Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F037C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 106B92071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CokuUsUR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgAXARv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729616AbgAXARv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O092Bf002932;
        Fri, 24 Jan 2020 00:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=20d1TRDNni/vKObZLnWSe7pAkwlMgXONdCRh39zXf7k=;
 b=CokuUsURtGqeimewPdy5XWEuiRt/YlIe4EYrOZYXGrl96Ps7lrvs1SaFrqcOI3WYd5/J
 /zOIicDSNLwG05EQ/99iAdVmrU53b+KpzaKDratOl42wqnvHXOqbVe6OFfDtdMT6tKhY
 EmiNy1UJACxxQnGycv4q8h5mFEe/JCDwPyuQob/3FFce+zNd3lyrw2KNAloRwDeuEBuZ
 gSA6VE48HMaXqsADJJDv9YoaKDssXlTbd5aaoDYPnTntodS7NINjM6k0IvdyQSVwMzTf
 zJ/8LRYfmgNy5aeuRlQhoKrGG10sKauXCA73hGap6xpjQpPXQVOukRJfkROsRQ45cacE Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnrnn3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0DWq2037288;
        Fri, 24 Jan 2020 00:17:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xqmuxkjkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:48 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O0HliY008186;
        Fri, 24 Jan 2020 00:17:47 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:47 -0800
Subject: [PATCH 3/6] xfs_repair: refactor fixed inode location checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Thu, 23 Jan 2020 16:17:45 -0800
Message-ID: <157982506534.2765631.12930539731426168994.stgit@magnolia>
In-Reply-To: <157982504556.2765631.630298760136626647.stgit@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the checking and resetting of fixed-location inodes (root,
rbmino, rsumino) into a helper function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |  106 ++++++++++++++++++---------------------------------
 1 file changed, 37 insertions(+), 69 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 3e9059f3..94673750 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -395,6 +395,37 @@ do_log(char const *msg, ...)
 	va_end(args);
 }
 
+/* Make sure a fixed-location inode is where it should be. */
+static void
+ensure_fixed_ino(
+	xfs_ino_t	*ino,
+	xfs_ino_t	expected_ino,
+	const char	*tag)
+{
+	if (*ino == expected_ino)
+		return;
+
+	do_warn(
+_("sb %s inode value %" PRIu64 " %sinconsistent with calculated value %"PRIu64"\n"),
+		tag, *ino, *ino == NULLFSINO ? "(NULLFSINO) " : "",
+		expected_ino);
+
+	if (!no_modify)
+		do_warn(
+_("resetting superblock %s inode pointer to %"PRIu64"\n"),
+			tag, expected_ino);
+	else
+		do_warn(
+_("would reset superblock %s inode pointer to %"PRIu64"\n"),
+			tag, expected_ino);
+
+	/*
+	 * Just set the value -- safe since the superblock doesn't get flushed
+	 * out if no_modify is set.
+	 */
+	*ino = expected_ino;
+}
+
 static void
 calc_mkfs(xfs_mount_t *mp)
 {
@@ -463,75 +494,12 @@ calc_mkfs(xfs_mount_t *mp)
 	/*
 	 * now the first 3 inodes in the system
 	 */
-	if (mp->m_sb.sb_rootino != first_prealloc_ino)  {
-		do_warn(
-_("sb root inode value %" PRIu64 " %sinconsistent with calculated value %u\n"),
-			mp->m_sb.sb_rootino,
-			(mp->m_sb.sb_rootino == NULLFSINO ? "(NULLFSINO) ":""),
-			first_prealloc_ino);
-
-		if (!no_modify)
-			do_warn(
-		_("resetting superblock root inode pointer to %u\n"),
-				first_prealloc_ino);
-		else
-			do_warn(
-		_("would reset superblock root inode pointer to %u\n"),
-				first_prealloc_ino);
-
-		/*
-		 * just set the value -- safe since the superblock
-		 * doesn't get flushed out if no_modify is set
-		 */
-		mp->m_sb.sb_rootino = first_prealloc_ino;
-	}
-
-	if (mp->m_sb.sb_rbmino != first_prealloc_ino + 1)  {
-		do_warn(
-_("sb realtime bitmap inode %" PRIu64 " %sinconsistent with calculated value %u\n"),
-			mp->m_sb.sb_rbmino,
-			(mp->m_sb.sb_rbmino == NULLFSINO ? "(NULLFSINO) ":""),
-			first_prealloc_ino + 1);
-
-		if (!no_modify)
-			do_warn(
-		_("resetting superblock realtime bitmap ino pointer to %u\n"),
-				first_prealloc_ino + 1);
-		else
-			do_warn(
-		_("would reset superblock realtime bitmap ino pointer to %u\n"),
-				first_prealloc_ino + 1);
-
-		/*
-		 * just set the value -- safe since the superblock
-		 * doesn't get flushed out if no_modify is set
-		 */
-		mp->m_sb.sb_rbmino = first_prealloc_ino + 1;
-	}
-
-	if (mp->m_sb.sb_rsumino != first_prealloc_ino + 2)  {
-		do_warn(
-_("sb realtime summary inode %" PRIu64 " %sinconsistent with calculated value %u\n"),
-			mp->m_sb.sb_rsumino,
-			(mp->m_sb.sb_rsumino == NULLFSINO ? "(NULLFSINO) ":""),
-			first_prealloc_ino + 2);
-
-		if (!no_modify)
-			do_warn(
-		_("resetting superblock realtime summary ino pointer to %u\n"),
-				first_prealloc_ino + 2);
-		else
-			do_warn(
-		_("would reset superblock realtime summary ino pointer to %u\n"),
-				first_prealloc_ino + 2);
-
-		/*
-		 * just set the value -- safe since the superblock
-		 * doesn't get flushed out if no_modify is set
-		 */
-		mp->m_sb.sb_rsumino = first_prealloc_ino + 2;
-	}
-
+	ensure_fixed_ino(&mp->m_sb.sb_rootino, first_prealloc_ino,
+			_("root"));
+	ensure_fixed_ino(&mp->m_sb.sb_rbmino, first_prealloc_ino + 1,
+			_("realtime bitmap"));
+	ensure_fixed_ino(&mp->m_sb.sb_rsumino, first_prealloc_ino + 2,
+			_("realtime summary"));
 }
 
 /*

