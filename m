Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE36C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 548C620724
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p57zJ9dm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389594AbgF3PmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:42:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44342 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389628AbgF3PmX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:42:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgMOa006983
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r8iKa386ZlGhqkZfzqCV5Ggcq2ybVBTXmmI5DNqtRN0=;
 b=p57zJ9dmkIxfydQHBIyVc0bFwtCGbesUMkYCftAMLwPr2UN0zcMHuXjr2PXV/CFObRPz
 SR4RNjOKn7k2hZ7lBRWxqDmEBAuYwZWCh4ESzDRfb5YLTJUiCdloaZOg7ZIkNy7S6zPB
 2d8T44pxkdqLwZ9QeM0yWfawKIqYPOMaajL9cZcJwIaSirEc+hHNcXk2RTFnuHkQyJRS
 z3Ty0bSuCpIgA3ZwCWioW3YdufZenPYpmDHmtoFPBONeC5JmGRQS5iFQDZJSMi1YLcPu
 sxSSmdR+nm1VFD7L7eU2IhXFJiyNDtUR5yAN1Gv9qX0u7RCBToyj2SONLXzzmdrSGzN9 Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrn59rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFMY4E059622
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31xfvsm41e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:12 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UFgBnO013641
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:42:11 +0000
Subject: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:42:09 -0700
Message-ID: <159353172899.2864738.6438709598863248951.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While loading dquot records off disk, make sure that the quota type
flags are the same between the incore dquot and the ondisk dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d5b7f03e93c8..46c8ca83c04d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -524,13 +524,27 @@ xfs_dquot_alloc(
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
+	 * The only field the verifier didn't check was the quota type flag, so
+	 * do that here.
+	 */
+	if ((dqp->dq_flags & XFS_DQ_ALLTYPES) !=
+	    (ddqp->d_flags & XFS_DQ_ALLTYPES) ||
+	    dqp->q_core.d_id != ddqp->d_id) {
+		xfs_alert(bp->b_mount,
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
 

