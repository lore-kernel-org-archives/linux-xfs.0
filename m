Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA68C46467
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjARWpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjARWpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C91B60499
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:18 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v10-20020a17090abb8a00b00229c517a6eeso3992813pjr.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qKuAMvXfEBORE+u/OsZZ6eeRG6KY8kuRyA4fB77aCEc=;
        b=CDg5KRlfSPpd9I/N7oGoc+MrJiA4BoAxJyNhLKYMgB6s7BeWWt9Ao2fjNBx9Xngb9+
         KOJe7xt7exVsJ2efsua6DjJJLLouZ5It5Z2pY/I+0htigBtEprOXfb0i8FhE8/6DZP99
         ty5+uGTlBNQUYH1oMV6LQbyBNa3p/fJHekWE1PN5/5cWQ2KMxgL4AN4VZzR3LOUrWXzx
         2dNGniOtTCv5tln1OsVoxd03+Hhl0oQHk8VBIT9jYHFvBodJ+mIvmLDNuy9ytixXLuvq
         dKUWlNHBs2JD280KEkqANJwOo3UNhHcfgnsUaW1p0V/M1NfUFKIUjwsWaacLeidlUjLK
         hWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKuAMvXfEBORE+u/OsZZ6eeRG6KY8kuRyA4fB77aCEc=;
        b=j0ZDq4nGlxHavLlJjAJ3DLr03gZu8leb9RWRm9Q0JbpZiQ28bYkvq/zjDKb9y2C9OJ
         THnioC4qpYpRBrwOLIFfVdVtndMbczAURglDZk047HvUq0vKwE8zH1syNYmscUt49kZg
         hCubu2H6xorNJUTVtvissHRLRaaWB2ywJUl9Due6aOGrL78bmDs6gGs8YRcrTmkVveM3
         XuUTdOBjK8TwdILbUBbuKNsAmqzfc6k7tUcbD/Xiq8j9+NKfCTSWcHB59SAABN/kwWWd
         q4HscvMxCZKc+zyieoMVH6RaycB//564c+PzOY4HjnHgFKtnFle2Ss51TP5wbQpzSKjd
         33bw==
X-Gm-Message-State: AFqh2krgMPiHAHg7afngY1aS9ueSMrSFhW3JbUxFhrW0340YIEiYcKZp
        1XPygEy4zT3R0PiuwtMjs9hCfBCBLPOYB6t7
X-Google-Smtp-Source: AMrXdXvD7stD/cvKJYd/yEBVOGGZkKb9B3l+ZVd7L/p1SLTSMTi/q+3wmBYiSCKHeP02Nwqr2XioPg==
X-Received: by 2002:a05:6a20:6b91:b0:ac:21c3:2fb7 with SMTP id bu17-20020a056a206b9100b000ac21c32fb7mr26228812pzb.6.1674081917983;
        Wed, 18 Jan 2023 14:45:17 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b001910b21fe90sm879892pls.210.2023.01.18.14.45.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYX-UB
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFj-31
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 40/42] xfs: pass perag to filestreams tracing
Date:   Thu, 19 Jan 2023 09:45:03 +1100
Message-Id: <20230118224505.1964941-41-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Pass perags instead of raw ag numbers, avoiding the need for the
special peek function for the tracing code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
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
index 3b25b10fccc1..b5f7d225d5b4 100644
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

