Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D099C56202
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4C2207BB
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J6s/EqcX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgKYUiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 15:38:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42290 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKYUiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 15:38:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKPOaD028107;
        Wed, 25 Nov 2020 20:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7cfiKS4S6hSwO9bMuus723bLiZe3tYnM0iGxQ0ukg1k=;
 b=J6s/EqcX44WzrRrkJdCFW8yjdIdlZ5DSnZHGdDoc7NwSqCWQr1A0Wjpu7yWdHgWYQsqj
 6zemfHCtNhwxsresKlUAWWrgmUrqucuJye8gyi3EjiJoPLhZ3Yhd+gceUKJWuUkrHMeH
 HE6iLZbdhiqjWboYhJeXL/cbSAxbx0es+74IqhVOXY36+I7urKLKPbzdX/oz3VMucVQm
 FOidG7rKcJkYOp2aMP4xn64Y2IrUJ7XZQKiegL6sRiZcG4tTObnx1FvlCr1p3rXN+EIW
 eYby2HOfzRmj782BnMPrrQ96cRg57ca5NjiE3z12WupagqVaqHb9iB2OU5XoJqpIQ7Kq EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 351kwhbb8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Nov 2020 20:38:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKQ4es066285;
        Wed, 25 Nov 2020 20:38:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 351n2jdym9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 20:38:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0APKcFbT029073;
        Wed, 25 Nov 2020 20:38:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Nov 2020 12:38:15 -0800
Subject: [PATCH 3/5] libxfs: add realtime extent reservation and usage
 tracking to transactions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Nov 2020 12:38:14 -0800
Message-ID: <160633669427.634603.6917592828334064504.stgit@magnolia>
In-Reply-To: <160633667604.634603.7657982642827987317.stgit@magnolia>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The libxfs resync added to the deferred ops code the ability to capture
the unfinished deferred ops and transaction reservation for later replay
during log recovery.  This nominally requires transactions to have the
ability to track rt extent reservations and usage, so port that missing
piece from the kernel now to avoid leaving logic bombs in case anyone
ever /does/ start messing with realtime.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 83247582d61e..bc4af26c09f6 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -230,6 +230,7 @@ xfs_trans_reserve(
 			error = -ENOSPC;
 			goto undo_blocks;
 		}
+		tp->t_rtx_res += rtextents;
 	}
 
 	return 0;
@@ -765,6 +766,19 @@ _("Transaction block reservation exceeded! %u > %u\n"),
 		tp->t_ifree_delta += delta;
 		break;
 	case XFS_TRANS_SB_FREXTENTS:
+		/*
+		 * Track the number of rt extents allocated in the transaction.
+		 * Make sure it does not exceed the number reserved.
+		 */
+		if (delta < 0) {
+			tp->t_rtx_res_used += (uint)-delta;
+			if (tp->t_rtx_res_used > tp->t_rtx_res) {
+				fprintf(stderr,
+_("Transaction rt block reservation exceeded! %u > %u\n"),
+					tp->t_rtx_res_used, tp->t_rtx_res);
+				ASSERT(0);
+			}
+		}
 		tp->t_frextents_delta += delta;
 		break;
 	default:

