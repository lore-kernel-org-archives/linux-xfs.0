Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66725EE3F00
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 18:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjILSA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 14:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjILSA6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 14:00:58 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19C010D3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:54 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-68fe2470d81so1334114b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694541654; x=1695146454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wBSl0G0zIcXuxkni3mw2/DyTr7082CNv0uPbSP1+zYQ=;
        b=R6J8lb8mbEh9H4tnmvxu3XkFcbk6fshnuojtv8QvNydCNgXBB43KmFAcGBo+Fub1GV
         r0aEfPU5BCehw7p8pkBnDftoXQJ9ss4496OEfCTil7Ip6BJ2hjBFNtUS58ld5uvU4Hxw
         BJLa6vMXpvi4ptwn+pQlFFBXQOVDU2cLMzENnq8v7lgJXeK+ZSoBNmY2/bNpPjfll2bx
         CipCBuNjpgPnax6jCwk4Qqt8VMZpcm0DWK4VLkaE9h3I6dWL5pcM9Q0JQEicrK9T0itV
         g3dsqBrR6pcj+5Gvxd5Wqn64jfnCGzthPFvHCbJREqe4HdwlTn5W0T8NqFhbq8ceNEhp
         rcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694541654; x=1695146454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBSl0G0zIcXuxkni3mw2/DyTr7082CNv0uPbSP1+zYQ=;
        b=BlgvWTN7cA0BFYlN4tRJtp2kMdaNtcdkxPuFj5YfNIpBz69c165VVhCCXE4In4Hm5r
         aJwOLKtnPnd5rytk5gjZbmkd1n8jZwuJpmlgTxgrwjkG8VGBfw7lKqWYZYkoRbLHsWmJ
         3b3LaE11ktb0wimdVIBuu8x40JsfnidUsBXRHCQpwYTPUXsQmjgH97pOlatiV25AUXma
         TTt8tDd212z2uhZR6Z6xvjzpdu8O4TYqsJzXBWhR0+riZ9ryZsFCfGs5h51TCc6ShVAr
         NabGY+XtdJVj9ZKgGq33dD55512nRkk1DrQoQAi90Pqjl6Eb/LrAyWiA5PfxNg4xL1H6
         5h9w==
X-Gm-Message-State: AOJu0Yx8G67q+ynZkXeNTZVuxOkxTM1wb5YFMRuvJPWWErLS/FTqrmMc
        5PzAs26btMTCUxeYvKSBaqgRHePIxw60bg==
X-Google-Smtp-Source: AGHT+IFcNFEdiaMZxIraLWi6s809dEW9BatKJsMhvcu4iu+CRnbDfKfVRTlqWPuH3sfWdH7byaYZJQ==
X-Received: by 2002:a05:6a00:124b:b0:68f:cb69:8e7b with SMTP id u11-20020a056a00124b00b0068fcb698e7bmr555918pfi.2.1694541654151;
        Tue, 12 Sep 2023 11:00:54 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:e951:d95c:9c79:d1b])
        by smtp.gmail.com with ESMTPSA id x12-20020aa784cc000000b0068be7119c70sm3412246pfn.186.2023.09.12.11.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:00:53 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        Chris Dunlop <chris@onthe.net.au>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 2/6] xfs: introduce xfs_inodegc_push()
Date:   Tue, 12 Sep 2023 11:00:36 -0700
Message-ID: <20230912180040.3149181-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230912180040.3149181-1-leah.rumancik@gmail.com>
References: <20230912180040.3149181-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 5e672cd69f0a534a445df4372141fd0d1d00901d ]

The current blocking mechanism for pushing the inodegc queue out to
disk can result in systems becoming unusable when there is a long
running inodegc operation. This is because the statfs()
implementation currently issues a blocking flush of the inodegc
queue and a significant number of common system utilities will call
statfs() to discover something about the underlying filesystem.

This can result in userspace operations getting stuck on inodegc
progress, and when trying to remove a heavily reflinked file on slow
storage with a full journal, this can result in delays measuring in
hours.

Avoid this problem by adding "push" function that expedites the
flushing of the inodegc queue, but doesn't wait for it to complete.

Convert xfs_fs_statfs() and xfs_qm_scall_getquota() to use this
mechanism so they don't block but still ensure that queued
operations are expedited.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Reported-by: Chris Dunlop <chris@onthe.net.au>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
[djwong: fix _getquota_next to use _inodegc_push too]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_icache.c      | 20 +++++++++++++++-----
 fs/xfs/xfs_icache.h      |  1 +
 fs/xfs/xfs_qm_syscalls.c |  9 ++++++---
 fs/xfs/xfs_super.c       |  7 +++++--
 fs/xfs/xfs_trace.h       |  1 +
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2c3ef553f5ef..e9ebfe6f8015 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1872,19 +1872,29 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately and
- * wait for the work to finish.
+ * Expedite all pending inodegc work to run immediately. This does not wait for
+ * completion of the work.
  */
 void
-xfs_inodegc_flush(
+xfs_inodegc_push(
 	struct xfs_mount	*mp)
 {
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
+	trace_xfs_inodegc_push(mp, __return_address);
+	xfs_inodegc_queue_all(mp);
+}
 
+/*
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
+ */
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	xfs_inodegc_push(mp);
 	trace_xfs_inodegc_flush(mp, __return_address);
-
-	xfs_inodegc_queue_all(mp);
 	flush_workqueue(mp->m_inodegc_wq);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2e4cfddf8b8e..6cd180721659 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -76,6 +76,7 @@ void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
+void xfs_inodegc_push(struct xfs_mount *mp);
 void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 47fe60e1a887..322a111dfbc0 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -481,9 +481,12 @@ xfs_qm_scall_getquota(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	/* Flush inodegc work at the start of a quota reporting scan. */
+	/*
+	 * Expedite pending inodegc work at the start of a quota reporting
+	 * scan but don't block waiting for it to complete.
+	 */
 	if (id == 0)
-		xfs_inodegc_flush(mp);
+		xfs_inodegc_push(mp);
 
 	/*
 	 * Try to get the dquot. We don't want it allocated on disk, so don't
@@ -525,7 +528,7 @@ xfs_qm_scall_getquota_next(
 
 	/* Flush inodegc work at the start of a quota reporting scan. */
 	if (*id == 0)
-		xfs_inodegc_flush(mp);
+		xfs_inodegc_push(mp);
 
 	error = xfs_qm_dqget_next(mp, *id, type, &dqp);
 	if (error)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8fe6ca9208de..9b3af7611eaa 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -795,8 +795,11 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
-	/* Wait for whatever inactivations are in progress. */
-	xfs_inodegc_flush(mp);
+	/*
+	 * Expedite background inodegc but don't wait. We do not want to block
+	 * here waiting hours for a billion extent file to be truncated.
+	 */
+	xfs_inodegc_push(mp);
 
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1033a95fbf8e..ebd17ddba024 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -240,6 +240,7 @@ DEFINE_EVENT(xfs_fs_class, name,					\
 	TP_PROTO(struct xfs_mount *mp, void *caller_ip), \
 	TP_ARGS(mp, caller_ip))
 DEFINE_FS_EVENT(xfs_inodegc_flush);
+DEFINE_FS_EVENT(xfs_inodegc_push);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_inodegc_queue);
-- 
2.42.0.283.g2d96d420d3-goog

