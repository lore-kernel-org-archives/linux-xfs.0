Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DD9C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D57D320872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:34:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QCcXm7/n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406525AbgJZXeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406524AbgJZXeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXtw164631;
        Mon, 26 Oct 2020 23:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=if1DYqCY5KhI0Jb00e/NLuRHf6w26OFpObqSR27PkC0=;
 b=QCcXm7/n2NCPq+GVuykbTHgq0cYQgdTQGVABtqIe3frWdmx+LSzUVolzIpIajYkZ4cRO
 tKAUQHZ9XGJtq18ookZHpEug6mPjeAEpsV6y1j/kjo5GWF5FyUqAXUHPB20VusU60IHw
 5+ANasDDRUMMI/uzFO7f5fAismB37gppGMO3pVcE5bxLm9efgu40/2RjidyYVqzDghMp
 AsTZcfSoJoRKGRYzzbcci0piBjQQ0LX0da/Dudy9/ndmHw0v0nqw4KY/KHAaTdTcykYB
 ISvPYx/floHAKAK0GmjUDpnOSwFmhp9Y/UcpFY9hCQ0zrzQBqdqjZyWmY5teUo5+iS8a +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3vup9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQFa3032559;
        Mon, 26 Oct 2020 23:34:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1q2b8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNYECX005480;
        Mon, 26 Oct 2020 23:34:14 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:13 -0700
Subject: [PATCH 01/26] libxfs: create a real struct timespec64
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:13 -0700
Message-ID: <160375525297.881414.4918118774537695755.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a real struct timespec64 that supports 64-bit seconds counts.
The C library struct timespec doesn't support this on 32-bit
architectures and we cannot lose the upper bits in the incore inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 include/libxfs.h        |    1 -
 include/xfs_fs_compat.h |    8 ++++++++
 include/xfs_inode.h     |   22 +++++++++++-----------
 libxfs/libxfs_priv.h    |    2 --
 4 files changed, 19 insertions(+), 14 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index b9370139becc..2667d3b77084 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -41,7 +41,6 @@ struct iomap;
 #define __round_mask(x, y) ((__typeof__(x))((y)-1))
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define unlikely(x) (x)
-#define timespec64 timespec
 
 /*
  * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
diff --git a/include/xfs_fs_compat.h b/include/xfs_fs_compat.h
index 154a802d9aed..d0ffc9775875 100644
--- a/include/xfs_fs_compat.h
+++ b/include/xfs_fs_compat.h
@@ -85,4 +85,12 @@ struct xfs_extent_data {
 #define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
 #define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
 
+/* 64-bit seconds counter that works independently of the C library time_t. */
+typedef long long int time64_t;
+
+struct timespec64 {
+	time64_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
+};
+
 #endif	/* __XFS_FS_COMPAT_H__ */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 588d8c7258f4..12676cb30bf2 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -31,17 +31,17 @@ struct xfs_inode_log_item;
  * metadata.
  */
 struct inode {
-	mode_t		i_mode;
-	uint32_t	i_uid;
-	uint32_t	i_gid;
-	uint32_t	i_nlink;
-	xfs_dev_t	i_rdev;		/* This actually holds xfs_dev_t */
-	unsigned long	i_state;	/* Not actually used in userspace */
-	uint32_t	i_generation;
-	uint64_t	i_version;
-	struct timespec	i_atime;
-	struct timespec	i_mtime;
-	struct timespec	i_ctime;
+	mode_t			i_mode;
+	uint32_t		i_uid;
+	uint32_t		i_gid;
+	uint32_t		i_nlink;
+	xfs_dev_t		i_rdev;	 /* This actually holds xfs_dev_t */
+	unsigned long		i_state; /* Not actually used in userspace */
+	uint32_t		i_generation;
+	uint64_t		i_version;
+	struct timespec64	i_atime;
+	struct timespec64	i_mtime;
+	struct timespec64	i_ctime;
 };
 
 static inline uint32_t i_uid_read(struct inode *inode)
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index bd724c32c263..e92269f0bdae 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -64,8 +64,6 @@ extern kmem_zone_t *xfs_buf_zone;
 extern kmem_zone_t *xfs_inode_zone;
 extern kmem_zone_t *xfs_trans_zone;
 
-#define timespec64 timespec
-
 /* fake up iomap, (not) used in xfs_bmap.[ch] */
 #define IOMAP_F_SHARED			0x04
 #define xfs_bmbt_to_iomap(a, b, c, d)	((void) 0)

