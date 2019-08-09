Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfHIVi1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYQvZ092736
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u8hasj9a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcOSA112177
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxkb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcL6Q019417
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:21 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v1 14/19] xfsprogs: Add delay context to xfs_da_args
Date: Fri,  9 Aug 2019 14:37:59 -0700
Message-Id: <20190809213804.32628-15-allison.henderson@oracle.com>
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a new struct xfs_delay_context, which we
will use to keep track of the current state of a delayed
attribute operation.

The flags member is used to track various operations that
are in progress so that we know not to repeat them, and
resume where we left off before EAGAIN was returned to
cycle out the transaction.  Other members take the place
of local variables that need to retain their values
across multiple function recalls.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h     |  6 ++++++
 libxfs/xfs_da_btree.h | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 06ed120..53d7d7e 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -91,6 +91,12 @@ struct xfs_attr_item {
 	struct list_head  xattri_list;
 
 	/*
+	 * xfs_da_args needs to remain instantiated across transaction rolls
+	 * during the defer finish, so store it here
+	 */
+	struct xfs_da_args	xattri_args;
+
+	/*
 	 * A byte array follows the header containing the file name and
 	 * attribute value.
 	 */
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 84dd865..b4607ad 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -42,6 +42,28 @@ enum xfs_dacmp {
 	XFS_CMP_CASE		/* names are same but differ in case */
 };
 
+#define		XFS_DC_INIT		0x01 /* Init delay info */
+#define		XFS_DC_FOUND_LBLK	0x02 /* We found leaf blk for attr */
+#define		XFS_DC_FOUND_NBLK	0x04 /* We found node blk for attr */
+#define		XFS_DC_ALLOC_LEAF	0x08 /* We are allocating leaf blocks */
+#define		XFS_DC_ALLOC_NODE	0x10 /* We are allocating node blocks */
+#define		XFS_DC_RM_LEAF_BLKS	0x20 /* We are removing leaf blocks */
+#define		XFS_DC_RM_NODE_BLKS	0x40 /* We are removing node blocks */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delay_context {
+	unsigned int		flags;
+	struct xfs_buf		*leaf_bp;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	xfs_fileoff_t		lfileoff;
+	int			blkcnt;
+	struct xfs_da_state	*state;
+	struct xfs_da_state_blk *blk;
+};
+
 /*
  * Structure to ease passing around component names.
  */
@@ -71,6 +93,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	struct xfs_delay_context  dc;	/* context used for delay attr ops */
 } xfs_da_args_t;
 
 /*
-- 
2.7.4
