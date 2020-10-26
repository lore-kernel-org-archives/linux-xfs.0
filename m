Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA635C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8401520809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y2IfHulZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407131AbgJZXgG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:06 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407121AbgJZXgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPVom177130;
        Mon, 26 Oct 2020 23:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Yn/hTMBZQvOFnTcFDUDyaYtgwsW2aQyUJinHNOioMfo=;
 b=y2IfHulZ8GXaXwtuH3UhznTBab2XI5zaP9+x9NGLXvf+/6x9T92ma1CHEvkg0uqS/kJU
 oxpf5mPc6k+ieS6nElo0VrehVmt3jl8a7fp/iPfdjudoYx55CueA34BHGZgMhnAjrmpn
 m5k+ioqYFBfV4MOhdAhpIKp85+0ffxihVriesKdcr2yDs4UAEfwkXF3s0V+k8wyNTcqg
 I/cLcoTm5dpzQe0NQGH84l29nAIHYc/sD0b39G5s4+5cuDkHV/rX1IMYwMx8FqQyFlgv
 H0uRpA8qFE5wn/peyXmWxSqFqy3JIXsQC/J3GcWPC6BIdWM7q9q4JWyEoo5i6gwat/eR IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqd6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxFb110502;
        Mon, 26 Oct 2020 23:36:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx5wfsty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:00 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNZwto029389;
        Mon, 26 Oct 2020 23:35:59 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:35:58 -0700
Subject: [PATCH 17/26] xfs: widen ondisk quota expiration timestamps to handle
 y2038+
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:35:57 -0700
Message-ID: <160375535744.881414.13178507174865310834.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 4ea1ff3b49681af45a4a8c14baf7f0b3d11aa74a

Enable the bigtime feature for quota timers.  We decrease the accuracy
of the timers to ~4s in exchange for being able to set timers up to the
bigtime maximum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_mount.h     |    5 +++++
 libxfs/xfs_dquot_buf.c  |   21 ++++++++++++++++++--
 libxfs/xfs_format.h     |   50 ++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_quota_defs.h |    3 ++-
 4 files changed, 75 insertions(+), 4 deletions(-)


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
index 04f62e31019d..0a5a237d2236 100644
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
 
@@ -293,7 +300,12 @@ xfs_dquot_from_disk_ts(
 	struct xfs_disk_dquot	*ddq,
 	__be32			dtimer)
 {
-	return be32_to_cpu(dtimer);
+	uint32_t		t = be32_to_cpu(dtimer);
+
+	if (t != 0 && (ddq->d_type & XFS_DQTYPE_BIGTIME))
+		return xfs_dq_bigtime_to_unix(t);
+
+	return t;
 }
 
 /* Convert an incore timer value into an on-disk timer value. */
@@ -302,5 +314,10 @@ xfs_dquot_to_disk_ts(
 	struct xfs_dquot	*dqp,
 	time64_t		timer)
 {
-	return cpu_to_be32(timer);
+	uint32_t		t = timer;
+
+	if (timer != 0 && (dqp->q_type & XFS_DQTYPE_BIGTIME))
+		t = xfs_dq_unix_to_bigtime(timer);
+
+	return cpu_to_be32(t);
 }
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index dbc7008e4498..0ab424cc25ca 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1263,13 +1263,15 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 #define XFS_DQTYPE_USER		0x01		/* user dquot record */
 #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
 #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
+#define XFS_DQTYPE_BIGTIME	0x80		/* large expiry timestamps */
 
 /* bitmask to determine if this is a user/group/project dquot */
 #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
 				 XFS_DQTYPE_PROJ | \
 				 XFS_DQTYPE_GROUP)
 
-#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
+#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK | \
+				 XFS_DQTYPE_BIGTIME)
 
 /*
  * XFS Quota Timers
@@ -1282,6 +1284,10 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
  * ondisk min and max defined here can be used directly to constrain the incore
  * quota expiration timestamps on a Unix system.
  *
+ * When bigtime is enabled, we trade two bits of precision to expand the
+ * expiration timeout range to match that of big inode timestamps.  The min and
+ * max recorded here are the on-disk limits, not a Unix timestamp.
+ *
  * The grace period for each quota type is stored in the root dquot (id = 0)
  * and is applied to a non-root dquot when it exceeds the soft or hard limits.
  * The length of quota grace periods are unsigned 32-bit quantities measured in
@@ -1300,6 +1306,48 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
  */
 #define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
 
+/*
+ * Smallest possible ondisk quota expiration value with bigtime timestamps.
+ * This corresponds (after conversion to a Unix timestamp) with the incore
+ * expiration of Jan  1 00:00:04 UTC 1970.
+ */
+#define XFS_DQ_BIGTIME_EXPIRY_MIN	(XFS_DQ_LEGACY_EXPIRY_MIN)
+
+/*
+ * Largest supported ondisk quota expiration value with bigtime timestamps.
+ * This corresponds (after conversion to a Unix timestamp) with an incore
+ * expiration of Jul  2 20:20:24 UTC 2486.
+ *
+ * The ondisk field supports values up to -1U, which corresponds to an incore
+ * expiration in 2514.  This is beyond the maximum the bigtime inode timestamp,
+ * so we cap the maximum bigtime quota expiration to the max inode timestamp.
+ */
+#define XFS_DQ_BIGTIME_EXPIRY_MAX	((int64_t)4074815106U)
+
+/*
+ * The following conversion factors assist in converting a quota expiration
+ * timestamp between the incore and ondisk formats.
+ */
+#define XFS_DQ_BIGTIME_SHIFT	(2)
+#define XFS_DQ_BIGTIME_SLACK	((int64_t)(1ULL << XFS_DQ_BIGTIME_SHIFT) - 1)
+
+/* Convert an incore quota expiration timestamp to an ondisk bigtime value. */
+static inline uint32_t xfs_dq_unix_to_bigtime(time64_t unix_seconds)
+{
+	/*
+	 * Round the expiration timestamp up to the nearest bigtime timestamp
+	 * that we can store, to give users the most time to fix problems.
+	 */
+	return ((uint64_t)unix_seconds + XFS_DQ_BIGTIME_SLACK) >>
+			XFS_DQ_BIGTIME_SHIFT;
+}
+
+/* Convert an ondisk bigtime quota expiration value to an incore timestamp. */
+static inline time64_t xfs_dq_bigtime_to_unix(uint32_t ondisk_seconds)
+{
+	return (time64_t)ondisk_seconds << XFS_DQ_BIGTIME_SHIFT;
+}
+
 /*
  * Default quota grace periods, ranging from zero (use the compiled defaults)
  * to ~136 years.  These are applied to a non-root dquot that has exceeded
diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index 9a99910d857e..0f0af4e35032 100644
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

