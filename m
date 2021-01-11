Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E55BC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28E722E03
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404046AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404061AbhAKXXz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:23:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E4D922D37;
        Mon, 11 Jan 2021 23:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407391;
        bh=QJ1vjUU8hSNBElVJHzrBgh2LOytQdHgIlpEAVGfWROs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NrmiC2vG4/WrcFUAM+7YLeDny/E6/skUmNPx5fCALB5AKU2jLoMal0IG+FdC14jq1
         bKfL27jeAVWsdZ5WFEnXwJMv2Hp6sqzpRq8teN0gt6HVpxj/sPhZ6PkYni6NTQqV2L
         i61XyRTrIWiY2M7jF5gdJFlx8w0bljn8pPdFFR95zkRhAnTqjfAFBGwYY9sv+7buVo
         ZGemwLT04NFyldud65xN1xY4iqc1RGi3hmy9pEIm/Wbk6JewuIh3TaGPiVmJEJXbmq
         ok3J2A0MBWlBsHWOvymIn3qULxsKPEIV9kC9WQIk8rlCN6Z5hfOdaBXMmxMpl6S8U8
         JzWaFt8TEgaeg==
Subject: [PATCH 6/6] xfs: flush speculative space allocations when we run out
 of space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:11 -0800
Message-ID: <161040739114.1582114.73792904328533145.stgit@magnolia>
In-Reply-To: <161040735389.1582114.15084485390769234805.stgit@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a fs modification (creation, file write, reflink, etc.) is unable to
reserve enough space to handle the modification, try clearing whatever
space the filesystem might have been hanging onto in the hopes of
speeding up the filesystem.  The flushing behavior will become
particularly important when we add deferred inode inactivation because
that will increase the amount of space that isn't actively tied to user
data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   13 ++++++++++++-
 fs/xfs/xfs_file.c      |   11 ++++-------
 fs/xfs/xfs_icache.c    |   37 ++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.h    |    1 +
 fs/xfs/xfs_inode.c     |   12 ++++++++++--
 fs/xfs/xfs_iomap.c     |   13 +++++++++++++
 fs/xfs/xfs_reflink.c   |   23 +++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    1 +
 8 files changed, 98 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 437fdc8a8fbd..602011f06fb6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -807,7 +807,18 @@ xfs_alloc_file_space(
 retry:
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
-
+		/*
+		 * We weren't able to reserve enough space to handle fallocate.
+		 * Flush any disk space that was being held in the hopes of
+		 * speeding up the filesystem.  We hold the IOLOCK so we cannot
+		 * do a synchronous scan.
+		 */
+		if (error == -ENOSPC && !cleared_space) {
+			cleared_space = true;
+			error = xfs_inode_free_blocks(ip->i_mount, false);
+			if (!error)
+				goto retry;
+		}
 		/*
 		 * Check for running out of space
 		 */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 136fb5972acd..1333c65dd2b5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -691,15 +691,12 @@ xfs_file_buffered_aio_write(
 			goto write_retry;
 		iolock = 0;
 	} else if (ret == -ENOSPC && !cleared_space) {
-		struct xfs_eofblocks eofb = {0};
-
-		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
-
 		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		cleared_space = true;
+		ret = xfs_inode_free_blocks(ip->i_mount, true);
+		if (ret)
+			return ret;
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d6f7c3e85805..c3867b25e362 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -950,6 +950,21 @@ xfs_queue_eofblocks(
 	rcu_read_unlock();
 }
 
+/* Scan all incore inodes for block preallocations that we can remove. */
+static inline int
+xfs_blockgc_scan(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	int			error;
+
+	error = xfs_icache_free_eofblocks(mp, eofb);
+	if (error && error != -EAGAIN)
+		return error;
+
+	return xfs_icache_free_cowblocks(mp, eofb);
+}
+
 void
 xfs_eofblocks_worker(
 	struct work_struct *work)
@@ -1470,9 +1485,25 @@ xfs_inode_free_quota_blocks(
 
 	trace_xfs_inode_free_quota_blocks(ip->i_mount, &eofb, _RET_IP_);
 
-	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
-	return true;
+	return xfs_blockgc_scan(ip->i_mount, &eofb) == 0;
+}
+
+/*
+ * Try to free space in the filesystem by purging eofblocks and cowblocks.
+ */
+int
+xfs_inode_free_blocks(
+	struct xfs_mount	*mp,
+	bool			sync)
+{
+	struct xfs_eofblocks	eofb = {0};
+
+	if (sync)
+		eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
+
+	trace_xfs_inode_free_blocks(mp, &eofb, _RET_IP_);
+
+	return xfs_blockgc_scan(mp, &eofb);
 }
 
 static inline unsigned long
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 88bbbc9f00f8..2f230d273a54 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -50,6 +50,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
 bool xfs_inode_free_quota_blocks(struct xfs_inode *ip, bool sync);
+int xfs_inode_free_blocks(struct xfs_mount *mp, bool sync);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 09d97cf81f6d..0e6cc33a33ad 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1025,10 +1025,18 @@ xfs_create(
 	 */
 retry:
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
+	/*
+	 * We weren't able to reserve enough space to add the inode.  Flush
+	 * any disk space that was being held in the hopes of speeding up the
+	 * filesystem.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+		error = xfs_inode_free_blocks(mp, true);
+		if (!error)
+			goto retry;
 	}
 	if (error)
 		goto out_release_inode;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d83ee1406cea..cf651c70f22c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -243,6 +243,19 @@ xfs_iomap_write_direct(
 retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
 			tflags, &tp);
+	/*
+	 * We weren't able to reserve enough space for the direct write.  Flush
+	 * any disk space that was being held in the hopes of speeding up the
+	 * filesystem.  Historically, we expected callers to have preallocated
+	 * all the space before a direct write, but this is not an absolute
+	 * requirement.  We still hold the IOLOCK so we cannot do a sync scan.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
+		error = xfs_inode_free_blocks(ip->i_mount, false);
+		if (!error)
+			goto retry;
+	}
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7be3cd3ee9bf..749d425603ca 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -379,6 +379,18 @@ xfs_reflink_allocate_cow(
 	xfs_iunlock(ip, *lockmode);
 retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	/*
+	 * We weren't able to reserve enough space to handle copy on write.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.  We potentially hold the IOLOCK so we cannot do a
+	 * synchronous scan.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
+		error = xfs_inode_free_blocks(ip->i_mount, false);
+		if (!error)
+			goto retry;
+	}
 	*lockmode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, *lockmode);
 
@@ -1028,6 +1040,17 @@ xfs_reflink_remap_extent(
 	/* Start a rolling transaction to switch the mappings */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	/*
+	 * We weren't able to reserve enough space for the remapping.  Flush
+	 * any disk space that was being held in the hopes of speeding up the
+	 * filesystem.  We still hold the IOLOCK so we cannot do a sync scan.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
+		error = xfs_inode_free_blocks(mp, false);
+		if (!error)
+			goto retry;
+	}
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7b0dbbf6f4cc..9a29a5e18711 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3927,6 +3927,7 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
 	TP_ARGS(mp, eofb, caller_ip))
 DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
 DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_quota_blocks);
+DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_blocks);
 
 #endif /* _TRACE_XFS_H */
 

