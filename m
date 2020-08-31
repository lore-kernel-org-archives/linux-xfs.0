Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FD1C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0569320E65
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="elGyH77t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgHaGHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:07:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGHF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 02:07:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5svOI113685;
        Mon, 31 Aug 2020 06:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=U75djIiCrODuDRs9a3ZksnzJNHWU+odOWjmvyw8IvmI=;
 b=elGyH77t8YGzYtKdgF/rl+12EaQZhuYf4xrKU5Zq7OjtcickNSR9ooZ6bzn/MO8uQh3Z
 cMZStT+dD0j01tJyfRWtl/NTdB8niF86j0w7w0hnVS1EiLYaIpvpKrVbv5+P9d3W5FSX
 PMJ6YIDfCLx0Fgn5xq23Nv5TohQHKopDW16g2hFlDZAgJWGSxajHcCTiEqTN9KO+Qcd2
 PQ3qBFs2YROvyWKI7vAlopCNveATFjYbTpGHNWA6clPZ5AuvWZoR+XHBhaf7K1a+yYD1
 aajKxiPnxRzvms+g58MWuT+mnIBFV7VCN6Icpp3/342RZPOisZweceR0VnmMUgsiFzWl Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqmbwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 06:06:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5t7pZ021284;
        Mon, 31 Aug 2020 06:06:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3380kk6uty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 06:06:53 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07V66nHb028443;
        Mon, 31 Aug 2020 06:06:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Aug 2020 23:06:49 -0700
Subject: [PATCH 01/11] xfs: explicitly define inode timestamp range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Sun, 30 Aug 2020 23:06:52 -0700
Message-ID: <159885401259.3608006.3598200231687223740.stgit@magnolia>
In-Reply-To: <159885400575.3608006.17716724192510967135.stgit@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Formally define the inode timestamp ranges that existing filesystems
support, and switch the vfs timetamp ranges to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   22 ++++++++++++++++++++++
 fs/xfs/xfs_super.c         |    4 ++--
 2 files changed, 24 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fe129fe16d5f..e57360a8fd16 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -848,11 +848,33 @@ struct xfs_agfl {
 	    ASSERT(xfs_daddr_to_agno(mp, d) == \
 		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
+/*
+ * XFS Timestamps
+ * ==============
+ *
+ * Traditional ondisk inode timestamps consist of signed 32-bit counters for
+ * seconds and nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC
+ * 1970, which means that the timestamp epoch is the same as the Unix epoch.
+ * Therefore, the ondisk min and max defined here can be used directly to
+ * constrain the incore timestamps on a Unix system.
+ */
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
 } xfs_timestamp_t;
 
+/*
+ * Smallest possible ondisk seconds value with traditional timestamps.  This
+ * corresponds exactly with the incore timestamp Dec 13 20:45:52 UTC 1901.
+ */
+#define XFS_LEGACY_TIME_MIN	((int64_t)S32_MIN)
+
+/*
+ * Largest possible ondisk seconds value with traditional timestamps.  This
+ * corresponds exactly with the incore timestamp Jan 19 03:14:07 UTC 2038.
+ */
+#define XFS_LEGACY_TIME_MAX	((int64_t)S32_MAX)
+
 /*
  * On-disk inode structure.
  *
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c7ffcb57b586..b3b0e6154bf2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1484,8 +1484,8 @@ xfs_fc_fill_super(
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	sb->s_time_min = S32_MIN;
-	sb->s_time_max = S32_MAX;
+	sb->s_time_min = XFS_LEGACY_TIME_MIN;
+	sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	sb->s_iflags |= SB_I_CGROUPWB;
 
 	set_posix_acl_flag(sb);

