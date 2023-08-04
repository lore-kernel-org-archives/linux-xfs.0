Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A52C04A6A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjHDRLW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjHDRLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:11:02 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8694C46B1
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:10:55 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HAWGN018486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169034; bh=DSZEMcDzHcclhsUmHzBZvm98nWwi1c9ddHiwzA+3kvo=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=lvXZu3XsIsmkDdvxEEgm6mChUX4wViEy9149XHLRPHyHZ5wUjh1hc9DzTpIKhnwt0
         4cNcq8ZiNeOJNMcHFOA+ph/YsYu+179/lUKSxtf9GxIJM5w26ALXIO/rXPNUkRLm0g
         vnGIldZk0Hliylydfnu/WNxXgCfEwhPhakiqPiFDSna3p0+J8mdnmI3raZYyUyXBYC
         atj/mCmjvEgUlvrmOVOvrjLJVob1RepVZJLr8QMbROYd/VAvA/J625FU8XSfEibYHS
         RJ3UXlX+ff0tCCis7W1duNRibtyTnX0LeYVw+oetKN4jFcu5a2oK0tnvDw9U41ZM1d
         QU7Fl7sspYyEw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0F79415C04F9; Fri,  4 Aug 2023 13:10:30 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Dave Chinner <dchinner@redhat.com>,
        Chris Dunlop <chris@onthe.net.au>
Subject: [PATCH CANDIDATE v5.15 9/9] xfs: introduce xfs_inodegc_push()
Date:   Fri,  4 Aug 2023 13:10:19 -0400
Message-Id: <20230804171019.1392900-9-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171019.1392900-1-tytso@mit.edu>
References: <20230802205747.GE358316@mit.edu>
 <20230804171019.1392900-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 5e672cd69f0a534a445df4372141fd0d1d00901d upstream.

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
2.31.0

