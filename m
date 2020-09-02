Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1A0C28E83
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D0920707
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jh9vuydc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBC5B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:57:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgIBC4z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:56:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822rtAp124322;
        Wed, 2 Sep 2020 02:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iXgXEQ7vGIyFnOnHZeivNPVAVptFbol2WbjtRTWbGWo=;
 b=Jh9vuydcCI10/hL2RPiP7RptiMR3vEYSrPQk7lcEDeE6niR1A/N0XSs5jFP5TqLCpnHd
 U7utDixyqoXeFyh2lOgZElmqZLX0+wVNySHbfGVLaaE03xgX1yhw9eRHPPvZjRWUSTlt
 7x7UZ57fL21b5z0oCbTqExtAMVtZQMC+DwBmwryXHZOBYI/oslTXvTSTKq4A1nAs3UI+
 5L985KbpDUCnyl+v8wCjvh2S0A6yzkgBl3yhU2XZl6Sk036p2ey0bjr8n/E4OftyDzoS
 YbCpB0lMbn4u/a/JKk4eWaamC6tkQW5vNDdEKmTAwb6DOR51x7MMFrc8VhPGhrefIyWy yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 339dmmxa5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:56:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822t1AB185969;
        Wed, 2 Sep 2020 02:56:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3380st0wfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:56:40 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0822ubgl004821;
        Wed, 2 Sep 2020 02:56:37 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:56:36 -0700
Subject: [PATCH 01/11] xfs: explicitly define inode timestamp range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Tue, 01 Sep 2020 19:56:34 -0700
Message-ID: <159901539472.548109.12460414849559832453.stgit@magnolia>
In-Reply-To: <159901538766.548109.8040337941204954344.stgit@magnolia>
References: <159901538766.548109.8040337941204954344.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
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
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
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

