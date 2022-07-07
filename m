Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BD6C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 22:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbiGGWin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbiGGWim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 18:38:42 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521F217A85
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 15:38:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fz10so10428903pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 07 Jul 2022 15:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HzGY9lzKAA+BGuGmKo3oDRTBMS2gsd2Nee5IUmSbtjU=;
        b=nU71PifGYOZFBBnHdA1mu0MGD2PvWmNP1W73pPoEyq6nbkjY6E0/S65EaBYH6F2SG7
         24LNdkPGTWD4cQzPnce0K3tCTP8mNv5BmvzsLVsu/HwfXmO4IzsGlIKLr/2sMGNLriL+
         +qDSjHPQVg32XQ/uzBc8UWSuZhxhXiAqYhWMA1Gk5+hcJ7nCZC+sjpIXM/+X1QNriF9O
         Mj0E+8SWqrJhVlABpE2cA5zsXna25XmP4A3zox6+S0b2qenBRbxBdfWs7115S0viDRtd
         6RjszTjbcSNtQ/4RAweCMYuCWmlLh9Q56YJo7bpcbCFNWTjkf6aSTdUq0IHPvN6Nts5l
         kjgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HzGY9lzKAA+BGuGmKo3oDRTBMS2gsd2Nee5IUmSbtjU=;
        b=pWJ9XJdFBXVIzSu7SBEaC6CkFI5Q+BswEbuWM36R2EISWHotSsByjNGPEQBzHE1qmC
         8lQPpTkrUVO5XMEGc+cdgCw2fRQKcvflY5jb5mhh6Iv5AO6q78SvzGi8HI9pMFp5HDO1
         RQUhKgLUlw+k17P7gj6XP7mcProvFKEZzGAb5QjBp4am2z+yCOBuh6li/eb3dr5Yig2o
         TdfaDt1uDc9K/T99VdHUYbE0+CI08rKc5smBD27SFbGIxyMve3kNxWX1kSc08f+7CnSk
         KRZe8pyp9am2MAfiEL0ejpYmSutyb9GG9e68fcK6VUmf8LgdcPI6je2ZHLx5n4Cj+tCw
         s0ag==
X-Gm-Message-State: AJIora81arvPvcC2Fqt+fMiisrcYN/2ueEq2wUfCuadMi2Qc/mxP/MKH
        cgJCNnvO/qVOLCHTNgDXduUya35MEYOOzg==
X-Google-Smtp-Source: AGRyM1tsI/VwpM5g17QBF8hJZOQf37pV8zvFXDCsIhx6zt5E1zhj/KDgu5oSngq/QeMsiiUeZhiHzw==
X-Received: by 2002:a17:903:22c1:b0:16c:eb4:83ea with SMTP id y1-20020a17090322c100b0016c0eb483eamr296724plg.123.1657233520750;
        Thu, 07 Jul 2022 15:38:40 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:26db:8a38:cdca:57b5])
        by smtp.gmail.com with ESMTPSA id j15-20020a056a00234f00b0052542cbff9dsm28776889pfj.99.2022.07.07.15.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:38:40 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <lrumancik@google.com>
Subject: [PATCH 5.15 CANDIDATE 3/4] xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks
Date:   Thu,  7 Jul 2022 15:38:27 -0700
Message-Id: <20220707223828.599185-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220707223828.599185-1-leah.rumancik@gmail.com>
References: <20220707223828.599185-1-leah.rumancik@gmail.com>
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
Signed-off-by: Leah Rumancik <lrumancik@google.com>
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
2.37.0.rc0.161.g10f37bed90-goog

