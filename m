Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F93629E1F
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 22:56:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 127F8304053
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:56:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zuBkpG0lk6LwsUW3 for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 20:56:10 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhWU5-0002Ut-Gj
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhWU5-0005Ib-Fn
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: make superblock version checks reflect reality
Date: Tue,  6 May 2014 13:55:55 +1000
Message-Id: <1399348559-19889-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1399348559-19889-1-git-send-email-david@fromorbit.com>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
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
regions for v4 feature bits. Also, convert the return values to
boolean types and remove typedefs from function declarations to
clean up calling conventions, too.

Because the feature bit checking is all inline code, this relatively
small cleanup has a noticable impact on code size:

   text    data     bss     dec     hex filename
 785195  100867     616  886678   d8796 fs/xfs/xfs.o.orig
 783595  100867     616  885078   d8156 fs/xfs/xfs.o.patched

i.e. it reduces it by 1600 bytes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_sb.h | 215 ++++++++++++++++++++------------------------------------
 1 file changed, 77 insertions(+), 138 deletions(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 950d1ea..85f0146 100644
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
@@ -50,24 +48,14 @@ struct xfs_trans;
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
-	 XFS_SB_VERSION_MOREBITSBIT)
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
@@ -76,7 +64,6 @@ struct xfs_trans;
  *
  * These defines represent bits in sb_features2.
  */
-#define XFS_SB_VERSION2_REALFBITS	0x00ffffff	/* Mask: features */
 #define XFS_SB_VERSION2_RESERVED1BIT	0x00000001
 #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
@@ -86,16 +73,11 @@ struct xfs_trans;
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
@@ -345,167 +327,124 @@ typedef enum {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-static inline int xfs_sb_good_version(xfs_sb_t *sbp)
+/*
+ * The first XFS version we support is a v4 superblock with V2 directories.
+ */
+static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
 {
-	/* We always support version 1-3 */
-	if (sbp->sb_versionnum >= XFS_SB_VERSION_1 &&
-	    sbp->sb_versionnum <= XFS_SB_VERSION_3)
-		return 1;
+	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
+		return false;
 
-	/* We support version 4 if all feature bits are supported */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) {
-		if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKREALBITS) ||
-		    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
-		     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKREALBITS)))
-			return 0;
+	/* check for unknown features in the fs */
+	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
+	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
+		return false;
 
-		if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
-			return 0;
-		return 1;
-	}
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
-		return 1;
+	/* We don't support shared superblocks - nobody knows what it is */
+	if (sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT)
+		return false;
 
-	return 0;
+	return true;
+}
+
+static inline bool xfs_sb_good_version(struct xfs_sb *sbp)
+{
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+		return true;
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+		return xfs_sb_good_v4_features(sbp);
+	return false;
 }
 
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
  */
-static inline int xfs_sb_has_mismatched_features2(xfs_sb_t *sbp)
+static inline bool xfs_sb_has_mismatched_features2(struct xfs_sb *sbp)
 {
-	return (sbp->sb_bad_features2 != sbp->sb_features2);
+	return sbp->sb_bad_features2 != sbp->sb_features2;
 }
 
-static inline unsigned xfs_sb_version_tonew(unsigned v)
+static inline bool xfs_sb_version_hasattr(struct xfs_sb *sbp)
 {
-	if (v == XFS_SB_VERSION_1)
-		return XFS_SB_VERSION_4;
-
-	if (v == XFS_SB_VERSION_2)
-		return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
-
-	return XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT |
-		XFS_SB_VERSION_NLINKBIT;
+	return (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT);
 }
 
-static inline unsigned xfs_sb_version_toold(unsigned v)
+static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
 {
-	if (v & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT))
-		return 0;
-	if (v & XFS_SB_VERSION_NLINKBIT)
-		return XFS_SB_VERSION_3;
-	if (v & XFS_SB_VERSION_ATTRBIT)
-		return XFS_SB_VERSION_2;
-	return XFS_SB_VERSION_1;
+	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 }
 
-static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasnlink(struct xfs_sb *sbp)
 {
-	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
-		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
-		(XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
+	return (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT);
 }
 
-static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
+static inline void xfs_sb_version_addnlink(struct xfs_sb *sbp)
 {
-	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
-		sbp->sb_versionnum = XFS_SB_VERSION_2;
-	else if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
-		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
-	else
-		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
+	sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
 }
 
-static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasquota(struct xfs_sb *sbp)
 {
-	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
-		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
+	return (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
-static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
+static inline void xfs_sb_version_addquota(struct xfs_sb *sbp)
 {
-	if (sbp->sb_versionnum <= XFS_SB_VERSION_2)
-		sbp->sb_versionnum = XFS_SB_VERSION_3;
-	else
-		sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
+	sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
 }
 
-static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasalign(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
-}
-
-static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
-{
-	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
-		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
-	else
-		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
-					XFS_SB_VERSION_QUOTABIT;
-}
-
-static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
 		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
 }
 
-static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
+	return (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
-static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasshared(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
 }
 
-static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasdirv2(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 }
 
-static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
-static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasextflgbit(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
 }
 
-static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hassector(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
+	return (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
-static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasasciici(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
+	return (sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
 }
 
-static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
 /*
@@ -513,46 +452,46 @@ static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
  *
  * For example, for a bit defined as XFS_SB_VERSION2_FUNBIT, has a macro:
  *
- * SB_VERSION_HASFUNBIT(xfs_sb_t *sbp)
+ * SB_VERSION_HASFUNBIT(struct xfs_sb *sbp)
  *	((xfs_sb_version_hasmorebits(sbp) &&
  *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
  */
 
-static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
 		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
 }
 
-static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasattr2(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
 		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
 }
 
-static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
+static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
-static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
+static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
 	if (!sbp->sb_features2)
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
 
-static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
 }
 
-static inline void xfs_sb_version_addprojid32bit(xfs_sb_t *sbp)
+static inline void xfs_sb_version_addprojid32bit(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
@@ -625,12 +564,12 @@ xfs_sb_has_incompat_log_feature(
 /*
  * V5 superblock specific feature checks
  */
-static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
+static inline int xfs_sb_version_hascrc(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
-static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
+static inline int xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
