Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE189C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Oct 2023 20:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjJ3Ud5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 16:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjJ3Ud4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Oct 2023 16:33:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72692AB
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 13:33:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-2802e5ae23bso1972861a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 13:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698698034; x=1699302834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HzZ+nfiu2ak8AmWa03KpSQ2ElnXO/L4npKTsMpwGkhk=;
        b=fy/KuA1oEutzhSEOkCQN7rl6r4DGF+wt+NdMTB5RIY0H+ORSfpO4NcQDL7lYqW4YT5
         f6esqzhcTDEtqxy13Gbsah8296y0vIfOLBJYMRgGQfVwIvhk31Smn0y/yz6WcaBqaFP1
         5yaqI5zMxC7XZzKvU51gnlwUElp3V7x+28sjPFNLToJtnTAWtWEZ2m9M3MF1AZkCXVTV
         deC6j3cZJPjdptIwBjR+VJDUYSuN4QBp/6RNyM2OXdltT1Y8pEz80iRfWx7VgE8UgrOq
         hSykWnYi0//s/DB0ponXo/tUcjphyeAnJBa2s2EKS3YFpW27qA8xL5fRxrlcYEsQFiQ5
         x1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698698034; x=1699302834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HzZ+nfiu2ak8AmWa03KpSQ2ElnXO/L4npKTsMpwGkhk=;
        b=XaCJJcd/ajQGjggDvGXD30af0r6W9PSMESXMeo6TO3XIEO0ZSN+jaxENbvXZSRwuqq
         PXgVxkwQCV9KqFpnnW69YSXm2SugnUEkQt7orTQs/Ljk3ZjX+l3Cuk37zCDJ5F65MBlT
         tYJixSmr5+zdHkq4Kz6Bnac9PaSrGgAF3/JN3icnGrr5mq99PZ9W6IrckP0G9jagbXkO
         nYkItKn5rqnDI7MFOnvg0dxyjfxwYDaYZSS/+yffVdfytPc95+7A5pm6Y/zqZ9MjdCcZ
         EiRuySt5UQhg4ptV60/I2NzkYQtq0FxyFXC+2uv3TwqbWlVVBjquJIVzLz4xK3d44rwv
         VGQg==
X-Gm-Message-State: AOJu0YyCj/Q0Gb/0o7rNWPeRKIYO6UBvg2DQUz3oE39t4l36BbnXVElD
        1Ss61J4ffiblwwsO7DZbmuYWynIsKFs=
X-Google-Smtp-Source: AGHT+IGeDAbE6ned/TiFDA+E5o/V0aLMhmnKcGIfiAq3R6pTgpffxqMMsskzkx/p3dOKioAn4Nnp/A==
X-Received: by 2002:a17:90a:88a:b0:27e:22b:dce5 with SMTP id v10-20020a17090a088a00b0027e022bdce5mr8612045pjc.27.1698698033656;
        Mon, 30 Oct 2023 13:33:53 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:cdb4:fb8:6857:c61c])
        by smtp.gmail.com with ESMTPSA id f22-20020a17090ace1600b002808c9e3095sm748979pju.26.2023.10.30.13.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 13:33:53 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH v3] xfs: up(ic_sema) if flushing data device fails
Date:   Mon, 30 Oct 2023 13:33:49 -0700
Message-ID: <20231030203349.663275-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We flush the data device cache before we issue external log IO. If
the flush fails, we shut down the log immediately and return. However,
the iclog->ic_sema is left in a decremented state so let's add an up().
Prior to this patch, xfs/438 would fail consistently when running with
an external log device:

sync
  -> xfs_log_force
  -> xlog_write_iclog
      -> down(&iclog->ic_sema)
      -> blkdev_issue_flush (fail causes us to intiate shutdown)
          -> xlog_force_shutdown
          -> return

unmount
  -> xfs_log_umount
      -> xlog_wait_iclog_completion
          -> down(&iclog->ic_sema) --------> HANG

There is a second early return / shutdown. Make sure the up() happens
for it as well. Also make sure we cleanup the iclog state,
xlog_state_done_syncing, before dropping the iclog lock.

Fixes: b5d721eaae47 ("xfs: external logs need to flush data device")
Fixes: 842a42d126b4 ("xfs: shutdown on failure to add page to log bio")
Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
v1->v2:
 - use goto instead of multiple returns
 - add Fixes tags
v2->v3:
 - added xlog_state_done_syncing to cleanup iclog state
     before dropping iclog lock

 fs/xfs/xfs_log.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..ee206facf0dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1893,9 +1893,7 @@ xlog_write_iclog(
 		 * the buffer manually, the code needs to be kept in sync
 		 * with the I/O completion path.
 		 */
-		xlog_state_done_syncing(iclog);
-		up(&iclog->ic_sema);
-		return;
+		goto sync;
 	}
 
 	/*
@@ -1925,20 +1923,17 @@ xlog_write_iclog(
 		 * avoid shutdown re-entering this path and erroring out again.
 		 */
 		if (log->l_targ != log->l_mp->m_ddev_targp &&
-		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
-			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-			return;
-		}
+		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
+			goto shutdown;
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
 
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
-	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-		return;
-	}
+	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
+		goto shutdown;
+
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
 
@@ -1959,6 +1954,12 @@ xlog_write_iclog(
 	}
 
 	submit_bio(&iclog->ic_bio);
+	return;
+shutdown:
+	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+sync:
+	xlog_state_done_syncing(iclog);
+	up(&iclog->ic_sema);
 }
 
 /*
-- 
2.42.0.820.g83a721a137-goog

