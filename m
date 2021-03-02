Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECF6C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 597196148E
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbhCBGjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242583AbhCBCy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 21:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614653581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syJAbd8h09jBQ8/g4k3fRAl3Qr7NcBT800qyHfUnx/s=;
        b=FXmXoYFzXkzRZe1rDQAfUlNLGGxiWc6um/l24dO2Bm9ULGwMAiGrqRcntlNi34RWhF9uPG
        oj7ttz7+SAVfwqEtaGZGzJOxMLkieWbaz1qDsx7cAByYDSNJy4qNv0WcOapRaQRcLylwak
        V6z/GvRQQf/8LoTltdRlktUX+NUcWco=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-C0GTx5jhM0aDA9Jem0L4KQ-1; Mon, 01 Mar 2021 21:49:19 -0500
X-MC-Unique: C0GTx5jhM0aDA9Jem0L4KQ-1
Received: by mail-pg1-f200.google.com with SMTP id i10so10978383pgm.7
        for <linux-xfs@vger.kernel.org>; Mon, 01 Mar 2021 18:49:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syJAbd8h09jBQ8/g4k3fRAl3Qr7NcBT800qyHfUnx/s=;
        b=iAH8vomwxHBiTZ89JhkqP7nO1bbWRFSPWdIg6fjc+nJwp5usnbPf2+wvE27drl4fbO
         2OEQTGBWUyqTsQZnh7ZOVLvB+l3ZD4xQVduQRDM+HYbxA4PwqAShY85d1DGGvicTJ1C2
         cPkH3MKwJNZvN5VU6fq+7VjjA/9EzaZtc/6ecYcjtQQVgVpSfvJ9JDmRXzD34ZVrykw+
         C2g16qPcb8VNR3ddJmoZilgQi3azs5LyE7KdOZeSvaPoQjPeHkDgGhUbqvF5WJj2iG6Q
         RWPEuJ0jZFUjd5DVA45d9rFtc2bHnvoUj0jAXyDoxJEHIbY198LX9/i1e9S/4sM13uLv
         535Q==
X-Gm-Message-State: AOAM530M9Ar7G/tPPrlEQ1XjCRIsC5Z1Fb+MoYDGFC4/+KbBcm0J3VeV
        Lfvm8GP/BWrybHd90Dz6MIfETtyKFC5iPQoKH7WC1mV+ceeYeigCBxONvCmHZZsnffm1XNCJpFk
        ByJOjVEv6ewpGE0CEKBTpqKXF59SbHM/F7QbKD5Lm9E8TzlYmKF9maszgU7YHs86H389g2ORi0A
        ==
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr1919479pjz.63.1614653357717;
        Mon, 01 Mar 2021 18:49:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5TrdJ6Q0OTedyknySG1s0tBzVm6GtzqOIZ5HfOGFYq8y7c5G857hERZc/pVgYF8DaMWRD1w==
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr1919450pjz.63.1614653357407;
        Mon, 01 Mar 2021 18:49:17 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d24sm18451031pfr.139.2021.03.01.18.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:49:17 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH v7 2/5] xfs: hoist out xfs_resizefs_init_new_ags()
Date:   Tue,  2 Mar 2021 10:48:13 +0800
Message-Id: <20210302024816.2525095-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210302024816.2525095-1-hsiangkao@redhat.com>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
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
 fs/xfs/xfs_fsops.c | 110 ++++++++++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9f9ba8bd0213..494f9354e3fb 100644
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
@@ -32,8 +90,8 @@ xfs_growfs_data_private(
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
-	xfs_rfsblock_t		nb, nb_div, nb_mod;
-	xfs_rfsblock_t		delta;
+	xfs_rfsblock_t		nb, nb_div, nb_mod, delta;
+	bool			lastag_resetagres;
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
@@ -74,48 +132,11 @@ xfs_growfs_data_private(
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
@@ -123,9 +144,8 @@ xfs_growfs_data_private(
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
 
@@ -152,7 +172,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (delta) {
+	if (lastag_resetagres) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
-- 
2.27.0

