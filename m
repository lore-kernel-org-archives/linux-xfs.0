Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDDF27F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:34:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97392304039
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:34:37 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id j3Fs78bBf0lh3zA0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:34:35 -0800 (PST)
Subject: [PATCH 1/3] xfs: use named array initializers for log item dumping
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:34:31 -0800
Message-ID: <20160123003431.2338.77639.stgit@birch.djwong.org>
In-Reply-To: <20160123003425.2338.18133.stgit@birch.djwong.org>
References: <20160123003425.2338.18133.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Use named array initializers for the string arrays used to dump log
items, rather than depending on the order being maintained correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |  132 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 68 insertions(+), 64 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2aa187e..4758f06 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1989,77 +1989,81 @@ xlog_print_tic_res(
 	uint ophdr_spc = ticket->t_res_num_ophdrs * (uint)sizeof(xlog_op_header_t);
 
 	/* match with XLOG_REG_TYPE_* in xfs_log.h */
-	static char *res_type_str[XLOG_REG_TYPE_MAX] = {
-	    "bformat",
-	    "bchunk",
-	    "efi_format",
-	    "efd_format",
-	    "iformat",
-	    "icore",
-	    "iext",
-	    "ibroot",
-	    "ilocal",
-	    "iattr_ext",
-	    "iattr_broot",
-	    "iattr_local",
-	    "qformat",
-	    "dquot",
-	    "quotaoff",
-	    "LR header",
-	    "unmount",
-	    "commit",
-	    "trans header"
+#define REG_TYPE_STR(type, str)	[XLOG_REG_TYPE_##type] = str
+	static char *res_type_str[XLOG_REG_TYPE_MAX + 1] = {
+	    REG_TYPE_STR(BFORMAT, "bformat"),
+	    REG_TYPE_STR(BCHUNK, "bchunk"),
+	    REG_TYPE_STR(EFI_FORMAT, "efi_format"),
+	    REG_TYPE_STR(EFD_FORMAT, "efd_format"),
+	    REG_TYPE_STR(IFORMAT, "iformat"),
+	    REG_TYPE_STR(ICORE, "icore"),
+	    REG_TYPE_STR(IEXT, "iext"),
+	    REG_TYPE_STR(IBROOT, "ibroot"),
+	    REG_TYPE_STR(ILOCAL, "ilocal"),
+	    REG_TYPE_STR(IATTR_EXT, "iattr_ext"),
+	    REG_TYPE_STR(IATTR_BROOT, "iattr_broot"),
+	    REG_TYPE_STR(IATTR_LOCAL, "iattr_local"),
+	    REG_TYPE_STR(QFORMAT, "qformat"),
+	    REG_TYPE_STR(DQUOT, "dquot"),
+	    REG_TYPE_STR(QUOTAOFF, "quotaoff"),
+	    REG_TYPE_STR(LRHEADER, "LR header"),
+	    REG_TYPE_STR(UNMOUNT, "unmount"),
+	    REG_TYPE_STR(COMMIT, "commit"),
+	    REG_TYPE_STR(TRANSHDR, "trans header"),
+	    REG_TYPE_STR(ICREATE, "inode create")
 	};
+#undef REG_TYPE_STR
+#define TRANS_TYPE_STR(type)	[XFS_TRANS_##type] = #type
 	static char *trans_type_str[XFS_TRANS_TYPE_MAX] = {
-	    "SETATTR_NOT_SIZE",
-	    "SETATTR_SIZE",
-	    "INACTIVE",
-	    "CREATE",
-	    "CREATE_TRUNC",
-	    "TRUNCATE_FILE",
-	    "REMOVE",
-	    "LINK",
-	    "RENAME",
-	    "MKDIR",
-	    "RMDIR",
-	    "SYMLINK",
-	    "SET_DMATTRS",
-	    "GROWFS",
-	    "STRAT_WRITE",
-	    "DIOSTRAT",
-	    "WRITE_SYNC",
-	    "WRITEID",
-	    "ADDAFORK",
-	    "ATTRINVAL",
-	    "ATRUNCATE",
-	    "ATTR_SET",
-	    "ATTR_RM",
-	    "ATTR_FLAG",
-	    "CLEAR_AGI_BUCKET",
-	    "QM_SBCHANGE",
-	    "DUMMY1",
-	    "DUMMY2",
-	    "QM_QUOTAOFF",
-	    "QM_DQALLOC",
-	    "QM_SETQLIM",
-	    "QM_DQCLUSTER",
-	    "QM_QINOCREATE",
-	    "QM_QUOTAOFF_END",
-	    "FSYNC_TS",
-	    "GROWFSRT_ALLOC",
-	    "GROWFSRT_ZERO",
-	    "GROWFSRT_FREE",
-	    "SWAPEXT",
-	    "CHECKPOINT",
-	    "ICREATE",
-	    "CREATE_TMPFILE"
+	    TRANS_TYPE_STR(SETATTR_NOT_SIZE),
+	    TRANS_TYPE_STR(SETATTR_SIZE),
+	    TRANS_TYPE_STR(INACTIVE),
+	    TRANS_TYPE_STR(CREATE),
+	    TRANS_TYPE_STR(CREATE_TRUNC),
+	    TRANS_TYPE_STR(TRUNCATE_FILE),
+	    TRANS_TYPE_STR(REMOVE),
+	    TRANS_TYPE_STR(LINK),
+	    TRANS_TYPE_STR(RENAME),
+	    TRANS_TYPE_STR(MKDIR),
+	    TRANS_TYPE_STR(RMDIR),
+	    TRANS_TYPE_STR(SYMLINK),
+	    TRANS_TYPE_STR(SET_DMATTRS),
+	    TRANS_TYPE_STR(GROWFS),
+	    TRANS_TYPE_STR(STRAT_WRITE),
+	    TRANS_TYPE_STR(DIOSTRAT),
+	    TRANS_TYPE_STR(WRITEID),
+	    TRANS_TYPE_STR(ADDAFORK),
+	    TRANS_TYPE_STR(ATTRINVAL),
+	    TRANS_TYPE_STR(ATRUNCATE),
+	    TRANS_TYPE_STR(ATTR_SET),
+	    TRANS_TYPE_STR(ATTR_RM),
+	    TRANS_TYPE_STR(ATTR_FLAG),
+	    TRANS_TYPE_STR(CLEAR_AGI_BUCKET),
+	    TRANS_TYPE_STR(SB_CHANGE),
+	    TRANS_TYPE_STR(DUMMY1),
+	    TRANS_TYPE_STR(DUMMY2),
+	    TRANS_TYPE_STR(QM_QUOTAOFF),
+	    TRANS_TYPE_STR(QM_DQALLOC),
+	    TRANS_TYPE_STR(QM_SETQLIM),
+	    TRANS_TYPE_STR(QM_DQCLUSTER),
+	    TRANS_TYPE_STR(QM_QINOCREATE),
+	    TRANS_TYPE_STR(QM_QUOTAOFF_END),
+	    TRANS_TYPE_STR(FSYNC_TS),
+	    TRANS_TYPE_STR(GROWFSRT_ALLOC),
+	    TRANS_TYPE_STR(GROWFSRT_ZERO),
+	    TRANS_TYPE_STR(GROWFSRT_FREE),
+	    TRANS_TYPE_STR(SWAPEXT),
+	    TRANS_TYPE_STR(CHECKPOINT),
+	    TRANS_TYPE_STR(ICREATE),
+	    TRANS_TYPE_STR(CREATE_TMPFILE)
 	};
+#undef TRANS_TYPE_STR
 
 	xfs_warn(mp, "xlog_write: reservation summary:");
 	xfs_warn(mp, "  trans type  = %s (%u)",
 		 ((ticket->t_trans_type <= 0 ||
 		   ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
-		  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
+		  "bad-trans-type" : trans_type_str[ticket->t_trans_type]),
 		 ticket->t_trans_type);
 	xfs_warn(mp, "  unit res    = %d bytes",
 		 ticket->t_unit_res);
@@ -2078,7 +2082,7 @@ xlog_print_tic_res(
 		uint r_type = ticket->t_res_arr[i].r_type;
 		xfs_warn(mp, "region[%u]: %s - %u bytes", i,
 			    ((r_type <= 0 || r_type > XLOG_REG_TYPE_MAX) ?
-			    "bad-rtype" : res_type_str[r_type-1]),
+			    "bad-rtype" : res_type_str[r_type]),
 			    ticket->t_res_arr[i].r_len);
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
