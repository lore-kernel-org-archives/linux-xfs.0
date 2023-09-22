Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A4EE7D0C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Sep 2023 01:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjIVBCM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjIVBCL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 21:02:11 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B491B192;
        Thu, 21 Sep 2023 18:02:05 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-578a91ac815so1236360a12.1;
        Thu, 21 Sep 2023 18:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695344525; x=1695949325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5KzxESXZkFDTp3cAkXdAn0yBd85C7ZZTAhXTSFq606w=;
        b=FqBkDtaX/Ea5bGzIwYj9BtMovBy16QgvEs0h/x2CxJaR1WNhNMX3JZO6vR41mcORGA
         Xp5fXwJ+IwrzzJgAmDrbRNQNe0pjGXAQ+0VmhYSJdiEo10vwAqOWgnOsN1wdmw/DOZw+
         CwiT4Mq+bzDZClXqMe0gTTw2M6wCgNXcms+fcgQHR6TXcEpRdjZDCv6Pwg9sueXFn6YJ
         rypN0XTWF9pZXFWXmFFdWRJkS+bdSSpoKGUTTkL0BzVoyf7vHetCUvw00wSzCFOq7R99
         CtzPXJ2nqJukW2EE1t4ZC6cpjGf3ifgKW/g5KP0IR2FgAYxi0vDhujJi+B5rmm3DXHgK
         DjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695344525; x=1695949325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5KzxESXZkFDTp3cAkXdAn0yBd85C7ZZTAhXTSFq606w=;
        b=kmgXSRweO2f+vrF/YM+q0/v8vGOyg6M/TgXOjtyqnvh8aGa6jZMlkepQadRw6J/VEc
         9Y59vW12OnIy6Q5anXrdVzwkOhURMKntllqwIuzm35W8yWnFiSAFwG+jeQJUYW6VIlmj
         J5FP+4+M9nY2bymIRgPWw3BWwxAAA76r5ITdGeIWDoACvutJUhapzDxAzix88eyyxqhE
         aiSUGU8qi6M3yJ+4C06zfV+GhM7PXUmMKb64t2ZsPf5W+1EKJnFQ0xo+VqrhRpqNWnGh
         iwQvQ9VmvW97euF47t7psSmYyuKWjFkpuJdNJD77gp1Git6a2atr0s/FC7aD41VQxTcn
         7XTA==
X-Gm-Message-State: AOJu0YxeE7GR0v/Iscsz6K33jfIEZ6gEaY6MbzLL9ysur9RPKiF1lzSz
        XyjKiPWcq2sEr9eKlo/CvFiuF1DLsSRnGg==
X-Google-Smtp-Source: AGHT+IHz+rmFhGYxkc2yBrjyXvYlXVvmndGszepY/GJRL6ByHqffYXuw57OLi2XBPqaiYzqbYLWxxg==
X-Received: by 2002:a17:90b:314c:b0:26d:b12:8383 with SMTP id ip12-20020a17090b314c00b0026d0b128383mr7151444pjb.8.1695344524952;
        Thu, 21 Sep 2023 18:02:04 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d5ff:b7b0:7028:8af6])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090282c200b001bc445e2497sm2178815plz.79.2023.09.21.18.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 18:02:04 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 4/6] xfs: check that per-cpu inodegc workers actually run on that cpu
Date:   Thu, 21 Sep 2023 18:01:54 -0700
Message-ID: <20230922010156.1718782-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230922010156.1718782-1-leah.rumancik@gmail.com>
References: <20230922010156.1718782-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b37c4c8339cd394ea6b8b415026603320a185651 ]

Now that we've allegedly worked out the problem of the per-cpu inodegc
workers being scheduled on the wrong cpu, let's put in a debugging knob
to let us know if a worker ever gets mis-scheduled again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 2 ++
 fs/xfs/xfs_mount.h  | 3 +++
 fs/xfs/xfs_super.c  | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ab8181f8d08a..02022164772d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1856,6 +1856,8 @@ xfs_inodegc_worker(
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
 
+	ASSERT(gc->cpu == smp_processor_id());
+
 	WRITE_ONCE(gc->items, 0);
 
 	if (!node)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3d58938a6f75..29f35169bf9c 100644
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
index 9b3af7611eaa..569960e4ea3a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1062,6 +1062,9 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+#if defined(DEBUG) || defined(XFS_WARN)
+		gc->cpu = cpu;
+#endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
-- 
2.42.0.515.g380fc7ccd1-goog

