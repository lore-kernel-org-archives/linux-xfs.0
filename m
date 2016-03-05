Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A83617CA0
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 20:52:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B1018F8040
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:52:06 -0800 (PST)
Received: from g2t4622.austin.hp.com (g2t4622.austin.hp.com [15.73.212.79]) by
	cuda.sgi.com with ESMTP id GmsjIkKEtQo1hcTh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 18:52:04 -0800 (PST)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH 2/2] xfs: Allow degeneration of m_fdblocks/m_ifree to
	global counters
Date: Fri,  4 Mar 2016 21:51:39 -0500
Message-Id: <1457146299-1601-3-git-send-email-Waiman.Long@hpe.com>
In-Reply-To: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
References: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Scott J Norton <scott.norton@hp.com>, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, Douglas Hatch <doug.hatch@hp.com>

Small XFS filesystems on systems with large number of CPUs can incur a
significant overhead due to excessive calls to the percpu_counter_sum()
function which needs to walk through a large number of different
cachelines.

This patch uses the newly added percpu_counter_set_limit() API to
potentially switch the m_fdblocks and m_ifree per-cpu counters to
a global counter with locks at filesystem mount time if its size
is small relatively to the number of CPUs available.

A possible use case is the use of the NVDIMM as an application scratch
storage area for log file and other small files. Current battery-backed
NVDIMMs are pretty small in size, e.g. 8G per DIMM. So we cannot create
large filesystem on top of them.

On a 4-socket 80-thread system running 4.5-rc6 kernel, this patch can
improve the throughput of the AIM7 XFS disk workload by 25%. Before
the patch, the perf profile was:

  18.68%   0.08%  reaim  [k] __percpu_counter_compare
  18.05%   9.11%  reaim  [k] __percpu_counter_sum
   0.37%   0.36%  reaim  [k] __percpu_counter_add

After the patch, the perf profile was:

   0.73%   0.36%  reaim  [k] __percpu_counter_add
   0.27%   0.27%  reaim  [k] __percpu_counter_compare

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/xfs/xfs_mount.c |    1 -
 fs/xfs/xfs_mount.h |    5 +++++
 fs/xfs/xfs_super.c |    6 ++++++
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bb753b3..fe74b91 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1163,7 +1163,6 @@ xfs_mod_ifree(
  * a large batch count (1024) to minimise global counter updates except when
  * we get near to ENOSPC and we have to be very accurate with our updates.
  */
-#define XFS_FDBLOCKS_BATCH	1024
 int
 xfs_mod_fdblocks(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b570984..d9520f4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -206,6 +206,11 @@ typedef struct xfs_mount {
 #define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
 
 /*
+ * FD blocks batch size for per-cpu compare
+ */
+#define XFS_FDBLOCKS_BATCH	1024
+
+/*
  * Allow large block sizes to be reported to userspace programs if the
  * "largeio" mount option is used.
  *
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 59c9b7b..c0b4f79 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1412,6 +1412,12 @@ xfs_reinit_percpu_counters(
 	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
 	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
 	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
+
+	/*
+	 * Use default batch size for m_ifree
+	 */
+	percpu_counter_set_limit(&mp->m_ifree, 0);
+	percpu_counter_set_limit(&mp->m_fdblocks, 4 * XFS_FDBLOCKS_BATCH);
 }
 
 static void
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
