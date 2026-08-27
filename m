Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09033BD62F
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112178; cv=none; b=WhPx0lnBJhUd1ICiGkqPSmoozTQQuxHfl+ICsiAJCZLvq12lhg/tx9aTM6lZexY+iovHStzBnKXXidpSMHnSATomW8LpximB+EVp8z46QvrscQPnqYDh1XDqL0E10Xi1eXe6yWbWY1v3XPxbnPettccCbebfYOX8+OjPIK97NO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112178; c=relaxed/simple;
	bh=3Py+QN9YwxwcuZtm1BcZ1HLjWd0InFscTDg3YuC2xvA=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=FGOUmTARm3p4hOyj3wPynX3ZAoUjgkp7jjr6yKsMoMx/NMNg8f5nUV2UitmvUEghfKREMNaCi2EAPUuI9rFEEzHVO4wJRtEsTdFlGN50yXGtJOux2RzDvYmw5Xdxu+g3/4CEIjsZq5+X1EYWm4MGEZ50WJvaaRmWbjevX8MZrqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=aAtjrEF6; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="aAtjrEF6"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04X5f5wz6mF
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112172; bh=sljHoVBkzXfwK+ZXlLsMhmcyNBtw2ADlQlYTGQ7yuPc=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=aAtjrEF6LbaMiYqYXR3KlwU2O6TM87JkjmgkWSXzYwCkfXWR0Y04+K0jhFJqg6pI/
	 ryEyn9lSlZaZ/sLSPOhbjBj4sCtKHfpKr+wDOvPM0h6ob/mfM7/fpmwkpMi1lfQ24I
	 nSgDZ7nG8w99g/1DKXhDW5Lqj/ehGcRsU8IT4OJRNqY4Xkr00G2Sg1r0cAH1PtPsL3
	 UAm5VKe4btAwJhQ7eUdxY4Zk3nGcjB+dc9xsY4hJOlXPD8T+pOY0GWMgP4Xhc+7QOG
	 FBtJJonVihw1qqMdK3XMCyBi+mNo2Ya+ihnBNohnDCj+YbJlBnPXkG+SuAVxg7uIas
	 fQPvaiPHSu8BQ==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04W20jQz9KVLH
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:31 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:31 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <a4fa78a72c122033a9c852116ddaef152c80df4a.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Wed, 26 Aug 2026 22:24:54 -0700
Subject: [PATCH 7/9] libxlog: build the imported kernel code
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Wire the imported sources into the build and give them the userspace
they expect.

The kernel facilities they refer to - atomics, spinlocks, completions,
allocation wrappers, hlists, trace points - are provided rather than
edited out, so the sources stay verbatim and future resyncs stay
mechanical.  They live in a new kernel_compat.h, with libxfs's platform
header extended where a shim has to sit beside existing userspace
definitions.

The imported sources are compiled into libxfs rather than into libxlog,
via vpath, even though they live in libxlog/.  They have to be: libxfs
code refers to them - xfs_defer.c needs the deferred operation types,
xfs_attr.c needs xfs_attr_defer_add(), xfs_trans_resv.c needs the log
space helpers - while they in turn refer to libxfs.  In the kernel both
halves are one module and the question does not arise.  Here, two
archives with references in both directions cannot be linked in any
order, and libtool offers no way to express a link group.  One archive
is the only arrangement that works.

libxfs's own log item layer is replaced by the kernel's.  That removes
defer_item.c, whose intent handling the imported items now do properly,
and aligns the log item and mount structures with the kernel so the
imported code sees the fields it expects.  libxlog adopts the kernel's
struct xlog for the same reason; xfs_repair and the logprint and db
callers follow it.

No behavioural change: xfs_repair still refuses a dirty log.
---
 db/logformat.c           |   6 +-
 include/Makefile         |   1 +
 include/atomic.h         |   2 +
 include/builddefs.in     |   1 +
 include/hlist.h          |  39 +-
 include/kmem.h           |  19 +
 include/libxfs.h         |   2 +-
 include/libxlog.h        |  39 +-
 include/list.h           |   7 +
 include/platform_defs.h  |  11 +-
 include/spinlock.h       |  18 +-
 include/xfs_inode.h      |   3 +
 include/xfs_mount.h      |   8 +-
 include/xfs_trace.h      |  30 ++
 include/xfs_trans.h      | 118 +++--
 libfrog/bitmask.h        |  17 +-
 libfrog/div64.h          |   7 +
 libxfs/Makefile          |  19 +-
 libxfs/defer_item.c      | 995 ---------------------------------------
 libxfs/defer_item.h      |  56 ---
 libxfs/init.c            |  73 +++
 libxfs/inode.c           |  43 ++
 libxfs/libxfs_io.h       |   3 +
 libxfs/logitem.c         | 204 +++++++-
 libxfs/rdwr.c            | 158 ++++++-
 libxfs/trans.c           |  34 +-
 libxfs/util.c            |   8 +-
 libxfs/xfs_alloc.c       |   2 +-
 libxfs/xfs_attr.c        |   2 +-
 libxfs/xfs_bmap.c        |   2 +-
 libxfs/xfs_defer.c       |   4 +
 libxfs/xfs_exchmaps.c    |   2 +-
 libxfs/xfs_ialloc.c      |   3 +
 libxfs/xfs_parent.c      |   2 +-
 libxfs/xfs_platform.h    |  19 +-
 libxfs/xfs_refcount.c    |   2 +-
 libxfs/xfs_rmap.c        |   2 +-
 libxfs/xfs_trans_resv.c  |   7 +-
 libxlog/Makefile         |  12 +
 libxlog/logscan.c        |  31 +-
 libxlog/util.c           |  34 +-
 logprint/log_misc.c      |   4 +-
 logprint/log_print_all.c |   2 +-
 logprint/logprint.c      |   2 +-
 logprint/logprint.h      |   2 +-
 repair/phase2.c          |   4 +-
 repair/xfs_repair.c      |   2 +-
 47 files changed, 857 insertions(+), 1204 deletions(-)
 delete mode 100644 libxfs/defer_item.c
 delete mode 100644 libxfs/defer_item.h

diff --git a/db/logformat.c b/db/logformat.c
index aba5b0b1..02da0c56 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -9,6 +9,10 @@
 #include "init.h"
 #include "output.h"
 #include "libxlog.h"
+#include "xfs_extfree_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
+#include "xfs_bmap_item.h"
 #include "logformat.h"
 
 #define MAX_LSUNIT	256 * 1024	/* max log buf. size */
@@ -60,7 +64,7 @@ logformat_f(int argc, char **argv)
 	 */
 	memset(mp->m_log, 0, sizeof(struct xlog));
 	mp->m_log->l_mp = mp;
-	mp->m_log->l_dev = mp->m_logdev_targp;
+	mp->m_log->l_targ = mp->m_logdev_targp;
 	mp->m_log->l_logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	mp->m_log->l_logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	mp->m_log->l_sectBBsize = BBSIZE;
diff --git a/include/Makefile b/include/Makefile
index f7c40a5c..fd57fb17 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -13,6 +13,7 @@ LIBHFILES = libxfs.h \
 	bitops.h \
 	cache.h \
 	hlist.h \
+	kernel_compat.h \
 	kmem.h \
 	list.h \
 	parent.h \
diff --git a/include/atomic.h b/include/atomic.h
index 3b7eabd0..db3aa370 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -119,6 +119,8 @@ atomic64_set(atomic64_t *a, int64_t v)
 #endif /* HAVE_URCU_ATOMIC64 */
 
 #define __smp_mb()		cmm_smp_mb()
+#define smp_rmb()		cmm_smp_rmb()
+#define smp_wmb()		cmm_smp_wmb()
 
 /* from compiler_types.h */
 /*
diff --git a/include/builddefs.in b/include/builddefs.in
index 3b52d1af..c4cd7999 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -180,6 +180,7 @@ endif
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs \
+	  -I$(TOPDIR)/libxlog \
 	  -I$(TOPDIR)
 
 ifeq ($(ENABLE_GETTEXT),yes)
diff --git a/include/hlist.h b/include/hlist.h
index a8d58e79..082490c0 100644
--- a/include/hlist.h
+++ b/include/hlist.h
@@ -53,10 +53,41 @@ static inline void hlist_del(struct hlist_node *n)
 #define hlist_for_each(pos, head) \
 	for (pos = (head)->first; pos; pos = pos->next)
 
-#define hlist_for_each_entry(tpos, pos, head, member)                    \
-        for (pos = (head)->first;                                        \
-	     pos && ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+/*
+ * The iteration macros below are the kernel's current (3 argument) form,
+ * which the xfs sources libxfs carries expect.
+ */
+#define hlist_entry_safe(ptr, type, member) \
+	({ typeof(ptr) ____ptr = (ptr); \
+	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
+	})
+
+#define hlist_for_each_entry(pos, head, member)				\
+	for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
+	     pos;							\
+	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
+
+#define hlist_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
+	     pos && ({ n = pos->member.next; 1; });			\
+	     pos = hlist_entry_safe(n, typeof(*pos), member))
+
+static inline void INIT_HLIST_HEAD(struct hlist_head *h)
+{
+	h->first = NULL;
+}
+
+static inline int hlist_unhashed(const struct hlist_node *h)
+{
+	return !h->pprev;
+}
 
+static inline void hlist_del_init(struct hlist_node *n)
+{
+	if (!hlist_unhashed(n)) {
+		__hlist_del(n);
+		INIT_HLIST_NODE(n);
+	}
+}
 
 #endif	/* __LIST_H__ */
diff --git a/include/kmem.h b/include/kmem.h
index 2c276e92..10eaf10a 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -26,6 +26,9 @@ typedef unsigned int __bitwise gfp_t;
 #define __GFP_NOFAIL	((__force gfp_t)0)
 #define __GFP_NOLOCKDEP	((__force gfp_t)0)
 #define __GFP_RETRY_MAYFAIL	((__force gfp_t)0)
+#define __GFP_DIRECT_RECLAIM	((__force gfp_t)0)
+#define __GFP_NOWARN	((__force gfp_t)0)
+#define __GFP_NORETRY	((__force gfp_t)0)
 
 #define __GFP_ZERO	((__force gfp_t)1)
 
@@ -53,11 +56,21 @@ kmem_cache_free(struct kmem_cache *cache, void *ptr)
 extern void	*kvmalloc(size_t, gfp_t);
 extern void	*krealloc(void *, size_t, int);
 
+static inline void *kvrealloc(void *ptr, size_t size, gfp_t flags)
+{
+	return krealloc(ptr, size, flags);
+}
+
 static inline void *kmalloc(size_t size, gfp_t flags)
 {
 	return kvmalloc(size, flags);
 }
 
+static inline void *vmalloc(size_t size)
+{
+	return kvmalloc(size, 0);
+}
+
 #define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
 #define kvzalloc(size, gfp)	kzalloc((size), (gfp))
 
@@ -111,6 +124,12 @@ static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
 #define kmalloc_obj(VAR_OR_TYPE, ...) \
 	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), 1)
 
+/* ...and the array forms, where the count is given explicitly. */
+#define kzalloc_objs(P, COUNT, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), COUNT)
+#define kmalloc_objs(VAR_OR_TYPE, COUNT, ...) \
+	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), COUNT)
+
 static inline void kfree(const void *ptr)
 {
 	free((void *)ptr);
diff --git a/include/libxfs.h b/include/libxfs.h
index 68d1f351..b507d47e 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -29,6 +29,7 @@
 #include "libfrog/util.h"
 #include "atomic.h"
 #include "spinlock.h"
+#include "kernel_compat.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
@@ -103,7 +104,6 @@ struct iomap;
 #include "xfs_rtbitmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_ag_resv.h"
-#include "defer_item.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/libxlog.h b/include/libxlog.h
index cf39e740..b596d2bc 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -6,31 +6,12 @@
 #define LIBXLOG_H
 
 /*
- * define the userlevel xlog_t to be the subset of the kernel's
- * xlog_t that we actually need to get our work done, avoiding
- * the need to define any exotic kernel types in userland.
+ * struct xlog is the kernel's, imported into libxfs, so that the log
+ * recovery sources libxfs carries and the tools that inspect a log agree
+ * on its layout.  It used to be a hand-written subset here, which is why
+ * a few of the fields below are referred to by their old names in places.
  */
-struct xlog {
-	atomic64_t	l_tail_lsn;     /* lsn of 1st LR w/ unflush buffers */
-	atomic64_t	l_last_sync_lsn;/* lsn of last LR on disk */
-	xfs_mount_t	*l_mp;	        /* mount point */
-	struct xfs_buftarg *l_dev;	        /* dev_t of log */
-	xfs_daddr_t	l_logBBstart;   /* start block of log */
-	int		l_logBBsize;    /* size of log in 512 byte chunks */
-	int		l_curr_cycle;   /* Cycle number of log writes */
-	int		l_prev_cycle;   /* Cycle # b4 last block increment */
-	int		l_curr_block;   /* current logical block of log */
-	int		l_prev_block;   /* previous logical block of log */
-	int		l_iclog_size;	 /* size of log in bytes */
-	int		l_iclog_size_log;/* log power size of log */
-	int		l_iclog_bufs;	 /* number of iclog buffers */
-	atomic64_t	l_grant_reserve_head;
-	atomic64_t	l_grant_write_head;
-	uint		l_sectbb_log;   /* log2 of sector size in bbs */
-	uint		l_sectbb_mask;  /* sector size (in BBs)
-					 * alignment mask */
-	int		l_sectBBsize;   /* size of log sector in 512 byte chunks */
-};
+#include "xfs_log_priv.h"
 
 #include "xfs_log_recover.h"
 
@@ -71,6 +52,15 @@ extern int	print_record_header;
 void xlog_init(struct xfs_mount *mp, struct xlog *log);
 int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log);
 
+/*
+ * The kernel used to keep the LSN of the last log record on disk in
+ * struct xlog as l_last_sync_lsn, and dropped it once the AIL became the
+ * authority on that.  xfs_repair still wants it, to seed the maximum
+ * metadata LSN it will accept, so libxlog tracks it here rather than
+ * carrying a field the kernel no longer has.
+ */
+extern xfs_lsn_t	xlog_last_sync_lsn;
+
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
 extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
 				struct xfs_buf *bp, char **offset);
@@ -84,7 +74,6 @@ extern int	xlog_find_cycle_start(struct xlog *log, struct xfs_buf *bp,
 extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
 				xfs_daddr_t *tail_blk);
 
-extern int	xlog_recover(struct xlog *log, int readonly);
 extern void	xlog_recover_print_data(char *p, int len);
 extern void	xlog_recover_print_logitem(struct xlog_recover_item *item);
 extern void	xlog_recover_print_trans_head(struct xlog_recover *tr);
diff --git a/include/list.h b/include/list.h
index 852a355a..436d41df 100644
--- a/include/list.h
+++ b/include/list.h
@@ -177,6 +177,13 @@ void list_sort(void *priv, struct list_head *head, list_cmp_func_t cmp);
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 
+static inline void list_splice_tail(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head->prev, head);
+}
+
 /**
  * list_splice_tail_init - join two lists and reinitialise the emptied list
  * @list: the new list to add.
diff --git a/include/platform_defs.h b/include/platform_defs.h
index 5d1bfb1b..4fa5bb1b 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -26,8 +26,15 @@
 #include <urcu.h>
 #include <linux/blkzoned.h>
 
-/* long and pointer must be either 32 bit or 64 bit */
-#define BITS_PER_LONG (sizeof(long) * CHAR_BIT)
+/*
+ * long and pointer must be either 32 bit or 64 bit.
+ *
+ * Spelled with the compiler's predefined width macros rather than
+ * sizeof(), because kernel headers test this in the preprocessor
+ * (xfs_trans_priv.h has "#if BITS_PER_LONG != 64") and sizeof() is not
+ * a preprocessor-evaluable constant.
+ */
+#define BITS_PER_LONG (__SIZEOF_LONG__ * __CHAR_BIT__)
 
 typedef unsigned short umode_t;
 
diff --git a/include/spinlock.h b/include/spinlock.h
index 73bd8c07..75d1cc1c 100644
--- a/include/spinlock.h
+++ b/include/spinlock.h
@@ -15,12 +15,20 @@
  * Hence we know it works.
  */
 
-typedef pthread_mutex_t	spinlock_t;
+/*
+ * In the kernel spinlock_t is struct spinlock, and xfs code refers to both
+ * spellings.  Keep the same shape here so kernel sources build unmodified.
+ */
+struct spinlock {
+	pthread_mutex_t	lock;
+};
+
+typedef struct spinlock	spinlock_t;
 
-#define spin_lock_init(l)	pthread_mutex_init(l, NULL)
-#define spin_lock(l)		pthread_mutex_lock(l)
-#define spin_trylock(l)		(pthread_mutex_trylock(l) != EBUSY)
-#define spin_unlock(l)		pthread_mutex_unlock(l)
+#define spin_lock_init(l)	pthread_mutex_init(&(l)->lock, NULL)
+#define spin_lock(l)		pthread_mutex_lock(&(l)->lock)
+#define spin_trylock(l)		(pthread_mutex_trylock(&(l)->lock) != EBUSY)
+#define spin_unlock(l)		pthread_mutex_unlock(&(l)->lock)
 
 #define mutex_init(l)		pthread_mutex_init(l, NULL)
 #define mutex_lock(l)		pthread_mutex_lock(l)
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 61d4d285..b5292c44 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -431,6 +431,9 @@ int libxfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
 		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
 
 /* Inode Cache Interfaces */
+struct xfs_inode *xfs_inode_alloc(struct xfs_mount *mp, xfs_ino_t ino);
+void		xfs_inode_free(struct xfs_inode *ip);
+
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
 extern void	libxfs_irele(struct xfs_inode *ip);
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 5a714333..8d18f2d9 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -171,6 +171,11 @@ typedef struct xfs_mount {
 	 * if warranted.
 	 */
 	struct xlog		*m_log;		/* log specific stuff */
+	struct xfs_ail		*m_ail;		/* fs active log item list */
+	struct xfs_buf		*m_rtsb_bp;	/* realtime superblock */
+	struct xfs_buf		*m_sb_bp;	/* superblock buffer */
+	char			*m_logname;	/* external log device name */
+	int			m_logbsize;	/* size of each log buffer */
 
         /*
 	 * Global count of allocation btree blocks in use across all AGs. Only
@@ -323,6 +328,7 @@ __XFS_UNSUPP_FEAT(grpid)
 #define XFS_OPSTATE_REPORT_CORRUPTION	2	/* report buffer corruption? */
 #define XFS_OPSTATE_PERAG_DATA_LOADED	3	/* per-AG data initialized? */
 #define XFS_OPSTATE_RTGROUP_DATA_LOADED	4	/* rtgroup data initialized? */
+#define XFS_OPSTATE_SHUTDOWN		5	/* stop accepting metadata writes */
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -349,6 +355,7 @@ __XFS_IS_OPSTATE(debugger, DEBUGGER)
 __XFS_IS_OPSTATE(reporting_corruption, REPORT_CORRUPTION)
 __XFS_IS_OPSTATE(perag_data_loaded, PERAG_DATA_LOADED)
 __XFS_IS_OPSTATE(rtgroup_data_loaded, RTGROUP_DATA_LOADED)
+__XFS_IS_OPSTATE(shutdown, SHUTDOWN)
 
 #define __XFS_UNSUPP_OPSTATE(name) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -356,7 +363,6 @@ static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
 	return false; \
 }
 __XFS_UNSUPP_OPSTATE(readonly)
-__XFS_UNSUPP_OPSTATE(shutdown)
 
 static inline int64_t xfs_sum_freecounter(struct xfs_mount *mp,
 		enum xfs_free_counter ctr)
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index be9183fc..938b60e5 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -13,6 +13,36 @@
 #define trace_xfbtree_trans_cancel_buf(...)	((void) 0)
 #define trace_xfbtree_trans_commit_buf(...)	((void) 0)
 
+#define trace_xfs_exchmaps_recover(...)	((void) 0)
+#define trace_xfs_log_recover_buf_cancel(...)	((void) 0)
+#define trace_xfs_log_recover_buf_cancel_add(...)	((void) 0)
+#define trace_xfs_log_recover_buf_cancel_ref_inc(...)	((void) 0)
+#define trace_xfs_log_recover_buf_dquot_buf(...)	((void) 0)
+#define trace_xfs_log_recover_buf_inode_buf(...)	((void) 0)
+#define trace_xfs_log_recover_buf_not_cancel(...)	((void) 0)
+#define trace_xfs_log_recover_buf_recover(...)	((void) 0)
+#define trace_xfs_log_recover_buf_reg_buf(...)	((void) 0)
+#define trace_xfs_log_recover_buf_skip(...)	((void) 0)
+#define trace_xfs_log_recover_inode_cancel(...)	((void) 0)
+#define trace_xfs_log_recover_inode_recover(...)	((void) 0)
+#define trace_xfs_log_recover_inode_skip(...)	((void) 0)
+#define trace_xfs_log_recover_item_recover(...)	((void) 0)
+#define trace_xfs_log_recover_item_reorder_head(...)	((void) 0)
+#define trace_xfs_log_recover_item_reorder_tail(...)	((void) 0)
+#define trace_xfs_log_recover_record(...)	((void) 0)
+#define trace_xfs_agfl_free_deferred(...)		((void) 0)
+#define trace_xfs_extent_free_deferred(...)		((void) 0)
+#define trace_xfs_log_recover_icreate_cancel(...)	((void) 0)
+#define trace_xfs_log_recover_icreate_recover(...)	((void) 0)
+#define trace_xfs_log_recover(...)		((void) 0)
+#define trace_xfs_ail_delete(...)		((void) 0)
+#define trace_xfs_ail_flushing(a,b,c,d)	((void)(a),(void)(b),(void)(c),(void)(d))
+#define trace_xfs_ail_insert(...)		((void) 0)
+#define trace_xfs_ail_locked(a,b,c,d)	((void)(a),(void)(b),(void)(c),(void)(d))
+#define trace_xfs_ail_move(...)			((void) 0)
+#define trace_xfs_ail_pinned(a,b,c,d)	((void)(a),(void)(b),(void)(c),(void)(d))
+#define trace_xfs_ail_push(...)			((void) 0)
+#define trace_xfs_log_assign_tail_lsn(...)	((void) 0)
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
 #define trace_xfs_agfl_free_defer(...)		((void) 0)
 #define trace_xfs_alloc_cur_check(...)		((void) 0)
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d4b546a0..1fe0fd2c 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -11,53 +11,93 @@ struct xfs_mount;
 struct xfs_buftarg;
 struct xfs_buf;
 struct xfs_buf_map;
+struct xfs_ail;
+struct xlog;
+struct xlog_format_buf;
 
 /*
  * Userspace Transaction interface
  */
 
+/*
+ * struct xfs_item_ops, struct xfs_log_item and the XFS_LI_ and XFS_ITEM_
+ * constants below are the kernel's, so that the log item and AIL code
+ * libxfs carries agrees with the kernel on their layout and meaning.
+ * Userspace implements only a subset of the operations; the unimplemented
+ * members are simply left NULL.
+ */
 struct xfs_item_ops {
+	unsigned flags;
+	void (*iop_size)(struct xfs_log_item *, int *, int *);
+	void (*iop_format)(struct xfs_log_item *lip,
+			struct xlog_format_buf *lfb);
+	void (*iop_pin)(struct xfs_log_item *);
+	void (*iop_unpin)(struct xfs_log_item *, int remove);
 	uint64_t (*iop_sort)(struct xfs_log_item *lip);
 	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
+	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
+	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
+	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
+	void (*iop_release)(struct xfs_log_item *);
+	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
+	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
 };
 
-typedef struct xfs_log_item {
+/* xfs_item_ops.flags */
+#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
+#define XFS_ITEM_INTENT			(1 << 1)
+#define XFS_ITEM_INTENT_DONE		(1 << 2)
+
+struct xfs_log_item {
+	struct list_head		li_ail;		/* AIL pointers */
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
-	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xlog			*li_log;
+	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	unsigned long			li_flags;	/* misc flags */
 	struct xfs_buf			*li_buf;	/* real buffer pointer */
 	struct list_head		li_bio_list;	/* buffer item list */
 	const struct xfs_item_ops	*li_ops;	/* function list */
-} xfs_log_item_t;
-
-#define XFS_LI_DIRTY	3	/* log item dirty in transaction */
-
-struct xfs_inode_log_item {
-	xfs_log_item_t		ili_item;		/* common portion */
-	struct xfs_inode	*ili_inode;		/* inode pointer */
-	unsigned short		ili_lock_flags;		/* lock flags */
-	unsigned int		ili_dirty_flags;	/* dirty in current tx */
-	unsigned int		ili_last_fields;	/* fields when flushed*/
-	unsigned int		ili_fields;		/* fields to be logged */
-	unsigned int		ili_fsync_fields;	/* ignored by userspace */
-	spinlock_t		ili_lock;
+
+	/* delayed logging */
+	struct list_head		li_cil;		/* CIL pointers */
+	struct xfs_log_vec		*li_lv;		/* active log vector */
+	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
+	xfs_csn_t			li_seq;		/* CIL commit seq */
+	uint32_t			li_order_id;	/* CIL commit order */
 };
 
-typedef struct xfs_buf_log_item {
-	xfs_log_item_t		bli_item;	/* common item structure */
-	struct xfs_buf		*bli_buf;	/* real buffer pointer */
-	unsigned int		bli_flags;	/* misc flags */
-	unsigned int		bli_recur;	/* recursion count */
-	struct xfs_buf_log_format	__bli_format;	/* in-log header */
-} xfs_buf_log_item_t;
+typedef struct xfs_log_item	xfs_log_item_t;
+
+int		xfs_trans_ail_init(struct xfs_mount *mp);
+void		xfs_trans_ail_destroy(struct xfs_mount *mp);
+
+/* li_flags bit values */
+#define	XFS_LI_IN_AIL	0
+#define	XFS_LI_ABORTED	1
+#define	XFS_LI_FAILED	2
+#define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
+#define	XFS_LI_WHITEOUT	4
+#define	XFS_LI_FLUSHING	5
+
+/* return codes from iop_push() */
+#define XFS_ITEM_SUCCESS	0
+#define XFS_ITEM_PINNED		1
+#define XFS_ITEM_LOCKED		2
+#define XFS_ITEM_FLUSHING	3
+
+/*
+ * struct xfs_inode_log_item, struct xfs_buf_log_item and the XFS_BLI_
+ * flags are the kernel's.  Note that libxfs previously numbered the
+ * XFS_BLI_ flags differently - DIRTY and HOLD were swapped - which was
+ * harmless only because they live in memory and never on disk.
+ */
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
+#include "xfs_buf_item.h"
 
-#define XFS_BLI_DIRTY			(1<<0)
-#define XFS_BLI_HOLD			(1<<1)
-#define XFS_BLI_STALE			(1<<2)
-#define XFS_BLI_INODE_ALLOC_BUF		(1<<3)
-#define XFS_BLI_ORDERED			(1<<4)
+typedef struct xfs_buf_log_item	xfs_buf_log_item_t;
 
 typedef struct xfs_trans {
 	unsigned int		t_log_res;	/* amt of log space resvd */
@@ -158,28 +198,8 @@ libxfs_trans_read_buf(
 	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
 }
 
-#define xfs_log_item_in_current_chkpt(lip)	(false)
-
-/* Contorted mess to make gcc shut up about unused vars. */
-#define xfs_ail_get_push_target(ail)    \
-		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
-
-/* from xfs_log.h */
-/*
- * By comparing each component, we don't have to worry about extra
- * endian issues in treating two 32 bit numbers as one 64 bit number
- */
-static inline xfs_lsn_t _lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
-{
-	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
-		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
-
-	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
-		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
-
-	return 0;
-}
 
-#define XFS_LSN_CMP(a, b)			_lsn_cmp(a, b)
+/* _lsn_cmp() and XFS_LSN_CMP() now come from the kernel's xfs_log.h. */
+#include "xfs_log.h"
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libfrog/bitmask.h b/libfrog/bitmask.h
index 47e39a1e..21dc0dc0 100644
--- a/libfrog/bitmask.h
+++ b/libfrog/bitmask.h
@@ -9,7 +9,7 @@
 #define BIT_MASK(nr)	(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)	((nr) / BITS_PER_LONG)
 
-static inline void set_bit(int nr, volatile unsigned long *addr)
+static inline void set_bit(int nr, volatile void *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -17,7 +17,7 @@ static inline void set_bit(int nr, volatile unsigned long *addr)
 	*p  |= mask;
 }
 
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static inline void clear_bit(int nr, volatile void *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -25,7 +25,7 @@ static inline void clear_bit(int nr, volatile unsigned long *addr)
 	*p &= ~mask;
 }
 
-static inline int test_bit(int nr, const volatile unsigned long *addr)
+static inline int test_bit(int nr, const volatile void *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -34,7 +34,7 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
 }
 
 /* Sets and returns original value of the bit */
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit(int nr, volatile void *addr)
 {
 	if (test_bit(nr, addr))
 		return 1;
@@ -42,6 +42,15 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 	return 0;
 }
 
+/* Clears and returns original value of the bit */
+static inline int test_and_clear_bit(int nr, volatile void *addr)
+{
+	if (!test_bit(nr, addr))
+		return 0;
+	clear_bit(nr, addr);
+	return 1;
+}
+
 /* Get high bit set out of 64-bit argument, -1 if none set */
 static inline int xfrog_highbit64(uint64_t v)
 {
diff --git a/libfrog/div64.h b/libfrog/div64.h
index 4b0d4c3b..2f18d995 100644
--- a/libfrog/div64.h
+++ b/libfrog/div64.h
@@ -29,6 +29,13 @@ static inline int __do_div(unsigned long long *n, unsigned base)
  * This is commonly provided by 32bit archs to provide an optimized 64bit
  * divide.
  */
+static inline int64_t
+div_s64_rem(int64_t dividend, int32_t divisor, int32_t *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
 static inline uint64_t
 div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
 {
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 83c8592e..1ca6ad82 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -20,7 +20,6 @@ PKGHFILES = xfs_fs.h \
 	xfs_log_format.h
 
 HFILES = \
-	defer_item.h \
 	libxfs_io.h \
 	libxfs_api_defs.h \
 	listxattr.h \
@@ -74,9 +73,25 @@ HFILES = \
 	xfs_dir2_priv.h \
 	xfs_zones.h
 
+# The kernel keeps log recovery, the log items and the AIL at the top level
+# of fs/xfs; this tree keeps them in libxlog/.  libxfs code refers to them, so
+# they are compiled into this library rather than a separate one.
+vpath %.c $(TOPDIR)/libxlog
+
 CFILES = buf_mem.c \
+	xfs_bmap_item.c \
+	xfs_buf_item_recover.c \
+	xfs_attr_item.c \
+	xfs_dquot_item_recover.c \
+	xfs_exchmaps_item.c \
+	xfs_extfree_item.c \
+	xfs_log_recover.c \
+	xfs_inode_item_recover.c \
+	xfs_icreate_item.c \
+	xfs_refcount_item.c \
+	xfs_rmap_item.c \
+	xfs_trans_ail.c \
 	cache.c \
-	defer_item.c \
 	init.c \
 	inode.c \
 	iunlink.c \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
deleted file mode 100644
index 4fc2c74a..00000000
--- a/libxfs/defer_item.c
+++ /dev/null
@@ -1,995 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (C) 2016 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
- */
-#include "xfs_platform.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_da_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_bit.h"
-#include "xfs_sb.h"
-#include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_trans.h"
-#include "xfs_bmap.h"
-#include "xfs_alloc.h"
-#include "xfs_rmap.h"
-#include "xfs_refcount.h"
-#include "xfs_bmap.h"
-#include "xfs_inode.h"
-#include "xfs_da_btree.h"
-#include "xfs_attr.h"
-#include "libxfs.h"
-#include "defer_item.h"
-#include "xfs_ag.h"
-#include "xfs_exchmaps.h"
-#include "defer_item.h"
-#include "xfs_group.h"
-#include "xfs_rtgroup.h"
-
-/* Dummy defer item ops, since we don't do logging. */
-
-/* Extent Freeing */
-
-static inline struct xfs_extent_free_item *xefi_entry(const struct list_head *e)
-{
-	return list_entry(e, struct xfs_extent_free_item, xefi_list);
-}
-
-/* Sort bmap items by AG. */
-static int
-xfs_extent_free_diff_items(
-	void				*priv,
-	const struct list_head		*a,
-	const struct list_head		*b)
-{
-	struct xfs_extent_free_item	*ra = xefi_entry(a);
-	struct xfs_extent_free_item	*rb = xefi_entry(b);
-
-	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
-}
-
-/* Get an EFI. */
-static struct xfs_log_item *
-xfs_extent_free_create_intent(
-	struct xfs_trans		*tp,
-	struct list_head		*items,
-	unsigned int			count,
-	bool				sort)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-
-	if (sort)
-		list_sort(mp, items, xfs_extent_free_diff_items);
-	return NULL;
-}
-
-/* Get an EFD so we can process all the free extents. */
-static struct xfs_log_item *
-xfs_extent_free_create_done(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*intent,
-	unsigned int			count)
-{
-	return NULL;
-}
-
-static inline const struct xfs_defer_op_type *
-xefi_ops(
-	struct xfs_extent_free_item	*xefi)
-{
-	if (xfs_efi_is_realtime(xefi))
-		return &xfs_rtextent_free_defer_type;
-	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
-		return &xfs_agfl_free_defer_type;
-	return &xfs_extent_free_defer_type;
-}
-
-/* Add this deferred EFI to the transaction. */
-void
-xfs_extent_free_defer_add(
-	struct xfs_trans		*tp,
-	struct xfs_extent_free_item	*xefi,
-	struct xfs_defer_pending	**dfpp)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-
-	trace_xfs_extent_free_defer(mp, xefi);
-
-	xefi->xefi_group = xfs_group_intent_get(mp, xefi->xefi_startblock,
-			xfs_efi_is_realtime(xefi) ? XG_TYPE_RTG : XG_TYPE_AG);
-	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, xefi_ops(xefi));
-}
-
-/* Cancel a free extent. */
-STATIC void
-xfs_extent_free_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_extent_free_item	*xefi = xefi_entry(item);
-
-	xfs_group_intent_put(xefi->xefi_group);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
-}
-
-/* Process a free extent. */
-STATIC int
-xfs_extent_free_finish_item(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*done,
-	struct list_head		*item,
-	struct xfs_btree_cur		**state)
-{
-	struct xfs_owner_info		oinfo = { };
-	struct xfs_extent_free_item	*xefi = xefi_entry(item);
-	xfs_agblock_t			agbno;
-	int				error = 0;
-
-	oinfo.oi_owner = xefi->xefi_owner;
-	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
-
-	agbno = XFS_FSB_TO_AGBNO(tp->t_mountp, xefi->xefi_startblock);
-
-	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
-		error = xfs_free_extent(tp, to_perag(xefi->xefi_group), agbno,
-				xefi->xefi_blockcount, &oinfo,
-				XFS_AG_RESV_NONE);
-	}
-
-	/*
-	 * Don't free the XEFI if we need a new transaction to complete
-	 * processing of it.
-	 */
-	if (error != -EAGAIN)
-		xfs_extent_free_cancel_item(item);
-	return error;
-}
-
-/* Abort all pending EFIs. */
-STATIC void
-xfs_extent_free_abort_intent(
-	struct xfs_log_item		*intent)
-{
-}
-
-const struct xfs_defer_op_type xfs_extent_free_defer_type = {
-	.name		= "extent_free",
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_extent_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
-STATIC int
-xfs_rtextent_free_finish_item(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*done,
-	struct list_head		*item,
-	struct xfs_btree_cur		**state)
-{
-	struct xfs_extent_free_item	*xefi = xefi_entry(item);
-	int				error;
-
-	error = xfs_rtfree_blocks(tp, to_rtg(xefi->xefi_group),
-			xefi->xefi_startblock, xefi->xefi_blockcount);
-	if (error != -EAGAIN)
-		xfs_extent_free_cancel_item(item);
-	return error;
-}
-
-const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
-	.name		= "rtextent_free",
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_rtextent_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
-/*
- * AGFL blocks are accounted differently in the reserve pools and are not
- * inserted into the busy extent list.
- */
-STATIC int
-xfs_agfl_free_finish_item(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*done,
-	struct list_head		*item,
-	struct xfs_btree_cur		**state)
-{
-	struct xfs_owner_info		oinfo = { };
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent_free_item	*xefi = xefi_entry(item);
-	struct xfs_buf			*agbp;
-	int				error;
-	xfs_agblock_t			agbno;
-
-	ASSERT(xefi->xefi_blockcount == 1);
-	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
-	oinfo.oi_owner = xefi->xefi_owner;
-
-	error = xfs_alloc_read_agf(to_perag(xefi->xefi_group), tp, 0, &agbp);
-	if (!error)
-		error = xfs_free_ag_extent(tp, agbp, agbno, 1, &oinfo,
-				XFS_AG_RESV_AGFL);
-
-	xfs_extent_free_cancel_item(item);
-	return error;
-}
-
-/* sub-type with special handling for AGFL deferred frees */
-const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
-	.name		= "agfl_free",
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_agfl_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
-/* Reverse Mapping */
-
-static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
-{
-	return list_entry(e, struct xfs_rmap_intent, ri_list);
-}
-
-/* Sort rmap intents by AG. */
-static int
-xfs_rmap_update_diff_items(
-	void				*priv,
-	const struct list_head		*a,
-	const struct list_head		*b)
-{
-	struct xfs_rmap_intent		*ra = ri_entry(a);
-	struct xfs_rmap_intent		*rb = ri_entry(b);
-
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
-}
-
-/* Get an RUI. */
-static struct xfs_log_item *
-xfs_rmap_update_create_intent(
-	struct xfs_trans		*tp,
-	struct list_head		*items,
-	unsigned int			count,
-	bool				sort)
-{
-	 struct xfs_mount		*mp = tp->t_mountp;
-
-	if (sort)
-		list_sort(mp, items, xfs_rmap_update_diff_items);
-	return NULL;
-}
-
-/* Get an RUD so we can process all the deferred rmap updates. */
-static struct xfs_log_item *
-xfs_rmap_update_create_done(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*intent,
-	unsigned int			count)
-{
-	return NULL;
-}
-
-/* Add this deferred RUI to the transaction. */
-void
-xfs_rmap_defer_add(
-	struct xfs_trans	*tp,
-	struct xfs_rmap_intent	*ri)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-
-	trace_xfs_rmap_defer(mp, ri);
-
-	/*
-	 * Deferred rmap updates for the realtime and data sections must use
-	 * separate transactions to finish deferred work because updates to
-	 * realtime metadata files can lock AGFs to allocate btree blocks and
-	 * we don't want that mixing with the AGF locks taken to finish data
-	 * section updates.
-	 */
-	ri->ri_group = xfs_group_intent_get(mp, ri->ri_bmap.br_startblock,
-			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
-	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
-			&xfs_rtrmap_update_defer_type :
-			&xfs_rmap_update_defer_type);
-}
-
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_rmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_rmap_intent		*ri = ri_entry(item);
-
-	xfs_group_intent_put(ri->ri_group);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
-}
-
-/* Process a deferred rmap update. */
-STATIC int
-xfs_rmap_update_finish_item(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*done,
-	struct list_head		*item,
-	struct xfs_btree_cur		**state)
-{
-	struct xfs_rmap_intent		*ri = ri_entry(item);
-	int				error;
-
-	error = xfs_rmap_finish_one(tp, ri, state);
-
-	xfs_rmap_update_cancel_item(item);
-	return error;
-}
-
-/* Clean up after calling xfs_rmap_finish_one. */
-STATIC void
-xfs_rmap_finish_one_cleanup(
-	struct xfs_trans	*tp,
-	struct xfs_btree_cur	*rcur,
-	int			error)
-{
-	struct xfs_buf		*agbp = NULL;
-
-	if (rcur == NULL)
-		return;
-	agbp = rcur->bc_ag.agbp;
-	xfs_btree_del_cursor(rcur, error);
-	if (error && agbp)
-		xfs_trans_brelse(tp, agbp);
-}
-
-/* Abort all pending RUIs. */
-STATIC void
-xfs_rmap_update_abort_intent(
-	struct xfs_log_item		*intent)
-{
-}
-
-const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
-	.name		= "rmap",
-	.create_intent	= xfs_rmap_update_create_intent,
-	.abort_intent	= xfs_rmap_update_abort_intent,
-	.create_done	= xfs_rmap_update_create_done,
-	.finish_item	= xfs_rmap_update_finish_item,
-	.finish_cleanup = xfs_rmap_finish_one_cleanup,
-	.cancel_item	= xfs_rmap_update_cancel_item,
-};
-
-/* Clean up after calling xfs_rtrmap_finish_one. */
-STATIC void
-xfs_rtrmap_finish_one_cleanup(
-	struct xfs_trans	*tp,
-	struct xfs_btree_cur	*rcur,
-	int			error)
-{
-	if (rcur)
-		xfs_btree_del_cursor(rcur, error);
-}
-
-const struct xfs_defer_op_type xfs_rtrmap_update_defer_type = {
-	.name		= "rtrmap",
-	.create_intent	= xfs_rmap_update_create_intent,
-	.abort_intent	= xfs_rmap_update_abort_intent,
-	.create_done	= xfs_rmap_update_create_done,
-	.finish_item	= xfs_rmap_update_finish_item,
-	.finish_cleanup = xfs_rtrmap_finish_one_cleanup,
-	.cancel_item	= xfs_rmap_update_cancel_item,
-};
-
-/* Reference Counting */
-
-static inline struct xfs_refcount_intent *ci_entry(const struct list_head *e)
-{
-	return list_entry(e, struct xfs_refcount_intent, ri_list);
-}
-
-/* Sort refcount intents by AG. */
-static int
-xfs_refcount_update_diff_items(
-	void				*priv,
-	const struct list_head		*a,
-	const struct list_head		*b)
-{
-	struct xfs_refcount_intent	*ra = ci_entry(a);
-	struct xfs_refcount_intent	*rb = ci_entry(b);
-
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
-}
-
-/* Get an CUI. */
-static struct xfs_log_item *
-xfs_refcount_update_create_intent(
-	struct xfs_trans		*tp,
-	struct list_head		*items,
-	unsigned int			count,
-	bool				sort)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-
-	if (sort)
-		list_sort(mp, items, xfs_refcount_update_diff_items);
-	return NULL;
-}
-
-/* Get an CUD so we can process all the deferred refcount updates. */
-static struct xfs_log_item *
-xfs_refcount_update_create_done(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*intent,
-	unsigned int			count)
-{
-	return NULL;
-}
-
-/* Add this deferred CUI to the transaction. */
-void
-xfs_refcount_defer_add(
-	struct xfs_trans		*tp,
-	struct xfs_refcount_intent	*ri)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-
-	trace_xfs_refcount_defer(mp, ri);
-
-	/*
-	 * Deferred refcount updates for the realtime and data sections must
-	 * use separate transactions to finish deferred work because updates to
-	 * realtime metadata files can lock AGFs to allocate btree blocks and
-	 * we don't want that mixing with the AGF locks taken to finish data
-	 * section updates.
-	 */
-	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock,
-			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
-	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
-			&xfs_rtrefcount_update_defer_type :
-			&xfs_refcount_update_defer_type);
-}
-
-/* Cancel a deferred refcount update. */
-STATIC void
-xfs_refcount_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_refcount_intent	*ri = ci_entry(item);
-
-	xfs_group_intent_put(ri->ri_group);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
-}
-
-/* Process a deferred refcount update. */
-STATIC int
-xfs_refcount_update_finish_item(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*done,
-	struct list_head		*item,
-	struct xfs_btree_cur		**state)
-{
-	struct xfs_refcount_intent	*ri = ci_entry(item);
-	int				error;
-
-	error = xfs_refcount_finish_one(tp, ri, state);
-
-	/* Did we run out of reservation?  Requeue what we didn't finish. */
-	if (!error && ri->ri_blockcount > 0) {
-		ASSERT(ri->ri_type == XFS_REFCOUNT_INCREASE ||
-		       ri->ri_type == XFS_REFCOUNT_DECREASE);
-		return -EAGAIN;
-	}
-
-	xfs_refcount_update_cancel_item(item);
-	return error;
-}
-
-/* Abort all pending CUIs. */
-STATIC void
-xfs_refcount_update_abort_intent(
-	struct xfs_log_item		*intent)
-{
-}
-
-/* Clean up after calling xfs_refcount_finish_one. */
-STATIC void
-xfs_refcount_finish_one_cleanup(
-	struct xfs_trans	*tp,
-	struct xfs_btree_cur	*rcur,
-	int			error)
-{
-	struct xfs_buf		*agbp;
-
-	if (rcur == NULL)
-		return;
-	agbp = rcur->bc_ag.agbp;
-	xfs_btree_del_cursor(rcur, error);
-	if (error)
-		xfs_trans_brelse(tp, agbp);
-}
-
-const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
-	.name		= "refcount",
-	.create_intent	= xfs_refcount_update_create_intent,
-	.abort_intent	= xfs_refcount_update_abort_intent,
-	.create_done	= xfs_refcount_update_create_done,
-	.finish_item	= xfs_refcount_update_finish_item,
-	.finish_cleanup = xfs_refcount_finish_one_cleanup,
-	.cancel_item	= xfs_refcount_update_cancel_item,
-};
-
-/* Clean up after calling xfs_rtrefcount_finish_one. */
-STATIC void
-xfs_rtrefcount_finish_one_cleanup(
-	struct xfs_trans	*tp,
-	struct xfs_btree_cur	*rcur,
-	int			error)
-{
-	if (rcur)
-		xfs_btree_del_cursor(rcur, error);
-}
-
-const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type = {
-	.name		= "rtrefcount",
-	.create_intent	= xfs_refcount_update_create_intent,
-	.abort_intent	= xfs_refcount_update_abort_intent,
-	.create_done	= xfs_refcount_update_create_done,
-	.finish_item	= xfs_refcount_update_finish_item,
-	.finish_cleanup = xfs_rtrefcount_finish_one_cleanup,
-	.cancel_item	= xfs_refcount_update_cancel_item,
-};
-
-/* Inode Block Mapping */
-
-static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
-{
-	return list_entry(e, struct xfs_bmap_intent, bi_list);
-}
-
-/* Sort bmap intents by inode. */
-static int
-xfs_bmap_update_diff_items(
-	void				*priv,
-	const struct list_head		*a,
-	const struct list_head		*b)
-{
-	struct xfs_bmap_intent		*ba = bi_entry(a);
-	struct xfs_bmap_intent		*bb = bi_entry(b);
-
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
-}
-
-/* Get an BUI. */
-static struct xfs_log_item *
-xfs_bmap_update_create_intent(
-	struct xfs_trans		*tp,
-	struct list_head		*items,
-	unsigned int			count,
-	bool				sort)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-
-	if (sort)
-		list_sort(mp, items, xfs_bmap_update_diff_items);
-	return NULL;
-}
-
-/* Get an BUD so we can process all the deferred rmap updates. */
-static struct xfs_log_item *
-xfs_bmap_update_create_done(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*intent,
-	unsigned int			count)
-{
-	return NULL;
-}
-
-/* Take a passive ref to the group containing the space we're mapping. */
-static inline void
-xfs_bmap_update_get_group(
-	struct xfs_mount	*mp,
-	struct xfs_bmap_intent	*bi)
-{
-	enum xfs_group_type	type = XG_TYPE_AG;
-
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
-		type = XG_TYPE_RTG;
-
-	/*
-	 * Bump the intent count on behalf of the deferred rmap and refcount
-	 * intent items that that we can queue when we finish this bmap work.
-	 * This new intent item will bump the intent count before the bmap
-	 * intent drops the intent count, ensuring that the intent count
-	 * remains nonzero across the transaction roll.
-	 */
-	bi->bi_group = xfs_group_intent_get(mp, bi->bi_bmap.br_startblock,
-				type);
-}
-
-/* Add this deferred BUI to the transaction. */
-void
-xfs_bmap_defer_add(
-	struct xfs_trans	*tp,
-	struct xfs_bmap_intent	*bi)
-{
-	xfs_bmap_update_get_group(tp->t_mountp, bi);
-
-	/*
-	 * Ensure the deferred mapping is pre-recorded in i_delayed_blks.
-	 *
-	 * Otherwise stat can report zero blocks for an inode that actually has
-	 * data when the entire mapping is in the process of being overwritten
-	 * using the out of place write path. This is undone in xfs_bmapi_remap
-	 * after it has incremented di_nblocks for a successful operation.
-	 */
-	if (bi->bi_type == XFS_BMAP_MAP)
-		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
-
-	trace_xfs_bmap_defer(bi);
-	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
-}
-
-/* Cancel a deferred bmap update. */
-STATIC void
-xfs_bmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_bmap_intent		*bi = bi_entry(item);
-
-	if (bi->bi_type == XFS_BMAP_MAP)
-		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
-
-	xfs_group_intent_put(bi->bi_group);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
-}
-
-/* Process a deferred rmap update. */
-STATIC int
-xfs_bmap_update_finish_item(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*done,
-	struct list_head		*item,
-	struct xfs_btree_cur		**state)
-{
-	struct xfs_bmap_intent		*bi = bi_entry(item);
-	int				error;
-
-	error = xfs_bmap_finish_one(tp, bi);
-	if (!error && bi->bi_bmap.br_blockcount > 0) {
-		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
-		return -EAGAIN;
-	}
-
-	xfs_bmap_update_cancel_item(item);
-	return error;
-}
-
-/* Abort all pending BUIs. */
-STATIC void
-xfs_bmap_update_abort_intent(
-	struct xfs_log_item		*intent)
-{
-}
-
-const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
-	.name		= "bmap",
-	.create_intent	= xfs_bmap_update_create_intent,
-	.abort_intent	= xfs_bmap_update_abort_intent,
-	.create_done	= xfs_bmap_update_create_done,
-	.finish_item	= xfs_bmap_update_finish_item,
-	.cancel_item	= xfs_bmap_update_cancel_item,
-};
-
-/* Logged extended attributes */
-
-static inline struct xfs_attr_intent *attri_entry(const struct list_head *e)
-{
-	return list_entry(e, struct xfs_attr_intent, xattri_list);
-}
-
-/* Get an ATTRI. */
-static struct xfs_log_item *
-xfs_attr_create_intent(
-	struct xfs_trans	*tp,
-	struct list_head	*items,
-	unsigned int		count,
-	bool			sort)
-{
-	return NULL;
-}
-
-/* Abort all pending ATTRs. */
-static void
-xfs_attr_abort_intent(
-	struct xfs_log_item	*intent)
-{
-}
-
-/* Get an ATTRD so we can process all the attrs. */
-static struct xfs_log_item *
-xfs_attr_create_done(
-	struct xfs_trans	*tp,
-	struct xfs_log_item	*intent,
-	unsigned int		count)
-{
-	return NULL;
-}
-
-static inline void
-xfs_attr_free_item(
-	struct xfs_attr_intent	*attr)
-{
-	if (attr->xattri_da_state)
-		xfs_da_state_free(attr->xattri_da_state);
-	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
-		kfree(attr);
-	else
-		kmem_cache_free(xfs_attr_intent_cache, attr);
-}
-
-/* Process an attr. */
-static int
-xfs_attr_finish_item(
-	struct xfs_trans	*tp,
-	struct xfs_log_item	*done,
-	struct list_head	*item,
-	struct xfs_btree_cur	**state)
-{
-	struct xfs_attr_intent	*attr = attri_entry(item);
-	struct xfs_da_args	*args;
-	int			error;
-
-	args = attr->xattri_da_args;
-
-	/*
-	 * Always reset trans after EAGAIN cycle
-	 * since the transaction is new
-	 */
-	args->trans = tp;
-
-	if (XFS_TEST_ERROR(args->dp->i_mount, XFS_ERRTAG_LARP)) {
-		error = -EIO;
-		goto out;
-	}
-
-	error = xfs_attr_set_iter(attr);
-	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
-		error = -EAGAIN;
-out:
-	if (error != -EAGAIN)
-		xfs_attr_free_item(attr);
-
-	return error;
-}
-
-/* Cancel an attr */
-static void
-xfs_attr_cancel_item(
-	struct list_head	*item)
-{
-	struct xfs_attr_intent	*attr = attri_entry(item);
-
-	xfs_attr_free_item(attr);
-}
-
-void
-xfs_attr_defer_add(
-	struct xfs_da_args	*args,
-	enum xfs_attr_defer_op	op)
-{
-	struct xfs_attr_intent	*new;
-	unsigned int		log_op = 0;
-	bool			is_pptr = args->attr_filter & XFS_ATTR_PARENT;
-
-	if (is_pptr) {
-		ASSERT(xfs_has_parent(args->dp->i_mount));
-		ASSERT((args->attr_filter & ~XFS_ATTR_PARENT) != 0);
-		ASSERT(args->op_flags & XFS_DA_OP_LOGGED);
-		ASSERT(args->valuelen == sizeof(struct xfs_parent_rec));
-	}
-
-	new = kmem_cache_zalloc(xfs_attr_intent_cache,
-			GFP_NOFS | __GFP_NOFAIL);
-	new->xattri_da_args = args;
-
-	/* Compute log operation from the higher level op and namespace. */
-	switch (op) {
-	case XFS_ATTR_DEFER_SET:
-		if (is_pptr)
-			log_op = XFS_ATTRI_OP_FLAGS_PPTR_SET;
-		else
-			log_op = XFS_ATTRI_OP_FLAGS_SET;
-		break;
-	case XFS_ATTR_DEFER_REPLACE:
-		if (is_pptr)
-			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REPLACE;
-		else
-			log_op = XFS_ATTRI_OP_FLAGS_REPLACE;
-		break;
-	case XFS_ATTR_DEFER_REMOVE:
-		if (is_pptr)
-			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REMOVE;
-		else
-			log_op = XFS_ATTRI_OP_FLAGS_REMOVE;
-		break;
-	default:
-		ASSERT(0);
-		break;
-	}
-	new->xattri_op_flags = log_op;
-
-	/* Set up initial attr operation state. */
-	switch (log_op) {
-	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
-	case XFS_ATTRI_OP_FLAGS_SET:
-		new->xattri_dela_state = xfs_attr_init_add_state(args);
-		break;
-	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
-		ASSERT(args->new_valuelen == args->valuelen);
-		new->xattri_dela_state = xfs_attr_init_replace_state(args);
-		break;
-	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		new->xattri_dela_state = xfs_attr_init_replace_state(args);
-		break;
-	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
-	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		new->xattri_dela_state = xfs_attr_init_remove_state(args);
-		break;
-	}
-
-	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
-}
-
-const struct xfs_defer_op_type xfs_attr_defer_type = {
-	.name		= "attr",
-	.max_items	= 1,
-	.create_intent	= xfs_attr_create_intent,
-	.abort_intent	= xfs_attr_abort_intent,
-	.create_done	= xfs_attr_create_done,
-	.finish_item	= xfs_attr_finish_item,
-	.cancel_item	= xfs_attr_cancel_item,
-};
-
-/* File Mapping Exchanges */
-
-STATIC struct xfs_log_item *
-xfs_exchmaps_create_intent(
-	struct xfs_trans		*tp,
-	struct list_head		*items,
-	unsigned int			count,
-	bool				sort)
-{
-	return NULL;
-}
-STATIC struct xfs_log_item *
-xfs_exchmaps_create_done(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*intent,
-	unsigned int			count)
-{
-	return NULL;
-}
-
-/* Add this deferred XMI to the transaction. */
-void
-xfs_exchmaps_defer_add(
-	struct xfs_trans		*tp,
-	struct xfs_exchmaps_intent	*xmi)
-{
-	trace_xfs_exchmaps_defer(tp->t_mountp, xmi);
-
-	xfs_defer_add(tp, &xmi->xmi_list, &xfs_exchmaps_defer_type);
-}
-
-static inline struct xfs_exchmaps_intent *xmi_entry(const struct list_head *e)
-{
-	return list_entry(e, struct xfs_exchmaps_intent, xmi_list);
-}
-
-/* Process a deferred swapext update. */
-STATIC int
-xfs_exchmaps_finish_item(
-	struct xfs_trans		*tp,
-	struct xfs_log_item		*done,
-	struct list_head		*item,
-	struct xfs_btree_cur		**state)
-{
-	struct xfs_exchmaps_intent	*xmi = xmi_entry(item);
-	int				error;
-
-	/*
-	 * Exchange one more extent between the two files.  If there's still
-	 * more work to do, we want to requeue ourselves after all other
-	 * pending deferred operations have finished.  This includes all of the
-	 * dfops that we queued directly as well as any new ones created in the
-	 * process of finishing the others.
-	 */
-	error = xfs_exchmaps_finish_one(tp, xmi);
-	if (error != -EAGAIN)
-		kmem_cache_free(xfs_exchmaps_intent_cache, xmi);
-	return error;
-}
-
-/* Abort all pending XMIs. */
-STATIC void
-xfs_exchmaps_abort_intent(
-	struct xfs_log_item		*intent)
-{
-}
-
-/* Cancel a deferred swapext update. */
-STATIC void
-xfs_exchmaps_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_exchmaps_intent	*xmi = xmi_entry(item);
-
-	kmem_cache_free(xfs_exchmaps_intent_cache, xmi);
-}
-
-const struct xfs_defer_op_type xfs_exchmaps_defer_type = {
-	.name		= "exchmaps",
-	.create_intent	= xfs_exchmaps_create_intent,
-	.abort_intent	= xfs_exchmaps_abort_intent,
-	.create_done	= xfs_exchmaps_create_done,
-	.finish_item	= xfs_exchmaps_finish_item,
-	.cancel_item	= xfs_exchmaps_cancel_item,
-};
-
-/* log intent size calculations */
-
-static inline unsigned int
-xlog_item_space(
-	unsigned int	niovecs,
-	unsigned int	nbytes)
-{
-	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
-	return round_up(nbytes, sizeof(uint64_t));
-}
-
-unsigned int xfs_efi_log_space(unsigned int nr)
-{
-	return xlog_item_space(1, xfs_efi_log_format_sizeof(nr));
-}
-
-unsigned int xfs_efd_log_space(unsigned int nr)
-{
-	return xlog_item_space(1, xfs_efd_log_format_sizeof(nr));
-}
-
-unsigned int xfs_rui_log_space(unsigned int nr)
-{
-	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
-}
-
-unsigned int xfs_rud_log_space(void)
-{
-	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
-}
-
-unsigned int xfs_bui_log_space(unsigned int nr)
-{
-	return xlog_item_space(1, xfs_bui_log_format_sizeof(nr));
-}
-
-unsigned int xfs_bud_log_space(void)
-{
-	return xlog_item_space(1, sizeof(struct xfs_bud_log_format));
-}
-
-unsigned int xfs_cui_log_space(unsigned int nr)
-{
-	return xlog_item_space(1, xfs_cui_log_format_sizeof(nr));
-}
-
-unsigned int xfs_cud_log_space(void)
-{
-	return xlog_item_space(1, sizeof(struct xfs_cud_log_format));
-}
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
deleted file mode 100644
index 325a6f7b..00000000
--- a/libxfs/defer_item.h
+++ /dev/null
@@ -1,56 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <djwong@kernel.org>
- */
-#ifndef	__LIBXFS_DEFER_ITEM_H_
-#define	__LIBXFS_DEFER_ITEM_H_
-
-struct xfs_bmap_intent;
-
-void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
-
-enum xfs_attr_defer_op {
-	XFS_ATTR_DEFER_SET,
-	XFS_ATTR_DEFER_REMOVE,
-	XFS_ATTR_DEFER_REPLACE,
-};
-
-void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
-
-struct xfs_exchmaps_intent;
-
-void xfs_exchmaps_defer_add(struct xfs_trans *tp,
-		struct xfs_exchmaps_intent *xmi);
-
-struct xfs_extent_free_item;
-struct xfs_defer_pending;
-
-void xfs_extent_free_defer_add(struct xfs_trans *tp,
-		struct xfs_extent_free_item *xefi,
-		struct xfs_defer_pending **dfpp);
-
-struct xfs_rmap_intent;
-
-void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
-
-struct xfs_refcount_intent;
-
-void xfs_refcount_defer_add(struct xfs_trans *tp,
-		struct xfs_refcount_intent *ri);
-
-/* log intent size calculations */
-
-unsigned int xfs_efi_log_space(unsigned int nr);
-unsigned int xfs_efd_log_space(unsigned int nr);
-
-unsigned int xfs_rui_log_space(unsigned int nr);
-unsigned int xfs_rud_log_space(void);
-
-unsigned int xfs_bui_log_space(unsigned int nr);
-unsigned int xfs_bud_log_space(void);
-
-unsigned int xfs_cui_log_space(unsigned int nr);
-unsigned int xfs_cud_log_space(void);
-
-#endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 5d8b4a15..43e76539 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -19,6 +19,13 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_extfree_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
+#include "xfs_bmap_item.h"
+#include "xfs_attr_item.h"
+#include "xfs_icreate_item.h"
+#include "xfs_exchmaps_item.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_metafile.h"
@@ -218,6 +225,44 @@ init_caches(void)
 			sizeof(struct xfs_trans), "xfs_trans");
 	xfs_parent_args_cache = kmem_cache_init(
 			sizeof(struct xfs_parent_args), "xfs_parent_args");
+
+	/*
+	 * Log intent and intent-done items, allocated by log recovery.  The
+	 * kernel creates these in xfs_init_caches(); the sizes are the same,
+	 * since the ones with a variable tail are sized for the fast-extent
+	 * count the log format allows.
+	 */
+	xfs_efi_cache = kmem_cache_init(
+			xfs_efi_log_item_sizeof(XFS_EFI_MAX_FAST_EXTENTS),
+			"xfs_efi_item");
+	xfs_efd_cache = kmem_cache_init(
+			xfs_efd_log_item_sizeof(XFS_EFD_MAX_FAST_EXTENTS),
+			"xfs_efd_item");
+	xfs_rui_cache = kmem_cache_init(
+			xfs_rui_log_item_sizeof(XFS_RUI_MAX_FAST_EXTENTS),
+			"xfs_rui_item");
+	xfs_rud_cache = kmem_cache_init(
+			sizeof(struct xfs_rud_log_item), "xfs_rud_item");
+	xfs_cui_cache = kmem_cache_init(
+			xfs_cui_log_item_sizeof(XFS_CUI_MAX_FAST_EXTENTS),
+			"xfs_cui_item");
+	xfs_cud_cache = kmem_cache_init(
+			sizeof(struct xfs_cud_log_item), "xfs_cud_item");
+	xfs_bui_cache = kmem_cache_init(
+			xfs_bui_log_item_sizeof(XFS_BUI_MAX_FAST_EXTENTS),
+			"xfs_bui_item");
+	xfs_bud_cache = kmem_cache_init(
+			sizeof(struct xfs_bud_log_item), "xfs_bud_item");
+	xfs_attri_cache = kmem_cache_init(
+			sizeof(struct xfs_attri_log_item), "xfs_attri_item");
+	xfs_attrd_cache = kmem_cache_init(
+			sizeof(struct xfs_attrd_log_item), "xfs_attrd_item");
+	xfs_icreate_cache = kmem_cache_init(
+			sizeof(struct xfs_icreate_item), "xfs_icr");
+	xfs_xmi_cache = kmem_cache_init(
+			sizeof(struct xfs_xmi_log_item), "xfs_xmi_item");
+	xfs_xmd_cache = kmem_cache_init(
+			sizeof(struct xfs_xmd_log_item), "xfs_xmd_item");
 }
 
 static int
@@ -230,6 +275,19 @@ destroy_caches(void)
 	leaked += kmem_cache_destroy(xfs_inode_cache);
 	leaked += kmem_cache_destroy(xfs_ifork_cache);
 	leaked += kmem_cache_destroy(xfs_buf_item_cache);
+	leaked += kmem_cache_destroy(xfs_efi_cache);
+	leaked += kmem_cache_destroy(xfs_efd_cache);
+	leaked += kmem_cache_destroy(xfs_rui_cache);
+	leaked += kmem_cache_destroy(xfs_rud_cache);
+	leaked += kmem_cache_destroy(xfs_cui_cache);
+	leaked += kmem_cache_destroy(xfs_cud_cache);
+	leaked += kmem_cache_destroy(xfs_bui_cache);
+	leaked += kmem_cache_destroy(xfs_bud_cache);
+	leaked += kmem_cache_destroy(xfs_attri_cache);
+	leaked += kmem_cache_destroy(xfs_attrd_cache);
+	leaked += kmem_cache_destroy(xfs_icreate_cache);
+	leaked += kmem_cache_destroy(xfs_xmi_cache);
+	leaked += kmem_cache_destroy(xfs_xmd_cache);
 	leaked += kmem_cache_destroy(xfs_da_state_cache);
 	xfs_defer_destroy_item_caches();
 	xfs_btree_destroy_cur_caches();
@@ -460,6 +518,7 @@ libxfs_buftarg_alloc(
 	btp->bt_mount = mp;
 	btp->bt_bdev = dev->dev;
 	btp->bt_bdev_fd = dev->fd;
+	libxfs_bdev_register(dev->dev, dev->fd);
 	btp->bt_xfile = NULL;
 	btp->flags = 0;
 	if (write_fails) {
@@ -883,6 +942,17 @@ libxfs_mount(
 
 	xfs_set_rtgroup_data_loaded(mp);
 
+	/*
+	 * Deferred operations create real intent items now, and an intent item
+	 * is released through the AIL.  The kernel builds the AIL in
+	 * xfs_log_mount(); libxfs has no log mount, so build it here and give
+	 * every tool the same guarantee that mp->m_ail exists.
+	 */
+	if (xfs_trans_ail_init(mp)) {
+		fprintf(stderr, _("%s: AIL init failed\n"), progname);
+		exit(1);
+	}
+
 	return mp;
 out_da:
 	xfs_da_unmount(mp);
@@ -1009,6 +1079,9 @@ libxfs_umount(
 	if (mp->m_metadirip)
 		libxfs_irele(mp->m_metadirip);
 
+	if (mp->m_ail)
+		xfs_trans_ail_destroy(mp);
+
 	/*
 	 * Purge the buffer cache to write all dirty buffers to disk and free
 	 * all incore buffers, then pick up the outcome when we tell the disks
diff --git a/libxfs/inode.c b/libxfs/inode.c
index dc7e227e..d5a2738f 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -312,3 +312,46 @@ void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
 		inode_fsgid_set(inode, idmap);
 	inode->i_mode = mode;
 }
+
+/*
+ * Allocate a bare in-core inode, without the imap lookup that
+ * libxfs_iget() performs.  Log recovery uses this to build an inode it
+ * only ever reads the fork owners out of, so there is nothing on disk to
+ * map yet.  Mirrors the kernel's xfs_inode_alloc()/xfs_inode_free() in
+ * xfs_icache.c, minus the VFS inode initialisation.
+ */
+struct xfs_inode *
+xfs_inode_alloc(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct xfs_inode	*ip;
+
+	ip = kmem_cache_zalloc(xfs_inode_cache, 0);
+	if (!ip)
+		return NULL;
+
+	VFS_I(ip)->i_count = 1;
+	VFS_I(ip)->i_mode = 0;
+	ip->i_ino = ino;
+	ip->i_mount = mp;
+	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_next_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = NULLAGINO;
+	spin_lock_init(&VFS_I(ip)->i_lock);
+
+	return ip;
+}
+
+void
+xfs_inode_free(
+	struct xfs_inode	*ip)
+{
+	/*
+	 * xfs_inode_from_disk() allocates the data fork's broot, the attr fork
+	 * and the CoW fork, so free them before the inode itself.  Recovering
+	 * an owner-change item is the path that gets here.
+	 */
+	libxfs_idestroy(ip);
+	kmem_cache_free(xfs_inode_cache, ip);
+}
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index e27922d5..510ef7ac 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -27,6 +27,8 @@ struct xfs_buftarg {
 	unsigned long		writes_left;
 	dev_t			bt_bdev;
 	int			bt_bdev_fd;
+	xfs_daddr_t		bt_nr_sectors;	/* device size, kept in
+						 * step by log recovery */
 	struct xfile		*bt_xfile;
 	unsigned int		flags;
 	struct cache		*bcache;	/* buffer cache */
@@ -179,6 +181,7 @@ void libxfs_buf_mark_dirty(struct xfs_buf *bp);
 int libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
 			int nmaps, int flags, struct xfs_buf **bpp);
 void	libxfs_buf_relse(struct xfs_buf *bp);
+void	libxfs_buf_rele(struct xfs_buf *bp);
 
 static inline int
 libxfs_buf_get(
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index d8d86d91..9f576364 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -16,6 +16,11 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_buf_item.h"
+#include "xfs_cksum.h"
 
 struct kmem_cache	*xfs_buf_item_cache;
 struct kmem_cache	*xfs_ili_cache;		/* inode log item cache */
@@ -70,7 +75,7 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
  * buffer (see xfs_buf_attach_iodone() below), then put the
  * buf log item at the front.
  */
-void
+int
 xfs_buf_item_init(
 	struct xfs_buf		*bp,
 	xfs_mount_t		*mp)
@@ -96,7 +101,7 @@ xfs_buf_item_init(
 				"reused buf item %p for pre-logged buffer %p\n",
 				lip, bp);
 #endif
-			return;
+			return 0;
 		}
 	}
 
@@ -111,6 +116,7 @@ xfs_buf_item_init(
 	bip->__bli_format.blf_blkno = (int64_t)xfs_buf_daddr(bp);
 	bip->__bli_format.blf_len = (unsigned short)bp->b_length;
 	bp->b_log_item = bip;
+	return 0;
 }
 
 
@@ -229,7 +235,6 @@ xfs_inode_item_precommit(
 	 * (ili_fields) correctly tracks that the version has changed.
 	 */
 	spin_lock(&iip->ili_lock);
-	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
 	if (flags & XFS_ILOG_IVERSION)
 		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
 
@@ -325,3 +330,196 @@ xfs_inode_item_init(
 						&xfs_inode_item_ops);
 	iip->ili_inode = ip;
 }
+
+/*
+ * The log write path does not exist in userspace: nothing waits on log
+ * space, and there is no log to shut down.  These are declared by the
+ * kernel's xfs_log.h, so provide the definitions rather than defining
+ * the names away.
+ */
+void
+xfs_log_space_wake(
+	struct xfs_mount	*mp)
+{
+}
+
+/*
+ * Userspace never pushes a checkpoint, so an item that exists at all is still
+ * in the one being built.  Saying so is not just the truthful answer, it is
+ * the necessary one: the only caller is xfs_defer_relog(), and a false here
+ * sends it on to sample the AIL push target through mp->m_log, which is NULL
+ * in every tool but xfs_repair.  Relogging an intent to keep the log tail
+ * moving is meaningless when nothing is writing a log.
+ */
+bool
+xfs_log_item_in_current_chkpt(
+	struct xfs_log_item	*lip)
+{
+	return true;
+}
+
+/*
+ * Recovery shuts the log down when an item fails to replay, and the imported
+ * code relies on that state afterwards: xlog_recover_process() uses it to
+ * avoid writing out a partial checkpoint, and xfs_repair checks it before
+ * trusting that replay finished.  Record it rather than ignoring it.
+ *
+ * Shut the mount down as well.  In the kernel these are one event, and code
+ * that reaches this directly rather than through xfs_force_shutdown() would
+ * otherwise leave xfs_is_shutdown() answering false on a filesystem the log
+ * has already given up on.
+ */
+bool
+xlog_force_shutdown(
+	struct xlog		*log,
+	uint32_t		shutdown_flags)
+{
+	if (!log)
+		return false;
+	if (log->l_mp)
+		xfs_set_shutdown(log->l_mp);
+	return !test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate);
+}
+
+/*
+ * Log item formatting builds the log vectors that get written to the log.
+ * libxfs replays a log but never writes one, so ->iop_format() is never
+ * called and these exist only so the kernel's log item sources link.
+ * struct xlog_format_buf is private to the kernel's xfs_log_cil.c, so it
+ * is defined here rather than in a header nothing else needs.
+ */
+struct xlog_format_buf {
+	struct xfs_log_vec	*lv;
+	unsigned int		idx;
+};
+
+void *
+xlog_format_start(
+	struct xlog_format_buf	*lfb,
+	uint16_t		type)
+{
+	fprintf(stderr,
+_("%s: log item formatting attempted in userspace; this is a bug\n"),
+		progname);
+	exit(1);
+}
+
+void
+xlog_format_commit(
+	struct xlog_format_buf	*lfb,
+	unsigned int		data_len)
+{
+	fprintf(stderr,
+_("%s: log item formatting attempted in userspace; this is a bug\n"),
+		progname);
+	exit(1);
+}
+
+/*
+ * Pieces of the kernel's xfs_log.c, xfs_buf_item.c and xfs_inode_item.c that
+ * log recovery needs.  Those files are mostly the log write path and buffer
+ * pinning, neither of which exists in userspace, so libxfs carries the
+ * individual functions rather than the files.  These are the kernel's
+ * implementations unchanged.
+ */
+
+/* from xfs_log.c */
+__le32
+xlog_cksum(
+	struct xlog		*log,
+	struct xlog_rec_header	*rhead,
+	char			*dp,
+	unsigned int		hdrsize,
+	unsigned int		size)
+{
+	uint32_t		crc;
+
+	/* first generate the crc for the record header ... */
+	crc = xfs_start_cksum_update((char *)rhead, hdrsize,
+			      offsetof(struct xlog_rec_header, h_crc));
+
+	/* ... then for additional cycle data for v2 logs ... */
+	if (xfs_has_logv2(log->l_mp)) {
+		int		xheads, i;
+
+		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE) - 1;
+		for (i = 0; i < xheads; i++)
+			crc = crc32c(crc, &rhead->h_ext[i], XLOG_REC_EXT_SIZE);
+	}
+
+	/* ... and finally for the payload */
+	crc = crc32c(crc, dp, size);
+
+	return xfs_end_cksum(crc);
+}
+
+/* from xfs_buf_item.c */
+bool
+xfs_buf_log_check_iovec(
+	struct kvec			*iovec)
+{
+	struct xfs_buf_log_format	*blfp = iovec->iov_base;
+	char				*bmp_end;
+	char				*item_end;
+
+	if (offsetof(struct xfs_buf_log_format, blf_data_map) > iovec->iov_len)
+		return false;
+
+	item_end = (char *)iovec->iov_base + iovec->iov_len;
+	bmp_end = (char *)&blfp->blf_data_map[blfp->blf_map_size];
+	return bmp_end <= item_end;
+}
+
+/* from xfs_inode_item.c */
+int
+xfs_inode_item_format_convert(
+	struct kvec			*buf,
+	struct xfs_inode_log_format	*in_f)
+{
+	struct xfs_inode_log_format_32	*in_f32 = buf->iov_base;
+
+	if (buf->iov_len != sizeof(*in_f32)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+		return -EFSCORRUPTED;
+	}
+
+	in_f->ilf_type = in_f32->ilf_type;
+	in_f->ilf_size = in_f32->ilf_size;
+	in_f->ilf_fields = in_f32->ilf_fields;
+	in_f->ilf_asize = in_f32->ilf_asize;
+	in_f->ilf_dsize = in_f32->ilf_dsize;
+	in_f->ilf_ino = in_f32->ilf_ino;
+	memcpy(&in_f->ilf_u, &in_f32->ilf_u, sizeof(in_f->ilf_u));
+	in_f->ilf_blkno = in_f32->ilf_blkno;
+	in_f->ilf_len = in_f32->ilf_len;
+	in_f->ilf_boffset = in_f32->ilf_boffset;
+	return 0;
+}
+
+/*
+ * Nothing waits for the log in userspace.
+ */
+int
+xfs_log_force(
+	struct xfs_mount	*mp,
+	uint			flags)
+{
+	return 0;
+}
+
+/*
+ * See kernel_compat.h: libxfs holds no inode locks, but the transaction
+ * join the kernel does here matters.
+ */
+void
+xfs_exchrange_ilock(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	if (!tp)
+		return;
+	libxfs_trans_ijoin(tp, ip1, 0);
+	if (ip2 != ip1)
+		libxfs_trans_ijoin(tp, ip2, 0);
+}
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 5b1c1bbc..7b9540ea 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_log_priv.h"
 #include "libfrog/platform.h"
 #include "libxfs/xfile.h"
 #include "libxfs/buf_mem.h"
@@ -571,6 +572,25 @@ libxfs_buf_relse(
 	}
 }
 
+/*
+ * Drop a buffer reference without unlocking the buffer.  The kernel's
+ * xfs_buf_rele() only manages the reference count, and its caller in
+ * xlog_recover_iunlink_ag() has already unlocked the AGI by the time it gets
+ * here, so treating it as a full release would unlock a second time.
+ */
+void
+libxfs_buf_rele(
+	struct xfs_buf	*bp)
+{
+	if (!list_empty(&bp->b_node.cn_hash))
+		cache_node_put(bp->b_target->bcache, &bp->b_node);
+	else if (--bp->b_node.cn_count == 0) {
+		if (bp->b_flags & LIBXFS_B_DIRTY)
+			libxfs_bwrite(bp);
+		libxfs_brelse(&bp->b_node);
+	}
+}
+
 static struct cache_node *
 libxfs_balloc(
 	cache_key_t		key)
@@ -863,8 +883,17 @@ libxfs_bwrite(
 	 * contain data that has been invalidated, and even if the buffer is
 	 * dirty it must *never* be written. Verifiers are wonderful for finding
 	 * bugs like this. Make sure the error is obvious as to the cause.
+	 *
+	 * Log recovery is the exception.  When it replays an inode buffer
+	 * whose size does not match this kernel's inode cluster size it marks
+	 * the buffer stale deliberately, to keep it out of the buffer cache,
+	 * and then writes it anyway - see xlog_recover_buf_commit_pass2().
+	 * Refusing that write would fail recovery of any log written with a
+	 * different inode cluster size.
 	 */
-	if (bp->b_flags & LIBXFS_B_STALE) {
+	if ((bp->b_flags & LIBXFS_B_STALE) &&
+	    !(bp->b_mount && bp->b_mount->m_log &&
+	      xlog_recovery_needed(bp->b_mount->m_log))) {
 		bp->b_error = -ESTALE;
 		return bp->b_error;
 	}
@@ -1154,6 +1183,24 @@ xfs_buf_delwri_submit(
 
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		list_del_init(&bp->b_list);
+
+		/*
+		 * Log recovery shuts the log down when an item fails to
+		 * replay, precisely so that the checkpoint it was part way
+		 * through does not reach disk.  Writing some of it can stop
+		 * the whole checkpoint being recoverable next time, so drop
+		 * the buffers instead, as the kernel does.
+		 */
+		if (bp->b_mount && bp->b_mount->m_log &&
+		    xlog_is_shutdown(bp->b_mount->m_log)) {
+			bp->b_flags |= LIBXFS_B_STALE;
+			bp->b_flags &= ~LIBXFS_B_DIRTY;
+			libxfs_buf_relse(bp);
+			if (!error)
+				error = -EIO;
+			continue;
+		}
+
 		error2 = libxfs_bwrite(bp);
 		if (!error)
 			error = error2;
@@ -1455,3 +1502,112 @@ __xfs_buf_mark_corrupt(
 	xfs_buf_corruption_error(bp, fa);
 	xfs_buf_stale(bp);
 }
+
+/*
+ * Raw device I/O for log recovery.
+ *
+ * The kernel passes a struct block_device here; libxfs's buftarg carries a
+ * dev_t and keeps the file descriptor alongside it, so resolve one to the
+ * other through the small set of buftargs libxfs creates.  Keeping the
+ * signature means xfs_log_recover.c needs no change.
+ */
+static struct {
+	dev_t	dev;
+	int	fd;
+} libxfs_bdev_fds[8] = {
+	[0 ... 7] = { .fd = -1 },
+};
+
+void
+libxfs_bdev_register(
+	dev_t		dev,
+	int		fd)
+{
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(libxfs_bdev_fds); i++) {
+		if (libxfs_bdev_fds[i].fd < 0 ||
+		    libxfs_bdev_fds[i].dev == dev) {
+			libxfs_bdev_fds[i].dev = dev;
+			libxfs_bdev_fds[i].fd = fd;
+			return;
+		}
+	}
+}
+
+static int
+libxfs_bdev_fd(
+	dev_t		dev)
+{
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(libxfs_bdev_fds); i++)
+		if (libxfs_bdev_fds[i].fd >= 0 &&
+		    libxfs_bdev_fds[i].dev == dev)
+			return libxfs_bdev_fds[i].fd;
+	return -1;
+}
+
+static int
+xfs_rw_bdev_raw(
+	int			fd,
+	char			*data,
+	unsigned int		count,
+	off_t			offset,
+	enum req_op		op)
+{
+	ssize_t			ret;
+
+	do {
+		if (op == REQ_OP_WRITE)
+			ret = pwrite(fd, data, count, offset);
+		else
+			ret = pread(fd, data, count, offset);
+	} while (ret < 0 && errno == EINTR);
+
+	if (ret < 0)
+		return -errno;
+	if ((unsigned int)ret != count)
+		return -EIO;
+	return 0;
+}
+
+int
+xfs_rw_bdev(
+	dev_t			bdev,
+	sector_t		sector,
+	unsigned int		count,
+	char			*data,
+	enum req_op		op)
+{
+	off_t			offset = (off_t)sector << BBSHIFT;
+	ssize_t			ret;
+	int			fd = libxfs_bdev_fd(bdev);
+
+	if (fd < 0)
+		return -EINVAL;
+
+	/*
+	 * Recovery buffers come from kvzalloc(), which is plain calloc() in
+	 * userspace and so is not sector aligned.  libxfs opens block devices
+	 * O_DIRECT, where an unaligned buffer fails the I/O with EINVAL, and
+	 * everywhere else libxfs allocates buffers with memalign() for exactly
+	 * this reason.  Bounce through an aligned buffer when we are handed one
+	 * that will not do.
+	 */
+	if ((uintptr_t)data & (libxfs_device_alignment() - 1)) {
+		char	*bounce = memalign(libxfs_device_alignment(), count);
+
+		if (!bounce)
+			return -ENOMEM;
+		if (op == REQ_OP_WRITE)
+			memcpy(bounce, data, count);
+		ret = xfs_rw_bdev_raw(fd, bounce, count, offset, op);
+		if (ret == 0 && op != REQ_OP_WRITE)
+			memcpy(data, bounce, count);
+		free(bounce);
+		return ret;
+	}
+
+	return xfs_rw_bdev_raw(fd, data, count, offset, op);
+}
diff --git a/libxfs/trans.c b/libxfs/trans.c
index c89b035f..a575ca2f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -16,6 +16,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_log_priv.h"
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_trace.h"
@@ -52,7 +53,7 @@ libxfs_trans_add_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
-	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_log == tp->t_mountp->m_log);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 	ASSERT(list_empty(&lip->li_trans));
 	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
@@ -347,6 +348,23 @@ libxfs_trans_cancel(
 	}
 
 	if (dirty) {
+		/*
+		 * The kernel shuts the filesystem down here rather than
+		 * aborting, because a dirty cancel is not necessarily a
+		 * programming error: replaying a corrupt log item reaches
+		 * this path legitimately.  Do the same while the log is
+		 * being recovered so the failure is reported instead of
+		 * dumping core, and keep the loud abort everywhere else,
+		 * where it still means xfs_repair has a bug.
+		 */
+		if (tp->t_mountp && tp->t_mountp->m_log &&
+		    xlog_recovery_needed(tp->t_mountp->m_log)) {
+			xlog_force_shutdown(tp->t_mountp->m_log,
+					SHUTDOWN_CORRUPT_INCORE);
+			xfs_trans_free_items(tp);
+			xfs_trans_free(tp);
+			return;
+		}
 		fprintf(stderr, _("Cancelling dirty transaction!\n"));
 		abort();
 	}
@@ -355,7 +373,7 @@ libxfs_trans_cancel(
 	xfs_trans_free(tp);
 }
 
-static void
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
@@ -963,6 +981,12 @@ buf_item_done(
 	libxfs_buf_relse(bp);
 }
 
+/*
+ * Dispose of the items a transaction accumulated.  Buffers and inodes have
+ * always had their own userspace handling; everything else - the intent and
+ * intent-done items that deferred operations now really do create - is
+ * disposed of the way the kernel does it, through the item ops vector.
+ */
 static void
 trans_committed(
 	xfs_trans_t		*tp)
@@ -976,6 +1000,8 @@ trans_committed(
 			buf_item_done((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
 			inode_item_done((struct xfs_inode_log_item *)lip);
+		else if (lip->li_ops->iop_release)
+			lip->li_ops->iop_release(lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
@@ -1021,6 +1047,8 @@ xfs_trans_free_items(
 			buf_item_unlock((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
 			inode_item_unlock((struct xfs_inode_log_item *)lip);
+		else if (lip->li_ops->iop_release)
+			lip->li_ops->iop_release(lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
@@ -1109,7 +1137,7 @@ xfs_trans_run_precommits(
 		}
 	}
 	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	return error;
 }
 
diff --git a/libxfs/util.c b/libxfs/util.c
index 143d011a..88580980 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -408,12 +408,16 @@ xfs_log_item_init(
 	int			type,
 	const struct xfs_item_ops *ops)
 {
-	item->li_mountp = mp; 
+	item->li_log = mp->m_log;
+	item->li_ailp = mp->m_ail;
 	item->li_type = type;
 	item->li_ops = ops;
+	item->li_lv = NULL;
 
-	INIT_LIST_HEAD(&item->li_trans);
+	INIT_LIST_HEAD(&item->li_ail);
+	INIT_LIST_HEAD(&item->li_cil);
 	INIT_LIST_HEAD(&item->li_bio_list);
+	INIT_LIST_HEAD(&item->li_trans);
 }   
 
 static struct xfs_buftarg *
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 695ed830..e40a3622 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -23,7 +23,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_extfree_item.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a2611aac..5f5b73c5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,7 +24,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "defer_item.h"
+#include "xfs_attr_item.h"
 #include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 96975f88..a9e38683 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -31,7 +31,7 @@
 #include "xfs_refcount.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_bmap_item.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 3e36865f..a5f3d68e 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -12,8 +12,12 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
 #include "xfs_inode.h"
+#include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_log_priv.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 5566f9fa..feea9d3d 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -20,7 +20,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_exchmaps_item.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 31c818f9..74224437 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -19,7 +19,10 @@
 #include "xfs_errortag.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_icreate_item.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index d82c3819..5307653e 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -24,7 +24,7 @@
 #include "xfs_defer.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
-#include "defer_item.h"
+#include "xfs_attr_item.h"
 #include "xfs_health.h"
 #include "xfs_attr_leaf.h"
 
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index bb9c3e23..e4e1d75b 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -56,6 +56,7 @@
 #include "libfrog/util.h"
 #include "atomic.h"
 #include "spinlock.h"
+#include "kernel_compat.h"
 #include "linux-err.h"
 
 #include "xfs_types.h"
@@ -143,7 +144,13 @@ extern char    *progname;
 #define xfs_stack_trace()		((void) 0)
 
 
-#define xfs_force_shutdown(d,n)		((void) 0)
+/*
+ * The kernel shuts the mount and the log down together.  Doing only half of it
+ * leaves the log looking healthy to xlog_is_shutdown(), which is what phase 2
+ * consults before it declares the log clean and retires it.
+ */
+#define xfs_force_shutdown(mp,f)	((void)xfs_set_shutdown(mp),	\
+					 xlog_force_shutdown((mp)->m_log, (f)))
 #define xfs_mod_delalloc(a,b,c)		((void) 0)
 #define xfs_mod_sb_delalloc(sb, d)	((void) 0)
 
@@ -155,12 +162,12 @@ extern char    *progname;
 } while (0)
 
 #define XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	do { \
-	(mp) = (mp); \
+	(void)(mp); \
 	cmn_err(CE_ALERT, "%s: XFS_CORRUPTION_ERROR", (e));  \
 } while (0)
 
 #define XFS_ERROR_REPORT(e,l,mp)	do { \
-	(mp) = (mp); \
+	(void)(mp); \
 	cmn_err(CE_ALERT, "%s: XFS_ERROR_REPORT", (e));  \
 } while (0)
 
@@ -454,9 +461,7 @@ static inline int retzero(void) { return 0; }
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
 
-#define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
-#define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
 
 #define xfs_zoned_add_available(mp, rtxnum)	do { } while (0)
 
@@ -499,10 +504,6 @@ void xfs_trans_del_item(struct xfs_log_item *);
 /* xfs_inode_item.c */
 void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 
-/* xfs_buf_item.c */
-void xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
-void xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
-
 /* xfs_trans_buf.c */
 struct xfs_buf *xfs_trans_buf_item_match(struct xfs_trans *,
 			struct xfs_buftarg *, struct xfs_buf_map *, int);
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 1d451607..e4b0a5cf 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -23,7 +23,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_refcount_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrefcount_btree.h"
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 9da10afe..e9094175 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -23,7 +23,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_rmap_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 9294b72e..cadd4471 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -20,7 +20,12 @@
 #include "xfs_quota_defs.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_trace.h"
-#include "defer_item.h"
+#include "xfs_attr_item.h"
+#include "xfs_defer.h"
+#include "xfs_bmap_item.h"
+#include "xfs_extfree_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
 
 #define _ALLOC	true
 #define _FREE	false
diff --git a/libxlog/Makefile b/libxlog/Makefile
index 49a67165..4ede4be8 100644
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -6,6 +6,18 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 LTLIBRARY = libxlog.la
+HFILES = xfs_bmap_item.h \
+	xfs_buf_item.h \
+	xfs_attr_item.h \
+	xfs_exchmaps_item.h \
+	xfs_extfree_item.h \
+	xfs_icreate_item.h \
+	xfs_inode_item.h \
+	xfs_refcount_item.h \
+	xfs_rmap_item.h \
+	xfs_log.h \
+	xfs_log_priv.h \
+	xfs_trans_priv.h
 LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
diff --git a/libxlog/logscan.c b/libxlog/logscan.c
index af72b97d..f9a580ca 100644
--- a/libxlog/logscan.c
+++ b/libxlog/logscan.c
@@ -6,7 +6,6 @@
 #include "libxfs.h"
 #include "libxlog.h"
 
-#define xfs_readonly_buftarg(buftarg)			(0)
 
 /* avoid set-but-unused var warning. gcc is not very bright. */
 #define xlog_clear_stale_blocks(log, taillsn)		({ \
@@ -69,7 +68,7 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	libxfs_buf_get_uncached(log->l_dev, nbblks, &bp);
+	libxfs_buf_get_uncached(log->l_targ, nbblks, &bp);
 	return bp;
 }
 
@@ -118,7 +117,7 @@ xlog_bread_noalign(
 	bp->b_length = nbblks;
 	bp->b_error = 0;
 
-	return libxfs_readbufr(log->l_dev, xfs_buf_daddr(bp), bp, nbblks, 0);
+	return libxfs_readbufr(log->l_targ, xfs_buf_daddr(bp), bp, nbblks, 0);
 }
 
 int
@@ -766,7 +765,7 @@ xlog_find_tail(
 	if (found == 2)
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
-	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
+	xlog_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
 	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
 	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
@@ -814,11 +813,16 @@ xlog_find_tail(
 			 * Set tail and last sync so that newly written
 			 * log records will point recovery to after the
 			 * current unmount record.
+			 *
+			 * Note that xlog_assign_atomic_lsn() is a no-op in
+			 * userspace, so neither of these actually takes
+			 * effect; xlog_last_sync_lsn keeps the value the
+			 * record header scan gave it.  Preserved as-is to
+			 * avoid changing what xfs_repair concludes about
+			 * the maximum metadata LSN.
 			 */
 			xlog_assign_atomic_lsn(&log->l_tail_lsn,
 					log->l_curr_cycle, after_umount_blk);
-			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
-					log->l_curr_cycle, after_umount_blk);
 			*tail_blk = after_umount_blk;
 		}
 	}
@@ -974,9 +978,8 @@ xlog_recover_find_tid(
 	xlog_tid_t		tid)
 {
 	struct xlog_recover	*trans;
-	struct hlist_node	*n;
 
-	hlist_for_each_entry(trans, n, head, r_list) {
+	hlist_for_each_entry(trans, head, r_list) {
 		if (trans->r_log_tid == tid)
 			return trans;
 	}
@@ -1329,18 +1332,6 @@ xlog_unpack_data_crc(
  * added for v2 logs.  Addressing for the cycles array there is off by one,
  * because the first batch of cycles is in the original header.
  */
-static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
-{
-	if (i >= XLOG_CYCLE_DATA_SIZE) {
-		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
-		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
-
-		return &rhead->h_ext[j - 1].xh_cycle_data[k];
-	}
-
-	return &rhead->h_cycle_data[i];
-}
-
 STATIC int
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
diff --git a/libxlog/util.c b/libxlog/util.c
index 3cfaeb51..1e5aeb89 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -11,6 +11,8 @@ int print_exit;
 int print_skip_uuid;
 int print_record_header;
 
+xfs_lsn_t	xlog_last_sync_lsn;
+
 void
 xlog_init(
 	struct xfs_mount	*mp,
@@ -20,23 +22,45 @@ xlog_init(
 
 	memset(log, 0, sizeof(*log));
 
-	log->l_dev = mp->m_logdev_targp;
+	log->l_targ = mp->m_logdev_targp;
 	log->l_logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	log->l_logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+	log->l_logsize = BBTOB(log->l_logBBsize);
 	if (xfs_has_sector(mp))
 		log_sect_size <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 	log->l_sectBBsize  = BTOBB(log_sect_size);
 	log->l_mp = mp;
+
+	/*
+	 * The rest of what xlog_alloc_log() sets up that matters to a log
+	 * that is only ever read and recovered, never written:
+	 * r_dfops collects the intent items recovery finds, and
+	 * XLOG_ACTIVE_RECOVERY marks the log as being recovered right now.
+	 * That is a different bit from XLOG_RECOVERY_NEEDED, which records
+	 * that a log was recovered and is set around the replay window by
+	 * xfs_repair.
+	 */
+	INIT_LIST_HEAD(&log->r_dfops);
+	set_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
+	log->l_covered_state = XLOG_STATE_COVER_IDLE;
+	log->l_prev_block = -1;
+	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
+	log->l_curr_cycle = 1;	/* 0 is bad since this is initial value */
+
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
+		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
+	else if (mp->m_sb.sb_logsectsize > 0)
+		log->l_iclog_roundoff = mp->m_sb.sb_logsectsize;
+	else
+		log->l_iclog_roundoff = BBSIZE;
+
 	if (xfs_has_sector(mp)) {
-		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
-		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
 		/* for larger sector sizes, must have v2 or external log */
-		ASSERT(log->l_sectbb_log == 0 ||
+		ASSERT(log->l_sectBBsize == 1 ||
 			log->l_logBBstart == 0 ||
 			xfs_has_logv2(mp));
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
-	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
 }
 
 /*
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 8e0589c1..6f37df20 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -532,7 +532,7 @@ xlog_print_trans_qoff(
  * (which can have different field alignments) to the native 64 bit version
  */
 struct xfs_inode_log_format *
-xfs_inode_item_format_convert(
+logprint_inode_item_format_convert(
 	char				*src_buf,
 	uint				len,
 	struct xfs_inode_log_format	*in_f)
@@ -652,7 +652,7 @@ xlog_print_trans_inode(
 		return f->ilf_size;
 	}
 
-	f = xfs_inode_item_format_convert((char*)&src_lbuf, len, &dst_lbuf);
+	f = logprint_inode_item_format_convert((char*)&src_lbuf, len, &dst_lbuf);
 	printf(_("INODE: "));
 	printf(_("#regs: %d   ino: 0x%llx  flags: 0x%x   dsize: %d\n"),
 		f->ilf_size,
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 5a01e049..08749e3f 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -291,7 +291,7 @@ xlog_recover_print_inode(
 
 	ASSERT(item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format_32) ||
 		item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format));
-	f = xfs_inode_item_format_convert(item->ri_buf[0].iov_base,
+	f = logprint_inode_item_format_convert(item->ri_buf[0].iov_base,
 					  item->ri_buf[0].iov_len, &f_buf);
 
 	printf(_("	INODE: #regs:%d   ino:0x%llx  flags:0x%x   dsize:%d\n"),
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 34df3400..2def581d 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -103,7 +103,7 @@ logstat(
 		log->l_logBBsize = s.st_size >> 9;
 		log->l_logBBstart = 0;
 		log->l_sectBBsize = BTOBB(BBSIZE);
-		log->l_dev = mp->m_logdev_targp;
+		log->l_targ = mp->m_logdev_targp;
 		log->l_mp = mp;
 	}
 
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 2ba868a9..ade7f443 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -35,7 +35,7 @@ extern bool is_printable(char* ptr, int len);
 extern void print_or_dump(char* ptr, int len);
 
 extern struct xfs_inode_log_format *
-	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
+	logprint_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
 
 extern int xlog_print_trans_efi(char **ptr, uint src_len, int continued);
 extern void xlog_recover_print_efi(struct xlog_recover_item *item);
diff --git a/repair/phase2.c b/repair/phase2.c
index fc96f9c4..e66ff316 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -89,7 +89,7 @@ zero_log(
 	 * filesystems.
 	 */
 	if (!no_modify && zap_log) {
-		libxfs_log_clear(log->l_dev, NULL,
+		libxfs_log_clear(log->l_targ, NULL,
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			&mp->m_sb.sb_uuid,
@@ -110,7 +110,7 @@ zero_log(
 	 * is a v5 filesystem.
 	 */
 	if (xfs_has_crc(mp))
-		libxfs_max_lsn = atomic64_read(&log->l_last_sync_lsn);
+		libxfs_max_lsn = xlog_last_sync_lsn;
 }
 
 static bool
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index dd758ebc..016795ee 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -794,7 +794,7 @@ format_log_max_lsn(
 	}
 
 	do_warn(_("Format log to cycle %d.\n"), new_cycle);
-	libxfs_log_clear(log->l_dev, NULL, logstart, logblocks,
+	libxfs_log_clear(log->l_targ, NULL, logstart, logblocks,
 			 &mp->m_sb.sb_uuid, logversion, mp->m_sb.sb_logsunit,
 			 XLOG_FMT, new_cycle, true);
 }
-- 
2.47.3

