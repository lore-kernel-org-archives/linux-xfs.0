Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD202346FB0
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 12:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781008259; cv=none; b=hnnUIzwTgUDcz9iUabD71pkVpSEB8PgUWFPjUIDWCQDSMDZkTyo6S46++PLpPjr79mXNzI4s2zmCPGXYD3o2lyhSpO+coRS0kdOqir83fWrvcJRIote/nS24eIeIHlfysyOcW1pgzHs3P5hAiOgVTwF+jMBHdzK0NSveOqlqJXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781008259; c=relaxed/simple;
	bh=nPG03SmqZwOcjX8/12Y3rN+1O64E3sALVV5t3j5yv6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f/2VY21BjoBVty/LINqlDIXTXNAb1BvsP9EZxULJtWl8LDr4UeZhmWOH9g7jQVGy6aFzCLa0HIPRsufW15PMC/b6cBQuIU3qtSPvI3l+RR5WIllrbMsRRfc4xaggpnz3fK97imaMHeWyeJe7gGXt/wyyoijbDTXyp/oNTO6HCSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xL6tUdLv; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xL6tUdLv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781008254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gSmhLbRZiCMLmvUSNQ09XQZBUjKHV+qKidrVgGQPtjM=;
	b=xL6tUdLvO6wGf/3x5Mz4uaE7Lf7/4EskVXo/P2dSlSfwoRuhGCMkji/5Y2L2/fQPurQWhF
	vjGt7pbV7bzOhX82Yj03E58N+R5IWqGcIM0UJL7FGy6s1Jb4gIrp6RYHf7nIsd3i19HxhV
	mjaJZlEr5mJaXetgmCzeJfrWRziwUbE=
From: Usama Arif <usama.arif@linux.dev>
To: brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org
Cc: hughd@google.com,
	boris@bur.io,
	clm@fb.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	cem@kernel.org,
	linux-xfs@vger.kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink
Date: Tue,  9 Jun 2026 05:30:47 -0700
Message-ID: <20260609123047.1948242-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
dentry and inode LRUs are memcg-aware (via list_lru). But the optional
->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
btrfs extent maps and xfs inode reclaim operate on filesystem-global
state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
None of them filter by sc->memcg.

The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
whose bit is set in the per-superblock shrinker bitmap, which on a busy
host means hundreds of calls per reclaim pass. Each scan queues the same
global shrinker work item that's already kicked from the root path.

Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
the returned total stays positive even if a memcg's own dentry/inode LRUs
are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
in the memcg bitmap, so subsequent reclaim passes from the same memcg
re-enter super_cache_count() and pay for the global counter walk again.

Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
or root). The memcg-aware dentry/inode LRUs keep being counted and
scanned per memcg as before; only the global fs-specific hooks are skipped.
The root/global shrink path still drives those hooks; only their
invocation from non-root memcg slab reclaim is removed.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/super.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 378e81efe643..5216c5dbd4c4 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/memcontrol.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
@@ -169,6 +170,19 @@ static void super_wake(struct super_block *sb, unsigned int flag)
 	wake_up_var(&sb->s_flags);
 }
 
+/*
+ * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
+ * operate on filesystem-global state and ignore sc->memcg. Driving them
+ * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
+ * per-cpu counters and queueing duplicate work: the actual reclaim happens on
+ * the global path (kswapd or root direct reclaim) regardless. Restrict them
+ * to that path.
+ */
+static inline bool super_fs_objects_eligible(struct shrink_control *sc)
+{
+	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
+}
+
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -198,7 +212,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects)
+	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -259,7 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects)
+	if (sb->s_op && sb->s_op->nr_cached_objects &&
+	    super_fs_objects_eligible(sc))
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
-- 
2.52.0

