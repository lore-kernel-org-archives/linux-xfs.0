Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0951C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBIW06 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBIW04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:56 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33353527E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:53 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d8so3336029plr.10
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f0VsHlmi93YM1u0tibHIrwyffasqlYEvC9bHCRGReSg=;
        b=kEwEmJF+P5XGmIXtxvr1DPXQ5CnZLZfcjxuarRH1zeIl1WrrR79qEXLkumL8YqdOLR
         toUt9OSpwBkVfLocY80P/eMcZ5uIIhAuXziDlQykB+C4oj5RjpIvceS6vCdJzw6Ng5Wi
         daur4jWhjTW0CYHs6o0Ciq3u1xMiB15vaSX+4DpZTrjPGfe9U1/fWynTf5dwE7Ei4+VY
         h22au04NHEBdl3AQmawOpZIZcXw3uOgOd5tqY9BmhE9zAqraNa2wfdyA9y4SB67vZVAS
         Har5if9paDDN3GtmH3aZpBqk48yf4HUk6BCujb+lZfrmLHIPTr3T8B9DjxbDL84VeNWI
         5HMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0VsHlmi93YM1u0tibHIrwyffasqlYEvC9bHCRGReSg=;
        b=jrpWrV69wPMw2i6++k8CcH8FrdbN+f1u63F7+L15kgM60Ht/ptxpcDDSGkhaVfrBMk
         4hAze+HhjQQ7zy1UHaxiniriil3TcjTvwM3LFwuRFA2FVkeMz39fRySGsc2l7uvOUrBP
         YCJczRQclWCKQcLu3BPzYYcMNWHAj3fq4CPkjbhQDJt3chITuFCaNVXVDyuqLU2uDgp4
         XHQcBXIN+2zHcTFdnWKSG5LlHZ4IBqK2Pk5F/uYvXOJ//HkWV/fVU0ScDm0YbwCAuZbH
         MlESmlTqi4cVEfbIwhD4nziRNwFig+rNMkhTHXmhKH6kNNI0sM3S4P1lLkxaJIcBSmjM
         AqMA==
X-Gm-Message-State: AO0yUKUSlezCVPrALN+FWc5lM+ISvTdHgZ5+GNAxQx8KFhTSqS9/8bNC
        tNT5ZMpCqNyPTksarrLcZQF1HDMbo2BfduZe
X-Google-Smtp-Source: AK7set9dEE0vaZwbBpxLjKwVaemvBT4b4WkQwvzL5jjIOhF1/Fstg+sAZc7IlWt8FYssj+C2529Sag==
X-Received: by 2002:a05:6a20:3d86:b0:bf:6e94:3721 with SMTP id s6-20020a056a203d8600b000bf6e943721mr15559791pzi.26.1675981612616;
        Thu, 09 Feb 2023 14:26:52 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id m26-20020aa78a1a000000b0058dbd7a5e0esm1929330pfa.89.2023.02.09.14.26.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:52 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOWZ-Vj
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcP8-37
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 40/42] xfs: pass perag to filestreams tracing
Date:   Fri, 10 Feb 2023 09:18:23 +1100
Message-Id: <20230209221825.3722244-41-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Pass perags instead of raw ag numbers, avoiding the need for the
special peek function for the tracing code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_filestream.c | 29 +++++------------------------
 fs/xfs/xfs_filestream.h |  1 -
 fs/xfs/xfs_trace.h      | 37 ++++++++++++++++++++-----------------
 3 files changed, 25 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 71fa44485a2f..81aebe3e09ba 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -31,25 +31,6 @@ enum xfs_fstrm_alloc {
 	XFS_PICK_LOWSPACE = 2,
 };
 
-/*
- * Allocation group filestream associations are tracked with per-ag atomic
- * counters.  These counters allow xfs_filestream_pick_ag() to tell whether a
- * particular AG already has active filestreams associated with it.
- */
-int
-xfs_filestream_peek_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-	int		ret;
-
-	pag = xfs_perag_get(mp, agno);
-	ret = atomic_read(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-	return ret;
-}
-
 static void
 xfs_fstrm_free_func(
 	void			*data,
@@ -59,7 +40,7 @@ xfs_fstrm_free_func(
 		container_of(mru, struct xfs_fstrm_item, mru);
 	struct xfs_perag	*pag = item->pag;
 
-	trace_xfs_filestream_free(pag->pag_mount, mru->key, pag->pag_agno);
+	trace_xfs_filestream_free(pag, mru->key);
 	atomic_dec(&pag->pagf_fstrms);
 	xfs_perag_rele(pag);
 
@@ -99,7 +80,7 @@ xfs_filestream_pick_ag(
 
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
-		trace_xfs_filestream_scan(mp, ip->i_ino, agno);
+		trace_xfs_filestream_scan(pag, ip->i_ino);
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
@@ -169,7 +150,7 @@ xfs_filestream_pick_ag(
 		 */
 		if (!max_pag) {
 			*agp = NULLAGNUMBER;
-			trace_xfs_filestream_pick(ip, *agp, free, 0);
+			trace_xfs_filestream_pick(ip, NULL, free);
 			return 0;
 		}
 		pag = max_pag;
@@ -179,7 +160,7 @@ xfs_filestream_pick_ag(
 		xfs_perag_rele(max_pag);
 	}
 
-	trace_xfs_filestream_pick(ip, pag->pag_agno, free, 0);
+	trace_xfs_filestream_pick(ip, pag, free);
 
 	err = -ENOMEM;
 	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
@@ -258,7 +239,7 @@ xfs_filestream_select_ag_mru(
 	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
 	xfs_mru_cache_done(mp->m_filestream);
 
-	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, pag->pag_agno);
+	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
 
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
 	xfs_bmap_adjacent(ap);
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index df9f7553e106..84149ed0e340 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -14,7 +14,6 @@ struct xfs_alloc_arg;
 int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
-int xfs_filestream_peek_ag(struct xfs_mount *mp, xfs_agnumber_t agno);
 int xfs_filestream_select_ag(struct xfs_bmalloca *ap,
 		struct xfs_alloc_arg *args, xfs_extlen_t *blen);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bb7ccb5feeca..107bc8692f23 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -74,6 +74,7 @@ struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
+struct xfs_perag;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -638,8 +639,8 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
 
 DECLARE_EVENT_CLASS(xfs_filestream_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno),
-	TP_ARGS(mp, ino, agno),
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino),
+	TP_ARGS(pag, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -647,10 +648,10 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 		__field(int, streams)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
 		__entry->ino = ino;
-		__entry->agno = agno;
-		__entry->streams = xfs_filestream_peek_ag(mp, agno);
+		__entry->agno = pag->pag_agno;
+		__entry->streams = atomic_read(&pag->pagf_fstrms);
 	),
 	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -660,39 +661,41 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 )
 #define DEFINE_FILESTREAM_EVENT(name) \
 DEFINE_EVENT(xfs_filestream_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno), \
-	TP_ARGS(mp, ino, agno))
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino), \
+	TP_ARGS(pag, ino))
 DEFINE_FILESTREAM_EVENT(xfs_filestream_free);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
 
 TRACE_EVENT(xfs_filestream_pick,
-	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno,
-		 xfs_extlen_t free, int nscan),
-	TP_ARGS(ip, agno, free, nscan),
+	TP_PROTO(struct xfs_inode *ip, struct xfs_perag *pag,
+		 xfs_extlen_t free),
+	TP_ARGS(ip, pag, free),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(xfs_agnumber_t, agno)
 		__field(int, streams)
 		__field(xfs_extlen_t, free)
-		__field(int, nscan)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->agno = agno;
-		__entry->streams = xfs_filestream_peek_ag(ip->i_mount, agno);
+		if (pag) {
+			__entry->agno = pag->pag_agno;
+			__entry->streams = atomic_read(&pag->pagf_fstrms);
+		} else {
+			__entry->agno = NULLAGNUMBER;
+			__entry->streams = 0;
+		}
 		__entry->free = free;
-		__entry->nscan = nscan;
 	),
-	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d nscan %d",
+	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->agno,
 		  __entry->streams,
-		  __entry->free,
-		  __entry->nscan)
+		  __entry->free)
 );
 
 DECLARE_EVENT_CLASS(xfs_lock_class,
-- 
2.39.0

