Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09979C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 18:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDKSth (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDKStg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 14:49:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC143ED
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 11:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4727C62335
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 18:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13BCC433EF;
        Tue, 11 Apr 2023 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681238974;
        bh=SMxgYo13aRU75zBXszrMPDF2tnLZS1BvBgsrQweQiMk=;
        h=Date:From:To:Cc:Subject:From;
        b=T6Q3Fk+YHDvGLLfHedFh2MdZqxeGsXsRL7mmEpojJK+jkfwq8UdyMZjAGT4RSzP63
         jhMkrqpn+mRfj7x8EDOXG1/suwDsIzcHyqVq2MO3dboBosb0ohZAsl0zBeNhODh6mA
         X05Y2Gq/64MqLaz/enEoj6BgCcU9IExalJQMWMOmswgd3E31b67F5LeEmnEb2Yssbn
         RQzvIevX3afTgrMtO+MI5wcLsBnw15vtqOtDtO1YUhaKA8ex+qVRyLZVrL009Pqsuc
         XhDKRAM1k8rxVsBS+//VgBS2s1XPTpd22D7yOiL1jHgNJor4VBDCI0/pzlXieopwBR
         HfRkjXgrhsr7Q==
Date:   Tue, 11 Apr 2023 11:49:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: _{attr,data}_map_shared should take ILOCK_EXCL until
 iread_extents is completely done
Message-ID: <20230411184934.GK360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While fuzzing the data fork extent count on a btree-format directory
with xfs/375, I observed the following (excerpted) splat:

XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
------------[ cut here ]------------
WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The cause of this is a race condition in xfs_ilock_data_map_shared,
which performs an unlocked access to the data fork to guess which lock
mode it needs:

Thread 0                          Thread 1

xfs_need_iread_extents
<observe no iext tree>
xfs_ilock(..., ILOCK_EXCL)
xfs_iread_extents
<observe no iext tree>
<check ILOCK_EXCL>
<load bmbt extents into iext>
<notice iext size doesn't
 match nextents>
                                  xfs_need_iread_extents
                                  <observe iext tree>
                                  xfs_ilock(..., ILOCK_SHARED)
<tear down iext tree>
xfs_iunlock(..., ILOCK_EXCL)
                                  xfs_iread_extents
                                  <observe no iext tree>
                                  <check ILOCK_EXCL>
                                  *BOOM*

Fix this race by adding a flag to the xfs_ifork structure to indicate
that we have not yet read in the extent records and changing the
predicate to look at the flag state, not if_height.  The memory barrier
ensures that the flag will not be set until the very end of the
function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: use smp_store_release per reviewer comments
---
 fs/xfs/libxfs/xfs_bmap.c       |    6 ++++++
 fs/xfs/libxfs/xfs_inode_fork.c |   16 +++++++++++++++-
 fs/xfs/libxfs/xfs_inode_fork.h |    6 ++++--
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 34de6e6898c4..f11ef331e5a4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1171,6 +1171,12 @@ xfs_iread_extents(
 		goto out;
 	}
 	ASSERT(ir.loaded == xfs_iext_count(ifp));
+	/*
+	 * Use release semantics so that we can use acquire semantics in
+	 * xfs_need_iread_extents and be guaranteed to see a valid mapping tree
+	 * after that load.
+	 */
+	smp_store_release(&ifp->if_needextents, 0);
 	return 0;
 out:
 	xfs_iext_destroy(ifp);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 6b21760184d9..1bbe5ea3f00b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -226,10 +226,15 @@ xfs_iformat_data_fork(
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
-	 * depend on it.
+	 * depend on it.  Use release semantics to set needextents /after/ we
+	 * set the format. This ensures that we can use acquire semantics on
+	 * needextents in xfs_need_iread_extents() and be guaranteed to see a
+	 * valid format value after that load.
 	 */
 	ip->i_df.if_format = dip->di_format;
 	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
+	smp_store_release(&ip->i_df.if_needextents,
+			   ip->i_df.if_format == XFS_DINODE_FMT_BTREE ? 1 : 0);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -282,8 +287,17 @@ xfs_ifork_init_attr(
 	enum xfs_dinode_fmt	format,
 	xfs_extnum_t		nextents)
 {
+	/*
+	 * Initialize the extent count early, as the per-format routines may
+	 * depend on it.  Use release semantics to set needextents /after/ we
+	 * set the format. This ensures that we can use acquire semantics on
+	 * needextents in xfs_need_iread_extents() and be guaranteed to see a
+	 * valid format value after that load.
+	 */
 	ip->i_af.if_format = format;
 	ip->i_af.if_nextents = nextents;
+	smp_store_release(&ip->i_af.if_needextents,
+			   ip->i_af.if_format == XFS_DINODE_FMT_BTREE ? 1 : 0);
 }
 
 void
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index d3943d6ad0b9..96d307784c85 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -24,6 +24,7 @@ struct xfs_ifork {
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
+	uint8_t			if_needextents;	/* extents have not been read */
 };
 
 /*
@@ -260,9 +261,10 @@ int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
 
 /* returns true if the fork has extents but they are not read in yet. */
-static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
+static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)
 {
-	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_height == 0;
+	/* see xfs_iformat_{data,attr}_fork() for needextents semantics */
+	return smp_load_acquire(&ifp->if_needextents) != 0;
 }
 
 #endif	/* __XFS_INODE_FORK_H__ */
