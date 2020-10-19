Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DBFC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C57CA2231B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HrUBuPLJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgJSQ3W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:29:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729849AbgJSQ3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 12:29:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JGOYlA155292
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 16:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=n/ICPz/31M99aS4no5ceV+ATtTgiaoKXW2uZZ2jRlmo=;
 b=HrUBuPLJ+ykzavwk9WgFsTNihflXZHgg3FvDvmT3k+wEunOqiojhxvBLEQNEIl8b+ZFY
 RbNQ2Nz+C6CiB4txIrj0A//iUUjbNDlhYv32YbPG3zm+WCxrTeHDm4kuTuoGIxe1t6MO
 lLlnWPMQ9Wys+SOLWUY0Ue3KNrAFgVbC5lY0W7sP9EQ5jzfAfFARwB1eX4x7xu6o8Ypc
 wnSy3JMruQ/LJ46SQ5gawSg92B3/9nDR7ezKIPmSgLWri/vgoGZ2aMCoqGJo8xnlLWn4
 4NfyVRFy27jLCfL7q8xJn9z5PlrGwkDVBVkO9rAZssHKmGRM/TgDJdCaiFxMuxbsaaUm EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 347s8mpeeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 16:29:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JGJp4P024222
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 16:29:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 348acpp0k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 16:29:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JGTJn6022562
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 16:29:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 09:29:19 -0700
Date:   Mon, 19 Oct 2020 09:29:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: cancel intents immediately if process_intents fails
Message-ID: <20201019162917.GJ9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=1
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190113
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If processing recovered log intent items fails, we need to cancel all
the unprocessed recovered items immediately so that a subsequent AIL
push in the bail out path won't get wedged on the pinned intent items
that didn't get processed.

This can happen if the log contains (1) an intent that gets and releases
an inode, (2) an intent that cannot be recovered successfully, and (3)
some third intent item.  When recovery of (2) fails, we leave (3) pinned
in memory.  Inode reclamation is called in the error-out path of
xfs_mountfs before xfs_log_cancel_mount.  Reclamation calls
xfs_ail_push_all_sync, which gets stuck waiting for (3).

Therefore, call xlog_recover_cancel_intents if _process_intents fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a8289adc1b29..87886b7f77da 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3446,6 +3446,14 @@ xlog_recover_finish(
 		int	error;
 		error = xlog_recover_process_intents(log);
 		if (error) {
+			/*
+			 * Cancel all the unprocessed intent items now so that
+			 * we don't leave them pinned in the AIL.  This can
+			 * cause the AIL to livelock on the pinned item if
+			 * anyone tries to push the AIL (inode reclaim does
+			 * this) before we get around to xfs_log_mount_cancel.
+			 */
+			xlog_recover_cancel_intents(log);
 			xfs_alert(log->l_mp, "Failed to recover intents");
 			return error;
 		}
