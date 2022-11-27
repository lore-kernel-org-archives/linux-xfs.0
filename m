Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4012C43217
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Nov 2022 18:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiK0Sge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Nov 2022 13:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiK0Sgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2022 13:36:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559FDE69
        for <linux-xfs@vger.kernel.org>; Sun, 27 Nov 2022 10:36:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A07AB80B2F
        for <linux-xfs@vger.kernel.org>; Sun, 27 Nov 2022 18:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B71C433C1;
        Sun, 27 Nov 2022 18:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669574189;
        bh=rDbh2u2nUggyGJK47vCsS92qdiIodm2yiz+73wnjqwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hWCojgDK3859Tj0RNvBdUnubdB9jYjzi+GttNo7NABIdAByuAMhkoPQZlIHQectF4
         vvNApPq3yqpXYLF1VjfGY4vePUW7crr/UbFQ18whcLE6SMezFt8jU1jRTSd64AlsUY
         m55Xy3/LE3LjOmojexHjWqC8kNZrvjbB4ptnHlQTYjN5EWpZOhSbgw+94mjXve304P
         xzeH53URbEakmMB3k2hCsgzA+zD4INE+I6cA+umjQ5euXcASfgh84R9awhm5UTuUts
         qdOl3pxnscFdHYcmjR2xQsLjJl2Z9Ou8/0Ju6kjzQUZH+smqR/uERYjkZsXGkch5oF
         1B3TVDYUhrRQA==
Date:   Sun, 27 Nov 2022 10:36:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/3] xfs: attach dquots to inode before reading data/cow fork
 mappings
Message-ID: <Y4OuLTwPVdiHMBGi@magnolia>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166930915825.2061853.2470510849612284907.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I've been running near-continuous integration testing of online fsck,
and I've noticed that once a day, one of the ARM VMs will fail the test
with out of order records in the data fork.

xfs/804 races fsstress with online scrub (aka scan but do not change
anything), so I think this might be a bug in the core xfs code.  This
also only seems to trigger if one runs the test for more than ~6 minutes
via TIME_FACTOR=13 or something.
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf

I added a debugging patch to the kernel to check the data fork extents
after taking the ILOCK, before dropping ILOCK, and before and after each
bmapping operation.  So far I've narrowed it down to the delalloc code
inserting a record in the wrong place in the iext tree:

xfs_bmap_add_extent_hole_delay, near line 2691:

	case 0:
		/*
		 * New allocation is not contiguous with another
		 * delayed allocation.
		 * Insert a new entry.
		 */
		oldlen = newlen = 0;
		xfs_iunlock_check_datafork(ip);		<-- ok here
		xfs_iext_insert(ip, icur, new, state);
		xfs_iunlock_check_datafork(ip);		<-- bad here
		break;
	}

I recorded the state of the data fork mappings and iext cursor state
when a corrupt data fork is detected immediately after the
xfs_bmap_add_extent_hole_delay call in xfs_bmapi_reserve_delalloc:

ino 0x140bb3 func xfs_bmapi_reserve_delalloc line 4164 data fork:
    ino 0x140bb3 nr 0x0 nr_real 0x0 offset 0xb9 blockcount 0x1f startblock 0x935de2 state 1
    ino 0x140bb3 nr 0x1 nr_real 0x1 offset 0xe6 blockcount 0xa startblock 0xffffffffe0007 state 0
    ino 0x140bb3 nr 0x2 nr_real 0x1 offset 0xd8 blockcount 0xe startblock 0x935e01 state 0

Here we see that a delalloc extent was inserted into the wrong position
in the iext leaf, same as all the other times.  The extra trace data I
collected are as follows:

ino 0x140bb3 fork 0 oldoff 0xe6 oldlen 0x4 oldprealloc 0x6 isize 0xe6000
    ino 0x140bb3 oldgotoff 0xea oldgotstart 0xfffffffffffffffe oldgotcount 0x0 oldgotstate 0
    ino 0x140bb3 crapgotoff 0x0 crapgotstart 0x0 crapgotcount 0x0 crapgotstate 0
    ino 0x140bb3 freshgotoff 0xd8 freshgotstart 0x935e01 freshgotcount 0xe freshgotstate 0
    ino 0x140bb3 nowgotoff 0xe6 nowgotstart 0xffffffffe0007 nowgotcount 0xa nowgotstate 0
    ino 0x140bb3 oldicurpos 1 oldleafnr 2 oldleaf 0xfffffc00f0609a00
    ino 0x140bb3 crapicurpos 2 crapleafnr 2 crapleaf 0xfffffc00f0609a00
    ino 0x140bb3 freshicurpos 1 freshleafnr 2 freshleaf 0xfffffc00f0609a00
    ino 0x140bb3 newicurpos 1 newleafnr 3 newleaf 0xfffffc00f0609a00

The first line shows that xfs_bmapi_reserve_delalloc was called with
whichfork=XFS_DATA_FORK, off=0xe6, len=0x4, prealloc=6.

The second line ("oldgot") shows the contents of @got at the beginning
of the call, which are the results of the first iext lookup in
xfs_buffered_write_iomap_begin.

Line 3 ("crapgot") is the result of duplicating the cursor at the start
of the body of xfs_bmapi_reserve_delalloc and performing a fresh lookup
at @off.

Line 4 ("freshgot") is the result of a new xfs_iext_get_extent right
before the call to xfs_bmap_add_extent_hole_delay.  Totally garbage.

Line 5 ("nowgot") is contents of @got after the
xfs_bmap_add_extent_hole_delay call.

Line 6 is the contents of @icur at the beginning fo the call.  Lines 7-9
are the contents of the iext cursors at the point where the block
mappings were sampled.

I think @oldgot is a HOLESTARTBLOCK extent because the first lookup
didn't find anything, so we filled in imap with "fake hole until the
end".  At the time of the first lookup, I suspect that there's only one
32-block unwritten extent in the mapping (hence oldicurpos==1) but by
the time we get to recording crapgot, crapicurpos==2.

Dave then added:

Ok, that's much simpler to reason about, and implies the smoke is
coming from xfs_buffered_write_iomap_begin() or
xfs_bmapi_reserve_delalloc(). I suspect the former - it does a lot
of stuff with the ILOCK_EXCL held.....

.... including calling xfs_qm_dqattach_locked().

xfs_buffered_write_iomap_begin
  ILOCK_EXCL
  look up icur
  xfs_qm_dqattach_locked
    xfs_qm_dqattach_one
      xfs_qm_dqget_inode
        dquot cache miss
        xfs_iunlock(ip, XFS_ILOCK_EXCL);
        error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
        xfs_ilock(ip, XFS_ILOCK_EXCL);
  ....
  xfs_bmapi_reserve_delalloc(icur)

Yup, that's what is letting the magic smoke out -
xfs_qm_dqattach_locked() can cycle the ILOCK. If that happens, we
can pass a stale icur to xfs_bmapi_reserve_delalloc() and it all
goes downhill from there.

So.  Fix this by moving the dqattach_locked call up, and add a comment
about how we must attach the dquots *before* sampling the data/cow fork
contents.

Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1bdd7afc1010..d903f0586490 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -984,6 +984,14 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * Attach dquots before we access the data/cow fork mappings, because
+	 * this function can cycle the ILOCK.
+	 */
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error)
+		goto out_unlock;
+
 	/*
 	 * Search the data fork first to look up our source mapping.  We
 	 * always need the data fork map, as we have to return it to the
@@ -1071,10 +1079,6 @@ xfs_buffered_write_iomap_begin(
 			allocfork = XFS_COW_FORK;
 	}
 
-	error = xfs_qm_dqattach_locked(ip, false);
-	if (error)
-		goto out_unlock;
-
 	if (eof && offset + count > XFS_ISIZE(ip)) {
 		/*
 		 * Determine the initial size of the preallocation.
