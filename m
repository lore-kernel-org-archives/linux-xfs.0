Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A222C5519F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 17:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F02C121D7F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 17:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SNqL8cNo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKLRpw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 12:45:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgKLRpw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 12:45:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACHhN0Q182153;
        Thu, 12 Nov 2020 17:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=cRenlXtOvoKV1YMeZZcWN5SaUFkv21/sdP1+SBER/+8=;
 b=SNqL8cNoTsWrD/5TjGQQkjKbVw1gycPhY/GUi/gad29vF7qK2KJIcvtkZUKG5bO1KfFE
 XWpMCisg4UjDZdhReTs7BuFSf7m/OqjDyJyhYHjkV4Chg2T5x4BwcM9f4LzCV3bYA1Id
 j/JZK4AWuH1J/ZbyYlZYLc7CI/yjJjktRXLiBprF92AKdEhZGu+MCa2FtPv9JIcmCaij
 AiaE7aao66hJjJVm15gSvNiZkVLUy3R5kuxAbTxv0N4tM+iKdQzAnSQZXnav5wWmQXMF
 D8Jw1WeWd3IsxfhLYNebzSOFHIxw/gy9hHEK0MqfGH3huGUkA45MdcCCFzd4jMXJKWxe 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72evx6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 17:45:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACHaGR0020613;
        Thu, 12 Nov 2020 17:43:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34rtks53kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 17:43:47 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACHhlAs024118;
        Thu, 12 Nov 2020 17:43:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 09:43:46 -0800
Date:   Thu, 12 Nov 2020 09:43:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: add realtime extent reservation and usage tracking
 to transactions
Message-ID: <20201112174345.GT9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120105
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

An upcoming patch will add to the deferred ops code the ability to
capture the unfinished deferred ops and transaction reservation for
later replay during log recovery.  This requires transactions to have
the ability to track rt extent reservations and usage, so add that
missing piece now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
FWIW this should have been a prep patch ahead of "xfs: xfs_defer_capture
should absorb remaining block reservations" but I goofed.  Sorry about
that... :(
---
 include/xfs_trans.h |    2 ++
 libxfs/trans.c      |   14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 9292a4a54237..f19914068030 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -64,9 +64,11 @@ typedef struct xfs_trans {
 	unsigned int	t_log_res;		/* amt of log space resvd */
 	unsigned int	t_log_count;		/* count for perm log res */
 	unsigned int	t_blk_res;		/* # of blocks resvd */
+	unsigned int	t_rtx_res;
 	xfs_fsblock_t	t_firstblock;		/* first block allocated */
 	struct xfs_mount *t_mountp;		/* ptr to fs mount struct */
 	unsigned int	t_blk_res_used;		/* # of resvd blocks used */
+	unsigned int	t_rtx_res_used;
 	unsigned int	t_flags;		/* misc flags */
 	long		t_icount_delta;		/* superblock icount change */
 	long		t_ifree_delta;		/* superblock ifree change */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 6838b727350b..912e95b8d708 100644
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
