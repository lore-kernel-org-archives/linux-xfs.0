Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34B1C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC512074B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xRW+jOzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgGOBxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:53:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOBxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:53:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1kufg101607;
        Wed, 15 Jul 2020 01:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=01f/UtIbD94Hgq8WmhWV9TwYe7aI+DECMf2qlAwxK8s=;
 b=xRW+jOzS/SN9/l27DtQAiHcrfnMNXJMeGEHIzB5HMZbDmDi5aWnz8opDoDObjQpkIcCM
 bVNzWxFGedJiA/n4N9LfUIOQAyx8okOsOmj90DtGNSpCGfgUX0sLSJy0NJhtujVaaR5s
 +PdruoHQZvQkW2KfLDo86xR5E1Q6fI6STnwiHDqb6WX/v1gpWcJeVHU1dScoWa3pjW0V
 Jc6HX669cMZfHEm7SiJnggO3fAB6Syd3xOg16fOL+O+A+PfH6ZieaCG0XSpLyAjaPSfh
 IOAr9/m+zzHwlWoAz3V+N+bSArUAJWB/pW+2kfdrmxze/+m6E/IbcnWXX+TRGiebK0kA fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762ngggk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:51:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lamB184505;
        Wed, 15 Jul 2020 01:51:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb5wr3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:51:43 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1pgdn023601;
        Wed, 15 Jul 2020 01:51:42 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:51:41 -0700
Subject: [PATCH 10/26] xfs: stop using q_core.d_flags in the quota code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:51:40 -0700
Message-ID: <159477790082.3263162.2486913704651505901.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the incore dq_flags to figure out the dquot type.  This is the first
step towards removing xfs_disk_dquot from the incore dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c      |   34 ++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_dquot.h      |    2 ++
 fs/xfs/xfs_dquot_item.c |    6 ++++--
 3 files changed, 38 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6fcea0d3989e..93b5b7277cb8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -568,6 +568,15 @@ xfs_dquot_from_disk(
 	return 0;
 }
 
+/* Copy the in-core quota fields into the on-disk buffer. */
+void
+xfs_dquot_to_disk(
+	struct xfs_disk_dquot	*ddqp,
+	struct xfs_dquot	*dqp)
+{
+	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
+}
+
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
 static int
 xfs_qm_dqread_alloc(
@@ -1122,6 +1131,19 @@ xfs_dquot_done(
 	}
 }
 
+/* Check incore dquot for errors before we flush. */
+static xfs_failaddr_t
+xfs_qm_dqflush_check(
+	struct xfs_dquot	*dqp)
+{
+	if (dqp->q_type != XFS_DQTYPE_USER &&
+	    dqp->q_type != XFS_DQTYPE_GROUP &&
+	    dqp->q_type != XFS_DQTYPE_PROJ)
+		return __this_address;
+
+	return NULL;
+}
+
 /*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
@@ -1180,8 +1202,16 @@ xfs_qm_dqflush(
 		goto out_abort;
 	}
 
-	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
+	fa = xfs_qm_dqflush_check(dqp);
+	if (fa) {
+		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
+				be32_to_cpu(dqp->q_core.d_id), fa);
+		xfs_buf_relse(bp);
+		error = -EFSCORRUPTED;
+		goto out_abort;
+	}
+
+	xfs_dquot_to_disk(ddqp, dqp);
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 7f3f734bced8..84399d1d8188 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -151,6 +151,8 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 	return false;
 }
 
+void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
+
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_USER)
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d7e4de7151d7..fc21e48c889c 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -45,6 +45,7 @@ xfs_qm_dquot_logitem_format(
 	struct xfs_log_item	*lip,
 	struct xfs_log_vec	*lv)
 {
+	struct xfs_disk_dquot	ddq;
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_dq_logformat	*qlf;
@@ -58,8 +59,9 @@ xfs_qm_dquot_logitem_format(
 	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
 	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_dq_logformat));
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT,
-			&qlip->qli_dquot->q_core,
+	xfs_dquot_to_disk(&ddq, qlip->qli_dquot);
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT, &ddq,
 			sizeof(struct xfs_disk_dquot));
 }
 

