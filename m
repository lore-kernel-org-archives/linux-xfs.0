Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C516DC636CC
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjBHRwo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjBHRwn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:43 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CDB6A64
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:42 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id f15-20020a17090ac28f00b00230a32f0c9eso3098460pjt.4
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4zaCZqG/9Te1S4SLOTcFbt+IncxgVAgVwl1b3HxBTaM=;
        b=U6uDQK23exe1TGSi7ij0zE1dEuzunO3lMaVQPLhVIOr0Dt8LqJYIuTd9rb46km8JQW
         /9sgsB7W1DRVl0pQMAPDTfAN3qn0m7WVVMnj/Ziuxs4VrMvukXuo2/GSOqOgoUndyJec
         KjIYrXskXITH80Tp65xselLFD1/BlEN1YQ7y1nZzcu8VyChuTmhGYHbhT23tBmu/q9oH
         0BqAoLgGi8IIfcR/r1YmFs2lYlMM+kcfI//JweEgP/NTk2BX28nBw6r9YEoQqZ4AVi70
         JBVrYUBHaFxW6dwgrA05OaaEeWUokUnHzTX1SCw0ymbQhJD/O9fWmpSUiUgHW2VG7D3y
         gyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4zaCZqG/9Te1S4SLOTcFbt+IncxgVAgVwl1b3HxBTaM=;
        b=CCE8i8T5vHPjhY5WYvPL7EginX9OEcbUzN8r3YjUBZFKe98W79YeEsN7K4i24UEFpg
         F+b/kgkfhf6V5L/ENud6Il6lKnD5rDx790+sX3ANHzojvHU44bVA6lz/Mz7OX/VDgqcz
         PoI50+4yJLNJwTzxvsc8jBEhGeX24GeMaoxfmrcyW4Izzd5pnMZWMZB9rg0IpKTEBbRi
         iuP+RMF0LeVUk930BAM+wEcdVrreg560eViukC/SJPu1H05OcYrdkAvEShSuFq/5D2w3
         JVlmmoDuXKTIo0O0zuKyEQiYdX58xwhZvxPSCXH7ejFl5EXT+8poS3de7E1so9quxcHA
         tOMg==
X-Gm-Message-State: AO0yUKVBlJ6x2WnNjuzvbXgo/BnyXEXwqvtN1YbMwcoz81eIfhqH62b6
        GDjq6hplkJ5FAP7Igimuyl3+TzhXo6kywQ==
X-Google-Smtp-Source: AK7set/h18P8sxQ1Y9t4cPrNTh0ObWqSMEV0mhKZzlLpwcFTjxdKtvwjjLxrFCbT1P6s0XWH771Udw==
X-Received: by 2002:a17:902:db0a:b0:199:15bb:8320 with SMTP id m10-20020a170902db0a00b0019915bb8320mr8566270plx.31.1675878761525;
        Wed, 08 Feb 2023 09:52:41 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:41 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 02/10] xfs: fix potential log item leak
Date:   Wed,  8 Feb 2023 09:52:20 -0800
Message-Id: <20230208175228.2226263-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit c230a4a85bcdbfc1a7415deec6caf04e8fca1301 ]

Ever since we added shadown format buffers to the log items, log
items need to handle the item being released with shadow buffers
attached. Due to the fact this requirement was added at the same
time we added new rmap/reflink intents, we missed the cleanup of
those items.

In theory, this means shadow buffers can be leaked in a very small
window when a shutdown is initiated. Testing with KASAN shows this
leak does not happen in practice - we haven't identified a single
leak in several years of shutdown testing since ~v4.8 kernels.

However, the intent whiteout cleanup mechanism results in every
cancelled intent in exactly the same state as this tiny race window
creates and so if intents down clean up shadow buffers on final
release we will leak the shadow buffer for just about every intent
we create.

Hence we start with this patch to close this condition off and
ensure that when whiteouts start to be used we don't leak lots of
memory.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_bmap_item.c     | 2 ++
 fs/xfs/xfs_icreate_item.c  | 1 +
 fs/xfs/xfs_refcount_item.c | 2 ++
 fs/xfs/xfs_rmap_item.c     | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 03159970133f..51ffdec5e4fa 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -39,6 +39,7 @@ STATIC void
 xfs_bui_item_free(
 	struct xfs_bui_log_item	*buip)
 {
+	kmem_free(buip->bui_item.li_lv_shadow);
 	kmem_cache_free(xfs_bui_zone, buip);
 }
 
@@ -198,6 +199,7 @@ xfs_bud_item_release(
 	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
 
 	xfs_bui_release(budp->bud_buip);
+	kmem_free(budp->bud_item.li_lv_shadow);
 	kmem_cache_free(xfs_bud_zone, budp);
 }
 
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 017904a34c02..c265ae20946d 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -63,6 +63,7 @@ STATIC void
 xfs_icreate_item_release(
 	struct xfs_log_item	*lip)
 {
+	kmem_free(ICR_ITEM(lip)->ic_item.li_lv_shadow);
 	kmem_cache_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 46904b793bd4..8ef842d17916 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_cui_item_free(
 	struct xfs_cui_log_item	*cuip)
 {
+	kmem_free(cuip->cui_item.li_lv_shadow);
 	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
 		kmem_free(cuip);
 	else
@@ -204,6 +205,7 @@ xfs_cud_item_release(
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
 
 	xfs_cui_release(cudp->cud_cuip);
+	kmem_free(cudp->cud_item.li_lv_shadow);
 	kmem_cache_free(xfs_cud_zone, cudp);
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5f0695980467..15e7b01740a7 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_rui_item_free(
 	struct xfs_rui_log_item	*ruip)
 {
+	kmem_free(ruip->rui_item.li_lv_shadow);
 	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
 		kmem_free(ruip);
 	else
@@ -227,6 +228,7 @@ xfs_rud_item_release(
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 
 	xfs_rui_release(rudp->rud_ruip);
+	kmem_free(rudp->rud_item.li_lv_shadow);
 	kmem_cache_free(xfs_rud_zone, rudp);
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

