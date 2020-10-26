Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B575CC55178
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C58D207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LxNGtTQg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406887AbgJZXfP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406881AbgJZXfO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOv73164755;
        Mon, 26 Oct 2020 23:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r40eINVASr8+c4GBu3wmtjDfWYb4wSpOoALZh3yl228=;
 b=LxNGtTQg3//d3hwf+kQGxr+KdD6N0H29icK0xe3KstqGQi5hKV6fV1SCpmEchSA56S4F
 88VR3wcD/tjMB/SczDi6BBNgFKJH9PYlBIrqsruaYUS7LdNgnaotsSvA8mJnSgDVkwrz
 nArZuZZje3UhkeXS/9nrvlxxjNsv+19dordb9BsVXhGJ7APqtUPcAn6Fn5gb98Fo0rju
 JM7AiGE0Cn2NY4k2Fso9Fkb1/Q+ReDOduY1w4GR7B33lRdRtYR0g9BzvXydOSk00LTir
 SBYI8Y7HET4TutSUcfdKk6sCTBUhT7k48H+hv+ox/Q4WARjnjXE9WkntpZVRtrIqMme8 bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm3vurj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQN85058358;
        Mon, 26 Oct 2020 23:35:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwukr8ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:35:06 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNZ4mh005813;
        Mon, 26 Oct 2020 23:35:04 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:35:04 -0700
Subject: [PATCH 09/26] xfs: explicitly define inode timestamp range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:35:02 -0700
Message-ID: <160375530283.881414.14161839557866465200.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
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

Source kernel commit: 876fdc7c4f366a709ac272ef3336ae7dce58f2af

Formally define the inode timestamp ranges that existing filesystems
support, and switch the vfs timetamp ranges to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_fs_compat.h |    4 ++++
 libxfs/xfs_format.h     |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)


diff --git a/include/xfs_fs_compat.h b/include/xfs_fs_compat.h
index d0ffc9775875..0077f00cb949 100644
--- a/include/xfs_fs_compat.h
+++ b/include/xfs_fs_compat.h
@@ -93,4 +93,8 @@ struct timespec64 {
 	long		tv_nsec;		/* nanoseconds */
 };
 
+#define U32_MAX		((uint32_t)~0U)
+#define S32_MAX		((int32_t)(U32_MAX >> 1))
+#define S32_MIN		((int32_t)(-S32_MAX - 1))
+
 #endif	/* __XFS_FS_COMPAT_H__ */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5a183b6658e6..4a106b6713ad 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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

