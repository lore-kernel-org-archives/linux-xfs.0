Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20352C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347380AbiDNW5L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiDNW5K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EEB21242
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB56B62078
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D58C385A5;
        Thu, 14 Apr 2022 22:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976883;
        bh=22ypJ0XZVXR5fEG0KJNRg1dMiLYyVGecjXuN7JzkTDQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=khwNVY0qiFOvuinpSCvbl3Agtd7X6ltP2GhBhFRIFI0MutfYnTjNzY2i3OSP7lK3T
         FdVIOReNvxp9BYIUZawCAX/3H1Yc2AZvSepKKBpYOyKP/hT4E5Y8s7eUn38ZM4HOja
         TGNpYd7hES1PZpzajMBgsQQvl6ksM0z0CJmaRd2TutRuYf5msmi/Yn45dykIoNhIjl
         y8IYBgaXc1SPDOJ7tm3LakxKxT7tps/jU4YhiueH2MPty3owKMIw5M7aVu/oCDTsDm
         sG25aD9umqVy75lUEeUEYTLtsM9oUafU2jUmNYJlwYOxwc8PdSG7PCVIIOsZ8X7ket
         hpx4RrwdSUDYw==
Subject: [PATCH 3/6] xfs: create shadow transaction reservations for computing
 minimum log size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:42 -0700
Message-ID: <164997688275.383881.1038640482191339784.stgit@magnolia>
In-Reply-To: <164997686569.383881.8935566398533700022.stgit@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_log_rlimit.c |   17 +++++++++++++----
 fs/xfs/libxfs/xfs_trans_resv.c |   12 ++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |    2 ++
 fs/xfs/xfs_trace.h             |   12 ++++++++++--
 4 files changed, 37 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 67798ff5e14e..2bafc69cac15 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -14,6 +14,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_trace.h"
 
 /*
  * Calculate the maximum length in bytes that would be required for a local
@@ -47,18 +48,25 @@ xfs_log_get_max_trans_res(
 	struct xfs_trans_res	*max_resp)
 {
 	struct xfs_trans_res	*resp;
+	struct xfs_trans_res	*start_resp;
 	struct xfs_trans_res	*end_resp;
+	struct xfs_trans_resv	*resv;
 	int			log_space = 0;
 	int			attr_space;
 
 	attr_space = xfs_log_calc_max_attrsetm_res(mp);
 
-	resp = (struct xfs_trans_res *)M_RES(mp);
-	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
-	for (; resp < end_resp; resp++) {
+	resv = kmem_zalloc(sizeof(struct xfs_trans_resv), 0);
+	xfs_trans_resv_calc_logsize(mp, resv);
+
+	start_resp = (struct xfs_trans_res *)resv;
+	end_resp = (struct xfs_trans_res *)(resv + 1);
+	for (resp = start_resp; resp < end_resp; resp++) {
 		int		tmp = resp->tr_logcount > 1 ?
 				      resp->tr_logres * resp->tr_logcount :
 				      resp->tr_logres;
+
+		trace_xfs_trans_resv_calc_logsize(mp, resp - start_resp, resp);
 		if (log_space < tmp) {
 			log_space = tmp;
 			*max_resp = *resp;		/* struct copy */
@@ -66,9 +74,10 @@ xfs_log_get_max_trans_res(
 	}
 
 	if (attr_space > log_space) {
-		*max_resp = M_RES(mp)->tr_attrsetm;	/* struct copy */
+		*max_resp = resv->tr_attrsetm;	/* struct copy */
 		max_resp->tr_logres = attr_space;
 	}
+	kmem_free(resv);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6f83d9b306ee..12d4e451e70e 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -933,3 +933,15 @@ xfs_trans_resv_calc(
 	/* Put everything back the way it was.  This goes at the end. */
 	mp->m_rmap_maxlevels = rmap_maxlevels;
 }
+
+/*
+ * Compute an alternate set of log reservation sizes for use exclusively with
+ * minimum log size calculations.
+ */
+void
+xfs_trans_resv_calc_logsize(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	xfs_trans_resv_calc(mp, resp);
+}
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index fc4e9b369a3a..9fa4863f72a4 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -89,6 +89,8 @@ struct xfs_trans_resv {
 #define	XFS_ATTRSET_LOG_COUNT		3
 #define	XFS_ATTRRM_LOG_COUNT		3
 
+void xfs_trans_resv_calc_logsize(struct xfs_mount *mp,
+		struct xfs_trans_resv *resp);
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ecde0be3030a..d24784ab8cea 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3516,7 +3516,7 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
-TRACE_EVENT(xfs_trans_resv_calc,
+DECLARE_EVENT_CLASS(xfs_trans_resv_class,
 	TP_PROTO(struct xfs_mount *mp, unsigned int type,
 		 struct xfs_trans_res *res),
 	TP_ARGS(mp, type, res),
@@ -3540,7 +3540,15 @@ TRACE_EVENT(xfs_trans_resv_calc,
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
+DEFINE_TRANS_RESV_EVENT(xfs_trans_resv_calc_logsize);
 
 DECLARE_EVENT_CLASS(xfs_trans_class,
 	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip),

