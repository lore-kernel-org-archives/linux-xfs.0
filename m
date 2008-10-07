Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:56:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LuKNM007643
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:56:20 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F57B185E6CC
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:57:59 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id cHVW3H2VBOiBKgNp for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:57:59 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKZ3-0002Cs-Om
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:57:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: don't block in xfs_qm_dqflush() during async writeback
Date: Wed,  8 Oct 2008 08:57:57 +1100
Message-Id: <1223416677-8458-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Normally dquots are written back via delayed write mechanisms.  They
are flushed to their backing buffer by xfssyncd, which is then
pushed out by either AIL or xfsbufd flushing. The flush from the
xfssyncd is supposed to be non-blocking, but xfs_qm_dqflush() always
waits for pinned duots, which means that it will block for the
length of time it takes to do a synchronous log force. This causes
unnecessary extra log I/O to be issued whenever we try to flush a
busy dquot.

Avoid the log forces and blocking xfssyncd by making xfs_qm_dqflush()
pay attention to what type of sync it is doing when it sees a pinned
dquot and not waiting when doing non-blocking flushes.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 5dca401..591ca66 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1221,16 +1221,14 @@ xfs_qm_dqflush(
 	xfs_dqtrace_entry(dqp, "DQFLUSH");
 
 	/*
-	 * If not dirty, nada.
+	 * If not dirty, or it's pinned and we are not supposed to
+	 * block, nada.
 	 */
-	if (!XFS_DQ_IS_DIRTY(dqp)) {
+	if (!XFS_DQ_IS_DIRTY(dqp) ||
+	    (!(flags & XFS_QMOPT_SYNC) && atomic_read(&dqp->q_pincount) > 0)) {
 		xfs_dqfunlock(dqp);
-		return (0);
+		return 0;
 	}
-
-	/*
-	 * Cant flush a pinned dquot. Wait for it.
-	 */
 	xfs_qm_dqunpin_wait(dqp);
 
 	/*
-- 
1.5.6.5
