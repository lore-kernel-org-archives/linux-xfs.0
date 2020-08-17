Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AC9C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4201F2065D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IK6w6gAv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgHQW5B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:57:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39606 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgHQW5A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:57:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMuwIR136138;
        Mon, 17 Aug 2020 22:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rN17pWiCR5jRCi856ADQ+/y/cFP/7WUWftZJn+HLPPw=;
 b=IK6w6gAvmu4VHfikL1T+g/PRyZdVWGd0w706PlZ+J8XigTYw+aZ8Pp2rLowGvw2DF1zC
 /aGwHZ/azKZPwYzmGxCAJ5ud8bIcuamo67MA/EgQ113VAyS8T5tMVn6eSk5mPGSguXB0
 qgTcvXEsMsFYG3vc1MtCc9VZurpNEWcizZDIkr0tNL+tVPLBStAtQBrxDkOOWTPPZt0x
 IYKVnUBhrEPU7vyBE2mxVuhpdi4pF7PO/OcdEPjN1DFEfkgoDBwR1o9/BIvr1jvW8AKO
 Ceu8E+p4aj1faDaMzm+RVFgCZoyTLCfONkxu+wYu8BRRiIJXsbxt4MAam8ux3lgB4zTE 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn1fsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:56:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMm7fR101692;
        Mon, 17 Aug 2020 22:56:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9m9xr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:56:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMut8J017027;
        Mon, 17 Aug 2020 22:56:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:56:55 -0700
Subject: [PATCH 01/11] xfs: explicitly define inode timestamp range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Mon, 17 Aug 2020 15:56:54 -0700
Message-ID: <159770501455.3956827.1205192443311495980.stgit@magnolia>
In-Reply-To: <159770500809.3956827.8869892960975362931.stgit@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Formally define the inode timestamp ranges that existing filesystems
support, and switch the vfs timetamp ranges to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   19 +++++++++++++++++++
 fs/xfs/xfs_ondisk.h        |   12 ++++++++++++
 fs/xfs/xfs_super.c         |    5 +++--
 3 files changed, 34 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index be86fa1a5556..b1b8a5c05cea 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -849,11 +849,30 @@ struct xfs_agfl {
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
index acb9b737fe6b..48a64fa49f91 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -15,6 +15,18 @@
 		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
 		"expected " #off)
 
+#define XFS_CHECK_VALUE(value, expected) \
+	BUILD_BUG_ON_MSG((value) != (expected), \
+		"XFS: value of " #value " is wrong, expected " #expected)
+
+static inline void __init
+xfs_check_limits(void)
+{
+	/* make sure timestamp limits are correct */
+	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
+	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
+}
+
 static inline void __init
 xfs_check_ondisk_structs(void)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c7ffcb57b586..375f05a47ba4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1484,8 +1484,8 @@ xfs_fc_fill_super(
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	sb->s_time_min = S32_MIN;
-	sb->s_time_max = S32_MAX;
+	sb->s_time_min = XFS_INO_TIME_MIN;
+	sb->s_time_max = XFS_INO_TIME_MAX;
 	sb->s_iflags |= SB_I_CGROUPWB;
 
 	set_posix_acl_flag(sb);
@@ -2077,6 +2077,7 @@ init_xfs_fs(void)
 {
 	int			error;
 
+	xfs_check_limits();
 	xfs_check_ondisk_structs();
 
 	printk(KERN_INFO XFS_VERSION_STRING " with "

