Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188D7C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF7622072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NoMU92oq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgHQXAS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36052 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbgHQXAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwHcp164206;
        Mon, 17 Aug 2020 23:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LqMlinSHFiu5CYOVFtsQetd8guINBh/Q2eLnjKO01oA=;
 b=NoMU92oqZCU7TYRlM8GVDVhAZrHSKNfGhWCBZXH+5TPjEos4fnXcwAj5CFH2wn6tH8t0
 hpxY5KSjsYcejxY0nvXfLzLz01069gMvm0ZWFb1ihHkzu4/DXnIajF936jI/YQKxc6rP
 S4uS9+BaVRe/639/2/aiRUY8iPxC40C3D1xPtuUJpKaOY28zHocgzms904QiKLLxCDDd
 6u/iy72PoF2vZ6KZO4SMiL+lFGF/Jtbga/LQj/N0/vYNhd3JVCpGYQIlKN6/rgXKdMU5
 H8el6iIy2xx5NavFp4X9zxun3U3MOAx7WDK5MzKAFWqD6XuoIOUx/S984182qznCKCuR Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r1mwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvsbf114192;
        Mon, 17 Aug 2020 23:00:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32xsm18smn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:00:12 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HN0BZN017750;
        Mon, 17 Aug 2020 23:00:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:00:10 -0700
Subject: [PATCH 12/18] xfs: enable bigtime for quota timers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:00:09 -0700
Message-ID: <159770520929.3958786.2869468837745844258.stgit@magnolia>
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

Enable the bigtime feature for quota timers.  We decrease the accuracy
of the timers to ~4s in exchange for being able to set timers up to the
bigtime maximum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_mount.h     |    5 +++++
 libxfs/xfs_dquot_buf.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_format.h     |   26 +++++++++++++++++++++++++-
 libxfs/xfs_quota_defs.h |    3 ++-
 4 files changed, 72 insertions(+), 2 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 20c8bfaf4fa8..be74a922b7a1 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -184,4 +184,9 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
+/* Dummy xfs_dquot so that libxfs compiles. */
+struct xfs_dquot {
+	int		q_type;
+};
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 847b9ba5280c..e5938ef649f0 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -67,6 +67,13 @@ xfs_dquot_verify(
 	    ddq_type != XFS_DQTYPE_GROUP)
 		return __this_address;
 
+	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
+	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) && !ddq->d_id)
+		return __this_address;
+
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
 		return __this_address;
 
@@ -294,6 +301,20 @@ xfs_dquot_from_disk_timestamp(
 	time64_t		*timer,
 	__be32			dtimer)
 {
+	/* Zero always means zero, regardless of encoding. */
+	if (!dtimer) {
+		*timer = 0;
+		return;
+	}
+
+	if (ddq->d_type & XFS_DQTYPE_BIGTIME) {
+		uint64_t	t;
+
+		t = be32_to_cpu(dtimer);
+		*timer = t << XFS_DQ_BIGTIME_SHIFT;
+		return;
+	}
+
 	*timer = be32_to_cpu(dtimer);
 }
 
@@ -304,5 +325,24 @@ xfs_dquot_to_disk_timestamp(
 	__be32			*dtimer,
 	time64_t		timer)
 {
+	/* Zero always means zero, regardless of encoding. */
+	if (!timer) {
+		*dtimer = cpu_to_be32(0);
+		return;
+	}
+
+	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
+		uint64_t	t = timer;
+
+		/*
+		 * Round the end of the grace period up to the nearest bigtime
+		 * interval that we support, to give users the most time to fix
+		 * the problems.
+		 */
+		t = roundup_64(t, 1U << XFS_DQ_BIGTIME_SHIFT);
+		*dtimer = cpu_to_be32(t >> XFS_DQ_BIGTIME_SHIFT);
+		return;
+	}
+
 	*dtimer = cpu_to_be32(timer);
 }
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 67303e517260..87c86a6dfb91 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1228,13 +1228,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQTYPE_USER		0x01		/* user dquot record */
 #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
 #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
+#define XFS_DQTYPE_BIGTIME	0x08		/* large expiry timestamps */
 
 /* bitmask to determine if this is a user/group/project dquot */
 #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
 				 XFS_DQTYPE_PROJ | \
 				 XFS_DQTYPE_GROUP)
 
-#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
+#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK | \
+				 XFS_DQTYPE_BIGTIME)
 
 /*
  * XFS Quota Timers
@@ -1271,6 +1273,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQ_GRACE_MIN	((int64_t)0)
 #define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
 
+/*
+ * When bigtime is enabled, we trade a few bits of precision to expand the
+ * expiration timeout range to match that of big inode timestamps.  The grace
+ * periods stored in dquot 0 are not shifted, since they record an interval,
+ * not a timestamp.
+ */
+#define XFS_DQ_BIGTIME_SHIFT		(2)
+
+/*
+ * Smallest possible quota expiration with big timestamps, which is
+ * Jan  1 00:00:01 UTC 1970.
+ */
+#define XFS_DQ_BIGTIMEOUT_MIN		(XFS_DQ_TIMEOUT_MIN)
+
+/*
+ * Largest supported quota expiration with traditional timestamps, which is
+ * the largest bigtime inode timestamp, or Jul  2 20:20:25 UTC 2486.  The field
+ * is large enough that it's possible to fit expirations up to 2514, but we
+ * want to keep the maximum timestamp in sync.
+ */
+#define XFS_DQ_BIGTIMEOUT_MAX		(XFS_INO_BIGTIME_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index b524059faab5..b9a47eae684b 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -23,7 +23,8 @@ typedef uint8_t		xfs_dqtype_t;
 #define XFS_DQTYPE_STRINGS \
 	{ XFS_DQTYPE_USER,	"USER" }, \
 	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
-	{ XFS_DQTYPE_GROUP,	"GROUP" }
+	{ XFS_DQTYPE_GROUP,	"GROUP" }, \
+	{ XFS_DQTYPE_BIGTIME,	"BIGTIME" }
 
 /*
  * flags for q_flags field in the dquot.

