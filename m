Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA31C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72C9F214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dFC+sa5o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgBEArO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:47:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727647AbgBEArN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:47:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dH10112978;
        Wed, 5 Feb 2020 00:47:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QZhadxrK/BZfxx/YKchKaRQC2LQTCdpLVmRFRpNqNIk=;
 b=dFC+sa5ooqk6Bjd8LjAYuJYH8cuOEtcmDglAbrHnz+8wHqExFhO5st61ll5DB22DZrWg
 zCni8IvxfK61xXKxbz5+cPZNyabLMWMX9fUMVgwk+hOjqQEJfsAB7lae6G4KxdtpRJtX
 WcStTELMF5ymZC4CcguhxezPlI0ivWDFen0iun4sAKjSyWYVuRrNrhyX9V3soU54vXNV
 DsNKiuKXnkMsCH8lAFPhfQVzZG/1Ndf4rMOEaRhoPP1JjxH/URcp24Aueop+Ap+nHPhc
 9+EbqYYpfN7nxnYTRx5ze///T8cwnIBqtkY0ASf5/676bCRckb3aLMMxvLvaxJOS1/IP cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xykbp80m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dlU8115090;
        Wed, 5 Feb 2020 00:47:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xykc30ya8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0150l4wv023704;
        Wed, 5 Feb 2020 00:47:04 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:47:03 -0800
Subject: [PATCH 4/7] xfs_repair: refactor fixed inode location checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        alex@zadara.com
Date:   Tue, 04 Feb 2020 16:47:02 -0800
Message-ID: <158086362282.2079685.17208024677816310215.stgit@magnolia>
In-Reply-To: <158086359783.2079685.9581209719946834913.stgit@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the checking and resetting of fixed-location inodes (root,
rbmino, rsumino) into a helper function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/xfs_repair.c |  106 ++++++++++++++++++---------------------------------
 1 file changed, 37 insertions(+), 69 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 3e9059f3..f8005f8a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -395,6 +395,37 @@ do_log(char const *msg, ...)
 	va_end(args);
 }
 
+/* Make sure a fixed-location inode is where it should be. */
+static void
+validate_sb_ino(
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
+	validate_sb_ino(&mp->m_sb.sb_rootino, first_prealloc_ino,
+			_("root"));
+	validate_sb_ino(&mp->m_sb.sb_rbmino, first_prealloc_ino + 1,
+			_("realtime bitmap"));
+	validate_sb_ino(&mp->m_sb.sb_rsumino, first_prealloc_ino + 2,
+			_("realtime summary"));
 }
 
 /*

