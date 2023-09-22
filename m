Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F091E7D0BE
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Sep 2023 01:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjIVBCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjIVBCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 21:02:09 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA32122;
        Thu, 21 Sep 2023 18:02:03 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c5db4925f9so9141245ad.1;
        Thu, 21 Sep 2023 18:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695344523; x=1695949323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOqjqLKBsBB4hITnkzqZ6Dh7CcePl0xuVQ/ZcmiPf/Q=;
        b=VKKwsLch/S/zBSnfHYkqAmg/bLF7wEsv9orwEGU9TGu1Ukuvxx6yUuScSlfrj1ngZl
         HfSOia6QBDrHf2ZFBbraIoFwr6UG5ZZdF1PsN/FcQMnYV/tKgNCxD3rWMjAYD4XNCVGH
         CcdRREywL4Fcr+wmlaJV8EIkwuq36KzBtZPmx2LWymRIrlFR4hh2JblORKtI/gf5timx
         nM+eLFg/H8HlCy0UGUmdHSUNR+b09Ln7d7oTiJrYL+LvlN0IXEij0Gs5v7NYjg1Fmfgu
         VKz49Gjmyzfdhjdcy8RDhX9M4Cjv9F67YMeZyW6iWWI02LUlN1xmuJn63qT8lkmCvOi9
         g5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695344523; x=1695949323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOqjqLKBsBB4hITnkzqZ6Dh7CcePl0xuVQ/ZcmiPf/Q=;
        b=WBlKvencSeOjPcHRXn0WkMWCKpCECdXkvCvRFwqRC4S/1pkRUjhIe51W3HZRWbHqy8
         9NkpLz7nZ+iFHDQmDG9b03+NMHYVgAaJBIuFFrMAG4Ohn3b07wCdu/qAIqXeacT5hTcu
         xtYZfVK/vChb3CSUoo+trSopaDZGBRvc19t1Vj/IJ/uIMS8oP+u0rqPmvrsbf9fQQgef
         sNTEqhk8WTlhUCqOHjmAXOJX6ayewuGHrQBbcnlHlOVjZo/Wtu4S/zJhXDH+gHNXLCtM
         fkRxH0EzudddF+wOZNreoIaQTm1oSzDuPF03dDClZhc05BdCGnmznWEV0KZH/Qz+R9xJ
         8Hlg==
X-Gm-Message-State: AOJu0YzIfph0Bt5IxqMUPNHAS/1gAZK+9ULIxXxYUsvO45pEhYYi9i7t
        mDa8qQuk92MV6x/griAJTupClGUD/6XMnQ==
X-Google-Smtp-Source: AGHT+IHjhXQJaq6+lZQvCuP0q8dpitXt3UJhlxxd1an1RngaCUSEEzNu8NZISpUSFhx7J+DfzgQlZw==
X-Received: by 2002:a17:902:f689:b0:1b4:5699:aac1 with SMTP id l9-20020a170902f68900b001b45699aac1mr1918881plg.12.1695344522839;
        Thu, 21 Sep 2023 18:02:02 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d5ff:b7b0:7028:8af6])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090282c200b001bc445e2497sm2178815plz.79.2023.09.21.18.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 18:02:02 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        Chris Dunlop <chris@onthe.net.au>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 2/6] xfs: introduce xfs_inodegc_push()
Date:   Thu, 21 Sep 2023 18:01:52 -0700
Message-ID: <20230922010156.1718782-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230922010156.1718782-1-leah.rumancik@gmail.com>
References: <20230922010156.1718782-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.42.0.515.g380fc7ccd1-goog

