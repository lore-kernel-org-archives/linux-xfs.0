Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6136CEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 09:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjGLJrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjGLJrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 05:47:41 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7817B0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:40 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fbca8935bfso68928875e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689155259; x=1691747259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lq+6PEZbocUto3002utPHjzZHUQzj6s+6KUiweladO8=;
        b=CnQXy0Jh6ol++C9cJ4Nv3ERXUQTcaMPwEqFRf2CQUc0ceu1NT69V1JwTwUqoEMw8uC
         unXt0An8GX1Rvg91CBgoOEEx1oUWig+Dby5jvPyf49yveNV2LvtAWFQYgzUAz4ZZphYa
         IKMLNlmBvyD8K86AIsqGre/ABBIjIO2b6VkmOpUpr+Jt9TbfYQxx3hg39FRiV8bjItGg
         Y2SqgEvm/eR7KHatAUr5H/3zTbwDBv0p3nnAW5d6De29IHqueP4zCf3UwYR/1+3OULSR
         FJck+/gxkx/cWRkj2sCDAgAMQgy5/3emnOWET3E5RP9zcRRF7vJ3lcwyF8QLH3oJ7o37
         sPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689155259; x=1691747259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lq+6PEZbocUto3002utPHjzZHUQzj6s+6KUiweladO8=;
        b=BJ8v761K4WRa+IzojYCeofO7RJh4RU5KhyELrHgOaHc3TKigvnIWEheY0gdAAxXbmB
         +vAxxgir8qSurVpFOaFpzdRkVdyxxBZ9nljQqPlazfNXv/L2OwSLmcC3xlL3xfX0WLiz
         4+ge7JMIvvWmt4xdiuMMLLxSh1uxfzY/oTTmnT+SG7LejncVyYAI1+LRmmwOmhQsa/fM
         SA96pbxDXLYNV+Gci1RzY7gvc+w31DwSrb1tb6Weg3lYOj59W1S1Ek9ZbUDSOYvvefTE
         +sNtDqwh3mC2Pdjxm3DByi1FG3By+fshvDW9o6Ym6Fr8ciSXTZODnu5oHmSejx6HS6hC
         X50g==
X-Gm-Message-State: ABy/qLZlmD0rhpwnJJNQB7HltPr3yfnMHSfkDArNSGdqBfcDLrYusffs
        2CK/7GGd8dReuyKxInLkp3A=
X-Google-Smtp-Source: APBJJlH+Jnk0ir1/VEMwDa1prkZzSg5nlQJfzdjmRAAOkmEaAhWgMG4xPFVz5DxfM6aavjAAXc/Lfg==
X-Received: by 2002:a05:600c:c8:b0:3fa:e92e:7a8b with SMTP id u8-20020a05600c00c800b003fae92e7a8bmr16250859wmm.13.1689155259031;
        Wed, 12 Jul 2023 02:47:39 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id u9-20020a7bc049000000b003fbc681c8d1sm15144548wmc.36.2023.07.12.02.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 02:47:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6.1 CANDIDATE 2/3] xfs: check that per-cpu inodegc workers actually run on that cpu
Date:   Wed, 12 Jul 2023 12:47:32 +0300
Message-Id: <20230712094733.1265038-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712094733.1265038-1-amir73il@gmail.com>
References: <20230712094733.1265038-1-amir73il@gmail.com>
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

