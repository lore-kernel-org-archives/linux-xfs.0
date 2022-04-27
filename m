Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3804FC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356543AbiD0Azc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356541AbiD0Azc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4AF17E17
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A7C061AED
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EBAC385A4;
        Wed, 27 Apr 2022 00:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020740;
        bh=vxUcY9SqFFcedPyxRRTNa054RFo/9fusdmyhIgDJ7Xc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xu644KHZTqZ4Ep/wRpmSh8jkgKTeb5SaDsDuurDdbU6t4SWCslQfmhP4mXCniAUdA
         adZF9/epnvC9wqo7ZlXVjzx/LJfUxIm30C7aS06KHoVSRaBrid+d+lRBRx6RcpTE43
         hGinR5w9zFqIsw7E9IsZcijE5OMFPnxDDiIoTKbwd7BXPkwdEKDdXMDaOOgRbUr/H7
         Pbn4Aqa+8G4AMJEIdq5jwZxOOUvmTVsVeMZf/OhvXM5XtaSDtHq49+RDwDrMTfvZlV
         vstZU5/iYJknPpvbdisIazgcS4uNCOhTVwK40khD92exe6yRo4PmjPZjOc6Q21JBFs
         p2hG+BMQXDgwQ==
Subject: [PATCH 5/9] xfs: report "max_resp" used for min log size computation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:52:20 -0700
Message-ID: <165102074043.3922658.16450368163586208910.stgit@magnolia>
In-Reply-To: <165102071223.3922658.5241787533081256670.stgit@magnolia>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the tracepoint that computes the size of the transaction used to
compute the minimum log size into xfs_log_get_max_trans_res so that we
only have to compute this stuff once.

Leave xfs_log_get_max_trans_res as a non-static function so that xfs_db
can call it to report the results of the userspace computation of the
same value to diagnose mkfs/kernel misinteractions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |    1 +
 fs/xfs/xfs_trace.h             |   19 +++++++++++++++++++
 fs/xfs/xfs_trans.c             |    3 ---
 3 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 4d04568ab07e..1db27c3a1d16 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -76,6 +76,7 @@ xfs_log_get_max_trans_res(
 		*max_resp = resv.tr_attrsetm;	/* struct copy */
 		max_resp->tr_logres = attr_space;
 	}
+	trace_xfs_log_get_max_trans_res(mp, max_resp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9110bb5dd866..a690987cc5f0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3534,6 +3534,25 @@ DEFINE_EVENT(xfs_trans_resv_class, name, \
 DEFINE_TRANS_RESV_EVENT(xfs_trans_resv_calc);
 DEFINE_TRANS_RESV_EVENT(xfs_trans_resv_calc_minlogsize);
 
+TRACE_EVENT(xfs_log_get_max_trans_res,
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_trans_res *res),
+	TP_ARGS(mp, res),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(uint, logres)
+		__field(int, logcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->logres = res->tr_logres;
+		__entry->logcount = res->tr_logcount;
+	),
+	TP_printk("dev %d:%d logres %u logcount %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->logres,
+		  __entry->logcount)
+);
+
 DECLARE_EVENT_CLASS(xfs_trans_class,
 	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip),
 	TP_ARGS(tp, caller_ip),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 836ce2beac53..82cf0189c0db 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -32,7 +32,6 @@ static void
 xfs_trans_trace_reservations(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans_res	resv;
 	struct xfs_trans_res	*res;
 	struct xfs_trans_res	*end_res;
 	int			i;
@@ -41,8 +40,6 @@ xfs_trans_trace_reservations(
 	end_res = (struct xfs_trans_res *)(M_RES(mp) + 1);
 	for (i = 0; res < end_res; i++, res++)
 		trace_xfs_trans_resv_calc(mp, i, res);
-	xfs_log_get_max_trans_res(mp, &resv);
-	trace_xfs_trans_resv_calc(mp, -1, &resv);
 }
 #else
 # define xfs_trans_trace_reservations(mp)

