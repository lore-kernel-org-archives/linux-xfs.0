Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF9DC001DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 06:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbjGNGqV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbjGNGqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 02:46:02 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AF7358E
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:20 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3fbc244d307so14439505e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689317118; x=1691909118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lq+6PEZbocUto3002utPHjzZHUQzj6s+6KUiweladO8=;
        b=cN1zjtyAjgTHsyjzUSl053xKuFMerWs3/V7VDN/0mGdBr8YFCz1mUqOl275lUNIxGL
         VNZgpbOCSUUIsUqSG8GlrtORpucbqQsWBYdK9JBN6qb2NTmIdF26D064u5HpZ+NpbaD/
         nKwzvnvn8wg9PtUhkyU0Iv/ngtpIHwiGotrlIkToD++ocgHWeKkWLTywLo+O9XGtqFdt
         sbYcLZ0b2zd4mQY/n1ObvPRoI4LjOyTtq34c3je4MTNXvYXV8h0pAcD68kYsOZvx7942
         iJTAtALood9Afx2lpp8w6oLEZvmGEzgdgM7tcBWPJ3/Mw/PaebNEzs2xOkRP+YH+HOAN
         UB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689317118; x=1691909118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lq+6PEZbocUto3002utPHjzZHUQzj6s+6KUiweladO8=;
        b=kdNrOzJgn54Xr1qRNoz6vyGLFAOhUqUOb7pmQg/EMaOIlL00wQ1gtTEvXunDjcP6QF
         NyddE+pGy5hlF3oDdVqs5RzlVGKNEi8R5zAmp2bS8vSKT7EpQv00DjxQgfyqVZNhR1OQ
         B8EQkcpyPRUsXTypDC1WwTnwQrHuest1rRts/rSWRp264IjpahtQRzF9jznmtTX/5KNv
         O0HUD72/nHX9CfcZDt+77j0BPR6U2+RsAlOuV6hrOpK03t9cC/TZIZdPakIOv+kjDdCq
         qgSl+/0VhrFO98deuIlNNxYXUB+twMQALtBdGwMKSKEJJgO3f5KXS8oGN3pZUA4a1lZR
         dKKQ==
X-Gm-Message-State: ABy/qLYxZxGN02+itPWt8JR2QAq0A5+R9juvC3yPJx1sUwt7zjob+pz2
        u0oisFxYZmW0BtBwQZIc6SU=
X-Google-Smtp-Source: APBJJlEXhGK+mYO9EZ57iYfpgW1Qr/baoEVxxzhJAZMb1OM3EZU4EyaLZxrBNp8TGJAWxj9aIDd2dQ==
X-Received: by 2002:a1c:f70a:0:b0:3fb:ff34:a846 with SMTP id v10-20020a1cf70a000000b003fbff34a846mr3314109wmh.22.1689317118081;
        Thu, 13 Jul 2023 23:45:18 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c234300b003fc04d13242sm709574wmq.0.2023.07.13.23.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 23:45:17 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6.1 CANDIDATE v2 2/4] xfs: check that per-cpu inodegc workers actually run on that cpu
Date:   Fri, 14 Jul 2023 09:45:07 +0300
Message-Id: <20230714064509.1451122-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714064509.1451122-1-amir73il@gmail.com>
References: <20230714064509.1451122-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit b37c4c8339cd394ea6b8b415026603320a185651 upstream.

Now that we've allegedly worked out the problem of the per-cpu inodegc
workers being scheduled on the wrong cpu, let's put in a debugging knob
to let us know if a worker ever gets mis-scheduled again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_icache.c | 2 ++
 fs/xfs/xfs_mount.h  | 3 +++
 fs/xfs/xfs_super.c  | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 536885f8b8a8..7ce262dcabca 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1848,6 +1848,8 @@ xfs_inodegc_worker(
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
 
+	ASSERT(gc->cpu == smp_processor_id());
+
 	WRITE_ONCE(gc->items, 0);
 
 	if (!node)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8aca2cc173ac..69ddd5319634 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -66,6 +66,9 @@ struct xfs_inodegc {
 	/* approximate count of inodes in the list */
 	unsigned int		items;
 	unsigned int		shrinker_hits;
+#if defined(DEBUG) || defined(XFS_WARN)
+	unsigned int		cpu;
+#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee4b429a2f2c..4b179526913f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1084,6 +1084,9 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+#if defined(DEBUG) || defined(XFS_WARN)
+		gc->cpu = cpu;
+#endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
-- 
2.34.1

