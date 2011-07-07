Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6jZP159941 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AF1C52E0A
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	aazcZrIn38uTDLjg for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPs-0003zW-GI
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:44 +0000
Message-Id: <20110707110644.464527108@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 20/28] xfs: cleanup the definition of struct
	xfs_dir2_data_entry
References: <20110707110535.205001532@bombadil.infradead.org>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_dir2_data.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.h	2011-07-06 15:46:31.185403579 +0200
+++ xfs/fs/xfs/xfs_dir2_data.h	2011-07-07 09:55:02.398763553 +0200
@@ -98,14 +98,15 @@ typedef struct xfs_dir2_data_hdr {
 
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
+     /*	__be16                  tag; */		/* starting offset of us */
 } xfs_dir2_data_entry_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
