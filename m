Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25337C25B6B
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 22:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJYW67 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 18:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYW66 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 18:58:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94092BB
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 15:58:55 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6bb4abb8100so246754b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 15:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698274735; x=1698879535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3ugVeIVlap6t+3LxXzoKrnIQ6jZaNwr8X4qlxRwsPr0=;
        b=AyYZjIu3sWmtWIb1IwI22zljD6c5yS+mthNpnGKZD841fof6x0y4B/JbXkonipSrdr
         pZXCazafCumy9listRrEiEx4MDX1h+F/bSVKGHbTMFUEglMa6xzYDvkSlDr8oifDuUP4
         I+b69rpCQqr8L11Ap3K01twQXKT0dl6HcxXxfFLor13iTUrgtcoEkRcXxPsdMv006CPh
         yJ+ExOV/lvmF+9KrgHDufvkecOljay/smqMf50S7MiUxYLVLKqGglDFCQvQwxMlGrohM
         ePD3T7a0b5YEaFY9ZhaOZFshSCRfqJwgBRWEAFzLCryP7liPGWhEIgUTizErnkdJTwbd
         GOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698274735; x=1698879535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ugVeIVlap6t+3LxXzoKrnIQ6jZaNwr8X4qlxRwsPr0=;
        b=H5cQ63p//ZLl6q9UC0imuKE3S+90Yf1pHfDO+ZydDGMy3LhT7T4Xmz1BAjYh6ioCtF
         5LoCTqI+dYYDjWSGcMTziEH0HArhV1tSy4DrDaSFUPCPyjIBsZjm4Y7RAEclTV0RP9W3
         6JEoaNlmvnzNfuIJAls85L9+k68al9ioGnOfQ+KCsX4OGw24bpZB9FEzjEOCvbQv//C5
         BwevTMnYt+GWQP6KPx7LSl3tmKb1Pxbiymp9x9kZ/uHtYaM6LoV3D6GWbWc3N2EswFDP
         NCTw5wIaZmGFRsiv2TYE/eG73VZDIaDAfFU3M46n41s6fYgdW9Tz8bSIPCjytXVAY5RM
         Qteg==
X-Gm-Message-State: AOJu0YwcvCGbogdTNYmY59hfP7M8rD5QhBJDqlEM+P1Mb3MTvv7hNzrW
        xRZsiwUCYucAyXpMx4d+cUBiKU321TY=
X-Google-Smtp-Source: AGHT+IEdZSirSUdWD6utw8qwfq8wqOcf6fFwObL+4TFYd9uG0wcNHZBGq5md6/uKxP+Dv+97myRnwA==
X-Received: by 2002:a05:6a00:1788:b0:6b5:86c3:ccaf with SMTP id s8-20020a056a00178800b006b586c3ccafmr17103928pfg.22.1698274734725;
        Wed, 25 Oct 2023 15:58:54 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:408f:f5cc:46f9:46fa])
        by smtp.gmail.com with ESMTPSA id x2-20020aa79402000000b00690d4c16296sm9847006pfo.154.2023.10.25.15.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 15:58:54 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH v2] xfs: up(ic_sema) if flushing data device fails
Date:   Wed, 25 Oct 2023 15:58:48 -0700
Message-ID: <20231025225848.3437904-1-leah.rumancik@gmail.com>
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
for it as well.

Fixes: b5d721eaae47 ("xfs: external logs need to flush data device")
Fixes: 842a42d126b4 ("xfs: shutdown on failure to add page to log bio")
Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

Notes:
    v1->v2:
     - use goto instead of multiple returns
     - add Fixes tags

 fs/xfs/xfs_log.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..8ae923e00eb6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1925,20 +1925,17 @@ xlog_write_iclog(
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
 
@@ -1959,6 +1956,10 @@ xlog_write_iclog(
 	}
 
 	submit_bio(&iclog->ic_bio);
+	return;
+shutdown:
+	up(&iclog->ic_sema);
+	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 }
 
 /*
-- 
2.42.0.820.g83a721a137-goog

