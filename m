Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63344C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D4992074F
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IYBUHzzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389634AbgF3PmH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:42:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389628AbgF3PmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:42:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFRHCo109553
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bJY5pYEV7ErAz3hQ23ScDFK5AI0GiTL2D+B4eck3QQg=;
 b=IYBUHzzZ9WGBe2ZfplVPllDGTo9mzBbUpBH7FqtgzQo0FhVQ+lvy0ifDPoPGTWSX8oHz
 mXUvMKP2qn6f2YMNFZMMCEQVObzy7uSUyODdOvi9kJKIN7TXZHcdCKGxoi+gKMidSOZe
 7+7BhDqAX2V3knFhESXFHEATet07xTIU7kbUTqo6twlfX6H+8k5CYoUotYsgFIS75N+S
 S0s0sYQ7eW+yzObdAH4nxewysB0517zg3iGrjsYPHz66RL14XuAvtNsEMWPXGFwv/wIa
 0KszNJJ2ukdTuvVOj4CpGtHU/u69U0s5qudvsk8M9IXTL/DISR6nU8dIe5odbrdMK2cB GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31ywrbkja5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFNkX2051124
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31xg1wy5b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:05 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UFg4E9013276
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:42:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:42:03 +0000
Subject: [PATCH 02/18] xfs: fix inode quota reservation checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:42:02 -0700
Message-ID: <159353172261.2864738.3201442261854530990.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_trans_dqresv is the function that we use to make reservations
against resource quotas.  Each resource contains two counters: the
q_core counter, which tracks resources allocated on disk; and the dquot
reservation counter, which tracks how much of that resource has either
been allocated or reserved by threads that are working on metadata
updates.

For disk blocks, we compare the proposed reservation counter against the
hard and soft limits to decide if we're going to fail the operation.
However, for inodes we inexplicably compare against the q_core counter,
not the incore reservation count.

Since the q_core counter is always lower than the reservation count and
we unlock the dquot between reservation and transaction commit, this
means that multiple threads can reserve the last inode count before we
hit the hard limit, and when they commit, we'll be well over the hard
limit.

Fix this by checking against the incore inode reservation counter, since
we would appear to maintain that correctly (and that's what we report in
GETQUOTA).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c0f73b82c055..ed0ce8b301b4 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -647,7 +647,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
+			total_count = dqp->q_res_icount + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = defq->iwarnlimit;

