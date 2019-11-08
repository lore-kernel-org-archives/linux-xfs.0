Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68835C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 337E22087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AN2dHQD+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHHFX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:05:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39712 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:05:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873rdU055348;
        Fri, 8 Nov 2019 07:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=k2672JWRkT2Mvsi/pSgJR84BON+1ptxPXLCSVZWmijQ=;
 b=AN2dHQD+oEd5ngihoPz16DcT6gu/uXj26gBhqXoT9T3tRnwHlOgLBkw+4QSEvtoTZy4v
 JO8EvMUdx3QnhkNX3RtFwQwzRtegooXmPcpNQv18EZaH1r7XiW/PcnHSZcTDq01oYTCP
 Im+uWAWVnnKuvG6Q9k68I0+vDcE9ddofOiMtLeIb9TxUUM6aJZXZFPqvMw3DyBRO2XBA
 LBLvgcYbfobPMO7u2owzcX/OZ5B6X8Da9e2vLwXa56GlyoOOzH0wv8C8+n5X5SIbXZ0u
 Ohisn3ux+nVLFlRjE9xRr4GZu1qW5EA3DfNlvbOLdRGgluRa+63qJBM4aZZnj3hjpMIu BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w13bfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:05:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873s01182798;
        Fri, 8 Nov 2019 07:05:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w41wh0j74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:05:17 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA875GIT020066;
        Fri, 8 Nov 2019 07:05:16 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:05:16 -0800
Subject: [PATCH 1/2] xfs: refactor "does this fork map blocks" predicate
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 07 Nov 2019 23:05:15 -0800
Message-ID: <157319671485.834699.9969042485447944797.stgit@magnolia>
In-Reply-To: <157319670850.834699.10430897268214054248.stgit@magnolia>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded checks for whether or not an inode fork maps
blocks with a macro that will implant the code for us.  This helps us
declutter the bmap code a bit.

Note that I had to use a macro instead of a static inline function
because of C header dependency problems between xfs_inode.h and
xfs_inode_fork.h.

Conversion was performed with the following Coccinelle script:

@@
expression ip, w;
@@

- XFS_IFORK_FORMAT(ip, w) == XFS_DINODE_FMT_EXTENTS || XFS_IFORK_FORMAT(ip, w) == XFS_DINODE_FMT_BTREE
+ xfs_ifork_has_extents(ip, w)

@@
expression ip, w;
@@

- XFS_IFORK_FORMAT(ip, w) != XFS_DINODE_FMT_EXTENTS && XFS_IFORK_FORMAT(ip, w) != XFS_DINODE_FMT_BTREE
+ !xfs_ifork_has_extents(ip, w)

@@
expression ip, w;
@@

- XFS_IFORK_FORMAT(ip, w) == XFS_DINODE_FMT_BTREE || XFS_IFORK_FORMAT(ip, w) == XFS_DINODE_FMT_EXTENTS
+ xfs_ifork_has_extents(ip, w)

@@
expression ip, w;
@@

- XFS_IFORK_FORMAT(ip, w) != XFS_DINODE_FMT_BTREE && XFS_IFORK_FORMAT(ip, w) != XFS_DINODE_FMT_EXTENTS
+ !xfs_ifork_has_extents(ip, w)

@@
expression ip, w;
@@

- (xfs_ifork_has_extents(ip, w))
+ xfs_ifork_has_extents(ip, w)

@@
expression ip, w;
@@

- (!xfs_ifork_has_extents(ip, w))
+ !xfs_ifork_has_extents(ip, w)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |   28 +++++++++-------------------
 fs/xfs/libxfs/xfs_inode_fork.h |    4 ++++
 fs/xfs/scrub/dabtree.c         |    3 +--
 fs/xfs/xfs_iomap.c             |    3 +--
 4 files changed, 15 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d08bdb066555..97b6a1fd3246 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1288,8 +1288,7 @@ xfs_bmap_first_unused(
 	xfs_fileoff_t		lowest, max;
 	int			error;
 
-	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE ||
-	       XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ||
+	ASSERT(xfs_ifork_has_extents(ip, whichfork) ||
 	       XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
@@ -1445,8 +1444,7 @@ xfs_bmap_last_offset(
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL)
 		return 0;
 
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS) {
+	if (!xfs_ifork_has_extents(ip, whichfork)) {
 		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
@@ -3909,8 +3907,7 @@ xfs_bmapi_read(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	    !xfs_ifork_has_extents(ip, whichfork),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_read", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -4421,8 +4418,7 @@ xfs_bmapi_write(
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	    !xfs_ifork_has_extents(ip, whichfork),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_write", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -4691,8 +4687,7 @@ xfs_bmapi_remap(
 			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	    !xfs_ifork_has_extents(ip, whichfork),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -5333,9 +5328,7 @@ __xfs_bunmapi(
 	whichfork = xfs_bmapi_whichfork(flags);
 	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (unlikely(
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
+	if (unlikely(!xfs_ifork_has_extents(ip, whichfork))) {
 		XFS_ERROR_REPORT("xfs_bunmapi", XFS_ERRLEVEL_LOW,
 				 ip->i_mount);
 		return -EFSCORRUPTED;
@@ -5834,8 +5827,7 @@ xfs_bmap_collapse_extents(
 	int			logflags = 0;
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	    !xfs_ifork_has_extents(ip, whichfork),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -5954,8 +5946,7 @@ xfs_bmap_insert_extents(
 	int			logflags = 0;
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	    !xfs_ifork_has_extents(ip, whichfork),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -6063,8 +6054,7 @@ xfs_bmap_split_extent_at(
 	int				i = 0;
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	    !xfs_ifork_has_extents(ip, whichfork),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmap_split_extent_at",
 				 XFS_ERRLEVEL_LOW, mp);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7b845c052fb4..500333d0101e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -87,6 +87,10 @@ struct xfs_ifork {
 #define XFS_IFORK_MAXEXT(ip, w) \
 	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
 
+#define xfs_ifork_has_extents(ip, w) \
+	(XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_EXTENTS || \
+	 XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_BTREE)
+
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
 int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 77ff9f97bcda..ff30429d6e51 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -485,8 +485,7 @@ xchk_da_btree(
 	int				error;
 
 	/* Skip short format data structures; no btree to scan. */
-	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+	if (!xfs_ifork_has_extents(sc->ip, whichfork))
 		return 0;
 
 	/* Set up initial da state. */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 153262c76051..1471bcd6cb70 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -847,8 +847,7 @@ xfs_buffered_write_iomap_begin(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	    !xfs_ifork_has_extents(ip, XFS_DATA_FORK),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;

