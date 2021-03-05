Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0E8C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B37F64FE9
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCEC5x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:57:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhCEC5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 21:57:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KiRErMeigNgDcmq9JJTRtbgxvUKq5A68Wk3FeYjftXc=;
        b=h7i2+7JOratoHQEcCDmE5kpNQvGQ5/E0A1ONKcTRkRdaQnFHsLGgxpsTGqqImXBR5J5hSh
        JQNSLpsLlfoghqelwli5Cv3IwD8EGnJw7yPLn31jycUlkeJ2YB0ovZZYoa5Yrar8Kyhb7c
        itxUCSqNcJfRvizkWj+9R703PU02Xyk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-h_AuRX3ZNlucgq13Sg94vA-1; Thu, 04 Mar 2021 21:57:51 -0500
X-MC-Unique: h_AuRX3ZNlucgq13Sg94vA-1
Received: by mail-pj1-f72.google.com with SMTP id m1so445662pjs.9
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 18:57:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiRErMeigNgDcmq9JJTRtbgxvUKq5A68Wk3FeYjftXc=;
        b=VLtdoyVL5sGJkSmroSHkMUBXO7JlNtHd/PJEsIH+zyVbsSoNOqYtfcYmR5MXIgHFRZ
         ZtkCGaPvyB8I2pAmVvMneH+LDNX2d/NviSXe/rVzNWqmf2OQVpbHpc3UAuC+KSVMJms9
         ohjZ0WY4V083Ganc8XYebT4qeNLXasfqLyKTu9Ok1YiVuLVEI4fQFZ5xeD1Pc7QQMxrF
         ikmwu8xKRksSUcpxi89qjTNl9jcsk2eqO9TWxsP9bQnJJgiK4Gy7QDPUXZ8NyZjseNY4
         siqIr6CI9bvk6JHdTvR2oDaurSD3Rtcg8tStOQUNDfOLBvbxQxlMqCgA5QD28uqWiYNT
         TH5A==
X-Gm-Message-State: AOAM530YBc/am1HrhYZlChBC9lYe8MtrMS92YplUjbbVmUo6g/36+0rp
        qCmduROxdDy404CppR3CLCWuHdElTQS6FOZ7ipp1/vzbhqxs3EpRstpvI0WPhyHuQYR3fQ3Pafg
        5Bj3BPKV9Vm+ycLDkNtFh4gD/tGfmee3tyxZNOA06h4IvaI5FDQssUG8YJmrMfazpLDP8u48MpQ
        ==
X-Received: by 2002:a17:902:cb0b:b029:e5:b670:d905 with SMTP id c11-20020a170902cb0bb02900e5b670d905mr6999496ply.18.1614913069996;
        Thu, 04 Mar 2021 18:57:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfaj5jCGtuwKLDt14l+cV41znEqG5ySGSiofASi9oDwYsMsZMmagZnVX8iYJVFUSyGWDQ77g==
X-Received: by 2002:a17:902:cb0b:b029:e5:b670:d905 with SMTP id c11-20020a170902cb0bb02900e5b670d905mr6999461ply.18.1614913069491;
        Thu, 04 Mar 2021 18:57:49 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m19sm533414pjn.21.2021.03.04.18.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:57:49 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH v8 2/5] xfs: hoist out xfs_resizefs_init_new_ags()
Date:   Fri,  5 Mar 2021 10:57:00 +0800
Message-Id: <20210305025703.3069469-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305025703.3069469-1-hsiangkao@redhat.com>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move out related logic for initializing new added AGs to a new helper
in preparation for shrinking. No logic changes.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 107 +++++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9f9ba8bd0213..fc9e799b2ae3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -20,6 +20,64 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
+/*
+ * Write new AG headers to disk. Non-transactional, but need to be
+ * written and completed prior to the growfs transaction being logged.
+ * To do this, we use a delayed write buffer list and wait for
+ * submission and IO completion of the list as a whole. This allows the
+ * IO subsystem to merge all the AG headers in a single AG into a single
+ * IO and hide most of the latency of the IO from us.
+ *
+ * This also means that if we get an error whilst building the buffer
+ * list to write, we can cancel the entire list without having written
+ * anything.
+ */
+static int
+xfs_resizefs_init_new_ags(
+	struct xfs_trans	*tp,
+	struct aghdr_init_data	*id,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	xfs_rfsblock_t		delta,
+	bool			*lastag_resetagres)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + delta;
+	int			error;
+
+	*lastag_resetagres = false;
+
+	INIT_LIST_HEAD(&id->buffer_list);
+	for (id->agno = nagcount - 1;
+	     id->agno >= oagcount;
+	     id->agno--, delta -= id->agsize) {
+
+		if (id->agno == nagcount - 1)
+			id->agsize = nb - (id->agno *
+					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
+		else
+			id->agsize = mp->m_sb.sb_agblocks;
+
+		error = xfs_ag_init_headers(mp, id);
+		if (error) {
+			xfs_buf_delwri_cancel(&id->buffer_list);
+			return error;
+		}
+	}
+
+	error = xfs_buf_delwri_submit(&id->buffer_list);
+	if (error)
+		return error;
+
+	xfs_trans_agblocks_delta(tp, id->nfree);
+
+	if (delta) {
+		*lastag_resetagres = true;
+		error = xfs_ag_extend_space(mp, tp, id, delta);
+	}
+	return error;
+}
+
 /*
  * growfs operations
  */
@@ -34,6 +92,7 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	xfs_rfsblock_t		delta;
+	bool			lastag_resetagres;
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
@@ -74,48 +133,11 @@ xfs_growfs_data_private(
 	if (error)
 		return error;
 
-	/*
-	 * Write new AG headers to disk. Non-transactional, but need to be
-	 * written and completed prior to the growfs transaction being logged.
-	 * To do this, we use a delayed write buffer list and wait for
-	 * submission and IO completion of the list as a whole. This allows the
-	 * IO subsystem to merge all the AG headers in a single AG into a single
-	 * IO and hide most of the latency of the IO from us.
-	 *
-	 * This also means that if we get an error whilst building the buffer
-	 * list to write, we can cancel the entire list without having written
-	 * anything.
-	 */
-	INIT_LIST_HEAD(&id.buffer_list);
-	for (id.agno = nagcount - 1;
-	     id.agno >= oagcount;
-	     id.agno--, delta -= id.agsize) {
-
-		if (id.agno == nagcount - 1)
-			id.agsize = nb -
-				(id.agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
-		else
-			id.agsize = mp->m_sb.sb_agblocks;
-
-		error = xfs_ag_init_headers(mp, &id);
-		if (error) {
-			xfs_buf_delwri_cancel(&id.buffer_list);
-			goto out_trans_cancel;
-		}
-	}
-	error = xfs_buf_delwri_submit(&id.buffer_list);
+	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
+					  delta, &lastag_resetagres);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_agblocks_delta(tp, id.nfree);
-
-	/* If there are new blocks in the old last AG, extend it. */
-	if (delta) {
-		error = xfs_ag_extend_space(mp, tp, &id, delta);
-		if (error)
-			goto out_trans_cancel;
-	}
-
 	/*
 	 * Update changed superblock fields transactionally. These are not
 	 * seen by the rest of the world until the transaction commit applies
@@ -123,9 +145,8 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_sb.sb_dblocks)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
-				 nb - mp->m_sb.sb_dblocks);
+	if (delta > 0)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
 
@@ -152,7 +173,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (delta) {
+	if (lastag_resetagres) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
-- 
2.27.0

