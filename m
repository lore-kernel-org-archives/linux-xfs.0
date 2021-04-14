Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04013C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC15A61154
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhDNTyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 15:54:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353548AbhDNTxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 15:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618430010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gliz9OEP1Vaz9Jw809LedUaiNrGIv9h72Uhhip6g65A=;
        b=iV/LlVoR8bybbRsv+qIat2APQy0ixKsEBU9u5EqaY3B3jVAUASEGPxbMZ+sopUIjvAG5W2
        XaYsyvGrKYP9thpV10YWtDQiWt7IlQLKrayE1GuSrvjmlraRFQLrjKUV/ueZ0vLH5lu0QO
        e9NYLMdw1Zd8FgQhDUeNviE794j2c8M=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-lHG275mxMquc1l_4wlVdQQ-1; Wed, 14 Apr 2021 15:53:28 -0400
X-MC-Unique: lHG275mxMquc1l_4wlVdQQ-1
Received: by mail-pg1-f198.google.com with SMTP id w8-20020a6556c80000b02902072432fdabso114088pgs.21
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 12:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gliz9OEP1Vaz9Jw809LedUaiNrGIv9h72Uhhip6g65A=;
        b=b0h8gFkiNi15JWiqmEo2CDODGnqaR9gdzkWev5Pu/9nz+KhEacF46YbkLY7Tj5UFMm
         e8POqWtRZ5S5bmi9bMzYr3b4zvmVILZO0Tk9C40D47Ikue8+biWCgXYJdJ43P/5kIrra
         xeVL5xTcyPB8fZMeY5V+4zScKdSF+Ay+usaTZQyg0QYHNvWTwha0A1pMYqZYmMyLLY8x
         L31Hc8jjYtZb+QqDlNLaamREeZo++HpP1pD0W3I0w2W91rkYzZpPFbhAoK23MapTIJ4o
         gB340Jmn+FnbRSxt70SsJBwtYzvp6BCWnAjwY/aHF9J2Wq7GHsfEdgFVLCNjrP1wQFER
         888w==
X-Gm-Message-State: AOAM531lAF3Tp4qYKR4ZMWiNCHwsvNkCN1z9/6aie7MjvGgizGkX7wXH
        wtEmH+V+8BwurRnNv4JcANIwTzmItl4VdYfrUryP6cuB0BXrx1iFKyX2zxKYjVs+MNjw5xZLxR9
        ZDktFg4OHTz4R1b9lbTldtmkXza47526qbQycGowyYf+0CNbeZ5iKegq4FQ9CkFlHB9Fa42Iozw
        ==
X-Received: by 2002:a63:ea06:: with SMTP id c6mr13852893pgi.401.1618430007415;
        Wed, 14 Apr 2021 12:53:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqbTcd8hEICfM5Nd9drlvTOnTiqTHMmwcy63XiMZXoQKExlF8XjsdvtsA3ejspU6CTFNicug==
X-Received: by 2002:a63:ea06:: with SMTP id c6mr13852864pgi.401.1618430007069;
        Wed, 14 Apr 2021 12:53:27 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm215787pjm.0.2021.04.14.12.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:53:26 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH 3/4] xfs: introduce max_agcount
Date:   Thu, 15 Apr 2021 03:52:39 +0800
Message-Id: <20210414195240.1802221-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210414195240.1802221-1-hsiangkao@redhat.com>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After shrinking, some inactive AGs won't be valid anymore except
that these perags are still here. Introduce a new m_maxagcount
mainly used for freeing all perags.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 2 +-
 fs/xfs/libxfs/xfs_bmap.c   | 8 ++++----
 fs/xfs/libxfs/xfs_ialloc.c | 2 +-
 fs/xfs/libxfs/xfs_sb.c     | 1 +
 fs/xfs/xfs_extent_busy.c   | 2 +-
 fs/xfs/xfs_mount.c         | 4 ++--
 fs/xfs/xfs_mount.h         | 1 +
 fs/xfs/xfs_trans.c         | 2 ++
 8 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 60a8c134c00e..a493aaa955d7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3220,7 +3220,7 @@ xfs_alloc_vextent(
 		args->maxlen = agsize;
 	if (args->alignment == 0)
 		args->alignment = 1;
-	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
+	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_maxagcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->minlen <= agsize);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5574d345d066..abbb2a8aa0c0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -350,7 +350,7 @@ xfs_bmap_check_leaf_extents(
 	bno = be64_to_cpu(*pp);
 
 	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
+	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_maxagcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
 
 	/*
@@ -546,7 +546,7 @@ __xfs_bmap_add_free(
 	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(agno < mp->m_maxagcount);
 	ASSERT(agbno < mp->m_sb.sb_agblocks);
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
@@ -3129,7 +3129,7 @@ xfs_bmap_adjacent(
 	(rt ? \
 		(x) < mp->m_sb.sb_rblocks : \
 		XFS_FSB_TO_AGNO(mp, x) == XFS_FSB_TO_AGNO(mp, y) && \
-		XFS_FSB_TO_AGNO(mp, x) < mp->m_sb.sb_agcount && \
+		XFS_FSB_TO_AGNO(mp, x) < mp->m_maxagcount && \
 		XFS_FSB_TO_AGBNO(mp, x) < mp->m_sb.sb_agblocks)
 
 	mp = ap->ip->i_mount;
@@ -3353,7 +3353,7 @@ xfs_bmap_btalloc_nullfb(
 		if (error)
 			return error;
 
-		if (++ag == mp->m_sb.sb_agcount)
+		if (++ag == mp->m_maxagcount)
 			ag = 0;
 		if (ag == startag)
 			break;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4df218eeb088..2b80dcb428bf 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1852,7 +1852,7 @@ xfs_dialloc_select_ag(
 nextag:
 		up_read(&pag->pag_inactive_rwsem);
 		xfs_perag_put(pag);
-		if (++agno == mp->m_sb.sb_agcount)
+		if (++agno == mp->m_maxagcount)
 			agno = 0;
 		if (agno == start_agno)
 			return noroom ? -ENOSPC : 0;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 60e6d255e5e2..6062b799d1e0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -807,6 +807,7 @@ xfs_sb_mount_common(
 	struct xfs_sb		*sbp)
 {
 	mp->m_agfrotor = mp->m_agirotor = 0;
+	mp->m_maxagcount = mp->m_sb.sb_agcount;
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ef17c1f6db32..b6d9d6e6da90 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -608,7 +608,7 @@ xfs_extent_busy_wait_all(
 	DEFINE_WAIT		(wait);
 	xfs_agnumber_t		agno;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+	for (agno = 0; agno < mp->m_maxagcount; agno++) {
 		struct xfs_perag *pag = xfs_perag_get(mp, agno);
 
 		do {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f86360514828..69a60b5f4a32 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -141,7 +141,7 @@ xfs_free_perag(
 	xfs_agnumber_t	agno;
 	struct xfs_perag *pag;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+	for (agno = 0; agno < mp->m_maxagcount; agno++) {
 		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
@@ -633,7 +633,7 @@ xfs_check_summary_counts(
 	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
 		return 0;
 
-	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
+	return xfs_initialize_perag_data(mp, mp->m_maxagcount);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 667dae0acaf9..6bc1cedd4cd5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -192,6 +192,7 @@ typedef struct xfs_mount {
 	 */
 	struct work_struct	m_flush_inodes_work;
 
+	xfs_agnumber_t		m_maxagcount;
 	/*
 	 * Generation of the filesysyem layout.  This is incremented by each
 	 * growfs, and used by the pNFS server to ensure the client updates
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bc25afc10245..1d37de86fc09 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -632,6 +632,8 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
+	if (mp->m_sb.sb_agcount > mp->m_maxagcount)
+		mp->m_maxagcount = mp->m_sb.sb_agcount;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
 	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
 	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
-- 
2.27.0

