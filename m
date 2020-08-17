Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D25DC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2414D2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F/MW0uLC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgHQW7e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:59:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgHQW7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:59:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwA1h164159;
        Mon, 17 Aug 2020 22:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KsVoNlKSsyBwR9+p8lqVgAQa91borSkza/R1bP1Ze9E=;
 b=F/MW0uLCy9u0aBJPl2t3NMrK2rAAB/KMqlkVmVQTmUDoJNsBztr9PniFqIsTqjhGqsUw
 t5C2gSq2imRX2mQiXacG4+SWIxBZD+cbBKJ+TayRngpMXnPHYM/jaYWEUx/fk486suxu
 Y7ab5xC6gV9U6DcthIilGKW5TEoACachZ7UGzyv+4Fypi6333dOLzfe2pDqrT2Zl9Jib
 0LATijIg6opfOagGZkVcDBVIpMoaLND4Ia3osVxnR9F166Lv+FlzzKBkZ/DTnK9xTbQs
 r5yyumLPccWj4EVc52WBLd1J+fxNksOIOInSs0kZTEnmOp2EQkU1LuhGCDzw8MqLHPvZ ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r1mu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:59:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvjCr113883;
        Mon, 17 Aug 2020 22:59:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32xsm18r0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:27 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMxQ9D017349;
        Mon, 17 Aug 2020 22:59:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:26 -0700
Subject: [PATCH 05/18] xfs: remove xfs_timestamp_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:25 -0700
Message-ID: <159770516555.3958786.9705266272309911121.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Kill this old typedef.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/field.c              |    2 +-
 db/inode.c              |    2 +-
 libxfs/xfs_format.h     |   12 ++++++------
 libxfs/xfs_log_format.h |   12 ++++++------
 4 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/db/field.c b/db/field.c
index aa0154d82eb7..0f41be636db4 100644
--- a/db/field.c
+++ b/db/field.c
@@ -350,7 +350,7 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_TIME, "time", fp_time, NULL, SI(bitsz(int32_t)), FTARG_SIGNED,
 	  NULL, NULL },
 	{ FLDT_TIMESTAMP, "timestamp", NULL, (char *)timestamp_flds,
-	  SI(bitsz(xfs_timestamp_t)), 0, NULL, timestamp_flds },
+	  SI(bitsz(struct xfs_timestamp)), 0, NULL, timestamp_flds },
 	{ FLDT_UINT1, "uint1", fp_num, "%u", SI(1), 0, NULL, NULL },
 	{ FLDT_UINT16D, "uint16d", fp_num, "%u", SI(bitsz(uint16_t)), 0, NULL,
 	  NULL },
diff --git a/db/inode.c b/db/inode.c
index f13150c96aa9..dfaf12816d75 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -179,7 +179,7 @@ const field_t	inode_v3_flds[] = {
 };
 
 
-#define	TOFF(f)	bitize(offsetof(xfs_timestamp_t, t_ ## f))
+#define	TOFF(f)	bitize(offsetof(struct xfs_timestamp, t_ ## f))
 const field_t	timestamp_flds[] = {
 	{ "sec", FLDT_TIME, OI(TOFF(sec)), C1, 0, TYP_NONE },
 	{ "nsec", FLDT_NSEC, OI(TOFF(nsec)), C1, 0, TYP_NONE },
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a60d4ed40946..d11adbbd1808 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -856,10 +856,10 @@ struct xfs_agfl {
  * Inode timestamps consist of signed 32-bit counters for seconds and
  * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
  */
-typedef struct xfs_timestamp {
+struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
-} xfs_timestamp_t;
+};
 
 /*
  * Smallest possible timestamp with traditional timestamps, which is
@@ -904,9 +904,9 @@ typedef struct xfs_dinode {
 	__be16		di_projid_hi;	/* higher part owner's project id */
 	__u8		di_pad[6];	/* unused, zeroed space */
 	__be16		di_flushiter;	/* incremented on flush */
-	xfs_timestamp_t	di_atime;	/* time last accessed */
-	xfs_timestamp_t	di_mtime;	/* time last modified */
-	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
+	struct xfs_timestamp di_atime;	/* time last accessed */
+	struct xfs_timestamp di_mtime;	/* time last modified */
+	struct xfs_timestamp di_ctime;	/* time created/inode modified */
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
@@ -931,7 +931,7 @@ typedef struct xfs_dinode {
 	__u8		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
-	xfs_timestamp_t	di_crtime;	/* time created */
+	struct xfs_timestamp di_crtime;	/* time created */
 	__be64		di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index e3400c9c71cd..f2fac9bea66d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -368,10 +368,10 @@ static inline int xfs_ilog_fdata(int w)
  * directly mirrors the xfs_dinode structure as it must contain all the same
  * information.
  */
-typedef struct xfs_ictimestamp {
+struct xfs_ictimestamp {
 	int32_t		t_sec;		/* timestamp seconds */
 	int32_t		t_nsec;		/* timestamp nanoseconds */
-} xfs_ictimestamp_t;
+};
 
 /*
  * Define the format of the inode core that is logged. This structure must be
@@ -390,9 +390,9 @@ struct xfs_log_dinode {
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	uint8_t		di_pad[6];	/* unused, zeroed space */
 	uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_ictimestamp_t di_atime;	/* time last accessed */
-	xfs_ictimestamp_t di_mtime;	/* time last modified */
-	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
+	struct xfs_ictimestamp di_atime;	/* time last accessed */
+	struct xfs_ictimestamp di_mtime;	/* time last modified */
+	struct xfs_ictimestamp di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -417,7 +417,7 @@ struct xfs_log_dinode {
 	uint8_t		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
-	xfs_ictimestamp_t di_crtime;	/* time created */
+	struct xfs_ictimestamp di_crtime;	/* time created */
 	xfs_ino_t	di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 

