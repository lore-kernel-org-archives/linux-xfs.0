Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF94364EBF
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 10:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024120; cv=none; b=Q8tYYNlj8SzDcQgFb6tkPAvy3VWUEatacGtM8hijo3B6R48oGANRLK4m1l/Ii78ZtcjLLgxw+EbDIvVddhIhDgFhLqMHD6UopKsssRiNMK8dm3RXChGU1rLTkWL+Qval5V4fA0Gjnda71jrA+prgBbHmLnpb5WUkbF2Q8RFE4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024120; c=relaxed/simple;
	bh=kPrNgsDRivRDPcvksQTGjuyrSS+KOZO65V4bh/N3t8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a26LJZx5Fg771+ppUQmQwD59Q3lFp8mTMYRop5SVBJgmAi6p7GayZAQ2Odcl9CdJje/EuiJo9DL8tq2Px/S9XzNHut/4tSVgcPfZ+RJZjS4Lov6xAoctY1/yiPrlAjPo/PoelMHV9u/a5MHPhvRHw9mEJcVG5eHHsMdAiOw2nEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o7OshBKp; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o7OshBKp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784024106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=56WaBc6KXQyiipU+GOph11PsAxOVbA6Vo71DO1epUmU=;
	b=o7OshBKpJ96UBIQa6AkejMkZQiPGv9LV20o8q96VoBIHxr5DI02vQGJoH6/Rms4+sbJWYo
	l3+EccFU9tEcAmYpRR7YTLNB6Bx69xoTQMKcDdqKvi2CC7Gh7W6W71zYW4zTaAVUEPL87x
	Adi41BX+7qZ8wEaW2Sx8IuXJzH1/fEM=
From: Usama Arif <usama.arif@linux.dev>
To: brauner@kernel.org,
	qi.zheng@linux.dev,
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
Subject: [PATCH] fs: push nr_cached_objects memcg gating into individual filesystems
Date: Tue, 14 Jul 2026 03:14:54 -0700
Message-ID: <20260714101454.1202449-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
in memcg slab shrink") added a check in fs/super.c that skips the
->nr_cached_objects() hook whenever the shrinker is invoked for a
non-root memcg, because none of the current implementations (btrfs,
xfs, shmem huge) honour sc->memcg.

That policy is really a filesystem-owned property: fs/super.c should
not encode the assumption that these hooks are never memcg-aware,
since a future implementation might legitimately filter by sc->memcg.
Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
and shmem_unused_huge_count() so each filesystem can lift the
restriction independently once its underlying counters/scans become
memcg-aware, without needing a coordinated change to fs/super.c.

Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
still early-return 0 for non-root memcg contexts, keeping the shrinker
bit clearable in each memcg's bitmap; the global (kswapd or root
direct reclaim) path still drives them as before.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/btrfs/super.c   | 11 +++++++++++
 fs/super.c         | 19 ++-----------------
 fs/xfs/xfs_super.c | 12 ++++++++++++
 mm/shmem.c         | 11 +++++++++++
 4 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a7d804219bec..16c24bccc897 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -22,6 +22,7 @@
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
+#include <linux/memcontrol.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/crc32c.h>
@@ -2434,6 +2435,16 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
 
+	/*
+	 * The evictable extent map counter is filesystem-global and does not
+	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
+	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work and
+	 * pinning the shrinker bit in every memcg's bitmap.
+	 */
+	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
+		return 0;
+
 	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
 
 	return nr;
diff --git a/fs/super.c b/fs/super.c
index d2d04a6f4f84..a8fd61136aaf 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -24,7 +24,6 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/memcontrol.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
@@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
 	wake_up_var(&sb->s_flags);
 }
 
-/*
- * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
- * operate on filesystem-global state and ignore sc->memcg. Driving them
- * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
- * per-cpu counters and queueing duplicate work: the actual reclaim happens on
- * the global path (kswapd or root direct reclaim) regardless. Restrict them
- * to that path.
- */
-static inline bool super_fs_objects_eligible(struct shrink_control *sc)
-{
-	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
-}
-
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -212,7 +198,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
+	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -273,8 +259,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects &&
-	    super_fs_objects_eligible(sc))
+	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eac7f9503805..f0d8251fad3b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -54,6 +54,7 @@
 #include "scrub/rcbag_btree.h"
 
 #include <linux/magic.h>
+#include <linux/memcontrol.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/fserror.h>
@@ -1242,6 +1243,17 @@ xfs_fs_nr_cached_objects(
 	/* Paranoia: catch incorrect calls during mount setup or teardown */
 	if (WARN_ON_ONCE(!sb->s_fs_info))
 		return 0;
+
+	/*
+	 * The reclaimable inode count is filesystem-global and does not honour
+	 * sc->memcg, so it is only meaningful on the global (kswapd or root
+	 * direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work and
+	 * pinning the shrinker bit in every memcg's bitmap.
+	 */
+	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
+		return 0;
+
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 5789a0f5a346..3ba812e4f5ba 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -846,6 +846,17 @@ static long shmem_unused_huge_count(struct super_block *sb,
 		struct shrink_control *sc)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
+	/*
+	 * The per-superblock shrinklist is filesystem-global and does not
+	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
+	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work and
+	 * pinning the shrinker bit in every memcg's bitmap.
+	 */
+	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
+		return 0;
+
 	return READ_ONCE(sbinfo->shrinklist_len);
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-- 
2.53.0-Meta

