Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4B9C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD99C207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KBviMPBt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406859AbgJZXez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54944 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406857AbgJZXez (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOajr164649;
        Mon, 26 Oct 2020 23:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dlcLvRhsQhPllJH2ujBxQ8hkw7JYFdhsMw+mkYoS+nc=;
 b=KBviMPBt4d0sTqb6fdxY6Ze/NYQRlBFL8N3ckgwQqcl2rx1qe5HNbker4owFWF1Uq+cm
 m4MYeWmnkjH+hJznZZ0qWw+p7qIDWospbYfo2xnqtVMYO9yfG9bagoB6aEVp/RMpaOcp
 a3KxL1aghok73Rssv3/ra+GLkbKWRIfeN2OBwKqAtUlnjbdmkcGpuqiT9IXtE6IvwsuY
 oSU/jrkItmZhxqM52OVeFJiqGrNRcXPwR5apZh5qcW9CpnEoi7zsn8iRV7yucDsQFbIN
 5PKwxiuJS/bCnQ2/2oYrZ+VkFi4DzR3jcsos0rj8DzIBUaItNSrTQklvk4GGhiftLqVE TA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3vuqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxkQ110463;
        Mon, 26 Oct 2020 23:34:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wfs3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:52 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNYpCw007621;
        Mon, 26 Oct 2020 23:34:51 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:51 -0700
Subject: [PATCH 07/26] xfs_db: refactor quota timer printing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:50 -0700
Message-ID: <160375529066.881414.13277074782068895997.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
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

Introduce type-specific printing functions to xfs_db to print a quota
timer instead of printing a raw int32 value.  This is needed to stay
ahead of changes that we're going to make to the quota timer format in
the following patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/dquot.c  |    6 +++---
 db/field.c  |    2 ++
 db/field.h  |    1 +
 db/fprint.c |   34 ++++++++++++++++++++++++++++++++++
 db/fprint.h |    2 ++
 5 files changed, 42 insertions(+), 3 deletions(-)


diff --git a/db/dquot.c b/db/dquot.c
index 1392aa1673ae..e52000f2e6ee 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -60,8 +60,8 @@ const field_t	disk_dquot_flds[] = {
 	  TYP_NONE },
 	{ "bcount", FLDT_QCNT, OI(DOFF(bcount)), C1, 0, TYP_NONE },
 	{ "icount", FLDT_QCNT, OI(DOFF(icount)), C1, 0, TYP_NONE },
-	{ "itimer", FLDT_INT32D, OI(DOFF(itimer)), C1, 0, TYP_NONE },
-	{ "btimer", FLDT_INT32D, OI(DOFF(btimer)), C1, 0, TYP_NONE },
+	{ "itimer", FLDT_QTIMER, OI(DOFF(itimer)), C1, 0, TYP_NONE },
+	{ "btimer", FLDT_QTIMER, OI(DOFF(btimer)), C1, 0, TYP_NONE },
 	{ "iwarns", FLDT_QWARNCNT, OI(DOFF(iwarns)), C1, 0, TYP_NONE },
 	{ "bwarns", FLDT_QWARNCNT, OI(DOFF(bwarns)), C1, 0, TYP_NONE },
 	{ "pad0", FLDT_UINT32X, OI(DOFF(pad0)), C1, FLD_SKIPALL, TYP_NONE },
@@ -70,7 +70,7 @@ const field_t	disk_dquot_flds[] = {
 	{ "rtb_softlimit", FLDT_QCNT, OI(DOFF(rtb_softlimit)), C1, 0,
 	  TYP_NONE },
 	{ "rtbcount", FLDT_QCNT, OI(DOFF(rtbcount)), C1, 0, TYP_NONE },
-	{ "rtbtimer", FLDT_INT32D, OI(DOFF(rtbtimer)), C1, 0, TYP_NONE },
+	{ "rtbtimer", FLDT_QTIMER, OI(DOFF(rtbtimer)), C1, 0, TYP_NONE },
 	{ "rtbwarns", FLDT_QWARNCNT, OI(DOFF(rtbwarns)), C1, 0, TYP_NONE },
 	{ "pad", FLDT_UINT16X, OI(DOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
diff --git a/db/field.c b/db/field.c
index f0316aeb4a86..51268938a9d3 100644
--- a/db/field.c
+++ b/db/field.c
@@ -351,6 +351,8 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_TIMESTAMP, "timestamp", NULL, (char *)timestamp_flds,
 	  SI(bitsz(xfs_timestamp_t)), 0, NULL, timestamp_flds },
+	{ FLDT_QTIMER, "qtimer", fp_qtimer, NULL, SI(bitsz(uint32_t)), 0,
+	  NULL, NULL },
 	{ FLDT_UINT1, "uint1", fp_num, "%u", SI(1), 0, NULL, NULL },
 	{ FLDT_UINT16D, "uint16d", fp_num, "%u", SI(bitsz(uint16_t)), 0, NULL,
 	  NULL },
diff --git a/db/field.h b/db/field.h
index 15065373de39..387c189ec87a 100644
--- a/db/field.h
+++ b/db/field.h
@@ -170,6 +170,7 @@ typedef enum fldt	{
 
 	FLDT_TIME,
 	FLDT_TIMESTAMP,
+	FLDT_QTIMER,
 	FLDT_UINT1,
 	FLDT_UINT16D,
 	FLDT_UINT16O,
diff --git a/db/fprint.c b/db/fprint.c
index feec02c5de99..996e9325ddcc 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -182,6 +182,40 @@ fp_nsec(
 	return 1;
 }
 
+int
+fp_qtimer(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	uint32_t		sec;
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
+
+		t = obj + byteize(bitpos);
+		sec = be32_to_cpu(*t);
+
+		dbprintf("%u", sec);
+
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
index bfeed15ca7c4..a1ea935ca531 100644
--- a/db/fprint.h
+++ b/db/fprint.h
@@ -17,6 +17,8 @@ extern int	fp_time(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
 extern int	fp_nsec(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
+extern int	fp_qtimer(void *obj, int bit, int count, char *fmtstr, int size,
+			int arg, int base, int array);
 extern int	fp_uuid(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
 extern int	fp_crc(void *obj, int bit, int count, char *fmtstr, int size,

