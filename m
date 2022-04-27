Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7FCC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356530AbiD0Az0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356539AbiD0AzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC1013DC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE05161AED
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409CBC385A0;
        Wed, 27 Apr 2022 00:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020735;
        bh=MvO7w7GVO1gufFwt2917uH+tOdPJTrkraMOaMWZjVhE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g2vgqZTHm8Ji7/F+2vRzmQlsnDEBAm/EGvTPtvAd5amRv9W54obEDdMb+ufhshym6
         j49kIZJj7godsdDex6xAmWGtIiR8jYdiAhtM/fW4UpqszRQ7WY0n1BqOm05SYmwB1E
         B5c3vZW3BkDxbkIQ8bE1p+StSONknAE+ufDPnbHBSvU3Q4Vm9uuFbXJSgzApIhIh/f
         lxYe6X+2HwfiP/bAlkO9cRbskcVv2v2wgT/kkfNNiTq04Bmemivcza+FWj7x5JYLdj
         3zxNC+C9CIkqet+upQMrwXOuwFdthyW16nDNSZ0BuLfoBNCTxYp4y/F9nd0U7eHfur
         cpLm5e0MaIJkw==
Subject: [PATCH 4/9] xfs: create shadow transaction reservations for computing
 minimum log size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:52:14 -0700
Message-ID: <165102073482.3922658.3874181264513799865.stgit@magnolia>
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

Every time someone changes the transaction reservation sizes, they
introduce potential compatibility problems if the changes affect the
minimum log size that we validate at mount time.  If the minimum log
size gets larger (which should be avoided because doing so presents a
serious risk of log livelock), filesystems created with old mkfs will
not mount on a newer kernel; if the minimum size shrinks, filesystems
created with newer mkfs will not mount on older kernels.

Therefore, enable the creation of a shadow log reservation structure
where we can "undo" the effects of tweaks when computing minimum log
sizes.  These shadow reservations should never be used in practice, but
they insulate us from perturbations in minimum log size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   15 +++++++++++----
 fs/xfs/xfs_trace.h             |   12 ++++++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 67798ff5e14e..4d04568ab07e 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -14,6 +14,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_trace.h"
 
 /*
  * Calculate the maximum length in bytes that would be required for a local
@@ -46,19 +47,25 @@ xfs_log_get_max_trans_res(
 	struct xfs_mount	*mp,
 	struct xfs_trans_res	*max_resp)
 {
+	struct xfs_trans_resv	resv;
 	struct xfs_trans_res	*resp;
 	struct xfs_trans_res	*end_resp;
+	unsigned int		i;
 	int			log_space = 0;
 	int			attr_space;
 
 	attr_space = xfs_log_calc_max_attrsetm_res(mp);
 
-	resp = (struct xfs_trans_res *)M_RES(mp);
-	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
-	for (; resp < end_resp; resp++) {
+	memcpy(&resv, M_RES(mp), sizeof(struct xfs_trans_resv));
+
+	resp = (struct xfs_trans_res *)&resv;
+	end_resp = (struct xfs_trans_res *)(&resv + 1);
+	for (i = 0; resp < end_resp; i++, resp++) {
 		int		tmp = resp->tr_logcount > 1 ?
 				      resp->tr_logres * resp->tr_logcount :
 				      resp->tr_logres;
+
+		trace_xfs_trans_resv_calc_minlogsize(mp, i, resp);
 		if (log_space < tmp) {
 			log_space = tmp;
 			*max_resp = *resp;		/* struct copy */
@@ -66,7 +73,7 @@ xfs_log_get_max_trans_res(
 	}
 
 	if (attr_space > log_space) {
-		*max_resp = M_RES(mp)->tr_attrsetm;	/* struct copy */
+		*max_resp = resv.tr_attrsetm;	/* struct copy */
 		max_resp->tr_logres = attr_space;
 	}
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 91b916e82364..9110bb5dd866 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3500,7 +3500,7 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
-TRACE_EVENT(xfs_trans_resv_calc,
+DECLARE_EVENT_CLASS(xfs_trans_resv_class,
 	TP_PROTO(struct xfs_mount *mp, unsigned int type,
 		 struct xfs_trans_res *res),
 	TP_ARGS(mp, type, res),
@@ -3524,7 +3524,15 @@ TRACE_EVENT(xfs_trans_resv_calc,
 		  __entry->logres,
 		  __entry->logcount,
 		  __entry->logflags)
-);
+)
+
+#define DEFINE_TRANS_RESV_EVENT(name) \
+DEFINE_EVENT(xfs_trans_resv_class, name, \
+	TP_PROTO(struct xfs_mount *mp, unsigned int type, \
+		 struct xfs_trans_res *res), \
+	TP_ARGS(mp, type, res))
+DEFINE_TRANS_RESV_EVENT(xfs_trans_resv_calc);
+DEFINE_TRANS_RESV_EVENT(xfs_trans_resv_calc_minlogsize);
 
 DECLARE_EVENT_CLASS(xfs_trans_class,
 	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip),

