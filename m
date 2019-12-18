Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951E7C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 19:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D13D227BF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 19:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WFTO80/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfLRTjm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 14:39:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45904 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfLRTjl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 14:39:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIJdY9D127752;
        Wed, 18 Dec 2019 19:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ARuMRCxTeITnaliFldyiqQx94coszwTtXpwlEqAjfpc=;
 b=WFTO80/zohrk/S3KpmX8QiSGZEIRPMpdxxi/W2hR0tBMCfKPSbnoidYnesKC3SikpZfv
 6VyFMFd64YJ2/8a6Ahb+I1q/NwtKyImEOlUHuHsPDC4NSMVHx8yDXIhged8183XNOj6G
 q0zbBq3cSJeOjxlH3MeP/vjI/nMLfDj1OTlv21y7mnGQoKvUo9l0RON2VAAndQeQXnqN
 2YR4aMBPDfcw/iXrUd8SlfNttLXmD3EAFOIdZtNI0jPuLhYIVy5Y646MT8aPgIDYrg0W
 nTfXgBUipwZVT1bwKW10XvxIahcB+XJaxq4WBy9iP/1Ck04w+f5cxMxRSysSsVw4U9Jl 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wvqpqfs6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 19:39:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIJYHY7190377;
        Wed, 18 Dec 2019 19:37:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wyk3bp722-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 19:37:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBIJbav9029344;
        Wed, 18 Dec 2019 19:37:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 11:37:36 -0800
Subject: [PATCH 2/3] xfs: split the sunit parameter update into two parts
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com,
        alex@zadara.com
Date:   Wed, 18 Dec 2019 11:37:35 -0800
Message-ID: <157669785528.117895.4622861432203934489.stgit@magnolia>
In-Reply-To: <157669784202.117895.9984764081860081830.stgit@magnolia>
References: <157669784202.117895.9984764081860081830.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the administrator provided a sunit= mount option, we need to validate
the raw parameter, convert the mount option units (512b blocks) into the
internal unit (fs blocks), and then validate that the (now cooked)
parameter doesn't screw anything up on disk.  The incore inode geometry
computation can depend on the new sunit option, but a subsequent patch
will make validating the cooked value depends on the computed inode
geometry, so break the sunit update into two steps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |  126 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 51 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fca65109cf24..3750f0074c74 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -360,66 +360,79 @@ xfs_readsb(
 }
 
 /*
- * Update alignment values based on mount options and sb values
+ * If we were provided with new sunit/swidth values as mount options, make sure
+ * that they pass basic alignment and superblock feature checks, and convert
+ * them into the same units (FSB) that everything else expects.  This step
+ * /must/ be done before computing the inode geometry.
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_validate_new_dalign(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	if (mp->m_dalign == 0)
+		return 0;
 
-	if (mp->m_dalign) {
+	/*
+	 * If stripe unit and stripe width are not multiples
+	 * of the fs blocksize turn off alignment.
+	 */
+	if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
+	    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		xfs_warn(mp,
+	"alignment check failed: sunit/swidth vs. blocksize(%d)",
+			mp->m_sb.sb_blocksize);
+		return -EINVAL;
+	} else {
 		/*
-		 * If stripe unit and stripe width are not multiples
-		 * of the fs blocksize turn off alignment.
+		 * Convert the stripe unit and width to FSBs.
 		 */
-		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
-		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
+		if (mp->m_dalign && (mp->m_sb.sb_agblocks % mp->m_dalign)) {
 			xfs_warn(mp,
-		"alignment check failed: sunit/swidth vs. blocksize(%d)",
-				sbp->sb_blocksize);
+		"alignment check failed: sunit/swidth vs. agsize(%d)",
+				 mp->m_sb.sb_agblocks);
 			return -EINVAL;
-		} else {
-			/*
-			 * Convert the stripe unit and width to FSBs.
-			 */
-			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
-			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
-				xfs_warn(mp,
-			"alignment check failed: sunit/swidth vs. agsize(%d)",
-					 sbp->sb_agblocks);
-				return -EINVAL;
-			} else if (mp->m_dalign) {
-				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
-			} else {
-				xfs_warn(mp,
-			"alignment check failed: sunit(%d) less than bsize(%d)",
-					 mp->m_dalign, sbp->sb_blocksize);
-				return -EINVAL;
-			}
-		}
-
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
+		} else if (mp->m_dalign) {
+			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 		} else {
 			xfs_warn(mp,
-	"cannot change alignment: superblock does not support data alignment");
+		"alignment check failed: sunit(%d) less than bsize(%d)",
+				 mp->m_dalign, mp->m_sb.sb_blocksize);
 			return -EINVAL;
 		}
+	}
+
+	/* Update superblock with new values and log changes. */
+	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
+		xfs_warn(mp,
+"cannot change alignment: superblock does not support data alignment");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Update alignment values based on mount options and sb values
+ */
+STATIC int
+xfs_update_alignment(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	if (mp->m_dalign) {
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
@@ -648,12 +661,12 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Check if sb_agblocks is aligned at stripe boundary
-	 * If sb_agblocks is NOT aligned turn off m_dalign since
-	 * allocator alignment is within an ag, therefore ag has
-	 * to be aligned at stripe boundary.
+	 * If we were given new sunit/swidth options, do some basic validation
+	 * checks and convert the incore dalign and swidth values to the
+	 * same units (FSB) that everything else uses.  This /must/ happen
+	 * before computing the inode geometry.
 	 */
-	error = xfs_update_alignment(mp);
+	error = xfs_validate_new_dalign(mp);
 	if (error)
 		goto out;
 
@@ -664,6 +677,17 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	error = xfs_update_alignment(mp);
+	if (error)
+		goto out;
+
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 

