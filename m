Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8744C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FDDE20731
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n7EYS0TL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgIJFhD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 01:37:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgIJFg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 01:36:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A5YWQn027692;
        Thu, 10 Sep 2020 05:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bmza3onwzUp0UzGmTEwUkAF99JXzTh2Iu0/xA13Weqs=;
 b=n7EYS0TLiPDY4JaFLtfH6Azh1FOa/X/CvtjPCsfDzlc3UgPGbhADztv0+pl+CqsJQmuq
 LCe3/op99FjQWVH+FFrG64ZPwcn4PteiQEozNXkPO6UyRdU7zY2cPGfrf90YZDsqlajW
 J1yE4DgmvBp6DQEc1R0KX95QN/f4UoAXGhZKiL+xrdyU8Euv0aoYN1xxGVDRKWmsKQHj
 TLcayFaCpN26K6aJTOCapkmvMdTCBLyNXovw5qr8kRuQZXa0T9d1Qw8ArrfhQXFHyHI7
 bP8OYqLxkT4HgPdfbJEfFpYNaLfxJufqymgENnnqzyv5Ys6hS0VIvANzKouaa2WmXswa QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33c2mm5qk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 05:36:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A5Ze9w094703;
        Thu, 10 Sep 2020 05:36:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33dacmmpeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 05:36:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08A5aq7T021411;
        Thu, 10 Sep 2020 05:36:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 22:36:51 -0700
Subject: [PATCH 1/2] xfs: refactor inode flags propagation code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 09 Sep 2020 22:36:50 -0700
Message-ID: <159971621055.1311472.9677034380244876371.stgit@magnolia>
In-Reply-To: <159971620202.1311472.11867327944494045509.stgit@magnolia>
References: <159971620202.1311472.11867327944494045509.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100053
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the code that propagates di_flags and di_flags2 from a parent to a
new child into separate functions.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |  113 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 48 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..4c520cc10191 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -714,6 +714,67 @@ xfs_lookup(
 	return error;
 }
 
+/* Propagate di_flags from a parent inode to a child inode. */
+static void
+xfs_inode_propagate_flags(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	unsigned int		di_flags = 0;
+	umode_t			mode = VFS_I(ip)->i_mode;
+
+	if (S_ISDIR(mode)) {
+		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+			ip->i_d.di_extsize = pip->i_d.di_extsize;
+		}
+		if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+			di_flags |= XFS_DIFLAG_PROJINHERIT;
+	} else if (S_ISREG(mode)) {
+		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_REALTIME;
+		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+			ip->i_d.di_extsize = pip->i_d.di_extsize;
+		}
+	}
+	if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
+	    xfs_inherit_noatime)
+		di_flags |= XFS_DIFLAG_NOATIME;
+	if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
+	    xfs_inherit_nodump)
+		di_flags |= XFS_DIFLAG_NODUMP;
+	if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
+	    xfs_inherit_sync)
+		di_flags |= XFS_DIFLAG_SYNC;
+	if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
+	    xfs_inherit_nosymlinks)
+		di_flags |= XFS_DIFLAG_NOSYMLINKS;
+	if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
+	    xfs_inherit_nodefrag)
+		di_flags |= XFS_DIFLAG_NODEFRAG;
+	if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+		di_flags |= XFS_DIFLAG_FILESTREAM;
+
+	ip->i_d.di_flags |= di_flags;
+}
+
+/* Propagate di_flags2 from a parent inode to a child inode. */
+static void
+xfs_inode_propagate_flags2(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
+	}
+	if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
+}
+
 /*
  * Allocate an inode on disk and return a copy of its in-core version.
  * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
@@ -857,54 +918,10 @@ xfs_ialloc(
 		break;
 	case S_IFREG:
 	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
-			uint		di_flags = 0;
-
-			if (S_ISDIR(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-					di_flags |= XFS_DIFLAG_PROJINHERIT;
-			} else if (S_ISREG(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_REALTIME;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSIZE;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-			}
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
-			    xfs_inherit_noatime)
-				di_flags |= XFS_DIFLAG_NOATIME;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
-			    xfs_inherit_nodump)
-				di_flags |= XFS_DIFLAG_NODUMP;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
-			    xfs_inherit_sync)
-				di_flags |= XFS_DIFLAG_SYNC;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
-			    xfs_inherit_nosymlinks)
-				di_flags |= XFS_DIFLAG_NOSYMLINKS;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
-			    xfs_inherit_nodefrag)
-				di_flags |= XFS_DIFLAG_NODEFRAG;
-			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
-				di_flags |= XFS_DIFLAG_FILESTREAM;
-
-			ip->i_d.di_flags |= di_flags;
-		}
-		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
-			}
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
-		}
+		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY))
+			xfs_inode_propagate_flags(ip, pip);
+		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY))
+			xfs_inode_propagate_flags2(ip, pip);
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;

