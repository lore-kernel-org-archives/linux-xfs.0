Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501B3FC6196
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 233EA2077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yi79auVL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733006AbfKGDC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:02:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:02:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x4eU023946
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jy13RaK9zThgwILsHIzQ5kCFjEJ3ovE+CH7o5aVKStc=;
 b=Yi79auVLAJ1MqTI/8E50iGanXf/ZLcV5cY043SA2uWYtJzOcobWZjedRa9R/UghFVNv/
 B2xOu1xV8VUhYuUGuNxdekTw3BS1iNS4AMLkFnQ1tKd6Qv95n5mssyfRAMsSHGD9IL7L
 snFZL8JiK2oer/3n4agui5okDuAuM/1tOwaOLQkMMp1cSe+DdUodIqUJCsAqUR4Yi0ra
 kq4wbhceEYeswcjjradp5EBB+UyKlPfijuemXPqiCLNYbHo/u1STAVfL79fLcNOiL8nX
 JnLu7CPJX2upO9ZeZczcMSj9rOTUGaDjIi5Dgt24+WCmnQVIqDytsxBjTJyuWnoRruma dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w41w0u0jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wh0s106480
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w41wg134b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA732Q1a028972
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:02:26 -0800
Subject: [PATCH 1/6] xfs: annotate functions that trip static checker
 locking checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:02:25 -0800
Message-ID: <157309574505.46520.7461860244690955225.stgit@magnolia>
In-Reply-To: <157309573874.46520.18107298984141751739.stgit@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some lock annotations to helper functions that seem to have
unbalanced locking that confuses the static analyzers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c      |    1 +
 fs/xfs/xfs_log_priv.h |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d7d3bfd6a920..1b4e37bbce53 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2808,6 +2808,7 @@ xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
 	bool			aborted)
+	__releases(&log->l_icloglock) __acquires(&log->l_icloglock)
 {
 	spin_unlock(&log->l_icloglock);
 	spin_lock(&iclog->ic_callback_lock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4f19375f6592..78fef8fc18b3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -537,7 +537,10 @@ xlog_cil_force(struct xlog *log)
  * by a spinlock. This matches the semantics of all the wait queues used in the
  * log code.
  */
-static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
+static inline void
+xlog_wait(
+	struct wait_queue_head	*wq,
+	struct spinlock		*lock) __releases(lock)
 {
 	DECLARE_WAITQUEUE(wait, current);
 

