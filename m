Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFCEC432C3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5538722DFA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390779AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404063AbhAKXXz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:23:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 042C622D2C;
        Mon, 11 Jan 2021 23:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407385;
        bh=tSe5VXVOSHBkyk3nAsf0UKHR+YdYs/XwzKhR7O51aWE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k9tstssArSzWUvstyArja/k/PE350gnisiUzz9/LAa4otO0bqBAlb6o5QyGZq1aAB
         rx8rkgPxibn7RM/5xCG3hHiVYlMLw4i9tfQL9ZqERjnnFfeIdyV034qFMmEizStoi7
         T1n+2YxTGis6mBovUg9U6tusd9chwzMEbd5yTWQev+HhDV3uKlnFilvey6HPyUCdqy
         XEpNPPikDJXfFRze7sWvfIwo48r8ua5TxnC6QtZeSnv1k3cVqBzSw7hCByh+elXjhz
         U+ZIQ6ZA2Kkswo1NwYSw+6spTqZeGzjTjKi9AwZ5igNKMpIrYMj5vA68m9dcTgWk6i
         ZpHvvYGMKpQmQ==
Subject: [PATCH 5/6] xfs: flush speculative space allocations when we run out
 of quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:05 -0800
Message-ID: <161040738496.1582114.17998753962128996136.stgit@magnolia>
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
reserve enough quota to handle the modification, try clearing whatever
space the filesystem might have been hanging onto in the hopes of
speeding up the filesystem.  The flushing behavior will become
particularly important when we add deferred inode inactivation because
that will increase the amount of space that isn't actively tied to user
data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   16 ++++++++++++++++
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_icache.c    |    9 +++++++--
 fs/xfs/xfs_icache.h    |    2 +-
 fs/xfs/xfs_inode.c     |   17 +++++++++++++++++
 fs/xfs/xfs_ioctl.c     |    2 ++
 fs/xfs/xfs_iomap.c     |   20 +++++++++++++++++++-
 fs/xfs/xfs_reflink.c   |   40 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trace.c     |    1 +
 fs/xfs/xfs_trace.h     |   40 ++++++++++++++++++++++++++++++++++++++++
 10 files changed, 141 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7371a7f7c652..437fdc8a8fbd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -761,6 +761,7 @@ xfs_alloc_file_space(
 	 */
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
+		bool		cleared_space = false;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -803,6 +804,7 @@ xfs_alloc_file_space(
 		/*
 		 * Allocate and setup the transaction.
 		 */
+retry:
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
 
@@ -819,6 +821,20 @@ xfs_alloc_file_space(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
 						      0, quota_flag);
+		/*
+		 * We weren't able to reserve enough quota to handle fallocate.
+		 * Flush any disk space that was being held in the hopes of
+		 * speeding up the filesystem.  We hold the IOLOCK so we cannot
+		 * do a synchronous scan.
+		 */
+		if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+			xfs_trans_cancel(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			cleared_space = xfs_inode_free_quota_blocks(ip, false);
+			if (cleared_space)
+				goto retry;
+			return error;
+		}
 		if (error)
 			goto error1;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5d5cf25668b5..136fb5972acd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -686,7 +686,7 @@ xfs_file_buffered_aio_write(
 	 */
 	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		cleared_space = xfs_inode_free_quota_blocks(ip);
+		cleared_space = xfs_inode_free_quota_blocks(ip, true);
 		if (cleared_space)
 			goto write_retry;
 		iolock = 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 703d26d04e0f..d6f7c3e85805 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1423,7 +1423,8 @@ xfs_icache_free_eofblocks(
  */
 bool
 xfs_inode_free_quota_blocks(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	bool			sync)
 {
 	struct xfs_eofblocks	eofb = {0};
 	struct xfs_dquot	*dq;
@@ -1433,7 +1434,9 @@ xfs_inode_free_quota_blocks(
 	 * Run a sync scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION;
+	if (sync)
+		eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
 		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
@@ -1465,6 +1468,8 @@ xfs_inode_free_quota_blocks(
 	if (!do_work)
 		return false;
 
+	trace_xfs_inode_free_quota_blocks(ip->i_mount, &eofb, _RET_IP_);
+
 	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
 	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
 	return true;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index b94a94e9a7a6..88bbbc9f00f8 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -49,7 +49,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
-bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
+bool xfs_inode_free_quota_blocks(struct xfs_inode *ip, bool sync);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5dc41b10ebb..09d97cf81f6d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -990,6 +990,7 @@ xfs_create(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
+	bool			cleared_space = false;
 	uint			resblks;
 
 	trace_xfs_create(dp, name);
@@ -1022,6 +1023,7 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
+retry:
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
@@ -1039,6 +1041,21 @@ xfs_create(
 	 */
 	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
 						pdqp, resblks, 1, 0);
+	/*
+	 * We weren't able to reserve enough quota to handle adding the inode.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.
+	 */
+	if ((error == -EDQUOT || error == -ENOSPC) && !cleared_space) {
+		xfs_trans_cancel(tp);
+		if (unlock_dp_on_error)
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+		unlock_dp_on_error = false;
+		cleared_space = xfs_inode_free_quota_blocks(dp, true);
+		if (cleared_space)
+			goto retry;
+		goto out_release_inode;
+	}
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3fbd98f61ea5..97e5b192d559 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2348,6 +2348,8 @@ xfs_file_ioctl(
 		if (error)
 			return error;
 
+		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
+
 		sb_start_write(mp->m_super);
 		error = xfs_icache_free_eofblocks(mp, &keofb);
 		sb_end_write(mp->m_super);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7b9ff824e82d..d83ee1406cea 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -27,7 +27,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
-
+#include "xfs_icache.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -200,6 +200,7 @@ xfs_iomap_write_direct(
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
 	uint			tflags = 0;
+	bool			cleared_space = false;
 
 	ASSERT(count_fsb > 0);
 
@@ -239,6 +240,7 @@ xfs_iomap_write_direct(
 			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
 			tflags, &tp);
 	if (error)
@@ -247,6 +249,22 @@ xfs_iomap_write_direct(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
+	/*
+	 * We weren't able to reserve enough quota for the direct write.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.  Historically, we expected callers to have
+	 * preallocated all the space before a direct write, but this is not an
+	 * absolute requirement.  We still hold the IOLOCK so we cannot do a
+	 * sync scan.
+	 */
+	if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+		xfs_trans_cancel(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		cleared_space = xfs_inode_free_quota_blocks(ip, false);
+		if (cleared_space)
+			goto retry;
+		return error;
+	}
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..7be3cd3ee9bf 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -351,13 +351,14 @@ xfs_reflink_allocate_cow(
 	bool			convert_now)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
 	xfs_fileoff_t		offset_fsb = imap->br_startoff;
 	xfs_filblks_t		count_fsb = imap->br_blockcount;
-	struct xfs_trans	*tp;
-	int			nimaps, error = 0;
-	bool			found;
 	xfs_filblks_t		resaligned;
 	xfs_extlen_t		resblks = 0;
+	bool			found;
+	bool			cleared_space = false;
+	int			nimaps, error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (!ip->i_cowfp) {
@@ -376,6 +377,7 @@ xfs_reflink_allocate_cow(
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
 	xfs_iunlock(ip, *lockmode);
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	*lockmode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, *lockmode);
@@ -400,6 +402,23 @@ xfs_reflink_allocate_cow(
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
 			XFS_QMOPT_RES_REGBLKS);
+	/*
+	 * We weren't able to reserve enough quota to handle copy on write.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.  We potentially hold the IOLOCK so we cannot do a
+	 * synchronous scan.
+	 */
+	if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+		xfs_trans_cancel(tp);
+		xfs_iunlock(ip, *lockmode);
+		*lockmode = 0;
+		cleared_space = xfs_inode_free_quota_blocks(ip, false);
+		if (cleared_space)
+			goto retry;
+		*lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, *lockmode);
+		return error;
+	}
 	if (error)
 		goto out_trans_cancel;
 
@@ -1001,9 +1020,11 @@ xfs_reflink_remap_extent(
 	unsigned int		resblks;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	bool			cleared_space = false;
 	int			nimaps;
 	int			error;
 
+retry:
 	/* Start a rolling transaction to switch the mappings */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
@@ -1081,6 +1102,11 @@ xfs_reflink_remap_extent(
 	 * count.  This is suboptimal, but the VFS flushed the dest range
 	 * before we started.  That should have removed all the delalloc
 	 * reservations, but we code defensively.
+	 *
+	 * If we fail with ENOSPC or EDQUOT, we weren't able to reserve enough
+	 * quota for the remapping.  Flush any disk space that was being held
+	 * in the hopes of speeding up the filesystem.  We still hold the
+	 * IOLOCK so we cannot do a sync scan.
 	 */
 	qres = qdelta = 0;
 	if (smap_real || dmap_written)
@@ -1090,6 +1116,14 @@ xfs_reflink_remap_extent(
 	if (qres > 0) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
 				XFS_QMOPT_RES_REGBLKS);
+		if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
+			xfs_trans_cancel(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			cleared_space = xfs_inode_free_quota_blocks(ip, false);
+			if (cleared_space)
+				goto retry;
+			goto out;
+		}
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 120398a37c2a..9b8d703dc9fd 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -29,6 +29,7 @@
 #include "xfs_filestream.h"
 #include "xfs_fsmap.h"
 #include "xfs_btree_staging.h"
+#include "xfs_icache.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5a263ae3d4f0..7b0dbbf6f4cc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -37,6 +37,7 @@ struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
+struct xfs_eofblocks;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3888,6 +3889,45 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
 
+DECLARE_EVENT_CLASS(xfs_eofblocks_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, eofb, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(__u32, flags)
+		__field(uint32_t, uid)
+		__field(uint32_t, gid)
+		__field(prid_t, prid)
+		__field(__u64, min_file_size)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->flags = eofb->eof_flags;
+		__entry->uid = from_kuid(mp->m_super->s_user_ns, eofb->eof_uid);
+		__entry->gid = from_kgid(mp->m_super->s_user_ns, eofb->eof_gid);
+		__entry->prid = eofb->eof_prid;
+		__entry->min_file_size = eofb->eof_min_file_size;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->flags,
+		  __entry->uid,
+		  __entry->gid,
+		  __entry->prid,
+		  __entry->min_file_size,
+		  (char *)__entry->caller_ip)
+);
+#define DEFINE_EOFBLOCKS_EVENT(name)	\
+DEFINE_EVENT(xfs_eofblocks_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, eofb, caller_ip))
+DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
+DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_quota_blocks);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

