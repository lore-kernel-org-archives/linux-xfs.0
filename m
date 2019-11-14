Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6241C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 21:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D2A620724
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 21:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q859HHFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfKNVLP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 16:11:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfKNVLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 16:11:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEKxEiG029823
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:11:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=MvxFJ5RpmYgLbNhkZ46uUI56jV0yAzCQNMKpASb51Dw=;
 b=Q859HHFt4kcNytMOL4wkd6yjpjM6Tgd7n4KNQ704510KFef6UhjMMT3iQHxDDuPCuxiO
 Q0+YwZ/WVgbvMBp1qDVk0oRojcQW67MPc2ENPJLcBnWUHikOHOdNDuHZY39eeM42m0aj
 Ykcn2IqjSug03+ccK8KPiBrbmAvlngkYUQDu/4JPga/FV3034S+sFsx7/RdSVIDVAAnz
 IcvyQ8LX7rosrelzuvgw27Ghxo+ickqF/mJoIVGowa71eSaGkH71VZN9KO6SXPUz2r4t
 Ar8vwSAkTeW5KQN7vfz9LcfL2GLhG1W6QUfJrsKtV+P9zS+SsRUA0QUXhupzBO7ktdmq +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndqnuja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:11:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEL4Ra9013333
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:11:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w8ngay892-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:11:13 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAELBBWf032118
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 21:11:11 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 13:11:11 -0800
Date:   Thu, 14 Nov 2019 13:11:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix some memory leaks in log recovery
Message-ID: <20191114211110.GM6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a few places where we xlog_alloc_buffer a buffer, hit an error, and
then bail out without freeing the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f64614c3c13e..165f5181d02d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1342,10 +1342,11 @@ xlog_find_tail(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
 				      &rhead_blk, &rhead, &wrapped);
 	if (error < 0)
-		return error;
+		goto done;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto done;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -5300,7 +5301,8 @@ xlog_do_recovery_pass(
 			} else {
 				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
 						log->l_mp);
-				return -EFSCORRUPTED;
+				error = -EFSCORRUPTED;
+				goto bread_err1;
 			}
 		}
 
