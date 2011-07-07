Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6jxn159923 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20751176A800
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2XiiZtx6ouLQEr96 for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPr-0003ww-Ho
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:43 +0000
Message-Id: <20110707110643.501734294@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/28] xfs: cleanup the definition of struct xfs_dir2_sf_entry
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_dir2_sf_entry
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

Remove the inumber member which is at a variable offset after the actual
name, and make name a real variable sized C99 array instead of the incorrect
one-sized array which confuses (not only) gcc.  Based on this clean up
the helpers to calculate the entry size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2011-07-06 15:36:36.195433702 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2011-07-06 15:36:40.328766826 +0200
@@ -371,7 +371,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	add_entsize = xfs_dir2_sf_entsize_byname(sfp, args->namelen);
+	add_entsize = xfs_dir2_sf_entsize(sfp, args->namelen);
 	incr_isize = add_entsize;
 	objchange = 0;
 #if XFS_BIG_INUMS
@@ -465,7 +465,7 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp, xfs_dir2_sf_entsize_byname(sfp, args->namelen),
+	xfs_idata_realloc(dp, xfs_dir2_sf_entsize(sfp, args->namelen),
 		XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
@@ -1001,7 +1001,7 @@ xfs_dir2_sf_removename(
 	 * Calculate sizes.
 	 */
 	byteoff = (int)((char *)sfep - (char *)sfp);
-	entsize = xfs_dir2_sf_entsize_byname(sfp, args->namelen);
+	entsize = xfs_dir2_sf_entsize(sfp, args->namelen);
 	newsize = oldsize - entsize;
 	/*
 	 * Copy the part if any after the removed entry, sliding it down.
Index: xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.h	2011-07-06 15:36:36.208767034 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.h	2011-07-06 15:37:15.648765034 +0200
@@ -76,10 +76,13 @@ typedef struct xfs_dir2_sf_hdr {
 } __arch_pack xfs_dir2_sf_hdr_t;
 
 typedef struct xfs_dir2_sf_entry {
-	__uint8_t		namelen;	/* actual name length */
+	__u8			namelen;	/* actual name length */
 	xfs_dir2_sf_off_t	offset;		/* saved offset */
-	__uint8_t		name[1];	/* name, variable size */
-	xfs_dir2_inou_t		inumber;	/* inode number, var. offset */
+	__u8			name[];		/* name, variable size */
+	/*
+	 * A xfs_dir2_ino8_t or xfs_dir2_ino4_t follows here, at a
+	 * variable offset after the name.
+	 */
 } __arch_pack xfs_dir2_sf_entry_t; 
 
 static inline int xfs_dir2_sf_hdr_size(int i8count)
@@ -101,19 +104,14 @@ xfs_dir2_sf_put_offset(xfs_dir2_sf_entry
 	INT_SET_UNALIGNED_16_BE(&(sfep)->offset.i, off);
 }
 
-static inline int xfs_dir2_sf_entsize_byname(xfs_dir2_sf_hdr_t *sfp, int len)
-{
-	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (len) - \
-		((sfp)->i8count == 0) * \
-		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
-}
-
 static inline int
-xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_hdr_t *sfp, xfs_dir2_sf_entry_t *sfep)
+xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
 {
-	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (sfep)->namelen - \
-		((sfp)->i8count == 0) * \
-		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
+	return sizeof(struct xfs_dir2_sf_entry) +	/* namelen + offset */
+		len +					/* name */
+		(hdr->i8count ?				/* ino */
+		 sizeof(xfs_dir2_ino8_t) :
+		 sizeof(xfs_dir2_ino4_t));
 }
 
 static inline struct xfs_dir2_sf_entry *
@@ -128,7 +126,7 @@ xfs_dir2_sf_nextentry(struct xfs_dir2_sf
 		struct xfs_dir2_sf_entry *sfep)
 {
 	return (struct xfs_dir2_sf_entry *)
-		((char *)sfep + xfs_dir2_sf_entsize_byentry(hdr, sfep));
+		((char *)sfep + xfs_dir2_sf_entsize(hdr, sfep->namelen));
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
