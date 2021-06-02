Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E6AC47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89CCE613C0
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFBAyP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhFBAyP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEA7A61003;
        Wed,  2 Jun 2021 00:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595153;
        bh=4OTrjIDp2UDdB3ojq+KZIeaJqZLG8XVfmNeiOopzvl4=;
        h=Subject:From:To:Cc:Date:From;
        b=aFQXyd/gtmSqMMBrJG3pv3D44RHcfm9I0G/F3YhAG6pmfIV3qMSgnGHZvKn2+mY+S
         EQx7zJ3g/HqmmlkKswiAISi+M6htQfNQbqw18ttnOMDBy2q9vGbwBks50VCOICPGW2
         ajXyTsevxjeZTSnXFE1ttzQuw7hcocSaCHLiK8OcMjAdPQyaKI8eiUHKtzXDHkOzJB
         /jQ3a6h6cknB14kMimekEkCIKbYKCAWRVAb1e6TySBwLksWC6rRrQa/BEatRxjpPiV
         oJKbANWebmOpjbnqevVWQbkj9feepYyq2odQ48MwAeGkderQYYjqA7O/yEAEC/a23E
         zs1iloB6Qly0A==
Subject: [PATCHSET v5 00/14] xfs: clean up incore inode walk functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:52:32 -0700
Message-ID: <162259515220.662681.6750744293005850812.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This ambitious series aims to cleans up redundant inode walk code in
xfs_icache.c, hide implementation details of the quotaoff dquot release
code, and eliminates indirect function calls from incore inode walks.

The first thing it does is to move all the code that quotaoff calls to
release dquots from all incore inodes into xfs_icache.c.  Next, it
separates the goal of an inode walk from the actual radix tree tags that
may or may not be involved and drops the kludgy XFS_ICI_NO_TAG thing.
Finally, we split the speculative preallocation (blockgc) and quotaoff
dquot release code paths into separate functions so that we can keep the
implementations cohesive.

Christoph suggested last cycle that we 'simply' change quotaoff not to
allow deactivating quota entirely, but as these cleanups are to enable
one major change in behavior (deferred inode inactivation) I do not want
to add a second behavior change (quotaoff) as a dependency.

To be blunt: Additional cleanups are not in scope for this series.

Next, I made two observations about incore inode radix tree walks --
since there's a 1:1 mapping between the walk goal and the per-inode
processing function passed in, we can use the goal to make a direct call
to the processing function.  Furthermore, the only caller to supply a
nonzero iter_flags argument is quotaoff, and there's only one INEW flag.

From that observation, I concluded that it's quite possible to remove
two parameters from the xfs_inode_walk* function signatures -- the
iter_flags, and the execute function pointer.  The middle of the series
moves the INEW functionality into the one piece (quotaoff) that wants
it, and removes the indirect calls.

The final observation is that the inode reclaim walk loop is now almost
the same as xfs_inode_walk, so it's silly to maintain two copies.  Merge
the reclaim loop code into xfs_inode_walk.

Lastly, refactor the per-ag radix tagging functions since there's
duplicated code that can be consolidated.

This series is a prerequisite for the next two patchsets, since deferred
inode inactivation will add another inode radix tree tag and iterator
function to xfs_inode_walk.

v2: walk the vfs inode list when running quotaoff instead of the radix
    tree, then rework the (now completely internal) inode walk function
    to take the tag as the main parameter.
v3: merge the reclaim loop into xfs_inode_walk, then consolidate the
    radix tree tagging functions
v4: rebase to 5.13-rc4
v5: combine with the quotaoff patchset, reorder functions to minimize
    forward declarations, split inode walk goals from radix tree tags
    to reduce conceptual confusion

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-walk-cleanups-5.14
---
 fs/xfs/libxfs/xfs_sb.c   |    2 
 fs/xfs/libxfs/xfs_sb.h   |    4 
 fs/xfs/xfs_icache.c      |  803 +++++++++++++++++++++++++---------------------
 fs/xfs/xfs_icache.h      |   36 +-
 fs/xfs/xfs_inode.c       |   22 +
 fs/xfs/xfs_qm.h          |    1 
 fs/xfs/xfs_qm_syscalls.c |   54 ---
 fs/xfs/xfs_super.c       |    2 
 fs/xfs/xfs_trace.h       |    6 
 9 files changed, 467 insertions(+), 463 deletions(-)

