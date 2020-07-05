Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6057EC433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C6720C56
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jDBoYnNO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGEWM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:12:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56338 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:12:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCusx080729
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6H8vjMtXEfnwA565zIq4z3q5hJjkVwUD+N5X5MThkVQ=;
 b=jDBoYnNOUzVrIwCkbbMXSogaCwpfMq38r1QKUv2IWQVxg5+A41C/ur2GvMEcvyPrXmCK
 zApOlMXbfUz88JplOxMqqHKzqFEHkgNtMw+Yt3r9N9GgCI/fXjeOP5axkGN37X9Wgfmx
 iVy+iej0e1cp7ch9Aqs3mYAMhN0j08oArPlJ4cFYGRdaN4FQhUMdVL09tBYUFoNpot1K
 wgnv9DNUY5LNX9TdTsG1IWkw80A7Hp8C4ZFV6kYHk0kNbhmWz54fq8HeBbKy4D6YJHH4
 rCG724RMgQv4Ie0WkQW7jOKyqYEfP5G4LNc9NZRMxzSr01yudXco8vR9jWUpIZJzJNK5 MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 322kv63axn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:12:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCrm6102794
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:12:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3233hqbqy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:12:55 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MCtnS002815
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:12:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:12:54 -0700
Subject: [PATCH 03/22] xfs: validate ondisk/incore dquot flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:12:53 -0700
Message-ID: <159398717379.425236.1842038690682253468.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
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
index d5b7f03e93c8..5bd963c774f8 100644
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
 

