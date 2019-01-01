Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Dlg6173225
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx40t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:05 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012H4ie004315
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:04 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012H4TM024362
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:04 GMT
Subject: [PATCH 02/12] xfs: refactor the predicate part of xfs_free_eofblocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:03 -0800
Message-ID: <154630902321.16693.17215403042253916619.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the part of _free_eofblocks that decides if it's really going
to truncate post-EOF blocks into a separate helper function.  The
upcoming deferred inode inactivation patch requires us to be able to
decide this prior to actual inactivation.  No functionality changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |  101 ++++++++++++++++++++----------------------------
 fs/xfs/xfs_inode.c     |   32 +++++++++++++++
 fs/xfs/xfs_inode.h     |    1 
 3 files changed, 75 insertions(+), 59 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1ee8c5539fa4..aa7f7fe241ec 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -781,78 +781,61 @@ xfs_free_eofblocks(
 	struct xfs_inode	*ip)
 {
 	struct xfs_trans	*tp;
-	int			error;
-	xfs_fileoff_t		end_fsb;
-	xfs_fileoff_t		last_fsb;
-	xfs_filblks_t		map_len;
-	int			nimaps;
-	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
 
 	/*
-	 * Figure out if there are any blocks beyond the end
-	 * of the file.  If not, then there is nothing to do.
+	 * If there are blocks after the end of file, truncate the file to its
+	 * current size to free them up.
 	 */
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
-	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (last_fsb <= end_fsb)
+	if (!xfs_inode_has_posteof_blocks(ip))
 		return 0;
-	map_len = last_fsb - end_fsb;
-
-	nimaps = 1;
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	/*
-	 * If there are blocks after the end of file, truncate the file to its
-	 * current size to free them up.
+	 * Attach the dquots to the inode up front.
 	 */
-	if (!error && (nimaps != 0) &&
-	    (imap.br_startblock != HOLESTARTBLOCK ||
-	     ip->i_delayed_blks)) {
-		/*
-		 * Attach the dquots to the inode up front.
-		 */
-		error = xfs_qm_dqattach(ip);
-		if (error)
-			return error;
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
 
-		/* wait on dio to ensure i_size has settled */
-		inode_dio_wait(VFS_I(ip));
+	/* wait on dio to ensure i_size has settled */
+	inode_dio_wait(VFS_I(ip));
 
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
-				&tp);
-		if (error) {
-			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			return error;
-		}
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error) {
+		ASSERT(XFS_FORCED_SHUTDOWN(mp));
+		return error;
+	}
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
-		/*
-		 * Do not update the on-disk file size.  If we update the
-		 * on-disk file size and then the system crashes before the
-		 * contents of the file are flushed to disk then the files
-		 * may be full of holes (ie NULL files bug).
-		 */
-		error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
-					XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
-		if (error) {
-			/*
-			 * If we get an error at this point we simply don't
-			 * bother truncating the file.
-			 */
-			xfs_trans_cancel(tp);
-		} else {
-			error = xfs_trans_commit(tp);
-			if (!error)
-				xfs_inode_clear_eofblocks_tag(ip);
-		}
+	/*
+	 * Do not update the on-disk file size.  If we update the
+	 * on-disk file size and then the system crashes before the
+	 * contents of the file are flushed to disk then the files
+	 * may be full of holes (ie NULL files bug).
+	 */
+	error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
+				XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
+	if (error)
+		goto err_cancel;
 
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_unlock;
+
+	xfs_inode_clear_eofblocks_tag(ip);
+	goto out_unlock;
+
+err_cancel:
+	/*
+	 * If we get an error at this point we simply don't
+	 * bother truncating the file.
+	 */
+	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c8bf02be0003..662ee537ffb5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3568,3 +3568,35 @@ xfs_irele(
 	trace_xfs_irele(ip, _RET_IP_);
 	iput(VFS_I(ip));
 }
+
+/*
+ * Decide if this inode have post-EOF blocks.  The caller is responsible
+ * for knowing / caring about the PREALLOC/APPEND flags.
+ */
+bool
+xfs_inode_has_posteof_blocks(
+	struct xfs_inode	*ip)
+{
+	struct xfs_bmbt_irec	imap;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		end_fsb;
+	xfs_fileoff_t		last_fsb;
+	xfs_filblks_t		map_len;
+	int			nimaps;
+	int			error;
+
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
+	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
+	if (last_fsb <= end_fsb)
+		return false;
+	map_len = last_fsb - end_fsb;
+
+	nimaps = 1;
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	return !error && (nimaps != 0) &&
+	       (imap.br_startblock != HOLESTARTBLOCK ||
+	        ip->i_delayed_blks);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index be2014520155..02a938661ba8 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -499,5 +499,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
+bool xfs_inode_has_posteof_blocks(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_H__ */
