Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF2DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347854AbiFCS6J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240462AbiFCS6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:58:07 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0212983A
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:58:06 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g184so7902074pgc.1
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fl3v3MS3aj2KVPVMOC/Yzq6pLWVtpc/+yF8EB5Vih10=;
        b=bWymaRF50j4Vdb61SuR77Q+AD2kCdytM9WHzgIMU9+hTiHuOMpbJrgkmFg2+eGjOhj
         gGKE3OmZy46uF+pZHGTaGhivA32VIFdkVoQCpOzFXj2QUrE8TX3rHFoXRyddKNCuhTYu
         MRg1hWnJcjR5PZ1Fkpwg9FjfvG8vtZwB8a+qGU6U9k1trz1/5BZi/6Yu0lD7dNQ/ZK/N
         b0mJKMyK2O199N4IR2MDdmtaH9kHT+SYtsUqsi+WQz6s/4z2W4nWbokUO59qYyLXsbih
         VuyyHTggVOYOFQirguCko4j1UQo9xeMTJHfAtINDLDIDXfThvm8jm/yu0nZVAD7u8rPO
         dy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fl3v3MS3aj2KVPVMOC/Yzq6pLWVtpc/+yF8EB5Vih10=;
        b=Leuj2kaviC8IBrUkjUQQuAnbx6kRhfZF/zeG0pxdcVumeWP1FPVgTYJw17Riff4v9Y
         IknuRAivC1aXISxA+NMoUsWoSgC3WRpJywaEGi2WevgzQRn6Tnby4VJXbfPjjfsbM9v2
         kyKqx00ES/P50DDzbI0Y2Us2GnlTwliMHSBe4WRoAhOhypBEvTvk8H9QRjPNdkViVr1Q
         19WJVz0nCYmn7hWnLocUB9BVjkJhmbinn40T9HgTLR1lnOz/4MvBtRb3CJKCoxzsg4xZ
         2wa6QENTDM1WpVWxUt4Y0EB4ZOpn1NcjVw8foW2iLfwMbcaip+1Ky4puOqNf5jyfPeWM
         wDiQ==
X-Gm-Message-State: AOAM533/vfiQZfODKQsfucfr9YN/AhNKpbgnmQ8ZNM67ndaiCAQYUSKW
        V+sGipvoyYfstMBDqjDKP5CeFyMAtv/idQ==
X-Google-Smtp-Source: ABdhPJx8ci8/Mx0azsDq3y3bTEOI1TY7n/OLBPhmHUCBJQy1sw2+Ht10mh/M/KBzAm5+gc3/uzV6Vg==
X-Received: by 2002:a65:5c05:0:b0:3db:7729:88e1 with SMTP id u5-20020a655c05000000b003db772988e1mr10029932pgr.577.1654282686080;
        Fri, 03 Jun 2022 11:58:06 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:58:05 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 12/15] xfs: async CIL flushes need pending pushes to be made stable
Date:   Fri,  3 Jun 2022 11:57:18 -0700
Message-Id: <20220603185721.3121645-12-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 70447e0ad9781f84e60e0990888bd8c84987f44e ]

When the AIL tries to flush the CIL, it relies on the CIL push
ending up on stable storage without having to wait for and
manipulate iclog state directly. However, if there is already a
pending CIL push when the AIL tries to flush the CIL, it won't set
the cil->xc_push_commit_stable flag and so the CIL push will not
actively flush the commit record iclog.

generic/530 when run on a single CPU test VM can trigger this fairly
reliably. This test exercises unlinked inode recovery, and can
result in inodes being pinned in memory by ongoing modifications to
the inode cluster buffer to record unlinked list modifications. As a
result, the first inode unlinked in a buffer can pin the tail of the
log whilst the inode cluster buffer is pinned by the current
checkpoint that has been pushed but isn't on stable storage because
because the cil->xc_push_commit_stable was not set. This results in
the log/AIL effectively deadlocking until something triggers the
commit record iclog to be pushed to stable storage (i.e. the
periodic log worker calling xfs_log_force()).

The fix is two-fold - first we should always set the
cil->xc_push_commit_stable when xlog_cil_flush() is called,
regardless of whether there is already a pending push or not.

Second, if the CIL is empty, we should trigger an iclog flush to
ensure that the iclogs of the last checkpoint have actually been
submitted to disk as that checkpoint may not have been run under
stable completion constraints.

Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>
Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b59cc9c0961c..e29127fbed2c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1219,18 +1219,27 @@ xlog_cil_push_now(
 	if (!async)
 		flush_workqueue(cil->xc_push_wq);
 
+	spin_lock(&cil->xc_push_lock);
+
+	/*
+	 * If this is an async flush request, we always need to set the
+	 * xc_push_commit_stable flag even if something else has already queued
+	 * a push. The flush caller is asking for the CIL to be on stable
+	 * storage when the next push completes, so regardless of who has queued
+	 * the push, the flush requires stable semantics from it.
+	 */
+	cil->xc_push_commit_stable = async;
+
 	/*
 	 * If the CIL is empty or we've already pushed the sequence then
-	 * there's no work we need to do.
+	 * there's no more work that we need to do.
 	 */
-	spin_lock(&cil->xc_push_lock);
 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
 
 	cil->xc_push_seq = push_seq;
-	cil->xc_push_commit_stable = async;
 	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
 	spin_unlock(&cil->xc_push_lock);
 }
@@ -1328,6 +1337,13 @@ xlog_cil_flush(
 
 	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
 	xlog_cil_push_now(log, seq, true);
+
+	/*
+	 * If the CIL is empty, make sure that any previous checkpoint that may
+	 * still be in an active iclog is pushed to stable storage.
+	 */
+	if (list_empty(&log->l_cilp->xc_cil))
+		xfs_log_force(log->l_mp, 0);
 }
 
 /*
-- 
2.36.1.255.ge46751e96f-goog

