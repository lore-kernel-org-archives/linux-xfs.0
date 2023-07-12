Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C25AC001DF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 09:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjGLJrl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjGLJrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 05:47:40 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5F01BB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:39 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fbc5d5746cso75162535e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689155258; x=1691747258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPSDIbaxTNh3TAqtA4XCx0bfvfZiTomjp6ixjsSsxD0=;
        b=pqmppQefCGOKNlHKtorE3tGPOrX8Qq4PKaEkywrPniJSGyjTMHM4Pt2CI5Pd530q81
         bndbHksuME7edk865+qETm7xZkWVxw75TDHZvXJxTD4AAO5Q6JEN4u+fUcfW/M/x4x3D
         WUevBm11LiP1WnTgqI7rBKZ5jTN9uC4ToI0VYJvAAjm6EjaiIIeNMtsygD1Xxor1Xvyq
         ZF99fKIvmBBOT4Fe9KAmQdVdsKCBkbLksYNc5ZLPVDr1WD0cY2OV4j84tTCppybhmC5j
         S/y1q5+b1osXV8PcQxdNmMjnJX5BEFGbvg0KXNsmSVZfYDHjTFR0QL/It2QhQLDtCJOg
         taPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689155258; x=1691747258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPSDIbaxTNh3TAqtA4XCx0bfvfZiTomjp6ixjsSsxD0=;
        b=HINNFyoUYc7q3yzDYZEGhw4mCyXEAwRYjsn14YFsXGtwbOD7+Sm44Zk/jjoSBDrfPT
         A0QYBxVvUW0bol96B6Vu3OG09Uo9vDQ6bqX8i2Uc22R4Xeybko2m4UZ9VDU2fBIN1rix
         Rocs3CsZVDYc7ye0cdcEyWvNmX9Qon2GVLxbOq2foZed5LtiqehNt6yXXSeh3ypAaty5
         5vtIyv1IBJBAMd74+RRRITek2youpHTfSfWOBxGQzLWN0Sfdu8ZHkHkk6wDhHZ2nOlYI
         ZCPlffp6sZnqrXvnzH8p3Bu1x8mBxvwc3ifrsrrJjFdzpA8mZxVmq2S1/yoiaO/aYmGH
         ZLMg==
X-Gm-Message-State: ABy/qLaVZjwD1EKf6l2tzoYA7/7/FGxHQEAnSpuLk6vNMlX7B0X3phXI
        /QfFb7KvWPKx2THfdCGxnlM=
X-Google-Smtp-Source: APBJJlGebEDBkirvCCfF76Ut9c3H7algmqySr1ilKalU6qu5DVigDtT0ZwSNMgu5v3fRZ3xNo6Uvmw==
X-Received: by 2002:a05:600c:22ce:b0:3fa:8c68:4aba with SMTP id 14-20020a05600c22ce00b003fa8c684abamr4948362wmg.25.1689155257819;
        Wed, 12 Jul 2023 02:47:37 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id u9-20020a7bc049000000b003fbc681c8d1sm15144548wmc.36.2023.07.12.02.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 02:47:37 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6.1 CANDIDATE 1/3] xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
Date:   Wed, 12 Jul 2023 12:47:31 +0300
Message-Id: <20230712094733.1265038-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712094733.1265038-1-amir73il@gmail.com>
References: <20230712094733.1265038-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 03e0add80f4cf3f7393edb574eeb3a89a1db7758 upstream.

I've been noticing odd racing behavior in the inodegc code that could
only be explained by one cpu adding an inode to its inactivation llist
at the same time that another cpu is processing that cpu's llist.
Preemption is disabled between get/put_cpu_ptr, so the only explanation
is scheduler mayhem.  I inserted the following debug code into
xfs_inodegc_worker (see the next patch):

	ASSERT(gc->cpu == smp_processor_id());

This assertion tripped during overnight tests on the arm64 machines, but
curiously not on x86_64.  I think we haven't observed any resource leaks
here because the lockfree list code can handle simultaneous llist_add
and llist_del_all functions operating on the same list.  However, the
whole point of having percpu inodegc lists is to take advantage of warm
memory caches by inactivating inodes on the last processor to touch the
inode.

The incorrect scheduling seems to occur after an inodegc worker is
subjected to mod_delayed_work().  This wraps mod_delayed_work_on with
WORK_CPU_UNBOUND specified as the cpu number.  Unbound allows for
scheduling on any cpu, not necessarily the same one that scheduled the
work.

Because preemption is disabled for as long as we have the gc pointer, I
think it's safe to use current_cpu() (aka smp_processor_id) to queue the
delayed work item on the correct cpu.

Fixes: 7cf2b0f9611b ("xfs: bound maximum wait time for inodegc work")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_icache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index eae7427062cf..536885f8b8a8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2052,7 +2052,8 @@ xfs_inodegc_queue(
 		queue_delay = 0;
 
 	trace_xfs_inodegc_queue(mp, __return_address);
-	mod_delayed_work(mp->m_inodegc_wq, &gc->work, queue_delay);
+	mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+			queue_delay);
 	put_cpu_ptr(gc);
 
 	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
@@ -2096,7 +2097,8 @@ xfs_inodegc_cpu_dead(
 
 	if (xfs_is_inodegc_enabled(mp)) {
 		trace_xfs_inodegc_queue(mp, __return_address);
-		mod_delayed_work(mp->m_inodegc_wq, &gc->work, 0);
+		mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+				0);
 	}
 	put_cpu_ptr(gc);
 }
-- 
2.34.1

