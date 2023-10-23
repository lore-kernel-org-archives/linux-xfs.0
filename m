Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66530C25B48
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 18:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjJWSO2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWSO1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 14:14:27 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E911B4
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 11:14:25 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5b837dc2855so2424004a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 11:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698084865; x=1698689665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lnr7vonfH+a6Nw02liyc5MbH/0QN6YqdOhM5wprU7yQ=;
        b=SOL7DjMYxu4IN4jgkD1cXucSrsgokMHFayIPUbydpw5qRSbKZXffxMFkzWPEXtGm0r
         SqanJFb5bsXmCUtatC3Z1DmcAdTsZhiCzmvhUetig+PKccvJnxZ2V8KsC7/q9kg0tIXV
         mP6Sm4SaxXLuMt6XXNu4d0jHoumNeBH/eDFHzilVpYD8rPnDW+NTKJrxaZa0loXQKu/l
         +1mSUgxTeqAYJO0VAxbhyuvrNMy1ipey4UnL/QEanaAs88W/OMRdtW6UTQ3xNI4OGi7g
         Gxg7QZkkUtvt70H+IRPaZQAQysLTfEp5RCALQ/Tkqq0FoMTO8lnJbk5rj5Cz3My1lAVk
         pwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698084865; x=1698689665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lnr7vonfH+a6Nw02liyc5MbH/0QN6YqdOhM5wprU7yQ=;
        b=aDj8DI5FK3b/aTRHGlWNHCh168inyzyi6JkUC2Dij3/MuivnhQGjS4W2Z8JryLX9lD
         dlFHlZQ0q7VJIRSw8k8FpKNl3b/oaOEyRV1wxYUP/ddoIAmRxyKhMagJHF32liDummCh
         w8CVA0Bslg09U0FgQwZdCKoY7DjEsPoI42bNSWswgzKjGTCfZmhm4MzOhPeA1WTHFCaJ
         mhsy0aY19ro7sIB9l+46qd0GWNxz8pfe/SomEGGvh8EKxSiw355+zi2bMXqzgo8Wi60h
         VDQcyQxmzPkHzQ41D/VhFhzFOJEPWovVAMmPGWDhssfu+T6mM2VUQQY7QdEKu+RJ/pJN
         2b/w==
X-Gm-Message-State: AOJu0YyDDBk2XCDd0SUK7EsNyoBBMzHcjHuHIJyV3F+gPm7Eck0XCLeb
        Mxbm9BDmqmaNjaSeuP98MHub/cQz39c=
X-Google-Smtp-Source: AGHT+IEHupBo9hi2KhKsPIWOLESz2YNpgUov1+V4vCyaU4VMHFrs6L6AdS2NZGZXT7+6GbPJjnLPrg==
X-Received: by 2002:a05:6a20:8f26:b0:17b:a34d:5b56 with SMTP id b38-20020a056a208f2600b0017ba34d5b56mr441985pzk.19.1698084864645;
        Mon, 23 Oct 2023 11:14:24 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:ec6b:4e2c:bd7e:36e7])
        by smtp.gmail.com with ESMTPSA id n9-20020aa79849000000b00682868714fdsm6617453pfq.95.2023.10.23.11.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 11:14:24 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH] xfs: up(ic_sema) if flushing data device fails
Date:   Mon, 23 Oct 2023 11:14:10 -0700
Message-ID: <20231023181410.844000-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We flush the data device cache before we issue external log IO. Since
7d839e325af2, we check the return value of the flush, and if the flush
failed, we shut down the log immediately and return. However, the
iclog->ic_sema is left in a decremented state so let's add an up().
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

There is a second early return / shutdown. Add an up() there as well.

Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---

Notes:
    Tested auto group for xfs/4k and xfs/logdev configs with no regressions
    seen.

 fs/xfs/xfs_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..b4a8105299c2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1926,6 +1926,7 @@ xlog_write_iclog(
 		 */
 		if (log->l_targ != log->l_mp->m_ddev_targp &&
 		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
+			up(&iclog->ic_sema);
 			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 			return;
 		}
@@ -1936,6 +1937,7 @@ xlog_write_iclog(
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
 	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
+		up(&iclog->ic_sema);
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 		return;
 	}
-- 
2.42.0.758.gaed0368e0e-goog

