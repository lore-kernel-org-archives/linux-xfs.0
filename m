Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o371hoWk149931 for <xfs@oss.sgi.com>; Tue, 6 Apr 2010 20:43:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABCFC1D3DEEC
	for <xfs@oss.sgi.com>; Tue,  6 Apr 2010 18:45:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	9Hb9srB6cx6ljh6D for <xfs@oss.sgi.com>;
	Tue, 06 Apr 2010 18:45:36 -0700 (PDT)
Date: Wed, 7 Apr 2010 11:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100407014533.GI11036@dastard>
References: <201004050049.17952.hpj@urpla.net>
	<201004051335.41857.hpj@urpla.net> <20100405230600.GA3335@dastard>
	<201004061652.58189.hpj@urpla.net> <20100406231144.GF11036@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20100406231144.GF11036@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 07, 2010 at 09:11:44AM +1000, Dave Chinner wrote:
> On Tue, Apr 06, 2010 at 04:52:57PM +0200, Hans-Peter Jansen wrote:
> > Hi Dave,
> > 
> > On Tuesday 06 April 2010, 01:06:00 Dave Chinner wrote:
> > > On Mon, Apr 05, 2010 at 01:35:41PM +0200, Hans-Peter Jansen wrote:
> > > > >
> > > > > Oh, this is a highmem box. You ran out of low memory, I think, which
> > > > > is where all the inodes are cached. Seems like a VM problem or a
> > > > > highmem/lowmem split config problem to me, not anything to do with
> > > > > XFS...
> 
> [snip]
> 
> > Dave, I really don't want to disappoint you, but a lengthy bisection session 
> > points to:
> > 
> > 57817c68229984818fea9e614d6f95249c3fb098 is the first bad commit
> > commit 57817c68229984818fea9e614d6f95249c3fb098
> > Author: Dave Chinner <david@fromorbit.com>
> > Date:   Sun Jan 10 23:51:47 2010 +0000
> > 
> >     xfs: reclaim all inodes by background tree walks
> 
> Interesting. I did a fair bit of low memory testing when i made that
> change (admittedly none on a highmem i386 box), and since then I've
> done lots of "millions of files" tree creates, traversals and destroys on
> limited memory machines without triggering problems when memory is
> completely full of inodes.
> 
> Let me try to reproduce this on a small VM and I'll get back to you.

OK, if there is page cache pressure (e.g. creating small files or
grepping the resultant tree) or the machine has significant amounts
of memory (e.g. >= 4GB) then I can't reproduce this.

However, if the memory pressure is purely inode cache (creating zero
length files or read-only traversal), then the OOM killer kicks a
while after the slab cache fills memory.  This doesn't need highmem;
I used a x86_64 kernel on a VM w/ 1GB RAM to reliably reproduce
this.  I'll add zero length file tests and traversals to my low
memory testing.

The best way to fix this, I think, is to trigger a shrinker callback
when memory is low to run the background inode reclaim. The problem
is that these inode caches and the reclaim state are per-filesystem,
not global state, and the current shrinker interface only works with
global state.

Hence there are two patches to this fix - the first adds a context
to the shrinker callout, and the second adds the XFS infrastructure
to track the number of reclaimable inodes per filesystem and
register/unregister shrinkers for each filesystem.

With these patches, my reproducable test case which locked the
machine up with a OOM panic in a couple of minutes has been running
for over half an hour. I have much more confidence in this change
with limited testing than the reverting of the background inode
reclaim as the revert introduces 

The patches below apply to the xfs-dev tree, which is currently at
34-rc1. If they don't apply, let me know and I'll redo them against
a vanilla kernel tree. Can you test them to see if the problem goes
away? If the problem is fixed, I'll push them for a proper review
cycle...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=shrinker-context

mm: add context argument to shrinker callback

From: Dave Chinner <dchinner@redhat.com>

The current shrinker implementation requires the registered callback
to have global state to work from. This makes it difficult to shrink
caches that are not global (e.g. per-filesystem caches). Add a
context argument to the shrinker callback so that it can easily be
used in such situations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 arch/x86/kvm/mmu.c              |    2 +-
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 fs/dcache.c                     |    2 +-
 fs/gfs2/glock.c                 |    2 +-
 fs/gfs2/quota.c                 |    2 +-
 fs/gfs2/quota.h                 |    2 +-
 fs/inode.c                      |    2 +-
 fs/mbcache.c                    |    5 +++--
 fs/nfs/dir.c                    |    2 +-
 fs/nfs/internal.h               |    2 +-
 fs/quota/dquot.c                |    2 +-
 fs/ubifs/shrinker.c             |    2 +-
 fs/ubifs/ubifs.h                |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c      |    5 +++--
 fs/xfs/quota/xfs_qm.c           |    3 ++-
 include/linux/mm.h              |    3 ++-
 mm/vmscan.c                     |    9 ++++++---
 17 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 741373e..8977b3e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2914,7 +2914,7 @@ static void kvm_mmu_remove_one_alloc_mmu_page(struct kvm *kvm)
 	kvm_mmu_zap_page(kvm, page);
 }
 
-static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
+static int mmu_shrink(int nr_to_scan, void *ctx, gfp_t gfp_mask)
 {
 	struct kvm *kvm;
 	struct kvm *kvm_freed = NULL;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index fba37e9..295f993 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -5054,7 +5054,7 @@ void i915_gem_release(struct drm_device * dev, struct drm_file *file_priv)
 }
 
 static int
-i915_gem_shrink(int nr_to_scan, gfp_t gfp_mask)
+i915_gem_shrink(int nr_to_scan, void *ctx, gfp_t gfp_mask)
 {
 	drm_i915_private_t *dev_priv, *next_dev;
 	struct drm_i915_gem_object *obj_priv, *next_obj;
diff --git a/fs/dcache.c b/fs/dcache.c
index f1358e5..1545d37 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -897,7 +897,7 @@ EXPORT_SYMBOL(shrink_dcache_parent);
  *
  * In this case we return -1 to tell the caller that we baled.
  */
-static int shrink_dcache_memory(int nr, gfp_t gfp_mask)
+static int shrink_dcache_memory(int nr, void *ctx, gfp_t gfp_mask)
 {
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 454d4b4..fc4ced7 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1345,7 +1345,7 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 }
 
 
-static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
+static int gfs2_shrink_glock_memory(int nr, void *ctx, gfp_t gfp_mask)
 {
 	struct gfs2_glock *gl;
 	int may_demote;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6dbcbad..a5a1836 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -77,7 +77,7 @@ static LIST_HEAD(qd_lru_list);
 static atomic_t qd_lru_count = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(qd_lru_lock);
 
-int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask)
+int gfs2_shrink_qd_memory(int nr, void *ctx, gfp_t gfp_mask)
 {
 	struct gfs2_quota_data *qd;
 	struct gfs2_sbd *sdp;
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 195f60c..1dd6aa2 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -51,7 +51,7 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
 	return ret;
 }
 
-extern int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask);
+extern int gfs2_shrink_qd_memory(int nr, void *ctx, gfp_t gfp_mask);
 extern const struct quotactl_ops gfs2_quotactl_ops;
 
 #endif /* __QUOTA_DOT_H__ */
diff --git a/fs/inode.c b/fs/inode.c
index 407bf39..8423324 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -514,7 +514,7 @@ static void prune_icache(int nr_to_scan)
  * This function is passed the number of inodes to scan, and it returns the
  * total number of remaining possibly-reclaimable inodes.
  */
-static int shrink_icache_memory(int nr, gfp_t gfp_mask)
+static int shrink_icache_memory(int nr, void *ctx, gfp_t gfp_mask)
 {
 	if (nr) {
 		/*
diff --git a/fs/mbcache.c b/fs/mbcache.c
index ec88ff3..2c4f9bf 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -115,7 +115,7 @@ mb_cache_indexes(struct mb_cache *cache)
  * What the mbcache registers as to get shrunk dynamically.
  */
 
-static int mb_cache_shrink_fn(int nr_to_scan, gfp_t gfp_mask);
+static int mb_cache_shrink_fn(int nr_to_scan, void *ctx, gfp_t gfp_mask);
 
 static struct shrinker mb_cache_shrinker = {
 	.shrink = mb_cache_shrink_fn,
@@ -192,12 +192,13 @@ forget:
  * gets low.
  *
  * @nr_to_scan: Number of objects to scan
+ * @ctx: (ignored)
  * @gfp_mask: (ignored)
  *
  * Returns the number of objects which are present in the cache.
  */
 static int
-mb_cache_shrink_fn(int nr_to_scan, gfp_t gfp_mask)
+mb_cache_shrink_fn(int nr_to_scan, void *ctx, gfp_t gfp_mask)
 {
 	LIST_HEAD(free_list);
 	struct list_head *l, *ltmp;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index a1f6b44..b92b17d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1667,7 +1667,7 @@ static void nfs_access_free_entry(struct nfs_access_entry *entry)
 	smp_mb__after_atomic_dec();
 }
 
-int nfs_access_cache_shrinker(int nr_to_scan, gfp_t gfp_mask)
+int nfs_access_cache_shrinker(int nr_to_scan, void *ctx, gfp_t gfp_mask)
 {
 	LIST_HEAD(head);
 	struct nfs_inode *nfsi;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 11f82f0..34ad436 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -205,7 +205,7 @@ extern struct rpc_procinfo nfs4_procedures[];
 void nfs_close_context(struct nfs_open_context *ctx, int is_sync);
 
 /* dir.c */
-extern int nfs_access_cache_shrinker(int nr_to_scan, gfp_t gfp_mask);
+extern int nfs_access_cache_shrinker(int nr_to_scan, void *ctx, gfp_t gfp_mask);
 
 /* inode.c */
 extern struct workqueue_struct *nfsiod_workqueue;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index e0b870f..225b961 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -670,7 +670,7 @@ static void prune_dqcache(int count)
  * more memory
  */
 
-static int shrink_dqcache_memory(int nr, gfp_t gfp_mask)
+static int shrink_dqcache_memory(int nr, void *ctx, gfp_t gfp_mask)
 {
 	if (nr) {
 		spin_lock(&dq_list_lock);
diff --git a/fs/ubifs/shrinker.c b/fs/ubifs/shrinker.c
index 02feb59..a62dfe4 100644
--- a/fs/ubifs/shrinker.c
+++ b/fs/ubifs/shrinker.c
@@ -277,7 +277,7 @@ static int kick_a_thread(void)
 	return 0;
 }
 
-int ubifs_shrinker(int nr, gfp_t gfp_mask)
+int ubifs_shrinker(int nr, void *ctx, gfp_t gfp_mask)
 {
 	int freed, contention = 0;
 	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index b2d9763..a1fdb9c 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1574,7 +1574,7 @@ int ubifs_tnc_start_commit(struct ubifs_info *c, struct ubifs_zbranch *zroot);
 int ubifs_tnc_end_commit(struct ubifs_info *c);
 
 /* shrinker.c */
-int ubifs_shrinker(int nr_to_scan, gfp_t gfp_mask);
+int ubifs_shrinker(int nr_to_scan, void *ctx, gfp_t gfp_mask);
 
 /* commit.c */
 int ubifs_bg_thread(void *info);
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 74ccc70..4f5351f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -44,7 +44,7 @@
 
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
-STATIC int xfsbufd_wakeup(int, gfp_t);
+STATIC int xfsbufd_wakeup(int, void *, gfp_t);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
 static struct shrinker xfs_buf_shake = {
 	.shrink = xfsbufd_wakeup,
@@ -339,7 +339,7 @@ _xfs_buf_lookup_pages(
 					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
-			xfsbufd_wakeup(0, gfp_mask);
+			xfsbufd_wakeup(0, NULL, gfp_mask);
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto retry;
 		}
@@ -1759,6 +1759,7 @@ xfs_buf_runall_queues(
 STATIC int
 xfsbufd_wakeup(
 	int			priority,
+	void			*ctx,
 	gfp_t			mask)
 {
 	xfs_buftarg_t		*btp;
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 456b72e..40cf5c9 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -69,7 +69,7 @@ STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
 
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
-STATIC int	xfs_qm_shake(int, gfp_t);
+STATIC int	xfs_qm_shake(int, void *, gfp_t);
 
 static struct shrinker xfs_qm_shaker = {
 	.shrink = xfs_qm_shake,
@@ -2120,6 +2120,7 @@ xfs_qm_shake_freelist(
 STATIC int
 xfs_qm_shake(
 	int	nr_to_scan,
+	void	*ctx,
 	gfp_t	gfp_mask)
 {
 	int	ndqused, nfree, n;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3899395..b3fd387 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -989,7 +989,8 @@ void sync_mm_rss(struct task_struct *task, struct mm_struct *mm);
  * querying the cache size, so a fastpath for that case is appropriate.
  */
 struct shrinker {
-	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
+	int (*shrink)(int nr_to_scan, void *ctx, gfp_t gfp_mask);
+	void *ctx;	/* user callback context */
 	int seeks;	/* seeks to recreate an obj */
 
 	/* These are for internal use */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 79c8098..f293372 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -215,8 +215,9 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		unsigned long long delta;
 		unsigned long total_scan;
-		unsigned long max_pass = (*shrinker->shrink)(0, gfp_mask);
+		unsigned long max_pass;
 
+		max_pass = (*shrinker->shrink)(0, shrinker->ctx, gfp_mask);
 		delta = (4 * scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
@@ -244,8 +245,10 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			int shrink_ret;
 			int nr_before;
 
-			nr_before = (*shrinker->shrink)(0, gfp_mask);
-			shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
+			nr_before = (*shrinker->shrink)(0,
+						shrinker->ctx, gfp_mask);
+			shrink_ret = (*shrinker->shrink)(this_scan,
+						shrinker->ctx, gfp_mask);
 			if (shrink_ret == -1)
 				break;
 			if (shrink_ret < nr_before)

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-inode-reclaim-shrinker

xfs: add a shrinker to background inode reclaim

From: Dave Chinner <dchinner@redhat.com>

On low memory boxes or those with highmem, kernel can OOM before the
background reclaims inodes via xfssyncd. Add a shrinker to run inode
reclaim so that it inode reclaim is expedited when memory is low.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c   |    3 ++
 fs/xfs/linux-2.6/xfs_sync.c    |   71 ++++++++++++++++++++++++++++++++++++----
 fs/xfs/linux-2.6/xfs_sync.h    |    5 ++-
 fs/xfs/quota/xfs_qm_syscalls.c |    3 +-
 fs/xfs/xfs_ag.h                |    1 +
 fs/xfs/xfs_mount.h             |    1 +
 6 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 15bea67..aa11204 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1209,6 +1209,7 @@ xfs_fs_put_super(
 
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
+	xfs_inode_shrinker_unregister(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
 	xfs_dmops_put(mp);
@@ -1622,6 +1623,8 @@ xfs_fs_fill_super(
 	if (error)
 		goto fail_vnrele;
 
+	xfs_inode_shrinker_register(mp);
+
 	kfree(mtpt);
 	return 0;
 
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 5a4731e..a376a0d 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -95,7 +95,8 @@ xfs_inode_ag_walk(
 					   struct xfs_perag *pag, int flags),
 	int			flags,
 	int			tag,
-	int			exclusive)
+	int			exclusive,
+	int			*nr_to_scan)
 {
 	uint32_t		first_index;
 	int			last_error = 0;
@@ -134,7 +135,7 @@ restart:
 		if (error == EFSCORRUPTED)
 			break;
 
-	} while (1);
+	} while ((*nr_to_scan)--);
 
 	if (skipped) {
 		delay(1);
@@ -150,11 +151,16 @@ xfs_inode_ag_iterator(
 					   struct xfs_perag *pag, int flags),
 	int			flags,
 	int			tag,
-	int			exclusive)
+	int			exclusive,
+	int			nr_to_scan)
 {
 	int			error = 0;
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
+	int			nr = nr_to_scan;
+
+	if (!nr)
+		nr = INT_MAX;
 
 	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
 		struct xfs_perag	*pag;
@@ -165,7 +171,7 @@ xfs_inode_ag_iterator(
 			continue;
 		}
 		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag,
-						exclusive);
+						exclusive, &nr);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -291,7 +297,7 @@ xfs_sync_data(
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
 	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags,
-				      XFS_ICI_NO_TAG, 0);
+				      XFS_ICI_NO_TAG, 0, 0);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -310,7 +316,7 @@ xfs_sync_attr(
 	ASSERT((flags & ~SYNC_WAIT) == 0);
 
 	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags,
-				     XFS_ICI_NO_TAG, 0);
+				     XFS_ICI_NO_TAG, 0, 0);
 }
 
 STATIC int
@@ -673,6 +679,7 @@ __xfs_inode_set_reclaim_tag(
 	radix_tree_tag_set(&pag->pag_ici_root,
 			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
 			   XFS_ICI_RECLAIM_TAG);
+	pag->pag_ici_reclaimable++;
 }
 
 /*
@@ -705,6 +712,7 @@ __xfs_inode_clear_reclaim_tag(
 {
 	radix_tree_tag_clear(&pag->pag_ici_root,
 			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+	pag->pag_ici_reclaimable--;
 }
 
 /*
@@ -854,5 +862,54 @@ xfs_reclaim_inodes(
 	int		mode)
 {
 	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode, mode,
-					XFS_ICI_RECLAIM_TAG, 1);
+					XFS_ICI_RECLAIM_TAG, 1, 0);
+}
+
+static int
+xfs_reclaim_inode_shrink(
+	int	nr_to_scan,
+	void	*ctx,
+	gfp_t	gfp_mask)
+{
+	struct xfs_mount *mp = ctx;
+	xfs_agnumber_t	ag;
+	int		reclaimable = 0;
+
+	if (nr_to_scan) {
+		if (!(gfp_mask & __GFP_FS))
+			return -1;
+
+		xfs_inode_ag_iterator(mp, xfs_reclaim_inode, 0,
+					XFS_ICI_RECLAIM_TAG, 1, nr_to_scan);
+	}
+
+	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, ag);
+		if (!pag->pag_ici_init) {
+			xfs_perag_put(pag);
+			continue;
+		}
+		reclaimable += pag->pag_ici_reclaimable;
+		xfs_perag_put(pag);
+	}
+	return reclaimable;
+}
+
+void
+xfs_inode_shrinker_register(
+	struct xfs_mount	*mp)
+{
+	mp->m_inode_shrink.shrink = xfs_reclaim_inode_shrink;
+	mp->m_inode_shrink.ctx = mp;
+	mp->m_inode_shrink.seeks = DEFAULT_SEEKS;
+	register_shrinker(&mp->m_inode_shrink);
+}
+
+void
+xfs_inode_shrinker_unregister(
+	struct xfs_mount	*mp)
+{
+	unregister_shrinker(&mp->m_inode_shrink);
 }
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index d480c34..e6c631b 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -53,6 +53,9 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags, int tag, int write_lock);
+	int flags, int tag, int write_lock, int nr_to_scan);
+
+void xfs_inode_shrinker_register(struct xfs_mount *mp);
+void xfs_inode_shrinker_unregister(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index cda8ef4..79dbd30 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -891,7 +891,8 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, XFS_ICI_NO_TAG, 0);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags,
+				XFS_ICI_NO_TAG, 0, 0);
 }
 
 /*------------------------------------------------------------------------*/
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index b1a5a1f..abb8222 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -223,6 +223,7 @@ typedef struct xfs_perag {
 	int		pag_ici_init;	/* incore inode cache initialised */
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
+	int		pag_ici_reclaimable;	/* reclaimable inodes */
 #endif
 	int		pagb_count;	/* pagb slots in use */
 	xfs_perag_busy_t pagb_list[XFS_PAGB_NUM_SLOTS];	/* unstable blocks */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4fa0bc7..1fe7662 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -259,6 +259,7 @@ typedef struct xfs_mount {
 	wait_queue_head_t	m_wait_single_sync_task;
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
+	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
 } xfs_mount_t;
 
 /*

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--45Z9DzgjV8m4Oswq--
