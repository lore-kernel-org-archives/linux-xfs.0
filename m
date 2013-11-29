Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3CAD7F4E
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21F88F806F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id QNiFV6jCWMdpqILt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcH-0000J7-J1
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:01 +0000
Message-Id: <20131129084001.431063269@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/10] xfs: remove the inode log format from the inode log item
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0008-xfs-remove-the-inode-log-format-from-the-inode-log-i.patch
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

No need to keep the inode log format around all the time, we can easily
generate it at iop_format time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c |   29 +++++++++++------------------
 fs/xfs/xfs_inode_item.h |    1 -
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f103dfd..346d592 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -370,17 +370,21 @@ xfs_inode_item_format(
 	struct xfs_inode_log_format *ilf;
 	struct xfs_log_iovec	*vecp = NULL;
 
-	ilf = xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT,
-			&iip->ili_format,
-			sizeof(struct xfs_inode_log_format));
-	ilf->ilf_size = 1;
+	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
+	ilf->ilf_type = XFS_LI_INODE;
+	ilf->ilf_ino = ip->i_ino;
+	ilf->ilf_blkno = ip->i_imap.im_blkno;
+	ilf->ilf_len = ip->i_imap.im_len;
+	ilf->ilf_boffset = ip->i_imap.im_boffset;
+	ilf->ilf_fields = XFS_ILOG_CORE;
+	ilf->ilf_size = 2; /* format + core */
+	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_inode_log_format));
 
 	if (ip->i_d.di_version == 1)
 		xfs_inode_item_format_v1_inode(ip);
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICORE,
 			&ip->i_d,
 			xfs_icdinode_size(ip->i_d.di_version));
-	ilf->ilf_size++;
 
 	xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
 	if (XFS_IFORK_Q(ip)) {
@@ -390,14 +394,8 @@ xfs_inode_item_format(
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
 	}
 
-	/*
-	 * Now update the log format that goes out to disk from the in-core
-	 * values.  We always write the inode core to make the arithmetic
-	 * games in recovery easier, which isn't a big deal as just about any
-	 * transaction would dirty it anyway.
-	 */
-	iip->ili_format.ilf_fields = XFS_ILOG_CORE |
-		(iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
+	/* update the format with the exact fields we actually logged */
+	ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
 }
 
 /*
@@ -601,11 +599,6 @@ xfs_inode_item_init(
 	iip->ili_inode = ip;
 	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE,
 						&xfs_inode_item_ops);
-	iip->ili_format.ilf_type = XFS_LI_INODE;
-	iip->ili_format.ilf_ino = ip->i_ino;
-	iip->ili_format.ilf_blkno = ip->i_imap.im_blkno;
-	iip->ili_format.ilf_len = ip->i_imap.im_len;
-	iip->ili_format.ilf_boffset = ip->i_imap.im_boffset;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 29b5f2b..488d812 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -34,7 +34,6 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-	xfs_inode_log_format_t	ili_format;	   /* logged structure */
 } xfs_inode_log_item_t;
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
