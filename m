Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G6qOf031611 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:06:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 941D7164F1B5
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:06:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0JEKjdWvdyXdi89s for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:06:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlz-0007SW-6V
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:51 +0000
Message-Id: <20081202160651.115809000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 11/22] cleanup xfs_sb.h feature flag helpers
Content-Disposition: inline; filename=xfs-cleanup-sb.h-helpers
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

The various inlines in xfs_sb.h that deal with the superblock version
and fature flags were converted from macros a while ago, and this
show by the odd coding style full of useless braces and backslashes
and the avoidance of conditionals.

Clean these up to look like normal C code.

(First sent on August 2nd)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/xfs_sb.h
===================================================================
--- xfs-master.orig/fs/xfs/xfs_sb.h	2008-12-02 11:07:00.000000000 +0100
+++ xfs-master/fs/xfs/xfs_sb.h	2008-12-02 11:15:20.000000000 +0100
@@ -296,30 +296,34 @@ typedef enum {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-#ifdef __KERNEL__
 static inline int xfs_sb_good_version(xfs_sb_t *sbp)
 {
-	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
-		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
-		   ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		    !((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) || \
-		      ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) && \
-		       (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS))) && \
-	  	    (sbp->sb_shared_vn <= XFS_SB_MAX_SHARED_VN)));
-}
+	/* We always support version 1-3 */
+	if (sbp->sb_versionnum >= XFS_SB_VERSION_1 &&
+	    sbp->sb_versionnum <= XFS_SB_VERSION_3)
+		return 1;
+
+	/* We support version 4 if all feature bits are supported */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) {
+		if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) ||
+		    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+		     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS)))
+			return 0;
+
+#ifdef __KERNEL__
+		if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+			return 0;
 #else
-static inline int xfs_sb_good_version(xfs_sb_t *sbp)
-{
-	return (((sbp->sb_versionnum >= XFS_SB_VERSION_1) && \
-		  (sbp->sb_versionnum <= XFS_SB_VERSION_3)) || \
-		   ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		    !((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) || \
-		      ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) && \
-		       (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS))) && \
-		  (!(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) || \
-		   (sbp->sb_shared_vn <= XFS_SB_MAX_SHARED_VN))));
+		if ((sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) &&
+		    sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+			return 0;
+#endif
+
+		return 1;
+	}
+
+	return 0;
 }
-#endif /* __KERNEL__ */
 
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
@@ -332,123 +336,127 @@ static inline int xfs_sb_has_mismatched_
 
 static inline unsigned xfs_sb_version_tonew(unsigned v)
 {
-	return ((((v) == XFS_SB_VERSION_1) ? \
-		0 : \
-		(((v) == XFS_SB_VERSION_2) ? \
-			XFS_SB_VERSION_ATTRBIT : \
-			(XFS_SB_VERSION_ATTRBIT | XFS_SB_VERSION_NLINKBIT))) | \
-		XFS_SB_VERSION_4);
+	if (v == XFS_SB_VERSION_1)
+		return XFS_SB_VERSION_4;
+
+	if (v == XFS_SB_VERSION_2)
+		return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
+
+	return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT |
+		XFS_SB_VERSION_NLINKBIT;
 }
 
 static inline unsigned xfs_sb_version_toold(unsigned v)
 {
-	return (((v) & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT)) ? \
-		0 : \
-		(((v) & XFS_SB_VERSION_NLINKBIT) ? \
-			XFS_SB_VERSION_3 : \
-			(((v) & XFS_SB_VERSION_ATTRBIT) ?  \
-				XFS_SB_VERSION_2 : \
-				XFS_SB_VERSION_1)));
+	if (v & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT))
+		return 0;
+	if (v & XFS_SB_VERSION_NLINKBIT)
+		return XFS_SB_VERSION_3;
+	if (v & XFS_SB_VERSION_ATTRBIT)
+		return XFS_SB_VERSION_2;
+	return XFS_SB_VERSION_1;
 }
 
 static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
 {
-	return ((sbp)->sb_versionnum == XFS_SB_VERSION_2) || \
-		 ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
-		 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		  ((sbp)->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
+	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
+		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
+		(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
 }
 
 static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = (((sbp)->sb_versionnum == XFS_SB_VERSION_1) ? \
-		XFS_SB_VERSION_2 : \
-		((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) ? \
-			((sbp)->sb_versionnum | XFS_SB_VERSION_ATTRBIT) : \
-			(XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT)));
+	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
+		sbp->sb_versionnum = XFS_SB_VERSION_2;
+	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	else
+		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
 }
 
 static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
 {
-	return ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
-		 ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		  ((sbp)->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
+	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
+		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
 }
 
 static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = ((sbp)->sb_versionnum <= XFS_SB_VERSION_2 ? \
-		XFS_SB_VERSION_3 : \
-		((sbp)->sb_versionnum | XFS_SB_VERSION_NLINKBIT));
+	if (sbp->sb_versionnum <= XFS_SB_VERSION_2)
+		sbp->sb_versionnum = XFS_SB_VERSION_3;
+	else
+		sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
 }
 
 static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
 static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
 {
-	(sbp)->sb_versionnum = \
-		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 ? \
-			((sbp)->sb_versionnum | XFS_SB_VERSION_QUOTABIT) : \
-			(xfs_sb_version_tonew((sbp)->sb_versionnum) | \
-			 XFS_SB_VERSION_QUOTABIT));
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
+	else
+		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
+					XFS_SB_VERSION_QUOTABIT;
 }
 
 static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
 }
 
 static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
 static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
 }
 
 static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 }
 
 static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
 static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
 }
 
 static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
 static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
 }
 
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
-		((sbp)->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
 /*
@@ -463,22 +471,20 @@ static inline int xfs_sb_version_hasmore
 
 static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
 {
-	return (xfs_sb_version_hasmorebits(sbp) &&	\
-		((sbp)->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT);
 }
 
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
-	return (xfs_sb_version_hasmorebits(sbp)) &&	\
-		((sbp)->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
 }
 
 static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
 {
-	((sbp)->sb_versionnum =	\
-		((sbp)->sb_versionnum | XFS_SB_VERSION_MOREBITSBIT),	\
-	((sbp)->sb_features2 =	\
-		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
 static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
