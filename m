Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83953C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C02207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YV0W90+6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406682AbgJZXet (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36754 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406568AbgJZXet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP0PG157924;
        Mon, 26 Oct 2020 23:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EwtoCEdhQaz5AJIq9l8EaCP+xv/bRJI8tQSLYf5AI7E=;
 b=YV0W90+6GjEuP5Bz1NouEQ/H3J9YWrdN7/fIO4R8DGHKCoGHHW0YzRkkYcXTjEw8DVI5
 P0XNIvkT9/ARdryO3lIKzO8Sp8AxyenELjDEkvK57xigh3rca4tFCr+cjF2L8Z8fcxdD
 W8Lj5mqgtwkLamIoSg/G1ZB7VFQ2VdL/VrMnTkbgnOGkmX4jH3/HP2UZ73rORkG/mX7L
 MHvGGAhyXuKKZDrBegt4iwnne7P9KiebTUg+QqTt4H/R/e1dWbKQvmNcZTRpcpxHvn4O
 SZWviHBXiRqxoyFmdxjJ4eASnZLfXwKTD8XyZBWdEfhGHiSZ+dL/Ji/uFJuJIPEkH+fZ Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQE78032534;
        Mon, 26 Oct 2020 23:34:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1q2bfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNYjao007612;
        Mon, 26 Oct 2020 23:34:45 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:45 -0700
Subject: [PATCH 06/26] xfs_db: refactor timestamp printing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:44 -0700
Message-ID: <160375528453.881414.12498523896617282388.stgit@magnolia>
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

Introduce type-specific printing functions to xfs_db to print an
xfs_timestamp instead of open-coding the timestamp decoding.  This is
needed to stay ahead of changes that we're going to make to
xfs_timestamp_t in the following patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/field.c  |    8 ++++---
 db/fprint.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 db/fprint.h |    2 ++
 db/inode.c  |    5 ++--
 4 files changed, 60 insertions(+), 22 deletions(-)


diff --git a/db/field.c b/db/field.c
index aa0154d82eb7..f0316aeb4a86 100644
--- a/db/field.c
+++ b/db/field.c
@@ -334,8 +334,8 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_INT8D, "int8d", fp_num, "%d", SI(bitsz(int8_t)), FTARG_SIGNED,
 	  NULL, NULL },
-	{ FLDT_NSEC, "nsec", fp_num, "%09d", SI(bitsz(int32_t)), FTARG_SIGNED,
-	  NULL, NULL },
+	{ FLDT_NSEC, "nsec", fp_nsec, NULL, SI(bitsz(xfs_timestamp_t)),
+	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_QCNT, "qcnt", fp_num, "%llu", SI(bitsz(xfs_qcnt_t)), 0, NULL,
 	  NULL },
 	{ FLDT_QWARNCNT, "qwarncnt", fp_num, "%u", SI(bitsz(xfs_qwarncnt_t)), 0,
@@ -347,8 +347,8 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_SYMLINK_CRC, "symlink", NULL, (char *)symlink_crc_flds,
 	  symlink_size, FTARG_SIZE, NULL, symlink_crc_flds },
 
-	{ FLDT_TIME, "time", fp_time, NULL, SI(bitsz(int32_t)), FTARG_SIGNED,
-	  NULL, NULL },
+	{ FLDT_TIME, "time", fp_time, NULL, SI(bitsz(xfs_timestamp_t)),
+	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_TIMESTAMP, "timestamp", NULL, (char *)timestamp_flds,
 	  SI(bitsz(xfs_timestamp_t)), 0, NULL, timestamp_flds },
 	{ FLDT_UINT1, "uint1", fp_num, "%u", SI(1), 0, NULL, NULL },
diff --git a/db/fprint.c b/db/fprint.c
index c9d07e1bca7e..feec02c5de99 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -112,22 +112,22 @@ fp_sarray(
 	return 1;
 }
 
-/*ARGSUSED*/
 int
 fp_time(
-	void	*obj,
-	int	bit,
-	int	count,
-	char	*fmtstr,
-	int	size,
-	int	arg,
-	int	base,
-	int	array)
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
 {
-	int	bitpos;
-	char	*c;
-	int	i;
-	time_t  t;
+	xfs_timestamp_t		*ts;
+	int			bitpos;
+	char			*c;
+	int			i;
+	time_t			t;
 
 	ASSERT(bitoffs(bit) == 0);
 	for (i = 0, bitpos = bit;
@@ -135,10 +135,47 @@ fp_time(
 	     i++, bitpos += size) {
 		if (array)
 			dbprintf("%d:", i + base);
-		t = (time_t)getbitval((char *)obj + byteize(bitpos), 0,
-				sizeof(int32_t) * 8, BVSIGNED);
+
+		ts = obj + byteize(bitpos);
+		t = (int)be32_to_cpu(ts->t_sec);
+
 		c = ctime(&t);
 		dbprintf("%24.24s", c);
+
+		if (i < count - 1)
+			dbprintf(" ");
+	}
+	return 1;
+}
+
+int
+fp_nsec(
+	void			*obj,
+	int			bit,
+	int			count,
+	char			*fmtstr,
+	int			size,
+	int			arg,
+	int			base,
+	int			array)
+{
+	xfs_timestamp_t		*ts;
+	unsigned int		nsec;
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
+		ts = obj + byteize(bitpos);
+		nsec = (int)be32_to_cpu(ts->t_nsec);
+
+		dbprintf("%u", nsec);
+
 		if (i < count - 1)
 			dbprintf(" ");
 	}
diff --git a/db/fprint.h b/db/fprint.h
index c958dca0ed92..bfeed15ca7c4 100644
--- a/db/fprint.h
+++ b/db/fprint.h
@@ -15,6 +15,8 @@ extern int	fp_sarray(void *obj, int bit, int count, char *fmtstr, int size,
 			  int arg, int base, int array);
 extern int	fp_time(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
+extern int	fp_nsec(void *obj, int bit, int count, char *fmtstr, int size,
+			int arg, int base, int array);
 extern int	fp_uuid(void *obj, int bit, int count, char *fmtstr, int size,
 			int arg, int base, int array);
 extern int	fp_crc(void *obj, int bit, int count, char *fmtstr, int size,
diff --git a/db/inode.c b/db/inode.c
index f13150c96aa9..cc0e680aadea 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -179,10 +179,9 @@ const field_t	inode_v3_flds[] = {
 };
 
 
-#define	TOFF(f)	bitize(offsetof(xfs_timestamp_t, t_ ## f))
 const field_t	timestamp_flds[] = {
-	{ "sec", FLDT_TIME, OI(TOFF(sec)), C1, 0, TYP_NONE },
-	{ "nsec", FLDT_NSEC, OI(TOFF(nsec)), C1, 0, TYP_NONE },
+	{ "sec", FLDT_TIME, OI(0), C1, 0, TYP_NONE },
+	{ "nsec", FLDT_NSEC, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
 };
 

