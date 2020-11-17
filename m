Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07C4C2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 17:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2126E2465E
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 17:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fng6sgPg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKQRp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 12:45:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:32850 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgKQRp0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 12:45:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AHHiEVY012368;
        Tue, 17 Nov 2020 17:45:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6wmXXO5IKies/J1d0OH1kINTm60US/70V2/m5F2D/1Q=;
 b=fng6sgPgMBYKaPD6+lyWnXHwTpjhL6Ijomx3rfbSyRjpYja5LAk62CqednEkjVpCkQHH
 RAivYrY08PDbxd9saVYE/oouFpJHJctRoWd8x35diQLAHj8VPZfLcESe6Nvxffuu0gNc
 1pn/hutfxF1ify7TrQ0pSzlZoG9O2+mZwZEqHRVKphts454IWsMhH5aRoCUe9aC/y8Er
 7DuYKbafmnION8soVUsoXbXAMi3B6fI5PU2lwfyjxeMlZ+O5IayYxw5duDf8wyUiyTGX
 CR3cVS4z6FXFYMY3dLGXPwmCpK07TQZM64kN+IdLnPdbwkxz3o2IvATGE0shXVzTgirr EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rav22g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 17:45:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AHHfaJ8162234;
        Tue, 17 Nov 2020 17:45:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34usptpwy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 17:45:23 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AHHjMen009502;
        Tue, 17 Nov 2020 17:45:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Nov 2020 09:45:22 -0800
Date:   Tue, 17 Nov 2020 09:45:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 20/26] xfs_db: report bigtime format timestamps
Message-ID: <20201117174521.GY9695@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537615.881414.8162037930017365466.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375537615.881414.8162037930017365466.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=3 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=3 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Report the large format timestamps in a human-readable manner if it is
possible to do so without loss of information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: skip the build bug stuff and check directly for information loss in
the time64_t -> time_t conversion
---
 db/fprint.c              |   73 +++++++++++++++++++++++++++++++++-------------
 db/inode.c               |    4 ++-
 db/sb.c                  |    2 +
 libxfs/libxfs_api_defs.h |    1 +
 4 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/db/fprint.c b/db/fprint.c
index 7ceab29cc608..65accfda3fe4 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -112,23 +112,50 @@ fp_sarray(
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
+	time64_t		tt_sec = tt;
 	char			*c;
+
+	/*
+	 * Stupid time_t shenanigans -- POSIX.1-2017 only requires that this
+	 * type represent a time in seconds.  Since we have no idea if our
+	 * time64_t filesystem timestamps can actually be represented by the C
+	 * library, we resort to converting the input value from time64_t to
+	 * time_t and back to time64_t to check for information loss.  If so,
+	 * we print the raw value; otherwise we print a human-readable value.
+	 */
+	if (tt_sec != sec)
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
@@ -139,10 +166,8 @@ fp_time(
 
 		ts = obj + byteize(bitpos);
 		tv = libxfs_inode_from_disk_ts(obj, *ts);
-		t = tv.tv_sec;
 
-		c = ctime(&t);
-		dbprintf("%24.24s", c);
+		fp_time64(tv.tv_sec);
 
 		if (i < count - 1)
 			dbprintf(" ");
@@ -195,7 +220,8 @@ fp_qtimer(
 	int			base,
 	int			array)
 {
-	uint32_t		sec;
+	struct xfs_disk_dquot	*ddq = obj;
+	time64_t		sec;
 	__be32			*t;
 	int			bitpos;
 	int			i;
@@ -208,9 +234,16 @@ fp_qtimer(
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
index cfc2e32023fc..3608508a7eb8 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -800,6 +800,8 @@ version_string(
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
