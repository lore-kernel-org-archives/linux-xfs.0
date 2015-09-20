Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A17457F47
	for <xfs@oss.sgi.com>; Sun, 20 Sep 2015 02:03:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F17CAC003
	for <xfs@oss.sgi.com>; Sun, 20 Sep 2015 00:03:39 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id cqIcWH0OId05Kidm (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Sep 2015 00:03:37 -0700 (PDT)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 2/2] xfs: Print comm name and pid when open-coded __GFP_NOFAIL
	allocation stucks
Date: Sun, 20 Sep 2015 16:03:14 +0900
Message-Id: <1442732594-4205-2-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <1442732594-4205-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
References: <1442732594-4205-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
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
threads, OOM victim tasks, neither) are stalling.

  [  135.568662] Out of memory: Kill process 9593 (a.out) score 998 or sacrifice child
  [  135.570195] Killed process 9593 (a.out) total-vm:4700kB, anon-rss:488kB, file-rss:0kB
  [  137.473691] XFS: kworker/u16:29(383) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  137.497662] XFS: a.out(8944) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  137.598219] XFS: a.out(9658) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  139.494529] XFS: kworker/u16:29(383) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  139.517196] XFS: a.out(8944) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  139.616396] XFS: a.out(9658) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  141.512753] XFS: kworker/u16:29(383) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  141.531421] XFS: a.out(8944) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
  [  141.633574] XFS: a.out(9658) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)

(Strictly speaking, we want task_lock()/task_unlock() when reading comm name.)

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/kmem.c    | 6 ++++--
 fs/xfs/xfs_buf.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 1fcf90d..95a5b76 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -54,8 +54,9 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
 			return ptr;
 		if (!(++retries % 100))
-			xfs_err(NULL,
+			xfs_err(NULL, "%s(%u) "
 		"possible memory allocation deadlock in %s (mode:0x%x)",
+					current->comm, current->pid,
 					__func__, lflags);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
@@ -119,8 +120,9 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
 			return ptr;
 		if (!(++retries % 100))
-			xfs_err(NULL,
+			xfs_err(NULL, "%s(%u) "
 		"possible memory allocation deadlock in %s (mode:0x%x)",
+					current->comm, current->pid,
 					__func__, lflags);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cbd4f91..5deb629 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -353,8 +353,9 @@ retry:
 			 * handle buffer allocation failures we can't do much.
 			 */
 			if (!(++retries % 100))
-				xfs_err(NULL,
+				xfs_err(NULL, "%s(%u) "
 		"possible memory allocation deadlock in %s (mode:0x%x)",
+					current->comm, current->pid,
 					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
