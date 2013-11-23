Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37FEA7F55
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1701C8F8039
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id kHSgURYkSNtQeH8b (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:35 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvl-0001Or-Tk
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:33 +0000
Message-Id: <20131123151533.843899803@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: remove the inode log format from the inode log item
References: <20131123151151.716201348@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0002-xfs-remove-the-inode-log-format-from-the-inode-log-i.patch
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
 fs/xfs/xfs_inode_item.c |   51 +++++++++++++++++++----------------------------
 fs/xfs/xfs_inode_item.h |    1 -
 2 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fbdcde1..9ed1635 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -153,24 +153,28 @@ xfs_inode_item_format(
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_log_iovec	*vec;
 	struct xfs_inode_log_format *ilf;
-	uint			size;
-	uint			nvecs;
 	size_t			data_bytes;
 	xfs_mount_t		*mp;
 
 	vec = xlog_first_iovec(lv);
-	ilf = memcpy(vec->i_addr, &iip->ili_format,
-		     sizeof(struct xfs_inode_log_format));
-	vec->i_len = sizeof(struct xfs_inode_log_format);
 	vec->i_type = XLOG_REG_TYPE_IFORMAT;
-	nvecs = 1;
+	vec->i_len = sizeof(struct xfs_inode_log_format);
+
+	ilf = vec->i_addr;
+	ilf->ilf_type = XFS_LI_INODE;
+	ilf->ilf_ino = ip->i_ino;
+	ilf->ilf_blkno = ip->i_imap.im_blkno;
+	ilf->ilf_len = ip->i_imap.im_len;
+	ilf->ilf_boffset = ip->i_imap.im_boffset;
+	ilf->ilf_fields = XFS_ILOG_CORE;
+	ilf->ilf_size = 1;
 
 	vec = xlog_next_iovec(lv, vec);
-	size = xfs_icdinode_size(ip->i_d.di_version);
-	memcpy(vec->i_addr, &ip->i_d, size);
-	vec->i_len = size;
 	vec->i_type = XLOG_REG_TYPE_ICORE;
-	nvecs++;
+	vec->i_len = xfs_icdinode_size(ip->i_d.di_version);
+	memcpy(vec->i_addr, &ip->i_d, vec->i_len);
+
+	ilf->ilf_size++;
 
 	/*
 	 * If this is really an old format inode, then we need to
@@ -218,7 +222,7 @@ xfs_inode_item_format(
 			vec->i_len = xfs_iextents_copy(ip, vec->i_addr,
 						       XFS_DATA_FORK);
 			vec->i_type = XLOG_REG_TYPE_IEXT;
-			nvecs++;
+			ilf->ilf_size++;
 
 			ASSERT(vec->i_len <= ip->i_df.if_bytes);
 			ilf->ilf_dsize = vec->i_len;
@@ -241,7 +245,7 @@ xfs_inode_item_format(
 			       ip->i_df.if_broot_bytes);
 			vec->i_len = ip->i_df.if_broot_bytes;
 			vec->i_type = XLOG_REG_TYPE_IBROOT;
-			nvecs++;
+			ilf->ilf_size++;
 
 			ilf->ilf_dsize = ip->i_df.if_broot_bytes;
 		} else {
@@ -273,7 +277,7 @@ xfs_inode_item_format(
 			memcpy(vec->i_addr, ip->i_df.if_u1.if_data, data_bytes);
 			vec->i_len = data_bytes;
 			vec->i_type = XLOG_REG_TYPE_ILOCAL;
-			nvecs++;
+			ilf->ilf_size++;
 
 			ilf->ilf_dsize = (unsigned)data_bytes;
 		} else {
@@ -327,7 +331,7 @@ xfs_inode_item_format(
 			vec->i_len = xfs_iextents_copy(ip, vec->i_addr,
 						       XFS_ATTR_FORK);
 			vec->i_type = XLOG_REG_TYPE_IATTR_EXT;
-			nvecs++;
+			ilf->ilf_size++;
 
 			ilf->ilf_asize = vec->i_len;
 		} else {
@@ -348,7 +352,7 @@ xfs_inode_item_format(
 			       ip->i_afp->if_broot_bytes);
 			vec->i_len = ip->i_afp->if_broot_bytes;
 			vec->i_type = XLOG_REG_TYPE_IATTR_BROOT;
-			nvecs++;
+			ilf->ilf_size++;
 
 			ilf->ilf_asize = ip->i_afp->if_broot_bytes;
 		} else {
@@ -378,7 +382,7 @@ xfs_inode_item_format(
 			       data_bytes);
 			vec->i_len = data_bytes;
 			vec->i_type = XLOG_REG_TYPE_IATTR_LOCAL;
-			nvecs++;
+			ilf->ilf_size++;
 
 			ilf->ilf_asize = (unsigned)data_bytes;
 		} else {
@@ -393,15 +397,7 @@ xfs_inode_item_format(
 
 out:
 	xlog_last_iovec(lv, vec);
-	/*
-	 * Now update the log format that goes out to disk from the in-core
-	 * values.  We always write the inode core to make the arithmetic
-	 * games in recovery easier, which isn't a big deal as just about any
-	 * transaction would dirty it anyway.
-	 */
-	ilf->ilf_fields = XFS_ILOG_CORE |
-		(iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
-	ilf->ilf_size = nvecs;
+	ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
 }
 
 /*
@@ -605,11 +601,6 @@ xfs_inode_item_init(
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
