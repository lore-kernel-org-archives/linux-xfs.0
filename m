Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67EBE7F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 03:04:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39883304039
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 01:04:08 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id uc1yt6Gw9YagbB7m (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 01:04:06 -0700 (PDT)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH v3] xfs: Print comm name and pid when open-coded __GFP_NOFAIL
	allocation stucks
Date: Tue, 22 Sep 2015 17:03:43 +0900
Message-Id: <1442909023-4088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20150922051253.GB3902@dastard>
References: <20150922051253.GB3902@dastard>
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
To: david@fromorbit.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, xfs@oss.sgi.com

This patch adds comm name and pid to warning messages printed by
kmem_alloc(), kmem_zone_alloc() and xfs_buf_allocate_memory().
This will help telling which memory allocations (e.g. kernel worker
threads, OOM victim tasks, neither) are stalling because these functions
are passing __GFP_NOWARN which suppresses not only backtrace but comm name
and pid.

  [   66.089978] Kill process 8505 (a.out) sharing same memory
  [   69.748060] XFS: a.out(8082) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
  [   69.798580] XFS: kworker/u16:28(381) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
  [   69.876952] XFS: xfs-data/sda1(399) possible memory allocation deadlock in kmem_alloc (mode:0x8250)
  [   70.359518] XFS: a.out(8412) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
  [   73.299509] XFS: kworker/u16:28(381) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
  [   73.470350] XFS: xfs-data/sda1(399) possible memory allocation deadlock in kmem_alloc (mode:0x8250)
  [   73.664420] XFS: a.out(8082) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
  [   73.967434] XFS: a.out(8412) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
  [   76.950038] XFS: kworker/u16:28(381) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x250)
  [   76.957938] XFS: xfs-data/sda1(399) possible memory allocation deadlock in kmem_alloc (mode:0x8250)

(Strictly speaking, we want task_lock()/task_unlock() when reading comm name.)

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/kmem.c    | 10 ++++++----
 fs/xfs/xfs_buf.c |  3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a7a3a63..535c136 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -55,8 +55,9 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
-		"possible memory allocation deadlock in %s (mode:0x%x)",
-					__func__, lflags);
+		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
+				current->comm, current->pid,
+				__func__, lflags);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
@@ -120,8 +121,9 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
-		"possible memory allocation deadlock in %s (mode:0x%x)",
-					__func__, lflags);
+		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
+				current->comm, current->pid,
+				__func__, lflags);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8ecffb3..cac62e1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -354,7 +354,8 @@ retry:
 			 */
 			if (!(++retries % 100))
 				xfs_err(NULL,
-		"possible memory allocation deadlock in %s (mode:0x%x)",
+		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
+					current->comm, current->pid,
 					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
