Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BCBC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BEAF206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="owRVHEKa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgAABMq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABMq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119iCU089415
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VK1dIovHal6KzBh8r+mDX7flD7K+RuKAR8k+jIbcdb8=;
 b=owRVHEKaGtmTmhSXvtKJCxSgGy3zwvNA7aHV2oGeH0x3QkUCcSVHP2LyDxqw8PXSKQsE
 Nr2/QQYGm7sUAsNyP7FItQ+Cgoi1KkPzn++WkRGnP4eJanM2xXmFzn5H1ivx2Cv0OZBF
 PD0l76rGB+gB8N8lBBo/QjfGu2vjJAkKDTWnXl6dwdyZQnNP4Vhv5oo/aog27qUpDucQ
 +Ac36hTBiQiQ7EaLc3fBdTo6RUXj8OfgLS2+FK89hGeEaL1OD272DCXzE5+obGjMASX4
 zR/EYOX2O0kzylnzDPfMYkQnpHYJs1uk+7HWnMKvh0FwPyfw5wh/4fe6fyC3SFTvVq+o yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uHQ045280
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x7medfdbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011CiBF029125
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:44 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:44 -0800
Subject: [PATCH 01/21] xfs: hoist extent size helpers to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:12:42 -0800
Message-ID: <157784116204.1365473.14309906171600525443.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extent size helpers to xfs_bmap.c in libxfs since they're used
there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   43 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    3 +++
 fs/xfs/xfs_inode.c       |   51 +++++++---------------------------------------
 fs/xfs/xfs_inode.h       |    5 ++---
 fs/xfs/xfs_iops.c        |    1 +
 fs/xfs/xfs_reflink.h     |    6 -----
 6 files changed, 57 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a7287272b04e..e67068141e1f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6499,3 +6499,46 @@ xfs_bmap_query_all(
 
 	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
 }
+
+/*
+ * helper function to extract extent size hint from inode
+ */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	/*
+	 * No point in aligning allocations if we need to COW to actually
+	 * write to them.
+	 */
+	if (xfs_is_always_cow_inode(ip))
+		return 0;
+	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
+		return ip->i_d.di_extsize;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
+/*
+ * Helper function to extract CoW extent size hint from inode.
+ * Between the extent size hint and the CoW extent size hint, we
+ * return the greater of the two.  If the value is zero (automatic),
+ * use the default size.
+ */
+xfs_extlen_t
+xfs_get_cowextsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		a, b;
+
+	a = 0;
+	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_d.di_cowextsize;
+	b = xfs_get_extsz_hint(ip);
+
+	a = max(a, b);
+	if (a == 0)
+		return XFS_DEFAULT_COWEXTSZ_HINT;
+	return a;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f8da2d5b81b8..e5fac18b2f28 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -298,4 +298,7 @@ typedef int (*xfs_bmap_query_range_fn)(
 int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
 		void *priv);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9863081bdfe9..50123ab1c37c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -46,49 +46,6 @@ STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
 
-/*
- * helper function to extract extent size hint from inode
- */
-xfs_extlen_t
-xfs_get_extsz_hint(
-	struct xfs_inode	*ip)
-{
-	/*
-	 * No point in aligning allocations if we need to COW to actually
-	 * write to them.
-	 */
-	if (xfs_is_always_cow_inode(ip))
-		return 0;
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
-		return ip->i_d.di_extsize;
-	if (XFS_IS_REALTIME_INODE(ip))
-		return ip->i_mount->m_sb.sb_rextsize;
-	return 0;
-}
-
-/*
- * Helper function to extract CoW extent size hint from inode.
- * Between the extent size hint and the CoW extent size hint, we
- * return the greater of the two.  If the value is zero (automatic),
- * use the default size.
- */
-xfs_extlen_t
-xfs_get_cowextsz_hint(
-	struct xfs_inode	*ip)
-{
-	xfs_extlen_t		a, b;
-
-	a = 0;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-		a = ip->i_d.di_cowextsize;
-	b = xfs_get_extsz_hint(ip);
-
-	a = max(a, b);
-	if (a == 0)
-		return XFS_DEFAULT_COWEXTSZ_HINT;
-	return a;
-}
-
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
@@ -4220,3 +4177,11 @@ xfs_has_eofblocks(
 	*has = imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
 	return 0;
 }
+
+bool
+xfs_is_always_cow_inode(
+	struct xfs_inode	*ip)
+{
+	return ip->i_mount->m_always_cow &&
+		xfs_sb_version_hasreflink(&ip->i_mount->m_sb);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4a3e472d7078..bc50cfa2b513 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -188,6 +188,8 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
 }
 
+bool xfs_is_always_cow_inode(struct xfs_inode *ip);
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
@@ -444,9 +446,6 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
-xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
-
 int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
 			       xfs_nlink_t, dev_t, prid_t,
 			       struct xfs_inode **);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f698351cee5d..e4635b29a20d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -22,6 +22,7 @@
 #include "xfs_iomap.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_bmap.h"
 
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index d18ad7f4fb64..668b57c84228 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -6,12 +6,6 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
-static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
-{
-	return ip->i_mount->m_always_cow &&
-		xfs_sb_version_hasreflink(&ip->i_mount->m_sb);
-}
-
 static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
 {
 	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);

