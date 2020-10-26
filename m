Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2C1C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BCE0207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tf7GNhc9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406572AbgJZXeg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36612 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406563AbgJZXef (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP0Sv157931;
        Mon, 26 Oct 2020 23:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UkgJw6KwOqEuNAnxNFJo3okazcZL+JLu4M4Z/sasVkk=;
 b=tf7GNhc9W+ZHc0p3eiLNXhpOqvsXUcs4kJ2Ox+UU6SFqN1tcpm+aC7wK4Tjp4ZWurYSW
 39U3O/qp73/9SUu/2VQSrEotc5xSNB6wQkMC77CV+LU8mDxh3HF/OMg/dfbWu2N7zXMD
 0ws5KT3/m5SE/2ECuVNktTGXb0lygeyX72pye84hmtYMM4DCVLPnM0aq95HA/bWn+FSO
 b0/FpjliO04yedLZscmoaVcGY8C1x9nuI4yWyfOQfrA8v/5LBrNW2YgW6tHsY/DOtwwQ
 ccSjGz49J8Tv2nUTYfI/ydZr00eJNCbErlRZz1AmrcS2suN13HQBrVubl/fzsrUe3t7E dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNvE058345;
        Mon, 26 Oct 2020 23:34:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwukr8fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:33 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNYXsZ012566;
        Mon, 26 Oct 2020 23:34:33 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:33 -0700
Subject: [PATCH 04/26] libfrog: convert cvttime to return time64_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:31 -0700
Message-ID: <160375527139.881414.6476607474654532506.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
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

Change the cvttime function to return 64-bit time values so that we can
put them to use with the bigtime feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/convert.c |    6 +++---
 libfrog/convert.h |    2 +-
 quota/edit.c      |   14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/libfrog/convert.c b/libfrog/convert.c
index 6b8ff30de24a..0ceeb389682a 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -271,14 +271,14 @@ cvtstr(
 #define DAYS_TO_SECONDS(d)	((d) * HOURS_TO_SECONDS(24))
 #define WEEKS_TO_SECONDS(w)	((w) * DAYS_TO_SECONDS(7))
 
-unsigned long
+time64_t
 cvttime(
 	char		*s)
 {
-	unsigned long	i;
+	time64_t	i;
 	char		*sp;
 
-	i = strtoul(s, &sp, 0);
+	i = strtoll(s, &sp, 0);
 	if (i == 0 && sp == s)
 		return 0;
 	if (*sp == '\0')
diff --git a/libfrog/convert.h b/libfrog/convert.h
index b307d31ce955..3e5fbe055986 100644
--- a/libfrog/convert.h
+++ b/libfrog/convert.h
@@ -16,7 +16,7 @@ extern uint16_t	cvt_u16(char *s, int base);
 
 extern long long cvtnum(size_t blocksize, size_t sectorsize, const char *s);
 extern void cvtstr(double value, char *str, size_t sz);
-extern unsigned long cvttime(char *s);
+extern time64_t cvttime(char *s);
 
 extern uid_t	uid_from_string(char *user);
 extern gid_t	gid_from_string(char *group);
diff --git a/quota/edit.c b/quota/edit.c
index 01d358f740c8..b3cad024b1f1 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -419,13 +419,13 @@ restore_f(
 
 static void
 set_timer(
-	uint32_t	id,
-	uint		type,
-	uint		mask,
-	char		*dev,
-	uint		value)
+	uint32_t		id,
+	uint			type,
+	uint			mask,
+	char			*dev,
+	time64_t		value)
 {
-	fs_disk_quota_t	d;
+	struct fs_disk_quota	d;
 
 	memset(&d, 0, sizeof(d));
 
@@ -476,7 +476,7 @@ timer_f(
 	int		argc,
 	char		**argv)
 {
-	uint		value;
+	time64_t	value;
 	char		*name = NULL;
 	uint32_t	id = 0;
 	int		c, flags = 0, type = 0, mask = 0;

