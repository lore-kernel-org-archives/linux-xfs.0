Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CD2C433E4
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2EAB2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KvgD7Kw7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgHQXBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:01:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgHQXBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:01:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMurMV136090;
        Mon, 17 Aug 2020 23:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+A77UEr30xuu2QvGIc+rnlnj+ZkE4JZoDmNFQK0cYOk=;
 b=KvgD7Kw7pJklgwc33n38L8PCHcZmAiNbfMhM7LytBCgPHzvzck5BUQM5K2klZEhBAroT
 m8TsxH9CzNskQRUTvXH2rUqJi3FUjWmy6i4ZI5Sj4VbJ4cIWB+RNPVqNt7Ny/3l/KFcF
 H5U01rVKl5XEnQHTvYoAqAH4ry99nmjqugdxul/wQPufZo5Rlf7ZJzpQKgmryJ1bUHOB
 rZubf+nAyOvPPawpqaktd9U0XgNXsOuLTY7n2CdFtlz8QlBi6BwUCpirLr6OcjcOi45A
 Kl/w7hTDU55Xw4/6VbPRN7lIjh3RIS7bv73LkJ/6tUEM4Hg8CNsPRLOWGgKwo835nPr6 Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn1g5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:01:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw9j2084770;
        Mon, 17 Aug 2020 22:59:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfr598c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMx0Jc014074;
        Mon, 17 Aug 2020 22:59:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:00 -0700
Subject: [PATCH 01/18] libxfs: create a real struct timespec64
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:59 -0700
Message-ID: <159770513983.3958786.6208814640295936803.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Create a real struct timespec64 that supports 64-bit seconds counts.
The C library struct timespec doesn't support this on 32-bit
architectures and we cannot lose the upper bits in the incore inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h         |    1 -
 include/xfs_inode.h      |   22 +++++++++++-----------
 libxfs/libxfs_api_defs.h |    7 +++++++
 libxfs/libxfs_priv.h     |    2 --
 4 files changed, 18 insertions(+), 14 deletions(-)


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
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a3eef04db419..99bc5b936da7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -7,6 +7,13 @@
 #ifndef __LIBXFS_API_DEFS_H__
 #define __LIBXFS_API_DEFS_H__
 
+typedef long long int time64_t;
+
+struct timespec64 {
+	time64_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
+};
+
 /*
  * This file defines all the kernel based functions we expose to userspace
  * via the libxfs_* namespace. This is kept in a separate header file so
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index eb485e7375b1..808b78180b06 100644
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

