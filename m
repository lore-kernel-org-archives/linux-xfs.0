Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03ACEC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA3B611AD
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353535AbhDNTyH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 15:54:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353550AbhDNTx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 15:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618430013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2vcVLA2HPh4J9YEjfsL5yuAM3SA9vDw2eq0hPaFB1g=;
        b=DA4PWmEHUUWgDJwI/d/VQ5SrDo0hLfHOdqWLIebQQRKTQ2FmMCusq+WRhjfHNsoQ3eEPIG
        8IxGtZrrqZOoopEn671TZZOFRURTQjvOYeovduz1UlL1eRA41q9H64d+m32v2IhUEtwmCT
        hRFZy8CYq9XaqTzvYOHKYrY45HpX56I=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-IIZGyE-1POqEzrfSgPkjFA-1; Wed, 14 Apr 2021 15:53:32 -0400
X-MC-Unique: IIZGyE-1POqEzrfSgPkjFA-1
Received: by mail-pj1-f70.google.com with SMTP id k12-20020a17090a590cb029014dd8eb8647so10951842pji.7
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 12:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H2vcVLA2HPh4J9YEjfsL5yuAM3SA9vDw2eq0hPaFB1g=;
        b=a/LkqK/bVtLe794rtLsoRl5fttBJ8X58xnLyJekfOKTnjxmH5UxlnmSf1wBrtFNMcb
         b6FmQsJStptY4mTPC5kXyse0ecOc4kakx2c0K9segU2rSKtHpP//hKaGFpL9EyJnMcdd
         eWa3KiMbtgyY4JhXn3+tIX1ZgHaiPaarZ6s3XLNayTsW2yoXmp2Eh7f0zvdVZQ9Q/rGN
         hEL8y1ssp9Ua28QK1/+7L6YfaBsV9NfGAvfA5gk18a6ydJ5WDm8LD6FScDH/r8mi2VYa
         SWrvZAYmUkIVa9nuh1eqO1hLGxMPiJRkPV8RR4pmklyuItd7302HKQzviLhUJfc4rg0G
         hD+Q==
X-Gm-Message-State: AOAM530N/CP/Jkcvk/JBho9FzUZwBUnOvLR1BEVd+EGhVbmLYUT0l/2J
        szJjuHAkBRXZtpxockKt+HfZxeOge9AGuErW5SsAK651hui6wtLyLTA5+FY+RsB1zrVK/+boin/
        iFWj7t/t566RvdgftnSTLKu04JqI1hAiYmYU+x+w2HNi314U2WHXFGQJw2u6OcRAAX+mo+zh8pg
        ==
X-Received: by 2002:a62:5fc6:0:b029:24d:e86b:dd38 with SMTP id t189-20020a625fc60000b029024de86bdd38mr14638139pfb.64.1618430010545;
        Wed, 14 Apr 2021 12:53:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVzGRfZI0Z+LWYUMtl1z95U1xQMCWIfgXtO5K7YXY0ltRktz7D8cTAdbICGriuChDXtpkB1Q==
X-Received: by 2002:a62:5fc6:0:b029:24d:e86b:dd38 with SMTP id t189-20020a625fc60000b029024de86bdd38mr14638119pfb.64.1618430010192;
        Wed, 14 Apr 2021 12:53:30 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm215787pjm.0.2021.04.14.12.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:53:29 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH 4/4] xfs: support shrinking empty AGs
Date:   Thu, 15 Apr 2021 03:52:40 +0800
Message-Id: <20210414195240.1802221-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210414195240.1802221-1-hsiangkao@redhat.com>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Roughly, freespace can be shrinked atomicly with the following steps:

 - make sure the pending-for-discard AGs are all stablized as empty;
 - a transaction to
     fix up freespace btrees for the target tail AG;
     decrease agcount to the target value.

In order to make sure such AGs are empty, first to mark them as
inactive, then check if these AGs are all empty one-by-one. Also
need to log force, complete all discard operations together.

Even it's needed to drain out all related cached buffers in case of
corrupt fs if growfs again, so ail items are all needed to be pushed
out as well.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c |   1 -
 fs/xfs/libxfs/xfs_ag.h |   2 +-
 fs/xfs/xfs_fsops.c     | 148 ++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.c     |  87 +++++++++++++++++++-----
 fs/xfs/xfs_trans.c     |   1 -
 5 files changed, 210 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ba5702e5c9ad..eb370fbae192 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -512,7 +512,6 @@ xfs_ag_shrink_space(
 	struct xfs_agf		*agf;
 	int			error, err2;
 
-	ASSERT(agno == mp->m_sb.sb_agcount - 1);
 	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4535de1d88ea..7031e2c7ef66 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -15,7 +15,7 @@ struct aghdr_init_data {
 	xfs_agblock_t		agno;		/* ag to init */
 	xfs_extlen_t		agsize;		/* new AG size */
 	struct list_head	buffer_list;	/* buffer writeback list */
-	xfs_rfsblock_t		nfree;		/* cumulative new free space */
+	int64_t			nfree;		/* cumulative new free space */
 
 	/* per header data */
 	xfs_daddr_t		daddr;		/* header location */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b33c894b6cf3..659ca1836bba 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -14,11 +14,14 @@
 #include "xfs_trans.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_extent_busy.h"
 #include "xfs_fsops.h"
 #include "xfs_trans_space.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_trans_priv.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -78,6 +81,112 @@ xfs_resizefs_init_new_ags(
 	return error;
 }
 
+static int
+xfs_shrinkfs_deactivate_ags(
+	struct xfs_mount        *mp,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount)
+{
+	xfs_agnumber_t		agno;
+	int			error;
+
+	/* confirm AGs pending for shrinking are all inactive */
+	for (agno = nagcount; agno < oagcount; ++agno) {
+		struct xfs_buf *agfbp, *agibp;
+		struct xfs_perag *pag = xfs_perag_get(mp, agno);
+
+		down_write(&pag->pag_inactive_rwsem);
+		/* need to lock agi, agf buffers here to close all races */
+		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		if (!error) {
+			error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
+			if (!error) {
+				pag->pag_inactive = true;
+				xfs_buf_relse(agfbp);
+			}
+			xfs_buf_relse(agibp);
+		}
+		up_write(&pag->pag_inactive_rwsem);
+		xfs_perag_put(pag);
+		if (error)
+			break;
+	}
+	return error;
+}
+
+static void
+xfs_shrinkfs_activate_ags(
+	struct xfs_mount        *mp,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount)
+{
+	xfs_agnumber_t		agno;
+
+	for (agno = nagcount; agno < oagcount; ++agno) {
+		struct xfs_perag *pag = xfs_perag_get(mp, agno);
+
+		down_write(&pag->pag_inactive_rwsem);
+		pag->pag_inactive = false;
+		up_write(&pag->pag_inactive_rwsem);
+	}
+}
+
+static int
+xfs_shrinkfs_prepare_ags(
+	struct xfs_mount        *mp,
+	struct aghdr_init_data	*id,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount)
+{
+	xfs_agnumber_t		agno;
+	int 			error;
+
+	error = xfs_shrinkfs_deactivate_ags(mp, oagcount, nagcount);
+	if (error)
+		goto err_out;
+
+	/* confirm AGs pending for shrinking are all empty */
+	for (agno = nagcount; agno < oagcount; ++agno) {
+		struct xfs_buf		*agfbp;
+		struct xfs_perag	*pag;
+
+		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agfbp);
+		if (error)
+			goto err_out;
+
+		pag = agfbp->b_pag;
+		error = xfs_ag_resv_free(pag);
+		if (!error) {
+			error = xfs_ag_is_empty(agfbp);
+			if (!error) {
+				ASSERT(!pag->pagf_flcount);
+				id->nfree -= pag->pagf_freeblks;
+			}
+		}
+		xfs_buf_relse(agfbp);
+		if (error)
+			goto err_out;
+	}
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	/*
+	 * Wait for all busy extents to be freed, including completion of
+	 * any discard operation.
+	 */
+	xfs_extent_busy_wait_all(mp);
+	flush_workqueue(xfs_discard_wq);
+
+	/*
+	 * Also need to drain out all related cached buffers, at least,
+	 * in case of growfs back later (which uses uncached buffers.)
+	 */
+	xfs_ail_push_all_sync(mp->m_ail);
+	xfs_buftarg_drain(mp->m_ddev_targp);
+	return error;
+err_out:
+	xfs_shrinkfs_activate_ags(mp, oagcount, nagcount);
+	return error;
+}
+
 /*
  * growfs operations
  */
@@ -93,7 +202,7 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
 	bool			lastag_extended;
-	xfs_agnumber_t		oagcount;
+	xfs_agnumber_t		oagcount, agno;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 
@@ -130,14 +239,13 @@ xfs_growfs_data_private(
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
-	if (nagcount > oagcount) {
+	if (nagcount > oagcount)
 		error = xfs_initialize_perag(mp, nagcount, &nagimax);
-		if (error)
-			return error;
-	} else if (nagcount < oagcount) {
-		/* TODO: shrinking the entire AGs hasn't yet completed */
-		return -EINVAL;
-	}
+	else if (nagcount < oagcount)
+		error = xfs_shrinkfs_prepare_ags(mp, &id, oagcount, nagcount);
+
+	if (error)
+		return error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
 			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
@@ -151,13 +259,29 @@ xfs_growfs_data_private(
 	} else {
 		static struct ratelimit_state shrink_warning = \
 			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
+		xfs_agblock_t	agdelta;
+
 		ratelimit_set_flags(&shrink_warning, RATELIMIT_MSG_ON_RELEASE);
 
 		if (__ratelimit(&shrink_warning))
 			xfs_alert(mp,
 	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
 
-		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
+		for (agno = nagcount; agno < oagcount; ++agno) {
+			struct xfs_perag *pag = xfs_perag_get(mp, agno);
+
+			pag->pagf_freeblks = 0;
+			pag->pagf_longest = 0;
+			xfs_perag_put(pag);
+		}
+
+		xfs_trans_agblocks_delta(tp, id.nfree);
+
+		if (nagcount != oagcount)
+			agdelta = nagcount * mp->m_sb.sb_agblocks - nb;
+		else
+			agdelta = -delta;
+		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, agdelta);
 	}
 	if (error)
 		goto out_trans_cancel;
@@ -167,8 +291,10 @@ xfs_growfs_data_private(
 	 * seen by the rest of the world until the transaction commit applies
 	 * them atomically to the superblock.
 	 */
-	if (nagcount > oagcount)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
+	if (nagcount != oagcount)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT,
+				 (int64_t)nagcount - (int64_t)oagcount);
+
 	if (delta)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
 	if (id.nfree)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 69a60b5f4a32..ca9513fdc09e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -172,6 +172,47 @@ xfs_sb_validate_fsb_count(
 	return 0;
 }
 
+static int
+xfs_perag_reset(
+	struct xfs_perag	*pag)
+{
+	int	error;
+
+	spin_lock_init(&pag->pag_ici_lock);
+	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+
+	error = xfs_buf_hash_init(pag);
+	if (error)
+		return error;
+
+	init_waitqueue_head(&pag->pagb_wait);
+	spin_lock_init(&pag->pagb_lock);
+	pag->pagb_count = 0;
+	pag->pagb_tree = RB_ROOT;
+
+	error = xfs_iunlink_init(pag);
+	if (error) {
+		xfs_buf_hash_destroy(pag);
+		return error;
+	}
+	spin_lock_init(&pag->pag_state_lock);
+	return 0;
+}
+
+static int
+xfs_perag_inactive_reset(
+	struct xfs_perag	*pag)
+{
+	cancel_delayed_work_sync(&pag->pag_blockgc_work);
+	xfs_iunlink_destroy(pag);
+	xfs_buf_hash_destroy(pag);
+
+	memset((char *)pag + offsetof(struct xfs_perag, pag_inactive), 0,
+	       sizeof(*pag) - offsetof(struct xfs_perag, pag_inactive));
+	return xfs_perag_reset(pag);
+}
+
 int
 xfs_initialize_perag(
 	xfs_mount_t	*mp,
@@ -180,6 +221,8 @@ xfs_initialize_perag(
 {
 	xfs_agnumber_t	index;
 	xfs_agnumber_t	first_initialised = NULLAGNUMBER;
+	xfs_agnumber_t	first_inactive = NULLAGNUMBER;
+	xfs_agnumber_t	last_inactive = NULLAGNUMBER;
 	xfs_perag_t	*pag;
 	int		error = -ENOMEM;
 
@@ -191,6 +234,20 @@ xfs_initialize_perag(
 	for (index = 0; index < agcount; index++) {
 		pag = xfs_perag_get(mp, index);
 		if (pag) {
+			down_write(&pag->pag_inactive_rwsem);
+			if (pag->pag_inactive) {
+				error = xfs_perag_inactive_reset(pag);
+				if (error) {
+					pag->pag_inactive = true;
+					up_write(&pag->pag_inactive_rwsem);
+					xfs_perag_put(pag);
+					goto out_unwind_new_pags;
+				}
+				if (first_inactive == NULLAGNUMBER)
+					first_inactive = index;
+				last_inactive = index;
+			}
+			up_write(&pag->pag_inactive_rwsem);
 			xfs_perag_put(pag);
 			continue;
 		}
@@ -200,19 +257,13 @@ xfs_initialize_perag(
 			error = -ENOMEM;
 			goto out_unwind_new_pags;
 		}
+
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
-		spin_lock_init(&pag->pag_ici_lock);
-		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
-		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-
-		error = xfs_buf_hash_init(pag);
+		init_rwsem(&pag->pag_inactive_rwsem);
+		error = xfs_perag_reset(pag);
 		if (error)
 			goto out_free_pag;
-		init_waitqueue_head(&pag->pagb_wait);
-		spin_lock_init(&pag->pagb_lock);
-		pag->pagb_count = 0;
-		pag->pagb_tree = RB_ROOT;
 
 		error = radix_tree_preload(GFP_NOFS);
 		if (error)
@@ -231,12 +282,6 @@ xfs_initialize_perag(
 		/* first new pag is fully initialized */
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
-		error = xfs_iunlink_init(pag);
-		if (error)
-			goto out_hash_destroy;
-		spin_lock_init(&pag->pag_state_lock);
-
-		init_rwsem(&pag->pag_inactive_rwsem);
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
@@ -252,6 +297,18 @@ xfs_initialize_perag(
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
+	if (first_inactive != NULLAGNUMBER) {
+		for (index = first_inactive; index <= last_inactive; ++index) {
+			pag = xfs_perag_get(mp, index);
+			if (pag) {
+				down_write(&pag->pag_inactive_rwsem);
+				pag->pag_inactive = true;
+				up_write(&pag->pag_inactive_rwsem);
+				xfs_perag_put(pag);
+			}
+		}
+	}
+
 	/* unwind any prior newly initialized pags */
 	for (index = first_initialised; index < agcount; index++) {
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1d37de86fc09..7fc7e0d1fde6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -439,7 +439,6 @@ xfs_trans_mod_sb(
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-		ASSERT(delta > 0);
 		tp->t_agcount_delta += delta;
 		break;
 	case XFS_TRANS_SB_IMAXPCT:
-- 
2.27.0

