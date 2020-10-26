Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B39BC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DCF820872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vq1dpRra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407148AbgJZXgV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407121AbgJZXgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOgRg164668;
        Mon, 26 Oct 2020 23:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nqCnFM5BmqtHSGVzdmaNIWx/gKtgVGlf8/0UOFeHchs=;
 b=vq1dpRraZwhi2AvFpNnccO9yvrDKRQ1fgnWlUPWGte0An5+KTScJhnzu2zwtJW0MdSzb
 XvkFDJryeL2yYM3othuYTDL7dMyjMQMuepP2LQaclYQKPF89ZllIPUtSnlWJDTbOQs1z
 ups1iNlxd/eYFFMpbCOV4YgrPV6sjSh062JQ+yHgradmCTgGX0h7B4ras1Wo0coM/tT6
 MDWKC3HW73FNn31kvG7EnNGnv7fYVfJRauE9wvp6idbjim0gwUVamXTxFKKEE0PU3Qpp
 HZajmP+karisg6FtTu6EXDne134glOdQJrSiZLPhzh2EDVOAG3muNkq4n5qWn1syaYjg gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3vutm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPF6J120971;
        Mon, 26 Oct 2020 23:36:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6va6r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:18 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNaHDg008153;
        Mon, 26 Oct 2020 23:36:17 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:17 -0700
Subject: [PATCH 20/26] xfs_db: report bigtime format timestamps
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:16 -0700
Message-ID: <160375537615.881414.8162037930017365466.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Report the large format timestamps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fprint.c              |   66 ++++++++++++++++++++++++++++++++--------------
 db/inode.c               |    4 ++-
 db/sb.c                  |    2 +
 libxfs/libxfs_api_defs.h |    1 +
 4 files changed, 52 insertions(+), 21 deletions(-)


diff --git a/db/fprint.c b/db/fprint.c
index 7ceab29cc608..48562f0c9518 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -112,23 +112,43 @@ fp_sarray(
 	return 1;
 }
 
-int
-fp_time(
-	void			*obj,
-	int			bit,
-	int			count,
-	char			*fmtstr,
-	int			size,
-	int			arg,
-	int			base,
-	int			array)
+static void
+fp_time64(
+	time64_t		sec)
 {
-	struct timespec64	tv;
-	xfs_timestamp_t		*ts;
-	int			bitpos;
+	time_t			tt = sec;
 	char			*c;
+
+	BUILD_BUG_ON(sizeof(long) != sizeof(time_t));
+
+	if (sec > LONG_MAX || sec < LONG_MIN)
+		goto raw;
+
+	c = ctime(&tt);
+	if (!c)
+		goto raw;
+
+	dbprintf("%24.24s", c);
+	return;
+raw:
+	dbprintf("%lld", sec);
+}
+
+int
+fp_time(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	struct timespec64	tv;
+	xfs_timestamp_t		*ts;
+	int			bitpos;
 	int			i;
-	time_t			t;
 
 	ASSERT(bitoffs(bit) == 0);
 	for (i = 0, bitpos = bit;
@@ -139,10 +159,8 @@ fp_time(
 
 		ts = obj + byteize(bitpos);
 		tv = libxfs_inode_from_disk_ts(obj, *ts);
-		t = tv.tv_sec;
 
-		c = ctime(&t);
-		dbprintf("%24.24s", c);
+		fp_time64(tv.tv_sec);
 
 		if (i < count - 1)
 			dbprintf(" ");
@@ -195,7 +213,8 @@ fp_qtimer(
 	int			base,
 	int			array)
 {
-	uint32_t		sec;
+	struct xfs_disk_dquot	*ddq = obj;
+	time64_t		sec;
 	__be32			*t;
 	int			bitpos;
 	int			i;
@@ -208,9 +227,16 @@ fp_qtimer(
 			dbprintf("%d:", i + base);
 
 		t = obj + byteize(bitpos);
-		sec = be32_to_cpu(*t);
+		sec = libxfs_dquot_from_disk_ts(ddq, *t);
 
-		dbprintf("%u", sec);
+		/*
+		 * Display the raw value if it's the default grace expiration
+		 * period (root dquot) or if the quota has not expired.
+		 */
+		if (ddq->d_id == 0 || sec == 0)
+			dbprintf("%lld", sec);
+		else
+			fp_time64(sec);
 
 		if (i < count - 1)
 			dbprintf(" ");
diff --git a/db/inode.c b/db/inode.c
index cc0e680aadea..f0e08ebf5ad9 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -175,10 +175,12 @@ const field_t	inode_v3_flds[] = {
 	{ "dax", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_DAX_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "bigtime", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
-
 const field_t	timestamp_flds[] = {
 	{ "sec", FLDT_TIME, OI(0), C1, 0, TYP_NONE },
 	{ "nsec", FLDT_NSEC, OI(0), C1, 0, TYP_NONE },
diff --git a/db/sb.c b/db/sb.c
index b1033e5ef7f0..a04f36c73255 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -727,6 +727,8 @@ version_string(
 		strcat(s, ",REFLINK");
 	if (xfs_sb_version_hasinobtcounts(sbp))
 		strcat(s, ",INOBTCNT");
+	if (xfs_sb_version_hasbigtime(sbp))
+		strcat(s, ",BIGTIME");
 	return s;
 }
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 40da71ab3163..419e6d9888cf 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -99,6 +99,7 @@
 #define xfs_dir_replace			libxfs_dir_replace
 
 #define xfs_dqblk_repair		libxfs_dqblk_repair
+#define xfs_dquot_from_disk_ts		libxfs_dquot_from_disk_ts
 #define xfs_dquot_verify		libxfs_dquot_verify
 
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves

