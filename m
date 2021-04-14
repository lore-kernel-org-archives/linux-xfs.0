Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5493C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CD161154
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353530AbhDNTxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 15:53:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353523AbhDNTxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 15:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618430004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F9xF0hKxvdqIem8ylA2t9fMPF2dO98TC2hQY/cJildg=;
        b=HEgc9fXg2kDeKpvgnoq+7diumCXqVceZBRpFkFbqPx9SHLMxulJ3ENOBMU+hSkQ6ioyMgs
        U71Cnbi8pCtH/cwmw7fGMMJSdhnj1LlfFcRoIWYOZ9TRVGB7OP4BTGRIbEKbMJDeIUX+qT
        ucj6AjRPNbAGiHokNdRsALptiXKkPII=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-MFkaj0-wM7q4XZ_auy2NzQ-1; Wed, 14 Apr 2021 15:53:23 -0400
X-MC-Unique: MFkaj0-wM7q4XZ_auy2NzQ-1
Received: by mail-pl1-f197.google.com with SMTP id d29-20020a17090259ddb02900eadb61377aso6563321plj.22
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 12:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F9xF0hKxvdqIem8ylA2t9fMPF2dO98TC2hQY/cJildg=;
        b=r3vx6CO//gYJZ/X0H9h1i+gKnqiCCRp8iWIm+pQvg45McQHrnV+sD6Mukzb83VBfom
         UR5s/JRxnYW0K7G7WeQqMtMCg426vqWlyTo8hqF+2mesGseXugc735mBvUnCXuf0DAxo
         Fk/qN7lRFsj9IRiPpOTC6H/hCI2MQKYfpAmcJRPHwCKQOtrmhovyh9kh4nO2IaORAPhQ
         4knOkE7W2aaP/scVUazFLWJw79dO1RmHeP1o/vtKxWcz9V+EbV06rO2KsJIUfRlv7HNr
         w0U5Jf7D2NAQ1UtYc9nzcMrSpDo9G7IfNMYn1qdMalZ3uTjTVlN0kXdPjWbGm1TA4srF
         qeHQ==
X-Gm-Message-State: AOAM530AhktU/YhoPw3is2lKmFkaWMRZnttnzbP33v/HE3Lx+pSRnAsx
        TZlqPS/6DoDHHfCXh7OttDFugne/nzYdEsB/ApX37vxkMOj4I5biadRwL59vtNddhDFUNnSNYrP
        zTuuL++FvNOrXxfDzXKij21akAG4zQJw6Zk5+2CTQqgoNxk8aYPuYdUX/zGcARZNwNkD0gSo8QQ
        ==
X-Received: by 2002:a62:2c46:0:b029:245:6391:b631 with SMTP id s67-20020a622c460000b02902456391b631mr29657730pfs.67.1618430001732;
        Wed, 14 Apr 2021 12:53:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxAvF6Q7omURQ4Qi/zwLElUxw+jEN4YnLkkvNoEHoCSEEq9JRQd3vfiYIR4Ing5UcP0fJ1CQ==
X-Received: by 2002:a62:2c46:0:b029:245:6391:b631 with SMTP id s67-20020a622c460000b02902456391b631mr29657707pfs.67.1618430001360;
        Wed, 14 Apr 2021 12:53:21 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm215787pjm.0.2021.04.14.12.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:53:21 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH 1/4] xfs: support deactivating AGs
Date:   Thu, 15 Apr 2021 03:52:37 +0800
Message-Id: <20210414195240.1802221-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210414195240.1802221-1-hsiangkao@redhat.com>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To get rid of paralleled requests related to AGs which are pending
for shrinking, mark these perags as inactive rather than playing
with per-ag structures theirselves.

Since in that way, a per-ag lock can be used to stablize the inactive
status together with agi/agf buffer lock (which is much easier than
adding more complicated perag_{get, put} pairs..) Also, Such per-ags
can be released / reused when unmountfs / growfs.

On the read side, pag_inactive_rwsem can be unlocked immediately after
the agf or agi buffer lock is acquired. However, pag_inactive_rwsem
can only be unlocked after the agf/agi buffer locks are all acquired
with the inactive status on the write side.

XXX: maybe there are some missing cases.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c     | 16 +++++++++++++---
 fs/xfs/libxfs/xfs_alloc.c  | 12 +++++++++++-
 fs/xfs/libxfs/xfs_ialloc.c | 26 +++++++++++++++++++++++++-
 fs/xfs/xfs_mount.c         |  2 ++
 fs/xfs/xfs_mount.h         |  6 ++++++
 5 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c68a36688474..ba5702e5c9ad 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -676,16 +676,24 @@ xfs_ag_get_geometry(
 	if (agno >= mp->m_sb.sb_agcount)
 		return -EINVAL;
 
+	pag = xfs_perag_get(mp, agno);
+	down_read(&pag->pag_inactive_rwsem);
+
+	if (pag->pag_inactive) {
+		error = -EBUSY;
+		up_read(&pag->pag_inactive_rwsem);
+		goto out;
+	}
+
 	/* Lock the AG headers. */
 	error = xfs_ialloc_read_agi(mp, NULL, agno, &agi_bp);
+	up_read(&pag->pag_inactive_rwsem);
 	if (error)
-		return error;
+		goto out;
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
 	if (error)
 		goto out_agi;
 
-	pag = agi_bp->b_pag;
-
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
 	ageo->ag_number = agno;
@@ -707,5 +715,7 @@ xfs_ag_get_geometry(
 	xfs_buf_relse(agf_bp);
 out_agi:
 	xfs_buf_relse(agi_bp);
+out:
+	xfs_perag_put(pag);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..01d4e4d4c1d6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2537,12 +2537,17 @@ xfs_alloc_fix_freelist(
 	/* deferred ops (AGFL block frees) require permanent transactions */
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	down_read(&pag->pag_inactive_rwsem);
+	if (pag->pag_inactive)
+		goto out_no_agbp;
+
 	if (!pag->pagf_init) {
 		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
 				error = 0;
+			up_read(&pag->pag_inactive_rwsem);
 			goto out_no_agbp;
 		}
 	}
@@ -2555,13 +2560,16 @@ xfs_alloc_fix_freelist(
 	if (pag->pagf_metadata && (args->datatype & XFS_ALLOC_USERDATA) &&
 	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
 		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
+		up_read(&pag->pag_inactive_rwsem);
 		goto out_agbp_relse;
 	}
 
 	need = xfs_alloc_min_freelist(mp, pag);
 	if (!xfs_alloc_space_available(args, need, flags |
-			XFS_ALLOC_FLAG_CHECK))
+			XFS_ALLOC_FLAG_CHECK)) {
+		up_read(&pag->pag_inactive_rwsem);
 		goto out_agbp_relse;
+	}
 
 	/*
 	 * Get the a.g. freespace buffer.
@@ -2573,9 +2581,11 @@ xfs_alloc_fix_freelist(
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
 				error = 0;
+			up_read(&pag->pag_inactive_rwsem);
 			goto out_no_agbp;
 		}
 	}
+	up_read(&pag->pag_inactive_rwsem);
 
 	/* reset a padding mismatched agfl before final free space check */
 	if (pag->pagf_agflreset)
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index eefdb518fe64..4df218eeb088 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -969,11 +969,15 @@ xfs_ialloc_ag_select(
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
 		pag = xfs_perag_get(mp, agno);
+		down_read(&pag->pag_inactive_rwsem);
 		if (!pag->pagi_inodeok) {
 			xfs_ialloc_next_ag(mp);
 			goto nextag;
 		}
 
+		if (pag->pag_inactive)
+			goto nextag;
+
 		if (!pag->pagi_init) {
 			error = xfs_ialloc_pagi_init(mp, tp, agno);
 			if (error)
@@ -981,6 +985,7 @@ xfs_ialloc_ag_select(
 		}
 
 		if (pag->pagi_freecount) {
+			up_read(&pag->pag_inactive_rwsem);
 			xfs_perag_put(pag);
 			return agno;
 		}
@@ -1016,10 +1021,12 @@ xfs_ialloc_ag_select(
 
 		if (pag->pagf_freeblks >= needspace + ineed &&
 		    longest >= ineed) {
+			up_read(&pag->pag_inactive_rwsem);
 			xfs_perag_put(pag);
 			return agno;
 		}
 nextag:
+		up_read(&pag->pag_inactive_rwsem);
 		xfs_perag_put(pag);
 		/*
 		 * No point in iterating over the rest, if we're shutting
@@ -1776,10 +1783,13 @@ xfs_dialloc_select_ag(
 	agno = start_agno;
 	for (;;) {
 		pag = xfs_perag_get(mp, agno);
+		down_read(&pag->pag_inactive_rwsem);
 		if (!pag->pagi_inodeok) {
 			xfs_ialloc_next_ag(mp);
 			goto nextag;
 		}
+		if (pag->pag_inactive)
+			goto nextag;
 
 		if (!pag->pagi_init) {
 			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
@@ -1802,6 +1812,7 @@ xfs_dialloc_select_ag(
 			break;
 
 		if (pag->pagi_freecount) {
+			up_read(&pag->pag_inactive_rwsem);
 			xfs_perag_put(pag);
 			goto found_ag;
 		}
@@ -1825,6 +1836,7 @@ xfs_dialloc_select_ag(
 			 * allocate one of the new inodes.
 			 */
 			ASSERT(pag->pagi_freecount > 0);
+			up_read(&pag->pag_inactive_rwsem);
 			xfs_perag_put(pag);
 
 			error = xfs_dialloc_roll(tpp, agbp);
@@ -1838,13 +1850,14 @@ xfs_dialloc_select_ag(
 nextag_relse_buffer:
 		xfs_trans_brelse(*tpp, agbp);
 nextag:
+		up_read(&pag->pag_inactive_rwsem);
 		xfs_perag_put(pag);
 		if (++agno == mp->m_sb.sb_agcount)
 			agno = 0;
 		if (agno == start_agno)
 			return noroom ? -ENOSPC : 0;
 	}
-
+	up_read(&pag->pag_inactive_rwsem);
 	xfs_perag_put(pag);
 	return error;
 found_ag:
@@ -2263,11 +2276,22 @@ xfs_imap_lookup(
 {
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
+	struct xfs_perag	*pag;
 	struct xfs_buf		*agbp;
 	int			error;
 	int			i;
 
+	pag = xfs_perag_get(mp, agno);
+	down_read(&pag->pag_inactive_rwsem);
+	if (pag->pag_inactive) {
+		up_read(&pag->pag_inactive_rwsem);
+		xfs_perag_put(pag);
+		return -EINVAL;
+	}
+
 	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	up_read(&pag->pag_inactive_rwsem);
+	xfs_perag_put(pag);
 	if (error) {
 		xfs_alert(mp,
 			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1c97b155a8ee..f86360514828 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -235,6 +235,8 @@ xfs_initialize_perag(
 		if (error)
 			goto out_hash_destroy;
 		spin_lock_init(&pag->pag_state_lock);
+
+		init_rwsem(&pag->pag_inactive_rwsem);
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 81829d19596e..667dae0acaf9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -309,6 +309,12 @@ typedef struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
 	atomic_t	pag_ref;	/* perag reference count */
+
+	struct rw_semaphore	pag_inactive_rwsem;
+	bool			pag_inactive;
+
+	/* zero the following fields when growfs pag_inactive == true pags */
+
 	char		pagf_init;	/* this agf's entry is initialized */
 	char		pagi_init;	/* this agi's entry is initialized */
 	char		pagf_metadata;	/* the agf is preferred to be metadata */
-- 
2.27.0

