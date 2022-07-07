Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B09CCA479
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 23:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbiGGXnx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiGGXnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:43:52 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 244F06B27F
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:43:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7072B62C900
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 09:43:49 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9b9w-00FoQD-Ct
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 09:43:48 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9b9w-004bQ1-B9
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 09:43:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/9 v4] xfs: introduce in-memory inode unlink log items
Date:   Fri,  8 Jul 2022 09:43:36 +1000
Message-Id: <20220707234345.1097095-1-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c76fb5
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=-X1awSgLeBP-J9I1e5kA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Folks,

V4 of the iunlink log item patchset. Note that this has been rebased
on the xfs-perag-conv-5.20 topic branch to avoid the horrible merge
conflicts the previous version of this patchset had with the perag
conversions. hence you'll need to pull this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-perag-conv-5.20

before applying this patchset to test it.

-Dave.

-----

Inode cluster buffer pinning by dirty inodes allows us to improve
dirty inode tracking efficiency in the log by logging the inode
cluster buffer as an ordered transaction. However, this brings with
it some new issues, namely the order in which we lock inode cluster
buffers. While the dirty buffer pinning doesn't currently result in
nested cluster buffer locking in xfs_trans_log_inode() and so there
are no current problems, future changes will need to nest cluster
buffer locking in this context.

That is, transactions that dirty and commit multiple inodes in a
transaction will now need to locking multiple inode cluster buffers
in each transaction (e.g. create, rename, etc). This introduces new
lock ordering constraints in these operations. It also introduces
lock ordering constraints between the AGI and inode cluster buffers
as a result of allocation/freeing being serialised by the AGI
buffer lock. And then there is unlinked inode list logging, which
currently has no fixed order of inode cluster buffer locking.

It's all a bit Wild West right now.

Locking pure inode modifications in order is relatively easy. We
don't actually need to attach and log the buffer to the transaction
until the last moment. We have all the inodes locked, so nothing
other than unlinked inode list modification can race with the
transaction modifying inodes. Hence we can safely move the
attachment of the inodes to the cluster buffer from when we first
dirty them in xfs_trans_log_inode to just before we commit the
transaction.

At this point, all the inodes that have been dirtied in the
transaction have already been locked, modified, logged and attached
to the transaction. Hence if we add a hook into xfs_trans_commit()
to run a "precommit" operation on these log items, we can use this
operation to attach the inodes to the cluster buffer at commit time
instead of in xfs_trans_log_inode().

This, by itself, doesn't solve the lock ordering problem. What it
does do, however, is give us a place where we can -order- all the
dirty items in the transaction list. Hence before we call the
precommit operation on each log item, we sort them. This allows us
to sort all the inode items so that the pre-commit functions that
locks and logs the cluster buffers are run in a deterministic order.
This solves the lock order problem for pure inode modifications.

The unlinked inode list buffer locking is more complex. The unlinked
list is unordered - we add to the tail, remove from where-ever the
inode is in the list. Hence we might need to lock two inode buffers
here (previous inode in list and the one being removed). While we
can order the locking of these buffers correctly within the confines
of the unlinked list, there may be other inodes that need buffer
locking in the same transaction. e.g. O_TMPFILE being linked into a
directory also modifies the directory inode.

Hence we need a mechanism for defering unlinked inode list updates
to the pre-commit operation where it can be sorted into the correct
order. We can do this by first observing that we serialise unlinked
list modifications by holding the AGI buffer lock. IOWs, the AGI is
going to be locked until the transaction commits any time we modify
the unlinked list. Hence it doesn't matter when in the unlink
transactions that we actually load, lock and modify the inode
cluster buffer.

IOWs, what we need is an unlinked inode log item to defer the inode
cluster buffer update to transaction commit time where it can be
ordered with all the other inode cluster operations. Essentially all
we need to do is record the inodes that need to have their unlinked
list pointer updated in a new log item that we attached to the
transaction.

This log item exists purely for the purpose of delaying the update
of the unlinked list pointer until the inode cluster buffer can be
locked in the correct order around the other inode cluster buffers.
It plays no part in the actual commit, and there's no change to
anything that is written to the log. i.e. the inode cluster buffers
still have to be fully logged here (not just ordered) as log
recovery depedends on this to replay mods to the unlinked inode
list.

To make this unlinked inode list processing simpler and easier to
implement as a log item, we need to change the way we track the
unlinked list in memory. Starting from the observation that an inode
on the unlinked list is pinned in memory by the VFS, we can use the
xfs_inode itself to track the unlinked list. To do this efficiently,
we want the unlinked list to be a double linked list. The problem
here is that we need a list per AGI unlinked list, and there are 64
of these per AGI. The approach taken in this patchset is to shadow
the AGI unlinked list heads in the perag, and link inodes by agino,
hence requiring only 8 extra bytes per inode to track this state.

We can then use the agino pointers for lockless inode cache lookups
to retreive the inode. The aginos in the inode are modified only
under the AGI lock, just like the cluster buffer pointers, so we
don't need any extra locking here.  The i_next_unlinked field tracks
the on-disk value of the unlinked list, and the i_prev_unlinked is a
purely in-memory pointer that enables us to efficiently remove
inodes from the middle of the list.

This results in moving a lot of the unlink modification work into
the precommit operations on the unlink log item. tracking all the
unlinked inodes in the inodes themselves also gets rid of the
unlinked list reference hash table that is used to track this back
pointer relationship. This greatly simplifies the the unlinked list
modification code, and removes memory allocations in this hot path
to track back pointers. This, overall, slightly reduces the CPU
overhead of the unlink path.

The result of this log item means that we move all the actual
manipulation of objects to be logged out of the iunlink path and
into the iunlink item. This allows for future optimisation of this
mechanism without needing changes to high level unlink path, as
well as making the unlink lock ordering predictable and synchronised
with other operations that may require inode cluster locking.

Changelog:

Version 4:
- rebase on 5.19-rc2 + xfs-perag-conv-5.20 as the changes to AGI interfaces
  cause complex merge conflicts that are non-trivial to resolve correctly.
- fix typos in commit messages
- fix random whitespace damage
- clean up log recovery changes to avoid passing both mp and pag around
- clean up error handling for xfs_iunlink_lookup
- remove unused tracepoints
- remove stale references to potential dquot modifications

Version 3:
- https://lore.kernel.org/linux-xfs/20220627004336.217366-1-david@fromorbit.com/
- rebase on 5.19-rc2
- Note: has significant, non-trivial merge conflicts with xfs-perag-conv-5.20.
  Should probably be rebased on that branch to avoid these. Need to know what
  order these branches are going to get merged first.

Version 2:
- unpublished
- rebase on 5.15-rc2 + xlog-intent-whiteouts
- reverts changes made in V1 that moved to a list_head based double linked list.
  This requires on-disk format changes to allow the AGI to use just a single
  bucket and so is not generically applicable to all XFS filesystem formats.
  This version goes back to using prev/next agino values and radix tree lookups
  as the original RFC used.

Version 1:
- https://lore.kernel.org/linux-xfs/20200812092556.2567285-1-david@fromorbit.com/
- split up into many smaller patches
- includes Xiang's single unlinked list bucket modification
- uses a list_head for the in memory double unlinked inode list
  rather than aginos and lockless inode lookups
- much simpler as it doesn't need to look up inodes from agino
  values
- iunlink log item changed to take an xfs_inode pointer rather than
  an imap and agino values
- a handful of small cleanups that breaking up into small patches
  allowed.

[RFC]
- https://lore.kernel.org/linux-xfs/20200623095015.1934171-1-david@fromorbit.com/

