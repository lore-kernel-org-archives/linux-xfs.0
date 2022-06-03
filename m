Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECD6C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348510AbiFCS6N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348485AbiFCS6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:58:10 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0636729C8A
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:58:09 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d22so7412274plr.9
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yHd4N9m4mGJb2MT05n0HK3X7DILb9IEEwjS//wr0+bk=;
        b=OgFCPgIgeE6XABU9ctDpPG+337lzXU2CxtjdhRv82NIK/AIse+xYr54kM0qW63LcSw
         RyXkNFSyo6qAHZom43NzYUFMAcMBl52NafxiNcpIhKlXNr7vrCIlkUp8iNJDrmJwYtgT
         vcHYyb0vZWz4QHxGh1LMRORWXGKSXl1LWp6Osf/JxCZhl8+jKLlZOUbU6/3cfFdOjjr4
         FGNlE2YYBVIuCkeCkVZ1wPTXQQf6/NVhhpBVGI2ZdM3MShq6E+0+8mIi/0jHIBy1PZoQ
         zovubbNHTx8fFLPaC5KNkcNHIAI62OBQRge9+8eYJQC+Ljf91/KWnQU1fED6wr3vovu7
         EFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yHd4N9m4mGJb2MT05n0HK3X7DILb9IEEwjS//wr0+bk=;
        b=pWLMH4YroCKJz0sf2KUTmgd81tPgGGlKS1kAuxjJ2zYW+ZeEFEU0IJpw7BReHASlo9
         AoBdN4/BPaHtUgi7aDnvmt5crJdWkr6xBlQNAToxv+dUKxHqoOiZls/xouA8bWeaZhb2
         6dKgJmwGbHtEHdUndhbKuhzeMAWQX2iMrq1Dn6m/cFHt0id8M/q7DrfUAiEmQ7iz5ZfP
         xVoYuke1pZjl9e/zAlAC/hkHZq4V+fYIqmUkfxrwgbIHqIMClvNs/q7NvmMhmC+9XjJg
         TDlVjbEJ92LTEGy1LA5qbD9gJVNaRwGyePXescMIhP0fj7hxVue4uaU+UMJp0sRHzDsg
         V/SA==
X-Gm-Message-State: AOAM532BP+IJtb+9CQnQFxbJ99h9zChUCBecacWjiOANhHzsgulGCzJ4
        jFbSkTGeHQY9Egnv7zaRWNvJ4ZyPu0Evvg==
X-Google-Smtp-Source: ABdhPJzI4yBAe8b/2GqpIyOKxc9U/bA9rwhxx5m0QibSaWr8rUfC717t1Fl2WCYT2cPgbN06Ml0OfQ==
X-Received: by 2002:a17:902:ecc3:b0:161:eda6:1e8d with SMTP id a3-20020a170902ecc300b00161eda61e8dmr11253270plh.108.1654282688083;
        Fri, 03 Jun 2022 11:58:08 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:58:07 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 14/15] xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks
Date:   Fri,  3 Jun 2022 11:57:20 -0700
Message-Id: <20220603185721.3121645-14-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cd6f79d1fb324968a3bae92f82eeb7d28ca1fd22 ]

Brian reported a null pointer dereference failure during unmount in
xfs/006. He tracked the problem down to the AIL being torn down
before a log shutdown had completed and removed all the items from
the AIL. The failure occurred in this path while unmount was
proceeding in another task:

 xfs_trans_ail_delete+0x102/0x130 [xfs]
 xfs_buf_item_done+0x22/0x30 [xfs]
 xfs_buf_ioend+0x73/0x4d0 [xfs]
 xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
 xlog_cil_committed+0x2a9/0x300 [xfs]
 xlog_cil_process_committed+0x69/0x80 [xfs]
 xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
 xlog_force_shutdown+0xdf/0x150 [xfs]
 xfs_do_force_shutdown+0x5f/0x150 [xfs]
 xlog_ioend_work+0x71/0x80 [xfs]
 process_one_work+0x1c5/0x390
 worker_thread+0x30/0x350
 kthread+0xd7/0x100
 ret_from_fork+0x1f/0x30

This is processing an EIO error to a log write, and it's
triggering a force shutdown. This causes the log to be shut down,
and then it is running attached iclog callbacks from the shutdown
context. That means the fs and log has already been marked as
xfs_is_shutdown/xlog_is_shutdown and so high level code will abort
(e.g. xfs_trans_commit(), xfs_log_force(), etc) with an error
because of shutdown.

The umount would have been blocked waiting for a log force
completion inside xfs_log_cover() -> xfs_sync_sb(). The first thing
for this situation to occur is for xfs_sync_sb() to exit without
waiting for the iclog buffer to be comitted to disk. The
above trace is the completion routine for the iclog buffer, and
it is shutting down the filesystem.

xlog_state_shutdown_callbacks() does this:

{
        struct xlog_in_core     *iclog;
        LIST_HEAD(cb_list);

        spin_lock(&log->l_icloglock);
        iclog = log->l_iclog;
        do {
                if (atomic_read(&iclog->ic_refcnt)) {
                        /* Reference holder will re-run iclog callbacks. */
                        continue;
                }
                list_splice_init(&iclog->ic_callbacks, &cb_list);
>>>>>>           wake_up_all(&iclog->ic_write_wait);
>>>>>>           wake_up_all(&iclog->ic_force_wait);
        } while ((iclog = iclog->ic_next) != log->l_iclog);

        wake_up_all(&log->l_flush_wait);
        spin_unlock(&log->l_icloglock);

>>>>>>  xlog_cil_process_committed(&cb_list);
}

This wakes any thread waiting on IO completion of the iclog (in this
case the umount log force) before shutdown processes all the pending
callbacks.  That means the xfs_sync_sb() waiting on a sync
transaction in xfs_log_force() on iclog->ic_force_wait will get
woken before the callbacks attached to that iclog are run. This
results in xfs_sync_sb() returning an error, and so unmount unblocks
and continues to run whilst the log shutdown is still in progress.

Normally this is just fine because the force waiter has nothing to
do with AIL operations. But in the case of this unmount path, the
log force waiter goes on to tear down the AIL because the log is now
shut down and so nothing ever blocks it again from the wait point in
xfs_log_cover().

Hence it's a race to see who gets to the AIL first - the unmount
code or xlog_cil_process_committed() killing the superblock buffer.

To fix this, we just have to change the order of processing in
xlog_state_shutdown_callbacks() to run the callbacks before it wakes
any task waiting on completion of the iclog.

Reported-by: Brian Foster <bfoster@redhat.com>
Fixes: aad7272a9208 ("xfs: separate out log shutdown callback processing")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_log.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6cd2d4aa770..9ac4fc177d93 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -487,7 +487,10 @@ xfs_log_reserve(
  * Run all the pending iclog callbacks and wake log force waiters and iclog
  * space waiters so they can process the newly set shutdown state. We really
  * don't care what order we process callbacks here because the log is shut down
- * and so state cannot change on disk anymore.
+ * and so state cannot change on disk anymore. However, we cannot wake waiters
+ * until the callbacks have been processed because we may be in unmount and
+ * we must ensure that all AIL operations the callbacks perform have completed
+ * before we tear down the AIL.
  *
  * We avoid processing actively referenced iclogs so that we don't run callbacks
  * while the iclog owner might still be preparing the iclog for IO submssion.
@@ -501,7 +504,6 @@ xlog_state_shutdown_callbacks(
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);
 
-	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
 	do {
 		if (atomic_read(&iclog->ic_refcnt)) {
@@ -509,14 +511,16 @@ xlog_state_shutdown_callbacks(
 			continue;
 		}
 		list_splice_init(&iclog->ic_callbacks, &cb_list);
+		spin_unlock(&log->l_icloglock);
+
+		xlog_cil_process_committed(&cb_list);
+
+		spin_lock(&log->l_icloglock);
 		wake_up_all(&iclog->ic_write_wait);
 		wake_up_all(&iclog->ic_force_wait);
 	} while ((iclog = iclog->ic_next) != log->l_iclog);
 
 	wake_up_all(&log->l_flush_wait);
-	spin_unlock(&log->l_icloglock);
-
-	xlog_cil_process_committed(&cb_list);
 }
 
 /*
@@ -583,11 +587,8 @@ xlog_state_release_iclog(
 		 * pending iclog callbacks that were waiting on the release of
 		 * this iclog.
 		 */
-		if (last_ref) {
-			spin_unlock(&log->l_icloglock);
+		if (last_ref)
 			xlog_state_shutdown_callbacks(log);
-			spin_lock(&log->l_icloglock);
-		}
 		return -EIO;
 	}
 
@@ -3904,7 +3905,10 @@ xlog_force_shutdown(
 	wake_up_all(&log->l_cilp->xc_start_wait);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
+
+	spin_lock(&log->l_icloglock);
 	xlog_state_shutdown_callbacks(log);
+	spin_unlock(&log->l_icloglock);
 
 	return log_error;
 }
-- 
2.36.1.255.ge46751e96f-goog

