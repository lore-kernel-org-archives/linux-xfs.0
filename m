Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6877D7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 00:55:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46804304053
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 22:55:02 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Siosksnpd2oHKuZF for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 22:54:56 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WLSCg-0004za-Vd
	for xfs@oss.sgi.com; Thu, 06 Mar 2014 17:54:51 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WLSCg-0002oX-US
	for xfs@oss.sgi.com; Thu, 06 Mar 2014 17:54:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH] xfs: make superblock version checks reflect reality
Date: Thu,  6 Mar 2014 17:54:50 +1100
Message-Id: <1394088890-10713-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We only support filesystems that have v2 directory support, and than
means all the checking and handling of superblock versions prior to
this support being added is completely unnecessary overhead.

Strip out all the version 1-3 support, sanitise the good version
checking to reflect the supported versions, update all the feature
supported functions and clean up all the support bit definitions to
reflect the fact that we no longer care about Irix bootloader flag
regions for v4 feature bits.

Because the feature bit checking is all inline code, this relatively
small cleanup has a noticable impact on code size:

   text    data     bss     dec     hex filename
 802836   99339     632  902807   dc697 fs/xfs/xfs.o.orig
 801620   99339     632  901591   dc1d7 fs/xfs/xfs.o.patched

i.e. it reduces it by more than 1200 bytes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_sb.h | 175 ++++++++++++++++++++++----------------------------------
 1 file changed, 67 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index f7b2fe7..1fe9818 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -36,8 +36,6 @@ struct xfs_trans;
 #define	XFS_SB_VERSION_5	5		/* CRC enabled filesystem */
 #define	XFS_SB_VERSION_NUMBITS		0x000f
 #define	XFS_SB_VERSION_ALLFBITS		0xfff0
-#define	XFS_SB_VERSION_SASHFBITS	0xf000
-#define	XFS_SB_VERSION_REALFBITS	0x0ff0
 #define	XFS_SB_VERSION_ATTRBIT		0x0010
 #define	XFS_SB_VERSION_NLINKBIT		0x0020
 #define	XFS_SB_VERSION_QUOTABIT		0x0040
@@ -50,24 +48,26 @@ struct xfs_trans;
 #define	XFS_SB_VERSION_DIRV2BIT		0x2000
 #define	XFS_SB_VERSION_BORGBIT		0x4000	/* ASCII only case-insens. */
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
-#define	XFS_SB_VERSION_OKSASHFBITS	\
-	(XFS_SB_VERSION_EXTFLGBIT | \
-	 XFS_SB_VERSION_DIRV2BIT | \
-	 XFS_SB_VERSION_BORGBIT)
-#define	XFS_SB_VERSION_OKREALFBITS	\
-	(XFS_SB_VERSION_ATTRBIT | \
-	 XFS_SB_VERSION_NLINKBIT | \
-	 XFS_SB_VERSION_QUOTABIT | \
-	 XFS_SB_VERSION_ALIGNBIT | \
-	 XFS_SB_VERSION_DALIGNBIT | \
-	 XFS_SB_VERSION_SHAREDBIT | \
-	 XFS_SB_VERSION_LOGV2BIT | \
-	 XFS_SB_VERSION_SECTORBIT | \
+
+/*
+ * We only support superblocks that have at least V2 Dir capability. Any feature
+ * bit added after v2 dir capability is also indicates a supported superblock
+ * format.
+ */
+#define XFS_SB_NEEDED_FEATURES		\
+	(XFS_SB_VERSION_DIRV2BIT	| \
+	 XFS_SB_VERSION_LOGV2BIT	| \
+	 XFS_SB_VERSION_SECTORBIT	| \
+	 XFS_SB_VERSION_BORGBIT		| \
 	 XFS_SB_VERSION_MOREBITSBIT)
-#define	XFS_SB_VERSION_OKREALBITS	\
-	(XFS_SB_VERSION_NUMBITS | \
-	 XFS_SB_VERSION_OKREALFBITS | \
-	 XFS_SB_VERSION_OKSASHFBITS)
+
+/*
+ * Supported feature bit list is just all bits in the versionnum field because
+ * we've used them all up and understand them all.
+ */
+#define	XFS_SB_VERSION_OKBITS		\
+	(XFS_SB_VERSION_NUMBITS		| \
+	 XFS_SB_VERSION_ALLFBITS)
 
 /*
  * There are two words to hold XFS "feature" bits: the original
@@ -76,7 +76,6 @@ struct xfs_trans;
  *
  * These defines represent bits in sb_features2.
  */
-#define XFS_SB_VERSION2_REALFBITS	0x00ffffff	/* Mask: features */
 #define XFS_SB_VERSION2_RESERVED1BIT	0x00000001
 #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
@@ -86,16 +85,11 @@ struct xfs_trans;
 #define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
 #define XFS_SB_VERSION2_FTYPE		0x00000200	/* inode type in dir */
 
-#define	XFS_SB_VERSION2_OKREALFBITS	\
+#define	XFS_SB_VERSION2_OKBITS		\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
 	 XFS_SB_VERSION2_PROJID32BIT	| \
 	 XFS_SB_VERSION2_FTYPE)
-#define	XFS_SB_VERSION2_OKSASHFBITS	\
-	(0)
-#define XFS_SB_VERSION2_OKREALBITS	\
-	(XFS_SB_VERSION2_OKREALFBITS |	\
-	 XFS_SB_VERSION2_OKSASHFBITS )
 
 /*
  * Superblock - in core version.  Must match the ondisk version below.
@@ -345,28 +339,40 @@ typedef enum {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
+/*
+ * The first XFS version we support is filesytsems with V2 directories.
+ */
 static inline int xfs_sb_good_version(xfs_sb_t *sbp)
 {
-	/* We always support version 1-3 */
-	if (sbp->sb_versionnum >= XFS_SB_VERSION_1 &&
-	    sbp->sb_versionnum <= XFS_SB_VERSION_3)
+	/* We only support v4 and v5 */
+	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4 ||
+	    XFS_SB_VERSION_NUM(sbp) > XFS_SB_VERSION_5)
+		return 0;
+
+	/*
+	 * Version 5 feature checks are done separately.
+	 */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
 		return 1;
 
-	/* We support version 4 if all feature bits are supported */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) {
-		if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) ||
-		    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
-		     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS)))
-			return 0;
+	/*
+	 * We only support version 4 for if at least one of the needed feature
+	 * bits are set and all the feature bits are supported.
+	 */
+	ASSERT(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4);
+
+	if (!(sbp->sb_versionnum & XFS_SB_NEEDED_FEATURES))
+		return 0;
 
-		if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
+	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
 			return 0;
-		return 1;
-	}
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
-		return 1;
 
-	return 0;
+	if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
+		return 0;
+
+	return 1;
 }
 
 /*
@@ -378,88 +384,45 @@ static inline int xfs_sb_has_mismatched_features2(xfs_sb_t *sbp)
 	return (sbp->sb_bad_features2 != sbp->sb_features2);
 }
 
-static inline unsigned xfs_sb_version_tonew(unsigned v)
-{
-	if (v == XFS_SB_VERSION_1)
-		return XFS_SB_VERSION_4;
-
-	if (v == XFS_SB_VERSION_2)
-		return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
-
-	return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT |
-		XFS_SB_VERSION_NLINKBIT;
-}
-
-static inline unsigned xfs_sb_version_toold(unsigned v)
-{
-	if (v & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT))
-		return 0;
-	if (v & XFS_SB_VERSION_NLINKBIT)
-		return XFS_SB_VERSION_3;
-	if (v & XFS_SB_VERSION_ATTRBIT)
-		return XFS_SB_VERSION_2;
-	return XFS_SB_VERSION_1;
-}
-
 static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
 {
-	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
-		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
-		(XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
+	return !!(sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT);
 }
 
 static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
 {
-	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
-		sbp->sb_versionnum = XFS_SB_VERSION_2;
-	else if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
-		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
-	else
-		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
+	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 }
 
 static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
 {
-	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
-		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
+	return !!(sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT);
 }
 
 static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
 {
-	if (sbp->sb_versionnum <= XFS_SB_VERSION_2)
-		sbp->sb_versionnum = XFS_SB_VERSION_3;
-	else
-		sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
+	sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
 }
 
 static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
+	return !!(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
 static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
 {
-	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
-		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
-	else
-		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
-					XFS_SB_VERSION_QUOTABIT;
+	sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
 }
 
 static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
 		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
 }
 
 static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
+	return !!(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
 static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
@@ -470,42 +433,36 @@ static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 }
 
 static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
 static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
 }
 
 static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
+	return !!(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
 static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
+	return !!(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
 }
 
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
 /*
@@ -536,11 +493,13 @@ static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
+	sbp->sb_bad_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
 static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
 {
 	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
+	sbp->sb_bad_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
 	if (!sbp->sb_features2)
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
