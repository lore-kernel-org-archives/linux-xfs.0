Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F7BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 451E3207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GSK3EzZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHZWHN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:07:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59226 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZWHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:07:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QLwmjs196585;
        Wed, 26 Aug 2020 22:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NvlRQI/6JvrLyQrKVxj2tAAj6AQ+WDaqqMDUlfXtuR8=;
 b=GSK3EzZcEtUFaslmLJgJQ9zXZOBisCE4/D5DGocqeDUTbjScd6ttRxcM6YkbhHZREwFo
 89aV88NY2IH0ZzrjMp0GJdfqqiM+vRxVZakklI8MF3q1MBrxoaMrqXKOB753KlS2eaEW
 16blQDMiPXcGfq3qmjknSEd0MFA6Y+LZl3Zsmy4PjI+lP3r0umhyC0eIuFRepks9LvwW
 VIu1+6ajHocayxFMbYJWNsp3oqOhrjZrHyAuA3wN3n8vimPzTI8fS0Uf74eNmVnyrlG/
 dRhU8CnxbxwDT5j3ZS5WjA7xnc6f3d494fDAo0V8zEhmccl5lgENRSsWG3zktyDjFFzn qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 335gw84w3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 22:07:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM4eGk015194;
        Wed, 26 Aug 2020 22:05:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333ru0pr75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 22:05:06 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QM56bx027220;
        Wed, 26 Aug 2020 22:05:06 GMT
Received: from localhost (/10.159.146.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 15:05:05 -0700
Subject: [PATCH 01/11] xfs: explicitly define inode timestamp range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Wed, 26 Aug 2020 15:05:04 -0700
Message-ID: <159847950453.2601708.10180221593902060367.stgit@magnolia>
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Formally define the inode timestamp ranges that existing filesystems
support, and switch the vfs timetamp ranges to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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

