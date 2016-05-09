Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFB8D7CD3
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 03:48:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 88F848F8037
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 01:48:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yoVoCUVwwnzfXbU5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 01:48:21 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/15] xfs: split xfs_free_file_space in manageable pieces
Date: Mon,  9 May 2016 10:47:17 +0200
Message-Id: <1462783638-4968-15-git-send-email-hch@lst.de>
In-Reply-To: <1462783638-4968-1-git-send-email-hch@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: rpeterso@redhat.com, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 252 +++++++++++++++++++++++++++----------------------
 1 file changed, 137 insertions(+), 115 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3246ebc..5d030b0 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1191,30 +1191,132 @@ xfs_zero_remaining_bytes(
 	return error;
 }
 
+static int
+xfs_unmap_extent(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		startoffset_fsb,
+	xfs_filblks_t		len_fsb,
+	int			*done)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		firstfsb;
+	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	if (error) {
+		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot, ip->i_gdquot,
+			ip->i_pdquot, resblks, 0, XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out_trans_cancel;
+
+	xfs_trans_ijoin(tp, ip, 0);
+
+	xfs_bmap_init(&free_list, &firstfsb);
+	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
+			&free_list, done);
+	if (error)
+		goto out_bmap_cancel;
+
+	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	if (error)
+		goto out_bmap_cancel;
+
+	error = xfs_trans_commit(tp);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+
+out_bmap_cancel:
+	xfs_bmap_cancel(&free_list);
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	goto out_unlock;
+}
+
+static int
+xfs_adjust_extent_unmap_boundaries(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		*startoffset_fsb,
+	xfs_fileoff_t		*endoffset_fsb)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	imap;
+	int			nimap, error;
+	xfs_extlen_t		mod = 0;
+
+	nimap = 1;
+	error = xfs_bmapi_read(ip, *startoffset_fsb, 1, &imap, &nimap, 0);
+	if (error)
+		return error;
+
+	if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
+		xfs_daddr_t	block;
+
+		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+		block = imap.br_startblock;
+		mod = do_div(block, mp->m_sb.sb_rextsize);
+		if (mod)
+			*startoffset_fsb += mp->m_sb.sb_rextsize - mod;
+	}
+
+	nimap = 1;
+	error = xfs_bmapi_read(ip, *endoffset_fsb - 1, 1, &imap, &nimap, 0);
+	if (error)
+		return error;
+
+	if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
+		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+		mod++;
+		if (mod && mod != mp->m_sb.sb_rextsize)
+			*endoffset_fsb -= mod;
+	}
+
+	return 0;
+}
+
+static int
+xfs_flush_unmap_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	xfs_off_t		rounding, start, end;
+	int			error;
+
+	/* wait for the completion of any pending DIOs */
+	inode_dio_wait(inode);
+
+	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
+	start = round_down(offset, rounding);
+	end = round_up(offset + len, rounding) - 1;
+
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+	truncate_pagecache_range(inode, start, end);
+	return 0;
+}
+
 int
 xfs_free_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
-	int			done;
-	xfs_fileoff_t		endoffset_fsb;
-	int			error;
-	xfs_fsblock_t		firstfsb;
-	xfs_bmap_free_t		free_list;
-	xfs_bmbt_irec_t		imap;
-	xfs_off_t		ioffset;
-	xfs_off_t		iendoffset;
-	xfs_extlen_t		mod=0;
-	xfs_mount_t		*mp;
-	int			nimap;
-	uint			resblks;
-	xfs_off_t		rounding;
-	int			rt;
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		startoffset_fsb;
-	xfs_trans_t		*tp;
-
-	mp = ip->i_mount;
+	xfs_fileoff_t		endoffset_fsb;
+	int			done, error;
 
 	trace_xfs_free_file_space(ip);
 
@@ -1222,60 +1324,30 @@ xfs_free_file_space(
 	if (error)
 		return error;
 
-	error = 0;
 	if (len <= 0)	/* if nothing being freed */
-		return error;
-	rt = XFS_IS_REALTIME_INODE(ip);
-	startoffset_fsb	= XFS_B_TO_FSB(mp, offset);
-	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
-
-	/* wait for the completion of any pending DIOs */
-	inode_dio_wait(VFS_I(ip));
+		return 0;
 
-	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
-	ioffset = round_down(offset, rounding);
-	iendoffset = round_up(offset + len, rounding) - 1;
-	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping, ioffset,
-					     iendoffset);
+	error = xfs_flush_unmap_range(ip, offset, len);
 	if (error)
-		goto out;
-	truncate_pagecache_range(VFS_I(ip), ioffset, iendoffset);
+		return error;
+
+	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
+	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
 	/*
-	 * Need to zero the stuff we're not freeing, on disk.
-	 * If it's a realtime file & can't use unwritten extents then we
-	 * actually need to zero the extent edges.  Otherwise xfs_bunmapi
-	 * will take care of it for us.
+	 * Need to zero the stuff we're not freeing, on disk.  If it's a RT file
+	 * and we can't use unwritten extents then we actually need to ensure
+	 * to zero the whole extent, otherwise we just need to take of block
+	 * boundaries, and xfs_bunmapi will handle the rest.
 	 */
-	if (rt && !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
-		nimap = 1;
-		error = xfs_bmapi_read(ip, startoffset_fsb, 1,
-					&imap, &nimap, 0);
+	if (XFS_IS_REALTIME_INODE(ip) &&
+	    !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
+		error = xfs_adjust_extent_unmap_boundaries(ip, &startoffset_fsb,
+				&endoffset_fsb);
 		if (error)
-			goto out;
-		ASSERT(nimap == 0 || nimap == 1);
-		if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
-			xfs_daddr_t	block;
-
-			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-			block = imap.br_startblock;
-			mod = do_div(block, mp->m_sb.sb_rextsize);
-			if (mod)
-				startoffset_fsb += mp->m_sb.sb_rextsize - mod;
-		}
-		nimap = 1;
-		error = xfs_bmapi_read(ip, endoffset_fsb - 1, 1,
-					&imap, &nimap, 0);
-		if (error)
-			goto out;
-		ASSERT(nimap == 0 || nimap == 1);
-		if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
-			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-			mod++;
-			if (mod && (mod != mp->m_sb.sb_rextsize))
-				endoffset_fsb -= mod;
-		}
+			return error;
 	}
+
 	if ((done = (endoffset_fsb <= startoffset_fsb)))
 		/*
 		 * One contiguous piece to clear
@@ -1295,62 +1367,12 @@ xfs_free_file_space(
 				offset + len - 1);
 	}
 
-	/*
-	 * free file space until done or until there is an error
-	 */
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	while (!error && !done) {
-
-		/*
-		 * allocate and setup the transaction. Allow this
-		 * transaction to dip into the reserve blocks to ensure
-		 * the freeing of the space succeeds at ENOSPC.
-		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
-				&tp);
-		if (error) {
-			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
-			break;
-		}
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota(tp, mp,
-				ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
-				resblks, 0, XFS_QMOPT_RES_REGBLKS);
-		if (error)
-			goto error1;
-
-		xfs_trans_ijoin(tp, ip, 0);
-
-		/*
-		 * issue the bunmapi() call to free the blocks
-		 */
-		xfs_bmap_init(&free_list, &firstfsb);
-		error = xfs_bunmapi(tp, ip, startoffset_fsb,
-				  endoffset_fsb - startoffset_fsb,
-				  0, 2, &firstfsb, &free_list, &done);
-		if (error)
-			goto error0;
-
-		/*
-		 * complete the transaction
-		 */
-		error = xfs_bmap_finish(&tp, &free_list, NULL);
-		if (error)
-			goto error0;
-
-		error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		error = xfs_unmap_extent(ip, startoffset_fsb,
+				endoffset_fsb - startoffset_fsb, &done);
 	}
 
- out:
 	return error;
-
- error0:
-	xfs_bmap_cancel(&free_list);
- error1:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	goto out;
 }
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
