Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B241C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E509B206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgHLJ0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:06 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:46692 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbgHLJ0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:06 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id BA129D5B99E
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:59 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1A-0003QH-RX
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1A-00AlsY-HI
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/13] xfs: in memory inode unlink log items
Date:   Wed, 12 Aug 2020 19:25:43 +1000
Message-Id: <20200812092556.2567285-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=FMKECLKVQPIEAlWgDmcA:9 a=J2jcBcsKP0q6s0ZF:21 a=kRC6IqSYkNWb13LV:21
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a cleaned up version of the original RFC I posted here:

https://lore.kernel.org/linux-xfs/20200623095015.1934171-1-david@fromorbit.com/

The original description is preserved below for quick reference,
I'll just walk though the changes in this version:

- rebased on current TOT and xfs/for-next
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

The patchset passes fstests for v5 filesystems - v4 filesytsems
testing is currently running, though I don't expect any new problems
there.

Code can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-iunlink-item-2

Comments, thoughts, testing, etc all welcome.

-Dave.

============

[Original RFC text]

Inode cluster buffer pinning by dirty inodes allows us to improve
dirty inode tracking efficiency in the log by logging the inode
cluster buffer as an ordered transaction. However, this brings with
it some new issues, namely the order in which we lock inode cluster
buffers.

That is, transactions that dirty and commit multiple inodes in a
transaction will now need to locking multiple inode cluster buffers
in each transaction (e.g. create, rename, etc). This introduces new 
lock ordering constraints in these operations. It also introduces
lock ordering constraints between the AGI and inode cluster buffers
as a result of allocation/freeing being serialised by the AGI
buffer lock. And then there is unlinked inode list logging, which
currently has no fixed order of inode cluster buffer locking.

It's a bit messy.

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
the unlinked list. Hence it doesn't matter when in the transaction
we actually load, lock and modify the inode cluster buffer.

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
we want the unlinked list to be a double linked list. The current
implementation takes the approach of minimising the memory footprint
of this list in case we don't want to burn 16 bytes of memory per
inode for a largely unused list head. [*]

We can get this down to 8 bytes per inode because the unlinked list
is per-ag, and hence we only need to store the agino portion of the
inode number as list pointers. We can then use these for lockless
inode cache lookups to retreive the inode. The aginos in the inode
are modified only under the AGI lock, just like the cluster buffer
pointers, so we don't need any extra locking here.  The
i_next_unlinked field tracks the on-disk value of the unlinked list,
and the i_prev_unlinked is a purely in-memory pointer that enables
us to efficiently remove inodes from the middle of the list.

IOWs, we burn a bit more CPU to resolve the unlinked list pointers
to save 8 bytes of memory per inode. If we decide that 8 bytes of
memory isn't a big code, we can convert this to a list_head and just
link the inodes directly to a unlinked list head in the perag.[**]

This gets rid of the entire unlinked list reference hash table that
is used to track this back pointer relationship, greatly simplifying
the unlinked list modification code.

Comments, flames, thoughts all welcome.

-Dave.

[*] An in-memory double linked list removes the need for keeping
lists short to minimise previous inode lookup overhead when removing
from the list. The current backref hash has this function, but it's
not obvious that it can do this and it's a kinda complex way of
implementing a double linked list.

Once we've removed the need for keeping the lists short, we no
longer need the on-disk hash for unlinked lists, so we can put all
the inodes in a single list....

[**] A single unlinked list in the per-ag then leads to a mutex in
the per-ag to protect the list, removing the AGI lock from needing
to be held to modify the unlinked list unless the head of the list
is being modified. We can then add to the tail of the list instead
of the head, hence largely removing the AGI from the unlinked list
processing entirely when there is more than one inode on the
unlinked list.[***]

This is another advantage of moving to single unlinked list - we are
much more likely to have multiple inodes on a single unlinked list
than when they are spread across 64 lists. Hence we are more likely
to be able to elide AGI locking for the unlinked list modifications
the more pressure we put on the unlinked list...

[***] Taking the AGI out of the unlinked list processing means the
only thing it "protects" is the contents of the AGI itself. This is
basically updating accounting and tracking btree root pointers. We
could add another in-memory log item for AGI updates such that the
AGI only needs to be locked, updated and logged in the precommit
function, greatly reducing the time it spends locked for inode
unlink processing [*^4. This will improve performance of inode
alloc/freeing on AG constrained filessytems as we spend less time
serialising on the AGI lock.....

[*^4] This is how superblock updates work, except it's not by a
generic in-memory SB log item - the changes to accounting are stored
directly in the struct xfs_trans as deltas and then applied in
xfs_trans_commit() via xfs_trans_apply_sb_deltas() which locks,
applies and logs the superblock buffer. This could be converted to a
precommit operation, too. [*^5]

Note that this superblock locking is elided for the freespace and
inode accounting when lazy superblock updates are enabled. This
prevents the superblock buffer lock for transactional accounting
update from being a major global contention point.

[*^5] dquots also use a delta accounting structure hard coded into
the struct xfs_trans - the xfs_dquot_acct structure. This gets
allocated when dquot modifications are reserved, and then updated
with each quota modification that is made in the transaction.

Then, in xfs_trans_commit(), it calls xfs_trans_apply_dquot_deltas()
which then orders the locking of the dquots correct, reads, loads
and locks the dquots, modifies the in-memory on-disk dquots and logs
them. This could also be converted to pre-commit operations. [*^6]

[*^6] It should be obvious by now that the pattern of "pre-commit
processing" for "delayed object modification" is not a new idea.
It's been in the code for 25-odd years and copy-pasta'd through the
ages as needed. It's never been turned into a useful, formalised
infrastructure mechanism - that's what this patchset starts us down
the path of. It kinda reminds me of the btree infrastructure
abstraction I did years ago to get rid fo the the 15,000 lines of
copy-pastad btree code and set us on the path to the (relatively)
easy addition of more btrees....



Dave Chinner (12):
  xfs: xfs_iflock is no longer a completion
  xfs: add log item precommit operation
  xfs: factor the xfs_iunlink functions
  xfs: add unlink list pointers to xfs_inode
  xfs: replace iunlink backref lookups with list lookups
  xfs: mapping unlinked inodes is now redundant
  xfs: updating i_next_unlinked doesn't need to return old value
  xfs: validate the unlinked list pointer on update
  xfs: re-order AGI updates in unlink list updates
  xfs: combine iunlink inode update functions
  xfs: add in-memory iunlink log item
  xfs: reorder iunlink remove operation in xfs_ifree

Gao Xiang (1):
  xfs: arrange all unlinked inodes into one list

 fs/xfs/Makefile           |   1 +
 fs/xfs/xfs_error.c        |   2 -
 fs/xfs/xfs_icache.c       |  19 +-
 fs/xfs/xfs_inode.c        | 688 ++++++++------------------------------
 fs/xfs/xfs_inode.h        |  37 +-
 fs/xfs/xfs_inode_item.c   |  15 +-
 fs/xfs/xfs_inode_item.h   |   4 +-
 fs/xfs/xfs_iunlink_item.c | 168 ++++++++++
 fs/xfs/xfs_iunlink_item.h |  25 ++
 fs/xfs/xfs_log_recover.c  | 179 ++++++----
 fs/xfs/xfs_mount.c        |  17 +-
 fs/xfs/xfs_mount.h        |   1 +
 fs/xfs/xfs_super.c        |  20 +-
 fs/xfs/xfs_trace.h        |   1 -
 fs/xfs/xfs_trans.c        |  91 +++++
 fs/xfs/xfs_trans.h        |   6 +-
 16 files changed, 587 insertions(+), 687 deletions(-)
 create mode 100644 fs/xfs/xfs_iunlink_item.c
 create mode 100644 fs/xfs/xfs_iunlink_item.h

-- 
2.26.2.761.g0e0b3e54be

