Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JGXtws220192 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 11:33:55 -0500
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99B69AC00D
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 09:35:04 -0700 (PDT)
Message-Id: <20120919163145.367256258@sgi.com>
Date: Wed, 19 Sep 2012 11:31:34 -0500
From: tinguely@sgi.com
Subject: [PATCH 1/3] xfs: restrict allocate worker to x86_64
References: <20120919163133.097340199@sgi.com>
Content-Disposition: inline; filename=1-3-xfs-restrict_allocate_worker.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Restrict the allocation worker to X86_64 machines. This will improve
performance on non-X86-64 machines and avoid the AGF buffer hang.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2417,6 +2417,7 @@ error0:
 	return error;
 }
 
+#if defined(CONFIG_X86_64)
 static void
 xfs_alloc_vextent_worker(
 	struct work_struct	*work)
@@ -2433,6 +2434,7 @@ xfs_alloc_vextent_worker(
 
 	current_restore_flags_nested(&pflags, PF_FSTRANS);
 }
+#endif
 
 /*
  * Data allocation requests often come in with little stack to work on. Push
@@ -2444,6 +2446,7 @@ int
 xfs_alloc_vextent(
 	struct xfs_alloc_arg	*args)
 {
+#if defined(CONFIG_X86_64)
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	if (!args->userdata)
@@ -2455,6 +2458,14 @@ xfs_alloc_vextent(
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
 	return args->result;
+#else
+	/* The allocation worker is needed by the i386_64.
+	 * Do not use the worker for other platforms. This will
+	 * allow those platforms avoid the performance hit and
+	 * the potential AGF buffer deadlock issue.
+	 */
+	return __xfs_alloc_vextent(args);
+#endif
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
