Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k7Kn056095 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 038AD1EE3239
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	McSQU1jaGyuCo3WT for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIY-0001zq-Db
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:06 +0000
Message-Id: <20110701094606.386730624@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 20/27] xfs: cleanup the defintion of struct xfs_dir2_data_entry
References: <20110701094321.936534538@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_dir2_data_entry
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove the tag member which is at a variable offset after the actual
name, and make name a real variable sized C99 array instead of the incorrect
one-sized array which confuses (not only) gcc.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dir2_data.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.h	2011-06-29 13:42:35.521563513 +0200
+++ xfs/fs/xfs/xfs_dir2_data.h	2011-06-29 13:43:03.284746440 +0200
@@ -98,14 +98,14 @@ typedef struct xfs_dir2_data_hdr {
 
 /*
  * Active entry in a data block.  Aligned to 8 bytes.
- * Tag appears as the last 2 bytes.
+ *
+ * After the variable length name field there is a 2 byte tag field, which
+ * can be accessed using xfs_dir2_data_entry_tag_p.
  */
 typedef struct xfs_dir2_data_entry {
 	__be64			inumber;	/* inode number */
 	__u8			namelen;	/* name length */
-	__u8			name[1];	/* name bytes, no null */
-						/* variable offset */
-	__be16			tag;		/* starting offset of us */
+	__u8			name[];		/* name bytes, no null */
 } xfs_dir2_data_entry_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
