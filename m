Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0575C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96CB6206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pMcir+KY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgAABNP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001198Cm091316
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qKpirDn198TfkQXozVJ4gDXZk9lICDC8e8Jw5EF5l0E=;
 b=pMcir+KYwXxDpko74BLfZ5KGrDPOZyVPauXADcaCK2+zAyckEdF0gC6KZr+EovNTPZln
 lSfc7IxE/NVHU4J/kvGeI2xfRWk7ZUR1DPi94smDqPeSrBgMoLUtO+UUrjQOTMAt7AlV
 QsMFgJ7cRBFeHkMzux5lWSk50XsYnfKo0XNLExxi9R8fsTefWHfKRFI70c2KU1jr/pcu
 cdlmhQEFAavRsBWE3qKW2dw/pfdAbB4rxbfAVsERN2LQSKhreMLsIAzjto+LsTw1f1wI
 L+Y668qn8eEmm3zHSdN+BMQcm/+t2vvnjuPs9x2AwcQnHPycc+Xvz+3lLHHY0sohgMHK 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vEI190284
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrg117-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011BBxO032229
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:12 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:11:11 -0800
Subject: [PATCH 01/14] xfs: explicitly define inode timestamp range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:11:07 -0800
Message-ID: <157784106702.1364230.14985571182679451055.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   19 +++++++++++++++++++
 fs/xfs/xfs_ondisk.h        |    8 ++++++++
 fs/xfs/xfs_super.c         |    4 ++--
 3 files changed, 29 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9ff373962d10..82b15832ba32 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -841,11 +841,30 @@ typedef struct xfs_agfl {
 	    ASSERT(xfs_daddr_to_agno(mp, d) == \
 		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
+/*
+ * XFS Timestamps
+ * ==============
+ *
+ * Inode timestamps consist of signed 32-bit counters for seconds and
+ * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
+ */
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
 } xfs_timestamp_t;
 
+/*
+ * Smallest possible timestamp with traditional timestamps, which is
+ * Dec 13 20:45:52 UTC 1901.
+ */
+#define XFS_INO_TIME_MIN	((int64_t)S32_MIN)
+
+/*
+ * Largest possible timestamp with traditional timestamps, which is
+ * Jan 19 03:14:07 UTC 2038.
+ */
+#define XFS_INO_TIME_MAX	((int64_t)S32_MAX)
+
 /*
  * On-disk inode structure.
  *
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index fa0ec2fae14a..f67f3645efcd 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -15,9 +15,17 @@
 		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
 		"expected " #off)
 
+#define XFS_CHECK_VALUE(value, expected) \
+	BUILD_BUG_ON_MSG((value) != (expected), \
+		"XFS: value of " #value " is wrong, expected " #expected)
+
 static inline void __init
 xfs_check_ondisk_structs(void)
 {
+	/* make sure timestamp limits are correct */
+	XFS_CHECK_VALUE(XFS_INO_TIME_MIN, 			-2147483648LL);
+	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
+
 	/* ag/file structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f687181a2720..3bddf13cd8ea 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1582,8 +1582,8 @@ xfs_fc_fill_super(
 	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	sb->s_time_min = S32_MIN;
-	sb->s_time_max = S32_MAX;
+	sb->s_time_min = XFS_INO_TIME_MIN;
+	sb->s_time_max = XFS_INO_TIME_MAX;
 	sb->s_iflags |= SB_I_CGROUPWB;
 
 	set_posix_acl_flag(sb);

