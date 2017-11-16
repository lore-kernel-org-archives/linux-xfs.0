Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932838AbdKPBO2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Nov 2017 20:14:28 -0500
Date: Wed, 15 Nov 2017 17:14:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH for 4.14] xfs_copy: don't hang if /all/ the targets hit write
 errors
Message-ID: <20171116011232.GG5119@magnolia>
Reply-To: darrick.wong@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, djwong@kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If xfs_copy is told to copy a filesystem and /all/ the writer threads
hit an write error, there won't be any threads to unlock mainwait, which
means that write_wbuf will deadlock with itself trying to lock mainwait.
Therefore, if we discover that all the writer threads are dead, just
bail out.

Discovered by running xfs/073 with a tiny test device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 33e05df..fb37375 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -476,6 +476,7 @@ void
 write_wbuf(void)
 {
 	int		i;
+	int		badness = 0;
 
 	/* verify target threads */
 	for (i = 0; i < num_targets; i++)
@@ -486,6 +487,17 @@ write_wbuf(void)
 	for (i = 0; i < num_targets; i++)
 		if (target[i].state != INACTIVE)
 			pthread_mutex_unlock(&targ[i].wait);	/* wake up */
+		else
+			badness++;
+
+	/*
+	 * If all the targets are inactive then there won't be any io
+	 * threads left to release mainwait.  We're screwed, so bail out.
+	 */
+	if (badness == num_targets) {
+		check_errors();
+		exit(1);
+	}
 
 	signal_maskfunc(SIGCHLD, SIG_UNBLOCK);
 	pthread_mutex_lock(&mainwait);
