Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CC9C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1278207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R7cQc0Pn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHZWFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:05:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZWFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:05:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM0fHJ028784;
        Wed, 26 Aug 2020 22:05:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iqzgmVG/U/1QGyxx4/93j+j4KHQucG1l6wopvA2dbrA=;
 b=R7cQc0Pnz3xr7E4DNalIbanF+uPQprrNcs2pWyOnqZqix0aLGUAvj10nUhGqbl1ANPVR
 FWNG2DrrjkZKrArYqsyb0QZxDZAPsCD94aPmSObu5v9ecDAWMzKmj/s7JYIHa2Qk7QHu
 NRRiabWgVWJzc6OLlW5Ogp+XRSNP8yl3AxsJtzvNMR74nJjrVC40gW0JOxZ8k9d+NpQf
 3PVWtWCMl0FtJ9s12oGEUFtiW9ZKp7wBNlgiSWojMBZTNqZp6VNc8enFECzCpWc7UEXg
 LneHQ3xgx6EU0v5Lfqk2MIznt4T2b429G076lcNZULxQpov/kWEYpnhBR06eG51Jj3N5 kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 333dbs31ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 22:05:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM0JNm004046;
        Wed, 26 Aug 2020 22:05:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 333rubbf1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 22:05:46 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QM5in0027480;
        Wed, 26 Aug 2020 22:05:45 GMT
Received: from localhost (/10.159.146.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 15:05:44 -0700
Subject: [PATCH 07/11] xfs: kill struct xfs_ictimestamp
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Wed, 26 Aug 2020 15:05:43 -0700
Message-ID: <159847954327.2601708.9783406435973854389.stgit@magnolia>
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace this struct with an encoded uint64_t in preparation for the
bigtime functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h  |    5 +----
 fs/xfs/xfs_inode_item.c         |   39 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode_item_recover.c |   23 +++++++++++++++++++++--
 fs/xfs/xfs_ondisk.h             |    2 +-
 4 files changed, 54 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e3400c9c71cd..86640f8cd66a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -368,10 +368,7 @@ static inline int xfs_ilog_fdata(int w)
  * directly mirrors the xfs_dinode structure as it must contain all the same
  * information.
  */
-typedef struct xfs_ictimestamp {
-	int32_t		t_sec;		/* timestamp seconds */
-	int32_t		t_nsec;		/* timestamp nanoseconds */
-} xfs_ictimestamp_t;
+typedef uint64_t xfs_ictimestamp_t;
 
 /*
  * Define the format of the inode core that is logged. This structure must be
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6c65938cee1c..6ebc332ae446 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -295,6 +295,33 @@ xfs_inode_item_format_attr_fork(
 	}
 }
 
+/*
+ * Convert an incore timestamp to a log timestamp.  Note that the log format
+ * specifies host endian format!
+ *
+ * For traditional timestamps, the log format specifies that the seconds are
+ * stored in the first four bytes and the nanoseconds in the second four.  On a
+ * little-endian system, this means that we shift tv_nsec to put it in the
+ * upper four bytes and mask tv_sec to put it in the lower four bytes.  On
+ * big-endian systems, we shift tv_sec to put it in the upper four bytes and
+ * mask tv_nsec to put it in the lower four bytes.
+ */
+static inline xfs_ictimestamp_t
+xfs_inode_to_log_dinode_ts(
+	const struct timespec64	tv)
+{
+	uint64_t		t;
+
+#ifdef __LITTLE_ENDIAN
+	t = ((uint64_t)tv.tv_nsec << 32) | ((uint64_t)tv.tv_sec & 0xffffffff);
+#elif __BIG_ENDIAN
+	t = ((int64_t)tv.tv_sec << 32) | ((uint64_t)tv.tv_nsec & 0xffffffff);
+#else
+# error System is neither little nor big endian?
+#endif
+	return t;
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -313,12 +340,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	to->di_atime.t_sec = inode->i_atime.tv_sec;
-	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
-	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
-	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
-	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
-	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
+	to->di_atime = xfs_inode_to_log_dinode_ts(inode->i_atime);
+	to->di_mtime = xfs_inode_to_log_dinode_ts(inode->i_mtime);
+	to->di_ctime = xfs_inode_to_log_dinode_ts(inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -340,8 +364,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.tv_sec;
-		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
+		to->di_crtime = xfs_inode_to_log_dinode_ts(from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index e7c6f2b95e17..bbb820579ea2 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -117,15 +117,34 @@ xfs_recover_inode_owner_change(
 
 /*
  * Convert a log timestamp to an ondisk timestamp.  See notes about the ondisk
- * encoding in the comments for xfs_inode_to_disk_ts.
+ * encoding in the comments for xfs_inode_to_disk_ts.  Note that the log format
+ * specifies host endian format!
+ *
+ * For traditional timestamps, the log format specifies that the seconds are
+ * stored in the first four bytes and the nanoseconds in the second four.  On a
+ * little-endian system, this means that we shift tv_nsec to extract it from
+ * the upper four bytes and mask tv_sec to extract it from the lower four
+ * bytes.  On big-endian systems, we shift tv_sec to extract it from the upper
+ * four bytes and mask tv_nsec to extract it from the lower four bytes.
  */
 static inline xfs_timestamp_t
 xfs_log_dinode_to_disk_ts(
 	const xfs_ictimestamp_t	its)
 {
+	struct timespec64	tv;
 	uint64_t		t;
 
-	t = ((int64_t)its.t_sec << 32) | (its.t_nsec & 0xffffffff);
+#ifdef __LITTLE_ENDIAN
+	tv.tv_sec = (time64_t)its & 0xffffffff;
+	tv.tv_nsec = (int64_t)its >> 32;
+#elif __BIG_ENDIAN
+	tv.tv_sec = (time64_t)its >> 32;
+	tv.tv_nsec = (int64_t)its & 0xffffffff;
+#else
+# error System is neither little nor big endian?
+#endif
+
+	t = ((int64_t)tv.tv_sec << 32) | (tv.tv_nsec & 0xffffffff);
 	return cpu_to_be64(t);
 }
 
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 2f11a6f9e005..42b940e9b2b3 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -121,7 +121,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_ictimestamp_t,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);

