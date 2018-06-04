Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbeFDTRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 15:17:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54JFs9k147054
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 19:17:33 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2jbvypcxg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 19:17:32 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w54JHWYc001953
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 19:17:32 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54JHVS1016285
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 19:17:32 GMT
Date: Mon, 4 Jun 2018 12:17:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/4] xfs: explicitly pass buffer size to xfs_corruption_error
Message-ID: <20180604191730.GO7825@magnolia>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152812862079.2736.15381483104759513267.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Explicitly pass the buffer length to xfs_corruption_error() instead of
assuming XFS_CORRUPTION_DUMP_LEN so that we avoid dumping off the end
of the pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c  |    2 +-
 fs/xfs/libxfs/xfs_dir2_data.c |    5 +++--
 fs/xfs/libxfs/xfs_dir2_leaf.c |    3 ++-
 fs/xfs/libxfs/xfs_dir2_node.c |    3 ++-
 fs/xfs/xfs_attr_list.c        |    5 +++--
 fs/xfs/xfs_error.c            |    5 +++--
 fs/xfs/xfs_error.h            |    9 +++++----
 fs/xfs/xfs_log_recover.c      |   15 ++++++++++-----
 9 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 39c1013358ed..1427887a1974 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -306,7 +306,7 @@ xfs_da3_node_read(
 			break;
 		default:
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-					tp->t_mountp, info);
+					tp->t_mountp, info, sizeof(*info));
 			xfs_trans_brelse(tp, *bpp);
 			*bpp = NULL;
 			return -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2c16bb4f2155..c672846a0303 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -251,7 +251,8 @@ xfs_dir3_data_check(
 	if (!fa)
 		return;
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
-			bp->b_addr, __FILE__, __LINE__, fa);
+			bp->b_addr, BBTOB(bp->b_length), __FILE__, __LINE__,
+			fa);
 	ASSERT(0);
 }
 #endif
@@ -1157,7 +1158,7 @@ xfs_dir2_data_use_free(
 	return 0;
 corrupt:
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
-			hdr, __FILE__, __LINE__, fa);
+			hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9367f2a41b35..77240f4de0e0 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -81,7 +81,8 @@ xfs_dir3_leaf_check(
 	if (!fa)
 		return;
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
-			bp->b_addr, __FILE__, __LINE__, fa);
+			bp->b_addr, BBTOB(bp->b_length), __FILE__, __LINE__,
+			fa);
 	ASSERT(0);
 }
 #else
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 9df096cc3c37..a5e7d9bd7552 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -84,7 +84,8 @@ xfs_dir3_leaf_check(
 	if (!fa)
 		return;
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
-			bp->b_addr, __FILE__, __LINE__, fa);
+			bp->b_addr, BBTOB(bp->b_length), __FILE__, __LINE__,
+			fa);
 	ASSERT(0);
 }
 #else
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 3e59a348ea71..276465ed276e 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -139,7 +139,8 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 		    ((char *)sfe >= ((char *)sf + dp->i_afp->if_bytes)))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
-					     context->dp->i_mount, sfe);
+					     context->dp->i_mount, sfe,
+					     sizeof(*sfe));
 			kmem_free(sbuf);
 			return -EFSCORRUPTED;
 		}
@@ -241,7 +242,7 @@ xfs_attr_node_list_lookup(
 		if (magic != XFS_DA_NODE_MAGIC &&
 		    magic != XFS_DA3_NODE_MAGIC) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					node);
+					node, sizeof(*node));
 			goto out_corruptbuf;
 		}
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7975634cb8fe..fedb2730ea9b 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -334,13 +334,14 @@ xfs_corruption_error(
 	const char		*tag,
 	int			level,
 	struct xfs_mount	*mp,
-	void			*p,
+	void			*buf,
+	size_t			bufsize,
 	const char		*filename,
 	int			linenum,
 	xfs_failaddr_t		failaddr)
 {
 	if (level <= xfs_error_level)
-		xfs_hex_dump(p, XFS_CORRUPTION_DUMP_LEN);
+		xfs_hex_dump(buf, bufsize);
 	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index ce391349e78b..f8c3667790de 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -24,8 +24,9 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, void *p, const char *filename,
-			int linenum, xfs_failaddr_t failaddr);
+			struct xfs_mount *mp, void *buf, size_t bufsize,
+			const char *filename, int linenum,
+			xfs_failaddr_t failaddr);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
@@ -37,8 +38,8 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
-#define	XFS_CORRUPTION_ERROR(e, lvl, mp, mem)	\
-	xfs_corruption_error(e, lvl, mp, mem, \
+#define	XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	\
+	xfs_corruption_error(e, lvl, mp, buf, bufsize, \
 			     __FILE__, __LINE__, __return_address)
 
 #define XFS_ERRLEVEL_OFF	0
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 06a09cb948b5..750124b170e5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3115,7 +3115,8 @@ xlog_recover_inode_pass2(
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
-					 XFS_ERRLEVEL_LOW, mp, ldip);
+					 XFS_ERRLEVEL_LOW, mp, ldip,
+					 sizeof(*ldip));
 			xfs_alert(mp,
 		"%s: Bad regular inode log record, rec ptr "PTR_FMT", "
 		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
@@ -3128,7 +3129,8 @@ xlog_recover_inode_pass2(
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
 		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
-					     XFS_ERRLEVEL_LOW, mp, ldip);
+					     XFS_ERRLEVEL_LOW, mp, ldip,
+					     sizeof(*ldip));
 			xfs_alert(mp,
 		"%s: Bad dir inode log record, rec ptr "PTR_FMT", "
 		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
@@ -3139,7 +3141,8 @@ xlog_recover_inode_pass2(
 	}
 	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
-				     XFS_ERRLEVEL_LOW, mp, ldip);
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
 	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
@@ -3151,7 +3154,8 @@ xlog_recover_inode_pass2(
 	}
 	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
-				     XFS_ERRLEVEL_LOW, mp, ldip);
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
 	"dino bp "PTR_FMT", ino %Ld, forkoff 0x%x", __func__,
@@ -3162,7 +3166,8 @@ xlog_recover_inode_pass2(
 	isize = xfs_log_dinode_size(ldip->di_version);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
-				     XFS_ERRLEVEL_LOW, mp, ldip);
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
 		xfs_alert(mp,
 			"%s: Bad inode log record length %d, rec ptr "PTR_FMT,
 			__func__, item->ri_buf[1].i_len, item);
