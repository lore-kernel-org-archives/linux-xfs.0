Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DA2C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E43982063A
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T5g/fH3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgHQXAc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41712 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgHQXA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwJTF148426;
        Mon, 17 Aug 2020 23:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wpwnSpYFpo/+VcA1AcyccffYkBwIaBExY2vEe97kTlY=;
 b=T5g/fH3aBcQfxOBN8hm9gARYiJZGpMzfAc7lHg2OgwggaplL73tbxi/hx3VzU9LTIG8x
 dFu/KoJjWiqm98lSXcTdlhRnqY8+sSs9zePtdtj91+m/SWMaCVahmMhPw91RarW0AvCA
 QzrGoXqEYWRRpfdj/h7fPxpowXxRxwjD8wP2qQHXWJVPA4OXc2dpI5yaatxTwOqoJgrS
 N2wMlgA5O20Q79t6PYf08dwrqUUQbMK+HN6n+OBvHwY2O/SCHv2yNHYEBVwVKhsYsa7N
 e5f7FWtDPN4RXMEcr+cx84MA+5x3GSTpH2fswEAR4kcwauAvXKdCsv2YqFj9cBb/a85O 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn1g3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvjQj113983;
        Mon, 17 Aug 2020 23:00:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32xsm18t3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:00:23 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HN0NPh015334;
        Mon, 17 Aug 2020 23:00:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:00:23 -0700
Subject: [PATCH 14/18] xfs_db: report bigtime format timestamps
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:00:22 -0700
Message-ID: <159770522219.3958786.9075094123951100725.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Report the large format timestamps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/dquot.c               |   31 +++++++++++-
 db/field.c               |    6 ++
 db/field.h               |    3 +
 db/fprint.c              |  120 ++++++++++++++++++++++++++++++++++++++++++++++
 db/fprint.h              |    6 ++
 db/inode.c               |   28 ++++++++++-
 db/sb.c                  |    2 +
 libxfs/libxfs_api_defs.h |    3 +
 8 files changed, 194 insertions(+), 5 deletions(-)


diff --git a/db/dquot.c b/db/dquot.c
index edfcb0ca0744..30f4e6523c39 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -44,6 +44,22 @@ const field_t	dqblk_flds[] = {
 	{ NULL }
 };
 
+static int
+dquot_timestamp_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_sb_version_hasbigtime(&mp->m_sb) ? 0 : 1;
+}
+
+static int
+dquot_bigtimestamp_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_sb_version_hasbigtime(&mp->m_sb) ? 1 : 0;
+}
+
 #define	DOFF(f)		bitize(offsetof(struct xfs_disk_dquot, d_ ## f))
 const field_t	disk_dquot_flds[] = {
 	{ "magic", FLDT_UINT16X, OI(DOFF(magic)), C1, 0, TYP_NONE },
@@ -60,8 +76,14 @@ const field_t	disk_dquot_flds[] = {
 	  TYP_NONE },
 	{ "bcount", FLDT_QCNT, OI(DOFF(bcount)), C1, 0, TYP_NONE },
 	{ "icount", FLDT_QCNT, OI(DOFF(icount)), C1, 0, TYP_NONE },
-	{ "itimer", FLDT_INT32D, OI(DOFF(itimer)), C1, 0, TYP_NONE },
-	{ "btimer", FLDT_INT32D, OI(DOFF(btimer)), C1, 0, TYP_NONE },
+	{ "itimer", FLDT_INT32D, OI(DOFF(itimer)), dquot_timestamp_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "btimer", FLDT_INT32D, OI(DOFF(btimer)), dquot_timestamp_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "itimer", FLDT_BTQTIMER, OI(DOFF(itimer)), dquot_bigtimestamp_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "btimer", FLDT_BTQTIMER, OI(DOFF(btimer)), dquot_bigtimestamp_count,
+	  FLD_COUNT, TYP_NONE },
 	{ "iwarns", FLDT_QWARNCNT, OI(DOFF(iwarns)), C1, 0, TYP_NONE },
 	{ "bwarns", FLDT_QWARNCNT, OI(DOFF(bwarns)), C1, 0, TYP_NONE },
 	{ "pad0", FLDT_UINT32X, OI(DOFF(pad0)), C1, FLD_SKIPALL, TYP_NONE },
@@ -70,7 +92,10 @@ const field_t	disk_dquot_flds[] = {
 	{ "rtb_softlimit", FLDT_QCNT, OI(DOFF(rtb_softlimit)), C1, 0,
 	  TYP_NONE },
 	{ "rtbcount", FLDT_QCNT, OI(DOFF(rtbcount)), C1, 0, TYP_NONE },
-	{ "rtbtimer", FLDT_INT32D, OI(DOFF(rtbtimer)), C1, 0, TYP_NONE },
+	{ "rtbtimer", FLDT_INT32D, OI(DOFF(rtbtimer)), dquot_timestamp_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "rtbtimer", FLDT_BTQTIMER, OI(DOFF(rtbtimer)),
+	  dquot_bigtimestamp_count, FLD_COUNT, TYP_NONE },
 	{ "rtbwarns", FLDT_QWARNCNT, OI(DOFF(rtbwarns)), C1, 0, TYP_NONE },
 	{ "pad", FLDT_UINT16X, OI(DOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
diff --git a/db/field.c b/db/field.c
index cf3002c730e6..fad17b1f082e 100644
--- a/db/field.c
+++ b/db/field.c
@@ -351,6 +351,12 @@ const ftattr_t	ftattrtab[] = {
 	  NULL, NULL },
 	{ FLDT_TIMESTAMP, "timestamp", NULL, (char *)timestamp_flds,
 	  SI(bitsz(union xfs_timestamp)), 0, NULL, timestamp_flds },
+	{ FLDT_BTSEC, "btsec", fp_btsec, NULL, SI(bitsz(uint64_t)), 0, NULL,
+	  NULL },
+	{ FLDT_BTNSEC, "btnsec", fp_btnsec, NULL, SI(bitsz(uint64_t)), 0, NULL,
+	  NULL },
+	{ FLDT_BTQTIMER, "btqtimer", fp_btqtimer, NULL, SI(bitsz(uint32_t)), 0,
+	  NULL, NULL },
 	{ FLDT_UINT1, "uint1", fp_num, "%u", SI(1), 0, NULL, NULL },
 	{ FLDT_UINT16D, "uint16d", fp_num, "%u", SI(bitsz(uint16_t)), 0, NULL,
 	  NULL },
diff --git a/db/field.h b/db/field.h
index 15065373de39..0d27cd085b13 100644
--- a/db/field.h
+++ b/db/field.h
@@ -170,6 +170,9 @@ typedef enum fldt	{
 
 	FLDT_TIME,
 	FLDT_TIMESTAMP,
+	FLDT_BTSEC,
+	FLDT_BTNSEC,
+	FLDT_BTQTIMER,
 	FLDT_UINT1,
 	FLDT_UINT16D,
 	FLDT_UINT16O,
diff --git a/db/fprint.c b/db/fprint.c
index c9d07e1bca7e..3a4f839b355d 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -19,6 +19,7 @@
 #include "sig.h"
 #include "malloc.h"
 #include "io.h"
+#include "init.h"
 
 int
 fp_charns(
@@ -145,6 +146,125 @@ fp_time(
 	return 1;
 }
 
+static void
+fp_timespec64(
+	struct timespec64	*ts)
+{
+	BUILD_BUG_ON(sizeof(long) != sizeof(time_t));
+
+	if (ts->tv_sec > LONG_MAX || ts->tv_sec < LONG_MIN) {
+		dbprintf("%lld", (long long)ts->tv_sec);
+	} else {
+		time_t	tt = ts->tv_sec;
+		char	*c;
+
+		c = ctime(&tt);
+		dbprintf("%24.24s", c);
+	}
+}
+
+int
+fp_btsec(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	struct timespec64	ts;
+	union xfs_timestamp	*xts;
+	int			bitpos;
+	int			i;
+
+	ASSERT(bitoffs(bit) == 0);
+	for (i = 0, bitpos = bit;
+	     i < count && !seenint();
+	     i++, bitpos += size) {
+		if (array)
+			dbprintf("%d:", i + base);
+		xts = obj + byteize(bitpos);
+		libxfs_inode_from_disk_timestamp(obj, &ts, xts);
+		fp_timespec64(&ts);
+		if (i < count - 1)
+			dbprintf(" ");
+	}
+	return 1;
+}
+
+int
+fp_btnsec(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	struct timespec64	ts;
+	union xfs_timestamp	*xts;
+	int			bitpos;
+	int			i;
+
+	ASSERT(bitoffs(bit) == 0);
+	for (i = 0, bitpos = bit;
+	     i < count && !seenint();
+	     i++, bitpos += size) {
+		if (array)
+			dbprintf("%d:", i + base);
+		xts = obj + byteize(bitpos);
+		libxfs_inode_from_disk_timestamp(obj, &ts, xts);
+		dbprintf("%u", ts.tv_nsec);
+		if (i < count - 1)
+			dbprintf(" ");
+	}
+	return 1;
+}
+
+int
+fp_btqtimer(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	struct timespec64	ts = { 0 };
+	struct xfs_disk_dquot	*ddq = obj;
+	__be32			*t;
+	int			bitpos;
+	int			i;
+
+	ASSERT(bitoffs(bit) == 0);
+	for (i = 0, bitpos = bit;
+	     i < count && !seenint();
+	     i++, bitpos += size) {
+		if (array)
+			dbprintf("%d:", i + base);
+		t = obj + byteize(bitpos);
+		libxfs_dquot_from_disk_timestamp(ddq, &ts.tv_sec, *t);
+
+		/*
+		 * Display the raw value if it's the default grace expiration
+		 * period (root dquot) or if the quota has not expired.
+		 */
+		if (ddq->d_id == 0 || ts.tv_sec == 0)
+			dbprintf("%llu", (unsigned long long)ts.tv_sec);
+		else
+			fp_timespec64(&ts);
+		if (i < count - 1)
+			dbprintf(" ");
+	}
+	return 1;
+}
+
 /*ARGSUSED*/
 int
 fp_uuid(
diff --git a/db/fprint.h b/db/fprint.h
index c958dca0ed92..a33dcd11248d 100644
--- a/db/fprint.h
+++ b/db/fprint.h
@@ -15,6 +15,12 @@ extern int	fp_sarray(void *obj, int bit, int count, char *fmtstr, int size,
 			  int arg, int base, int array);
 extern int	fp_time(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
+extern int	fp_btsec(void *obj, int bit, int count, char *fmtstr, int size,
+			int arg, int base, int array);
+extern int	fp_btnsec(void *obj, int bit, int count, char *fmtstr, int size,
+			int arg, int base, int array);
+extern int	fp_btqtimer(void *obj, int bit, int count, char *fmtstr,
+			int size, int arg, int base, int array);
 extern int	fp_uuid(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
 extern int	fp_crc(void *obj, int bit, int count, char *fmtstr, int size,
diff --git a/db/inode.c b/db/inode.c
index 25112bb5e4d8..5fbfd4ddb5f5 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -175,14 +175,38 @@ const field_t	inode_v3_flds[] = {
 	{ "dax", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_DAX_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "bigtime", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
+static int
+inode_timestamp_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_sb_version_hasbigtime(&mp->m_sb) ? 0 : 1;
+}
+
+static int
+inode_bigtimestamp_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_sb_version_hasbigtime(&mp->m_sb) ? 1 : 0;
+}
 
 #define	TOFF(f)	bitize(offsetof(union xfs_timestamp, t_ ## f))
 const field_t	timestamp_flds[] = {
-	{ "sec", FLDT_TIME, OI(TOFF(sec)), C1, 0, TYP_NONE },
-	{ "nsec", FLDT_NSEC, OI(TOFF(nsec)), C1, 0, TYP_NONE },
+	{ "sec", FLDT_TIME, OI(TOFF(sec)), inode_timestamp_count, FLD_COUNT,
+		TYP_NONE },
+	{ "nsec", FLDT_NSEC, OI(TOFF(nsec)), inode_timestamp_count, FLD_COUNT,
+		TYP_NONE },
+	{ "sec", FLDT_BTSEC, OI(TOFF(bigtime)), inode_bigtimestamp_count,
+		FLD_COUNT, TYP_NONE },
+	{ "nsec", FLDT_BTNSEC, OI(TOFF(bigtime)), inode_bigtimestamp_count,
+		FLD_COUNT, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index 33d9f7df49bb..c68bb9a958e7 100644
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
index 4ee02473df0d..b83dc48a4802 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -116,6 +116,7 @@ struct timespec64 {
 #define xfs_dir_replace			libxfs_dir_replace
 
 #define xfs_dqblk_repair		libxfs_dqblk_repair
+#define xfs_dquot_from_disk_timestamp	libxfs_dquot_from_disk_timestamp
 #define xfs_dquot_verify		libxfs_dquot_verify
 
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
@@ -137,7 +138,9 @@ struct timespec64 {
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
+#define xfs_inode_from_disk_timestamp	libxfs_inode_from_disk_timestamp
 #define xfs_inode_to_disk		libxfs_inode_to_disk
+#define xfs_inode_to_disk_timestamp	libxfs_inode_to_disk_timestamp
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
 

