Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E227BC55178
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86CD20874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lodyuqdi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407166AbgJZXgo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37940 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407169AbgJZXgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPvfk158460;
        Mon, 26 Oct 2020 23:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZerwMX0Hxjn2gy1M5CRf1LP4nx0hAGtGVPshVu2nczA=;
 b=LodyuqdiXNWoMVVGuOe8vw/N997NgaErRkXWqBe8oPht3JY0Ps9SqRPFpitLkrJQiNq2
 XFCeYejSybD6UepnP+PxG7NNk4/WO63IIFfNpU3OVpkLpEkY0shv96C10MWeJP9qCBEz
 jHTvOyuzTomg5yXJpI2XqkOHqLIcRd37h+yDRX0WPjj3JFFgiTz3P+OgTf9bF4B1XjnO
 yG5PEbkLCeaGcfu9mrwieEqaoMpa4ZkdmwUMQV1qaQ/32389wBGGqfdGGOHSo5lxn8Xp
 z1QVdDDMjCUwu+D0nbtNP5gKGuw6tV91Cgci44xot8U8Z18xkn1DbJO2nf57xv15m87W Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQE2a032449;
        Mon, 26 Oct 2020 23:34:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1q2bec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNYd9L012578;
        Mon, 26 Oct 2020 23:34:39 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:39 -0700
Subject: [PATCH 05/26] xfs_quota: convert time_to_string to use time64_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:38 -0700
Message-ID: <160375527834.881414.2581158648212089750.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rework the time_to_string helper to be capable of dealing with 64-bit
timestamps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 quota/quota.c  |   16 ++++++++++------
 quota/quota.h  |    2 +-
 quota/report.c |   16 ++++++++++------
 quota/util.c   |    5 +++--
 4 files changed, 24 insertions(+), 15 deletions(-)


diff --git a/quota/quota.c b/quota/quota.c
index 9545cc430a93..8ba0995d9174 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -48,6 +48,7 @@ quota_mount(
 	uint		flags)
 {
 	fs_disk_quota_t	d;
+	time64_t	timer;
 	char		*dev = mount->fs_name;
 	char		c[8], h[8], s[8];
 	uint		qflags;
@@ -100,6 +101,7 @@ quota_mount(
 	}
 
 	if (form & XFS_BLOCK_QUOTA) {
+		timer = d.d_btimer;
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -111,16 +113,17 @@ quota_mount(
 				bbs_to_string(d.d_blk_softlimit, s, sizeof(s)),
 				bbs_to_string(d.d_blk_hardlimit, h, sizeof(h)),
 				d.d_bwarns,
-				time_to_string(d.d_btimer, qflags));
+				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu   %02d %9s ",
 				(unsigned long long)d.d_bcount >> 1,
 				(unsigned long long)d.d_blk_softlimit >> 1,
 				(unsigned long long)d.d_blk_hardlimit >> 1,
 				d.d_bwarns,
-				time_to_string(d.d_btimer, qflags));
+				time_to_string(timer, qflags));
 	}
 	if (form & XFS_INODE_QUOTA) {
+		timer = d.d_itimer;
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_ino_hardlimit && d.d_icount > d.d_ino_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -132,16 +135,17 @@ quota_mount(
 				num_to_string(d.d_ino_softlimit, s, sizeof(s)),
 				num_to_string(d.d_ino_hardlimit, h, sizeof(h)),
 				d.d_iwarns,
-				time_to_string(d.d_itimer, qflags));
+				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu   %02d %9s ",
 				(unsigned long long)d.d_icount,
 				(unsigned long long)d.d_ino_softlimit,
 				(unsigned long long)d.d_ino_hardlimit,
 				d.d_iwarns,
-				time_to_string(d.d_itimer, qflags));
+				time_to_string(timer, qflags));
 	}
 	if (form & XFS_RTBLOCK_QUOTA) {
+		timer = d.d_rtbtimer;
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_rtb_hardlimit && d.d_rtbcount > d.d_rtb_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -153,14 +157,14 @@ quota_mount(
 				bbs_to_string(d.d_rtb_softlimit, s, sizeof(s)),
 				bbs_to_string(d.d_rtb_hardlimit, h, sizeof(h)),
 				d.d_rtbwarns,
-				time_to_string(d.d_rtbtimer, qflags));
+				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu   %02d %9s ",
 				(unsigned long long)d.d_rtbcount >> 1,
 				(unsigned long long)d.d_rtb_softlimit >> 1,
 				(unsigned long long)d.d_rtb_hardlimit >> 1,
 				d.d_rtbwarns,
-				time_to_string(d.d_rtbtimer, qflags));
+				time_to_string(timer, qflags));
 	}
 	fprintf(fp, "%s\n", mount->fs_dir);
 	return 1;
diff --git a/quota/quota.h b/quota/quota.h
index 025d887726d8..11f62b208e6a 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -40,7 +40,7 @@ enum {
  */
 extern char *type_to_string(uint __type);
 extern char *form_to_string(uint __form);
-extern char *time_to_string(time_t __time, uint __flags);
+extern char *time_to_string(time64_t __time, uint __flags);
 extern char *bbs_to_string(uint64_t __v, char *__c, uint __size);
 extern char *num_to_string(uint64_t __v, char *__c, uint __size);
 extern char *pct_to_string(uint64_t __v, uint64_t __t, char *__c, uint __s);
diff --git a/quota/report.c b/quota/report.c
index e6def916b827..2d5024e95177 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -330,6 +330,7 @@ report_mount(
 	uint		flags)
 {
 	fs_disk_quota_t	d;
+	time64_t	timer;
 	char		*dev = mount->fs_name;
 	char		c[8], h[8], s[8];
 	uint		qflags;
@@ -397,6 +398,7 @@ report_mount(
 	}
 
 	if (form & XFS_BLOCK_QUOTA) {
+		timer = d.d_btimer;
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -408,16 +410,17 @@ report_mount(
 				bbs_to_string(d.d_blk_softlimit, s, sizeof(s)),
 				bbs_to_string(d.d_blk_hardlimit, h, sizeof(h)),
 				d.d_bwarns,
-				time_to_string(d.d_btimer, qflags));
+				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
 				(unsigned long long)d.d_bcount >> 1,
 				(unsigned long long)d.d_blk_softlimit >> 1,
 				(unsigned long long)d.d_blk_hardlimit >> 1,
 				d.d_bwarns,
-				time_to_string(d.d_btimer, qflags));
+				time_to_string(timer, qflags));
 	}
 	if (form & XFS_INODE_QUOTA) {
+		timer = d.d_itimer;
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_ino_hardlimit && d.d_icount > d.d_ino_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -429,16 +432,17 @@ report_mount(
 				num_to_string(d.d_ino_softlimit, s, sizeof(s)),
 				num_to_string(d.d_ino_hardlimit, h, sizeof(h)),
 				d.d_iwarns,
-				time_to_string(d.d_itimer, qflags));
+				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
 				(unsigned long long)d.d_icount,
 				(unsigned long long)d.d_ino_softlimit,
 				(unsigned long long)d.d_ino_hardlimit,
 				d.d_iwarns,
-				time_to_string(d.d_itimer, qflags));
+				time_to_string(timer, qflags));
 	}
 	if (form & XFS_RTBLOCK_QUOTA) {
+		timer = d.d_rtbtimer;
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_rtb_hardlimit && d.d_rtbcount > d.d_rtb_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -450,14 +454,14 @@ report_mount(
 				bbs_to_string(d.d_rtb_softlimit, s, sizeof(s)),
 				bbs_to_string(d.d_rtb_hardlimit, h, sizeof(h)),
 				d.d_rtbwarns,
-				time_to_string(d.d_rtbtimer, qflags));
+				time_to_string(timer, qflags));
 		else
 			fprintf(fp, " %10llu %10llu %10llu     %02d %9s",
 				(unsigned long long)d.d_rtbcount >> 1,
 				(unsigned long long)d.d_rtb_softlimit >> 1,
 				(unsigned long long)d.d_rtb_hardlimit >> 1,
 				d.d_rtbwarns,
-				time_to_string(d.d_rtbtimer, qflags));
+				time_to_string(timer, qflags));
 	}
 	fputc('\n', fp);
 	return 1;
diff --git a/quota/util.c b/quota/util.c
index 50470aba7b05..361d2a8ef5c6 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -18,11 +18,12 @@
 
 char *
 time_to_string(
-	time_t		origin,
+	time64_t	origin,
 	uint		flags)
 {
 	static char	timestamp[32];
-	time_t		now, timer;
+	time64_t	timer;
+	time_t		now;
 	uint		days, hours, minutes, seconds;
 
 	if (flags & ABSOLUTE_FLAG) {

