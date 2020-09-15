Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA9EC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5220520756
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:51:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VHQ+YKvi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgIOBvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:51:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOBvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:51:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1nu1N034927;
        Tue, 15 Sep 2020 01:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PkBe2/MmWoeDGmUaNPmNN0SEo1QZeeYDNXcX31xcGuk=;
 b=VHQ+YKvipUBwcbDlxc+H6SiMcwr26UfC+uYKY1ehTqL7yHVtFuPH37xXoZbID3a5YeyB
 Im1CvHb1ZS53qxtp85OOFzGdTp5NjdiSE+sOt4i+Uz6TalB9l0dAKwlDHbQLu61VZvkL
 Q+4uku+OqTGDqqVHuYIM17GaP72+voxQ9soqVS/dnjScNRM1gmbVP5oWKvu7CCZYZCR5
 uXJwotIT2/+8K/9EbLwKIhRiisafSJJw2Ciplr2sbJOmFLx/j5FhriI0rHs/IdsCrMKf
 eVrXbjB9ltkIqJWBLS/uwNqRAukEL9KCths20lqnOthnSbdNZksTj1eQsh8mgEJalsI4 rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m1xc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:51:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1nttJ103846;
        Tue, 15 Sep 2020 01:51:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33h7wn6r7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:51:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1pCR7005858;
        Tue, 15 Sep 2020 01:51:12 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:51:12 +0000
Subject: [PATCH 1/4] libxfs: refactor inode flags propagation code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:51:11 -0700
Message-ID: <160013467138.2932378.13730720108241920821.stgit@magnolia>
In-Reply-To: <160013466518.2932378.9536364695832878473.stgit@magnolia>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the code that propagates di_flags from a parent to a new child
into a separate function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/util.c |   55 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 23 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 7fb0a99596f4..78519872e8e8 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -207,6 +207,36 @@ xfs_flags2diflags2(
 	return di_flags2;
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
+	if ((mode & S_IFMT) == S_IFDIR) {
+		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+			ip->i_d.di_extsize = pip->i_d.di_extsize;
+		}
+	} else {
+		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) {
+			di_flags |= XFS_DIFLAG_REALTIME;
+		}
+		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+			ip->i_d.di_extsize = pip->i_d.di_extsize;
+		}
+	}
+	if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		di_flags |= XFS_DIFLAG_PROJINHERIT;
+	ip->i_d.di_flags |= di_flags;
+}
+
 /*
  * Allocate an inode on disk and return a copy of its in-core version.
  * Set mode, nlink, and rdev appropriately within the inode.
@@ -299,29 +329,8 @@ libxfs_ialloc(
 		break;
 	case S_IFREG:
 	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
-			uint	di_flags = 0;
-
-			if ((mode & S_IFMT) == S_IFDIR) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-			} else {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) {
-					di_flags |= XFS_DIFLAG_REALTIME;
-				}
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSIZE;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-			}
-			if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-				di_flags |= XFS_DIFLAG_PROJINHERIT;
-			ip->i_d.di_flags |= di_flags;
-		}
+		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY))
+			xfs_inode_propagate_flags(ip, pip);
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;

