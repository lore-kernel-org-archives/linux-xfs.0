Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAAEC433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A7A21924
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="axrCtB/D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgGNBbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:31:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57550 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgGNBbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:31:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1Qx3B123724;
        Tue, 14 Jul 2020 01:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PnVqWxedwqcjAFYWA8S5UbNchf8ckZcLRh7pA/+17x8=;
 b=axrCtB/D5Fb6b4s6FYrh/Av1G2AwH8DgxCSxLKA4OFnYZC+ZbvyqZ9PAwZNhD+WzvMYh
 MqTGymw3IjdiEFn4HavUWS9QMA7moaQRcU0ePyriY59iCyWzk1efnVBMPAqqPeLluHPb
 OWDPsvcBFtNt/kXclxZ3GUmZBrIzDNo1ttobXmY8cATWJfpLWZhcVTeGJFWVdXdoG6J5
 3nRgmMh+8sJvjo1ZDEeMzxb3Joj7PK8pBRVi1zcZmxh4y4i8qWkcTgWTGOPK+tZ5x8DN
 4L/BUbs2Phs1l8Z1FnhxV66DDVaJZyt0yPpDVkcNmjwFIyFLetGUQXOVnE/+FlNsFBm1 Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762na9t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:31:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1RVFp142564;
        Tue, 14 Jul 2020 01:31:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb28jww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:31:49 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1Vmd5012115;
        Tue, 14 Jul 2020 01:31:48 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:31:48 -0700
Subject: [PATCH 03/26] xfs: validate ondisk/incore dquot flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:31:47 -0700
Message-ID: <159469030762.2914673.9979155467953666925.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While loading dquot records off disk, make sure that the quota type
flags are the same between the incore dquot and the ondisk dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 76353c9a723e..7503c6695569 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_error.h"
 
 /*
  * Lock order:
@@ -524,13 +525,26 @@ xfs_dquot_alloc(
 }
 
 /* Copy the in-core quota fields in from the on-disk buffer. */
-STATIC void
+STATIC int
 xfs_dquot_from_disk(
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		*bp)
 {
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
 
+	/*
+	 * Ensure that we got the type and ID we were looking for.
+	 * Everything else was checked by the dquot buffer verifier.
+	 */
+	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
+	    ddqp->d_id != dqp->q_core.d_id) {
+		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
+			  "Metadata corruption detected at %pS, quota %u",
+			  __this_address, be32_to_cpu(dqp->q_core.d_id));
+		xfs_alert(bp->b_mount, "Unmount and run xfs_repair");
+		return -EFSCORRUPTED;
+	}
+
 	/* copy everything from disk dquot to the incore dquot */
 	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 
@@ -544,6 +558,7 @@ xfs_dquot_from_disk(
 
 	/* initialize the dquot speculative prealloc thresholds */
 	xfs_dquot_set_prealloc_limits(dqp);
+	return 0;
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
@@ -617,9 +632,11 @@ xfs_qm_dqread(
 	 * further.
 	 */
 	ASSERT(xfs_buf_islocked(bp));
-	xfs_dquot_from_disk(dqp, bp);
-
+	error = xfs_dquot_from_disk(dqp, bp);
 	xfs_buf_relse(bp);
+	if (error)
+		goto err;
+
 	*dqpp = dqp;
 	return error;
 

