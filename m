Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1055EC5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6FD52087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XhdVBMml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfKHHEz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:04:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39052 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:04:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873wx1055560
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rC0RCdZFetQiu0j0x7wut1wc3YVFYtwpCJmRwRE/e+c=;
 b=XhdVBMmlqU4nd15NxBfmNFIL1T2MMUNft3FGGX+kcid9pJ5HWo07r0o6no87jhkojWRG
 yLYlvBNwGqVYauwdkmy0goG8yynTv0IVzNSkWx/6vmzzffW1AUdg2+uzzuUuMqBWY2EU
 0Bxz0GDdNlF3/0mLvnOIR/MUm+T/+60JygRNqVlfc8zBJpuBDf6+5ttO/EyYgLwvLNFJ
 zjNj8RdYqzK5YqHb4VmPTd2TilwvVov5iHmrm2L+SEaUmGehZBrvwBKbh/2SD/XrfWp9
 48haVT9d8y8O5hAgkrwTC/hYmFaJgdWOztNtoeWfeu6TU4hBGZzZr1ywq/0QIoaHJ/Mm sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w13bd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:04:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873vcR182913
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:04:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wh0gyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:04:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA874qqT018059
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:04:52 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:04:52 -0800
Subject: [PATCH 1/3] xfs: annotate functions that trip static checker
 locking checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Nov 2019 23:04:51 -0800
Message-ID: <157319669162.834585.14162759688911694187.stgit@magnolia>
In-Reply-To: <157319668531.834585.6920821852974178.stgit@magnolia>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some lock annotations to helper functions that seem to have
unbalanced locking that confuses the static analyzers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c      |    2 ++
 fs/xfs/xfs_log_priv.h |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d7d3bfd6a920..3806674090ed 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2808,6 +2808,8 @@ xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
 	bool			aborted)
+		__releases(&log->l_icloglock)
+		__acquires(&log->l_icloglock)
 {
 	spin_unlock(&log->l_icloglock);
 	spin_lock(&iclog->ic_callback_lock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4f19375f6592..c47aa2ca6dc7 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -537,7 +537,11 @@ xlog_cil_force(struct xlog *log)
  * by a spinlock. This matches the semantics of all the wait queues used in the
  * log code.
  */
-static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
+static inline void
+xlog_wait(
+	struct wait_queue_head	*wq,
+	struct spinlock		*lock)
+		__releases(lock)
 {
 	DECLARE_WAITQUEUE(wait, current);
 

