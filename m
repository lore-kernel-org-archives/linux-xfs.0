Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931413AF676
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112190; cv=none; b=JvO7Se6+kornba6Hn9NIpedCCok3kpwR2VcI8zggf5z2wmZuEh+TVDNUDaGe18EwvzA2JgZqYsTTOWIuAGrSDsthGouqJYUb80Afh5SSwbhwzFLNJX7mGDfajsbw4N4HC4YzhwQ4V0XBJM7BHnZkEiAfuIrgcXmxgYytnPMcLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112190; c=relaxed/simple;
	bh=pNAzCZNuuwmWU1nUrMMJxvBvAL5UZnrPY4P6FoM+NN0=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=pib5EDVhJ+vPoaPNPwXxnfWY0qQGE1dr17SSKg1i/mnhcTPl75wLPiFU+bMOcY/NqdzUiXKvcuPiLVLaf3HoeJFQr56oBffWp0HQR3cDy+Ti4FSSecTsxkeQqHJ06FHbKUytTG83jsbHnREIyFlf35LSMvkfqAxT2reF9AviifM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=tMX00Rte; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="tMX00Rte"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04V5P3Hz6m4
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112170; bh=PXpRLdnBxBZqF8shpfQvYaFPQ6lvUeODn4lM83so1qg=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=tMX00RtekARHx1auYPZmpqDIYLO688hDwz+cg/YARjjg9ALacelmdgA+PPORW/bjT
	 TwphnGRrtbN4IIYVo5AT3sZQPUDM+V11dMFANkNejrWv6+CB3nZyGb1rAXOep0sdd0
	 SCGbA2wNTSZoOU2pBjExAFGMgSWCXc/u4/D7F52mPqAIbfkC9jk/fjjpHsLgTnuXxe
	 6nLQ9xUZPOfGQ2KTphBEEDHriDRH1KfJb3YBfMaA21/B6rwEFrqhVudVQpNoXWwayJ
	 yyiWWahTWtujiHyyEFScdNXaqDYjaWfxf402j0u137Z+YFQXGn8x0g4wOBda902Nrz
	 tuw5IXzdM+ggw==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04T1M7Sz9KVLH
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:29 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:29 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <49d9d6c177ed570d0ee5668df8a6d65ac3a27c6b.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Wed, 26 Aug 2026 22:09:03 -0700
Subject: [PATCH 5/9] libxlog: import the kernel's log recovery, log items and
 AIL
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfs_repair cannot replay a dirty log.  The code that can is in the
kernel, and xfsprogs already carries kernel code rather than
reimplementing it, so import it.

libxfs/ mirrors the kernel's fs/xfs/libxfs/ and these files are not from
there; they are from the top level of fs/xfs.  They go in libxlog/,
which is where this tree keeps log code, so that each directory has one
kernel counterpart and tools/libxfs-diff can check both.

The files are copied from Linux v7.1 and are byte-identical to their
kernel counterparts apart from their #include lists, which is the
adaptation libxfs has always used.  v7.1 is the kernel this tree's
libxfs/ is currently in sync with: comparing xfsprogs libxfs/ against
v7.1 reports no difference in any of 102 files, while against v7.2 it
reports 33.  Importing from a newer kernel than libxfs/ is synced to
would mix two kernel versions in one tree.

Nothing references these files yet and they are not in the build.  The
next patch wires them up.  Splitting it this way keeps the reviewable
change separate from fourteen thousand lines that should be read as
"the kernel's code, unchanged".
---
 include/kernel_compat.h          |  231 ++
 libxlog/xfs_attr_item.c          | 1206 ++++++++++
 libxlog/xfs_attr_item.h          |   64 +
 libxlog/xfs_bmap_item.c          |  718 ++++++
 libxlog/xfs_bmap_item.h          |   78 +
 libxlog/xfs_buf_item.h           |   71 +
 libxlog/xfs_buf_item_recover.c   | 1215 ++++++++++
 libxlog/xfs_dquot_item_recover.c |  214 ++
 libxlog/xfs_exchmaps_item.c      |  608 +++++
 libxlog/xfs_exchmaps_item.h      |   64 +
 libxlog/xfs_extfree_item.c       | 1026 +++++++++
 libxlog/xfs_extfree_item.h       |  100 +
 libxlog/xfs_icreate_item.c       |  260 +++
 libxlog/xfs_icreate_item.h       |   22 +
 libxlog/xfs_inode_item.h         |   62 +
 libxlog/xfs_inode_item_recover.c |  602 +++++
 libxlog/xfs_log.h                |  147 ++
 libxlog/xfs_log_priv.h           |  746 +++++++
 libxlog/xfs_log_recover.c        | 3575 ++++++++++++++++++++++++++++++
 libxlog/xfs_refcount_item.c      |  861 +++++++
 libxlog/xfs_refcount_item.h      |   82 +
 libxlog/xfs_rmap_item.c          |  890 ++++++++
 libxlog/xfs_rmap_item.h          |   81 +
 libxlog/xfs_trans_ail.c          |  978 ++++++++
 libxlog/xfs_trans_priv.h         |  170 ++
 25 files changed, 14071 insertions(+)
 create mode 100644 include/kernel_compat.h
 create mode 100644 libxlog/xfs_attr_item.c
 create mode 100644 libxlog/xfs_attr_item.h
 create mode 100644 libxlog/xfs_bmap_item.c
 create mode 100644 libxlog/xfs_bmap_item.h
 create mode 100644 libxlog/xfs_buf_item.h
 create mode 100644 libxlog/xfs_buf_item_recover.c
 create mode 100644 libxlog/xfs_dquot_item_recover.c
 create mode 100644 libxlog/xfs_exchmaps_item.c
 create mode 100644 libxlog/xfs_exchmaps_item.h
 create mode 100644 libxlog/xfs_extfree_item.c
 create mode 100644 libxlog/xfs_extfree_item.h
 create mode 100644 libxlog/xfs_icreate_item.c
 create mode 100644 libxlog/xfs_icreate_item.h
 create mode 100644 libxlog/xfs_inode_item.h
 create mode 100644 libxlog/xfs_inode_item_recover.c
 create mode 100644 libxlog/xfs_log.h
 create mode 100644 libxlog/xfs_log_priv.h
 create mode 100644 libxlog/xfs_log_recover.c
 create mode 100644 libxlog/xfs_refcount_item.c
 create mode 100644 libxlog/xfs_refcount_item.h
 create mode 100644 libxlog/xfs_rmap_item.c
 create mode 100644 libxlog/xfs_rmap_item.h
 create mode 100644 libxlog/xfs_trans_ail.c
 create mode 100644 libxlog/xfs_trans_priv.h

diff --git a/include/kernel_compat.h b/include/kernel_compat.h
new file mode 100644
index 00000000..0dbb2800
--- /dev/null
+++ b/include/kernel_compat.h
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Kernel infrastructure that xfs kernel sources refer to but which has no
+ * userspace equivalent.
+ *
+ * libxfs adapts kernel sources by rewriting their include list and nothing
+ * else, so the annotations, types and helpers those sources use have to be
+ * supplied from outside them.  Concurrency primitives collapse to no-ops
+ * because libxfs is single-threaded with respect to the log, and the
+ * deferred-work and I/O types only ever appear as struct members that
+ * userspace never schedules or submits.
+ *
+ * This header is included both by libxfs internals (via xfs_platform.h) and
+ * by the tools (via libxfs.h), because struct xlog embeds several of these
+ * types and the tools inspect struct xlog directly.
+ */
+#ifndef __LIBXFS_KERNEL_COMPAT_H__
+#define __LIBXFS_KERNEL_COMPAT_H__
+
+#ifndef ____cacheline_aligned_in_smp
+#define ____cacheline_aligned_in_smp
+#endif
+
+/* sparse annotations */
+#define __releases(x)
+#define __percpu
+
+typedef uint32_t	u32;
+
+struct work_struct { void *unused; };
+struct delayed_work { void *unused; };
+
+/*
+ * Types used only by the log write path (iclogs and the CIL).  libxfs
+ * replays a log but never writes one, so these only ever need to occupy
+ * space in a struct; nothing dereferences them.
+ */
+struct semaphore { void *unused; };
+struct rw_semaphore { void *unused; };
+struct bio { void *unused; };
+struct bio_vec { void *unused; };
+struct cpumask { void *unused; };
+struct xfs_busy_extents { void *unused; };
+struct xfs_kobj { void *unused; };
+
+/*
+ * xlog_wait() is on the log write path, which userspace never takes.  The
+ * task argument of DECLARE_WAITQUEUE() is unused here, so "current" itself
+ * is deliberately not defined - it is far too common an identifier to
+ * introduce as a macro into every tool that includes this header.
+ */
+#define DECLARE_WAITQUEUE(name, task)	int name __attribute__((unused))
+#define add_wait_queue_exclusive(wq, w)	((void)0)
+#define remove_wait_queue(wq, w)	((void)0)
+#define __set_current_state(state)	((void)0)
+#define set_current_state(state)	((void)0)
+#define TASK_UNINTERRUPTIBLE		0
+
+/*
+ * Function-like, so it only expands where it is actually called; unlike
+ * an object-like "current" this cannot capture unrelated identifiers.
+ */
+#define schedule()			((void)0)
+
+#define wait_var_event(var, cond)	((void)0)
+
+/*
+ * The AIL's pusher (xfsaild) is a kernel thread.  libxfs walks and
+ * updates the AIL directly and never starts a pusher, so the thread,
+ * freezer, scheduling and waitqueue primitives it uses are defined away
+ * here; the functions that call them compile but are not reachable from
+ * libxfs or the tools.
+ *
+ * NOTE: xfs_ail_push_all_sync() spins until the AIL drains, waking a
+ * pusher that does not exist in userspace, so it would not terminate if
+ * it were ever called.  Nothing in log recovery calls it - the callers
+ * are all in xfs_icache.c, xfs_log.c and xfs_mount.c, none of which
+ * libxfs carries - but do not introduce a caller without giving the AIL
+ * a synchronous push first.
+ */
+#define kthread_run(fn, data, fmt, ...)	((void *)NULL)
+#define kthread_should_stop()		(1)
+#define kthread_stop(tsk)		((void)0)
+#define set_freezable()			((void)0)
+#define try_to_freeze()			((void)0)
+#define memalloc_noreclaim_save()	(0)
+#define memalloc_noreclaim_restore(f)	((void)(f))
+#define msecs_to_jiffies(m)		(m)
+#define schedule_timeout(t)		((void)(t))
+#define init_waitqueue_head(wq)		((void)0)
+#define waitqueue_active(wq)		(0)
+#define wake_up_all(wq)			((void)0)
+#define wake_up_process(tsk)		((void)0)
+#define DEFINE_WAIT(name)		int name __attribute__((unused))
+#define prepare_to_wait(wq, w, state)	((void)0)
+#define finish_wait(wq, w)		((void)0)
+
+#define assert_spin_locked(l)		((void)0)
+#define lockdep_assert_held(l)		((void)0)
+#define list_empty_careful(l)		list_empty(l)
+
+/* xfs_alert_tag() drops the tag; libxfs has no per-tag panic mask. */
+#define XFS_PTAG_AILDELETE		0
+#define xfs_alert_tag(mp, tag, fmt, ...) xfs_alert(mp, fmt, ##__VA_ARGS__)
+
+/* libxfs submits delwri lists synchronously; there is no async variant. */
+#define xfs_buf_delwri_submit_nowait(list)	xfs_buf_delwri_submit(list)
+
+/*
+ * libxfs holds no buffer locks across threads the way the kernel does, so
+ * a trylock always succeeds.
+ *
+ * xfs_log_space_wake() and xlog_force_shutdown() are declared by the
+ * kernel's xfs_log.h and implemented for userspace in libxfs/logitem.c.
+ */
+#define xfs_buf_trylock(bp)			(xfs_buf_lock(bp), true)
+
+
+/*
+ * The kernel's refcount_t is a saturating wrapper around atomic_t with
+ * use-after-free detection.  libxfs is single-threaded with respect to
+ * these objects, so map it onto the atomic API it wraps.
+ */
+typedef atomic_t	refcount_t;
+
+#define refcount_set(r, n)		atomic_set((r), (n))
+#define refcount_inc_not_zero(r)	atomic_inc_not_zero(r)
+#define refcount_dec_and_test(r)	atomic_dec_and_test(r)
+
+/* Zoned realtime devices and logged xattrs are kernel-only features. */
+#define xfs_zone_free_blocks(tp, rtg, rtbno, len)	(-EOPNOTSUPP)
+/*
+ * The kernel tracks this as a mount opstate set when logged xattrs are
+ * enabled.  libxfs has no mount options, and a log that contains ATTRI
+ * items is itself proof that the filesystem was using them, so replay must
+ * accept them.  Deliberately true rather than accidentally so.
+ */
+#define xfs_is_using_logged_xattrs(mp)		(true)
+
+
+/* NOFS allocation scoping and sleeping have no userspace meaning. */
+#define memalloc_nofs_save()		(0)
+#define memalloc_nofs_restore(f)	((void)(f))
+#define msleep(ms)			((void)0)
+
+
+/* Block layer operation type, for the raw device I/O log recovery does. */
+typedef uint64_t	sector_t;
+
+enum req_op {
+	REQ_OP_READ,
+	REQ_OP_WRITE,
+};
+
+int xfs_rw_bdev(dev_t bdev, sector_t sector, unsigned int count, char *data,
+		enum req_op op);
+void libxfs_bdev_register(dev_t dev, int fd);
+
+/*
+ * Userspace has no inode cache to flush, no read-only device checks and no
+ * COW recovery, and never leaves the log dirty behind it.
+ */
+#define xfs_inodegc_flush(mp)			(0)
+#define xfs_dev_is_read_only(mp, msg)		(0)
+#define xfs_readonly_buftarg(btp)		(false)
+#define xfs_reflink_recover_cow(mp)		(0)
+#define xfs_set_clean(mp)			((void)0)
+#define xfs_notice_once(mp, fmt, ...)		xfs_notice(mp, fmt, ##__VA_ARGS__)
+#define xfs_buf_rele(bp)			libxfs_buf_rele(bp)
+
+
+/*
+ * Odds and ends the recovery sources reach for.
+ *
+ * m_logname and m_sb_bp are VFS-side mount state; libxfs keeps neither, so
+ * the log device has no name to print and the superblock buffer is read on
+ * demand.  m_logbsize is the in-core log buffer size, which userspace
+ * derives from the on-disk geometry.
+ */
+/*
+ * libxfs splits the read from the verification that the kernel does in one
+ * step, so do both.  The only caller is xlog_do_recover(), which re-reads the
+ * superblock after replay and whose own comment says it reverifies it; without
+ * the verifier a superblock that replay corrupted would be copied straight
+ * into mp->m_sb and repair would run against it.
+ */
+#define _xfs_buf_read(bp)						\
+({									\
+	int	__err = libxfs_readbufr((bp)->b_target,			\
+					xfs_buf_daddr(bp), (bp),	\
+					(bp)->b_length, 0);		\
+	__err ? __err : libxfs_readbuf_verify((bp), (bp)->b_ops);	\
+})
+
+#define xfs_iflags_clear(ip, flags)	((void)0)
+#define XFS_IRECOVERY			0
+
+#define SHUTDOWN_LOG_IO_ERROR		0x2
+#define SHUTDOWN_CORRUPT_INCORE		0x8
+
+/* Error injection knobs; userspace has none. */
+static const struct {
+	int	log_recovery_delay;
+	int	mount_delay;
+	int	always_cow;
+	int	pwork_threads;
+	int	larp;
+} xfs_globals;
+
+
+/* libxfs_iget() has no lock_flags argument. */
+#define xfs_iget(mp, tp, ino, flags, lock_flags, ipp) \
+	libxfs_iget((mp), (tp), (ino), (flags), (ipp))
+
+/* libuuid's uuid_is_null() takes the array, not a pointer to it. */
+#define uuid_is_null(u)			platform_uuid_is_null(u)
+
+/*
+ * libxfs takes no inode locks, but the kernel's xfs_exchrange_ilock() also
+ * joins the inodes to the transaction, which is load bearing.  Keep that
+ * half and drop only the locking.  A real function rather than a macro so
+ * the callers' locals do not look conditionally used.
+ */
+struct xfs_trans;
+struct xfs_inode;
+void xfs_exchrange_ilock(struct xfs_trans *tp, struct xfs_inode *ip1,
+		struct xfs_inode *ip2);
+
+#define xfs_exchrange_iunlock(ip1, ip2)		((void)0)
+
+#endif	/* __LIBXFS_KERNEL_COMPAT_H__ */
diff --git a/libxlog/xfs_attr_item.c b/libxlog/xfs_attr_item.c
new file mode 100644
index 00000000..9da3d688
--- /dev/null
+++ b/libxlog/xfs_attr_item.c
@@ -0,0 +1,1206 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Allison Henderson <allison.henderson@oracle.com>
+ */
+
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_attr_item.h"
+#include "xfs_trace.h"
+#include "xfs_trans_space.h"
+#include "xfs_errortag.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_parent.h"
+
+struct kmem_cache		*xfs_attri_cache;
+struct kmem_cache		*xfs_attrd_cache;
+
+static const struct xfs_item_ops xfs_attri_item_ops;
+static const struct xfs_item_ops xfs_attrd_item_ops;
+
+static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attri_log_item, attri_item);
+}
+
+/*
+ * Shared xattr name/value buffers for logged extended attribute operations
+ *
+ * When logging updates to extended attributes, we can create quite a few
+ * attribute log intent items for a single xattr update.  To avoid cycling the
+ * memory allocator and memcpy overhead, the name (and value, for setxattr)
+ * are kept in a refcounted object that is shared across all related log items
+ * and the upper-level deferred work state structure.  The shared buffer has
+ * a control structure, followed by the name, and then the value.
+ */
+
+static inline struct xfs_attri_log_nameval *
+xfs_attri_log_nameval_get(
+	struct xfs_attri_log_nameval	*nv)
+{
+	if (!refcount_inc_not_zero(&nv->refcount))
+		return NULL;
+	return nv;
+}
+
+static inline void
+xfs_attri_log_nameval_put(
+	struct xfs_attri_log_nameval	*nv)
+{
+	if (!nv)
+		return;
+	if (refcount_dec_and_test(&nv->refcount))
+		kvfree(nv);
+}
+
+static inline struct xfs_attri_log_nameval *
+xfs_attri_log_nameval_alloc(
+	const void			*name,
+	unsigned int			name_len,
+	const void			*new_name,
+	unsigned int			new_name_len,
+	const void			*value,
+	unsigned int			value_len,
+	const void			*new_value,
+	unsigned int			new_value_len)
+{
+	struct xfs_attri_log_nameval	*nv;
+
+	/*
+	 * This could be over 64kB in length, so we have to use kvmalloc() for
+	 * this. But kvmalloc() utterly sucks, so we use our own version.
+	 */
+	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
+					name_len + new_name_len + value_len +
+					new_value_len);
+
+	nv->name.iov_base = nv + 1;
+	nv->name.iov_len = name_len;
+	memcpy(nv->name.iov_base, name, name_len);
+
+	if (new_name_len) {
+		nv->new_name.iov_base = nv->name.iov_base + name_len;
+		nv->new_name.iov_len = new_name_len;
+		memcpy(nv->new_name.iov_base, new_name, new_name_len);
+	} else {
+		nv->new_name.iov_base = NULL;
+		nv->new_name.iov_len = 0;
+	}
+
+	if (value_len) {
+		nv->value.iov_base = nv->name.iov_base + name_len + new_name_len;
+		nv->value.iov_len = value_len;
+		memcpy(nv->value.iov_base, value, value_len);
+	} else {
+		nv->value.iov_base = NULL;
+		nv->value.iov_len = 0;
+	}
+
+	if (new_value_len) {
+		nv->new_value.iov_base = nv->name.iov_base + name_len +
+						new_name_len + value_len;
+		nv->new_value.iov_len = new_value_len;
+		memcpy(nv->new_value.iov_base, new_value, new_value_len);
+	} else {
+		nv->new_value.iov_base = NULL;
+		nv->new_value.iov_len = 0;
+	}
+
+	refcount_set(&nv->refcount, 1);
+	return nv;
+}
+
+STATIC void
+xfs_attri_item_free(
+	struct xfs_attri_log_item	*attrip)
+{
+	kvfree(attrip->attri_item.li_lv_shadow);
+	xfs_attri_log_nameval_put(attrip->attri_nameval);
+	kmem_cache_free(xfs_attri_cache, attrip);
+}
+
+/*
+ * Freeing the attrip requires that we remove it from the AIL if it has already
+ * been placed there. However, the ATTRI may not yet have been placed in the
+ * AIL when called by xfs_attri_release() from ATTRD processing due to the
+ * ordering of committed vs unpin operations in bulk insert operations. Hence
+ * the reference count to ensure only the last caller frees the ATTRI.
+ */
+STATIC void
+xfs_attri_release(
+	struct xfs_attri_log_item	*attrip)
+{
+	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
+	if (!atomic_dec_and_test(&attrip->attri_refcount))
+		return;
+
+	xfs_trans_ail_delete(&attrip->attri_item, 0);
+	xfs_attri_item_free(attrip);
+}
+
+STATIC void
+xfs_attri_item_size(
+	struct xfs_log_item		*lip,
+	int				*nvecs,
+	int				*nbytes)
+{
+	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
+	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
+
+	*nvecs += 2;
+	*nbytes += sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(nv->name.iov_len);
+
+	if (nv->new_name.iov_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->new_name.iov_len);
+	}
+
+	if (nv->value.iov_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.iov_len);
+	}
+
+	if (nv->new_value.iov_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->new_value.iov_len);
+	}
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attri log
+ * item. We use  1 iovec for the attri_format_item, 1 for the name, and
+ * another for the value if it is present
+ */
+STATIC void
+xfs_attri_item_format(
+	struct xfs_log_item		*lip,
+	struct xlog_format_buf		*lfb)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
+
+	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
+	attrip->attri_format.alfi_size = 1;
+
+	/*
+	 * This size accounting must be done before copying the attrip into the
+	 * iovec.  If we do it after, the wrong size will be recorded to the log
+	 * and we trip across assertion checks for bad region sizes later during
+	 * the log recovery.
+	 */
+
+	ASSERT(nv->name.iov_len > 0);
+	attrip->attri_format.alfi_size++;
+
+	if (nv->new_name.iov_len > 0)
+		attrip->attri_format.alfi_size++;
+
+	if (nv->value.iov_len > 0)
+		attrip->attri_format.alfi_size++;
+
+	if (nv->new_value.iov_len > 0)
+		attrip->attri_format.alfi_size++;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTRI_FORMAT, &attrip->attri_format,
+			sizeof(struct xfs_attri_log_format));
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NAME, nv->name.iov_base,
+			nv->name.iov_len);
+
+	if (nv->new_name.iov_len > 0)
+		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NEWNAME,
+				nv->new_name.iov_base, nv->new_name.iov_len);
+
+	if (nv->value.iov_len > 0)
+		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_VALUE,
+				nv->value.iov_base, nv->value.iov_len);
+
+	if (nv->new_value.iov_len > 0)
+		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NEWVALUE,
+				nv->new_value.iov_base, nv->new_value.iov_len);
+}
+
+/*
+ * The unpin operation is the last place an ATTRI is manipulated in the log. It
+ * is either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the ATTRI transaction has been successfully committed to make
+ * it this far. Therefore, we expect whoever committed the ATTRI to either
+ * construct and commit the ATTRD or drop the ATTRD's reference in the event of
+ * error. Simply drop the log's ATTRI reference now that the log is done with
+ * it.
+ */
+STATIC void
+xfs_attri_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+
+STATIC void
+xfs_attri_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+/*
+ * Allocate and initialize an attri item.  Caller may allocate an additional
+ * trailing buffer for name and value
+ */
+STATIC struct xfs_attri_log_item *
+xfs_attri_init(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_nameval	*nv)
+{
+	struct xfs_attri_log_item	*attrip;
+
+	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_KERNEL | __GFP_NOFAIL);
+
+	/*
+	 * Grab an extra reference to the name/value buffer for this log item.
+	 * The caller retains its own reference!
+	 */
+	attrip->attri_nameval = xfs_attri_log_nameval_get(nv);
+	ASSERT(attrip->attri_nameval);
+
+	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
+			  &xfs_attri_item_ops);
+	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
+	atomic_set(&attrip->attri_refcount, 2);
+
+	return attrip;
+}
+
+static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
+}
+
+STATIC void
+xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
+{
+	kvfree(attrdp->attrd_item.li_lv_shadow);
+	kmem_cache_free(xfs_attrd_cache, attrdp);
+}
+
+STATIC void
+xfs_attrd_item_size(
+	struct xfs_log_item		*lip,
+	int				*nvecs,
+	int				*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_attrd_log_format);
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attrd log item. We use
+ * only 1 iovec for the attrd_format, and we point that at the attr_log_format
+ * structure embedded in the attrd item.
+ */
+STATIC void
+xfs_attrd_item_format(
+	struct xfs_log_item		*lip,
+	struct xlog_format_buf		*lfb)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+
+	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
+	attrdp->attrd_format.alfd_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTRD_FORMAT,
+			&attrdp->attrd_format,
+			sizeof(struct xfs_attrd_log_format));
+}
+
+/*
+ * The ATTRD is either committed or aborted if the transaction is canceled. If
+ * the transaction is canceled, drop our reference to the ATTRI and free the
+ * ATTRD.
+ */
+STATIC void
+xfs_attrd_item_release(
+	struct xfs_log_item		*lip)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+
+	xfs_attri_release(attrdp->attrd_attrip);
+	xfs_attrd_item_free(attrdp);
+}
+
+static struct xfs_log_item *
+xfs_attrd_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &ATTRD_ITEM(lip)->attrd_attrip->attri_item;
+}
+
+static inline unsigned int
+xfs_attr_log_item_op(const struct xfs_attri_log_format *attrp)
+{
+	return attrp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_attri_log_item	*attrip,
+	const struct xfs_attr_intent	*attr)
+{
+	struct xfs_attri_log_format	*attrp;
+	struct xfs_attri_log_nameval	*nv = attr->xattri_nameval;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+
+	/*
+	 * At this point the xfs_attr_intent has been constructed, and we've
+	 * created the log intent. Fill in the attri log item and log format
+	 * structure with fields from this xfs_attr_intent
+	 */
+	attrp = &attrip->attri_format;
+	attrp->alfi_ino = args->dp->i_ino;
+	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
+	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_value_len = nv->value.iov_len;
+
+	switch (xfs_attr_log_item_op(attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		ASSERT(nv->value.iov_len == nv->new_value.iov_len);
+
+		attrp->alfi_igen = VFS_I(args->dp)->i_generation;
+		attrp->alfi_old_name_len = nv->name.iov_len;
+		attrp->alfi_new_name_len = nv->new_name.iov_len;
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+		attrp->alfi_igen = VFS_I(args->dp)->i_generation;
+		fallthrough;
+	default:
+		attrp->alfi_name_len = nv->name.iov_len;
+		break;
+	}
+
+	ASSERT(!(args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
+	attrp->alfi_attr_filter = args->attr_filter;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attr_intent		*attr;
+	struct xfs_da_args		*args;
+
+	ASSERT(count == 1);
+
+	/*
+	 * Each attr item only performs one attribute operation at a time, so
+	 * this is a list of one
+	 */
+	attr = list_first_entry_or_null(items, struct xfs_attr_intent,
+			xattri_list);
+	args = attr->xattri_da_args;
+
+	if (!(args->op_flags & XFS_DA_OP_LOGGED))
+		return NULL;
+
+	/*
+	 * Create a buffer to store the attribute name and value.  This buffer
+	 * will be shared between the higher level deferred xattr work state
+	 * and the lower level xattr log items.
+	 */
+	if (!attr->xattri_nameval) {
+		/*
+		 * Transfer our reference to the name/value buffer to the
+		 * deferred work state structure.
+		 */
+		attr->xattri_nameval = xfs_attri_log_nameval_alloc(
+				args->name, args->namelen,
+				args->new_name, args->new_namelen,
+				args->value, args->valuelen,
+				args->new_value, args->new_valuelen);
+	}
+
+	attrip = xfs_attri_init(mp, attr->xattri_nameval);
+	xfs_attr_log_item(tp, attrip, attr);
+
+	return &attrip->attri_item;
+}
+
+static inline void
+xfs_attr_free_item(
+	struct xfs_attr_intent		*attr)
+{
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
+	xfs_attri_log_nameval_put(attr->xattri_nameval);
+	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
+		kfree(attr);
+	else
+		kmem_cache_free(xfs_attr_intent_cache, attr);
+}
+
+static inline struct xfs_attr_intent *attri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_attr_intent, xattri_list);
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_intent		*attr = attri_entry(item);
+	struct xfs_da_args		*args;
+	int				error;
+
+	args = attr->xattri_da_args;
+
+	/* Reset trans after EAGAIN cycle since the transaction is new */
+	args->trans = tp;
+
+	if (XFS_TEST_ERROR(args->dp->i_mount, XFS_ERRTAG_LARP)) {
+		error = -EIO;
+		goto out;
+	}
+
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
+	error = xfs_attr_set_iter(attr);
+	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
+		return -EAGAIN;
+
+out:
+	xfs_attr_free_item(attr);
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_attri_release(ATTRI_ITEM(intent));
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_intent		*attr = attri_entry(item);
+
+	xfs_attr_free_item(attr);
+}
+
+STATIC bool
+xfs_attri_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
+}
+
+static inline bool
+xfs_attri_validate_namelen(unsigned int namelen)
+{
+	return namelen > 0 && namelen <= XATTR_NAME_MAX;
+}
+
+/* Is this recovered ATTRI format ok? */
+static inline bool
+xfs_attri_validate(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format	*attrp)
+{
+	unsigned int			op = xfs_attr_log_item_op(attrp);
+
+	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
+		return false;
+
+	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
+		return false;
+
+	if (!xfs_attr_check_namespace(attrp->alfi_attr_filter &
+				      XFS_ATTR_NSP_ONDISK_MASK))
+		return false;
+
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+		if (!xfs_has_parent(mp))
+			return false;
+		if (attrp->alfi_value_len != sizeof(struct xfs_parent_rec))
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
+			return false;
+		if (!(attrp->alfi_attr_filter & XFS_ATTR_PARENT))
+			return false;
+		break;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (!xfs_is_using_logged_xattrs(mp))
+			return false;
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
+			return false;
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (!xfs_is_using_logged_xattrs(mp))
+			return false;
+		if (attrp->alfi_value_len != 0)
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
+			return false;
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		if (!xfs_has_parent(mp))
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_old_name_len))
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_new_name_len))
+			return false;
+		if (attrp->alfi_value_len != sizeof(struct xfs_parent_rec))
+			return false;
+		if (!(attrp->alfi_attr_filter & XFS_ATTR_PARENT))
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return xfs_verify_ino(mp, attrp->alfi_ino);
+}
+
+static int
+xfs_attri_iread_extents(
+	struct xfs_inode		*ip)
+{
+	struct xfs_trans		*tp;
+	int				error;
+
+	tp = xfs_trans_alloc_empty(ip->i_mount);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_iread_extents(tp, ip, XFS_ATTR_FORK);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_cancel(tp);
+
+	return error;
+}
+
+static inline struct xfs_attr_intent *
+xfs_attri_recover_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	struct xfs_attri_log_format	*attrp,
+	struct xfs_inode		**ipp,
+	struct xfs_attri_log_nameval	*nv)
+{
+	struct xfs_attr_intent		*attr;
+	struct xfs_da_args		*args;
+	struct xfs_inode		*ip;
+	int				local;
+	int				error;
+
+	/*
+	 * Parent pointer attr items record the generation but regular logged
+	 * xattrs do not; select the right iget function.
+	 */
+	switch (xfs_attr_log_item_op(attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+		error = xlog_recover_iget_handle(mp, attrp->alfi_ino,
+				attrp->alfi_igen, &ip);
+		break;
+	default:
+		error = xlog_recover_iget(mp, attrp->alfi_ino, &ip);
+		break;
+	}
+	if (error) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
+				sizeof(*attrp));
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
+	if (xfs_inode_has_attr_fork(ip)) {
+		error = xfs_attri_iread_extents(ip);
+		if (error) {
+			xfs_irele(ip);
+			return ERR_PTR(error);
+		}
+	}
+
+	attr = kzalloc(sizeof(struct xfs_attr_intent) +
+			sizeof(struct xfs_da_args), GFP_KERNEL | __GFP_NOFAIL);
+	args = (struct xfs_da_args *)(attr + 1);
+
+	attr->xattri_da_args = args;
+	attr->xattri_op_flags = xfs_attr_log_item_op(attrp);
+
+	/*
+	 * We're reconstructing the deferred work state structure from the
+	 * recovered log item.  Grab a reference to the name/value buffer and
+	 * attach it to the new work state.
+	 */
+	attr->xattri_nameval = xfs_attri_log_nameval_get(nv);
+	ASSERT(attr->xattri_nameval);
+
+	args->dp = ip;
+	args->geo = mp->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->name = nv->name.iov_base;
+	args->namelen = nv->name.iov_len;
+	args->new_name = nv->new_name.iov_base;
+	args->new_namelen = nv->new_name.iov_len;
+	args->value = nv->value.iov_base;
+	args->valuelen = nv->value.iov_len;
+	args->new_value = nv->new_value.iov_base;
+	args->new_valuelen = nv->new_value.iov_len;
+	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
+	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
+			 XFS_DA_OP_LOGGED;
+	args->owner = args->dp->i_ino;
+	xfs_attr_sethash(args);
+
+	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		args->total = xfs_attr_calc_size(args, &local);
+		if (xfs_inode_hasattr(args->dp))
+			attr->xattri_dela_state = xfs_attr_init_replace_state(args);
+		else
+			attr->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	}
+
+	xfs_defer_add_item(dfp, &attr->xattri_list);
+	*ipp = ip;
+	return attr;
+}
+
+/*
+ * Process an attr intent item that was recovered from the log.  We need to
+ * delete the attr that it describes.
+ */
+STATIC int
+xfs_attr_recover_work(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	struct xfs_log_item		*lip = dfp->dfp_intent;
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_attr_intent		*attr;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_da_args		*args;
+	struct xfs_trans		*tp;
+	struct xfs_trans_res		resv;
+	struct xfs_attri_log_format	*attrp;
+	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
+	int				error;
+	unsigned int			total = 0;
+
+	/*
+	 * First check the validity of the attr described by the ATTRI.  If any
+	 * are bad, then assume that all are bad and just toss the ATTRI.
+	 */
+	attrp = &attrip->attri_format;
+	if (!xfs_attri_validate(mp, attrp) ||
+	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.iov_base,
+				nv->name.iov_len))
+		return -EFSCORRUPTED;
+
+	attr = xfs_attri_recover_work(mp, dfp, attrp, &ip, nv);
+	if (IS_ERR(attr))
+		return PTR_ERR(attr);
+	args = attr->xattri_da_args;
+
+	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		resv = xfs_attr_set_resv(args);
+		total = args->total;
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		resv = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+		break;
+	}
+	resv = xlog_recover_resv(&resv);
+	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+	args->trans = tp;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	error = xlog_recover_finish_intent(tp, dfp);
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&attrip->attri_format,
+				sizeof(attrip->attri_format));
+	if (error)
+		goto out_cancel;
+
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+	return error;
+out_cancel:
+	xfs_trans_cancel(tp);
+	goto out_unlock;
+}
+
+/* Re-log an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_attr_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_attri_log_item	*old_attrip;
+	struct xfs_attri_log_item	*new_attrip;
+	struct xfs_attri_log_format	*new_attrp;
+	struct xfs_attri_log_format	*old_attrp;
+
+	old_attrip = ATTRI_ITEM(intent);
+	old_attrp = &old_attrip->attri_format;
+
+	/*
+	 * Create a new log item that shares the same name/value buffer as the
+	 * old log item.
+	 */
+	new_attrip = xfs_attri_init(tp->t_mountp, old_attrip->attri_nameval);
+	new_attrp = &new_attrip->attri_format;
+
+	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_igen = old_attrp->alfi_igen;
+	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
+	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
+
+	switch (xfs_attr_log_item_op(old_attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		new_attrp->alfi_new_name_len = old_attrp->alfi_new_name_len;
+		new_attrp->alfi_old_name_len = old_attrp->alfi_old_name_len;
+		break;
+	default:
+		new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+		break;
+	}
+
+	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
+
+	return &new_attrip->attri_item;
+}
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attrd_log_item	*attrdp;
+
+	attrip = ATTRI_ITEM(intent);
+
+	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_KERNEL | __GFP_NOFAIL);
+
+	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	return &attrdp->attrd_item;
+}
+
+void
+xfs_attr_defer_add(
+	struct xfs_da_args	*args,
+	enum xfs_attr_defer_op	op)
+{
+	struct xfs_attr_intent	*new;
+	unsigned int		log_op = 0;
+	bool			is_pptr = args->attr_filter & XFS_ATTR_PARENT;
+
+	if (is_pptr) {
+		ASSERT(xfs_has_parent(args->dp->i_mount));
+		ASSERT((args->attr_filter & ~XFS_ATTR_PARENT) == 0);
+		ASSERT(args->op_flags & XFS_DA_OP_LOGGED);
+		ASSERT(args->valuelen == sizeof(struct xfs_parent_rec));
+	}
+
+	new = kmem_cache_zalloc(xfs_attr_intent_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	new->xattri_da_args = args;
+
+	/* Compute log operation from the higher level op and namespace. */
+	switch (op) {
+	case XFS_ATTR_DEFER_SET:
+		if (is_pptr)
+			log_op = XFS_ATTRI_OP_FLAGS_PPTR_SET;
+		else
+			log_op = XFS_ATTRI_OP_FLAGS_SET;
+		break;
+	case XFS_ATTR_DEFER_REPLACE:
+		if (is_pptr)
+			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REPLACE;
+		else
+			log_op = XFS_ATTRI_OP_FLAGS_REPLACE;
+		break;
+	case XFS_ATTR_DEFER_REMOVE:
+		if (is_pptr)
+			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REMOVE;
+		else
+			log_op = XFS_ATTRI_OP_FLAGS_REMOVE;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	new->xattri_op_flags = log_op;
+
+	/* Set up initial attr operation state. */
+	switch (log_op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_SET:
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		ASSERT(args->new_valuelen == args->valuelen);
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		new->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	}
+
+	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
+	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.name		= "attr",
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+	.recover_work	= xfs_attr_recover_work,
+	.relog_intent	= xfs_attr_relog_intent,
+};
+
+static inline void *
+xfs_attri_validate_name_iovec(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format     *attri_formatp,
+	const struct kvec		*iovec,
+	unsigned int			name_len)
+{
+	if (iovec->iov_len != xlog_calc_iovec_len(name_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		return NULL;
+	}
+
+	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, iovec->iov_base,
+				name_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				iovec->iov_base, iovec->iov_len);
+		return NULL;
+	}
+
+	return iovec->iov_base;
+}
+
+static inline void *
+xfs_attri_validate_value_iovec(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format     *attri_formatp,
+	const struct kvec		*iovec,
+	unsigned int			value_len)
+{
+	if (iovec->iov_len != xlog_calc_iovec_len(value_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		return NULL;
+	}
+
+	if ((attri_formatp->alfi_attr_filter & XFS_ATTR_PARENT) &&
+	    !xfs_parent_valuecheck(mp, iovec->iov_base, value_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				iovec->iov_base, iovec->iov_len);
+		return NULL;
+	}
+
+	return iovec->iov_base;
+}
+
+STATIC int
+xlog_recover_attri_commit_pass2(
+	struct xlog                     *log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item        *item,
+	xfs_lsn_t                       lsn)
+{
+	struct xfs_mount                *mp = log->l_mp;
+	struct xfs_attri_log_item       *attrip;
+	struct xfs_attri_log_format     *attri_formatp;
+	struct xfs_attri_log_nameval	*nv;
+	const void			*attr_name;
+	const void			*attr_value = NULL;
+	const void			*attr_new_name = NULL;
+	const void			*attr_new_value = NULL;
+	size_t				len;
+	unsigned int			name_len = 0;
+	unsigned int			value_len = 0;
+	unsigned int			new_name_len = 0;
+	unsigned int			new_value_len = 0;
+	unsigned int			op, i = 0;
+
+	/* Validate xfs_attri_log_format before the large memory allocation */
+	len = sizeof(struct xfs_attri_log_format);
+	if (item->ri_buf[i].iov_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	attri_formatp = item->ri_buf[i].iov_base;
+	if (!xfs_attri_validate(mp, attri_formatp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = xfs_attr_log_item_op(attri_formatp);
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
+		break;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, optional attr value */
+		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_name_len;
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		/*
+		 * Log item, attr name, new attr name, attr value, new attr
+		 * value
+		 */
+		if (item->ri_total != 5) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_old_name_len;
+		new_name_len = attri_formatp->alfi_new_name_len;
+		new_value_len = value_len = attri_formatp->alfi_value_len;
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+	i++;
+
+	/* Validate the attr name */
+	attr_name = xfs_attri_validate_name_iovec(mp, attri_formatp,
+			&item->ri_buf[i], name_len);
+	if (!attr_name)
+		return -EFSCORRUPTED;
+	i++;
+
+	/* Validate the new attr name */
+	if (new_name_len > 0) {
+		attr_new_name = xfs_attri_validate_name_iovec(mp,
+					attri_formatp, &item->ri_buf[i],
+					new_name_len);
+		if (!attr_new_name)
+			return -EFSCORRUPTED;
+		i++;
+	}
+
+	/* Validate the attr value, if present */
+	if (value_len != 0) {
+		attr_value = xfs_attri_validate_value_iovec(mp, attri_formatp,
+				&item->ri_buf[i], value_len);
+		if (!attr_value)
+			return -EFSCORRUPTED;
+		i++;
+	}
+
+	/* Validate the new attr value, if present */
+	if (new_value_len != 0) {
+		attr_new_value = xfs_attri_validate_value_iovec(mp,
+					attri_formatp, &item->ri_buf[i],
+					new_value_len);
+		if (!attr_new_value)
+			return -EFSCORRUPTED;
+		i++;
+	}
+
+	/*
+	 * Make sure we got the correct number of buffers for the operation
+	 * that we just loaded.
+	 */
+	if (i != item->ri_total) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Memory alloc failure will cause replay to abort.  We attach the
+	 * name/value buffer to the recovered incore log item and drop our
+	 * reference.
+	 */
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
+			attr_new_name, new_name_len,
+			attr_value, value_len,
+			attr_new_value, new_value_len);
+
+	attrip = xfs_attri_init(mp, nv);
+	memcpy(&attrip->attri_format, attri_formatp, len);
+
+	xlog_recover_intent_item(log, &attrip->attri_item, lsn,
+			&xfs_attr_defer_type);
+	xfs_attri_log_nameval_put(nv);
+	return 0;
+}
+
+/*
+ * This routine is called when an ATTRD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
+ * it was still in the log. To do this it searches the AIL for the ATTRI with
+ * an id equal to that in the ATTRD format structure. If we find it we drop
+ * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_attrd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_attrd_log_format	*attrd_formatp;
+
+	attrd_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_attrd_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_ATTRI,
+				    attrd_formatp->alfd_alf_id);
+	return 0;
+}
+
+static const struct xfs_item_ops xfs_attri_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
+	.iop_size	= xfs_attri_item_size,
+	.iop_format	= xfs_attri_item_format,
+	.iop_unpin	= xfs_attri_item_unpin,
+	.iop_release    = xfs_attri_item_release,
+	.iop_match	= xfs_attri_item_match,
+};
+
+const struct xlog_recover_item_ops xlog_attri_item_ops = {
+	.item_type	= XFS_LI_ATTRI,
+	.commit_pass2	= xlog_recover_attri_commit_pass2,
+};
+
+static const struct xfs_item_ops xfs_attrd_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
+	.iop_size	= xfs_attrd_item_size,
+	.iop_format	= xfs_attrd_item_format,
+	.iop_release    = xfs_attrd_item_release,
+	.iop_intent	= xfs_attrd_item_intent,
+};
+
+const struct xlog_recover_item_ops xlog_attrd_item_ops = {
+	.item_type	= XFS_LI_ATTRD,
+	.commit_pass2	= xlog_recover_attrd_commit_pass2,
+};
diff --git a/libxlog/xfs_attr_item.h b/libxlog/xfs_attr_item.h
new file mode 100644
index 00000000..d108a11b
--- /dev/null
+++ b/libxlog/xfs_attr_item.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Allison Henderson <allison.henderson@oracle.com>
+ */
+#ifndef	__XFS_ATTR_ITEM_H__
+#define	__XFS_ATTR_ITEM_H__
+
+/* kernel only ATTRI/ATTRD definitions */
+
+struct xfs_mount;
+struct kmem_zone;
+
+struct xfs_attri_log_nameval {
+	struct kvec		name;
+	struct kvec		new_name;	/* PPTR_REPLACE only */
+	struct kvec		value;
+	struct kvec		new_value;	/* PPTR_REPLACE only */
+	refcount_t		refcount;
+
+	/* name and value follow the end of this struct */
+};
+
+/*
+ * This is the "attr intention" log item.  It is used to log the fact that some
+ * extended attribute operations need to be processed.  An operation is
+ * currently either a set or remove.  Set or remove operations are described by
+ * the xfs_attr_intent which may be logged to this intent.
+ *
+ * During a normal attr operation, name and value point to the name and value
+ * fields of the caller's xfs_da_args structure.  During a recovery, the name
+ * and value buffers are copied from the log, and stored in a trailing buffer
+ * attached to the xfs_attr_intent until they are committed.  They are freed
+ * when the xfs_attr_intent itself is freed when the work is done.
+ */
+struct xfs_attri_log_item {
+	struct xfs_log_item		attri_item;
+	atomic_t			attri_refcount;
+	struct xfs_attri_log_nameval	*attri_nameval;
+	struct xfs_attri_log_format	attri_format;
+};
+
+/*
+ * This is the "attr done" log item.  It is used to log the fact that some attrs
+ * earlier mentioned in an attri item have been freed.
+ */
+struct xfs_attrd_log_item {
+	struct xfs_log_item		attrd_item;
+	struct xfs_attri_log_item	*attrd_attrip;
+	struct xfs_attrd_log_format	attrd_format;
+};
+
+extern struct kmem_cache	*xfs_attri_cache;
+extern struct kmem_cache	*xfs_attrd_cache;
+
+enum xfs_attr_defer_op {
+	XFS_ATTR_DEFER_SET,
+	XFS_ATTR_DEFER_REMOVE,
+	XFS_ATTR_DEFER_REPLACE,
+};
+
+void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
+
+#endif	/* __XFS_ATTR_ITEM_H__ */
diff --git a/libxlog/xfs_bmap_item.c b/libxlog/xfs_bmap_item.c
new file mode 100644
index 00000000..259a4921
--- /dev/null
+++ b/libxlog/xfs_bmap_item.c
@@ -0,0 +1,718 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_bmap_item.h"
+#include "xfs_log.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_ag.h"
+#include "xfs_trace.h"
+
+struct kmem_cache	*xfs_bui_cache;
+struct kmem_cache	*xfs_bud_cache;
+
+static const struct xfs_item_ops xfs_bui_item_ops;
+
+static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_bui_log_item, bui_item);
+}
+
+STATIC void
+xfs_bui_item_free(
+	struct xfs_bui_log_item	*buip)
+{
+	kvfree(buip->bui_item.li_lv_shadow);
+	kmem_cache_free(xfs_bui_cache, buip);
+}
+
+/*
+ * Freeing the BUI requires that we remove it from the AIL if it has already
+ * been placed there. However, the BUI may not yet have been placed in the AIL
+ * when called by xfs_bui_release() from BUD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the BUI.
+ */
+STATIC void
+xfs_bui_release(
+	struct xfs_bui_log_item	*buip)
+{
+	ASSERT(atomic_read(&buip->bui_refcount) > 0);
+	if (!atomic_dec_and_test(&buip->bui_refcount))
+		return;
+
+	xfs_trans_ail_delete(&buip->bui_item, 0);
+	xfs_bui_item_free(buip);
+}
+
+
+STATIC void
+xfs_bui_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents);
+}
+
+unsigned int xfs_bui_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_bui_log_format_sizeof(nr));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given bui log item. We use only 1 iovec, and we point that
+ * at the bui_log_format structure embedded in the bui item.
+ * It is at this point that we assert that all of the extent
+ * slots in the bui item have been filled.
+ */
+STATIC void
+xfs_bui_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
+
+	ASSERT(atomic_read(&buip->bui_next_extent) ==
+			buip->bui_format.bui_nextents);
+
+	buip->bui_format.bui_type = XFS_LI_BUI;
+	buip->bui_format.bui_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_BUI_FORMAT, &buip->bui_format,
+			xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents));
+}
+
+/*
+ * The unpin operation is the last place an BUI is manipulated in the log. It is
+ * either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the BUI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the BUI to either construct
+ * and commit the BUD or drop the BUD's reference in the event of error. Simply
+ * drop the log's BUI reference now that the log is done with it.
+ */
+STATIC void
+xfs_bui_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
+
+	xfs_bui_release(buip);
+}
+
+/*
+ * The BUI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an BUD isn't going to be
+ * constructed and thus we free the BUI here directly.
+ */
+STATIC void
+xfs_bui_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_bui_release(BUI_ITEM(lip));
+}
+
+/*
+ * Allocate and initialize an bui item with the given number of extents.
+ */
+STATIC struct xfs_bui_log_item *
+xfs_bui_init(
+	struct xfs_mount		*mp)
+
+{
+	struct xfs_bui_log_item		*buip;
+
+	buip = kmem_cache_zalloc(xfs_bui_cache, GFP_KERNEL | __GFP_NOFAIL);
+
+	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
+	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
+	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
+	atomic_set(&buip->bui_next_extent, 0);
+	atomic_set(&buip->bui_refcount, 2);
+
+	return buip;
+}
+
+static inline struct xfs_bud_log_item *BUD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_bud_log_item, bud_item);
+}
+
+STATIC void
+xfs_bud_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_bud_log_format);
+}
+
+unsigned int xfs_bud_log_space(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_bud_log_format));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given bud log item. We use only 1 iovec, and we point that
+ * at the bud_log_format structure embedded in the bud item.
+ * It is at this point that we assert that all of the extent
+ * slots in the bud item have been filled.
+ */
+STATIC void
+xfs_bud_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
+
+	budp->bud_format.bud_type = XFS_LI_BUD;
+	budp->bud_format.bud_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_BUD_FORMAT, &budp->bud_format,
+			sizeof(struct xfs_bud_log_format));
+}
+
+/*
+ * The BUD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the BUI and free the
+ * BUD.
+ */
+STATIC void
+xfs_bud_item_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
+
+	xfs_bui_release(budp->bud_buip);
+	kvfree(budp->bud_item.li_lv_shadow);
+	kmem_cache_free(xfs_bud_cache, budp);
+}
+
+static struct xfs_log_item *
+xfs_bud_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &BUD_ITEM(lip)->bud_buip->bui_item;
+}
+
+static const struct xfs_item_ops xfs_bud_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
+	.iop_size	= xfs_bud_item_size,
+	.iop_format	= xfs_bud_item_format,
+	.iop_release	= xfs_bud_item_release,
+	.iop_intent	= xfs_bud_item_intent,
+};
+
+static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_bmap_intent, bi_list);
+}
+
+/* Sort bmap intents by inode. */
+static int
+xfs_bmap_update_diff_items(
+	void				*priv,
+	const struct list_head		*a,
+	const struct list_head		*b)
+{
+	struct xfs_bmap_intent		*ba = bi_entry(a);
+	struct xfs_bmap_intent		*bb = bi_entry(b);
+
+	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
+}
+
+/* Log bmap updates in the intent item. */
+STATIC void
+xfs_bmap_update_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_bui_log_item		*buip,
+	struct xfs_bmap_intent		*bi)
+{
+	uint				next_extent;
+	struct xfs_map_extent		*map;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
+	ASSERT(next_extent < buip->bui_format.bui_nextents);
+	map = &buip->bui_format.bui_extents[next_extent];
+	map->me_owner = bi->bi_owner->i_ino;
+	map->me_startblock = bi->bi_bmap.br_startblock;
+	map->me_startoff = bi->bi_bmap.br_startoff;
+	map->me_len = bi->bi_bmap.br_blockcount;
+
+	switch (bi->bi_type) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		map->me_flags = bi->bi_type;
+		break;
+	default:
+		ASSERT(0);
+	}
+	if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
+	if (bi->bi_whichfork == XFS_ATTR_FORK)
+		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		map->me_flags |= XFS_BMAP_EXTENT_REALTIME;
+}
+
+static struct xfs_log_item *
+xfs_bmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_bui_log_item		*buip = xfs_bui_init(mp);
+	struct xfs_bmap_intent		*bi;
+
+	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
+
+	if (sort)
+		list_sort(mp, items, xfs_bmap_update_diff_items);
+	list_for_each_entry(bi, items, bi_list)
+		xfs_bmap_update_log_item(tp, buip, bi);
+	return &buip->bui_item;
+}
+
+/* Get an BUD so we can process all the deferred bmap updates. */
+static struct xfs_log_item *
+xfs_bmap_update_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	struct xfs_bui_log_item		*buip = BUI_ITEM(intent);
+	struct xfs_bud_log_item		*budp;
+
+	budp = kmem_cache_zalloc(xfs_bud_cache, GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
+			  &xfs_bud_item_ops);
+	budp->bud_buip = buip;
+	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
+
+	return &budp->bud_item;
+}
+
+/* Take a passive ref to the group containing the space we're mapping. */
+static inline void
+xfs_bmap_update_get_group(
+	struct xfs_mount	*mp,
+	struct xfs_bmap_intent	*bi)
+{
+	enum xfs_group_type	type = XG_TYPE_AG;
+
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		type = XG_TYPE_RTG;
+
+	/*
+	 * Bump the intent count on behalf of the deferred rmap and refcount
+	 * intent items that that we can queue when we finish this bmap work.
+	 * This new intent item will bump the intent count before the bmap
+	 * intent drops the intent count, ensuring that the intent count
+	 * remains nonzero across the transaction roll.
+	 */
+	bi->bi_group = xfs_group_intent_get(mp, bi->bi_bmap.br_startblock,
+				type);
+}
+
+/* Add this deferred BUI to the transaction. */
+void
+xfs_bmap_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_bmap_intent	*bi)
+{
+	xfs_bmap_update_get_group(tp->t_mountp, bi);
+
+	/*
+	 * Ensure the deferred mapping is pre-recorded in i_delayed_blks.
+	 *
+	 * Otherwise stat can report zero blocks for an inode that actually has
+	 * data when the entire mapping is in the process of being overwritten
+	 * using the out of place write path. This is undone in xfs_bmapi_remap
+	 * after it has incremented di_nblocks for a successful operation.
+	 */
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
+
+	trace_xfs_bmap_defer(bi);
+	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
+}
+
+/* Cancel a deferred bmap update. */
+STATIC void
+xfs_bmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bi = bi_entry(item);
+
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
+
+	xfs_group_intent_put(bi->bi_group);
+	kmem_cache_free(xfs_bmap_intent_cache, bi);
+}
+
+/* Process a deferred bmap update. */
+STATIC int
+xfs_bmap_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_bmap_intent		*bi = bi_entry(item);
+	int				error;
+
+	error = xfs_bmap_finish_one(tp, bi);
+	if (!error && bi->bi_bmap.br_blockcount > 0) {
+		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
+		return -EAGAIN;
+	}
+
+	xfs_bmap_update_cancel_item(item);
+	return error;
+}
+
+/* Abort all pending BUIs. */
+STATIC void
+xfs_bmap_update_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_bui_release(BUI_ITEM(intent));
+}
+
+/* Is this recovered BUI ok? */
+static inline bool
+xfs_bui_validate(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip)
+{
+	struct xfs_map_extent		*map;
+
+	/* Only one mapping operation per BUI... */
+	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+		return false;
+
+	map = &buip->bui_format.bui_extents[0];
+
+	if (map->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
+		return false;
+
+	switch (map->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		break;
+	default:
+		return false;
+	}
+
+	if (!xfs_verify_ino(mp, map->me_owner))
+		return false;
+
+	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
+		return false;
+
+	if (map->me_flags & XFS_BMAP_EXTENT_REALTIME)
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
+
+	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
+}
+
+static inline struct xfs_bmap_intent *
+xfs_bui_recover_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	struct xfs_inode		**ipp,
+	struct xfs_map_extent		*map)
+{
+	struct xfs_bmap_intent		*bi;
+	int				error;
+
+	error = xlog_recover_iget(mp, map->me_owner, ipp);
+	if (error)
+		return ERR_PTR(error);
+
+	bi = kmem_cache_zalloc(xfs_bmap_intent_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
+	bi->bi_whichfork = (map->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+			XFS_ATTR_FORK : XFS_DATA_FORK;
+	bi->bi_type = map->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
+	bi->bi_bmap.br_startblock = map->me_startblock;
+	bi->bi_bmap.br_startoff = map->me_startoff;
+	bi->bi_bmap.br_blockcount = map->me_len;
+	bi->bi_bmap.br_state = (map->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+	bi->bi_owner = *ipp;
+	xfs_bmap_update_get_group(mp, bi);
+
+	/* see xfs_bmap_defer_add for details */
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
+	xfs_defer_add_item(dfp, &bi->bi_list);
+	return bi;
+}
+
+/*
+ * Process a bmap update intent item that was recovered from the log.
+ * We need to update some inode's bmbt.
+ */
+STATIC int
+xfs_bmap_recover_work(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
+	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
+	struct xfs_map_extent		*map;
+	struct xfs_bmap_intent		*work;
+	int				iext_delta;
+	int				error = 0;
+
+	if (!xfs_bui_validate(mp, buip)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&buip->bui_format, sizeof(buip->bui_format));
+		return -EFSCORRUPTED;
+	}
+
+	map = &buip->bui_format.bui_extents[0];
+	work = xfs_bui_recover_work(mp, dfp, &ip, map);
+	if (IS_ERR(work))
+		return PTR_ERR(work);
+
+	/* Allocate transaction and do the work. */
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv,
+			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	if (error)
+		goto err_rele;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	if (!!(map->me_flags & XFS_BMAP_EXTENT_REALTIME) !=
+	    xfs_ifork_is_realtime(ip, work->bi_whichfork)) {
+		error = -EFSCORRUPTED;
+		goto err_cancel;
+	}
+
+	if (work->bi_type == XFS_BMAP_MAP)
+		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
+	else
+		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
+
+	error = xfs_iext_count_extend(tp, ip, work->bi_whichfork, iext_delta);
+	if (error)
+		goto err_cancel;
+
+	error = xlog_recover_finish_intent(tp, dfp);
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&buip->bui_format, sizeof(buip->bui_format));
+	if (error)
+		goto err_cancel;
+
+	/*
+	 * Commit transaction, which frees the transaction and saves the inode
+	 * for later replay activities.
+	 */
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	if (error)
+		goto err_unlock;
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+	return 0;
+
+err_cancel:
+	xfs_trans_cancel(tp);
+err_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+err_rele:
+	xfs_irele(ip);
+	return error;
+}
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_bmap_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_bui_log_item		*buip;
+	struct xfs_map_extent		*map;
+	unsigned int			count;
+
+	count = BUI_ITEM(intent)->bui_format.bui_nextents;
+	map = BUI_ITEM(intent)->bui_format.bui_extents;
+
+	buip = xfs_bui_init(tp->t_mountp);
+	memcpy(buip->bui_format.bui_extents, map, count * sizeof(*map));
+	atomic_set(&buip->bui_next_extent, count);
+
+	return &buip->bui_item;
+}
+
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+	.name		= "bmap",
+	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_bmap_update_create_intent,
+	.abort_intent	= xfs_bmap_update_abort_intent,
+	.create_done	= xfs_bmap_update_create_done,
+	.finish_item	= xfs_bmap_update_finish_item,
+	.cancel_item	= xfs_bmap_update_cancel_item,
+	.recover_work	= xfs_bmap_recover_work,
+	.relog_intent	= xfs_bmap_relog_intent,
+};
+
+STATIC bool
+xfs_bui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
+}
+
+static const struct xfs_item_ops xfs_bui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
+	.iop_size	= xfs_bui_item_size,
+	.iop_format	= xfs_bui_item_format,
+	.iop_unpin	= xfs_bui_item_unpin,
+	.iop_release	= xfs_bui_item_release,
+	.iop_match	= xfs_bui_item_match,
+};
+
+static inline void
+xfs_bui_copy_format(
+	struct xfs_bui_log_format	*dst,
+	const struct xfs_bui_log_format	*src)
+{
+	unsigned int			i;
+
+	memcpy(dst, src, offsetof(struct xfs_bui_log_format, bui_extents));
+
+	for (i = 0; i < src->bui_nextents; i++)
+		memcpy(&dst->bui_extents[i], &src->bui_extents[i],
+				sizeof(struct xfs_map_extent));
+}
+
+/*
+ * This routine is called to create an in-core extent bmap update
+ * item from the bui format structure which was logged on disk.
+ * It allocates an in-core bui, copies the extents from the format
+ * structure into it, and adds the bui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_bui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_bui_log_format	*bui_formatp;
+	size_t				len;
+
+	bui_formatp = item->ri_buf[0].iov_base;
+
+	if (item->ri_buf[0].iov_len < xfs_bui_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_bui_log_format_sizeof(bui_formatp->bui_nextents);
+	if (item->ri_buf[0].iov_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	buip = xfs_bui_init(mp);
+	xfs_bui_copy_format(&buip->bui_format, bui_formatp);
+	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
+
+	xlog_recover_intent_item(log, &buip->bui_item, lsn,
+			&xfs_bmap_update_defer_type);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_bui_item_ops = {
+	.item_type		= XFS_LI_BUI,
+	.commit_pass2		= xlog_recover_bui_commit_pass2,
+};
+
+/*
+ * This routine is called when an BUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding BUI if it
+ * was still in the log. To do this it searches the AIL for the BUI with an id
+ * equal to that in the BUD format structure. If we find it we drop the BUD
+ * reference, which removes the BUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_bud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_bud_log_format	*bud_formatp;
+
+	bud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_bud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_BUI, bud_formatp->bud_bui_id);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_bud_item_ops = {
+	.item_type		= XFS_LI_BUD,
+	.commit_pass2		= xlog_recover_bud_commit_pass2,
+};
diff --git a/libxlog/xfs_bmap_item.h b/libxlog/xfs_bmap_item.h
new file mode 100644
index 00000000..b42fee06
--- /dev/null
+++ b/libxlog/xfs_bmap_item.h
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef	__XFS_BMAP_ITEM_H__
+#define	__XFS_BMAP_ITEM_H__
+
+/*
+ * There are (currently) two pairs of bmap btree redo item types: map & unmap.
+ * The common abbreviations for these are BUI (bmap update intent) and BUD
+ * (bmap update done).  The redo item type is encoded in the flags field of
+ * each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated bmbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * bmbt metadata updates in the non-first transaction.
+ */
+
+/* kernel only BUI/BUD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_BUI_MAX_FAST_EXTENTS	1
+
+/*
+ * This is the "bmap update intent" log item.  It is used to log the fact that
+ * some reverse mappings need to change.  It is used in conjunction with the
+ * "bmap update done" log item described below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_bui_log_item {
+	struct xfs_log_item		bui_item;
+	atomic_t			bui_refcount;
+	atomic_t			bui_next_extent;
+	struct xfs_bui_log_format	bui_format;
+};
+
+static inline size_t
+xfs_bui_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_bui_log_item, bui_format) +
+			xfs_bui_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "bmap update done" log item.  It is used to log the fact that
+ * some bmbt updates mentioned in an earlier bui item have been performed.
+ */
+struct xfs_bud_log_item {
+	struct xfs_log_item		bud_item;
+	struct xfs_bui_log_item		*bud_buip;
+	struct xfs_bud_log_format	bud_format;
+};
+
+extern struct kmem_cache	*xfs_bui_cache;
+extern struct kmem_cache	*xfs_bud_cache;
+
+struct xfs_bmap_intent;
+
+void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
+
+unsigned int xfs_bui_log_space(unsigned int nr);
+unsigned int xfs_bud_log_space(void);
+
+#endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/libxlog/xfs_buf_item.h b/libxlog/xfs_buf_item.h
new file mode 100644
index 00000000..3159325d
--- /dev/null
+++ b/libxlog/xfs_buf_item.h
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_BUF_ITEM_H__
+#define	__XFS_BUF_ITEM_H__
+
+/* kernel only definitions */
+
+struct xfs_buf;
+struct xfs_mount;
+
+/* buf log item flags */
+#define	XFS_BLI_HOLD		(1u << 0)
+#define	XFS_BLI_DIRTY		(1u << 1)
+#define	XFS_BLI_STALE		(1u << 2)
+#define	XFS_BLI_LOGGED		(1u << 3)
+#define	XFS_BLI_INODE_ALLOC_BUF	(1u << 4)
+#define XFS_BLI_STALE_INODE	(1u << 5)
+#define	XFS_BLI_INODE_BUF	(1u << 6)
+#define	XFS_BLI_ORDERED		(1u << 7)
+
+#define XFS_BLI_FLAGS \
+	{ XFS_BLI_HOLD,		"HOLD" }, \
+	{ XFS_BLI_DIRTY,	"DIRTY" }, \
+	{ XFS_BLI_STALE,	"STALE" }, \
+	{ XFS_BLI_LOGGED,	"LOGGED" }, \
+	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
+	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
+	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
+	{ XFS_BLI_ORDERED,	"ORDERED" }
+
+/*
+ * This is the in core log item structure used to track information
+ * needed to log buffers.  It tracks how many times the lock has been
+ * locked, and which 128 byte chunks of the buffer are dirty.
+ */
+struct xfs_buf_log_item {
+	struct xfs_log_item	bli_item;	/* common item structure */
+	struct xfs_buf		*bli_buf;	/* real buffer pointer */
+	unsigned int		bli_flags;	/* misc flags */
+	unsigned int		bli_recur;	/* lock recursion count */
+	atomic_t		bli_refcount;	/* cnt of tp refs */
+	int			bli_format_count;	/* count of headers */
+	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
+	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
+};
+
+int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
+void	xfs_buf_item_done(struct xfs_buf *bp);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
+void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
+bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
+void	xfs_buf_inode_iodone(struct xfs_buf *);
+#ifdef CONFIG_XFS_QUOTA
+void	xfs_buf_dquot_iodone(struct xfs_buf *);
+#else
+static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
+{
+}
+#endif /* CONFIG_XFS_QUOTA */
+void	xfs_buf_iodone(struct xfs_buf *);
+bool	xfs_buf_log_check_iovec(struct kvec *iovec);
+
+unsigned int xfs_buf_inval_log_space(unsigned int map_count,
+		unsigned int blocksize);
+
+extern struct kmem_cache	*xfs_buf_item_cache;
+
+#endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/libxlog/xfs_buf_item_recover.c b/libxlog/xfs_buf_item_recover.c
new file mode 100644
index 00000000..6696405e
--- /dev/null
+++ b/libxlog/xfs_buf_item_recover.c
@@ -0,0 +1,1215 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_trans_priv.h"
+#include "xfs_trace.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_inode.h"
+#include "xfs_dir2.h"
+#include "xfs_quota_defs.h"
+#include "xfs_alloc.h"
+#include "xfs_ag.h"
+#include "xfs_sb.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
+
+/*
+ * This is the number of entries in the l_buf_cancel_table used during
+ * recovery.
+ */
+#define	XLOG_BC_TABLE_SIZE	64
+
+#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
+	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
+
+/*
+ * This structure is used during recovery to record the buf log items which
+ * have been canceled and should not be replayed.
+ */
+struct xfs_buf_cancel {
+	xfs_daddr_t		bc_blkno;
+	uint			bc_len;
+	int			bc_refcount;
+	struct list_head	bc_list;
+};
+
+static struct xfs_buf_cancel *
+xlog_find_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	struct list_head	*bucket;
+	struct xfs_buf_cancel	*bcp;
+
+	if (!log->l_buf_cancel_table)
+		return NULL;
+
+	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
+	list_for_each_entry(bcp, bucket, bc_list) {
+		if (bcp->bc_blkno == blkno && bcp->bc_len == len)
+			return bcp;
+	}
+
+	return NULL;
+}
+
+static bool
+xlog_add_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	struct xfs_buf_cancel	*bcp;
+
+	/*
+	 * If we find an existing cancel record, this indicates that the buffer
+	 * was cancelled multiple times.  To ensure that during pass 2 we keep
+	 * the record in the table until we reach its last occurrence in the
+	 * log, a reference count is kept to tell how many times we expect to
+	 * see this record during the second pass.
+	 */
+	bcp = xlog_find_buffer_cancelled(log, blkno, len);
+	if (bcp) {
+		bcp->bc_refcount++;
+		return false;
+	}
+
+	bcp = kmalloc_obj(struct xfs_buf_cancel, GFP_KERNEL | __GFP_NOFAIL);
+	bcp->bc_blkno = blkno;
+	bcp->bc_len = len;
+	bcp->bc_refcount = 1;
+	list_add_tail(&bcp->bc_list, XLOG_BUF_CANCEL_BUCKET(log, blkno));
+	return true;
+}
+
+/*
+ * Check if there is and entry for blkno, len in the buffer cancel record table.
+ */
+bool
+xlog_is_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
+}
+
+/*
+ * Check if there is and entry for blkno, len in the buffer cancel record table,
+ * and decremented the reference count on it if there is one.
+ *
+ * Remove the cancel record once the refcount hits zero, so that if the same
+ * buffer is re-used again after its last cancellation we actually replay the
+ * changes made at that point.
+ */
+static bool
+xlog_put_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	struct xfs_buf_cancel	*bcp;
+
+	bcp = xlog_find_buffer_cancelled(log, blkno, len);
+	if (!bcp) {
+		ASSERT(0);
+		return false;
+	}
+
+	if (--bcp->bc_refcount == 0) {
+		list_del(&bcp->bc_list);
+		kfree(bcp);
+	}
+	return true;
+}
+
+/* log buffer item recovery */
+
+/*
+ * Sort buffer items for log recovery.  Most buffer items should end up on the
+ * buffer list and are recovered first, with the following exceptions:
+ *
+ * 1. XFS_BLF_CANCEL buffers must be processed last because some log items
+ *    might depend on the incor ecancellation record, and replaying a cancelled
+ *    buffer item can remove the incore record.
+ *
+ * 2. XFS_BLF_INODE_BUF buffers are handled after most regular items so that
+ *    we replay di_next_unlinked only after flushing the inode 'free' state
+ *    to the inode buffer.
+ *
+ * See xlog_recover_reorder_trans for more details.
+ */
+STATIC enum xlog_recover_reorder
+xlog_recover_buf_reorder(
+	struct xlog_recover_item	*item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].iov_base;
+
+	if (buf_f->blf_flags & XFS_BLF_CANCEL)
+		return XLOG_REORDER_CANCEL_LIST;
+	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
+		return XLOG_REORDER_INODE_BUFFER_LIST;
+	return XLOG_REORDER_BUFFER_LIST;
+}
+
+STATIC void
+xlog_recover_buf_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].iov_base;
+
+	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
+}
+
+/*
+ * Build up the table of buf cancel records so that we don't replay cancelled
+ * data in the second pass.
+ */
+static int
+xlog_recover_buf_commit_pass1(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_buf_log_format	*bf = item->ri_buf[0].iov_base;
+
+	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
+		xfs_err(log->l_mp, "bad buffer log item size (%zd)",
+				item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	if (!(bf->blf_flags & XFS_BLF_CANCEL))
+		trace_xfs_log_recover_buf_not_cancel(log, bf);
+	else if (xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len))
+		trace_xfs_log_recover_buf_cancel_add(log, bf);
+	else
+		trace_xfs_log_recover_buf_cancel_ref_inc(log, bf);
+	return 0;
+}
+
+/*
+ * Validate the recovered buffer is of the correct type and attach the
+ * appropriate buffer operations to them for writeback. Magic numbers are in a
+ * few places:
+ *	the first 16 bits of the buffer (inode buffer, dquot buffer),
+ *	the first 32 bits of the buffer (most blocks),
+ *	inside a struct xfs_da_blkinfo at the start of the buffer.
+ */
+static void
+xlog_recover_validate_buf_type(
+	struct xfs_mount		*mp,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_da_blkinfo		*info = bp->b_addr;
+	uint32_t			magic32;
+	uint16_t			magic16;
+	uint16_t			magicda;
+	char				*warnmsg = NULL;
+
+	/*
+	 * We can only do post recovery validation on items on CRC enabled
+	 * fielsystems as we need to know when the buffer was written to be able
+	 * to determine if we should have replayed the item. If we replay old
+	 * metadata over a newer buffer, then it will enter a temporarily
+	 * inconsistent state resulting in verification failures. Hence for now
+	 * just avoid the verification stage for non-crc filesystems
+	 */
+	if (!xfs_has_crc(mp))
+		return;
+
+	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
+	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
+	magicda = be16_to_cpu(info->magic);
+	switch (xfs_blft_from_flags(buf_f)) {
+	case XFS_BLFT_BTREE_BUF:
+		switch (magic32) {
+		case XFS_ABTB_CRC_MAGIC:
+		case XFS_ABTB_MAGIC:
+			bp->b_ops = &xfs_bnobt_buf_ops;
+			break;
+		case XFS_ABTC_CRC_MAGIC:
+		case XFS_ABTC_MAGIC:
+			bp->b_ops = &xfs_cntbt_buf_ops;
+			break;
+		case XFS_IBT_CRC_MAGIC:
+		case XFS_IBT_MAGIC:
+			bp->b_ops = &xfs_inobt_buf_ops;
+			break;
+		case XFS_FIBT_CRC_MAGIC:
+		case XFS_FIBT_MAGIC:
+			bp->b_ops = &xfs_finobt_buf_ops;
+			break;
+		case XFS_BMAP_CRC_MAGIC:
+		case XFS_BMAP_MAGIC:
+			bp->b_ops = &xfs_bmbt_buf_ops;
+			break;
+		case XFS_RTRMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrmapbt_buf_ops;
+			break;
+		case XFS_RMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rmapbt_buf_ops;
+			break;
+		case XFS_REFC_CRC_MAGIC:
+			bp->b_ops = &xfs_refcountbt_buf_ops;
+			break;
+		case XFS_RTREFC_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrefcountbt_buf_ops;
+			break;
+		default:
+			warnmsg = "Bad btree block magic!";
+			break;
+		}
+		break;
+	case XFS_BLFT_AGF_BUF:
+		if (magic32 != XFS_AGF_MAGIC) {
+			warnmsg = "Bad AGF block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_agf_buf_ops;
+		break;
+	case XFS_BLFT_AGFL_BUF:
+		if (magic32 != XFS_AGFL_MAGIC) {
+			warnmsg = "Bad AGFL block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_agfl_buf_ops;
+		break;
+	case XFS_BLFT_AGI_BUF:
+		if (magic32 != XFS_AGI_MAGIC) {
+			warnmsg = "Bad AGI block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_agi_buf_ops;
+		break;
+	case XFS_BLFT_UDQUOT_BUF:
+	case XFS_BLFT_PDQUOT_BUF:
+	case XFS_BLFT_GDQUOT_BUF:
+#ifdef CONFIG_XFS_QUOTA
+		if (magic16 != XFS_DQUOT_MAGIC) {
+			warnmsg = "Bad DQUOT block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_dquot_buf_ops;
+#else
+		xfs_alert(mp,
+	"Trying to recover dquots without QUOTA support built in!");
+		ASSERT(0);
+#endif
+		break;
+	case XFS_BLFT_DINO_BUF:
+		if (magic16 != XFS_DINODE_MAGIC) {
+			warnmsg = "Bad INODE block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_inode_buf_ops;
+		break;
+	case XFS_BLFT_SYMLINK_BUF:
+		if (magic32 != XFS_SYMLINK_MAGIC) {
+			warnmsg = "Bad symlink block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_symlink_buf_ops;
+		break;
+	case XFS_BLFT_DIR_BLOCK_BUF:
+		if (magic32 != XFS_DIR2_BLOCK_MAGIC &&
+		    magic32 != XFS_DIR3_BLOCK_MAGIC) {
+			warnmsg = "Bad dir block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_dir3_block_buf_ops;
+		break;
+	case XFS_BLFT_DIR_DATA_BUF:
+		if (magic32 != XFS_DIR2_DATA_MAGIC &&
+		    magic32 != XFS_DIR3_DATA_MAGIC) {
+			warnmsg = "Bad dir data magic!";
+			break;
+		}
+		bp->b_ops = &xfs_dir3_data_buf_ops;
+		break;
+	case XFS_BLFT_DIR_FREE_BUF:
+		if (magic32 != XFS_DIR2_FREE_MAGIC &&
+		    magic32 != XFS_DIR3_FREE_MAGIC) {
+			warnmsg = "Bad dir3 free magic!";
+			break;
+		}
+		bp->b_ops = &xfs_dir3_free_buf_ops;
+		break;
+	case XFS_BLFT_DIR_LEAF1_BUF:
+		if (magicda != XFS_DIR2_LEAF1_MAGIC &&
+		    magicda != XFS_DIR3_LEAF1_MAGIC) {
+			warnmsg = "Bad dir leaf1 magic!";
+			break;
+		}
+		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
+		break;
+	case XFS_BLFT_DIR_LEAFN_BUF:
+		if (magicda != XFS_DIR2_LEAFN_MAGIC &&
+		    magicda != XFS_DIR3_LEAFN_MAGIC) {
+			warnmsg = "Bad dir leafn magic!";
+			break;
+		}
+		bp->b_ops = &xfs_dir3_leafn_buf_ops;
+		break;
+	case XFS_BLFT_DA_NODE_BUF:
+		if (magicda != XFS_DA_NODE_MAGIC &&
+		    magicda != XFS_DA3_NODE_MAGIC) {
+			warnmsg = "Bad da node magic!";
+			break;
+		}
+		bp->b_ops = &xfs_da3_node_buf_ops;
+		break;
+	case XFS_BLFT_ATTR_LEAF_BUF:
+		if (magicda != XFS_ATTR_LEAF_MAGIC &&
+		    magicda != XFS_ATTR3_LEAF_MAGIC) {
+			warnmsg = "Bad attr leaf magic!";
+			break;
+		}
+		bp->b_ops = &xfs_attr3_leaf_buf_ops;
+		break;
+	case XFS_BLFT_ATTR_RMT_BUF:
+		if (magic32 != XFS_ATTR3_RMT_MAGIC) {
+			warnmsg = "Bad attr remote magic!";
+			break;
+		}
+		bp->b_ops = &xfs_attr3_rmt_buf_ops;
+		break;
+	case XFS_BLFT_SB_BUF:
+		if (magic32 != XFS_SB_MAGIC) {
+			warnmsg = "Bad SB block magic!";
+			break;
+		}
+		bp->b_ops = &xfs_sb_buf_ops;
+		break;
+#ifdef CONFIG_XFS_RT
+	case XFS_BLFT_RTBITMAP_BUF:
+		if (xfs_has_rtgroups(mp) && magic32 != XFS_RTBITMAP_MAGIC) {
+			warnmsg = "Bad rtbitmap magic!";
+			break;
+		}
+		bp->b_ops = xfs_rtblock_ops(mp, XFS_RTGI_BITMAP);
+		break;
+	case XFS_BLFT_RTSUMMARY_BUF:
+		if (xfs_has_rtgroups(mp) && magic32 != XFS_RTSUMMARY_MAGIC) {
+			warnmsg = "Bad rtsummary magic!";
+			break;
+		}
+		bp->b_ops = xfs_rtblock_ops(mp, XFS_RTGI_SUMMARY);
+		break;
+#endif /* CONFIG_XFS_RT */
+	default:
+		xfs_warn(mp, "Unknown buffer type %d!",
+			 xfs_blft_from_flags(buf_f));
+		break;
+	}
+
+	/*
+	 * Nothing else to do in the case of a NULL current LSN as this means
+	 * the buffer is more recent than the change in the log and will be
+	 * skipped.
+	 */
+	if (current_lsn == NULLCOMMITLSN)
+		return;
+
+	if (warnmsg) {
+		xfs_warn(mp, warnmsg);
+		ASSERT(0);
+	}
+
+	/*
+	 * We must update the metadata LSN of the buffer as it is written out to
+	 * ensure that older transactions never replay over this one and corrupt
+	 * the buffer. This can occur if log recovery is interrupted at some
+	 * point after the current transaction completes, at which point a
+	 * subsequent mount starts recovery from the beginning.
+	 *
+	 * Write verifiers update the metadata LSN from log items attached to
+	 * the buffer. Therefore, initialize a bli purely to carry the LSN to
+	 * the verifier.
+	 */
+	if (bp->b_ops) {
+		struct xfs_buf_log_item	*bip;
+
+		bp->b_flags |= _XBF_LOGRECOVERY;
+		xfs_buf_item_init(bp, mp);
+		bip = bp->b_log_item;
+		bip->bli_item.li_lsn = current_lsn;
+	}
+}
+
+/*
+ * Perform a 'normal' buffer recovery.  Each logged region of the
+ * buffer should be copied over the corresponding region in the
+ * given buffer.  The bitmap in the buf log format structure indicates
+ * where to place the logged data.
+ */
+STATIC void
+xlog_recover_do_reg_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	int			i;
+	int			bit;
+	int			nbits;
+	xfs_failaddr_t		fa;
+	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
+
+	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
+
+	bit = 0;
+	i = 1;  /* 0 is the buf format structure */
+	while (1) {
+		bit = xfs_next_bit(buf_f->blf_data_map,
+				   buf_f->blf_map_size, bit);
+		if (bit == -1)
+			break;
+		nbits = xfs_contig_bits(buf_f->blf_data_map,
+					buf_f->blf_map_size, bit);
+		ASSERT(nbits > 0);
+		ASSERT(item->ri_buf[i].iov_base != NULL);
+		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
+		ASSERT(BBTOB(bp->b_length) >=
+		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
+
+		/*
+		 * The dirty regions logged in the buffer, even though
+		 * contiguous, may span multiple chunks. This is because the
+		 * dirty region may span a physical page boundary in a buffer
+		 * and hence be split into two separate vectors for writing into
+		 * the log. Hence we need to trim nbits back to the length of
+		 * the current region being copied out of the log.
+		 */
+		if (item->ri_buf[i].iov_len < (nbits << XFS_BLF_SHIFT))
+			nbits = item->ri_buf[i].iov_len >> XFS_BLF_SHIFT;
+
+		/*
+		 * Do a sanity check if this is a dquot buffer. Just checking
+		 * the first dquot in the buffer should do. XXXThis is
+		 * probably a good thing to do for other buf types also.
+		 */
+		fa = NULL;
+		if (buf_f->blf_flags &
+		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
+			if (item->ri_buf[i].iov_base == NULL) {
+				xfs_alert(mp,
+					"XFS: NULL dquot in %s.", __func__);
+				goto next;
+			}
+			if (item->ri_buf[i].iov_len < size_disk_dquot) {
+				xfs_alert(mp,
+					"XFS: dquot too small (%zd) in %s.",
+					item->ri_buf[i].iov_len, __func__);
+				goto next;
+			}
+			fa = xfs_dquot_verify(mp, item->ri_buf[i].iov_base, -1);
+			if (fa) {
+				xfs_alert(mp,
+	"dquot corrupt at %pS trying to replay into block 0x%llx",
+					fa, xfs_buf_daddr(bp));
+				goto next;
+			}
+		}
+
+		memcpy(xfs_buf_offset(bp,
+			(uint)bit << XFS_BLF_SHIFT),	/* dest */
+			item->ri_buf[i].iov_base,		/* source */
+			nbits<<XFS_BLF_SHIFT);		/* length */
+ next:
+		i++;
+		bit += nbits;
+	}
+
+	/* Shouldn't be any more regions */
+	ASSERT(i == item->ri_total);
+
+	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
+}
+
+/*
+ * Perform a dquot buffer recovery.
+ * Simple algorithm: if we have found a QUOTAOFF log item of the same type
+ * (ie. USR or GRP), then just toss this buffer away; don't recover it.
+ * Else, treat it as a regular buffer and do recovery.
+ *
+ * Return false if the buffer was tossed and true if we recovered the buffer to
+ * indicate to the caller if the buffer needs writing.
+ */
+STATIC bool
+xlog_recover_do_dquot_buffer(
+	struct xfs_mount		*mp,
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f)
+{
+	uint			type;
+
+	trace_xfs_log_recover_buf_dquot_buf(log, buf_f);
+
+	/*
+	 * Filesystems are required to send in quota flags at mount time.
+	 */
+	if (!mp->m_qflags)
+		return false;
+
+	type = 0;
+	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
+		type |= XFS_DQTYPE_USER;
+	if (buf_f->blf_flags & XFS_BLF_PDQUOT_BUF)
+		type |= XFS_DQTYPE_PROJ;
+	if (buf_f->blf_flags & XFS_BLF_GDQUOT_BUF)
+		type |= XFS_DQTYPE_GROUP;
+	/*
+	 * This type of quotas was turned off, so ignore this buffer
+	 */
+	if (log->l_quotaoffs_flag & type)
+		return false;
+
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
+	return true;
+}
+
+/*
+ * Perform recovery for a buffer full of inodes.  In these buffers, the only
+ * data which should be recovered is that which corresponds to the
+ * di_next_unlinked pointers in the on disk inode structures.  The rest of the
+ * data for the inodes is always logged through the inodes themselves rather
+ * than the inode buffer and is recovered in xlog_recover_inode_pass2().
+ *
+ * The only time when buffers full of inodes are fully recovered is when the
+ * buffer is full of newly allocated inodes.  In this case the buffer will
+ * not be marked as an inode buffer and so will be sent to
+ * xlog_recover_do_reg_buffer() below during recovery.
+ */
+STATIC int
+xlog_recover_do_inode_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f)
+{
+	int				i;
+	int				item_index = 0;
+	int				bit = 0;
+	int				nbits = 0;
+	int				reg_buf_offset = 0;
+	int				reg_buf_bytes = 0;
+	int				next_unlinked_offset;
+	int				inodes_per_buf;
+	xfs_agino_t			*logged_nextp;
+	xfs_agino_t			*buffer_nextp;
+
+	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
+
+	/*
+	 * Post recovery validation only works properly on CRC enabled
+	 * filesystems.
+	 */
+	if (xfs_has_crc(mp))
+		bp->b_ops = &xfs_inode_buf_ops;
+
+	inodes_per_buf = BBTOB(bp->b_length) >> mp->m_sb.sb_inodelog;
+	for (i = 0; i < inodes_per_buf; i++) {
+		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
+			offsetof(struct xfs_dinode, di_next_unlinked);
+
+		while (next_unlinked_offset >=
+		       (reg_buf_offset + reg_buf_bytes)) {
+			/*
+			 * The next di_next_unlinked field is beyond
+			 * the current logged region.  Find the next
+			 * logged region that contains or is beyond
+			 * the current di_next_unlinked field.
+			 */
+			bit += nbits;
+			bit = xfs_next_bit(buf_f->blf_data_map,
+					   buf_f->blf_map_size, bit);
+
+			/*
+			 * If there are no more logged regions in the
+			 * buffer, then we're done.
+			 */
+			if (bit == -1)
+				return 0;
+
+			nbits = xfs_contig_bits(buf_f->blf_data_map,
+						buf_f->blf_map_size, bit);
+			ASSERT(nbits > 0);
+			reg_buf_offset = bit << XFS_BLF_SHIFT;
+			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
+			item_index++;
+		}
+
+		/*
+		 * If the current logged region starts after the current
+		 * di_next_unlinked field, then move on to the next
+		 * di_next_unlinked field.
+		 */
+		if (next_unlinked_offset < reg_buf_offset)
+			continue;
+
+		ASSERT(item->ri_buf[item_index].iov_base != NULL);
+		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
+		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
+
+		/*
+		 * The current logged region contains a copy of the
+		 * current di_next_unlinked field.  Extract its value
+		 * and copy it to the buffer copy.
+		 */
+		logged_nextp = item->ri_buf[item_index].iov_base +
+				next_unlinked_offset - reg_buf_offset;
+		if (XFS_IS_CORRUPT(mp, *logged_nextp == 0)) {
+			xfs_alert(mp,
+		"Bad inode buffer log record (ptr = "PTR_FMT", bp = "PTR_FMT"). "
+		"Trying to replay bad (0) inode di_next_unlinked field.",
+				item, bp);
+			return -EFSCORRUPTED;
+		}
+
+		buffer_nextp = xfs_buf_offset(bp, next_unlinked_offset);
+		*buffer_nextp = *logged_nextp;
+
+		/*
+		 * If necessary, recalculate the CRC in the on-disk inode. We
+		 * have to leave the inode in a consistent state for whoever
+		 * reads it next....
+		 */
+		xfs_dinode_calc_crc(mp,
+				xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize));
+
+	}
+
+	return 0;
+}
+
+/*
+ * Update the in-memory superblock and perag structures from the primary SB
+ * buffer.
+ *
+ * This is required because transactions running after growfs may require the
+ * updated values to be set in a previous fully commit transaction.
+ */
+static int
+xlog_recover_do_primary_sb_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_dsb			*dsb = bp->b_addr;
+	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
+	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
+	int				error;
+
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+
+	if (orig_agcount == 0) {
+		xfs_alert(mp, "Trying to grow file system without AGs");
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Update the in-core super block from the freshly recovered on-disk one.
+	 */
+	xfs_sb_from_disk(&mp->m_sb, dsb);
+
+	/*
+	 * Grow can change the device size.  Mirror that into the buftarg.
+	 */
+	mp->m_ddev_targp->bt_nr_sectors =
+		XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
+		mp->m_rtdev_targp->bt_nr_sectors =
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	}
+
+	if (mp->m_sb.sb_agcount < orig_agcount) {
+		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
+		return -EFSCORRUPTED;
+	}
+	if (mp->m_sb.sb_rgcount < orig_rgcount) {
+		xfs_warn(mp,
+ "Shrinking rtgroup count in log recovery not supported");
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * If the last AG was grown or shrunk, we also need to update the
+	 * length in the in-core perag structure and values depending on it.
+	 */
+	error = xfs_update_last_ag_size(mp, orig_agcount);
+	if (error)
+		return error;
+
+	/*
+	 * If the last rtgroup was grown or shrunk, we also need to update the
+	 * length in the in-core rtgroup structure and values depending on it.
+	 * Ignore this on any filesystem with zero rtgroups.
+	 */
+	if (orig_rgcount > 0) {
+		error = xfs_update_last_rtgroup_size(mp, orig_rgcount);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Initialize the new perags, and also update various block and inode
+	 * allocator setting based off the number of AGs or total blocks.
+	 * Because of the latter this also needs to happen if the agcount did
+	 * not change.
+	 */
+	error = xfs_initialize_perag(mp, orig_agcount, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
+	if (error) {
+		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
+		return error;
+	}
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+
+	error = xfs_initialize_rtgroups(mp, orig_rgcount, mp->m_sb.sb_rgcount,
+			mp->m_sb.sb_rextents);
+	if (error) {
+		xfs_warn(mp, "Failed recovery rtgroup init: %d", error);
+		return error;
+	}
+	return 0;
+}
+
+/*
+ * V5 filesystems know the age of the buffer on disk being recovered. We can
+ * have newer objects on disk than we are replaying, and so for these cases we
+ * don't want to replay the current change as that will make the buffer contents
+ * temporarily invalid on disk.
+ *
+ * The magic number might not match the buffer type we are going to recover
+ * (e.g. reallocated blocks), so we ignore the xfs_buf_log_format flags.  Hence
+ * extract the LSN of the existing object in the buffer based on it's current
+ * magic number.  If we don't recognise the magic number in the buffer, then
+ * return a LSN of -1 so that the caller knows it was an unrecognised block and
+ * so can recover the buffer.
+ *
+ * Note: we cannot rely solely on magic number matches to determine that the
+ * buffer has a valid LSN - we also need to verify that it belongs to this
+ * filesystem, so we need to extract the object's LSN and compare it to that
+ * which we read from the superblock. If the UUIDs don't match, then we've got a
+ * stale metadata block from an old filesystem instance that we need to recover
+ * over the top of.
+ */
+static xfs_lsn_t
+xlog_recover_get_buf_lsn(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct xfs_buf_log_format *buf_f)
+{
+	uint32_t		magic32;
+	uint16_t		magic16;
+	uint16_t		magicda;
+	void			*blk = bp->b_addr;
+	uuid_t			*uuid;
+	xfs_lsn_t		lsn = -1;
+	uint16_t		blft;
+
+	/* v4 filesystems always recover immediately */
+	if (!xfs_has_crc(mp))
+		goto recover_immediately;
+
+	/*
+	 * realtime bitmap and summary file blocks do not have magic numbers or
+	 * UUIDs, so we must recover them immediately.
+	 */
+	blft = xfs_blft_from_flags(buf_f);
+	if (!xfs_has_rtgroups(mp) && (blft == XFS_BLFT_RTBITMAP_BUF ||
+				      blft == XFS_BLFT_RTSUMMARY_BUF))
+		goto recover_immediately;
+
+	magic32 = be32_to_cpu(*(__be32 *)blk);
+	switch (magic32) {
+	case XFS_RTSUMMARY_MAGIC:
+	case XFS_RTBITMAP_MAGIC: {
+		struct xfs_rtbuf_blkinfo	*hdr = blk;
+
+		lsn = be64_to_cpu(hdr->rt_lsn);
+		uuid = &hdr->rt_uuid;
+		break;
+	}
+	case XFS_ABTB_CRC_MAGIC:
+	case XFS_ABTC_CRC_MAGIC:
+	case XFS_ABTB_MAGIC:
+	case XFS_ABTC_MAGIC:
+	case XFS_RMAP_CRC_MAGIC:
+	case XFS_REFC_CRC_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+	case XFS_FIBT_MAGIC:
+	case XFS_IBT_CRC_MAGIC:
+	case XFS_IBT_MAGIC: {
+		struct xfs_btree_block *btb = blk;
+
+		lsn = be64_to_cpu(btb->bb_u.s.bb_lsn);
+		uuid = &btb->bb_u.s.bb_uuid;
+		break;
+	}
+	case XFS_RTRMAP_CRC_MAGIC:
+	case XFS_RTREFC_CRC_MAGIC:
+	case XFS_BMAP_CRC_MAGIC:
+	case XFS_BMAP_MAGIC: {
+		struct xfs_btree_block *btb = blk;
+
+		lsn = be64_to_cpu(btb->bb_u.l.bb_lsn);
+		uuid = &btb->bb_u.l.bb_uuid;
+		break;
+	}
+	case XFS_AGF_MAGIC:
+		lsn = be64_to_cpu(((struct xfs_agf *)blk)->agf_lsn);
+		uuid = &((struct xfs_agf *)blk)->agf_uuid;
+		break;
+	case XFS_AGFL_MAGIC:
+		lsn = be64_to_cpu(((struct xfs_agfl *)blk)->agfl_lsn);
+		uuid = &((struct xfs_agfl *)blk)->agfl_uuid;
+		break;
+	case XFS_AGI_MAGIC:
+		lsn = be64_to_cpu(((struct xfs_agi *)blk)->agi_lsn);
+		uuid = &((struct xfs_agi *)blk)->agi_uuid;
+		break;
+	case XFS_SYMLINK_MAGIC:
+		lsn = be64_to_cpu(((struct xfs_dsymlink_hdr *)blk)->sl_lsn);
+		uuid = &((struct xfs_dsymlink_hdr *)blk)->sl_uuid;
+		break;
+	case XFS_DIR3_BLOCK_MAGIC:
+	case XFS_DIR3_DATA_MAGIC:
+	case XFS_DIR3_FREE_MAGIC:
+		lsn = be64_to_cpu(((struct xfs_dir3_blk_hdr *)blk)->lsn);
+		uuid = &((struct xfs_dir3_blk_hdr *)blk)->uuid;
+		break;
+	case XFS_ATTR3_RMT_MAGIC:
+		/*
+		 * Remote attr blocks are written synchronously, rather than
+		 * being logged. That means they do not contain a valid LSN
+		 * (i.e. transactionally ordered) in them, and hence any time we
+		 * see a buffer to replay over the top of a remote attribute
+		 * block we should simply do so.
+		 */
+		goto recover_immediately;
+	case XFS_SB_MAGIC:
+		/*
+		 * superblock uuids are magic. We may or may not have a
+		 * sb_meta_uuid on disk, but it will be set in the in-core
+		 * superblock. We set the uuid pointer for verification
+		 * according to the superblock feature mask to ensure we check
+		 * the relevant UUID in the superblock.
+		 */
+		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
+		if (xfs_has_metauuid(mp))
+			uuid = &((struct xfs_dsb *)blk)->sb_meta_uuid;
+		else
+			uuid = &((struct xfs_dsb *)blk)->sb_uuid;
+		break;
+	default:
+		break;
+	}
+
+	if (lsn != (xfs_lsn_t)-1) {
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
+			goto recover_immediately;
+		return lsn;
+	}
+
+	magicda = be16_to_cpu(((struct xfs_da_blkinfo *)blk)->magic);
+	switch (magicda) {
+	case XFS_DIR3_LEAF1_MAGIC:
+	case XFS_DIR3_LEAFN_MAGIC:
+	case XFS_ATTR3_LEAF_MAGIC:
+	case XFS_DA3_NODE_MAGIC:
+		lsn = be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
+		uuid = &((struct xfs_da3_blkinfo *)blk)->uuid;
+		break;
+	default:
+		break;
+	}
+
+	if (lsn != (xfs_lsn_t)-1) {
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
+			goto recover_immediately;
+		return lsn;
+	}
+
+	/*
+	 * We do individual object checks on dquot and inode buffers as they
+	 * have their own individual LSN records. Also, we could have a stale
+	 * buffer here, so we have to at least recognise these buffer types.
+	 *
+	 * A notd complexity here is inode unlinked list processing - it logs
+	 * the inode directly in the buffer, but we don't know which inodes have
+	 * been modified, and there is no global buffer LSN. Hence we need to
+	 * recover all inode buffer types immediately. This problem will be
+	 * fixed by logical logging of the unlinked list modifications.
+	 */
+	magic16 = be16_to_cpu(*(__be16 *)blk);
+	switch (magic16) {
+	case XFS_DQUOT_MAGIC:
+	case XFS_DINODE_MAGIC:
+		goto recover_immediately;
+	default:
+		break;
+	}
+
+	/* unknown buffer contents, recover immediately */
+
+recover_immediately:
+	return (xfs_lsn_t)-1;
+
+}
+
+/*
+ * This routine replays a modification made to a buffer at runtime.
+ * There are actually two types of buffer, regular and inode, which
+ * are handled differently.  Inode buffers are handled differently
+ * in that we only recover a specific set of data from them, namely
+ * the inode di_next_unlinked fields.  This is because all other inode
+ * data is actually logged via inode records and any data we replay
+ * here which overlaps that may be stale.
+ *
+ * When meta-data buffers are freed at run time we log a buffer item
+ * with the XFS_BLF_CANCEL bit set to indicate that previous copies
+ * of the buffer in the log should not be replayed at recovery time.
+ * This is so that if the blocks covered by the buffer are reused for
+ * file data before we crash we don't end up replaying old, freed
+ * meta-data into a user's file.
+ *
+ * To handle the cancellation of buffer log items, we make two passes
+ * over the log during recovery.  During the first we build a table of
+ * those buffers which have been cancelled, and during the second we
+ * only replay those buffers which do not have corresponding cancel
+ * records in the table.  See xlog_recover_buf_pass[1,2] above
+ * for more details on the implementation of the table of cancel records.
+ */
+STATIC int
+xlog_recover_buf_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].iov_base;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_buf			*bp;
+	int				error;
+	xfs_lsn_t			lsn;
+
+	/*
+	 * In this pass we only want to recover all the buffers which have
+	 * not been cancelled and are not cancellation buffers themselves.
+	 */
+	if (buf_f->blf_flags & XFS_BLF_CANCEL) {
+		if (xlog_put_buffer_cancelled(log, buf_f->blf_blkno,
+				buf_f->blf_len))
+			goto cancelled;
+	} else {
+
+		if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno,
+				buf_f->blf_len))
+			goto cancelled;
+	}
+
+	trace_xfs_log_recover_buf_recover(log, buf_f);
+	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
+			  0, &bp, NULL);
+	if (error)
+		return error;
+
+	/*
+	 * Recover the buffer only if we get an LSN from it and it's less than
+	 * the lsn of the transaction we are replaying.
+	 *
+	 * Note that we have to be extremely careful of readahead here.
+	 * Readahead does not attach verfiers to the buffers so if we don't
+	 * actually do any replay after readahead because of the LSN we found
+	 * in the buffer if more recent than that current transaction then we
+	 * need to attach the verifier directly. Failure to do so can lead to
+	 * future recovery actions (e.g. EFI and unlinked list recovery) can
+	 * operate on the buffers and they won't get the verifier attached. This
+	 * can lead to blocks on disk having the correct content but a stale
+	 * CRC.
+	 *
+	 * It is safe to assume these clean buffers are currently up to date.
+	 * If the buffer is dirtied by a later transaction being replayed, then
+	 * the verifier will be reset to match whatever recover turns that
+	 * buffer into.
+	 */
+	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
+	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+		trace_xfs_log_recover_buf_skip(log, buf_f);
+		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
+
+		/*
+		 * We're skipping replay of this buffer log item due to the log
+		 * item LSN being behind the ondisk buffer.  Verify the buffer
+		 * contents since we aren't going to run the write verifier.
+		 */
+		if (bp->b_ops) {
+			bp->b_ops->verify_read(bp);
+			error = bp->b_error;
+		}
+		goto out_release;
+	}
+
+	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
+		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
+		if (error)
+			goto out_release;
+	} else if (buf_f->blf_flags &
+		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
+		bool	dirty;
+
+		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
+		if (!dirty)
+			goto out_release;
+	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
+			xfs_buf_daddr(bp) == 0) {
+		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
+				current_lsn);
+		if (error)
+			goto out_writebuf;
+
+		/* Update the rt superblock if we have one. */
+		if (xfs_has_rtsb(mp) && mp->m_rtsb_bp) {
+			struct xfs_buf	*rtsb_bp = mp->m_rtsb_bp;
+
+			xfs_buf_lock(rtsb_bp);
+			xfs_buf_hold(rtsb_bp);
+			xfs_update_rtsb(rtsb_bp, bp);
+			rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
+			xfs_buf_delwri_queue(rtsb_bp, buffer_list);
+			xfs_buf_relse(rtsb_bp);
+		}
+	} else {
+		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+	}
+
+	/*
+	 * Buffer held by buf log item during 'normal' buffer recovery must
+	 * be committed through buffer I/O submission path to ensure proper
+	 * release. When error occurs during sb buffer recovery, log shutdown
+	 * will be done before submitting buffer list so that buffers can be
+	 * released correctly through ioend failure path.
+	 */
+out_writebuf:
+
+	/*
+	 * Perform delayed write on the buffer.  Asynchronous writes will be
+	 * slower when taking into account all the buffers to be flushed.
+	 *
+	 * Also make sure that only inode buffers with good sizes stay in
+	 * the buffer cache.  The kernel moves inodes in buffers of 1 block
+	 * or inode_cluster_size bytes, whichever is bigger.  The inode
+	 * buffers in the log can be a different size if the log was generated
+	 * by an older kernel using unclustered inode buffers or a newer kernel
+	 * running with a different inode cluster size.  Regardless, if
+	 * the inode buffer size isn't max(blocksize, inode_cluster_size)
+	 * for *our* value of inode_cluster_size, then we need to keep
+	 * the buffer out of the buffer cache so that the buffer won't
+	 * overlap with future reads of those inodes.
+	 */
+	if (XFS_DINODE_MAGIC ==
+	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
+	    (BBTOB(bp->b_length) != M_IGEO(log->l_mp)->inode_cluster_size)) {
+		xfs_buf_stale(bp);
+		error = xfs_bwrite(bp);
+	} else {
+		ASSERT(bp->b_mount == mp);
+		bp->b_flags |= _XBF_LOGRECOVERY;
+		xfs_buf_delwri_queue(bp, buffer_list);
+	}
+
+out_release:
+	xfs_buf_relse(bp);
+	return error;
+cancelled:
+	trace_xfs_log_recover_buf_cancel(log, buf_f);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_buf_item_ops = {
+	.item_type		= XFS_LI_BUF,
+	.reorder		= xlog_recover_buf_reorder,
+	.ra_pass2		= xlog_recover_buf_ra_pass2,
+	.commit_pass1		= xlog_recover_buf_commit_pass1,
+	.commit_pass2		= xlog_recover_buf_commit_pass2,
+};
+
+#ifdef DEBUG
+void
+xlog_check_buf_cancel_table(
+	struct xlog	*log)
+{
+	int		i;
+
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
+		ASSERT(list_empty(&log->l_buf_cancel_table[i]));
+}
+#endif
+
+int
+xlog_alloc_buf_cancel_table(
+	struct xlog	*log)
+{
+	void		*p;
+	int		i;
+
+	ASSERT(log->l_buf_cancel_table == NULL);
+
+	p = kmalloc_objs(struct list_head, XLOG_BC_TABLE_SIZE);
+	if (!p)
+		return -ENOMEM;
+
+	log->l_buf_cancel_table = p;
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
+		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
+
+	return 0;
+}
+
+void
+xlog_free_buf_cancel_table(
+	struct xlog	*log)
+{
+	int		i;
+
+	if (!log->l_buf_cancel_table)
+		return;
+
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++) {
+		struct xfs_buf_cancel	*bc;
+
+		while ((bc = list_first_entry_or_null(
+				&log->l_buf_cancel_table[i],
+				struct xfs_buf_cancel, bc_list))) {
+			list_del(&bc->bc_list);
+			kfree(bc);
+		}
+	}
+
+	kfree(log->l_buf_cancel_table);
+	log->l_buf_cancel_table = NULL;
+}
diff --git a/libxlog/xfs_dquot_item_recover.c b/libxlog/xfs_dquot_item_recover.c
new file mode 100644
index 00000000..f9d182ee
--- /dev/null
+++ b/libxlog/xfs_dquot_item_recover.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_quota_defs.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+
+STATIC void
+xlog_recover_dquot_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_disk_dquot	*recddq;
+	struct xfs_dq_logformat	*dq_f;
+	uint			type;
+
+	if (mp->m_qflags == 0)
+		return;
+
+	recddq = item->ri_buf[1].iov_base;
+	if (recddq == NULL)
+		return;
+	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot))
+		return;
+
+	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return;
+
+	dq_f = item->ri_buf[0].iov_base;
+	ASSERT(dq_f);
+	ASSERT(dq_f->qlf_len == 1);
+
+	xlog_buf_readahead(log, dq_f->qlf_blkno,
+			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
+			&xfs_dquot_buf_ra_ops);
+}
+
+/*
+ * Recover a dquot record
+ */
+STATIC int
+xlog_recover_dquot_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_buf			*bp;
+	struct xfs_dqblk		*dqb;
+	struct xfs_disk_dquot		*ddq, *recddq;
+	struct xfs_dq_logformat		*dq_f;
+	xfs_failaddr_t			fa;
+	int				error;
+	uint				type;
+
+	/*
+	 * Filesystems are required to send in quota flags at mount time.
+	 */
+	if (mp->m_qflags == 0)
+		return 0;
+
+	recddq = item->ri_buf[1].iov_base;
+	if (recddq == NULL) {
+		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
+		return -EFSCORRUPTED;
+	}
+	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot)) {
+		xfs_alert(log->l_mp, "dquot too small (%zd) in %s.",
+			item->ri_buf[1].iov_len, __func__);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * This type of quotas was turned off, so ignore this record.
+	 */
+	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return 0;
+
+	/*
+	 * At this point we know that quota was _not_ turned off.
+	 * Since the mount flags are not indicating to us otherwise, this
+	 * must mean that quota is on, and the dquot needs to be replayed.
+	 * Remember that we may not have fully recovered the superblock yet,
+	 * so we can't do the usual trick of looking at the SB quota bits.
+	 *
+	 * The other possibility, of course, is that the quota subsystem was
+	 * removed since the last mount - ENOSYS.
+	 */
+	dq_f = item->ri_buf[0].iov_base;
+	ASSERT(dq_f);
+	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
+	if (fa) {
+		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
+				dq_f->qlf_id, fa);
+		return -EFSCORRUPTED;
+	}
+	ASSERT(dq_f->qlf_len == 1);
+
+	/*
+	 * At this point we are assuming that the dquots have been allocated
+	 * and hence the buffer has valid dquots stamped in it. It should,
+	 * therefore, pass verifier validation. If the dquot is bad, then the
+	 * we'll return an error here, so we don't need to specifically check
+	 * the dquot in the buffer after the verifier has run.
+	 */
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
+				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
+				   &xfs_dquot_buf_ops);
+	if (error)
+		return error;
+
+	ASSERT(bp);
+	dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	ddq = &dqb->dd_diskdq;
+
+	/*
+	 * If the dquot has an LSN in it, recover the dquot only if it's less
+	 * than the lsn of the transaction we are replaying.
+	 */
+	if (xfs_has_crc(mp)) {
+		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
+
+		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+			goto out_release;
+		}
+	}
+
+	memcpy(ddq, recddq, item->ri_buf[1].iov_len);
+	if (xfs_has_crc(mp)) {
+		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
+	}
+
+	/* Validate the recovered dquot. */
+	fa = xfs_dqblk_verify(log->l_mp, dqb, dq_f->qlf_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot after recovery",
+				XFS_ERRLEVEL_LOW, mp, dqb,
+				sizeof(struct xfs_dqblk));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dq_f->qlf_id);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
+	ASSERT(dq_f->qlf_size == 2);
+	ASSERT(bp->b_mount == mp);
+	bp->b_flags |= _XBF_LOGRECOVERY;
+	xfs_buf_delwri_queue(bp, buffer_list);
+
+out_release:
+	xfs_buf_relse(bp);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_dquot_item_ops = {
+	.item_type		= XFS_LI_DQUOT,
+	.ra_pass2		= xlog_recover_dquot_ra_pass2,
+	.commit_pass2		= xlog_recover_dquot_commit_pass2,
+};
+
+/*
+ * Recover QUOTAOFF records. We simply make a note of it in the xlog
+ * structure, so that we know not to do any dquot item or dquot buffer recovery,
+ * of that type.
+ */
+STATIC int
+xlog_recover_quotaoff_commit_pass1(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_qoff_logformat	*qoff_f = item->ri_buf[0].iov_base;
+	ASSERT(qoff_f);
+
+	/*
+	 * The logitem format's flag tells us if this was user quotaoff,
+	 * group/project quotaoff or both.
+	 */
+	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
+		log->l_quotaoffs_flag |= XFS_DQTYPE_USER;
+	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
+		log->l_quotaoffs_flag |= XFS_DQTYPE_PROJ;
+	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
+		log->l_quotaoffs_flag |= XFS_DQTYPE_GROUP;
+
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
+	.item_type		= XFS_LI_QUOTAOFF,
+	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
+	/* nothing to commit in pass2 */
+};
diff --git a/libxlog/xfs_exchmaps_item.c b/libxlog/xfs_exchmaps_item.c
new file mode 100644
index 00000000..20e70ae2
--- /dev/null
+++ b/libxlog/xfs_exchmaps_item.c
@@ -0,0 +1,608 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_exchmaps_item.h"
+#include "xfs_exchmaps.h"
+#include "xfs_log.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_trace.h"
+
+struct kmem_cache	*xfs_xmi_cache;
+struct kmem_cache	*xfs_xmd_cache;
+
+static const struct xfs_item_ops xfs_xmi_item_ops;
+
+static inline struct xfs_xmi_log_item *XMI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_xmi_log_item, xmi_item);
+}
+
+STATIC void
+xfs_xmi_item_free(
+	struct xfs_xmi_log_item	*xmi_lip)
+{
+	kvfree(xmi_lip->xmi_item.li_lv_shadow);
+	kmem_cache_free(xfs_xmi_cache, xmi_lip);
+}
+
+/*
+ * Freeing the XMI requires that we remove it from the AIL if it has already
+ * been placed there. However, the XMI may not yet have been placed in the AIL
+ * when called by xfs_xmi_release() from XMD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the XMI.
+ */
+STATIC void
+xfs_xmi_release(
+	struct xfs_xmi_log_item	*xmi_lip)
+{
+	ASSERT(atomic_read(&xmi_lip->xmi_refcount) > 0);
+	if (atomic_dec_and_test(&xmi_lip->xmi_refcount)) {
+		xfs_trans_ail_delete(&xmi_lip->xmi_item, 0);
+		xfs_xmi_item_free(xmi_lip);
+	}
+}
+
+
+STATIC void
+xfs_xmi_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_xmi_log_format);
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the given xmi log
+ * item. We use only 1 iovec, and we point that at the xmi_log_format structure
+ * embedded in the xmi item.
+ */
+STATIC void
+xfs_xmi_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_xmi_log_item	*xmi_lip = XMI_ITEM(lip);
+
+	xmi_lip->xmi_format.xmi_type = XFS_LI_XMI;
+	xmi_lip->xmi_format.xmi_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_XMI_FORMAT, &xmi_lip->xmi_format,
+			sizeof(struct xfs_xmi_log_format));
+}
+
+/*
+ * The unpin operation is the last place an XMI is manipulated in the log. It
+ * is either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the XMI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the XMI to either construct
+ * and commit the XMD or drop the XMD's reference in the event of error. Simply
+ * drop the log's XMI reference now that the log is done with it.
+ */
+STATIC void
+xfs_xmi_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_xmi_log_item	*xmi_lip = XMI_ITEM(lip);
+
+	xfs_xmi_release(xmi_lip);
+}
+
+/*
+ * The XMI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an XMD isn't going to be
+ * constructed and thus we free the XMI here directly.
+ */
+STATIC void
+xfs_xmi_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_xmi_release(XMI_ITEM(lip));
+}
+
+/* Allocate and initialize an xmi item. */
+STATIC struct xfs_xmi_log_item *
+xfs_xmi_init(
+	struct xfs_mount	*mp)
+
+{
+	struct xfs_xmi_log_item	*xmi_lip;
+
+	xmi_lip = kmem_cache_zalloc(xfs_xmi_cache, GFP_KERNEL | __GFP_NOFAIL);
+
+	xfs_log_item_init(mp, &xmi_lip->xmi_item, XFS_LI_XMI, &xfs_xmi_item_ops);
+	xmi_lip->xmi_format.xmi_id = (uintptr_t)(void *)xmi_lip;
+	atomic_set(&xmi_lip->xmi_refcount, 2);
+
+	return xmi_lip;
+}
+
+static inline struct xfs_xmd_log_item *XMD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_xmd_log_item, xmd_item);
+}
+
+STATIC void
+xfs_xmd_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_xmd_log_format);
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the given xmd log
+ * item. We use only 1 iovec, and we point that at the xmd_log_format structure
+ * embedded in the xmd item.
+ */
+STATIC void
+xfs_xmd_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_xmd_log_item	*xmd_lip = XMD_ITEM(lip);
+
+	xmd_lip->xmd_format.xmd_type = XFS_LI_XMD;
+	xmd_lip->xmd_format.xmd_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_XMD_FORMAT, &xmd_lip->xmd_format,
+			sizeof(struct xfs_xmd_log_format));
+}
+
+/*
+ * The XMD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the XMI and free the
+ * XMD.
+ */
+STATIC void
+xfs_xmd_item_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_xmd_log_item	*xmd_lip = XMD_ITEM(lip);
+
+	xfs_xmi_release(xmd_lip->xmd_intent_log_item);
+	kvfree(xmd_lip->xmd_item.li_lv_shadow);
+	kmem_cache_free(xfs_xmd_cache, xmd_lip);
+}
+
+static struct xfs_log_item *
+xfs_xmd_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &XMD_ITEM(lip)->xmd_intent_log_item->xmi_item;
+}
+
+static const struct xfs_item_ops xfs_xmd_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
+	.iop_size	= xfs_xmd_item_size,
+	.iop_format	= xfs_xmd_item_format,
+	.iop_release	= xfs_xmd_item_release,
+	.iop_intent	= xfs_xmd_item_intent,
+};
+
+/* Log file mapping exchange information in the intent item. */
+STATIC struct xfs_log_item *
+xfs_exchmaps_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_xmi_log_item		*xmi_lip;
+	struct xfs_exchmaps_intent	*xmi;
+	struct xfs_xmi_log_format	*xlf;
+
+	ASSERT(count == 1);
+
+	xmi = list_first_entry_or_null(items, struct xfs_exchmaps_intent,
+			xmi_list);
+
+	xmi_lip = xfs_xmi_init(tp->t_mountp);
+	xlf = &xmi_lip->xmi_format;
+
+	xlf->xmi_inode1 = xmi->xmi_ip1->i_ino;
+	xlf->xmi_igen1 = VFS_I(xmi->xmi_ip1)->i_generation;
+	xlf->xmi_inode2 = xmi->xmi_ip2->i_ino;
+	xlf->xmi_igen2 = VFS_I(xmi->xmi_ip2)->i_generation;
+	xlf->xmi_startoff1 = xmi->xmi_startoff1;
+	xlf->xmi_startoff2 = xmi->xmi_startoff2;
+	xlf->xmi_blockcount = xmi->xmi_blockcount;
+	xlf->xmi_isize1 = xmi->xmi_isize1;
+	xlf->xmi_isize2 = xmi->xmi_isize2;
+	xlf->xmi_flags = xmi->xmi_flags & XFS_EXCHMAPS_LOGGED_FLAGS;
+
+	return &xmi_lip->xmi_item;
+}
+
+STATIC struct xfs_log_item *
+xfs_exchmaps_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	struct xfs_xmi_log_item		*xmi_lip = XMI_ITEM(intent);
+	struct xfs_xmd_log_item		*xmd_lip;
+
+	xmd_lip = kmem_cache_zalloc(xfs_xmd_cache, GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &xmd_lip->xmd_item, XFS_LI_XMD,
+			  &xfs_xmd_item_ops);
+	xmd_lip->xmd_intent_log_item = xmi_lip;
+	xmd_lip->xmd_format.xmd_xmi_id = xmi_lip->xmi_format.xmi_id;
+
+	return &xmd_lip->xmd_item;
+}
+
+/* Add this deferred XMI to the transaction. */
+void
+xfs_exchmaps_defer_add(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi)
+{
+	trace_xfs_exchmaps_defer(tp->t_mountp, xmi);
+
+	xfs_defer_add(tp, &xmi->xmi_list, &xfs_exchmaps_defer_type);
+}
+
+static inline struct xfs_exchmaps_intent *xmi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_exchmaps_intent, xmi_list);
+}
+
+/* Cancel a deferred file mapping exchange. */
+STATIC void
+xfs_exchmaps_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_exchmaps_intent	*xmi = xmi_entry(item);
+
+	kmem_cache_free(xfs_exchmaps_intent_cache, xmi);
+}
+
+/* Process a deferred file mapping exchange. */
+STATIC int
+xfs_exchmaps_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_exchmaps_intent	*xmi = xmi_entry(item);
+	int				error;
+
+	/*
+	 * Exchange one more mappings between two files.  If there's still more
+	 * work to do, we want to requeue ourselves after all other pending
+	 * deferred operations have finished.  This includes all of the dfops
+	 * that we queued directly as well as any new ones created in the
+	 * process of finishing the others.  Doing so prevents us from queuing
+	 * a large number of XMI log items in kernel memory, which in turn
+	 * prevents us from pinning the tail of the log (while logging those
+	 * new XMI items) until the first XMI items can be processed.
+	 */
+	error = xfs_exchmaps_finish_one(tp, xmi);
+	if (error != -EAGAIN)
+		xfs_exchmaps_cancel_item(item);
+	return error;
+}
+
+/* Abort all pending XMIs. */
+STATIC void
+xfs_exchmaps_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_xmi_release(XMI_ITEM(intent));
+}
+
+/* Is this recovered XMI ok? */
+static inline bool
+xfs_xmi_validate(
+	struct xfs_mount		*mp,
+	struct xfs_xmi_log_item		*xmi_lip)
+{
+	struct xfs_xmi_log_format	*xlf = &xmi_lip->xmi_format;
+
+	if (!xfs_has_exchange_range(mp))
+		return false;
+
+	if (xmi_lip->xmi_format.__pad != 0)
+		return false;
+
+	if (xlf->xmi_flags & ~XFS_EXCHMAPS_LOGGED_FLAGS)
+		return false;
+
+	if (!xfs_verify_ino(mp, xlf->xmi_inode1) ||
+	    !xfs_verify_ino(mp, xlf->xmi_inode2))
+		return false;
+
+	if (!xfs_verify_fileext(mp, xlf->xmi_startoff1, xlf->xmi_blockcount))
+		return false;
+
+	return xfs_verify_fileext(mp, xlf->xmi_startoff2, xlf->xmi_blockcount);
+}
+
+/*
+ * Use the recovered log state to create a new request, estimate resource
+ * requirements, and create a new incore intent state.
+ */
+STATIC struct xfs_exchmaps_intent *
+xfs_xmi_item_recover_intent(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	const struct xfs_xmi_log_format	*xlf,
+	struct xfs_exchmaps_req		*req,
+	struct xfs_inode		**ipp1,
+	struct xfs_inode		**ipp2)
+{
+	struct xfs_inode		*ip1, *ip2;
+	struct xfs_exchmaps_intent	*xmi;
+	int				error;
+
+	/*
+	 * Grab both inodes and set IRECOVERY to prevent trimming of post-eof
+	 * mappings and freeing of unlinked inodes until we're totally done
+	 * processing files.  The ondisk format of this new log item contains
+	 * file handle information, which is why recovery for other items do
+	 * not check the inode generation number.
+	 */
+	error = xlog_recover_iget_handle(mp, xlf->xmi_inode1, xlf->xmi_igen1,
+			&ip1);
+	if (error) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, xlf,
+				sizeof(*xlf));
+		return ERR_PTR(error);
+	}
+
+	error = xlog_recover_iget_handle(mp, xlf->xmi_inode2, xlf->xmi_igen2,
+			&ip2);
+	if (error) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, xlf,
+				sizeof(*xlf));
+		goto err_rele1;
+	}
+
+	req->ip1 = ip1;
+	req->ip2 = ip2;
+	req->startoff1 = xlf->xmi_startoff1;
+	req->startoff2 = xlf->xmi_startoff2;
+	req->blockcount = xlf->xmi_blockcount;
+	req->flags = xlf->xmi_flags & XFS_EXCHMAPS_PARAMS;
+
+	xfs_exchrange_ilock(NULL, ip1, ip2);
+	error = xfs_exchmaps_estimate(req);
+	xfs_exchrange_iunlock(ip1, ip2);
+	if (error)
+		goto err_rele2;
+
+	*ipp1 = ip1;
+	*ipp2 = ip2;
+	xmi = xfs_exchmaps_init_intent(req);
+	xfs_defer_add_item(dfp, &xmi->xmi_list);
+	return xmi;
+
+err_rele2:
+	xfs_irele(ip2);
+err_rele1:
+	xfs_irele(ip1);
+	req->ip2 = req->ip1 = NULL;
+	return ERR_PTR(error);
+}
+
+/* Process a file mapping exchange item that was recovered from the log. */
+STATIC int
+xfs_exchmaps_recover_work(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	struct xfs_exchmaps_req		req = { .flags = 0 };
+	struct xfs_trans_res		resv;
+	struct xfs_exchmaps_intent	*xmi;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
+	struct xfs_xmi_log_item		*xmi_lip = XMI_ITEM(lip);
+	struct xfs_mount		*mp = lip->li_log->l_mp;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip1, *ip2;
+	int				error = 0;
+
+	if (!xfs_xmi_validate(mp, xmi_lip)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&xmi_lip->xmi_format,
+				sizeof(xmi_lip->xmi_format));
+		return -EFSCORRUPTED;
+	}
+
+	xmi = xfs_xmi_item_recover_intent(mp, dfp, &xmi_lip->xmi_format, &req,
+			&ip1, &ip2);
+	if (IS_ERR(xmi))
+		return PTR_ERR(xmi);
+
+	trace_xfs_exchmaps_recover(mp, xmi);
+
+	resv = xlog_recover_resv(&M_RES(mp)->tr_write);
+	error = xfs_trans_alloc(mp, &resv, req.resblks, 0, 0, &tp);
+	if (error)
+		goto err_rele;
+
+	xfs_exchrange_ilock(tp, ip1, ip2);
+
+	xfs_exchmaps_ensure_reflink(tp, xmi);
+	xfs_exchmaps_upgrade_extent_counts(tp, xmi);
+	error = xlog_recover_finish_intent(tp, dfp);
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&xmi_lip->xmi_format,
+				sizeof(xmi_lip->xmi_format));
+	if (error)
+		goto err_cancel;
+
+	/*
+	 * Commit transaction, which frees the transaction and saves the inodes
+	 * for later replay activities.
+	 */
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	goto err_unlock;
+
+err_cancel:
+	xfs_trans_cancel(tp);
+err_unlock:
+	xfs_exchrange_iunlock(ip1, ip2);
+err_rele:
+	xfs_irele(ip2);
+	xfs_irele(ip1);
+	return error;
+}
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_exchmaps_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_xmi_log_item		*xmi_lip;
+	struct xfs_xmi_log_format	*old_xlf, *new_xlf;
+
+	old_xlf = &XMI_ITEM(intent)->xmi_format;
+
+	xmi_lip = xfs_xmi_init(tp->t_mountp);
+	new_xlf = &xmi_lip->xmi_format;
+
+	new_xlf->xmi_inode1	= old_xlf->xmi_inode1;
+	new_xlf->xmi_inode2	= old_xlf->xmi_inode2;
+	new_xlf->xmi_igen1	= old_xlf->xmi_igen1;
+	new_xlf->xmi_igen2	= old_xlf->xmi_igen2;
+	new_xlf->xmi_startoff1	= old_xlf->xmi_startoff1;
+	new_xlf->xmi_startoff2	= old_xlf->xmi_startoff2;
+	new_xlf->xmi_blockcount	= old_xlf->xmi_blockcount;
+	new_xlf->xmi_flags	= old_xlf->xmi_flags;
+	new_xlf->xmi_isize1	= old_xlf->xmi_isize1;
+	new_xlf->xmi_isize2	= old_xlf->xmi_isize2;
+
+	return &xmi_lip->xmi_item;
+}
+
+const struct xfs_defer_op_type xfs_exchmaps_defer_type = {
+	.name		= "exchmaps",
+	.max_items	= 1,
+	.create_intent	= xfs_exchmaps_create_intent,
+	.abort_intent	= xfs_exchmaps_abort_intent,
+	.create_done	= xfs_exchmaps_create_done,
+	.finish_item	= xfs_exchmaps_finish_item,
+	.cancel_item	= xfs_exchmaps_cancel_item,
+	.recover_work	= xfs_exchmaps_recover_work,
+	.relog_intent	= xfs_exchmaps_relog_intent,
+};
+
+STATIC bool
+xfs_xmi_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return XMI_ITEM(lip)->xmi_format.xmi_id == intent_id;
+}
+
+static const struct xfs_item_ops xfs_xmi_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
+	.iop_size	= xfs_xmi_item_size,
+	.iop_format	= xfs_xmi_item_format,
+	.iop_unpin	= xfs_xmi_item_unpin,
+	.iop_release	= xfs_xmi_item_release,
+	.iop_match	= xfs_xmi_item_match,
+};
+
+/*
+ * This routine is called to create an in-core file mapping exchange item from
+ * the xmi format structure which was logged on disk.  It allocates an in-core
+ * xmi, copies the exchange information from the format structure into it, and
+ * adds the xmi to the AIL with the given LSN.
+ */
+STATIC int
+xlog_recover_xmi_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_xmi_log_item		*xmi_lip;
+	struct xfs_xmi_log_format	*xmi_formatp;
+	size_t				len;
+
+	len = sizeof(struct xfs_xmi_log_format);
+	if (item->ri_buf[0].iov_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	xmi_formatp = item->ri_buf[0].iov_base;
+	if (xmi_formatp->__pad != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	xmi_lip = xfs_xmi_init(mp);
+	memcpy(&xmi_lip->xmi_format, xmi_formatp, len);
+
+	xlog_recover_intent_item(log, &xmi_lip->xmi_item, lsn,
+			&xfs_exchmaps_defer_type);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_xmi_item_ops = {
+	.item_type		= XFS_LI_XMI,
+	.commit_pass2		= xlog_recover_xmi_commit_pass2,
+};
+
+/*
+ * This routine is called when an XMD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding XMI if it
+ * was still in the log. To do this it searches the AIL for the XMI with an id
+ * equal to that in the XMD format structure. If we find it we drop the XMD
+ * reference, which removes the XMI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_xmd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_xmd_log_format	*xmd_formatp;
+
+	xmd_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_xmd_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_XMI, xmd_formatp->xmd_xmi_id);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_xmd_item_ops = {
+	.item_type		= XFS_LI_XMD,
+	.commit_pass2		= xlog_recover_xmd_commit_pass2,
+};
diff --git a/libxlog/xfs_exchmaps_item.h b/libxlog/xfs_exchmaps_item.h
new file mode 100644
index 00000000..efa368d2
--- /dev/null
+++ b/libxlog/xfs_exchmaps_item.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef	__XFS_EXCHMAPS_ITEM_H__
+#define	__XFS_EXCHMAPS_ITEM_H__
+
+/*
+ * The file mapping exchange intent item helps us exchange multiple file
+ * mappings between two inode forks.  It does this by tracking the range of
+ * file block offsets that still need to be exchanged, and relogs as progress
+ * happens.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated bmbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * rest of the mapping exchanges.
+ */
+
+/* kernel only XMI/XMD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * This is the incore file mapping exchange intent log item.  It is used to log
+ * the fact that we are exchanging mappings between two files.  It is used in
+ * conjunction with the incore file mapping exchange done log item described
+ * below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_xmi_log_item {
+	struct xfs_log_item		xmi_item;
+	atomic_t			xmi_refcount;
+	struct xfs_xmi_log_format	xmi_format;
+};
+
+/*
+ * This is the incore file mapping exchange done log item.  It is used to log
+ * the fact that an exchange mentioned in an earlier xmi item have been
+ * performed.
+ */
+struct xfs_xmd_log_item {
+	struct xfs_log_item		xmd_item;
+	struct xfs_xmi_log_item		*xmd_intent_log_item;
+	struct xfs_xmd_log_format	xmd_format;
+};
+
+extern struct kmem_cache	*xfs_xmi_cache;
+extern struct kmem_cache	*xfs_xmd_cache;
+
+struct xfs_exchmaps_intent;
+
+void xfs_exchmaps_defer_add(struct xfs_trans *tp,
+		struct xfs_exchmaps_intent *xmi);
+
+#endif	/* __XFS_EXCHMAPS_ITEM_H__ */
diff --git a/libxlog/xfs_extfree_item.c b/libxlog/xfs_extfree_item.c
new file mode 100644
index 00000000..24864e7a
--- /dev/null
+++ b/libxlog/xfs_extfree_item.c
@@ -0,0 +1,1026 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_ag.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_extfree_item.h"
+#include "xfs_log.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_trace.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_inode.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
+
+struct kmem_cache	*xfs_efi_cache;
+struct kmem_cache	*xfs_efd_cache;
+
+static const struct xfs_item_ops xfs_efi_item_ops;
+
+static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_efi_log_item, efi_item);
+}
+
+STATIC void
+xfs_efi_item_free(
+	struct xfs_efi_log_item	*efip)
+{
+	kvfree(efip->efi_item.li_lv_shadow);
+	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
+		kfree(efip);
+	else
+		kmem_cache_free(xfs_efi_cache, efip);
+}
+
+/*
+ * Freeing the efi requires that we remove it from the AIL if it has already
+ * been placed there. However, the EFI may not yet have been placed in the AIL
+ * when called by xfs_efi_release() from EFD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the EFI.
+ */
+STATIC void
+xfs_efi_release(
+	struct xfs_efi_log_item	*efip)
+{
+	ASSERT(atomic_read(&efip->efi_refcount) > 0);
+	if (!atomic_dec_and_test(&efip->efi_refcount))
+		return;
+
+	xfs_trans_ail_delete(&efip->efi_item, 0);
+	xfs_efi_item_free(efip);
+}
+
+STATIC void
+xfs_efi_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents);
+}
+
+unsigned int xfs_efi_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efi_log_format_sizeof(nr));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given efi log item. We use only 1 iovec, and we point that
+ * at the efi_log_format structure embedded in the efi item.
+ * It is at this point that we assert that all of the extent
+ * slots in the efi item have been filled.
+ */
+STATIC void
+xfs_efi_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+
+	ASSERT(atomic_read(&efip->efi_next_extent) ==
+				efip->efi_format.efi_nextents);
+	ASSERT(lip->li_type == XFS_LI_EFI || lip->li_type == XFS_LI_EFI_RT);
+
+	efip->efi_format.efi_type = lip->li_type;
+	efip->efi_format.efi_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_EFI_FORMAT, &efip->efi_format,
+			xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents));
+}
+
+/*
+ * The unpin operation is the last place an EFI is manipulated in the log. It is
+ * either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the EFI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the EFI to either construct
+ * and commit the EFD or drop the EFD's reference in the event of error. Simply
+ * drop the log's EFI reference now that the log is done with it.
+ */
+STATIC void
+xfs_efi_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+	xfs_efi_release(efip);
+}
+
+/*
+ * The EFI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an EFD isn't going to be
+ * constructed and thus we free the EFI here directly.
+ */
+STATIC void
+xfs_efi_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_efi_release(EFI_ITEM(lip));
+}
+
+/*
+ * Allocate and initialize an efi item with the given number of extents.
+ */
+STATIC struct xfs_efi_log_item *
+xfs_efi_init(
+	struct xfs_mount	*mp,
+	unsigned short		item_type,
+	uint			nextents)
+{
+	struct xfs_efi_log_item	*efip;
+
+	ASSERT(item_type == XFS_LI_EFI || item_type == XFS_LI_EFI_RT);
+	ASSERT(nextents > 0);
+
+	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
+		efip = kzalloc(xfs_efi_log_item_sizeof(nextents),
+				GFP_KERNEL | __GFP_NOFAIL);
+	} else {
+		efip = kmem_cache_zalloc(xfs_efi_cache,
+					 GFP_KERNEL | __GFP_NOFAIL);
+	}
+
+	xfs_log_item_init(mp, &efip->efi_item, item_type, &xfs_efi_item_ops);
+	efip->efi_format.efi_nextents = nextents;
+	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
+	atomic_set(&efip->efi_next_extent, 0);
+	atomic_set(&efip->efi_refcount, 2);
+
+	return efip;
+}
+
+/*
+ * Copy an EFI format buffer from the given buf, and into the destination
+ * EFI format structure.
+ * The given buffer can be in 32 bit or 64 bit form (which has different padding),
+ * one of which will be the native format for this kernel.
+ * It will handle the conversion of formats if necessary.
+ */
+STATIC int
+xfs_efi_copy_format(
+	struct kvec			*buf,
+	struct xfs_efi_log_format	*dst_efi_fmt)
+{
+	struct xfs_efi_log_format	*src_efi_fmt = buf->iov_base;
+	uint				len, len32, len64, i;
+
+	len = xfs_efi_log_format_sizeof(src_efi_fmt->efi_nextents);
+	len32 = xfs_efi_log_format32_sizeof(src_efi_fmt->efi_nextents);
+	len64 = xfs_efi_log_format64_sizeof(src_efi_fmt->efi_nextents);
+
+	if (buf->iov_len == len) {
+		memcpy(dst_efi_fmt, src_efi_fmt,
+		       offsetof(struct xfs_efi_log_format, efi_extents));
+		for (i = 0; i < src_efi_fmt->efi_nextents; i++)
+			memcpy(&dst_efi_fmt->efi_extents[i],
+			       &src_efi_fmt->efi_extents[i],
+			       sizeof(struct xfs_extent));
+		return 0;
+	} else if (buf->iov_len == len32) {
+		struct xfs_efi_log_format_32 *src_efi_fmt_32 = buf->iov_base;
+
+		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
+		dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
+		dst_efi_fmt->efi_nextents = src_efi_fmt_32->efi_nextents;
+		dst_efi_fmt->efi_id       = src_efi_fmt_32->efi_id;
+		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
+			dst_efi_fmt->efi_extents[i].ext_start =
+				src_efi_fmt_32->efi_extents[i].ext_start;
+			dst_efi_fmt->efi_extents[i].ext_len =
+				src_efi_fmt_32->efi_extents[i].ext_len;
+		}
+		return 0;
+	} else if (buf->iov_len == len64) {
+		struct xfs_efi_log_format_64 *src_efi_fmt_64 = buf->iov_base;
+
+		dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
+		dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
+		dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
+		dst_efi_fmt->efi_id       = src_efi_fmt_64->efi_id;
+		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
+			dst_efi_fmt->efi_extents[i].ext_start =
+				src_efi_fmt_64->efi_extents[i].ext_start;
+			dst_efi_fmt->efi_extents[i].ext_len =
+				src_efi_fmt_64->efi_extents[i].ext_len;
+		}
+		return 0;
+	}
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, NULL, buf->iov_base,
+			buf->iov_len);
+	return -EFSCORRUPTED;
+}
+
+static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_efd_log_item, efd_item);
+}
+
+STATIC void
+xfs_efd_item_free(struct xfs_efd_log_item *efdp)
+{
+	kvfree(efdp->efd_item.li_lv_shadow);
+	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
+		kfree(efdp);
+	else
+		kmem_cache_free(xfs_efd_cache, efdp);
+}
+
+STATIC void
+xfs_efd_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents);
+}
+
+unsigned int xfs_efd_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efd_log_format_sizeof(nr));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given efd log item. We use only 1 iovec, and we point that
+ * at the efd_log_format structure embedded in the efd item.
+ * It is at this point that we assert that all of the extent
+ * slots in the efd item have been filled.
+ */
+STATIC void
+xfs_efd_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+
+	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
+	ASSERT(lip->li_type == XFS_LI_EFD || lip->li_type == XFS_LI_EFD_RT);
+
+	efdp->efd_format.efd_type = lip->li_type;
+	efdp->efd_format.efd_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_EFD_FORMAT, &efdp->efd_format,
+			xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents));
+}
+
+/*
+ * The EFD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the EFI and free the EFD.
+ */
+STATIC void
+xfs_efd_item_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+
+	xfs_efi_release(efdp->efd_efip);
+	xfs_efd_item_free(efdp);
+}
+
+static struct xfs_log_item *
+xfs_efd_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &EFD_ITEM(lip)->efd_efip->efi_item;
+}
+
+static const struct xfs_item_ops xfs_efd_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
+	.iop_size	= xfs_efd_item_size,
+	.iop_format	= xfs_efd_item_format,
+	.iop_release	= xfs_efd_item_release,
+	.iop_intent	= xfs_efd_item_intent,
+};
+
+static inline struct xfs_extent_free_item *xefi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_extent_free_item, xefi_list);
+}
+
+static inline bool
+xfs_efi_item_isrt(const struct xfs_log_item *lip)
+{
+	ASSERT(lip->li_type == XFS_LI_EFI || lip->li_type == XFS_LI_EFI_RT);
+
+	return lip->li_type == XFS_LI_EFI_RT;
+}
+
+/*
+ * Fill the EFD with all extents from the EFI when we need to roll the
+ * transaction and continue with a new EFI.
+ *
+ * This simply copies all the extents in the EFI to the EFD rather than make
+ * assumptions about which extents in the EFI have already been processed. We
+ * currently keep the xefi list in the same order as the EFI extent list, but
+ * that may not always be the case. Copying everything avoids leaving a landmine
+ * were we fail to cancel all the extents in an EFI if the xefi list is
+ * processed in a different order to the extents in the EFI.
+ */
+static void
+xfs_efd_from_efi(
+	struct xfs_efd_log_item	*efdp)
+{
+	struct xfs_efi_log_item *efip = efdp->efd_efip;
+	uint                    i;
+
+	ASSERT(efip->efi_format.efi_nextents > 0);
+	ASSERT(efdp->efd_next_extent < efip->efi_format.efi_nextents);
+
+	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+	       efdp->efd_format.efd_extents[i] =
+		       efip->efi_format.efi_extents[i];
+	}
+	efdp->efd_next_extent = efip->efi_format.efi_nextents;
+}
+
+static void
+xfs_efd_add_extent(
+	struct xfs_efd_log_item		*efdp,
+	struct xfs_extent_free_item	*xefi)
+{
+	struct xfs_extent		*extp;
+
+	ASSERT(efdp->efd_next_extent < efdp->efd_format.efd_nextents);
+
+	extp = &efdp->efd_format.efd_extents[efdp->efd_next_extent];
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
+
+	efdp->efd_next_extent++;
+}
+
+/* Sort bmap items by AG. */
+static int
+xfs_extent_free_diff_items(
+	void				*priv,
+	const struct list_head		*a,
+	const struct list_head		*b)
+{
+	struct xfs_extent_free_item	*ra = xefi_entry(a);
+	struct xfs_extent_free_item	*rb = xefi_entry(b);
+
+	return cmp_int(ra->xefi_group->xg_gno, rb->xefi_group->xg_gno);
+}
+
+/* Log a free extent to the intent item. */
+STATIC void
+xfs_extent_free_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_efi_log_item		*efip,
+	struct xfs_extent_free_item	*xefi)
+{
+	uint				next_extent;
+	struct xfs_extent		*extp;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&efip->efi_next_extent) - 1;
+	ASSERT(next_extent < efip->efi_format.efi_nextents);
+	extp = &efip->efi_format.efi_extents[next_extent];
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
+}
+
+static struct xfs_log_item *
+__xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort,
+	unsigned short			item_type)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_extent_free_item	*xefi;
+
+	ASSERT(count > 0);
+
+	efip = xfs_efi_init(mp, item_type, count);
+	if (sort)
+		list_sort(mp, items, xfs_extent_free_diff_items);
+	list_for_each_entry(xefi, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, xefi);
+	return &efip->efi_item;
+}
+
+static struct xfs_log_item *
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_extent_free_create_intent(tp, items, count, sort,
+			XFS_LI_EFI);
+}
+
+static inline unsigned short
+xfs_efd_type_from_efi(const struct xfs_efi_log_item *efip)
+{
+	return xfs_efi_item_isrt(&efip->efi_item) ?  XFS_LI_EFD_RT : XFS_LI_EFD;
+}
+
+/* Get an EFD so we can process all the free extents. */
+static struct xfs_log_item *
+xfs_extent_free_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	struct xfs_efi_log_item		*efip = EFI_ITEM(intent);
+	struct xfs_efd_log_item		*efdp;
+
+	ASSERT(count > 0);
+
+	if (count > XFS_EFD_MAX_FAST_EXTENTS) {
+		efdp = kzalloc(xfs_efd_log_item_sizeof(count),
+				GFP_KERNEL | __GFP_NOFAIL);
+	} else {
+		efdp = kmem_cache_zalloc(xfs_efd_cache,
+					GFP_KERNEL | __GFP_NOFAIL);
+	}
+
+	xfs_log_item_init(tp->t_mountp, &efdp->efd_item,
+			xfs_efd_type_from_efi(efip), &xfs_efd_item_ops);
+	efdp->efd_efip = efip;
+	efdp->efd_format.efd_nextents = count;
+	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
+
+	return &efdp->efd_item;
+}
+
+static inline const struct xfs_defer_op_type *
+xefi_ops(
+	struct xfs_extent_free_item	*xefi)
+{
+	if (xfs_efi_is_realtime(xefi))
+		return &xfs_rtextent_free_defer_type;
+	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
+		return &xfs_agfl_free_defer_type;
+	return &xfs_extent_free_defer_type;
+}
+
+/* Add this deferred EFI to the transaction. */
+void
+xfs_extent_free_defer_add(
+	struct xfs_trans		*tp,
+	struct xfs_extent_free_item	*xefi,
+	struct xfs_defer_pending	**dfpp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	xefi->xefi_group = xfs_group_intent_get(mp, xefi->xefi_startblock,
+			xfs_efi_is_realtime(xefi) ? XG_TYPE_RTG : XG_TYPE_AG);
+
+	trace_xfs_extent_free_defer(mp, xefi);
+	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, xefi_ops(xefi));
+}
+
+/* Cancel a free extent. */
+STATIC void
+xfs_extent_free_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+
+	xfs_group_intent_put(xefi->xefi_group);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
+}
+
+/* Process a free extent. */
+STATIC int
+xfs_extent_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_owner_info		oinfo = { };
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_agblock_t			agbno;
+	int				error = 0;
+
+	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
+
+	oinfo.oi_owner = xefi->xefi_owner;
+	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+
+	trace_xfs_extent_free_deferred(mp, xefi);
+
+	/*
+	 * If we need a new transaction to make progress, the caller will log a
+	 * new EFI with the current contents. It will also log an EFD to cancel
+	 * the existing EFI, and so we need to copy all the unprocessed extents
+	 * in this EFI to the EFD so this works correctly.
+	 */
+	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED))
+		error = __xfs_free_extent(tp, to_perag(xefi->xefi_group), agbno,
+				xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
+				xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	if (error == -EAGAIN) {
+		xfs_efd_from_efi(efdp);
+		return error;
+	}
+
+	xfs_efd_add_extent(efdp, xefi);
+	xfs_extent_free_cancel_item(item);
+	return error;
+}
+
+/* Abort all pending EFIs. */
+STATIC void
+xfs_extent_free_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_efi_release(EFI_ITEM(intent));
+}
+
+/*
+ * AGFL blocks are accounted differently in the reserve pools and are not
+ * inserted into the busy extent list.
+ */
+STATIC int
+xfs_agfl_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_owner_info		oinfo = { };
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+	struct xfs_buf			*agbp;
+	int				error;
+	xfs_agblock_t			agbno;
+
+	ASSERT(xefi->xefi_blockcount == 1);
+	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
+	oinfo.oi_owner = xefi->xefi_owner;
+
+	trace_xfs_agfl_free_deferred(mp, xefi);
+
+	error = xfs_alloc_read_agf(to_perag(xefi->xefi_group), tp, 0, &agbp);
+	if (!error)
+		error = xfs_free_ag_extent(tp, agbp, agbno, 1, &oinfo,
+				XFS_AG_RESV_AGFL);
+
+	xfs_efd_add_extent(efdp, xefi);
+	xfs_extent_free_cancel_item(&xefi->xefi_list);
+	return error;
+}
+
+/* Is this recovered EFI ok? */
+static inline bool
+xfs_efi_validate_ext(
+	struct xfs_mount		*mp,
+	bool				isrt,
+	struct xfs_extent		*extp)
+{
+	if (isrt)
+		return xfs_verify_rtbext(mp, extp->ext_start, extp->ext_len);
+
+	return xfs_verify_fsbext(mp, extp->ext_start, extp->ext_len);
+}
+
+static inline void
+xfs_efi_recover_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	bool				isrt,
+	struct xfs_extent		*extp)
+{
+	struct xfs_extent_free_item	*xefi;
+
+	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
+			       GFP_KERNEL | __GFP_NOFAIL);
+	xefi->xefi_startblock = extp->ext_start;
+	xefi->xefi_blockcount = extp->ext_len;
+	xefi->xefi_agresv = XFS_AG_RESV_NONE;
+	xefi->xefi_owner = XFS_RMAP_OWN_UNKNOWN;
+	xefi->xefi_group = xfs_group_intent_get(mp, extp->ext_start,
+			isrt ? XG_TYPE_RTG : XG_TYPE_AG);
+	if (isrt)
+		xefi->xefi_flags |= XFS_EFI_REALTIME;
+
+	xfs_defer_add_item(dfp, &xefi->xefi_list);
+}
+
+/*
+ * Process an extent free intent item that was recovered from
+ * the log.  We need to free the extents that it describes.
+ */
+STATIC int
+xfs_extent_free_recover_work(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
+	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
+	struct xfs_mount		*mp = lip->li_log->l_mp;
+	struct xfs_trans		*tp;
+	int				i;
+	int				error = 0;
+	bool				isrt = xfs_efi_item_isrt(lip);
+
+	/*
+	 * First check the validity of the extents described by the EFI.  If
+	 * any are bad, then assume that all are bad and just toss the EFI.
+	 * Mixing RT and non-RT extents in the same EFI item is not allowed.
+	 */
+	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+		if (!xfs_efi_validate_ext(mp, isrt,
+					&efip->efi_format.efi_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&efip->efi_format,
+					sizeof(efip->efi_format));
+			return -EFSCORRUPTED;
+		}
+
+		xfs_efi_recover_work(mp, dfp, isrt,
+				&efip->efi_format.efi_extents[i]);
+	}
+
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	error = xlog_recover_finish_intent(tp, dfp);
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&efip->efi_format,
+				sizeof(efip->efi_format));
+	if (error)
+		goto abort_error;
+
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+
+abort_error:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_extent_free_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done_item);
+	struct xfs_efi_log_item		*efip;
+	struct xfs_extent		*extp;
+	unsigned int			count;
+
+	count = EFI_ITEM(intent)->efi_format.efi_nextents;
+	extp = EFI_ITEM(intent)->efi_format.efi_extents;
+
+	ASSERT(intent->li_type == XFS_LI_EFI || intent->li_type == XFS_LI_EFI_RT);
+
+	efdp->efd_next_extent = count;
+	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
+
+	efip = xfs_efi_init(tp->t_mountp, intent->li_type, count);
+	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
+	atomic_set(&efip->efi_next_extent, count);
+
+	return &efip->efi_item;
+}
+
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.name		= "extent_free",
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_extent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+	.relog_intent	= xfs_extent_free_relog_intent,
+};
+
+/* sub-type with special handling for AGFL deferred frees */
+const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.name		= "agfl_free",
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_agfl_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+	.relog_intent	= xfs_extent_free_relog_intent,
+};
+
+#ifdef CONFIG_XFS_RT
+/* Create a realtime extent freeing */
+static struct xfs_log_item *
+xfs_rtextent_free_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_extent_free_create_intent(tp, items, count, sort,
+			XFS_LI_EFI_RT);
+}
+
+/* Process a free realtime extent. */
+STATIC int
+xfs_rtextent_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
+	struct xfs_rtgroup		**rtgp = (struct xfs_rtgroup **)state;
+	int				error = 0;
+
+	trace_xfs_extent_free_deferred(mp, xefi);
+
+	if (xefi->xefi_flags & XFS_EFI_CANCELLED)
+		goto done;
+
+	if (*rtgp != to_rtg(xefi->xefi_group)) {
+		unsigned int		lock_flags;
+
+		if (xfs_has_zoned(mp))
+			lock_flags = XFS_RTGLOCK_RMAP;
+		else
+			lock_flags = XFS_RTGLOCK_BITMAP;
+
+		*rtgp = to_rtg(xefi->xefi_group);
+		xfs_rtgroup_lock(*rtgp, lock_flags);
+		xfs_rtgroup_trans_join(tp, *rtgp, lock_flags);
+	}
+
+	if (xfs_has_zoned(mp)) {
+		error = xfs_zone_free_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	} else {
+		error = xfs_rtfree_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	}
+
+	if (error == -EAGAIN) {
+		xfs_efd_from_efi(efdp);
+		return error;
+	}
+done:
+	xfs_efd_add_extent(efdp, xefi);
+	xfs_extent_free_cancel_item(item);
+	return error;
+}
+
+const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
+	.name		= "rtextent_free",
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rtextent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_rtextent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+	.relog_intent	= xfs_extent_free_relog_intent,
+};
+#else
+const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
+	.name		= "rtextent_free",
+};
+#endif /* CONFIG_XFS_RT */
+
+STATIC bool
+xfs_efi_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
+}
+
+static const struct xfs_item_ops xfs_efi_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
+	.iop_size	= xfs_efi_item_size,
+	.iop_format	= xfs_efi_item_format,
+	.iop_unpin	= xfs_efi_item_unpin,
+	.iop_release	= xfs_efi_item_release,
+	.iop_match	= xfs_efi_item_match,
+};
+
+/*
+ * This routine is called to create an in-core extent free intent
+ * item from the efi format structure which was logged on disk.
+ * It allocates an in-core efi, copies the extents from the format
+ * structure into it, and adds the efi to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_efi_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_efi_log_format	*efi_formatp;
+	int				error;
+
+	efi_formatp = item->ri_buf[0].iov_base;
+
+	if (item->ri_buf[0].iov_len < xfs_efi_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
+	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	if (error) {
+		xfs_efi_item_free(efip);
+		return error;
+	}
+	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
+
+	xlog_recover_intent_item(log, &efip->efi_item, lsn,
+			&xfs_extent_free_defer_type);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_efi_item_ops = {
+	.item_type		= XFS_LI_EFI,
+	.commit_pass2		= xlog_recover_efi_commit_pass2,
+};
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtefi_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_efi_log_format	*efi_formatp;
+	int				error;
+
+	efi_formatp = item->ri_buf[0].iov_base;
+
+	if (item->ri_buf[0].iov_len < xfs_efi_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
+	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	if (error) {
+		xfs_efi_item_free(efip);
+		return error;
+	}
+	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
+
+	xlog_recover_intent_item(log, &efip->efi_item, lsn,
+			&xfs_rtextent_free_defer_type);
+	return 0;
+}
+#else
+STATIC int
+xlog_recover_rtefi_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+			item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	return -EFSCORRUPTED;
+}
+#endif
+
+const struct xlog_recover_item_ops xlog_rtefi_item_ops = {
+	.item_type		= XFS_LI_EFI_RT,
+	.commit_pass2		= xlog_recover_rtefi_commit_pass2,
+};
+
+/*
+ * This routine is called when an EFD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding EFI if it
+ * was still in the log. To do this it searches the AIL for the EFI with an id
+ * equal to that in the EFD format structure. If we find it we drop the EFD
+ * reference, which removes the EFI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_efd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_efd_log_format	*efd_formatp;
+	int				buflen = item->ri_buf[0].iov_len;
+
+	efd_formatp = item->ri_buf[0].iov_base;
+
+	if (buflen < sizeof(struct xfs_efd_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
+
+	if (item->ri_buf[0].iov_len != xfs_efd_log_format32_sizeof(
+						efd_formatp->efd_nextents) &&
+	    item->ri_buf[0].iov_len != xfs_efd_log_format64_sizeof(
+						efd_formatp->efd_nextents)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_efd_item_ops = {
+	.item_type		= XFS_LI_EFD,
+	.commit_pass2		= xlog_recover_efd_commit_pass2,
+};
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtefd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_efd_log_format	*efd_formatp;
+	int				buflen = item->ri_buf[0].iov_len;
+
+	efd_formatp = item->ri_buf[0].iov_base;
+
+	if (buflen < sizeof(struct xfs_efd_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
+
+	if (item->ri_buf[0].iov_len != xfs_efd_log_format32_sizeof(
+						efd_formatp->efd_nextents) &&
+	    item->ri_buf[0].iov_len != xfs_efd_log_format64_sizeof(
+						efd_formatp->efd_nextents)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_EFI_RT,
+			efd_formatp->efd_efi_id);
+	return 0;
+}
+#else
+# define xlog_recover_rtefd_commit_pass2	xlog_recover_rtefi_commit_pass2
+#endif
+
+const struct xlog_recover_item_ops xlog_rtefd_item_ops = {
+	.item_type		= XFS_LI_EFD_RT,
+	.commit_pass2		= xlog_recover_rtefd_commit_pass2,
+};
diff --git a/libxlog/xfs_extfree_item.h b/libxlog/xfs_extfree_item.h
new file mode 100644
index 00000000..af1b0331
--- /dev/null
+++ b/libxlog/xfs_extfree_item.h
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_EXTFREE_ITEM_H__
+#define	__XFS_EXTFREE_ITEM_H__
+
+/* kernel only EFI/EFD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_EFI_MAX_FAST_EXTENTS	16
+
+/*
+ * This is the "extent free intention" log item.  It is used to log the fact
+ * that some extents need to be free.  It is used in conjunction with the
+ * "extent free done" log item described below.
+ *
+ * The EFI is reference counted so that it is not freed prior to both the EFI
+ * and EFD being committed and unpinned. This ensures the EFI is inserted into
+ * the AIL even in the event of out of order EFI/EFD processing. In other words,
+ * an EFI is born with two references:
+ *
+ * 	1.) an EFI held reference to track EFI AIL insertion
+ * 	2.) an EFD held reference to track EFD commit
+ *
+ * On allocation, both references are the responsibility of the caller. Once the
+ * EFI is added to and dirtied in a transaction, ownership of reference one
+ * transfers to the transaction. The reference is dropped once the EFI is
+ * inserted to the AIL or in the event of failure along the way (e.g., commit
+ * failure, log I/O error, etc.). Note that the caller remains responsible for
+ * the EFD reference under all circumstances to this point. The caller has no
+ * means to detect failure once the transaction is committed, however.
+ * Therefore, an EFD is required after this point, even in the event of
+ * unrelated failure.
+ *
+ * Once an EFD is allocated and dirtied in a transaction, reference two
+ * transfers to the transaction. The EFD reference is dropped once it reaches
+ * the unpin handler. Similar to the EFI, the reference also drops in the event
+ * of commit failure or log I/O errors. Note that the EFD is not inserted in the
+ * AIL, so at this point both the EFI and EFD are freed.
+ */
+struct xfs_efi_log_item {
+	struct xfs_log_item	efi_item;
+	atomic_t		efi_refcount;
+	atomic_t		efi_next_extent;
+	struct xfs_efi_log_format efi_format;
+};
+
+static inline size_t
+xfs_efi_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_efi_log_item, efi_format) +
+			xfs_efi_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "extent free done" log item.  It is used to log
+ * the fact that some extents earlier mentioned in an efi item
+ * have been freed.
+ */
+struct xfs_efd_log_item {
+	struct xfs_log_item	efd_item;
+	struct xfs_efi_log_item *efd_efip;
+	uint			efd_next_extent;
+	struct xfs_efd_log_format efd_format;
+};
+
+static inline size_t
+xfs_efd_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_efd_log_item, efd_format) +
+			xfs_efd_log_format_sizeof(nr);
+}
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_EFD_MAX_FAST_EXTENTS	16
+
+extern struct kmem_cache	*xfs_efi_cache;
+extern struct kmem_cache	*xfs_efd_cache;
+
+struct xfs_extent_free_item;
+
+void xfs_extent_free_defer_add(struct xfs_trans *tp,
+		struct xfs_extent_free_item *xefi,
+		struct xfs_defer_pending **dfpp);
+
+unsigned int xfs_efi_log_space(unsigned int nr);
+unsigned int xfs_efd_log_space(unsigned int nr);
+
+#endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/libxlog/xfs_icreate_item.c b/libxlog/xfs_icreate_item.c
new file mode 100644
index 00000000..95b0eba2
--- /dev/null
+++ b/libxlog/xfs_icreate_item.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2008-2010, 2013 Dave Chinner
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_icreate_item.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_ialloc.h"
+#include "xfs_trace.h"
+
+struct kmem_cache	*xfs_icreate_cache;		/* inode create item */
+
+static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_icreate_item, ic_item);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given inode item.
+ *
+ * We only need one iovec for the icreate log structure.
+ */
+STATIC void
+xfs_icreate_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_icreate_log);
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given inode create log item.
+ */
+STATIC void
+xfs_icreate_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_ICREATE, &icp->ic_format,
+			sizeof(struct xfs_icreate_log));
+}
+
+STATIC void
+xfs_icreate_item_release(
+	struct xfs_log_item	*lip)
+{
+	kvfree(ICR_ITEM(lip)->ic_item.li_lv_shadow);
+	kmem_cache_free(xfs_icreate_cache, ICR_ITEM(lip));
+}
+
+static const struct xfs_item_ops xfs_icreate_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.iop_size	= xfs_icreate_item_size,
+	.iop_format	= xfs_icreate_item_format,
+	.iop_release	= xfs_icreate_item_release,
+};
+
+
+/*
+ * Initialize the inode log item for a newly allocated (in-core) inode.
+ *
+ * Inode extents can only reside within an AG. Hence specify the starting
+ * block for the inode chunk by offset within an AG as well as the
+ * length of the allocated extent.
+ *
+ * This joins the item to the transaction and marks it dirty so
+ * that we don't need a separate call to do this, nor does the
+ * caller need to know anything about the icreate item.
+ */
+void
+xfs_icreate_log(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	unsigned int		count,
+	unsigned int		inode_size,
+	xfs_agblock_t		length,
+	unsigned int		generation)
+{
+	struct xfs_icreate_item	*icp;
+
+	icp = kmem_cache_zalloc(xfs_icreate_cache, GFP_KERNEL | __GFP_NOFAIL);
+
+	xfs_log_item_init(tp->t_mountp, &icp->ic_item, XFS_LI_ICREATE,
+			  &xfs_icreate_item_ops);
+
+	icp->ic_format.icl_type = XFS_LI_ICREATE;
+	icp->ic_format.icl_size = 1;	/* single vector */
+	icp->ic_format.icl_ag = cpu_to_be32(agno);
+	icp->ic_format.icl_agbno = cpu_to_be32(agbno);
+	icp->ic_format.icl_count = cpu_to_be32(count);
+	icp->ic_format.icl_isize = cpu_to_be32(inode_size);
+	icp->ic_format.icl_length = cpu_to_be32(length);
+	icp->ic_format.icl_gen = cpu_to_be32(generation);
+
+	xfs_trans_add_item(tp, &icp->ic_item);
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
+}
+
+static enum xlog_recover_reorder
+xlog_recover_icreate_reorder(
+		struct xlog_recover_item *item)
+{
+	/*
+	 * Inode allocation buffers must be replayed before subsequent inode
+	 * items try to modify those buffers.  ICREATE items are the logical
+	 * equivalent of logging a newly initialized inode buffer, so recover
+	 * these at the same time that we recover logged buffers.
+	 */
+	return XLOG_REORDER_BUFFER_LIST;
+}
+
+/*
+ * This routine is called when an inode create format structure is found in a
+ * committed transaction in the log.  It's purpose is to initialise the inodes
+ * being allocated on disk. This requires us to get inode cluster buffers that
+ * match the range to be initialised, stamped with inode templates and written
+ * by delayed write so that subsequent modifications will hit the cached buffer
+ * and only need writing out at the end of recovery.
+ */
+STATIC int
+xlog_recover_icreate_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_icreate_log		*icl;
+	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	unsigned int			count;
+	unsigned int			isize;
+	xfs_agblock_t			length;
+	int				bb_per_cluster;
+	int				cancel_count;
+	int				nbufs;
+	int				i;
+
+	icl = (struct xfs_icreate_log *)item->ri_buf[0].iov_base;
+	if (icl->icl_type != XFS_LI_ICREATE) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
+		return -EINVAL;
+	}
+
+	if (icl->icl_size != 1) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
+		return -EINVAL;
+	}
+
+	agno = be32_to_cpu(icl->icl_ag);
+	if (agno >= mp->m_sb.sb_agcount) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
+		return -EINVAL;
+	}
+	agbno = be32_to_cpu(icl->icl_agbno);
+	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
+		return -EINVAL;
+	}
+	isize = be32_to_cpu(icl->icl_isize);
+	if (isize != mp->m_sb.sb_inodesize) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
+		return -EINVAL;
+	}
+	count = be32_to_cpu(icl->icl_count);
+	if (!count) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
+		return -EINVAL;
+	}
+	length = be32_to_cpu(icl->icl_length);
+	if (!length || length >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
+		return -EINVAL;
+	}
+
+	/*
+	 * The inode chunk is either full or sparse and we only support
+	 * m_ino_geo.ialloc_min_blks sized sparse allocations at this time.
+	 */
+	if (length != igeo->ialloc_blks &&
+	    length != igeo->ialloc_min_blks) {
+		xfs_warn(log->l_mp,
+			 "%s: unsupported chunk length", __func__);
+		return -EINVAL;
+	}
+
+	/* verify inode count is consistent with extent length */
+	if ((count >> mp->m_sb.sb_inopblog) != length) {
+		xfs_warn(log->l_mp,
+			 "%s: inconsistent inode count and chunk length",
+			 __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * The icreate transaction can cover multiple cluster buffers and these
+	 * buffers could have been freed and reused. Check the individual
+	 * buffers for cancellation so we don't overwrite anything written after
+	 * a cancellation.
+	 */
+	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
+	nbufs = length / igeo->blocks_per_cluster;
+	for (i = 0, cancel_count = 0; i < nbufs; i++) {
+		xfs_daddr_t	daddr;
+
+		daddr = XFS_AGB_TO_DADDR(mp, agno,
+				agbno + i * igeo->blocks_per_cluster);
+		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
+			cancel_count++;
+	}
+
+	/*
+	 * We currently only use icreate for a single allocation at a time. This
+	 * means we should expect either all or none of the buffers to be
+	 * cancelled. Be conservative and skip replay if at least one buffer is
+	 * cancelled, but warn the user that something is awry if the buffers
+	 * are not consistent.
+	 *
+	 * XXX: This must be refined to only skip cancelled clusters once we use
+	 * icreate for multiple chunk allocations.
+	 */
+	ASSERT(!cancel_count || cancel_count == nbufs);
+	if (cancel_count) {
+		if (cancel_count != nbufs)
+			xfs_warn(mp,
+	"WARNING: partial inode chunk cancellation, skipped icreate.");
+		trace_xfs_log_recover_icreate_cancel(log, icl);
+		return 0;
+	}
+
+	trace_xfs_log_recover_icreate_recover(log, icl);
+	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
+				     length, be32_to_cpu(icl->icl_gen));
+}
+
+const struct xlog_recover_item_ops xlog_icreate_item_ops = {
+	.item_type		= XFS_LI_ICREATE,
+	.reorder		= xlog_recover_icreate_reorder,
+	.commit_pass2		= xlog_recover_icreate_commit_pass2,
+};
diff --git a/libxlog/xfs_icreate_item.h b/libxlog/xfs_icreate_item.h
new file mode 100644
index 00000000..64992823
--- /dev/null
+++ b/libxlog/xfs_icreate_item.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2008-2010, Dave Chinner
+ * All Rights Reserved.
+ */
+#ifndef XFS_ICREATE_ITEM_H
+#define XFS_ICREATE_ITEM_H	1
+
+/* in memory log item structure */
+struct xfs_icreate_item {
+	struct xfs_log_item	ic_item;
+	struct xfs_icreate_log	ic_format;
+};
+
+extern struct kmem_cache *xfs_icreate_cache;	/* inode create item */
+
+void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
+			xfs_agblock_t agbno, unsigned int count,
+			unsigned int inode_size, xfs_agblock_t length,
+			unsigned int generation);
+
+#endif	/* XFS_ICREATE_ITEM_H */
diff --git a/libxlog/xfs_inode_item.h b/libxlog/xfs_inode_item.h
new file mode 100644
index 00000000..2ddcca41
--- /dev/null
+++ b/libxlog/xfs_inode_item.h
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_INODE_ITEM_H__
+#define	__XFS_INODE_ITEM_H__
+
+/* kernel only definitions */
+
+struct xfs_buf;
+struct xfs_bmbt_rec;
+struct xfs_inode;
+struct xfs_mount;
+
+struct xfs_inode_log_item {
+	struct xfs_log_item	ili_item;	   /* common portion */
+	struct xfs_inode	*ili_inode;	   /* inode ptr */
+	unsigned short		ili_lock_flags;	   /* inode lock flags */
+	unsigned int		ili_dirty_flags;   /* dirty in current tx */
+	/*
+	 * The ili_lock protects the interactions between the dirty state and
+	 * the flush state of the inode log item. This allows us to do atomic
+	 * modifications of multiple state fields without having to hold a
+	 * specific inode lock to serialise them.
+	 *
+	 * We need atomic changes between inode dirtying, inode flushing and
+	 * inode completion, but these all hold different combinations of
+	 * ILOCK and IFLUSHING and hence we need some other method of
+	 * serialising updates to the flush state.
+	 */
+	spinlock_t		ili_lock;	   /* flush state lock */
+	unsigned int		ili_last_fields;   /* fields when flushed */
+	unsigned int		ili_fields;	   /* fields to be logged */
+	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
+
+	/*
+	 * We record the sequence number for every inode modification, as
+	 * well as those that only require fdatasync operations for data
+	 * integrity. This allows optimisation of the O_DSYNC/fdatasync path
+	 * without needing to track what modifications the journal is currently
+	 * carrying for the inode. These are protected by the above ili_lock.
+	 */
+	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
+	xfs_csn_t		ili_datasync_seq;  /* for datasync optimisation */
+};
+
+static inline int xfs_inode_clean(struct xfs_inode *ip)
+{
+	return !ip->i_itemp || !(ip->i_itemp->ili_fields & XFS_ILOG_ALL);
+}
+
+extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
+extern void xfs_inode_item_destroy(struct xfs_inode *);
+extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
+int xfs_inode_item_format_convert(struct kvec *buf,
+		struct xfs_inode_log_format *in_f);
+
+extern struct kmem_cache	*xfs_ili_cache;
+
+#endif	/* __XFS_INODE_ITEM_H__ */
diff --git a/libxlog/xfs_inode_item_recover.c b/libxlog/xfs_inode_item_recover.c
new file mode 100644
index 00000000..e410e2a3
--- /dev/null
+++ b/libxlog/xfs_inode_item_recover.c
@@ -0,0 +1,602 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_inode_item.h"
+#include "xfs_trace.h"
+#include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
+
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
+		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].iov_base;
+
+		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+				   &xfs_inode_buf_ra_ops);
+	} else {
+		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].iov_base;
+
+		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+				   &xfs_inode_buf_ra_ops);
+	}
+}
+
+/*
+ * Inode fork owner changes
+ *
+ * If we have been told that we have to reparent the inode fork, it's because an
+ * extent swap operation on a CRC enabled filesystem has been done and we are
+ * replaying it. We need to walk the BMBT of the appropriate fork and change the
+ * owners of it.
+ *
+ * The complexity here is that we don't have an inode context to work with, so
+ * after we've replayed the inode we need to instantiate one.  This is where the
+ * fun begins.
+ *
+ * We are in the middle of log recovery, so we can't run transactions. That
+ * means we cannot use cache coherent inode instantiation via xfs_iget(), as
+ * that will result in the corresponding iput() running the inode through
+ * xfs_inactive(). If we've just replayed an inode core that changes the link
+ * count to zero (i.e. it's been unlinked), then xfs_inactive() will run
+ * transactions (bad!).
+ *
+ * So, to avoid this, we instantiate an inode directly from the inode core we've
+ * just recovered. We have the buffer still locked, and all we really need to
+ * instantiate is the inode core and the forks being modified. We can do this
+ * manually, then run the inode btree owner change, and then tear down the
+ * xfs_inode without having to run any transactions at all.
+ *
+ * Also, because we don't have a transaction context available here but need to
+ * gather all the buffers we modify for writeback so we pass the buffer_list
+ * instead for the operation to use.
+ */
+
+STATIC int
+xfs_recover_inode_owner_change(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	struct xfs_inode_log_format *in_f,
+	struct list_head	*buffer_list)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	ASSERT(in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER));
+
+	ip = xfs_inode_alloc(mp, in_f->ilf_ino);
+	if (!ip)
+		return -ENOMEM;
+
+	/* instantiate the inode */
+	ASSERT(dip->di_version >= 3);
+
+	error = xfs_inode_from_disk(ip, dip);
+	if (error)
+		goto out_free_ip;
+
+	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
+		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
+		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
+					      ip->i_ino, buffer_list);
+		if (error)
+			goto out_free_ip;
+	}
+
+	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
+		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
+		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
+					      ip->i_ino, buffer_list);
+		if (error)
+			goto out_free_ip;
+	}
+
+out_free_ip:
+	xfs_inode_free(ip);
+	return error;
+}
+
+static inline bool xfs_log_dinode_has_bigtime(const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_BIGTIME);
+}
+
+/* Convert a log timestamp to an ondisk timestamp. */
+static inline xfs_timestamp_t
+xfs_log_dinode_to_disk_ts(
+	struct xfs_log_dinode		*from,
+	const xfs_log_timestamp_t	its)
+{
+	struct xfs_legacy_timestamp	*lts;
+	struct xfs_log_legacy_timestamp	*lits;
+	xfs_timestamp_t			ts;
+
+	if (xfs_log_dinode_has_bigtime(from))
+		return cpu_to_be64(its);
+
+	lts = (struct xfs_legacy_timestamp *)&ts;
+	lits = (struct xfs_log_legacy_timestamp *)&its;
+	lts->t_sec = cpu_to_be32(lits->t_sec);
+	lts->t_nsec = cpu_to_be32(lits->t_nsec);
+
+	return ts;
+}
+
+static inline bool xfs_log_dinode_has_large_extent_counts(
+		const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
+}
+
+static inline void
+xfs_log_dinode_to_disk_iext_counters(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
+{
+	if (xfs_log_dinode_has_large_extent_counts(from)) {
+		to->di_big_nextents = cpu_to_be64(from->di_big_nextents);
+		to->di_big_anextents = cpu_to_be32(from->di_big_anextents);
+		to->di_nrext64_pad = cpu_to_be16(from->di_nrext64_pad);
+	} else {
+		to->di_nextents = cpu_to_be32(from->di_nextents);
+		to->di_anextents = cpu_to_be16(from->di_anextents);
+	}
+
+}
+
+STATIC void
+xfs_log_dinode_to_disk(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to,
+	xfs_lsn_t		lsn)
+{
+	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_mode = cpu_to_be16(from->di_mode);
+	to->di_version = from->di_version;
+	to->di_format = from->di_format;
+	to->di_metatype = cpu_to_be16(from->di_metatype);
+	to->di_uid = cpu_to_be32(from->di_uid);
+	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_nlink = cpu_to_be32(from->di_nlink);
+	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
+	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+
+	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
+	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
+	to->di_ctime = xfs_log_dinode_to_disk_ts(from, from->di_ctime);
+
+	to->di_size = cpu_to_be64(from->di_size);
+	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmstate = cpu_to_be16(from->di_dmstate);
+	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_gen = cpu_to_be32(from->di_gen);
+
+	if (from->di_version == 3) {
+		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_crtime = xfs_log_dinode_to_disk_ts(from,
+							  from->di_crtime);
+		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		/* also covers the di_used_blocks union arm: */
+		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		to->di_ino = cpu_to_be64(from->di_ino);
+		to->di_lsn = cpu_to_be64(lsn);
+		memset(to->di_pad2, 0, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_v3_pad = 0;
+	} else {
+		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
+	}
+
+	xfs_log_dinode_to_disk_iext_counters(from, to);
+}
+
+STATIC int
+xlog_dinode_verify_extent_counts(
+	struct xfs_mount	*mp,
+	struct xfs_log_dinode	*ldip)
+{
+	xfs_extnum_t		nextents;
+	xfs_aextnum_t		anextents;
+
+	if (xfs_log_dinode_has_large_extent_counts(ldip)) {
+		if (!xfs_has_large_extent_counts(mp) ||
+		    (ldip->di_nrext64_pad != 0)) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode large extent count format",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, large extent counts %d, padding 0x%x",
+				ldip->di_ino, xfs_has_large_extent_counts(mp),
+				ldip->di_nrext64_pad);
+			return -EFSCORRUPTED;
+		}
+
+		nextents = ldip->di_big_nextents;
+		anextents = ldip->di_big_anextents;
+	} else {
+		if (ldip->di_version == 3 && ldip->di_v3_pad != 0) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode di_v3_pad",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, di_v3_pad 0x%llx",
+				ldip->di_ino, ldip->di_v3_pad);
+			return -EFSCORRUPTED;
+		}
+
+		nextents = ldip->di_nextents;
+		anextents = ldip->di_anextents;
+	}
+
+	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
+		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+		xfs_alert(mp,
+			"Bad inode 0x%llx, large extent counts %d, nextents 0x%llx, anextents 0x%x, nblocks 0x%llx",
+			ldip->di_ino, xfs_has_large_extent_counts(mp), nextents,
+			anextents, ldip->di_nblocks);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+static inline int
+xlog_recover_inode_dbroot(
+	struct xfs_mount	*mp,
+	void			*src,
+	unsigned int		len,
+	struct xfs_dinode	*dip)
+{
+	void			*dfork = XFS_DFORK_DPTR(dip);
+	unsigned int		dsize = XFS_DFORK_DSIZE(dip, mp);
+
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_BTREE:
+		xfs_bmbt_to_bmdr(mp, src, len, dfork, dsize);
+		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		switch (be16_to_cpu(dip->di_metatype)) {
+		case XFS_METAFILE_RTRMAP:
+			xfs_rtrmapbt_to_disk(mp, src, len, dfork, dsize);
+			return 0;
+		case XFS_METAFILE_RTREFCOUNT:
+			xfs_rtrefcountbt_to_disk(mp, src, len, dfork, dsize);
+			return 0;
+		default:
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+STATIC int
+xlog_recover_inode_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_inode_log_format	*in_f;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_buf			*bp;
+	struct xfs_dinode		*dip;
+	int				len;
+	char				*src;
+	char				*dest;
+	int				error;
+	int				attr_index;
+	uint				fields;
+	struct xfs_log_dinode		*ldip;
+	uint				isize;
+	int				need_free = 0;
+	xfs_failaddr_t			fa;
+
+	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
+		in_f = item->ri_buf[0].iov_base;
+	} else {
+		in_f = kmalloc_obj(struct xfs_inode_log_format,
+				   GFP_KERNEL | __GFP_NOFAIL);
+		need_free = 1;
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+		if (error)
+			goto error;
+	}
+
+	/*
+	 * Inode buffers can be freed, look out for it,
+	 * and do not replay the inode.
+	 */
+	if (xlog_is_buffer_cancelled(log, in_f->ilf_blkno, in_f->ilf_len)) {
+		error = 0;
+		trace_xfs_log_recover_inode_cancel(log, in_f);
+		goto error;
+	}
+	trace_xfs_log_recover_inode_recover(log, in_f);
+
+	error = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
+			0, &bp, &xfs_inode_buf_ops);
+	if (error)
+		goto error;
+	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
+	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
+
+	/*
+	 * Make sure the place we're flushing out to really looks
+	 * like an inode!
+	 */
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_magic16(bp, dip->di_magic))) {
+		xfs_alert(mp,
+	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %lld",
+			__func__, dip, bp, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	ldip = item->ri_buf[1].iov_base;
+	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
+		xfs_alert(mp,
+			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %lld",
+			__func__, item, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
+	/*
+	 * If the inode has an LSN in it, recover the inode only if the on-disk
+	 * inode's LSN is older than the lsn of the transaction we are
+	 * replaying. We can have multiple checkpoints with the same start LSN,
+	 * so the current LSN being equal to the on-disk LSN doesn't necessarily
+	 * mean that the on-disk inode is more recent than the change being
+	 * replayed.
+	 *
+	 * We must check the current_lsn against the on-disk inode
+	 * here because the we can't trust the log dinode to contain a valid LSN
+	 * (see comment below before replaying the log dinode for details).
+	 *
+	 * Note: we still need to replay an owner change even though the inode
+	 * is more recent than the transaction as there is no guarantee that all
+	 * the btree blocks are more recent than this transaction, too.
+	 */
+	if (dip->di_version >= 3) {
+		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
+
+		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) > 0) {
+			trace_xfs_log_recover_inode_skip(log, in_f);
+			error = 0;
+			goto out_owner_change;
+		}
+	}
+
+	/*
+	 * di_flushiter is only valid for v1/2 inodes. All changes for v3 inodes
+	 * are transactional and if ordering is necessary we can determine that
+	 * more accurately by the LSN field in the V3 inode core. Don't trust
+	 * the inode versions we might be changing them here - use the
+	 * superblock flag to determine whether we need to look at di_flushiter
+	 * to skip replay when the on disk inode is newer than the log one
+	 */
+	if (!xfs_has_v3inodes(mp)) {
+		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
+			/*
+			 * Deal with the wrap case, DI_MAX_FLUSH is less
+			 * than smaller numbers
+			 */
+			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
+			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
+				/* do nothing */
+			} else {
+				trace_xfs_log_recover_inode_skip(log, in_f);
+				error = 0;
+				goto out_release;
+			}
+		}
+
+		/* Take the opportunity to reset the flush iteration count */
+		ldip->di_flushiter = 0;
+	}
+
+
+	if (unlikely(S_ISREG(ldip->di_mode))) {
+		if (ldip->di_format != XFS_DINODE_FMT_EXTENTS &&
+		    ldip->di_format != XFS_DINODE_FMT_BTREE &&
+		    ldip->di_format != XFS_DINODE_FMT_META_BTREE) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode data fork format for regular file",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, data fork format 0x%x",
+				in_f->ilf_ino, ldip->di_format);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	} else if (unlikely(S_ISDIR(ldip->di_mode))) {
+		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
+		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode data fork format for directory",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, data fork format 0x%x",
+				in_f->ilf_ino, ldip->di_format);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+
+	error = xlog_dinode_verify_extent_counts(mp, ldip);
+	if (error)
+		goto out_release;
+
+	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
+		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+		xfs_alert(mp,
+			"Bad inode 0x%llx, di_forkoff 0x%x",
+			in_f->ilf_ino, ldip->di_forkoff);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	isize = xfs_log_dinode_size(mp);
+	if (unlikely(item->ri_buf[1].iov_len > isize)) {
+		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
+				     mp, ldip, sizeof(*ldip));
+		xfs_alert(mp,
+			"Bad inode 0x%llx log dinode size 0x%zx",
+			in_f->ilf_ino, item->ri_buf[1].iov_len);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
+	/*
+	 * Recover the log dinode inode into the on disk inode.
+	 *
+	 * The LSN in the log dinode is garbage - it can be zero or reflect
+	 * stale in-memory runtime state that isn't coherent with the changes
+	 * logged in this transaction or the changes written to the on-disk
+	 * inode.  Hence we write the current lSN into the inode because that
+	 * matches what xfs_iflush() would write inode the inode when flushing
+	 * the changes in this transaction.
+	 */
+	xfs_log_dinode_to_disk(ldip, dip, current_lsn);
+
+	fields = in_f->ilf_fields;
+	if (fields & XFS_ILOG_DEV)
+		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
+
+	if (in_f->ilf_size == 2)
+		goto out_owner_change;
+	len = item->ri_buf[2].iov_len;
+	src = item->ri_buf[2].iov_base;
+	ASSERT(in_f->ilf_size <= 4);
+	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
+	ASSERT(!(fields & XFS_ILOG_DFORK) ||
+	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
+
+	switch (fields & XFS_ILOG_DFORK) {
+	case XFS_ILOG_DDATA:
+	case XFS_ILOG_DEXT:
+		memcpy(XFS_DFORK_DPTR(dip), src, len);
+		break;
+
+	case XFS_ILOG_DBROOT:
+		error = xlog_recover_inode_dbroot(mp, src, len, dip);
+		if (error)
+			goto out_release;
+		break;
+
+	default:
+		/*
+		 * There are no data fork flags set.
+		 */
+		ASSERT((fields & XFS_ILOG_DFORK) == 0);
+		break;
+	}
+
+	/*
+	 * If we logged any attribute data, recover it.  There may or
+	 * may not have been any other non-core data logged in this
+	 * transaction.
+	 */
+	if (in_f->ilf_fields & XFS_ILOG_AFORK) {
+		if (in_f->ilf_fields & XFS_ILOG_DFORK) {
+			attr_index = 3;
+		} else {
+			attr_index = 2;
+		}
+		len = item->ri_buf[attr_index].iov_len;
+		src = item->ri_buf[attr_index].iov_base;
+		ASSERT(len == xlog_calc_iovec_len(in_f->ilf_asize));
+
+		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
+		case XFS_ILOG_ADATA:
+		case XFS_ILOG_AEXT:
+			dest = XFS_DFORK_APTR(dip);
+			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
+			memcpy(dest, src, len);
+			break;
+
+		case XFS_ILOG_ABROOT:
+			dest = XFS_DFORK_APTR(dip);
+			xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src,
+					 len, (struct xfs_bmdr_block *)dest,
+					 XFS_DFORK_ASIZE(dip, mp));
+			break;
+
+		default:
+			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
+			ASSERT(0);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+
+out_owner_change:
+	/* Recover the swapext owner change unless inode has been deleted */
+	if ((in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER)) &&
+	    (dip->di_mode != 0))
+		error = xfs_recover_inode_owner_change(mp, dip, in_f,
+						       buffer_list);
+	/* re-generate the checksum and validate the recovered inode. */
+	xfs_dinode_calc_crc(log->l_mp, dip);
+	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
+	if (fa) {
+		XFS_CORRUPTION_ERROR(
+			"Bad dinode after recovery",
+				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
+		xfs_alert(mp,
+			"Metadata corruption detected at %pS, inode 0x%llx",
+			fa, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
+	ASSERT(bp->b_mount == mp);
+	bp->b_flags |= _XBF_LOGRECOVERY;
+	xfs_buf_delwri_queue(bp, buffer_list);
+
+out_release:
+	xfs_buf_relse(bp);
+error:
+	if (need_free)
+		kfree(in_f);
+	return error;
+}
+
+const struct xlog_recover_item_ops xlog_inode_item_ops = {
+	.item_type		= XFS_LI_INODE,
+	.ra_pass2		= xlog_recover_inode_ra_pass2,
+	.commit_pass2		= xlog_recover_inode_commit_pass2,
+};
diff --git a/libxlog/xfs_log.h b/libxlog/xfs_log.h
new file mode 100644
index 00000000..0f23812b
--- /dev/null
+++ b/libxlog/xfs_log.h
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_LOG_H__
+#define __XFS_LOG_H__
+
+struct xlog_format_buf;
+struct xfs_cil_ctx;
+
+/* Region types for iovec's i_type */
+#define XLOG_REG_TYPE_BFORMAT		1
+#define XLOG_REG_TYPE_BCHUNK		2
+#define XLOG_REG_TYPE_EFI_FORMAT	3
+#define XLOG_REG_TYPE_EFD_FORMAT	4
+#define XLOG_REG_TYPE_IFORMAT		5
+#define XLOG_REG_TYPE_ICORE		6
+#define XLOG_REG_TYPE_IEXT		7
+#define XLOG_REG_TYPE_IBROOT		8
+#define XLOG_REG_TYPE_ILOCAL		9
+#define XLOG_REG_TYPE_IATTR_EXT		10
+#define XLOG_REG_TYPE_IATTR_BROOT	11
+#define XLOG_REG_TYPE_IATTR_LOCAL	12
+#define XLOG_REG_TYPE_QFORMAT		13
+#define XLOG_REG_TYPE_DQUOT		14
+#define XLOG_REG_TYPE_QUOTAOFF		15
+#define XLOG_REG_TYPE_LRHEADER		16
+#define XLOG_REG_TYPE_UNMOUNT		17
+#define XLOG_REG_TYPE_COMMIT		18
+#define XLOG_REG_TYPE_TRANSHDR		19
+#define XLOG_REG_TYPE_ICREATE		20
+#define XLOG_REG_TYPE_RUI_FORMAT	21
+#define XLOG_REG_TYPE_RUD_FORMAT	22
+#define XLOG_REG_TYPE_CUI_FORMAT	23
+#define XLOG_REG_TYPE_CUD_FORMAT	24
+#define XLOG_REG_TYPE_BUI_FORMAT	25
+#define XLOG_REG_TYPE_BUD_FORMAT	26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME		29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_XMI_FORMAT	31
+#define XLOG_REG_TYPE_XMD_FORMAT	32
+#define XLOG_REG_TYPE_ATTR_NEWNAME	33
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
+#define XLOG_REG_TYPE_MAX		34
+
+#define XFS_LOG_VEC_ORDERED	(-1)
+
+/*
+ * Calculate the log iovec length for a given user buffer length. Intended to be
+ * used by ->iop_size implementations when sizing buffers of arbitrary
+ * alignments.
+ */
+static inline int
+xlog_calc_iovec_len(int len)
+{
+	return roundup(len, sizeof(uint32_t));
+}
+
+void *xlog_format_start(struct xlog_format_buf *lfb, uint16_t type);
+void xlog_format_commit(struct xlog_format_buf *lfb, unsigned int data_len);
+
+/*
+ * Copy the amount of data requested by the caller into a new log iovec.
+ */
+static inline void *
+xlog_format_copy(
+	struct xlog_format_buf	*lfb,
+	uint16_t		type,
+	void			*data,
+	unsigned int		len)
+{
+	void *buf;
+
+	buf = xlog_format_start(lfb, type);
+	memcpy(buf, data, len);
+	xlog_format_commit(lfb, len);
+	return buf;
+}
+
+/*
+ * By comparing each component, we don't have to worry about extra
+ * endian issues in treating two 32 bit numbers as one 64 bit number
+ */
+static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
+{
+	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
+		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
+
+	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
+		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
+
+	return 0;
+}
+
+#define	XFS_LSN_CMP(x,y) _lsn_cmp(x,y)
+
+/*
+ * Flags to xfs_log_force()
+ *
+ *	XFS_LOG_SYNC:	Synchronous force in-core log to disk
+ */
+#define XFS_LOG_SYNC		0x1
+
+/* Log manager interfaces */
+struct xfs_mount;
+struct xlog_in_core;
+struct xlog_ticket;
+struct xfs_log_item;
+struct xfs_item_ops;
+struct xfs_trans;
+struct xlog;
+
+int	  xfs_log_force(struct xfs_mount *mp, uint flags);
+int	  xfs_log_force_seq(struct xfs_mount *mp, xfs_csn_t seq, uint flags,
+		int *log_forced);
+int	  xfs_log_mount(struct xfs_mount	*mp,
+			struct xfs_buftarg	*log_target,
+			xfs_daddr_t		start_block,
+			int		 	num_bblocks);
+int	  xfs_log_mount_finish(struct xfs_mount *mp);
+void	xfs_log_mount_cancel(struct xfs_mount *);
+xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
+xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
+void	xfs_log_space_wake(struct xfs_mount *mp);
+int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
+			struct xlog_ticket **ticket, bool permanent);
+int	xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
+void	xfs_log_unmount(struct xfs_mount *mp);
+bool	xfs_log_writable(struct xfs_mount *mp);
+
+struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
+void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
+
+void	xlog_cil_process_committed(struct list_head *list);
+bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
+
+void	xfs_log_work_queue(struct xfs_mount *mp);
+int	xfs_log_quiesce(struct xfs_mount *mp);
+void	xfs_log_clean(struct xfs_mount *mp);
+bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
+
+bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
+
+#endif	/* __XFS_LOG_H__ */
diff --git a/libxlog/xfs_log_priv.h b/libxlog/xfs_log_priv.h
new file mode 100644
index 00000000..97a9df80
--- /dev/null
+++ b/libxlog/xfs_log_priv.h
@@ -0,0 +1,746 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_LOG_PRIV_H__
+#define __XFS_LOG_PRIV_H__
+
+
+struct xfs_buf;
+struct xlog;
+struct xlog_ticket;
+struct xfs_mount;
+
+struct xfs_log_iovec {
+	void			*i_addr;/* beginning address of region */
+	int			i_len;	/* length in bytes of region */
+	uint			i_type;	/* type of region */
+};
+
+struct xfs_log_vec {
+	struct list_head	lv_list;	/* CIL lv chain ptrs */
+	uint32_t		lv_order_id;	/* chain ordering info */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+	struct xfs_log_item	*lv_item;	/* owner */
+	char			*lv_buf;	/* formatted buffer */
+	int			lv_bytes;	/* accounted space in buffer */
+	int			lv_buf_used;	/* buffer space used so far */
+	int			lv_alloc_size;	/* size of allocated lv */
+};
+
+/*
+ * get client id from packed copy.
+ *
+ * this hack is here because the xlog_pack code copies four bytes
+ * of xlog_op_header containing the fields oh_clientid, oh_flags
+ * and oh_res2 into the packed copy.
+ *
+ * later on this four byte chunk is treated as an int and the
+ * client id is pulled out.
+ *
+ * this has endian issues, of course.
+ */
+static inline uint xlog_get_client_id(__be32 i)
+{
+	return be32_to_cpu(i) >> 24;
+}
+
+/*
+ * In core log state
+ */
+enum xlog_iclog_state {
+	XLOG_STATE_ACTIVE,	/* Current IC log being written to */
+	XLOG_STATE_WANT_SYNC,	/* Want to sync this iclog; no more writes */
+	XLOG_STATE_SYNCING,	/* This IC log is syncing */
+	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
+	XLOG_STATE_CALLBACK,	/* Callback functions now */
+	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
+};
+
+#define XLOG_STATE_STRINGS \
+	{ XLOG_STATE_ACTIVE,	"XLOG_STATE_ACTIVE" }, \
+	{ XLOG_STATE_WANT_SYNC,	"XLOG_STATE_WANT_SYNC" }, \
+	{ XLOG_STATE_SYNCING,	"XLOG_STATE_SYNCING" }, \
+	{ XLOG_STATE_DONE_SYNC,	"XLOG_STATE_DONE_SYNC" }, \
+	{ XLOG_STATE_CALLBACK,	"XLOG_STATE_CALLBACK" }, \
+	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }
+
+/*
+ * In core log flags
+ */
+#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* iclog needs REQ_PREFLUSH */
+#define XLOG_ICL_NEED_FUA	(1u << 1)	/* iclog needs REQ_FUA */
+
+#define XLOG_ICL_STRINGS \
+	{ XLOG_ICL_NEED_FLUSH,	"XLOG_ICL_NEED_FLUSH" }, \
+	{ XLOG_ICL_NEED_FUA,	"XLOG_ICL_NEED_FUA" }
+
+
+/*
+ * Log ticket flags
+ */
+#define XLOG_TIC_PERM_RESERV	(1u << 0)	/* permanent reservation */
+
+#define XLOG_TIC_FLAGS \
+	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
+
+/*
+ * Below are states for covering allocation transactions.
+ * By covering, we mean changing the h_tail_lsn in the last on-disk
+ * log write such that no allocation transactions will be re-done during
+ * recovery after a system crash. Recovery starts at the last on-disk
+ * log write.
+ *
+ * These states are used to insert dummy log entries to cover
+ * space allocation transactions which can undo non-transactional changes
+ * after a crash. Writes to a file with space
+ * already allocated do not result in any transactions. Allocations
+ * might include space beyond the EOF. So if we just push the EOF a
+ * little, the last transaction for the file could contain the wrong
+ * size. If there is no file system activity, after an allocation
+ * transaction, and the system crashes, the allocation transaction
+ * will get replayed and the file will be truncated. This could
+ * be hours/days/... after the allocation occurred.
+ *
+ * The fix for this is to do two dummy transactions when the
+ * system is idle. We need two dummy transaction because the h_tail_lsn
+ * in the log record header needs to point beyond the last possible
+ * non-dummy transaction. The first dummy changes the h_tail_lsn to
+ * the first transaction before the dummy. The second dummy causes
+ * h_tail_lsn to point to the first dummy. Recovery starts at h_tail_lsn.
+ *
+ * These dummy transactions get committed when everything
+ * is idle (after there has been some activity).
+ *
+ * There are 5 states used to control this.
+ *
+ *  IDLE -- no logging has been done on the file system or
+ *		we are done covering previous transactions.
+ *  NEED -- logging has occurred and we need a dummy transaction
+ *		when the log becomes idle.
+ *  DONE -- we were in the NEED state and have committed a dummy
+ *		transaction.
+ *  NEED2 -- we detected that a dummy transaction has gone to the
+ *		on disk log with no other transactions.
+ *  DONE2 -- we committed a dummy transaction when in the NEED2 state.
+ *
+ * There are two places where we switch states:
+ *
+ * 1.) In xfs_sync, when we detect an idle log and are in NEED or NEED2.
+ *	We commit the dummy transaction and switch to DONE or DONE2,
+ *	respectively. In all other states, we don't do anything.
+ *
+ * 2.) When we finish writing the on-disk log (xlog_state_clean_log).
+ *
+ *	No matter what state we are in, if this isn't the dummy
+ *	transaction going out, the next state is NEED.
+ *	So, if we aren't in the DONE or DONE2 states, the next state
+ *	is NEED. We can't be finishing a write of the dummy record
+ *	unless it was committed and the state switched to DONE or DONE2.
+ *
+ *	If we are in the DONE state and this was a write of the
+ *		dummy transaction, we move to NEED2.
+ *
+ *	If we are in the DONE2 state and this was a write of the
+ *		dummy transaction, we move to IDLE.
+ *
+ *
+ * Writing only one dummy transaction can get appended to
+ * one file space allocation. When this happens, the log recovery
+ * code replays the space allocation and a file could be truncated.
+ * This is why we have the NEED2 and DONE2 states before going idle.
+ */
+
+#define XLOG_STATE_COVER_IDLE	0
+#define XLOG_STATE_COVER_NEED	1
+#define XLOG_STATE_COVER_DONE	2
+#define XLOG_STATE_COVER_NEED2	3
+#define XLOG_STATE_COVER_DONE2	4
+
+#define XLOG_COVER_OPS		5
+
+struct xlog_ticket {
+	struct list_head	t_queue;	/* reserve/write queue */
+	struct task_struct	*t_task;	/* task that owns this ticket */
+	xlog_tid_t		t_tid;		/* transaction identifier */
+	atomic_t		t_ref;		/* ticket reference count */
+	int			t_curr_res;	/* current reservation */
+	int			t_unit_res;	/* unit reservation */
+	char			t_ocnt;		/* original unit count */
+	char			t_cnt;		/* current unit count */
+	uint8_t			t_flags;	/* properties of reservation */
+	int			t_iclog_hdrs;	/* iclog hdrs in t_curr_res */
+};
+
+/*
+ * In-core log structure.
+ *
+ * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
+ * - ic_next is the pointer to the next iclog in the ring.
+ * - ic_log is a pointer back to the global log structure.
+ * - ic_size is the full size of the log buffer, minus the cycle headers.
+ * - ic_offset is the current number of bytes written to in this iclog.
+ * - ic_refcnt is bumped when someone is writing to the log.
+ * - ic_state is the state of the iclog.
+ *
+ * Because of cacheline contention on large machines, we need to separate
+ * various resources onto different cachelines. To start with, make the
+ * structure cacheline aligned. The following fields can be contended on
+ * by independent processes:
+ *
+ *	- ic_callbacks
+ *	- ic_refcnt
+ *	- fields protected by the global l_icloglock
+ *
+ * so we need to ensure that these fields are located in separate cachelines.
+ * We'll put all the read-only and l_icloglock fields in the first cacheline,
+ * and move everything else out to subsequent cachelines.
+ */
+struct xlog_in_core {
+	wait_queue_head_t	ic_force_wait;
+	wait_queue_head_t	ic_write_wait;
+	struct xlog_in_core	*ic_next;
+	struct xlog_in_core	*ic_prev;
+	struct xlog		*ic_log;
+	u32			ic_size;
+	u32			ic_offset;
+	enum xlog_iclog_state	ic_state;
+	unsigned int		ic_flags;
+	void			*ic_datap;	/* pointer to iclog data */
+	struct list_head	ic_callbacks;
+
+	/* reference counts need their own cacheline */
+	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
+	struct xlog_rec_header	*ic_header;
+#ifdef DEBUG
+	bool			ic_fail_crc : 1;
+#endif
+	struct semaphore	ic_sema;
+	struct work_struct	ic_end_io_work;
+	struct bio		ic_bio;
+	struct bio_vec		ic_bvec[];
+};
+
+/*
+ * The CIL context is used to aggregate per-transaction details as well be
+ * passed to the iclog for checkpoint post-commit processing.  After being
+ * passed to the iclog, another context needs to be allocated for tracking the
+ * next set of transactions to be aggregated into a checkpoint.
+ */
+struct xfs_cil;
+
+struct xfs_cil_ctx {
+	struct xfs_cil		*cil;
+	xfs_csn_t		sequence;	/* chkpt sequence # */
+	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
+	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
+	struct xlog_in_core	*commit_iclog;
+	struct xlog_ticket	*ticket;	/* chkpt ticket */
+	atomic_t		space_used;	/* aggregate size of regions */
+	struct xfs_busy_extents	busy_extents;
+	struct list_head	log_items;	/* log items in chkpt */
+	struct list_head	lv_chain;	/* logvecs being pushed */
+	struct list_head	iclog_entry;
+	struct list_head	committing;	/* ctx committing list */
+	struct work_struct	push_work;
+	atomic_t		order_id;
+
+	/*
+	 * CPUs that could have added items to the percpu CIL data.  Access is
+	 * coordinated with xc_ctx_lock.
+	 */
+	struct cpumask		cil_pcpmask;
+};
+
+/*
+ * Per-cpu CIL tracking items
+ */
+struct xlog_cil_pcp {
+	int32_t			space_used;
+	uint32_t		space_reserved;
+	struct list_head	busy_extents;
+	struct list_head	log_items;
+};
+
+/*
+ * Committed Item List structure
+ *
+ * This structure is used to track log items that have been committed but not
+ * yet written into the log. It is used only when the delayed logging mount
+ * option is enabled.
+ *
+ * This structure tracks the list of committing checkpoint contexts so
+ * we can avoid the problem of having to hold out new transactions during a
+ * flush until we have a the commit record LSN of the checkpoint. We can
+ * traverse the list of committing contexts in xlog_cil_push_lsn() to find a
+ * sequence match and extract the commit LSN directly from there. If the
+ * checkpoint is still in the process of committing, we can block waiting for
+ * the commit LSN to be determined as well. This should make synchronous
+ * operations almost as efficient as the old logging methods.
+ */
+struct xfs_cil {
+	struct xlog		*xc_log;
+	unsigned long		xc_flags;
+	atomic_t		xc_iclog_hdrs;
+	struct workqueue_struct	*xc_push_wq;
+
+	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
+	struct xfs_cil_ctx	*xc_ctx;
+
+	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
+	xfs_csn_t		xc_push_seq;
+	bool			xc_push_commit_stable;
+	struct list_head	xc_committing;
+	wait_queue_head_t	xc_commit_wait;
+	wait_queue_head_t	xc_start_wait;
+	xfs_csn_t		xc_current_sequence;
+	wait_queue_head_t	xc_push_wait;	/* background push throttle */
+
+	void __percpu		*xc_pcp;	/* percpu CIL structures */
+} ____cacheline_aligned_in_smp;
+
+/* xc_flags bit values */
+#define	XLOG_CIL_EMPTY		1
+#define XLOG_CIL_PCP_SPACE	2
+
+/*
+ * The amount of log space we allow the CIL to aggregate is difficult to size.
+ * Whatever we choose, we have to make sure we can get a reservation for the
+ * log space effectively, that it is large enough to capture sufficient
+ * relogging to reduce log buffer IO significantly, but it is not too large for
+ * the log or induces too much latency when writing out through the iclogs. We
+ * track both space consumed and the number of vectors in the checkpoint
+ * context, so we need to decide which to use for limiting.
+ *
+ * Every log buffer we write out during a push needs a header reserved, which
+ * is at least one sector and more for v2 logs. Hence we need a reservation of
+ * at least 512 bytes per 32k of log space just for the LR headers. That means
+ * 16KB of reservation per megabyte of delayed logging space we will consume,
+ * plus various headers.  The number of headers will vary based on the num of
+ * io vectors, so limiting on a specific number of vectors is going to result
+ * in transactions of varying size. IOWs, it is more consistent to track and
+ * limit space consumed in the log rather than by the number of objects being
+ * logged in order to prevent checkpoint ticket overruns.
+ *
+ * Further, use of static reservations through the log grant mechanism is
+ * problematic. It introduces a lot of complexity (e.g. reserve grant vs write
+ * grant) and a significant deadlock potential because regranting write space
+ * can block on log pushes. Hence if we have to regrant log space during a log
+ * push, we can deadlock.
+ *
+ * However, we can avoid this by use of a dynamic "reservation stealing"
+ * technique during transaction commit whereby unused reservation space in the
+ * transaction ticket is transferred to the CIL ctx commit ticket to cover the
+ * space needed by the checkpoint transaction. This means that we never need to
+ * specifically reserve space for the CIL checkpoint transaction, nor do we
+ * need to regrant space once the checkpoint completes. This also means the
+ * checkpoint transaction ticket is specific to the checkpoint context, rather
+ * than the CIL itself.
+ *
+ * With dynamic reservations, we can effectively make up arbitrary limits for
+ * the checkpoint size so long as they don't violate any other size rules.
+ * Recovery imposes a rule that no transaction exceed half the log, so we are
+ * limited by that.  Furthermore, the log transaction reservation subsystem
+ * tries to keep 25% of the log free, so we need to keep below that limit or we
+ * risk running out of free log space to start any new transactions.
+ *
+ * In order to keep background CIL push efficient, we only need to ensure the
+ * CIL is large enough to maintain sufficient in-memory relogging to avoid
+ * repeated physical writes of frequently modified metadata. If we allow the CIL
+ * to grow to a substantial fraction of the log, then we may be pinning hundreds
+ * of megabytes of metadata in memory until the CIL flushes. This can cause
+ * issues when we are running low on memory - pinned memory cannot be reclaimed,
+ * and the CIL consumes a lot of memory. Hence we need to set an upper physical
+ * size limit for the CIL that limits the maximum amount of memory pinned by the
+ * CIL but does not limit performance by reducing relogging efficiency
+ * significantly.
+ *
+ * As such, the CIL push threshold ends up being the smaller of two thresholds:
+ * - a threshold large enough that it allows CIL to be pushed and progress to be
+ *   made without excessive blocking of incoming transaction commits. This is
+ *   defined to be 12.5% of the log space - half the 25% push threshold of the
+ *   AIL.
+ * - small enough that it doesn't pin excessive amounts of memory but maintains
+ *   close to peak relogging efficiency. This is defined to be 16x the iclog
+ *   buffer window (32MB) as measurements have shown this to be roughly the
+ *   point of diminishing performance increases under highly concurrent
+ *   modification workloads.
+ *
+ * To prevent the CIL from overflowing upper commit size bounds, we introduce a
+ * new threshold at which we block committing transactions until the background
+ * CIL commit commences and switches to a new context. While this is not a hard
+ * limit, it forces the process committing a transaction to the CIL to block and
+ * yeild the CPU, giving the CIL push work a chance to be scheduled and start
+ * work. This prevents a process running lots of transactions from overfilling
+ * the CIL because it is not yielding the CPU. We set the blocking limit at
+ * twice the background push space threshold so we keep in line with the AIL
+ * push thresholds.
+ *
+ * Note: this is not a -hard- limit as blocking is applied after the transaction
+ * is inserted into the CIL and the push has been triggered. It is largely a
+ * throttling mechanism that allows the CIL push to be scheduled and run. A hard
+ * limit will be difficult to implement without introducing global serialisation
+ * in the CIL commit fast path, and it's not at all clear that we actually need
+ * such hard limits given the ~7 years we've run without a hard limit before
+ * finding the first situation where a checkpoint size overflow actually
+ * occurred. Hence the simple throttle, and an ASSERT check to tell us that
+ * we've overrun the max size.
+ */
+#define XLOG_CIL_SPACE_LIMIT(log)	\
+	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
+
+#define XLOG_CIL_BLOCKING_SPACE_LIMIT(log)	\
+	(XLOG_CIL_SPACE_LIMIT(log) * 2)
+
+/*
+ * ticket grant locks, queues and accounting have their own cachlines
+ * as these are quite hot and can be operated on concurrently.
+ */
+struct xlog_grant_head {
+	spinlock_t		lock ____cacheline_aligned_in_smp;
+	struct list_head	waiters;
+	atomic64_t		grant;
+};
+
+/*
+ * The reservation head lsn is not made up of a cycle number and block number.
+ * Instead, it uses a cycle number and byte number.  Logs don't expect to
+ * overflow 31 bits worth of byte offset, so using a byte number will mean
+ * that round off problems won't occur when releasing partial reservations.
+ */
+struct xlog {
+	/* The following fields don't need locking */
+	struct xfs_mount	*l_mp;	        /* mount point */
+	struct xfs_ail		*l_ailp;	/* AIL log is working with */
+	struct xfs_cil		*l_cilp;	/* CIL log is working with */
+	struct xfs_buftarg	*l_targ;        /* buftarg of log */
+	struct workqueue_struct	*l_ioend_workqueue; /* for I/O completions */
+	struct delayed_work	l_work;		/* background flush work */
+	long			l_opstate;	/* operational state */
+	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
+	struct list_head	*l_buf_cancel_table;
+	struct list_head	r_dfops;	/* recovered log intent items */
+	int			l_iclog_hsize;  /* size of iclog header */
+	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
+	int			l_iclog_size;	/* size of log in bytes */
+	int			l_iclog_bufs;	/* number of iclog buffers */
+	xfs_daddr_t		l_logBBstart;   /* start block of log */
+	int			l_logsize;      /* size of log in bytes */
+	int			l_logBBsize;    /* size of log in BB chunks */
+
+	/* The following block of fields are changed while holding icloglock */
+	wait_queue_head_t	l_flush_wait ____cacheline_aligned_in_smp;
+						/* waiting for iclog flush */
+	int			l_covered_state;/* state of "covering disk
+						 * log entries" */
+	struct xlog_in_core	*l_iclog;       /* head log queue	*/
+	spinlock_t		l_icloglock;    /* grab to change iclog state */
+	int			l_curr_cycle;   /* Cycle number of log writes */
+	int			l_prev_cycle;   /* Cycle number before last
+						 * block increment */
+	int			l_curr_block;   /* current logical log block */
+	int			l_prev_block;   /* previous logical log block */
+
+	/*
+	 * l_tail_lsn is atomic so it can be set and read without needing to
+	 * hold specific locks. To avoid operations contending with other hot
+	 * objects, it on a separate cacheline.
+	 */
+	/* lsn of 1st LR with unflushed * buffers */
+	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
+
+	struct xlog_grant_head	l_reserve_head;
+	struct xlog_grant_head	l_write_head;
+	uint64_t		l_tail_space;
+
+	struct xfs_kobj		l_kobj;
+
+	/* log recovery lsn tracking (for buffer submission */
+	xfs_lsn_t		l_recovery_lsn;
+
+	uint32_t		l_iclog_roundoff;/* padding roundoff */
+};
+
+/*
+ * Bits for operational state
+ */
+#define XLOG_ACTIVE_RECOVERY	0	/* in the middle of recovery */
+#define XLOG_RECOVERY_NEEDED	1	/* log was recovered */
+#define XLOG_IO_ERROR		2	/* log hit an I/O error, and being
+				   shutdown */
+#define XLOG_TAIL_WARN		3	/* log tail verify warning issued */
+#define XLOG_SHUTDOWN_STARTED	4	/* xlog_force_shutdown() exclusion */
+
+static inline bool
+xlog_recovery_needed(struct xlog *log)
+{
+	return test_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
+}
+
+static inline bool
+xlog_in_recovery(struct xlog *log)
+{
+	return test_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
+}
+
+static inline bool
+xlog_is_shutdown(struct xlog *log)
+{
+	return test_bit(XLOG_IO_ERROR, &log->l_opstate);
+}
+
+/*
+ * Wait until the xlog_force_shutdown() has marked the log as shut down
+ * so xlog_is_shutdown() will always return true.
+ */
+static inline void
+xlog_shutdown_wait(
+	struct xlog	*log)
+{
+	wait_var_event(&log->l_opstate, xlog_is_shutdown(log));
+}
+
+/* common routines */
+extern int
+xlog_recover(
+	struct xlog		*log);
+extern int
+xlog_recover_finish(
+	struct xlog		*log);
+extern void
+xlog_recover_cancel(struct xlog *);
+
+__le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
+		char *dp, unsigned int hdrsize, unsigned int size);
+
+extern struct kmem_cache *xfs_log_ticket_cache;
+struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
+		int count, bool permanent);
+
+void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
+void	xlog_print_trans(struct xfs_trans *);
+int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
+		struct list_head *lv_chain, struct xlog_ticket *tic,
+		uint32_t len);
+int	xlog_write_one_vec(struct xlog *log, struct xfs_cil_ctx *ctx,
+		struct xfs_log_iovec *reg, struct xlog_ticket *ticket);
+void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
+void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
+
+void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
+		int eventual_size);
+int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
+		struct xlog_ticket *ticket);
+
+/*
+ * When we crack an atomic LSN, we sample it first so that the value will not
+ * change while we are cracking it into the component values. This means we
+ * will always get consistent component values to work from. This should always
+ * be used to sample and crack LSNs that are stored and updated in atomic
+ * variables.
+ */
+static inline void
+xlog_crack_atomic_lsn(atomic64_t *lsn, uint *cycle, uint *block)
+{
+	xfs_lsn_t val = atomic64_read(lsn);
+
+	*cycle = CYCLE_LSN(val);
+	*block = BLOCK_LSN(val);
+}
+
+/*
+ * Calculate and assign a value to an atomic LSN variable from component pieces.
+ */
+static inline void
+xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
+{
+	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
+}
+
+/*
+ * Committed Item List interfaces
+ */
+int	xlog_cil_init(struct xlog *log);
+void	xlog_cil_init_post_recovery(struct xlog *log);
+void	xlog_cil_destroy(struct xlog *log);
+bool	xlog_cil_empty(struct xlog *log);
+void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
+			xfs_csn_t *commit_seq, bool regrant);
+void	xlog_cil_set_ctx_write_state(struct xfs_cil_ctx *ctx,
+			struct xlog_in_core *iclog);
+
+
+/*
+ * CIL force routines
+ */
+void xlog_cil_flush(struct xlog *log);
+xfs_lsn_t xlog_cil_force_seq(struct xlog *log, xfs_csn_t sequence);
+
+static inline void
+xlog_cil_force(struct xlog *log)
+{
+	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
+}
+
+/*
+ * Wrapper function for waiting on a wait queue serialised against wakeups
+ * by a spinlock. This matches the semantics of all the wait queues used in the
+ * log code.
+ */
+static inline void
+xlog_wait(
+	struct wait_queue_head	*wq,
+	struct spinlock		*lock)
+		__releases(lock)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	add_wait_queue_exclusive(wq, &wait);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	spin_unlock(lock);
+	schedule();
+	remove_wait_queue(wq, &wait);
+}
+
+int xlog_wait_on_iclog(struct xlog_in_core *iclog)
+		__releases(iclog->ic_log->l_icloglock);
+
+/* Calculate the distance between two LSNs in bytes */
+static inline uint64_t
+xlog_lsn_sub(
+	struct xlog	*log,
+	xfs_lsn_t	high,
+	xfs_lsn_t	low)
+{
+	uint32_t	hi_cycle = CYCLE_LSN(high);
+	uint32_t	hi_block = BLOCK_LSN(high);
+	uint32_t	lo_cycle = CYCLE_LSN(low);
+	uint32_t	lo_block = BLOCK_LSN(low);
+
+	if (hi_cycle == lo_cycle)
+		return BBTOB(hi_block - lo_block);
+	ASSERT((hi_cycle == lo_cycle + 1) || xlog_is_shutdown(log));
+	return (uint64_t)log->l_logsize - BBTOB(lo_block - hi_block);
+}
+
+void xlog_grant_return_space(struct xlog *log, xfs_lsn_t old_head,
+		xfs_lsn_t new_head);
+
+/*
+ * The LSN is valid so long as it is behind the current LSN. If it isn't, this
+ * means that the next log record that includes this metadata could have a
+ * smaller LSN. In turn, this means that the modification in the log would not
+ * replay.
+ */
+static inline bool
+xlog_valid_lsn(
+	struct xlog	*log,
+	xfs_lsn_t	lsn)
+{
+	int		cur_cycle;
+	int		cur_block;
+	bool		valid = true;
+
+	/*
+	 * First, sample the current lsn without locking to avoid added
+	 * contention from metadata I/O. The current cycle and block are updated
+	 * (in xlog_state_switch_iclogs()) and read here in a particular order
+	 * to avoid false negatives (e.g., thinking the metadata LSN is valid
+	 * when it is not).
+	 *
+	 * The current block is always rewound before the cycle is bumped in
+	 * xlog_state_switch_iclogs() to ensure the current LSN is never seen in
+	 * a transiently forward state. Instead, we can see the LSN in a
+	 * transiently behind state if we happen to race with a cycle wrap.
+	 */
+	cur_cycle = READ_ONCE(log->l_curr_cycle);
+	smp_rmb();
+	cur_block = READ_ONCE(log->l_curr_block);
+
+	if ((CYCLE_LSN(lsn) > cur_cycle) ||
+	    (CYCLE_LSN(lsn) == cur_cycle && BLOCK_LSN(lsn) > cur_block)) {
+		/*
+		 * If the metadata LSN appears invalid, it's possible the check
+		 * above raced with a wrap to the next log cycle. Grab the lock
+		 * to check for sure.
+		 */
+		spin_lock(&log->l_icloglock);
+		cur_cycle = log->l_curr_cycle;
+		cur_block = log->l_curr_block;
+		spin_unlock(&log->l_icloglock);
+
+		if ((CYCLE_LSN(lsn) > cur_cycle) ||
+		    (CYCLE_LSN(lsn) == cur_cycle && BLOCK_LSN(lsn) > cur_block))
+			valid = false;
+	}
+
+	return valid;
+}
+
+/*
+ * Log vector and shadow buffers can be large, so we need to use kvmalloc() here
+ * to ensure success. Unfortunately, kvmalloc() only allows GFP_KERNEL contexts
+ * to fall back to vmalloc, so we can't actually do anything useful with gfp
+ * flags to control the kmalloc() behaviour within kvmalloc(). Hence kmalloc()
+ * will do direct reclaim and compaction in the slow path, both of which are
+ * horrendously expensive. We just want kmalloc to fail fast and fall back to
+ * vmalloc if it can't get something straight away from the free lists or
+ * buddy allocator. Hence we have to open code kvmalloc outselves here.
+ *
+ * This assumes that the caller uses memalloc_nofs_save task context here, so
+ * despite the use of GFP_KERNEL here, we are going to be doing GFP_NOFS
+ * allocations. This is actually the only way to make vmalloc() do GFP_NOFS
+ * allocations, so lets just all pretend this is a GFP_KERNEL context
+ * operation....
+ */
+static inline void *
+xlog_kvmalloc(
+	size_t		buf_size)
+{
+	gfp_t		flags = GFP_KERNEL;
+	void		*p;
+
+	flags &= ~__GFP_DIRECT_RECLAIM;
+	flags |= __GFP_NOWARN | __GFP_NORETRY;
+	do {
+		p = kmalloc(buf_size, flags);
+		if (!p)
+			p = vmalloc(buf_size);
+	} while (!p);
+
+	return p;
+}
+
+/*
+ * Given a count of iovecs and space for a log item, compute the space we need
+ * in the log to store that data plus the log headers.
+ */
+static inline unsigned int
+xlog_item_space(
+	unsigned int	niovecs,
+	unsigned int	nbytes)
+{
+	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
+	return round_up(nbytes, sizeof(uint64_t));
+}
+
+/*
+ * Cycles over XLOG_CYCLE_DATA_SIZE overflow into the extended header that was
+ * added for v2 logs.  Addressing for the cycles array there is off by one,
+ * because the first batch of cycles is in the original header.
+ */
+static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
+{
+	if (i >= XLOG_CYCLE_DATA_SIZE) {
+		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
+		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
+
+		return &rhead->h_ext[j - 1].xh_cycle_data[k];
+	}
+
+	return &rhead->h_cycle_data[i];
+}
+
+#endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
new file mode 100644
index 00000000..9bddd434
--- /dev/null
+++ b/libxlog/xfs_log_recover.c
@@ -0,0 +1,3575 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_trans_priv.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_trace.h"
+#include "xfs_buf_item.h"
+#include "xfs_ag.h"
+#include "xfs_quota_defs.h"
+
+#define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
+
+STATIC int
+xlog_find_zeroed(
+	struct xlog	*,
+	xfs_daddr_t	*);
+STATIC int
+xlog_clear_stale_blocks(
+	struct xlog	*,
+	xfs_lsn_t);
+STATIC int
+xlog_do_recovery_pass(
+        struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
+
+/*
+ * Sector aligned buffer routines for buffer create/read/write/access
+ */
+
+/*
+ * Verify the log-relative block number and length in basic blocks are valid for
+ * an operation involving the given XFS log buffer. Returns true if the fields
+ * are valid, false otherwise.
+ */
+static inline bool
+xlog_verify_bno(
+	struct xlog	*log,
+	xfs_daddr_t	blk_no,
+	int		bbcount)
+{
+	if (blk_no < 0 || blk_no >= log->l_logBBsize)
+		return false;
+	if (bbcount <= 0 || (blk_no + bbcount) > log->l_logBBsize)
+		return false;
+	return true;
+}
+
+/*
+ * Allocate a buffer to hold log data.  The buffer needs to be able to map to
+ * a range of nbblks basic blocks at any valid offset within the log.
+ */
+static char *
+xlog_alloc_buffer(
+	struct xlog	*log,
+	int		nbblks)
+{
+	/*
+	 * Pass log block 0 since we don't have an addr yet, buffer will be
+	 * verified on read.
+	 */
+	if (XFS_IS_CORRUPT(log->l_mp, !xlog_verify_bno(log, 0, nbblks))) {
+		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
+			nbblks);
+		return NULL;
+	}
+
+	/*
+	 * We do log I/O in units of log sectors (a power-of-2 multiple of the
+	 * basic block size), so we round up the requested size to accommodate
+	 * the basic blocks required for complete log sectors.
+	 *
+	 * In addition, the buffer may be used for a non-sector-aligned block
+	 * offset, in which case an I/O of the requested size could extend
+	 * beyond the end of the buffer.  If the requested size is only 1 basic
+	 * block it will never straddle a sector boundary, so this won't be an
+	 * issue.  Nor will this be a problem if the log I/O is done in basic
+	 * blocks (sector size 1).  But otherwise we extend the buffer by one
+	 * extra log sector to ensure there's space to accommodate this
+	 * possibility.
+	 */
+	if (nbblks > 1 && log->l_sectBBsize > 1)
+		nbblks += log->l_sectBBsize;
+	nbblks = round_up(nbblks, log->l_sectBBsize);
+	return kvzalloc(BBTOB(nbblks), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+}
+
+/*
+ * Return the address of the start of the given block number's data
+ * in a log buffer.  The buffer covers a log sector-aligned region.
+ */
+static inline unsigned int
+xlog_align(
+	struct xlog	*log,
+	xfs_daddr_t	blk_no)
+{
+	return BBTOB(blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1));
+}
+
+static int
+xlog_do_io(
+	struct xlog		*log,
+	xfs_daddr_t		blk_no,
+	unsigned int		nbblks,
+	char			*data,
+	enum req_op		op)
+{
+	int			error;
+
+	if (XFS_IS_CORRUPT(log->l_mp, !xlog_verify_bno(log, blk_no, nbblks))) {
+		xfs_warn(log->l_mp,
+			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
+			 blk_no, nbblks);
+		return -EFSCORRUPTED;
+	}
+
+	blk_no = round_down(blk_no, log->l_sectBBsize);
+	nbblks = round_up(nbblks, log->l_sectBBsize);
+	ASSERT(nbblks > 0);
+
+	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
+			BBTOB(nbblks), data, op);
+	if (error && !xlog_is_shutdown(log)) {
+		xfs_alert(log->l_mp,
+			  "log recovery %s I/O error at daddr 0x%llx len %d error %d",
+			  op == REQ_OP_WRITE ? "write" : "read",
+			  blk_no, nbblks, error);
+	}
+	return error;
+}
+
+STATIC int
+xlog_bread_noalign(
+	struct xlog	*log,
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	char		*data)
+{
+	return xlog_do_io(log, blk_no, nbblks, data, REQ_OP_READ);
+}
+
+STATIC int
+xlog_bread(
+	struct xlog	*log,
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	char		*data,
+	char		**offset)
+{
+	int		error;
+
+	error = xlog_do_io(log, blk_no, nbblks, data, REQ_OP_READ);
+	if (!error)
+		*offset = data + xlog_align(log, blk_no);
+	return error;
+}
+
+STATIC int
+xlog_bwrite(
+	struct xlog	*log,
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	char		*data)
+{
+	return xlog_do_io(log, blk_no, nbblks, data, REQ_OP_WRITE);
+}
+
+#ifdef DEBUG
+/*
+ * dump debug superblock and log record information
+ */
+STATIC void
+xlog_header_check_dump(
+	struct xfs_mount		*mp,
+	struct xlog_rec_header		*head)
+{
+	xfs_debug(mp, "%s:  SB : uuid = %pU, fmt = %d",
+		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
+	xfs_debug(mp, "    log : uuid = %pU, fmt = %d",
+		&head->h_fs_uuid, be32_to_cpu(head->h_fmt));
+}
+#else
+#define xlog_header_check_dump(mp, head)
+#endif
+
+/*
+ * check log record header for recovery
+ */
+STATIC int
+xlog_header_check_recover(
+	struct xfs_mount	*mp,
+	struct xlog_rec_header	*head)
+{
+	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
+
+	/*
+	 * IRIX doesn't write the h_fmt field and leaves it zeroed
+	 * (XLOG_FMT_UNKNOWN). This stops us from trying to recover
+	 * a dirty log created in IRIX.
+	 */
+	if (XFS_IS_CORRUPT(mp, head->h_fmt != cpu_to_be32(XLOG_FMT))) {
+		xfs_warn(mp,
+	"dirty log written in incompatible format - can't recover");
+		xlog_header_check_dump(mp, head);
+		return -EFSCORRUPTED;
+	}
+	if (XFS_IS_CORRUPT(mp, !uuid_equal(&mp->m_sb.sb_uuid,
+					   &head->h_fs_uuid))) {
+		xfs_warn(mp,
+	"dirty log entry has mismatched uuid - can't recover");
+		xlog_header_check_dump(mp, head);
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
+/*
+ * read the head block of the log and check the header
+ */
+STATIC int
+xlog_header_check_mount(
+	struct xfs_mount	*mp,
+	struct xlog_rec_header	*head)
+{
+	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
+
+	if (uuid_is_null(&head->h_fs_uuid)) {
+		/*
+		 * IRIX doesn't write the h_fs_uuid or h_fmt fields. If
+		 * h_fs_uuid is null, we assume this log was last mounted
+		 * by IRIX and continue.
+		 */
+		xfs_warn(mp, "null uuid in log - IRIX style log");
+	} else if (XFS_IS_CORRUPT(mp, !uuid_equal(&mp->m_sb.sb_uuid,
+						  &head->h_fs_uuid))) {
+		xfs_warn(mp, "log has mismatched uuid - can't recover");
+		xlog_header_check_dump(mp, head);
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
+/*
+ * This routine finds (to an approximation) the first block in the physical
+ * log which contains the given cycle.  It uses a binary search algorithm.
+ * Note that the algorithm can not be perfect because the disk will not
+ * necessarily be perfect.
+ */
+STATIC int
+xlog_find_cycle_start(
+	struct xlog	*log,
+	char		*buffer,
+	xfs_daddr_t	first_blk,
+	xfs_daddr_t	*last_blk,
+	uint		cycle)
+{
+	char		*offset;
+	xfs_daddr_t	mid_blk;
+	xfs_daddr_t	end_blk;
+	uint		mid_cycle;
+	int		error;
+
+	end_blk = *last_blk;
+	mid_blk = BLK_AVG(first_blk, end_blk);
+	while (mid_blk != first_blk && mid_blk != end_blk) {
+		error = xlog_bread(log, mid_blk, 1, buffer, &offset);
+		if (error)
+			return error;
+		mid_cycle = xlog_get_cycle(offset);
+		if (mid_cycle == cycle)
+			end_blk = mid_blk;   /* last_half_cycle == mid_cycle */
+		else
+			first_blk = mid_blk; /* first_half_cycle == mid_cycle */
+		mid_blk = BLK_AVG(first_blk, end_blk);
+	}
+	ASSERT((mid_blk == first_blk && mid_blk+1 == end_blk) ||
+	       (mid_blk == end_blk && mid_blk-1 == first_blk));
+
+	*last_blk = end_blk;
+
+	return 0;
+}
+
+/*
+ * Check that a range of blocks does not contain stop_on_cycle_no.
+ * Fill in *new_blk with the block offset where such a block is
+ * found, or with -1 (an invalid block number) if there is no such
+ * block in the range.  The scan needs to occur from front to back
+ * and the pointer into the region must be updated since a later
+ * routine will need to perform another test.
+ */
+STATIC int
+xlog_find_verify_cycle(
+	struct xlog	*log,
+	xfs_daddr_t	start_blk,
+	int		nbblks,
+	uint		stop_on_cycle_no,
+	xfs_daddr_t	*new_blk)
+{
+	xfs_daddr_t	i, j;
+	uint		cycle;
+	char		*buffer;
+	xfs_daddr_t	bufblks;
+	char		*buf = NULL;
+	int		error = 0;
+
+	/*
+	 * Greedily allocate a buffer big enough to handle the full
+	 * range of basic blocks we'll be examining.  If that fails,
+	 * try a smaller size.  We need to be able to read at least
+	 * a log sector, or we're out of luck.
+	 */
+	bufblks = roundup_pow_of_two(nbblks);
+	while (bufblks > log->l_logBBsize)
+		bufblks >>= 1;
+	while (!(buffer = xlog_alloc_buffer(log, bufblks))) {
+		bufblks >>= 1;
+		if (bufblks < log->l_sectBBsize)
+			return -ENOMEM;
+	}
+
+	for (i = start_blk; i < start_blk + nbblks; i += bufblks) {
+		int	bcount;
+
+		bcount = min(bufblks, (start_blk + nbblks - i));
+
+		error = xlog_bread(log, i, bcount, buffer, &buf);
+		if (error)
+			goto out;
+
+		for (j = 0; j < bcount; j++) {
+			cycle = xlog_get_cycle(buf);
+			if (cycle == stop_on_cycle_no) {
+				*new_blk = i+j;
+				goto out;
+			}
+
+			buf += BBSIZE;
+		}
+	}
+
+	*new_blk = -1;
+
+out:
+	kvfree(buffer);
+	return error;
+}
+
+static inline int
+xlog_logrec_hblks(struct xlog *log, struct xlog_rec_header *rh)
+{
+	if (xfs_has_logv2(log->l_mp)) {
+		int	h_size = be32_to_cpu(rh->h_size);
+
+		if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
+		    h_size > XLOG_HEADER_CYCLE_SIZE)
+			return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+	}
+	return 1;
+}
+
+/*
+ * Potentially backup over partial log record write.
+ *
+ * In the typical case, last_blk is the number of the block directly after
+ * a good log record.  Therefore, we subtract one to get the block number
+ * of the last block in the given buffer.  extra_bblks contains the number
+ * of blocks we would have read on a previous read.  This happens when the
+ * last log record is split over the end of the physical log.
+ *
+ * extra_bblks is the number of blocks potentially verified on a previous
+ * call to this routine.
+ */
+STATIC int
+xlog_find_verify_log_record(
+	struct xlog		*log,
+	xfs_daddr_t		start_blk,
+	xfs_daddr_t		*last_blk,
+	int			extra_bblks)
+{
+	xfs_daddr_t		i;
+	char			*buffer;
+	char			*offset = NULL;
+	struct xlog_rec_header	*head = NULL;
+	int			error = 0;
+	int			smallmem = 0;
+	int			num_blks = *last_blk - start_blk;
+	int			xhdrs;
+
+	ASSERT(start_blk != 0 || *last_blk != start_blk);
+
+	buffer = xlog_alloc_buffer(log, num_blks);
+	if (!buffer) {
+		buffer = xlog_alloc_buffer(log, 1);
+		if (!buffer)
+			return -ENOMEM;
+		smallmem = 1;
+	} else {
+		error = xlog_bread(log, start_blk, num_blks, buffer, &offset);
+		if (error)
+			goto out;
+		offset += ((num_blks - 1) << BBSHIFT);
+	}
+
+	for (i = (*last_blk) - 1; i >= 0; i--) {
+		if (i < start_blk) {
+			/* valid log record not found */
+			xfs_warn(log->l_mp,
+		"Log inconsistent (didn't find previous header)");
+			ASSERT(0);
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+
+		if (smallmem) {
+			error = xlog_bread(log, i, 1, buffer, &offset);
+			if (error)
+				goto out;
+		}
+
+		head = (struct xlog_rec_header *)offset;
+
+		if (head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
+			break;
+
+		if (!smallmem)
+			offset -= BBSIZE;
+	}
+
+	/*
+	 * We hit the beginning of the physical log & still no header.  Return
+	 * to caller.  If caller can handle a return of -1, then this routine
+	 * will be called again for the end of the physical log.
+	 */
+	if (i == -1) {
+		error = 1;
+		goto out;
+	}
+
+	/*
+	 * We have the final block of the good log (the first block
+	 * of the log record _before_ the head. So we check the uuid.
+	 */
+	if ((error = xlog_header_check_mount(log->l_mp, head)))
+		goto out;
+
+	/*
+	 * We may have found a log record header before we expected one.
+	 * last_blk will be the 1st block # with a given cycle #.  We may end
+	 * up reading an entire log record.  In this case, we don't want to
+	 * reset last_blk.  Only when last_blk points in the middle of a log
+	 * record do we update last_blk.
+	 */
+	xhdrs = xlog_logrec_hblks(log, head);
+
+	if (*last_blk - i + extra_bblks !=
+	    BTOBB(be32_to_cpu(head->h_len)) + xhdrs)
+		*last_blk = i;
+
+out:
+	kvfree(buffer);
+	return error;
+}
+
+/*
+ * Head is defined to be the point of the log where the next log write
+ * could go.  This means that incomplete LR writes at the end are
+ * eliminated when calculating the head.  We aren't guaranteed that previous
+ * LR have complete transactions.  We only know that a cycle number of
+ * current cycle number -1 won't be present in the log if we start writing
+ * from our current block number.
+ *
+ * last_blk contains the block number of the first block with a given
+ * cycle number.
+ *
+ * Return: zero if normal, non-zero if error.
+ */
+STATIC int
+xlog_find_head(
+	struct xlog	*log,
+	xfs_daddr_t	*return_head_blk)
+{
+	char		*buffer;
+	char		*offset;
+	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
+	int		num_scan_bblks;
+	uint		first_half_cycle, last_half_cycle;
+	uint		stop_on_cycle;
+	int		error, log_bbnum = log->l_logBBsize;
+
+	/* Is the end of the log device zeroed? */
+	error = xlog_find_zeroed(log, &first_blk);
+	if (error < 0) {
+		xfs_warn(log->l_mp, "empty log check failed");
+		return error;
+	}
+	if (error == 1) {
+		*return_head_blk = first_blk;
+
+		/* Is the whole lot zeroed? */
+		if (!first_blk) {
+			/* Linux XFS shouldn't generate totally zeroed logs -
+			 * mkfs etc write a dummy unmount record to a fresh
+			 * log so we can store the uuid in there
+			 */
+			xfs_warn(log->l_mp, "totally zeroed log");
+		}
+
+		return 0;
+	}
+
+	first_blk = 0;			/* get cycle # of 1st block */
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
+		return -ENOMEM;
+
+	error = xlog_bread(log, 0, 1, buffer, &offset);
+	if (error)
+		goto out_free_buffer;
+
+	first_half_cycle = xlog_get_cycle(offset);
+
+	last_blk = head_blk = log_bbnum - 1;	/* get cycle # of last block */
+	error = xlog_bread(log, last_blk, 1, buffer, &offset);
+	if (error)
+		goto out_free_buffer;
+
+	last_half_cycle = xlog_get_cycle(offset);
+	ASSERT(last_half_cycle != 0);
+
+	/*
+	 * If the 1st half cycle number is equal to the last half cycle number,
+	 * then the entire log is stamped with the same cycle number.  In this
+	 * case, head_blk can't be set to zero (which makes sense).  The below
+	 * math doesn't work out properly with head_blk equal to zero.  Instead,
+	 * we set it to log_bbnum which is an invalid block number, but this
+	 * value makes the math correct.  If head_blk doesn't changed through
+	 * all the tests below, *head_blk is set to zero at the very end rather
+	 * than log_bbnum.  In a sense, log_bbnum and zero are the same block
+	 * in a circular file.
+	 */
+	if (first_half_cycle == last_half_cycle) {
+		/*
+		 * In this case we believe that the entire log should have
+		 * cycle number last_half_cycle.  We need to scan backwards
+		 * from the end verifying that there are no holes still
+		 * containing last_half_cycle - 1.  If we find such a hole,
+		 * then the start of that hole will be the new head.  The
+		 * simple case looks like
+		 *        x | x ... | x - 1 | x
+		 * Another case that fits this picture would be
+		 *        x | x + 1 | x ... | x
+		 * In this case the head really is somewhere at the end of the
+		 * log, as one of the latest writes at the beginning was
+		 * incomplete.
+		 * One more case is
+		 *        x | x + 1 | x ... | x - 1 | x
+		 * This is really the combination of the above two cases, and
+		 * the head has to end up at the start of the x-1 hole at the
+		 * end of the log.
+		 *
+		 * In the 256k log case, we will read from the beginning to the
+		 * end of the log and search for cycle numbers equal to x-1.
+		 * We don't worry about the x+1 blocks that we encounter,
+		 * because we know that they cannot be the head since the log
+		 * started with x.
+		 */
+		head_blk = log_bbnum;
+		stop_on_cycle = last_half_cycle - 1;
+	} else {
+		/*
+		 * In this case we want to find the first block with cycle
+		 * number matching last_half_cycle.  We expect the log to be
+		 * some variation on
+		 *        x + 1 ... | x ... | x
+		 * The first block with cycle number x (last_half_cycle) will
+		 * be where the new head belongs.  First we do a binary search
+		 * for the first occurrence of last_half_cycle.  The binary
+		 * search may not be totally accurate, so then we scan back
+		 * from there looking for occurrences of last_half_cycle before
+		 * us.  If that backwards scan wraps around the beginning of
+		 * the log, then we look for occurrences of last_half_cycle - 1
+		 * at the end of the log.  The cases we're looking for look
+		 * like
+		 *                               v binary search stopped here
+		 *        x + 1 ... | x | x + 1 | x ... | x
+		 *                   ^ but we want to locate this spot
+		 * or
+		 *        <---------> less than scan distance
+		 *        x + 1 ... | x ... | x - 1 | x
+		 *                           ^ we want to locate this spot
+		 */
+		stop_on_cycle = last_half_cycle;
+		error = xlog_find_cycle_start(log, buffer, first_blk, &head_blk,
+				last_half_cycle);
+		if (error)
+			goto out_free_buffer;
+	}
+
+	/*
+	 * Now validate the answer.  Scan back some number of maximum possible
+	 * blocks and make sure each one has the expected cycle number.  The
+	 * maximum is determined by the total possible amount of buffering
+	 * in the in-core log.  The following number can be made tighter if
+	 * we actually look at the block size of the filesystem.
+	 */
+	num_scan_bblks = min_t(int, log_bbnum, XLOG_TOTAL_REC_SHIFT(log));
+	if (head_blk >= num_scan_bblks) {
+		/*
+		 * We are guaranteed that the entire check can be performed
+		 * in one buffer.
+		 */
+		start_blk = head_blk - num_scan_bblks;
+		if ((error = xlog_find_verify_cycle(log,
+						start_blk, num_scan_bblks,
+						stop_on_cycle, &new_blk)))
+			goto out_free_buffer;
+		if (new_blk != -1)
+			head_blk = new_blk;
+	} else {		/* need to read 2 parts of log */
+		/*
+		 * We are going to scan backwards in the log in two parts.
+		 * First we scan the physical end of the log.  In this part
+		 * of the log, we are looking for blocks with cycle number
+		 * last_half_cycle - 1.
+		 * If we find one, then we know that the log starts there, as
+		 * we've found a hole that didn't get written in going around
+		 * the end of the physical log.  The simple case for this is
+		 *        x + 1 ... | x ... | x - 1 | x
+		 *        <---------> less than scan distance
+		 * If all of the blocks at the end of the log have cycle number
+		 * last_half_cycle, then we check the blocks at the start of
+		 * the log looking for occurrences of last_half_cycle.  If we
+		 * find one, then our current estimate for the location of the
+		 * first occurrence of last_half_cycle is wrong and we move
+		 * back to the hole we've found.  This case looks like
+		 *        x + 1 ... | x | x + 1 | x ...
+		 *                               ^ binary search stopped here
+		 * Another case we need to handle that only occurs in 256k
+		 * logs is
+		 *        x + 1 ... | x ... | x+1 | x ...
+		 *                   ^ binary search stops here
+		 * In a 256k log, the scan at the end of the log will see the
+		 * x + 1 blocks.  We need to skip past those since that is
+		 * certainly not the head of the log.  By searching for
+		 * last_half_cycle-1 we accomplish that.
+		 */
+		ASSERT(head_blk <= INT_MAX &&
+			(xfs_daddr_t) num_scan_bblks >= head_blk);
+		start_blk = log_bbnum - (num_scan_bblks - head_blk);
+		if ((error = xlog_find_verify_cycle(log, start_blk,
+					num_scan_bblks - (int)head_blk,
+					(stop_on_cycle - 1), &new_blk)))
+			goto out_free_buffer;
+		if (new_blk != -1) {
+			head_blk = new_blk;
+			goto validate_head;
+		}
+
+		/*
+		 * Scan beginning of log now.  The last part of the physical
+		 * log is good.  This scan needs to verify that it doesn't find
+		 * the last_half_cycle.
+		 */
+		start_blk = 0;
+		ASSERT(head_blk <= INT_MAX);
+		if ((error = xlog_find_verify_cycle(log,
+					start_blk, (int)head_blk,
+					stop_on_cycle, &new_blk)))
+			goto out_free_buffer;
+		if (new_blk != -1)
+			head_blk = new_blk;
+	}
+
+validate_head:
+	/*
+	 * Now we need to make sure head_blk is not pointing to a block in
+	 * the middle of a log record.
+	 */
+	num_scan_bblks = XLOG_REC_SHIFT(log);
+	if (head_blk >= num_scan_bblks) {
+		start_blk = head_blk - num_scan_bblks; /* don't read head_blk */
+
+		/* start ptr at last block ptr before head_blk */
+		error = xlog_find_verify_log_record(log, start_blk, &head_blk, 0);
+		if (error == 1)
+			error = -EIO;
+		if (error)
+			goto out_free_buffer;
+	} else {
+		start_blk = 0;
+		ASSERT(head_blk <= INT_MAX);
+		error = xlog_find_verify_log_record(log, start_blk, &head_blk, 0);
+		if (error < 0)
+			goto out_free_buffer;
+		if (error == 1) {
+			/* We hit the beginning of the log during our search */
+			start_blk = log_bbnum - (num_scan_bblks - head_blk);
+			new_blk = log_bbnum;
+			ASSERT(start_blk <= INT_MAX &&
+				(xfs_daddr_t) log_bbnum-start_blk >= 0);
+			ASSERT(head_blk <= INT_MAX);
+			error = xlog_find_verify_log_record(log, start_blk,
+							&new_blk, (int)head_blk);
+			if (error == 1)
+				error = -EIO;
+			if (error)
+				goto out_free_buffer;
+			if (new_blk != log_bbnum)
+				head_blk = new_blk;
+		} else if (error)
+			goto out_free_buffer;
+	}
+
+	kvfree(buffer);
+	if (head_blk == log_bbnum)
+		*return_head_blk = 0;
+	else
+		*return_head_blk = head_blk;
+	/*
+	 * When returning here, we have a good block number.  Bad block
+	 * means that during a previous crash, we didn't have a clean break
+	 * from cycle number N to cycle number N-1.  In this case, we need
+	 * to find the first block with cycle number N-1.
+	 */
+	return 0;
+
+out_free_buffer:
+	kvfree(buffer);
+	if (error)
+		xfs_warn(log->l_mp, "failed to find log head");
+	return error;
+}
+
+/*
+ * Seek backwards in the log for log record headers.
+ *
+ * Given a starting log block, walk backwards until we find the provided number
+ * of records or hit the provided tail block. The return value is the number of
+ * records encountered or a negative error code. The log block and buffer
+ * pointer of the last record seen are returned in rblk and rhead respectively.
+ */
+STATIC int
+xlog_rseek_logrec_hdr(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk,
+	int			count,
+	char			*buffer,
+	xfs_daddr_t		*rblk,
+	struct xlog_rec_header	**rhead,
+	bool			*wrapped)
+{
+	int			i;
+	int			error;
+	int			found = 0;
+	char			*offset = NULL;
+	xfs_daddr_t		end_blk;
+
+	*wrapped = false;
+
+	/*
+	 * Walk backwards from the head block until we hit the tail or the first
+	 * block in the log.
+	 */
+	end_blk = head_blk > tail_blk ? tail_blk : 0;
+	for (i = (int) head_blk - 1; i >= end_blk; i--) {
+		error = xlog_bread(log, i, 1, buffer, &offset);
+		if (error)
+			goto out_error;
+
+		if (*(__be32 *) offset == cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+			*rblk = i;
+			*rhead = (struct xlog_rec_header *) offset;
+			if (++found == count)
+				break;
+		}
+	}
+
+	/*
+	 * If we haven't hit the tail block or the log record header count,
+	 * start looking again from the end of the physical log. Note that
+	 * callers can pass head == tail if the tail is not yet known.
+	 */
+	if (tail_blk >= head_blk && found != count) {
+		for (i = log->l_logBBsize - 1; i >= (int) tail_blk; i--) {
+			error = xlog_bread(log, i, 1, buffer, &offset);
+			if (error)
+				goto out_error;
+
+			if (*(__be32 *)offset ==
+			    cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+				*wrapped = true;
+				*rblk = i;
+				*rhead = (struct xlog_rec_header *) offset;
+				if (++found == count)
+					break;
+			}
+		}
+	}
+
+	return found;
+
+out_error:
+	return error;
+}
+
+/*
+ * Seek forward in the log for log record headers.
+ *
+ * Given head and tail blocks, walk forward from the tail block until we find
+ * the provided number of records or hit the head block. The return value is the
+ * number of records encountered or a negative error code. The log block and
+ * buffer pointer of the last record seen are returned in rblk and rhead
+ * respectively.
+ */
+STATIC int
+xlog_seek_logrec_hdr(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk,
+	int			count,
+	char			*buffer,
+	xfs_daddr_t		*rblk,
+	struct xlog_rec_header	**rhead,
+	bool			*wrapped)
+{
+	int			i;
+	int			error;
+	int			found = 0;
+	char			*offset = NULL;
+	xfs_daddr_t		end_blk;
+
+	*wrapped = false;
+
+	/*
+	 * Walk forward from the tail block until we hit the head or the last
+	 * block in the log.
+	 */
+	end_blk = head_blk > tail_blk ? head_blk : log->l_logBBsize - 1;
+	for (i = (int) tail_blk; i <= end_blk; i++) {
+		error = xlog_bread(log, i, 1, buffer, &offset);
+		if (error)
+			goto out_error;
+
+		if (*(__be32 *) offset == cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+			*rblk = i;
+			*rhead = (struct xlog_rec_header *) offset;
+			if (++found == count)
+				break;
+		}
+	}
+
+	/*
+	 * If we haven't hit the head block or the log record header count,
+	 * start looking again from the start of the physical log.
+	 */
+	if (tail_blk > head_blk && found != count) {
+		for (i = 0; i < (int) head_blk; i++) {
+			error = xlog_bread(log, i, 1, buffer, &offset);
+			if (error)
+				goto out_error;
+
+			if (*(__be32 *)offset ==
+			    cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+				*wrapped = true;
+				*rblk = i;
+				*rhead = (struct xlog_rec_header *) offset;
+				if (++found == count)
+					break;
+			}
+		}
+	}
+
+	return found;
+
+out_error:
+	return error;
+}
+
+/*
+ * Calculate distance from head to tail (i.e., unused space in the log).
+ */
+static inline int
+xlog_tail_distance(
+	struct xlog	*log,
+	xfs_daddr_t	head_blk,
+	xfs_daddr_t	tail_blk)
+{
+	if (head_blk < tail_blk)
+		return tail_blk - head_blk;
+
+	return tail_blk + (log->l_logBBsize - head_blk);
+}
+
+/*
+ * Verify the log tail. This is particularly important when torn or incomplete
+ * writes have been detected near the front of the log and the head has been
+ * walked back accordingly.
+ *
+ * We also have to handle the case where the tail was pinned and the head
+ * blocked behind the tail right before a crash. If the tail had been pushed
+ * immediately prior to the crash and the subsequent checkpoint was only
+ * partially written, it's possible it overwrote the last referenced tail in the
+ * log with garbage. This is not a coherency problem because the tail must have
+ * been pushed before it can be overwritten, but appears as log corruption to
+ * recovery because we have no way to know the tail was updated if the
+ * subsequent checkpoint didn't write successfully.
+ *
+ * Therefore, CRC check the log from tail to head. If a failure occurs and the
+ * offending record is within max iclog bufs from the head, walk the tail
+ * forward and retry until a valid tail is found or corruption is detected out
+ * of the range of a possible overwrite.
+ */
+STATIC int
+xlog_verify_tail(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		*tail_blk,
+	int			hsize)
+{
+	struct xlog_rec_header	*thead;
+	char			*buffer;
+	xfs_daddr_t		first_bad;
+	int			error = 0;
+	bool			wrapped;
+	xfs_daddr_t		tmp_tail;
+	xfs_daddr_t		orig_tail = *tail_blk;
+
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
+		return -ENOMEM;
+
+	/*
+	 * Make sure the tail points to a record (returns positive count on
+	 * success).
+	 */
+	error = xlog_seek_logrec_hdr(log, head_blk, *tail_blk, 1, buffer,
+			&tmp_tail, &thead, &wrapped);
+	if (error < 0)
+		goto out;
+	if (*tail_blk != tmp_tail)
+		*tail_blk = tmp_tail;
+
+	/*
+	 * Run a CRC check from the tail to the head. We can't just check
+	 * MAX_ICLOGS records past the tail because the tail may point to stale
+	 * blocks cleared during the search for the head/tail. These blocks are
+	 * overwritten with zero-length records and thus record count is not a
+	 * reliable indicator of the iclog state before a crash.
+	 */
+	first_bad = 0;
+	error = xlog_do_recovery_pass(log, head_blk, *tail_blk,
+				      XLOG_RECOVER_CRCPASS, &first_bad);
+	while ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
+		int	tail_distance;
+
+		/*
+		 * Is corruption within range of the head? If so, retry from
+		 * the next record. Otherwise return an error.
+		 */
+		tail_distance = xlog_tail_distance(log, head_blk, first_bad);
+		if (tail_distance > BTOBB(XLOG_MAX_ICLOGS * hsize))
+			break;
+
+		/* skip to the next record; returns positive count on success */
+		error = xlog_seek_logrec_hdr(log, head_blk, first_bad, 2,
+				buffer, &tmp_tail, &thead, &wrapped);
+		if (error < 0)
+			goto out;
+
+		*tail_blk = tmp_tail;
+		first_bad = 0;
+		error = xlog_do_recovery_pass(log, head_blk, *tail_blk,
+					      XLOG_RECOVER_CRCPASS, &first_bad);
+	}
+
+	if (!error && *tail_blk != orig_tail)
+		xfs_warn(log->l_mp,
+		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
+			 orig_tail, *tail_blk);
+out:
+	kvfree(buffer);
+	return error;
+}
+
+/*
+ * Detect and trim torn writes from the head of the log.
+ *
+ * Storage without sector atomicity guarantees can result in torn writes in the
+ * log in the event of a crash. Our only means to detect this scenario is via
+ * CRC verification. While we can't always be certain that CRC verification
+ * failure is due to a torn write vs. an unrelated corruption, we do know that
+ * only a certain number (XLOG_MAX_ICLOGS) of log records can be written out at
+ * one time. Therefore, CRC verify up to XLOG_MAX_ICLOGS records at the head of
+ * the log and treat failures in this range as torn writes as a matter of
+ * policy. In the event of CRC failure, the head is walked back to the last good
+ * record in the log and the tail is updated from that record and verified.
+ */
+STATIC int
+xlog_verify_head(
+	struct xlog		*log,
+	xfs_daddr_t		*head_blk,	/* in/out: unverified head */
+	xfs_daddr_t		*tail_blk,	/* out: tail block */
+	char			*buffer,
+	xfs_daddr_t		*rhead_blk,	/* start blk of last record */
+	struct xlog_rec_header	**rhead,	/* ptr to last record */
+	bool			*wrapped)	/* last rec. wraps phys. log */
+{
+	struct xlog_rec_header	*tmp_rhead;
+	char			*tmp_buffer;
+	xfs_daddr_t		first_bad;
+	xfs_daddr_t		tmp_rhead_blk;
+	int			found;
+	int			error;
+	bool			tmp_wrapped;
+
+	/*
+	 * Check the head of the log for torn writes. Search backwards from the
+	 * head until we hit the tail or the maximum number of log record I/Os
+	 * that could have been in flight at one time. Use a temporary buffer so
+	 * we don't trash the rhead/buffer pointers from the caller.
+	 */
+	tmp_buffer = xlog_alloc_buffer(log, 1);
+	if (!tmp_buffer)
+		return -ENOMEM;
+	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
+				      XLOG_MAX_ICLOGS, tmp_buffer,
+				      &tmp_rhead_blk, &tmp_rhead, &tmp_wrapped);
+	kvfree(tmp_buffer);
+	if (error < 0)
+		return error;
+
+	/*
+	 * Now run a CRC verification pass over the records starting at the
+	 * block found above to the current head. If a CRC failure occurs, the
+	 * log block of the first bad record is saved in first_bad.
+	 */
+	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
+				      XLOG_RECOVER_CRCPASS, &first_bad);
+	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
+		/*
+		 * We've hit a potential torn write. Reset the error and warn
+		 * about it.
+		 */
+		error = 0;
+		xfs_warn(log->l_mp,
+"Torn write (CRC failure) detected at log block 0x%llx. Truncating head block from 0x%llx.",
+			 first_bad, *head_blk);
+
+		/*
+		 * Get the header block and buffer pointer for the last good
+		 * record before the bad record.
+		 *
+		 * Note that xlog_find_tail() clears the blocks at the new head
+		 * (i.e., the records with invalid CRC) if the cycle number
+		 * matches the current cycle.
+		 */
+		found = xlog_rseek_logrec_hdr(log, first_bad, *tail_blk, 1,
+				buffer, rhead_blk, rhead, wrapped);
+		if (found < 0)
+			return found;
+		if (found == 0)		/* XXX: right thing to do here? */
+			return -EIO;
+
+		/*
+		 * Reset the head block to the starting block of the first bad
+		 * log record and set the tail block based on the last good
+		 * record.
+		 *
+		 * Bail out if the updated head/tail match as this indicates
+		 * possible corruption outside of the acceptable
+		 * (XLOG_MAX_ICLOGS) range. This is a job for xfs_repair...
+		 */
+		*head_blk = first_bad;
+		*tail_blk = BLOCK_LSN(be64_to_cpu((*rhead)->h_tail_lsn));
+		if (*head_blk == *tail_blk) {
+			ASSERT(0);
+			return 0;
+		}
+	}
+	if (error)
+		return error;
+
+	return xlog_verify_tail(log, *head_blk, tail_blk,
+				be32_to_cpu((*rhead)->h_size));
+}
+
+/*
+ * We need to make sure we handle log wrapping properly, so we can't use the
+ * calculated logbno directly. Make sure it wraps to the correct bno inside the
+ * log.
+ *
+ * The log is limited to 32 bit sizes, so we use the appropriate modulus
+ * operation here and cast it back to a 64 bit daddr on return.
+ */
+static inline xfs_daddr_t
+xlog_wrap_logbno(
+	struct xlog		*log,
+	xfs_daddr_t		bno)
+{
+	int			mod;
+
+	div_s64_rem(bno, log->l_logBBsize, &mod);
+	return mod;
+}
+
+/*
+ * Check whether the head of the log points to an unmount record. In other
+ * words, determine whether the log is clean. If so, update the in-core state
+ * appropriately.
+ */
+static int
+xlog_check_unmount_rec(
+	struct xlog		*log,
+	xfs_daddr_t		*head_blk,
+	xfs_daddr_t		*tail_blk,
+	struct xlog_rec_header	*rhead,
+	xfs_daddr_t		rhead_blk,
+	char			*buffer,
+	bool			*clean)
+{
+	struct xlog_op_header	*op_head;
+	xfs_daddr_t		umount_data_blk;
+	xfs_daddr_t		after_umount_blk;
+	int			hblks;
+	int			error;
+	char			*offset;
+
+	*clean = false;
+
+	/*
+	 * Look for unmount record. If we find it, then we know there was a
+	 * clean unmount. Since 'i' could be the last block in the physical
+	 * log, we convert to a log block before comparing to the head_blk.
+	 *
+	 * Save the current tail lsn to use to pass to xlog_clear_stale_blocks()
+	 * below. We won't want to clear the unmount record if there is one, so
+	 * we pass the lsn of the unmount record rather than the block after it.
+	 */
+	hblks = xlog_logrec_hblks(log, rhead);
+	after_umount_blk = xlog_wrap_logbno(log,
+			rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len)));
+
+	if (*head_blk == after_umount_blk &&
+	    be32_to_cpu(rhead->h_num_logops) == 1) {
+		umount_data_blk = xlog_wrap_logbno(log, rhead_blk + hblks);
+		error = xlog_bread(log, umount_data_blk, 1, buffer, &offset);
+		if (error)
+			return error;
+
+		op_head = (struct xlog_op_header *)offset;
+		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
+			/*
+			 * Set tail and last sync so that newly written log
+			 * records will point recovery to after the current
+			 * unmount record.
+			 */
+			xlog_assign_atomic_lsn(&log->l_tail_lsn,
+					log->l_curr_cycle, after_umount_blk);
+			log->l_ailp->ail_head_lsn =
+					atomic64_read(&log->l_tail_lsn);
+			*tail_blk = after_umount_blk;
+
+			*clean = true;
+		}
+	}
+
+	return 0;
+}
+
+static void
+xlog_set_state(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	struct xlog_rec_header	*rhead,
+	xfs_daddr_t		rhead_blk,
+	bool			bump_cycle)
+{
+	/*
+	 * Reset log values according to the state of the log when we
+	 * crashed.  In the case where head_blk == 0, we bump curr_cycle
+	 * one because the next write starts a new cycle rather than
+	 * continuing the cycle of the last good log record.  At this
+	 * point we have guaranteed that all partial log records have been
+	 * accounted for.  Therefore, we know that the last good log record
+	 * written was complete and ended exactly on the end boundary
+	 * of the physical log.
+	 */
+	log->l_prev_block = rhead_blk;
+	log->l_curr_block = (int)head_blk;
+	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
+	if (bump_cycle)
+		log->l_curr_cycle++;
+	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
+	log->l_ailp->ail_head_lsn = be64_to_cpu(rhead->h_lsn);
+}
+
+/*
+ * Find the sync block number or the tail of the log.
+ *
+ * This will be the block number of the last record to have its
+ * associated buffers synced to disk.  Every log record header has
+ * a sync lsn embedded in it.  LSNs hold block numbers, so it is easy
+ * to get a sync block number.  The only concern is to figure out which
+ * log record header to believe.
+ *
+ * The following algorithm uses the log record header with the largest
+ * lsn.  The entire log record does not need to be valid.  We only care
+ * that the header is valid.
+ *
+ * We could speed up search by using current head_blk buffer, but it is not
+ * available.
+ */
+STATIC int
+xlog_find_tail(
+	struct xlog		*log,
+	xfs_daddr_t		*head_blk,
+	xfs_daddr_t		*tail_blk)
+{
+	struct xlog_rec_header	*rhead;
+	char			*offset = NULL;
+	char			*buffer;
+	int			error;
+	xfs_daddr_t		rhead_blk;
+	xfs_lsn_t		tail_lsn;
+	bool			wrapped = false;
+	bool			clean = false;
+
+	/*
+	 * Find previous log record
+	 */
+	if ((error = xlog_find_head(log, head_blk)))
+		return error;
+	ASSERT(*head_blk < INT_MAX);
+
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
+		return -ENOMEM;
+	if (*head_blk == 0) {				/* special case */
+		error = xlog_bread(log, 0, 1, buffer, &offset);
+		if (error)
+			goto done;
+
+		if (xlog_get_cycle(offset) == 0) {
+			*tail_blk = 0;
+			/* leave all other log inited values alone */
+			goto done;
+		}
+	}
+
+	/*
+	 * Search backwards through the log looking for the log record header
+	 * block. This wraps all the way back around to the head so something is
+	 * seriously wrong if we can't find it.
+	 */
+	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
+				      &rhead_blk, &rhead, &wrapped);
+	if (error < 0)
+		goto done;
+	if (!error) {
+		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
+		error = -EFSCORRUPTED;
+		goto done;
+	}
+	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
+
+	/*
+	 * Set the log state based on the current head record.
+	 */
+	xlog_set_state(log, *head_blk, rhead, rhead_blk, wrapped);
+	tail_lsn = atomic64_read(&log->l_tail_lsn);
+
+	/*
+	 * Look for an unmount record at the head of the log. This sets the log
+	 * state to determine whether recovery is necessary.
+	 */
+	error = xlog_check_unmount_rec(log, head_blk, tail_blk, rhead,
+				       rhead_blk, buffer, &clean);
+	if (error)
+		goto done;
+
+	/*
+	 * Verify the log head if the log is not clean (e.g., we have anything
+	 * but an unmount record at the head). This uses CRC verification to
+	 * detect and trim torn writes. If discovered, CRC failures are
+	 * considered torn writes and the log head is trimmed accordingly.
+	 *
+	 * Note that we can only run CRC verification when the log is dirty
+	 * because there's no guarantee that the log data behind an unmount
+	 * record is compatible with the current architecture.
+	 */
+	if (!clean) {
+		xfs_daddr_t	orig_head = *head_blk;
+
+		error = xlog_verify_head(log, head_blk, tail_blk, buffer,
+					 &rhead_blk, &rhead, &wrapped);
+		if (error)
+			goto done;
+
+		/* update in-core state again if the head changed */
+		if (*head_blk != orig_head) {
+			xlog_set_state(log, *head_blk, rhead, rhead_blk,
+				       wrapped);
+			tail_lsn = atomic64_read(&log->l_tail_lsn);
+			error = xlog_check_unmount_rec(log, head_blk, tail_blk,
+						       rhead, rhead_blk, buffer,
+						       &clean);
+			if (error)
+				goto done;
+		}
+	}
+
+	/*
+	 * Note that the unmount was clean. If the unmount was not clean, we
+	 * need to know this to rebuild the superblock counters from the perag
+	 * headers if we have a filesystem using non-persistent counters.
+	 */
+	if (clean)
+		xfs_set_clean(log->l_mp);
+
+	/*
+	 * Make sure that there are no blocks in front of the head
+	 * with the same cycle number as the head.  This can happen
+	 * because we allow multiple outstanding log writes concurrently,
+	 * and the later writes might make it out before earlier ones.
+	 *
+	 * We use the lsn from before modifying it so that we'll never
+	 * overwrite the unmount record after a clean unmount.
+	 *
+	 * Do this only if we are going to recover the filesystem
+	 *
+	 * NOTE: This used to say "if (!readonly)"
+	 * However on Linux, we can & do recover a read-only filesystem.
+	 * We only skip recovery if NORECOVERY is specified on mount,
+	 * in which case we would not be here.
+	 *
+	 * But... if the -device- itself is readonly, just skip this.
+	 * We can't recover this device anyway, so it won't matter.
+	 */
+	if (!xfs_readonly_buftarg(log->l_targ))
+		error = xlog_clear_stale_blocks(log, tail_lsn);
+
+done:
+	kvfree(buffer);
+
+	if (error)
+		xfs_warn(log->l_mp, "failed to locate log tail");
+	return error;
+}
+
+/*
+ * Is the log zeroed at all?
+ *
+ * The last binary search should be changed to perform an X block read
+ * once X becomes small enough.  You can then search linearly through
+ * the X blocks.  This will cut down on the number of reads we need to do.
+ *
+ * If the log is partially zeroed, this routine will pass back the blkno
+ * of the first block with cycle number 0.  It won't have a complete LR
+ * preceding it.
+ *
+ * Return:
+ *	0  => the log is completely written to
+ *	1 => use *blk_no as the first block of the log
+ *	<0 => error has occurred
+ */
+STATIC int
+xlog_find_zeroed(
+	struct xlog	*log,
+	xfs_daddr_t	*blk_no)
+{
+	char		*buffer;
+	char		*offset;
+	uint	        first_cycle, last_cycle;
+	xfs_daddr_t	new_blk, last_blk, start_blk;
+	xfs_daddr_t     num_scan_bblks;
+	int	        error, log_bbnum = log->l_logBBsize;
+	int		ret = 1;
+
+	*blk_no = 0;
+
+	/* check totally zeroed log */
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
+		return -ENOMEM;
+	error = xlog_bread(log, 0, 1, buffer, &offset);
+	if (error)
+		goto out_free_buffer;
+
+	first_cycle = xlog_get_cycle(offset);
+	if (first_cycle == 0) {		/* completely zeroed log */
+		*blk_no = 0;
+		goto out_free_buffer;
+	}
+
+	/* check partially zeroed log */
+	error = xlog_bread(log, log_bbnum-1, 1, buffer, &offset);
+	if (error)
+		goto out_free_buffer;
+
+	last_cycle = xlog_get_cycle(offset);
+	if (last_cycle != 0) {		/* log completely written to */
+		ret = 0;
+		goto out_free_buffer;
+	}
+
+	/* we have a partially zeroed log */
+	last_blk = log_bbnum-1;
+	error = xlog_find_cycle_start(log, buffer, 0, &last_blk, 0);
+	if (error)
+		goto out_free_buffer;
+
+	/*
+	 * Validate the answer.  Because there is no way to guarantee that
+	 * the entire log is made up of log records which are the same size,
+	 * we scan over the defined maximum blocks.  At this point, the maximum
+	 * is not chosen to mean anything special.   XXXmiken
+	 */
+	num_scan_bblks = XLOG_TOTAL_REC_SHIFT(log);
+	ASSERT(num_scan_bblks <= INT_MAX);
+
+	if (last_blk < num_scan_bblks)
+		num_scan_bblks = last_blk;
+	start_blk = last_blk - num_scan_bblks;
+
+	/*
+	 * We search for any instances of cycle number 0 that occur before
+	 * our current estimate of the head.  What we're trying to detect is
+	 *        1 ... | 0 | 1 | 0...
+	 *                       ^ binary search ends here
+	 */
+	if ((error = xlog_find_verify_cycle(log, start_blk,
+					 (int)num_scan_bblks, 0, &new_blk)))
+		goto out_free_buffer;
+	if (new_blk != -1)
+		last_blk = new_blk;
+
+	/*
+	 * Potentially backup over partial log record write.  We don't need
+	 * to search the end of the log because we know it is zero.
+	 */
+	error = xlog_find_verify_log_record(log, start_blk, &last_blk, 0);
+	if (error == 1)
+		error = -EIO;
+	if (error)
+		goto out_free_buffer;
+
+	*blk_no = last_blk;
+out_free_buffer:
+	kvfree(buffer);
+	if (error)
+		return error;
+	return ret;
+}
+
+/*
+ * These are simple subroutines used by xlog_clear_stale_blocks() below
+ * to initialize a buffer full of empty log record headers and write
+ * them into the log.
+ */
+STATIC void
+xlog_add_record(
+	struct xlog		*log,
+	char			*buf,
+	int			cycle,
+	int			block,
+	int			tail_cycle,
+	int			tail_block)
+{
+	struct xlog_rec_header	*recp = (struct xlog_rec_header *)buf;
+
+	memset(buf, 0, BBSIZE);
+	recp->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
+	recp->h_cycle = cpu_to_be32(cycle);
+	recp->h_version = cpu_to_be32(
+			xfs_has_logv2(log->l_mp) ? 2 : 1);
+	recp->h_lsn = cpu_to_be64(xlog_assign_lsn(cycle, block));
+	recp->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(tail_cycle, tail_block));
+	recp->h_fmt = cpu_to_be32(XLOG_FMT);
+	memcpy(&recp->h_fs_uuid, &log->l_mp->m_sb.sb_uuid, sizeof(uuid_t));
+}
+
+STATIC int
+xlog_write_log_records(
+	struct xlog	*log,
+	int		cycle,
+	int		start_block,
+	int		blocks,
+	int		tail_cycle,
+	int		tail_block)
+{
+	char		*offset;
+	char		*buffer;
+	int		balign, ealign;
+	int		sectbb = log->l_sectBBsize;
+	int		end_block = start_block + blocks;
+	int		bufblks;
+	int		error = 0;
+	int		i, j = 0;
+
+	/*
+	 * Greedily allocate a buffer big enough to handle the full
+	 * range of basic blocks to be written.  If that fails, try
+	 * a smaller size.  We need to be able to write at least a
+	 * log sector, or we're out of luck.
+	 */
+	bufblks = roundup_pow_of_two(blocks);
+	while (bufblks > log->l_logBBsize)
+		bufblks >>= 1;
+	while (!(buffer = xlog_alloc_buffer(log, bufblks))) {
+		bufblks >>= 1;
+		if (bufblks < sectbb)
+			return -ENOMEM;
+	}
+
+	/* We may need to do a read at the start to fill in part of
+	 * the buffer in the starting sector not covered by the first
+	 * write below.
+	 */
+	balign = round_down(start_block, sectbb);
+	if (balign != start_block) {
+		error = xlog_bread_noalign(log, start_block, 1, buffer);
+		if (error)
+			goto out_free_buffer;
+
+		j = start_block - balign;
+	}
+
+	for (i = start_block; i < end_block; i += bufblks) {
+		int		bcount, endcount;
+
+		bcount = min(bufblks, end_block - start_block);
+		endcount = bcount - j;
+
+		/* We may need to do a read at the end to fill in part of
+		 * the buffer in the final sector not covered by the write.
+		 * If this is the same sector as the above read, skip it.
+		 */
+		ealign = round_down(end_block, sectbb);
+		if (j == 0 && (start_block + endcount > ealign)) {
+			error = xlog_bread_noalign(log, ealign, sectbb,
+					buffer + BBTOB(ealign - start_block));
+			if (error)
+				break;
+
+		}
+
+		offset = buffer + xlog_align(log, start_block);
+		for (; j < endcount; j++) {
+			xlog_add_record(log, offset, cycle, i+j,
+					tail_cycle, tail_block);
+			offset += BBSIZE;
+		}
+		error = xlog_bwrite(log, start_block, endcount, buffer);
+		if (error)
+			break;
+		start_block += endcount;
+		j = 0;
+	}
+
+out_free_buffer:
+	kvfree(buffer);
+	return error;
+}
+
+/*
+ * This routine is called to blow away any incomplete log writes out
+ * in front of the log head.  We do this so that we won't become confused
+ * if we come up, write only a little bit more, and then crash again.
+ * If we leave the partial log records out there, this situation could
+ * cause us to think those partial writes are valid blocks since they
+ * have the current cycle number.  We get rid of them by overwriting them
+ * with empty log records with the old cycle number rather than the
+ * current one.
+ *
+ * The tail lsn is passed in rather than taken from
+ * the log so that we will not write over the unmount record after a
+ * clean unmount in a 512 block log.  Doing so would leave the log without
+ * any valid log records in it until a new one was written.  If we crashed
+ * during that time we would not be able to recover.
+ */
+STATIC int
+xlog_clear_stale_blocks(
+	struct xlog	*log,
+	xfs_lsn_t	tail_lsn)
+{
+	int		tail_cycle, head_cycle;
+	int		tail_block, head_block;
+	int		tail_distance, max_distance;
+	int		distance;
+	int		error;
+
+	tail_cycle = CYCLE_LSN(tail_lsn);
+	tail_block = BLOCK_LSN(tail_lsn);
+	head_cycle = log->l_curr_cycle;
+	head_block = log->l_curr_block;
+
+	/*
+	 * Figure out the distance between the new head of the log
+	 * and the tail.  We want to write over any blocks beyond the
+	 * head that we may have written just before the crash, but
+	 * we don't want to overwrite the tail of the log.
+	 */
+	if (head_cycle == tail_cycle) {
+		/*
+		 * The tail is behind the head in the physical log,
+		 * so the distance from the head to the tail is the
+		 * distance from the head to the end of the log plus
+		 * the distance from the beginning of the log to the
+		 * tail.
+		 */
+		if (XFS_IS_CORRUPT(log->l_mp,
+				   head_block < tail_block ||
+				   head_block >= log->l_logBBsize))
+			return -EFSCORRUPTED;
+		tail_distance = tail_block + (log->l_logBBsize - head_block);
+	} else {
+		/*
+		 * The head is behind the tail in the physical log,
+		 * so the distance from the head to the tail is just
+		 * the tail block minus the head block.
+		 */
+		if (XFS_IS_CORRUPT(log->l_mp,
+				   head_block >= tail_block ||
+				   head_cycle != tail_cycle + 1))
+			return -EFSCORRUPTED;
+		tail_distance = tail_block - head_block;
+	}
+
+	/*
+	 * If the head is right up against the tail, we can't clear
+	 * anything.
+	 */
+	if (tail_distance <= 0) {
+		ASSERT(tail_distance == 0);
+		return 0;
+	}
+
+	max_distance = XLOG_TOTAL_REC_SHIFT(log);
+	/*
+	 * Take the smaller of the maximum amount of outstanding I/O
+	 * we could have and the distance to the tail to clear out.
+	 * We take the smaller so that we don't overwrite the tail and
+	 * we don't waste all day writing from the head to the tail
+	 * for no reason.
+	 */
+	max_distance = min(max_distance, tail_distance);
+
+	if ((head_block + max_distance) <= log->l_logBBsize) {
+		/*
+		 * We can stomp all the blocks we need to without
+		 * wrapping around the end of the log.  Just do it
+		 * in a single write.  Use the cycle number of the
+		 * current cycle minus one so that the log will look like:
+		 *     n ... | n - 1 ...
+		 */
+		error = xlog_write_log_records(log, (head_cycle - 1),
+				head_block, max_distance, tail_cycle,
+				tail_block);
+		if (error)
+			return error;
+	} else {
+		/*
+		 * We need to wrap around the end of the physical log in
+		 * order to clear all the blocks.  Do it in two separate
+		 * I/Os.  The first write should be from the head to the
+		 * end of the physical log, and it should use the current
+		 * cycle number minus one just like above.
+		 */
+		distance = log->l_logBBsize - head_block;
+		error = xlog_write_log_records(log, (head_cycle - 1),
+				head_block, distance, tail_cycle,
+				tail_block);
+
+		if (error)
+			return error;
+
+		/*
+		 * Now write the blocks at the start of the physical log.
+		 * This writes the remainder of the blocks we want to clear.
+		 * It uses the current cycle number since we're now on the
+		 * same cycle as the head so that we get:
+		 *    n ... n ... | n - 1 ...
+		 *    ^^^^^ blocks we're writing
+		 */
+		distance = max_distance - (log->l_logBBsize - head_block);
+		error = xlog_write_log_records(log, head_cycle, 0, distance,
+				tail_cycle, tail_block);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Release the recovered intent item in the AIL that matches the given intent
+ * type and intent id.
+ */
+void
+xlog_recover_release_intent(
+	struct xlog			*log,
+	unsigned short			intent_type,
+	uint64_t			intent_id)
+{
+	struct xfs_defer_pending	*dfp, *n;
+
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
+
+		if (lip->li_type != intent_type)
+			continue;
+		if (!lip->li_ops->iop_match(lip, intent_id))
+			continue;
+
+		ASSERT(xlog_item_is_intent(lip));
+
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
+}
+
+int
+xlog_recover_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	**ipp)
+{
+	int			error;
+
+	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	if (error)
+		return error;
+
+	error = xfs_qm_dqattach(*ipp);
+	if (error) {
+		xfs_irele(*ipp);
+		return error;
+	}
+
+	if (VFS_I(*ipp)->i_nlink == 0)
+		xfs_iflags_set(*ipp, XFS_IRECOVERY);
+
+	return 0;
+}
+
+/*
+ * Get an inode so that we can recover a log operation.
+ *
+ * Log intent items that target inodes effectively contain a file handle.
+ * Check that the generation number matches the intent item like we do for
+ * other file handles.  Log intent items defined after this validation weakness
+ * was identified must use this function.
+ */
+int
+xlog_recover_iget_handle(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	uint32_t		gen,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = xlog_recover_iget(mp, ino, &ip);
+	if (error)
+		return error;
+
+	if (VFS_I(ip)->i_generation != gen) {
+		xfs_irele(ip);
+		return -EFSCORRUPTED;
+	}
+
+	*ipp = ip;
+	return 0;
+}
+
+/******************************************************************************
+ *
+ *		Log recover routines
+ *
+ ******************************************************************************
+ */
+static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
+	&xlog_buf_item_ops,
+	&xlog_inode_item_ops,
+	&xlog_dquot_item_ops,
+	&xlog_quotaoff_item_ops,
+	&xlog_icreate_item_ops,
+	&xlog_efi_item_ops,
+	&xlog_efd_item_ops,
+	&xlog_rui_item_ops,
+	&xlog_rud_item_ops,
+	&xlog_cui_item_ops,
+	&xlog_cud_item_ops,
+	&xlog_bui_item_ops,
+	&xlog_bud_item_ops,
+	&xlog_attri_item_ops,
+	&xlog_attrd_item_ops,
+	&xlog_xmi_item_ops,
+	&xlog_xmd_item_ops,
+	&xlog_rtefi_item_ops,
+	&xlog_rtefd_item_ops,
+	&xlog_rtrui_item_ops,
+	&xlog_rtrud_item_ops,
+	&xlog_rtcui_item_ops,
+	&xlog_rtcud_item_ops,
+};
+
+static const struct xlog_recover_item_ops *
+xlog_find_item_ops(
+	struct xlog_recover_item		*item)
+{
+	unsigned int				i;
+
+	for (i = 0; i < ARRAY_SIZE(xlog_recover_item_ops); i++)
+		if (ITEM_TYPE(item) == xlog_recover_item_ops[i]->item_type)
+			return xlog_recover_item_ops[i];
+
+	return NULL;
+}
+
+/*
+ * Sort the log items in the transaction.
+ *
+ * The ordering constraints are defined by the inode allocation and unlink
+ * behaviour. The rules are:
+ *
+ *	1. Every item is only logged once in a given transaction. Hence it
+ *	   represents the last logged state of the item. Hence ordering is
+ *	   dependent on the order in which operations need to be performed so
+ *	   required initial conditions are always met.
+ *
+ *	2. Cancelled buffers are recorded in pass 1 in a separate table and
+ *	   there's nothing to replay from them so we can simply cull them
+ *	   from the transaction. However, we can't do that until after we've
+ *	   replayed all the other items because they may be dependent on the
+ *	   cancelled buffer and replaying the cancelled buffer can remove it
+ *	   form the cancelled buffer table. Hence they have to be done last.
+ *
+ *	3. Inode allocation buffers must be replayed before inode items that
+ *	   read the buffer and replay changes into it. For filesystems using the
+ *	   ICREATE transactions, this means XFS_LI_ICREATE objects need to get
+ *	   treated the same as inode allocation buffers as they create and
+ *	   initialise the buffers directly.
+ *
+ *	4. Inode unlink buffers must be replayed after inode items are replayed.
+ *	   This ensures that inodes are completely flushed to the inode buffer
+ *	   in a "free" state before we remove the unlinked inode list pointer.
+ *
+ * Hence the ordering needs to be inode allocation buffers first, inode items
+ * second, inode unlink buffers third and cancelled buffers last.
+ *
+ * But there's a problem with that - we can't tell an inode allocation buffer
+ * apart from a regular buffer, so we can't separate them. We can, however,
+ * tell an inode unlink buffer from the others, and so we can separate them out
+ * from all the other buffers and move them to last.
+ *
+ * Hence, 4 lists, in order from head to tail:
+ *	- buffer_list for all buffers except cancelled/inode unlink buffers
+ *	- item_list for all non-buffer items
+ *	- inode_buffer_list for inode unlink buffers
+ *	- cancel_list for the cancelled buffers
+ *
+ * Note that we add objects to the tail of the lists so that first-to-last
+ * ordering is preserved within the lists. Adding objects to the head of the
+ * list means when we traverse from the head we walk them in last-to-first
+ * order. For cancelled buffers and inode unlink buffers this doesn't matter,
+ * but for all other items there may be specific ordering that we need to
+ * preserve.
+ */
+STATIC int
+xlog_recover_reorder_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	int			pass)
+{
+	struct xlog_recover_item *item, *n;
+	int			error = 0;
+	LIST_HEAD(sort_list);
+	LIST_HEAD(cancel_list);
+	LIST_HEAD(buffer_list);
+	LIST_HEAD(inode_buffer_list);
+	LIST_HEAD(item_list);
+
+	list_splice_init(&trans->r_itemq, &sort_list);
+	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
+		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
+
+		item->ri_ops = xlog_find_item_ops(item);
+		if (!item->ri_ops) {
+			xfs_warn(log->l_mp,
+				"%s: unrecognized type of log operation (%d)",
+				__func__, ITEM_TYPE(item));
+			ASSERT(0);
+			/*
+			 * return the remaining items back to the transaction
+			 * item list so they can be freed in caller.
+			 */
+			if (!list_empty(&sort_list))
+				list_splice_init(&sort_list, &trans->r_itemq);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		if (item->ri_ops->reorder)
+			fate = item->ri_ops->reorder(item);
+
+		switch (fate) {
+		case XLOG_REORDER_BUFFER_LIST:
+			list_move_tail(&item->ri_list, &buffer_list);
+			break;
+		case XLOG_REORDER_CANCEL_LIST:
+			trace_xfs_log_recover_item_reorder_head(log,
+					trans, item, pass);
+			list_move(&item->ri_list, &cancel_list);
+			break;
+		case XLOG_REORDER_INODE_BUFFER_LIST:
+			list_move(&item->ri_list, &inode_buffer_list);
+			break;
+		case XLOG_REORDER_ITEM_LIST:
+			trace_xfs_log_recover_item_reorder_tail(log,
+							trans, item, pass);
+			list_move_tail(&item->ri_list, &item_list);
+			break;
+		}
+	}
+
+	ASSERT(list_empty(&sort_list));
+	if (!list_empty(&buffer_list))
+		list_splice(&buffer_list, &trans->r_itemq);
+	if (!list_empty(&item_list))
+		list_splice_tail(&item_list, &trans->r_itemq);
+	if (!list_empty(&inode_buffer_list))
+		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
+	if (!list_empty(&cancel_list))
+		list_splice_tail(&cancel_list, &trans->r_itemq);
+	return error;
+}
+
+void
+xlog_buf_readahead(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len,
+	const struct xfs_buf_ops *ops)
+{
+	if (!xlog_is_buffer_cancelled(log, blkno, len))
+		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
+}
+
+/*
+ * Create a deferred work structure for resuming and tracking the progress of a
+ * log intent item that was found during recovery.
+ */
+void
+xlog_recover_intent_item(
+	struct xlog			*log,
+	struct xfs_log_item		*lip,
+	xfs_lsn_t			lsn,
+	const struct xfs_defer_op_type	*ops)
+{
+	ASSERT(xlog_item_is_intent(lip));
+
+	xfs_defer_start_recovery(lip, &log->r_dfops, ops);
+
+	/*
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
+	 */
+	xfs_trans_ail_insert(log->l_ailp, lip, lsn);
+	lip->li_ops->iop_unpin(lip, 0);
+}
+
+STATIC int
+xlog_recover_items_pass2(
+	struct xlog                     *log,
+	struct xlog_recover             *trans,
+	struct list_head                *buffer_list,
+	struct list_head                *item_list)
+{
+	struct xlog_recover_item	*item;
+	int				error = 0;
+
+	list_for_each_entry(item, item_list, ri_list) {
+		trace_xfs_log_recover_item_recover(log, trans, item,
+				XLOG_RECOVER_PASS2);
+
+		if (item->ri_ops->commit_pass2)
+			error = item->ri_ops->commit_pass2(log, buffer_list,
+					item, trans->r_lsn);
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
+/*
+ * Perform the transaction.
+ *
+ * If the transaction modifies a buffer or inode, do it now.  Otherwise,
+ * EFIs and EFDs get queued up by adding entries into the AIL for them.
+ */
+STATIC int
+xlog_recover_commit_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	int			pass,
+	struct list_head	*buffer_list)
+{
+	int				error = 0;
+	int				items_queued = 0;
+	struct xlog_recover_item	*item;
+	struct xlog_recover_item	*next;
+	LIST_HEAD			(ra_list);
+	LIST_HEAD			(done_list);
+
+	#define XLOG_RECOVER_COMMIT_QUEUE_MAX 100
+
+	hlist_del_init(&trans->r_list);
+
+	error = xlog_recover_reorder_trans(log, trans, pass);
+	if (error)
+		return error;
+
+	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
+		trace_xfs_log_recover_item_recover(log, trans, item, pass);
+
+		switch (pass) {
+		case XLOG_RECOVER_PASS1:
+			if (item->ri_ops->commit_pass1)
+				error = item->ri_ops->commit_pass1(log, item);
+			break;
+		case XLOG_RECOVER_PASS2:
+			if (item->ri_ops->ra_pass2)
+				item->ri_ops->ra_pass2(log, item);
+			list_move_tail(&item->ri_list, &ra_list);
+			items_queued++;
+			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {
+				error = xlog_recover_items_pass2(log, trans,
+						buffer_list, &ra_list);
+				list_splice_tail_init(&ra_list, &done_list);
+				items_queued = 0;
+			}
+
+			break;
+		default:
+			ASSERT(0);
+		}
+
+		if (error)
+			goto out;
+	}
+
+out:
+	if (!list_empty(&ra_list)) {
+		if (!error)
+			error = xlog_recover_items_pass2(log, trans,
+					buffer_list, &ra_list);
+		list_splice_tail_init(&ra_list, &done_list);
+	}
+
+	if (!list_empty(&done_list))
+		list_splice_init(&done_list, &trans->r_itemq);
+
+	return error;
+}
+
+STATIC void
+xlog_recover_add_item(
+	struct list_head	*head)
+{
+	struct xlog_recover_item *item;
+
+	item = kzalloc_obj(struct xlog_recover_item, GFP_KERNEL | __GFP_NOFAIL);
+	INIT_LIST_HEAD(&item->ri_list);
+	list_add_tail(&item->ri_list, head);
+}
+
+STATIC int
+xlog_recover_add_to_cont_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	char			*dp,
+	int			len)
+{
+	struct xlog_recover_item *item;
+	char			*ptr, *old_ptr;
+	int			old_len;
+
+	/*
+	 * If the transaction is empty, the header was split across this and the
+	 * previous record. Copy the rest of the header.
+	 */
+	if (list_empty(&trans->r_itemq)) {
+		ASSERT(len <= sizeof(struct xfs_trans_header));
+		if (len > sizeof(struct xfs_trans_header)) {
+			xfs_warn(log->l_mp, "%s: bad header length", __func__);
+			return -EFSCORRUPTED;
+		}
+
+		xlog_recover_add_item(&trans->r_itemq);
+		ptr = (char *)&trans->r_theader +
+				sizeof(struct xfs_trans_header) - len;
+		memcpy(ptr, dp, len);
+		return 0;
+	}
+
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
+			  ri_list);
+
+	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
+	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
+
+	ptr = kvrealloc(old_ptr, len + old_len, GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+	memcpy(&ptr[old_len], dp, len);
+	item->ri_buf[item->ri_cnt-1].iov_len += len;
+	item->ri_buf[item->ri_cnt-1].iov_base = ptr;
+	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
+	return 0;
+}
+
+/*
+ * The next region to add is the start of a new region.  It could be
+ * a whole region or it could be the first part of a new region.  Because
+ * of this, the assumption here is that the type and size fields of all
+ * format structures fit into the first 32 bits of the structure.
+ *
+ * This works because all regions must be 32 bit aligned.  Therefore, we
+ * either have both fields or we have neither field.  In the case we have
+ * neither field, the data part of the region is zero length.  We only have
+ * a log_op_header and can throw away the header since a new one will appear
+ * later.  If we have at least 4 bytes, then we can determine how many regions
+ * will appear in the current log item.
+ */
+STATIC int
+xlog_recover_add_to_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	char			*dp,
+	int			len)
+{
+	struct xfs_inode_log_format	*in_f;			/* any will do */
+	struct xlog_recover_item *item;
+	char			*ptr;
+
+	if (!len)
+		return 0;
+	if (list_empty(&trans->r_itemq)) {
+		/* we need to catch log corruptions here */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xfs_warn(log->l_mp, "%s: bad header magic number",
+				__func__);
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		if (len > sizeof(struct xfs_trans_header)) {
+			xfs_warn(log->l_mp, "%s: bad header length", __func__);
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		/*
+		 * The transaction header can be arbitrarily split across op
+		 * records. If we don't have the whole thing here, copy what we
+		 * do have and handle the rest in the next record.
+		 */
+		if (len == sizeof(struct xfs_trans_header))
+			xlog_recover_add_item(&trans->r_itemq);
+		memcpy(&trans->r_theader, dp, len);
+		return 0;
+	}
+
+	ptr = xlog_kvmalloc(len);
+	memcpy(ptr, dp, len);
+	in_f = (struct xfs_inode_log_format *)ptr;
+
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
+			  ri_list);
+	if (item->ri_total != 0 &&
+	     item->ri_total == item->ri_cnt) {
+		/* tail item is in use, get a new one */
+		xlog_recover_add_item(&trans->r_itemq);
+		item = list_entry(trans->r_itemq.prev,
+					struct xlog_recover_item, ri_list);
+	}
+
+	if (item->ri_total == 0) {		/* first region to be added */
+		if (in_f->ilf_size == 0 ||
+		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
+			xfs_warn(log->l_mp,
+		"bad number of regions (%d) in inode log format",
+				  in_f->ilf_size);
+			ASSERT(0);
+			kvfree(ptr);
+			return -EFSCORRUPTED;
+		}
+
+		item->ri_total = in_f->ilf_size;
+		item->ri_buf = kzalloc_objs(*item->ri_buf, item->ri_total,
+					    GFP_KERNEL | __GFP_NOFAIL);
+	}
+
+	if (item->ri_total <= item->ri_cnt) {
+		xfs_warn(log->l_mp,
+	"log item region count (%d) overflowed size (%d)",
+				item->ri_cnt, item->ri_total);
+		ASSERT(0);
+		kvfree(ptr);
+		return -EFSCORRUPTED;
+	}
+
+	/* Description region is ri_buf[0] */
+	item->ri_buf[item->ri_cnt].iov_base = ptr;
+	item->ri_buf[item->ri_cnt].iov_len  = len;
+	item->ri_cnt++;
+	trace_xfs_log_recover_item_add(log, trans, item, 0);
+	return 0;
+}
+
+/*
+ * Free up any resources allocated by the transaction
+ *
+ * Remember that EFIs, EFDs, and IUNLINKs are handled later.
+ */
+STATIC void
+xlog_recover_free_trans(
+	struct xlog_recover	*trans)
+{
+	struct xlog_recover_item *item, *n;
+	int			i;
+
+	hlist_del_init(&trans->r_list);
+
+	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
+		/* Free the regions in the item. */
+		list_del(&item->ri_list);
+		for (i = 0; i < item->ri_cnt; i++)
+			kvfree(item->ri_buf[i].iov_base);
+		/* Free the item itself */
+		kfree(item->ri_buf);
+		kfree(item);
+	}
+	/* Free the transaction recover structure */
+	kfree(trans);
+}
+
+/*
+ * On error or completion, trans is freed.
+ */
+STATIC int
+xlog_recovery_process_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	char			*dp,
+	unsigned int		len,
+	unsigned int		flags,
+	int			pass,
+	struct list_head	*buffer_list)
+{
+	int			error = 0;
+	bool			freeit = false;
+
+	/* mask off ophdr transaction container flags */
+	flags &= ~XLOG_END_TRANS;
+	if (flags & XLOG_WAS_CONT_TRANS)
+		flags &= ~XLOG_CONTINUE_TRANS;
+
+	/*
+	 * Callees must not free the trans structure. We'll decide if we need to
+	 * free it or not based on the operation being done and it's result.
+	 */
+	switch (flags) {
+	/* expected flag values */
+	case 0:
+	case XLOG_CONTINUE_TRANS:
+		error = xlog_recover_add_to_trans(log, trans, dp, len);
+		break;
+	case XLOG_WAS_CONT_TRANS:
+		error = xlog_recover_add_to_cont_trans(log, trans, dp, len);
+		break;
+	case XLOG_COMMIT_TRANS:
+		error = xlog_recover_commit_trans(log, trans, pass,
+						  buffer_list);
+		/* success or fail, we are now done with this transaction. */
+		freeit = true;
+		break;
+
+	/* unexpected flag values */
+	case XLOG_UNMOUNT_TRANS:
+		/* just skip trans */
+		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
+		freeit = true;
+		break;
+	case XLOG_START_TRANS:
+	default:
+		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		break;
+	}
+	if (error || freeit)
+		xlog_recover_free_trans(trans);
+	return error;
+}
+
+/*
+ * Lookup the transaction recovery structure associated with the ID in the
+ * current ophdr. If the transaction doesn't exist and the start flag is set in
+ * the ophdr, then allocate a new transaction for future ID matches to find.
+ * Either way, return what we found during the lookup - an existing transaction
+ * or nothing.
+ */
+STATIC struct xlog_recover *
+xlog_recover_ophdr_to_trans(
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	struct xlog_op_header	*ohead)
+{
+	struct xlog_recover	*trans;
+	xlog_tid_t		tid;
+	struct hlist_head	*rhp;
+
+	tid = be32_to_cpu(ohead->oh_tid);
+	rhp = &rhash[XLOG_RHASH(tid)];
+	hlist_for_each_entry(trans, rhp, r_list) {
+		if (trans->r_log_tid == tid)
+			return trans;
+	}
+
+	/*
+	 * skip over non-start transaction headers - we could be
+	 * processing slack space before the next transaction starts
+	 */
+	if (!(ohead->oh_flags & XLOG_START_TRANS))
+		return NULL;
+
+	ASSERT(be32_to_cpu(ohead->oh_len) == 0);
+
+	/*
+	 * This is a new transaction so allocate a new recovery container to
+	 * hold the recovery ops that will follow.
+	 */
+	trans = kzalloc_obj(struct xlog_recover, GFP_KERNEL | __GFP_NOFAIL);
+	trans->r_log_tid = tid;
+	trans->r_lsn = be64_to_cpu(rhead->h_lsn);
+	INIT_LIST_HEAD(&trans->r_itemq);
+	INIT_HLIST_NODE(&trans->r_list);
+	hlist_add_head(&trans->r_list, rhp);
+
+	/*
+	 * Nothing more to do for this ophdr. Items to be added to this new
+	 * transaction will be in subsequent ophdr containers.
+	 */
+	return NULL;
+}
+
+STATIC int
+xlog_recover_process_ophdr(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	struct xlog_op_header	*ohead,
+	char			*dp,
+	char			*end,
+	int			pass,
+	struct list_head	*buffer_list)
+{
+	struct xlog_recover	*trans;
+	unsigned int		len;
+	int			error;
+
+	/* Do we understand who wrote this op? */
+	if (ohead->oh_clientid != XFS_TRANSACTION &&
+	    ohead->oh_clientid != XFS_LOG) {
+		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
+			__func__, ohead->oh_clientid);
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Check the ophdr contains all the data it is supposed to contain.
+	 */
+	len = be32_to_cpu(ohead->oh_len);
+	if (dp + len > end) {
+		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
+		WARN_ON(1);
+		return -EFSCORRUPTED;
+	}
+
+	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
+	if (!trans) {
+		/* nothing to do, so skip over this ophdr */
+		return 0;
+	}
+
+	/*
+	 * The recovered buffer queue is drained only once we know that all
+	 * recovery items for the current LSN have been processed. This is
+	 * required because:
+	 *
+	 * - Buffer write submission updates the metadata LSN of the buffer.
+	 * - Log recovery skips items with a metadata LSN >= the current LSN of
+	 *   the recovery item.
+	 * - Separate recovery items against the same metadata buffer can share
+	 *   a current LSN. I.e., consider that the LSN of a recovery item is
+	 *   defined as the starting LSN of the first record in which its
+	 *   transaction appears, that a record can hold multiple transactions,
+	 *   and/or that a transaction can span multiple records.
+	 *
+	 * In other words, we are allowed to submit a buffer from log recovery
+	 * once per current LSN. Otherwise, we may incorrectly skip recovery
+	 * items and cause corruption.
+	 *
+	 * We don't know up front whether buffers are updated multiple times per
+	 * LSN. Therefore, track the current LSN of each commit log record as it
+	 * is processed and drain the queue when it changes. Use commit records
+	 * because they are ordered correctly by the logging code.
+	 */
+	if (log->l_recovery_lsn != trans->r_lsn &&
+	    ohead->oh_flags & XLOG_COMMIT_TRANS) {
+		error = xfs_buf_delwri_submit(buffer_list);
+		if (error)
+			return error;
+		log->l_recovery_lsn = trans->r_lsn;
+	}
+
+	return xlog_recovery_process_trans(log, trans, dp, len,
+					   ohead->oh_flags, pass, buffer_list);
+}
+
+/*
+ * There are two valid states of the r_state field.  0 indicates that the
+ * transaction structure is in a normal state.  We have either seen the
+ * start of the transaction or the last operation we added was not a partial
+ * operation.  If the last operation we added to the transaction was a
+ * partial operation, we need to mark r_state with XLOG_WAS_CONT_TRANS.
+ *
+ * NOTE: skip LRs with 0 data length.
+ */
+STATIC int
+xlog_recover_process_data(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	char			*dp,
+	int			pass,
+	struct list_head	*buffer_list)
+{
+	struct xlog_op_header	*ohead;
+	char			*end;
+	int			num_logops;
+	int			error;
+
+	end = dp + be32_to_cpu(rhead->h_len);
+	num_logops = be32_to_cpu(rhead->h_num_logops);
+
+	/* check the log format matches our own - else we can't recover */
+	if (xlog_header_check_recover(log->l_mp, rhead))
+		return -EIO;
+
+	trace_xfs_log_recover_record(log, rhead, pass);
+	while ((dp < end) && num_logops) {
+
+		ohead = (struct xlog_op_header *)dp;
+		dp += sizeof(*ohead);
+		if (dp > end) {
+			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+			return -EFSCORRUPTED;
+		}
+
+		/* errors will abort recovery */
+		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
+						   dp, end, pass, buffer_list);
+		if (error)
+			return error;
+
+		dp += be32_to_cpu(ohead->oh_len);
+		num_logops--;
+	}
+	return 0;
+}
+
+/* Take all the collected deferred ops and finish them in order. */
+static int
+xlog_finish_defer_ops(
+	struct xfs_mount	*mp,
+	struct list_head	*capture_list)
+{
+	struct xfs_defer_capture *dfc, *next;
+	struct xfs_trans	*tp;
+	int			error = 0;
+
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		struct xfs_trans_res	resv;
+		struct xfs_defer_resources dres;
+
+		/*
+		 * Create a new transaction reservation from the captured
+		 * information.  Set logcount to 1 to force the new transaction
+		 * to regrant every roll so that we can make forward progress
+		 * in recovery no matter how full the log might be.
+		 */
+		resv.tr_logres = dfc->dfc_logres;
+		resv.tr_logcount = 1;
+		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
+		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
+				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
+		if (error) {
+			xlog_force_shutdown(mp->m_log, SHUTDOWN_LOG_IO_ERROR);
+			return error;
+		}
+
+		/*
+		 * Transfer to this new transaction all the dfops we captured
+		 * from recovering a single intent item.
+		 */
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_continue(dfc, tp, &dres);
+		error = xfs_trans_commit(tp);
+		xfs_defer_resources_rele(&dres);
+		if (error)
+			return error;
+	}
+
+	ASSERT(list_empty(capture_list));
+	return 0;
+}
+
+/* Release all the captured defer ops and capture structures in this list. */
+static void
+xlog_abort_defer_ops(
+	struct xfs_mount		*mp,
+	struct list_head		*capture_list)
+{
+	struct xfs_defer_capture	*dfc;
+	struct xfs_defer_capture	*next;
+
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_capture_abort(mp, dfc);
+	}
+}
+
+/*
+ * When this is called, all of the log intent items which did not have
+ * corresponding log done items should be in the AIL.  What we do now is update
+ * the data structures associated with each one.
+ *
+ * Since we process the log intent items in normal transactions, they will be
+ * removed at some point after the commit.  This prevents us from just walking
+ * down the list processing each one.  We'll use a flag in the intent item to
+ * skip those that we've already processed and use the AIL iteration mechanism's
+ * generation count to try to speed this up at least a bit.
+ *
+ * When we start, we know that the intents are the only things in the AIL. As we
+ * process them, however, other items are added to the AIL. Hence we know we
+ * have started recovery on all the pending intents when we find an non-intent
+ * item in the AIL.
+ */
+STATIC int
+xlog_recover_process_intents(
+	struct xlog			*log)
+{
+	LIST_HEAD(capture_list);
+	struct xfs_defer_pending	*dfp, *n;
+	int				error = 0;
+#if defined(DEBUG) || defined(XFS_WARN)
+	xfs_lsn_t			last_lsn;
+
+	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
+#endif
+
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		ASSERT(xlog_item_is_intent(dfp->dfp_intent));
+
+		/*
+		 * We should never see a redo item with a LSN higher than
+		 * the last transaction we found in the log at the start
+		 * of recovery.
+		 */
+		ASSERT(XFS_LSN_CMP(last_lsn, dfp->dfp_intent->li_lsn) >= 0);
+
+		/*
+		 * NOTE: If your intent processing routine can create more
+		 * deferred ops, you /must/ attach them to the capture list in
+		 * the recover routine or else those subsequent intents will be
+		 * replayed in the wrong order!
+		 *
+		 * The recovery function can free the log item, so we must not
+		 * access dfp->dfp_intent after it returns.  It must dispose of
+		 * @dfp if it returns 0.
+		 */
+		error = xfs_defer_finish_recovery(log->l_mp, dfp,
+				&capture_list);
+		if (error)
+			break;
+	}
+	if (error)
+		goto err;
+
+	error = xlog_finish_defer_ops(log->l_mp, &capture_list);
+	if (error)
+		goto err;
+
+	return 0;
+err:
+	xlog_abort_defer_ops(log->l_mp, &capture_list);
+	return error;
+}
+
+/*
+ * A cancel occurs when the mount has failed and we're bailing out.  Release all
+ * pending log intent items that we haven't started recovery on so they don't
+ * pin the AIL.
+ */
+STATIC void
+xlog_recover_cancel_intents(
+	struct xlog			*log)
+{
+	struct xfs_defer_pending	*dfp, *n;
+
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		ASSERT(xlog_item_is_intent(dfp->dfp_intent));
+
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
+}
+
+/*
+ * Transfer ownership of the recovered pending work to the recovery transaction
+ * and try to finish the work.  If there is more work to be done, the dfp will
+ * remain attached to the transaction.  If not, the dfp is freed.
+ */
+int
+xlog_recover_finish_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	int				error;
+
+	list_move(&dfp->dfp_list, &tp->t_dfops);
+	error = xfs_defer_finish_one(tp, dfp);
+	if (error == -EAGAIN)
+		return 0;
+	return error;
+}
+
+/*
+ * This routine performs a transaction to null out a bad inode pointer
+ * in an agi unlinked inode hash bucket.
+ */
+STATIC void
+xlog_recover_clear_agi_bucket(
+	struct xfs_perag	*pag,
+	int			bucket)
+{
+	struct xfs_mount	*mp = pag_mount(pag);
+	struct xfs_trans	*tp;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	int			offset;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
+	if (error)
+		goto out_error;
+
+	error = xfs_read_agi(pag, tp, 0, &agibp);
+	if (error)
+		goto out_abort;
+
+	agi = agibp->b_addr;
+	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+	offset = offsetof(xfs_agi_t, agi_unlinked) +
+		 (sizeof(xfs_agino_t) * bucket);
+	xfs_trans_log_buf(tp, agibp, offset,
+			  (offset + sizeof(xfs_agino_t) - 1));
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return;
+
+out_abort:
+	xfs_trans_cancel(tp);
+out_error:
+	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__,
+			pag_agno(pag));
+	return;
+}
+
+static int
+xlog_recover_iunlink_bucket(
+	struct xfs_perag	*pag,
+	struct xfs_agi		*agi,
+	int			bucket)
+{
+	struct xfs_mount	*mp = pag_mount(pag);
+	struct xfs_inode	*prev_ip = NULL;
+	struct xfs_inode	*ip;
+	xfs_agino_t		prev_agino, agino;
+	int			error = 0;
+
+	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+	while (agino != NULLAGINO) {
+		error = xfs_iget(mp, NULL, xfs_agino_to_ino(pag, agino), 0, 0,
+				&ip);
+		if (error)
+			break;
+
+		ASSERT(VFS_I(ip)->i_nlink == 0);
+		ASSERT(VFS_I(ip)->i_mode != 0);
+		xfs_iflags_clear(ip, XFS_IRECOVERY);
+		agino = ip->i_next_unlinked;
+
+		if (prev_ip) {
+			ip->i_prev_unlinked = prev_agino;
+			xfs_irele(prev_ip);
+
+			/*
+			 * Ensure the inode is removed from the unlinked list
+			 * before we continue so that it won't race with
+			 * building the in-memory list here. This could be
+			 * serialised with the agibp lock, but that just
+			 * serialises via lockstepping and it's much simpler
+			 * just to flush the inodegc queue and wait for it to
+			 * complete.
+			 */
+			error = xfs_inodegc_flush(mp);
+			if (error)
+				break;
+		}
+
+		prev_agino = agino;
+		prev_ip = ip;
+	}
+
+	if (prev_ip) {
+		int	error2;
+
+		ip->i_prev_unlinked = prev_agino;
+		xfs_irele(prev_ip);
+
+		error2 = xfs_inodegc_flush(mp);
+		if (error2 && !error)
+			return error2;
+	}
+	return error;
+}
+
+/*
+ * Recover AGI unlinked lists
+ *
+ * This is called during recovery to process any inodes which we unlinked but
+ * not freed when the system crashed.  These inodes will be on the lists in the
+ * AGI blocks. What we do here is scan all the AGIs and fully truncate and free
+ * any inodes found on the lists. Each inode is removed from the lists when it
+ * has been fully truncated and is freed. The freeing of the inode and its
+ * removal from the list must be atomic.
+ *
+ * If everything we touch in the agi processing loop is already in memory, this
+ * loop can hold the cpu for a long time. It runs without lock contention,
+ * memory allocation contention, the need wait for IO, etc, and so will run
+ * until we either run out of inodes to process, run low on memory or we run out
+ * of log space.
+ *
+ * This behaviour is bad for latency on single CPU and non-preemptible kernels,
+ * and can prevent other filesystem work (such as CIL pushes) from running. This
+ * can lead to deadlocks if the recovery process runs out of log reservation
+ * space. Hence we need to yield the CPU when there is other kernel work
+ * scheduled on this CPU to ensure other scheduled work can run without undue
+ * latency.
+ */
+static void
+xlog_recover_iunlink_ag(
+	struct xfs_perag	*pag)
+{
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	int			bucket;
+	int			error;
+
+	error = xfs_read_agi(pag, NULL, 0, &agibp);
+	if (error) {
+		/*
+		 * AGI is b0rked. Don't process it.
+		 *
+		 * We should probably mark the filesystem as corrupt after we've
+		 * recovered all the ag's we can....
+		 */
+		return;
+	}
+
+	/*
+	 * Unlock the buffer so that it can be acquired in the normal course of
+	 * the transaction to truncate and free each inode.  Because we are not
+	 * racing with anyone else here for the AGI buffer, we don't even need
+	 * to hold it locked to read the initial unlinked bucket entries out of
+	 * the buffer. We keep buffer reference though, so that it stays pinned
+	 * in memory while we need the buffer.
+	 */
+	agi = agibp->b_addr;
+	xfs_buf_unlock(agibp);
+
+	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
+		error = xlog_recover_iunlink_bucket(pag, agi, bucket);
+		if (error) {
+			/*
+			 * Bucket is unrecoverable, so only a repair scan can
+			 * free the remaining unlinked inodes. Just empty the
+			 * bucket and remaining inodes on it unreferenced and
+			 * unfreeable.
+			 */
+			xlog_recover_clear_agi_bucket(pag, bucket);
+		}
+	}
+
+	xfs_buf_rele(agibp);
+}
+
+static void
+xlog_recover_process_iunlinks(
+	struct xlog	*log)
+{
+	struct xfs_perag	*pag = NULL;
+
+	while ((pag = xfs_perag_next(log->l_mp, pag)))
+		xlog_recover_iunlink_ag(pag);
+}
+
+STATIC void
+xlog_unpack_data(
+	struct xlog_rec_header	*rhead,
+	char			*dp,
+	struct xlog		*log)
+{
+	int			i;
+
+	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
+		*(__be32 *)dp = *xlog_cycle_data(rhead, i);
+		dp += BBSIZE;
+	}
+}
+
+/*
+ * CRC check, unpack and process a log record.
+ */
+STATIC int
+xlog_recover_process(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	char			*dp,
+	int			pass,
+	struct list_head	*buffer_list)
+{
+	__le32			expected_crc = rhead->h_crc, crc, other_crc;
+
+	crc = xlog_cksum(log, rhead, dp, XLOG_REC_SIZE,
+			be32_to_cpu(rhead->h_len));
+
+	/*
+	 * Look at the end of the struct xlog_rec_header definition in
+	 * xfs_log_format.h for the glory details.
+	 */
+	if (expected_crc && crc != expected_crc) {
+		other_crc = xlog_cksum(log, rhead, dp, XLOG_REC_SIZE_OTHER,
+				be32_to_cpu(rhead->h_len));
+		if (other_crc == expected_crc) {
+			xfs_notice_once(log->l_mp,
+	"Fixing up incorrect CRC due to padding.");
+			crc = other_crc;
+		}
+	}
+
+	/*
+	 * Nothing else to do if this is a CRC verification pass. Just return
+	 * if this a record with a non-zero crc. Unfortunately, mkfs always
+	 * sets expected_crc to 0 so we must consider this valid even on v5
+	 * supers.  Otherwise, return EFSBADCRC on failure so the callers up the
+	 * stack know precisely what failed.
+	 */
+	if (pass == XLOG_RECOVER_CRCPASS) {
+		if (expected_crc && crc != expected_crc)
+			return -EFSBADCRC;
+		return 0;
+	}
+
+	/*
+	 * We're in the normal recovery path. Issue a warning if and only if the
+	 * CRC in the header is non-zero. This is an advisory warning and the
+	 * zero CRC check prevents warnings from being emitted when upgrading
+	 * the kernel from one that does not add CRCs by default.
+	 */
+	if (crc != expected_crc) {
+		if (expected_crc || xfs_has_crc(log->l_mp)) {
+			xfs_alert(log->l_mp,
+		"log record CRC mismatch: found 0x%x, expected 0x%x.",
+					le32_to_cpu(expected_crc),
+					le32_to_cpu(crc));
+			xfs_hex_dump(dp, 32);
+		}
+
+		/*
+		 * If the filesystem is CRC enabled, this mismatch becomes a
+		 * fatal log corruption failure.
+		 */
+		if (xfs_has_crc(log->l_mp)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+			return -EFSCORRUPTED;
+		}
+	}
+
+	xlog_unpack_data(rhead, dp, log);
+
+	return xlog_recover_process_data(log, rhash, rhead, dp, pass,
+					 buffer_list);
+}
+
+STATIC int
+xlog_valid_rec_header(
+	struct xlog		*log,
+	struct xlog_rec_header	*rhead,
+	xfs_daddr_t		blkno,
+	int			bufsize)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	u32			h_version = be32_to_cpu(rhead->h_version);
+	int			hlen;
+
+	if (XFS_IS_CORRUPT(mp,
+			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
+		return -EFSCORRUPTED;
+
+	/*
+	 * The log version must match the superblock
+	 */
+	if (xfs_has_logv2(mp)) {
+		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))
+			return -EFSCORRUPTED;
+	} else {
+		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_1))
+			return -EFSCORRUPTED;
+	}
+
+	/*
+	 * LR body must have data (or it wouldn't have been written)
+	 * and h_len must not be greater than LR buffer size.
+	 */
+	hlen = be32_to_cpu(rhead->h_len);
+	if (XFS_IS_CORRUPT(mp, hlen <= 0 || hlen > bufsize))
+		return -EFSCORRUPTED;
+
+	if (XFS_IS_CORRUPT(mp, blkno > log->l_logBBsize || blkno > INT_MAX))
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/*
+ * Read the log from tail to head and process the log records found.
+ * Handle the two cases where the tail and head are in the same cycle
+ * and where the active portion of the log wraps around the end of
+ * the physical log separately.  The pass parameter is passed through
+ * to the routines called to process the data and is not looked at
+ * here.
+ */
+STATIC int
+xlog_do_recovery_pass(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk,
+	int			pass,
+	xfs_daddr_t		*first_bad)	/* out: first bad log rec */
+{
+	struct xlog_rec_header	*rhead;
+	xfs_daddr_t		blk_no, rblk_no;
+	xfs_daddr_t		rhead_blk;
+	char			*offset;
+	char			*hbp, *dbp;
+	int			error = 0, h_size, h_len;
+	int			error2 = 0;
+	int			bblks, split_bblks;
+	int			hblks = 1, split_hblks, wrapped_hblks;
+	int			i;
+	struct hlist_head	rhash[XLOG_RHASH_SIZE];
+	LIST_HEAD		(buffer_list);
+
+	ASSERT(head_blk != tail_blk);
+	blk_no = rhead_blk = tail_blk;
+
+	for (i = 0; i < XLOG_RHASH_SIZE; i++)
+		INIT_HLIST_HEAD(&rhash[i]);
+
+	hbp = xlog_alloc_buffer(log, hblks);
+	if (!hbp)
+		return -ENOMEM;
+
+	/*
+	 * Read the header of the tail block and get the iclog buffer size from
+	 * h_size.  Use this to tell how many sectors make up the log header.
+	 */
+	if (xfs_has_logv2(log->l_mp)) {
+		/*
+		 * When using variable length iclogs, read first sector of
+		 * iclog header and extract the header size from it.  Get a
+		 * new hbp that is the correct size.
+		 */
+		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
+		if (error)
+			goto bread_err1;
+
+		rhead = (struct xlog_rec_header *)offset;
+
+		/*
+		 * xfsprogs has a bug where record length is based on lsunit but
+		 * h_size (iclog size) is hardcoded to 32k. Now that we
+		 * unconditionally CRC verify the unmount record, this means the
+		 * log buffer can be too small for the record and cause an
+		 * overrun.
+		 *
+		 * Detect this condition here. Use lsunit for the buffer size as
+		 * long as this looks like the mkfs case. Otherwise, return an
+		 * error to avoid a buffer overrun.
+		 */
+		h_size = be32_to_cpu(rhead->h_size);
+		h_len = be32_to_cpu(rhead->h_len);
+		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
+		    rhead->h_num_logops == cpu_to_be32(1)) {
+			xfs_warn(log->l_mp,
+		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
+				 h_size, log->l_mp->m_logbsize);
+			h_size = log->l_mp->m_logbsize;
+		}
+
+		error = xlog_valid_rec_header(log, rhead, tail_blk, h_size);
+		if (error)
+			goto bread_err1;
+
+		/*
+		 * This open codes xlog_logrec_hblks so that we can reuse the
+		 * fixed up h_size value calculated above.  Without that we'd
+		 * still allocate the buffer based on the incorrect on-disk
+		 * size.
+		 */
+		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
+		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+			if (hblks > 1) {
+				kvfree(hbp);
+				hbp = xlog_alloc_buffer(log, hblks);
+				if (!hbp)
+					return -ENOMEM;
+			}
+		}
+	} else {
+		ASSERT(log->l_sectBBsize == 1);
+		h_size = XLOG_BIG_RECORD_BSIZE;
+	}
+
+	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
+	if (!dbp) {
+		kvfree(hbp);
+		return -ENOMEM;
+	}
+
+	memset(rhash, 0, sizeof(rhash));
+	if (tail_blk > head_blk) {
+		/*
+		 * Perform recovery around the end of the physical log.
+		 * When the head is not on the same cycle number as the tail,
+		 * we can't do a sequential recovery.
+		 */
+		while (blk_no < log->l_logBBsize) {
+			/*
+			 * Check for header wrapping around physical end-of-log
+			 */
+			offset = hbp;
+			split_hblks = 0;
+			wrapped_hblks = 0;
+			if (blk_no + hblks <= log->l_logBBsize) {
+				/* Read header in one read */
+				error = xlog_bread(log, blk_no, hblks, hbp,
+						   &offset);
+				if (error)
+					goto bread_err2;
+			} else {
+				/* This LR is split across physical log end */
+				if (blk_no != log->l_logBBsize) {
+					/* some data before physical log end */
+					ASSERT(blk_no <= INT_MAX);
+					split_hblks = log->l_logBBsize - (int)blk_no;
+					ASSERT(split_hblks > 0);
+					error = xlog_bread(log, blk_no,
+							   split_hblks, hbp,
+							   &offset);
+					if (error)
+						goto bread_err2;
+				}
+
+				/*
+				 * Note: this black magic still works with
+				 * large sector sizes (non-512) only because:
+				 * - we increased the buffer size originally
+				 *   by 1 sector giving us enough extra space
+				 *   for the second read;
+				 * - the log start is guaranteed to be sector
+				 *   aligned;
+				 * - we read the log end (LR header start)
+				 *   _first_, then the log start (LR header end)
+				 *   - order is important.
+				 */
+				wrapped_hblks = hblks - split_hblks;
+				error = xlog_bread_noalign(log, 0,
+						wrapped_hblks,
+						offset + BBTOB(split_hblks));
+				if (error)
+					goto bread_err2;
+			}
+			rhead = (struct xlog_rec_header *)offset;
+			error = xlog_valid_rec_header(log, rhead,
+					split_hblks ? blk_no : 0, h_size);
+			if (error)
+				goto bread_err2;
+
+			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
+			blk_no += hblks;
+
+			/*
+			 * Read the log record data in multiple reads if it
+			 * wraps around the end of the log. Note that if the
+			 * header already wrapped, blk_no could point past the
+			 * end of the log. The record data is contiguous in
+			 * that case.
+			 */
+			if (blk_no + bblks <= log->l_logBBsize ||
+			    blk_no >= log->l_logBBsize) {
+				rblk_no = xlog_wrap_logbno(log, blk_no);
+				error = xlog_bread(log, rblk_no, bblks, dbp,
+						   &offset);
+				if (error)
+					goto bread_err2;
+			} else {
+				/* This log record is split across the
+				 * physical end of log */
+				offset = dbp;
+				split_bblks = 0;
+				if (blk_no != log->l_logBBsize) {
+					/* some data is before the physical
+					 * end of log */
+					ASSERT(!wrapped_hblks);
+					ASSERT(blk_no <= INT_MAX);
+					split_bblks =
+						log->l_logBBsize - (int)blk_no;
+					ASSERT(split_bblks > 0);
+					error = xlog_bread(log, blk_no,
+							split_bblks, dbp,
+							&offset);
+					if (error)
+						goto bread_err2;
+				}
+
+				/*
+				 * Note: this black magic still works with
+				 * large sector sizes (non-512) only because:
+				 * - we increased the buffer size originally
+				 *   by 1 sector giving us enough extra space
+				 *   for the second read;
+				 * - the log start is guaranteed to be sector
+				 *   aligned;
+				 * - we read the log end (LR header start)
+				 *   _first_, then the log start (LR header end)
+				 *   - order is important.
+				 */
+				error = xlog_bread_noalign(log, 0,
+						bblks - split_bblks,
+						offset + BBTOB(split_bblks));
+				if (error)
+					goto bread_err2;
+			}
+
+			error = xlog_recover_process(log, rhash, rhead, offset,
+						     pass, &buffer_list);
+			if (error)
+				goto bread_err2;
+
+			blk_no += bblks;
+			rhead_blk = blk_no;
+		}
+
+		ASSERT(blk_no >= log->l_logBBsize);
+		blk_no -= log->l_logBBsize;
+		rhead_blk = blk_no;
+	}
+
+	/* read first part of physical log */
+	while (blk_no < head_blk) {
+		error = xlog_bread(log, blk_no, hblks, hbp, &offset);
+		if (error)
+			goto bread_err2;
+
+		rhead = (struct xlog_rec_header *)offset;
+		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
+		if (error)
+			goto bread_err2;
+
+		/* blocks in data section */
+		bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
+		error = xlog_bread(log, blk_no+hblks, bblks, dbp,
+				   &offset);
+		if (error)
+			goto bread_err2;
+
+		error = xlog_recover_process(log, rhash, rhead, offset, pass,
+					     &buffer_list);
+		if (error)
+			goto bread_err2;
+
+		blk_no += bblks + hblks;
+		rhead_blk = blk_no;
+	}
+
+ bread_err2:
+	kvfree(dbp);
+ bread_err1:
+	kvfree(hbp);
+
+	/*
+	 * Submit buffers that have been dirtied by the last record recovered.
+	 */
+	if (!list_empty(&buffer_list)) {
+		if (error) {
+			/*
+			 * If there has been an item recovery error then we
+			 * cannot allow partial checkpoint writeback to
+			 * occur.  We might have multiple checkpoints with the
+			 * same start LSN in this buffer list, and partial
+			 * writeback of a checkpoint in this situation can
+			 * prevent future recovery of all the changes in the
+			 * checkpoints at this start LSN.
+			 *
+			 * Note: Shutting down the filesystem will result in the
+			 * delwri submission marking all the buffers stale,
+			 * completing them and cleaning up _XBF_LOGRECOVERY
+			 * state without doing any IO.
+			 */
+			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		}
+		error2 = xfs_buf_delwri_submit(&buffer_list);
+	}
+
+	if (error && first_bad)
+		*first_bad = rhead_blk;
+
+	/*
+	 * Transactions are freed at commit time but transactions without commit
+	 * records on disk are never committed. Free any that may be left in the
+	 * hash table.
+	 */
+	for (i = 0; i < XLOG_RHASH_SIZE; i++) {
+		struct hlist_node	*tmp;
+		struct xlog_recover	*trans;
+
+		hlist_for_each_entry_safe(trans, tmp, &rhash[i], r_list)
+			xlog_recover_free_trans(trans);
+	}
+
+	return error ? error : error2;
+}
+
+/*
+ * Do the recovery of the log.  We actually do this in two phases.
+ * The two passes are necessary in order to implement the function
+ * of cancelling a record written into the log.  The first pass
+ * determines those things which have been cancelled, and the
+ * second pass replays log items normally except for those which
+ * have been cancelled.  The handling of the replay and cancellations
+ * takes place in the log item type specific routines.
+ *
+ * The table of items which have cancel records in the log is allocated
+ * and freed at this level, since only here do we know when all of
+ * the log recovery has been completed.
+ */
+STATIC int
+xlog_do_log_recovery(
+	struct xlog	*log,
+	xfs_daddr_t	head_blk,
+	xfs_daddr_t	tail_blk)
+{
+	int		error;
+
+	ASSERT(head_blk != tail_blk);
+
+	/*
+	 * First do a pass to find all of the cancelled buf log items.
+	 * Store them in the buf_cancel_table for use in the second pass.
+	 */
+	error = xlog_alloc_buf_cancel_table(log);
+	if (error)
+		return error;
+
+	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
+				      XLOG_RECOVER_PASS1, NULL);
+	if (error != 0)
+		goto out_cancel;
+
+	/*
+	 * Then do a second pass to actually recover the items in the log.
+	 * When it is complete free the table of buf cancel items.
+	 */
+	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
+				      XLOG_RECOVER_PASS2, NULL);
+	if (!error)
+		xlog_check_buf_cancel_table(log);
+out_cancel:
+	xlog_free_buf_cancel_table(log);
+	return error;
+}
+
+/*
+ * Do the actual recovery
+ */
+STATIC int
+xlog_do_recover(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_buf		*bp = mp->m_sb_bp;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	int			error;
+
+	trace_xfs_log_recover(log, head_blk, tail_blk);
+
+	/*
+	 * First replay the images in the log.
+	 */
+	error = xlog_do_log_recovery(log, head_blk, tail_blk);
+	if (error)
+		return error;
+
+	if (xlog_is_shutdown(log))
+		return -EIO;
+
+	/*
+	 * We now update the tail_lsn since much of the recovery has completed
+	 * and there may be space available to use.  If there were no extent or
+	 * iunlinks, we can free up the entire log.  This was set in
+	 * xlog_find_tail to be the lsn of the last known good LR on disk.  If
+	 * there are extent frees or iunlinks they will have some entries in the
+	 * AIL; so we look at the AIL to determine how to set the tail_lsn.
+	 */
+	xfs_ail_assign_tail_lsn(log->l_ailp);
+
+	/*
+	 * Now that we've finished replaying all buffer and inode updates,
+	 * re-read the superblock and reverify it.
+	 */
+	xfs_buf_lock(bp);
+	xfs_buf_hold(bp);
+	error = _xfs_buf_read(bp);
+	if (error) {
+		if (!xlog_is_shutdown(log)) {
+			xfs_buf_ioerror_alert(bp, __this_address);
+			ASSERT(0);
+		}
+		xfs_buf_relse(bp);
+		return error;
+	}
+
+	/* Convert superblock from on-disk format */
+	xfs_sb_from_disk(sbp, bp->b_addr);
+	xfs_buf_relse(bp);
+
+	/* re-initialise in-core superblock and geometry structures */
+	mp->m_features |= xfs_sb_version_to_features(sbp);
+	xfs_reinit_percpu_counters(mp);
+
+	/* Normal transactions can now occur */
+	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
+	return 0;
+}
+
+/*
+ * Perform recovery and re-initialize some log variables in xlog_find_tail.
+ *
+ * Return error or zero.
+ */
+int
+xlog_recover(
+	struct xlog	*log)
+{
+	xfs_daddr_t	head_blk, tail_blk;
+	int		error;
+
+	/* find the tail of the log */
+	error = xlog_find_tail(log, &head_blk, &tail_blk);
+	if (error)
+		return error;
+
+	/*
+	 * The superblock was read before the log was available and thus the LSN
+	 * could not be verified. Check the superblock LSN against the current
+	 * LSN now that it's known.
+	 */
+	if (xfs_has_crc(log->l_mp) &&
+	    !xfs_log_check_lsn(log->l_mp, log->l_mp->m_sb.sb_lsn))
+		return -EINVAL;
+
+	if (tail_blk != head_blk) {
+		/* There used to be a comment here:
+		 *
+		 * disallow recovery on read-only mounts.  note -- mount
+		 * checks for ENOSPC and turns it into an intelligent
+		 * error message.
+		 * ...but this is no longer true.  Now, unless you specify
+		 * NORECOVERY (in which case this function would never be
+		 * called), we just go ahead and recover.  We do this all
+		 * under the vfs layer, so we can get away with it unless
+		 * the device itself is read-only, in which case we fail.
+		 */
+		if ((error = xfs_dev_is_read_only(log->l_mp, "recovery"))) {
+			return error;
+		}
+
+		/*
+		 * Version 5 superblock log feature mask validation. We know the
+		 * log is dirty so check if there are any unknown log features
+		 * in what we need to recover. If there are unknown features
+		 * (e.g. unsupported transactions, then simply reject the
+		 * attempt at recovery before touching anything.
+		 */
+		if (xfs_sb_is_v5(&log->l_mp->m_sb) &&
+		    xfs_sb_has_incompat_log_feature(&log->l_mp->m_sb,
+					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN)) {
+			xfs_warn(log->l_mp,
+"Superblock has unknown incompatible log features (0x%x) enabled.",
+				(log->l_mp->m_sb.sb_features_log_incompat &
+					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
+			xfs_warn(log->l_mp,
+"The log can not be fully and/or safely recovered by this kernel.");
+			xfs_warn(log->l_mp,
+"Please recover the log on a kernel that supports the unknown features.");
+			return -EINVAL;
+		}
+
+		/*
+		 * Delay log recovery if the debug hook is set. This is debug
+		 * instrumentation to coordinate simulation of I/O failures with
+		 * log recovery.
+		 */
+		if (xfs_globals.log_recovery_delay) {
+			xfs_notice(log->l_mp,
+				"Delaying log recovery for %d seconds.",
+				xfs_globals.log_recovery_delay);
+			msleep(xfs_globals.log_recovery_delay * 1000);
+		}
+
+		xfs_notice(log->l_mp, "Starting recovery (logdev: %s)",
+				log->l_mp->m_logname ? log->l_mp->m_logname
+						     : "internal");
+
+		error = xlog_do_recover(log, head_blk, tail_blk);
+		set_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
+	}
+	return error;
+}
+
+/*
+ * In the first part of recovery we replay inodes and buffers and build up the
+ * list of intents which need to be processed. Here we process the intents and
+ * clean up the on disk unlinked inode lists. This is separated from the first
+ * part of recovery so that the root and real-time bitmap inodes can be read in
+ * from disk in between the two stages.  This is necessary so that we can free
+ * space in the real-time portion of the file system.
+ *
+ * We run this whole process under GFP_NOFS allocation context. We do a
+ * combination of non-transactional and transactional work, yet we really don't
+ * want to recurse into the filesystem from direct reclaim during any of this
+ * processing. This allows all the recovery code run here not to care about the
+ * memory allocation context it is running in.
+ */
+int
+xlog_recover_finish(
+	struct xlog	*log)
+{
+	unsigned int	nofs_flags = memalloc_nofs_save();
+	int		error;
+
+	error = xlog_recover_process_intents(log);
+	if (error) {
+		/*
+		 * Cancel all the unprocessed intent items now so that we don't
+		 * leave them pinned in the AIL.  This can cause the AIL to
+		 * livelock on the pinned item if anyone tries to push the AIL
+		 * (inode reclaim does this) before we get around to
+		 * xfs_log_mount_cancel.
+		 */
+		xlog_recover_cancel_intents(log);
+		xfs_alert(log->l_mp, "Failed to recover intents");
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		goto out_error;
+	}
+
+	/*
+	 * Sync the log to get all the intents out of the AIL.  This isn't
+	 * absolutely necessary, but it helps in case the unlink transactions
+	 * would have problems pushing the intents out of the way.
+	 */
+	xfs_log_force(log->l_mp, XFS_LOG_SYNC);
+
+	xlog_recover_process_iunlinks(log);
+
+	/*
+	 * Recover any CoW staging blocks that are still referenced by the
+	 * ondisk refcount metadata.  During mount there cannot be any live
+	 * staging extents as we have not permitted any user modifications.
+	 * Therefore, it is safe to free them all right now, even on a
+	 * read-only mount.
+	 */
+	error = xfs_reflink_recover_cow(log->l_mp);
+	if (error) {
+		xfs_alert(log->l_mp,
+	"Failed to recover leftover CoW staging extents, err %d.",
+				error);
+		/*
+		 * If we get an error here, make sure the log is shut down
+		 * but return zero so that any log items committed since the
+		 * end of intents processing can be pushed through the CIL
+		 * and AIL.
+		 */
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		error = 0;
+		goto out_error;
+	}
+
+out_error:
+	memalloc_nofs_restore(nofs_flags);
+	return error;
+}
+
+void
+xlog_recover_cancel(
+	struct xlog	*log)
+{
+	if (xlog_recovery_needed(log))
+		xlog_recover_cancel_intents(log);
+}
+
diff --git a/libxlog/xfs_refcount_item.c b/libxlog/xfs_refcount_item.c
new file mode 100644
index 00000000..d7e41f2d
--- /dev/null
+++ b/libxlog/xfs_refcount_item.c
@@ -0,0 +1,861 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_refcount_item.h"
+#include "xfs_log.h"
+#include "xfs_refcount.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_ag.h"
+#include "xfs_btree.h"
+#include "xfs_trace.h"
+#include "xfs_rtgroup.h"
+
+struct kmem_cache	*xfs_cui_cache;
+struct kmem_cache	*xfs_cud_cache;
+
+static const struct xfs_item_ops xfs_cui_item_ops;
+
+static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_cui_log_item, cui_item);
+}
+
+STATIC void
+xfs_cui_item_free(
+	struct xfs_cui_log_item	*cuip)
+{
+	kvfree(cuip->cui_item.li_lv_shadow);
+	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
+		kfree(cuip);
+	else
+		kmem_cache_free(xfs_cui_cache, cuip);
+}
+
+/*
+ * Freeing the CUI requires that we remove it from the AIL if it has already
+ * been placed there. However, the CUI may not yet have been placed in the AIL
+ * when called by xfs_cui_release() from CUD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the CUI.
+ */
+STATIC void
+xfs_cui_release(
+	struct xfs_cui_log_item	*cuip)
+{
+	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
+	if (!atomic_dec_and_test(&cuip->cui_refcount))
+		return;
+
+	xfs_trans_ail_delete(&cuip->cui_item, 0);
+	xfs_cui_item_free(cuip);
+}
+
+
+STATIC void
+xfs_cui_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents);
+}
+
+unsigned int xfs_cui_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_cui_log_format_sizeof(nr));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given cui log item. We use only 1 iovec, and we point that
+ * at the cui_log_format structure embedded in the cui item.
+ * It is at this point that we assert that all of the extent
+ * slots in the cui item have been filled.
+ */
+STATIC void
+xfs_cui_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
+
+	ASSERT(atomic_read(&cuip->cui_next_extent) ==
+			cuip->cui_format.cui_nextents);
+	ASSERT(lip->li_type == XFS_LI_CUI || lip->li_type == XFS_LI_CUI_RT);
+
+	cuip->cui_format.cui_type = lip->li_type;
+	cuip->cui_format.cui_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_CUI_FORMAT, &cuip->cui_format,
+			xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents));
+}
+
+/*
+ * The unpin operation is the last place an CUI is manipulated in the log. It is
+ * either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the CUI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the CUI to either construct
+ * and commit the CUD or drop the CUD's reference in the event of error. Simply
+ * drop the log's CUI reference now that the log is done with it.
+ */
+STATIC void
+xfs_cui_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
+
+	xfs_cui_release(cuip);
+}
+
+/*
+ * The CUI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an CUD isn't going to be
+ * constructed and thus we free the CUI here directly.
+ */
+STATIC void
+xfs_cui_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_cui_release(CUI_ITEM(lip));
+}
+
+/*
+ * Allocate and initialize an cui item with the given number of extents.
+ */
+STATIC struct xfs_cui_log_item *
+xfs_cui_init(
+	struct xfs_mount		*mp,
+	unsigned short			item_type,
+	uint				nextents)
+{
+	struct xfs_cui_log_item		*cuip;
+
+	ASSERT(nextents > 0);
+	ASSERT(item_type == XFS_LI_CUI || item_type == XFS_LI_CUI_RT);
+
+	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
+		cuip = kzalloc(xfs_cui_log_item_sizeof(nextents),
+				GFP_KERNEL | __GFP_NOFAIL);
+	else
+		cuip = kmem_cache_zalloc(xfs_cui_cache,
+					 GFP_KERNEL | __GFP_NOFAIL);
+
+	xfs_log_item_init(mp, &cuip->cui_item, item_type, &xfs_cui_item_ops);
+	cuip->cui_format.cui_nextents = nextents;
+	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
+	atomic_set(&cuip->cui_next_extent, 0);
+	atomic_set(&cuip->cui_refcount, 2);
+
+	return cuip;
+}
+
+static inline struct xfs_cud_log_item *CUD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_cud_log_item, cud_item);
+}
+
+STATIC void
+xfs_cud_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_cud_log_format);
+}
+
+unsigned int xfs_cud_log_space(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_cud_log_format));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given cud log item. We use only 1 iovec, and we point that
+ * at the cud_log_format structure embedded in the cud item.
+ * It is at this point that we assert that all of the extent
+ * slots in the cud item have been filled.
+ */
+STATIC void
+xfs_cud_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
+
+	ASSERT(lip->li_type == XFS_LI_CUD || lip->li_type == XFS_LI_CUD_RT);
+
+	cudp->cud_format.cud_type = lip->li_type;
+	cudp->cud_format.cud_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
+			sizeof(struct xfs_cud_log_format));
+}
+
+/*
+ * The CUD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the CUI and free the
+ * CUD.
+ */
+STATIC void
+xfs_cud_item_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
+
+	xfs_cui_release(cudp->cud_cuip);
+	kvfree(cudp->cud_item.li_lv_shadow);
+	kmem_cache_free(xfs_cud_cache, cudp);
+}
+
+static struct xfs_log_item *
+xfs_cud_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &CUD_ITEM(lip)->cud_cuip->cui_item;
+}
+
+static const struct xfs_item_ops xfs_cud_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
+	.iop_size	= xfs_cud_item_size,
+	.iop_format	= xfs_cud_item_format,
+	.iop_release	= xfs_cud_item_release,
+	.iop_intent	= xfs_cud_item_intent,
+};
+
+static inline struct xfs_refcount_intent *ci_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_refcount_intent, ri_list);
+}
+
+static inline bool
+xfs_cui_item_isrt(const struct xfs_log_item *lip)
+{
+	ASSERT(lip->li_type == XFS_LI_CUI || lip->li_type == XFS_LI_CUI_RT);
+
+	return lip->li_type == XFS_LI_CUI_RT;
+}
+
+/* Sort refcount intents by AG. */
+static int
+xfs_refcount_update_diff_items(
+	void				*priv,
+	const struct list_head		*a,
+	const struct list_head		*b)
+{
+	struct xfs_refcount_intent	*ra = ci_entry(a);
+	struct xfs_refcount_intent	*rb = ci_entry(b);
+
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
+}
+
+/* Log refcount updates in the intent item. */
+STATIC void
+xfs_refcount_update_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_cui_log_item		*cuip,
+	struct xfs_refcount_intent	*ri)
+{
+	uint				next_extent;
+	struct xfs_phys_extent		*pmap;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
+	ASSERT(next_extent < cuip->cui_format.cui_nextents);
+	pmap = &cuip->cui_format.cui_extents[next_extent];
+	pmap->pe_startblock = ri->ri_startblock;
+	pmap->pe_len = ri->ri_blockcount;
+
+	pmap->pe_flags = 0;
+	switch (ri->ri_type) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		pmap->pe_flags |= ri->ri_type;
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+static struct xfs_log_item *
+__xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort,
+	unsigned short			item_type)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_refcount_intent	*ri;
+
+	ASSERT(count > 0);
+
+	cuip = xfs_cui_init(mp, item_type, count);
+	if (sort)
+		list_sort(mp, items, xfs_refcount_update_diff_items);
+	list_for_each_entry(ri, items, ri_list)
+		xfs_refcount_update_log_item(tp, cuip, ri);
+	return &cuip->cui_item;
+}
+
+static struct xfs_log_item *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_refcount_update_create_intent(tp, items, count, sort,
+			XFS_LI_CUI);
+}
+
+static inline unsigned short
+xfs_cud_type_from_cui(const struct xfs_cui_log_item *cuip)
+{
+	return xfs_cui_item_isrt(&cuip->cui_item) ? XFS_LI_CUD_RT : XFS_LI_CUD;
+}
+
+/* Get an CUD so we can process all the deferred refcount updates. */
+static struct xfs_log_item *
+xfs_refcount_update_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	struct xfs_cui_log_item		*cuip = CUI_ITEM(intent);
+	struct xfs_cud_log_item		*cudp;
+
+	cudp = kmem_cache_zalloc(xfs_cud_cache, GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &cudp->cud_item,
+			xfs_cud_type_from_cui(cuip), &xfs_cud_item_ops);
+	cudp->cud_cuip = cuip;
+	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
+
+	return &cudp->cud_item;
+}
+
+/* Add this deferred CUI to the transaction. */
+void
+xfs_refcount_defer_add(
+	struct xfs_trans		*tp,
+	struct xfs_refcount_intent	*ri)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	/*
+	 * Deferred refcount updates for the realtime and data sections must
+	 * use separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
+	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock,
+			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
+
+	trace_xfs_refcount_defer(mp, ri);
+	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
+			&xfs_rtrefcount_update_defer_type :
+			&xfs_refcount_update_defer_type);
+}
+
+/* Cancel a deferred refcount update. */
+STATIC void
+xfs_refcount_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+
+	xfs_group_intent_put(ri->ri_group);
+	kmem_cache_free(xfs_refcount_intent_cache, ri);
+}
+
+/* Process a deferred refcount update. */
+STATIC int
+xfs_refcount_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+	int				error;
+
+	/* Did we run out of reservation?  Requeue what we didn't finish. */
+	error = xfs_refcount_finish_one(tp, ri, state);
+	if (!error && ri->ri_blockcount > 0) {
+		ASSERT(ri->ri_type == XFS_REFCOUNT_INCREASE ||
+		       ri->ri_type == XFS_REFCOUNT_DECREASE);
+		return -EAGAIN;
+	}
+
+	xfs_refcount_update_cancel_item(item);
+	return error;
+}
+
+/* Clean up after calling xfs_refcount_finish_one. */
+STATIC void
+xfs_refcount_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_ag.agbp;
+	xfs_btree_del_cursor(rcur, error);
+	if (error && agbp)
+		xfs_trans_brelse(tp, agbp);
+}
+
+/* Abort all pending CUIs. */
+STATIC void
+xfs_refcount_update_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_cui_release(CUI_ITEM(intent));
+}
+
+/* Is this recovered CUI ok? */
+static inline bool
+xfs_cui_validate_phys(
+	struct xfs_mount		*mp,
+	bool				isrt,
+	struct xfs_phys_extent		*pmap)
+{
+	if (!xfs_has_reflink(mp))
+		return false;
+
+	if (pmap->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
+		return false;
+
+	switch (pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		break;
+	default:
+		return false;
+	}
+
+	if (isrt)
+		return xfs_verify_rtbext(mp, pmap->pe_startblock, pmap->pe_len);
+
+	return xfs_verify_fsbext(mp, pmap->pe_startblock, pmap->pe_len);
+}
+
+static inline void
+xfs_cui_recover_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	bool				isrt,
+	struct xfs_phys_extent		*pmap)
+{
+	struct xfs_refcount_intent	*ri;
+
+	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
+	ri->ri_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
+	ri->ri_startblock = pmap->pe_startblock;
+	ri->ri_blockcount = pmap->pe_len;
+	ri->ri_group = xfs_group_intent_get(mp, pmap->pe_startblock,
+			isrt ? XG_TYPE_RTG : XG_TYPE_AG);
+	ri->ri_realtime = isrt;
+
+	xfs_defer_add_item(dfp, &ri->ri_list);
+}
+
+/*
+ * Process a refcount update intent item that was recovered from the log.
+ * We need to update the refcountbt.
+ */
+STATIC int
+xfs_refcount_recover_work(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
+	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
+	struct xfs_trans		*tp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
+	bool				isrt = xfs_cui_item_isrt(lip);
+	int				i;
+	int				error = 0;
+
+	/*
+	 * First check the validity of the extents described by the
+	 * CUI.  If any are bad, then assume that all are bad and
+	 * just toss the CUI.
+	 */
+	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
+		if (!xfs_cui_validate_phys(mp, isrt,
+					&cuip->cui_format.cui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&cuip->cui_format,
+					sizeof(cuip->cui_format));
+			return -EFSCORRUPTED;
+		}
+
+		xfs_cui_recover_work(mp, dfp, isrt,
+				&cuip->cui_format.cui_extents[i]);
+	}
+
+	/*
+	 * Under normal operation, refcount updates are deferred, so we
+	 * wouldn't be adding them directly to a transaction.  All
+	 * refcount updates manage reservation usage internally and
+	 * dynamically by deferring work that won't fit in the
+	 * transaction.  Normally, any work that needs to be deferred
+	 * gets attached to the same defer_ops that scheduled the
+	 * refcount update.  However, we're in log recovery here, so we
+	 * use the passed in defer_ops and to finish up any work that
+	 * doesn't fit.  We need to reserve enough blocks to handle a
+	 * full btree split on either end of the refcount range.
+	 */
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, mp->m_refc_maxlevels * 2, 0,
+			XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+
+	error = xlog_recover_finish_intent(tp, dfp);
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&cuip->cui_format,
+				sizeof(cuip->cui_format));
+	if (error)
+		goto abort_error;
+
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+
+abort_error:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_refcount_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_phys_extent		*pmap;
+	unsigned int			count;
+
+	ASSERT(intent->li_type == XFS_LI_CUI ||
+	       intent->li_type == XFS_LI_CUI_RT);
+
+	count = CUI_ITEM(intent)->cui_format.cui_nextents;
+	pmap = CUI_ITEM(intent)->cui_format.cui_extents;
+
+	cuip = xfs_cui_init(tp->t_mountp, intent->li_type, count);
+	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
+	atomic_set(&cuip->cui_next_extent, count);
+
+	return &cuip->cui_item;
+}
+
+const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+	.name		= "refcount",
+	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_refcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_refcount_update_finish_item,
+	.finish_cleanup = xfs_refcount_finish_one_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+	.recover_work	= xfs_refcount_recover_work,
+	.relog_intent	= xfs_refcount_relog_intent,
+};
+
+#ifdef CONFIG_XFS_RT
+static struct xfs_log_item *
+xfs_rtrefcount_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_refcount_update_create_intent(tp, items, count, sort,
+			XFS_LI_CUI_RT);
+}
+
+/* Process a deferred realtime refcount update. */
+STATIC int
+xfs_rtrefcount_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+	int				error;
+
+	error = xfs_rtrefcount_finish_one(tp, ri, state);
+
+	/* Did we run out of reservation?  Requeue what we didn't finish. */
+	if (!error && ri->ri_blockcount > 0) {
+		ASSERT(ri->ri_type == XFS_REFCOUNT_INCREASE ||
+		       ri->ri_type == XFS_REFCOUNT_DECREASE);
+		return -EAGAIN;
+	}
+
+	xfs_refcount_update_cancel_item(item);
+	return error;
+}
+
+/* Clean up after calling xfs_rtrefcount_finish_one. */
+STATIC void
+xfs_rtrefcount_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	if (rcur)
+		xfs_btree_del_cursor(rcur, error);
+}
+
+const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type = {
+	.name		= "rtrefcount",
+	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rtrefcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_rtrefcount_update_finish_item,
+	.finish_cleanup = xfs_rtrefcount_finish_one_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+	.recover_work	= xfs_refcount_recover_work,
+	.relog_intent	= xfs_refcount_relog_intent,
+};
+#else
+const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type = {
+	.name		= "rtrefcount",
+};
+#endif /* CONFIG_XFS_RT */
+
+STATIC bool
+xfs_cui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
+}
+
+static const struct xfs_item_ops xfs_cui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
+	.iop_size	= xfs_cui_item_size,
+	.iop_format	= xfs_cui_item_format,
+	.iop_unpin	= xfs_cui_item_unpin,
+	.iop_release	= xfs_cui_item_release,
+	.iop_match	= xfs_cui_item_match,
+};
+
+static inline void
+xfs_cui_copy_format(
+	struct xfs_cui_log_format	*dst,
+	const struct xfs_cui_log_format	*src)
+{
+	unsigned int			i;
+
+	memcpy(dst, src, offsetof(struct xfs_cui_log_format, cui_extents));
+
+	for (i = 0; i < src->cui_nextents; i++)
+		memcpy(&dst->cui_extents[i], &src->cui_extents[i],
+				sizeof(struct xfs_phys_extent));
+}
+
+/*
+ * This routine is called to create an in-core extent refcount update
+ * item from the cui format structure which was logged on disk.
+ * It allocates an in-core cui, copies the extents from the format
+ * structure into it, and adds the cui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_cui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_cui_log_format	*cui_formatp;
+	size_t				len;
+
+	cui_formatp = item->ri_buf[0].iov_base;
+
+	if (item->ri_buf[0].iov_len < xfs_cui_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
+	if (item->ri_buf[0].iov_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	cuip = xfs_cui_init(mp, ITEM_TYPE(item), cui_formatp->cui_nextents);
+	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
+	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+
+	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
+			&xfs_refcount_update_defer_type);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_cui_item_ops = {
+	.item_type		= XFS_LI_CUI,
+	.commit_pass2		= xlog_recover_cui_commit_pass2,
+};
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtcui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_cui_log_format	*cui_formatp;
+	size_t				len;
+
+	cui_formatp = item->ri_buf[0].iov_base;
+
+	if (item->ri_buf[0].iov_len < xfs_cui_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
+	if (item->ri_buf[0].iov_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	cuip = xfs_cui_init(mp, ITEM_TYPE(item), cui_formatp->cui_nextents);
+	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
+	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+
+	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
+			&xfs_rtrefcount_update_defer_type);
+	return 0;
+}
+#else
+STATIC int
+xlog_recover_rtcui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+			item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	return -EFSCORRUPTED;
+}
+#endif
+
+const struct xlog_recover_item_ops xlog_rtcui_item_ops = {
+	.item_type		= XFS_LI_CUI_RT,
+	.commit_pass2		= xlog_recover_rtcui_commit_pass2,
+};
+
+/*
+ * This routine is called when an CUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding CUI if it
+ * was still in the log. To do this it searches the AIL for the CUI with an id
+ * equal to that in the CUD format structure. If we find it we drop the CUD
+ * reference, which removes the CUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_cud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_cud_log_format	*cud_formatp;
+
+	cud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_CUI, cud_formatp->cud_cui_id);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_cud_item_ops = {
+	.item_type		= XFS_LI_CUD,
+	.commit_pass2		= xlog_recover_cud_commit_pass2,
+};
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtcud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_cud_log_format	*cud_formatp;
+
+	cud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_CUI_RT,
+			cud_formatp->cud_cui_id);
+	return 0;
+}
+#else
+# define xlog_recover_rtcud_commit_pass2	xlog_recover_rtcui_commit_pass2
+#endif
+
+const struct xlog_recover_item_ops xlog_rtcud_item_ops = {
+	.item_type		= XFS_LI_CUD_RT,
+	.commit_pass2		= xlog_recover_rtcud_commit_pass2,
+};
diff --git a/libxlog/xfs_refcount_item.h b/libxlog/xfs_refcount_item.h
new file mode 100644
index 00000000..0fc3f493
--- /dev/null
+++ b/libxlog/xfs_refcount_item.h
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef	__XFS_REFCOUNT_ITEM_H__
+#define	__XFS_REFCOUNT_ITEM_H__
+
+/*
+ * There are (currently) two pairs of refcount btree redo item types:
+ * increase and decrease.  The log items for these are CUI (refcount
+ * update intent) and CUD (refcount update done).  The redo item type
+ * is encoded in the flags field of each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same
+ * transaction that records the associated refcountbt updates.
+ *
+ * Should the system crash after the commit of the first transaction
+ * but before the commit of the final transaction in a series, log
+ * recovery will use the redo information recorded by the intent items
+ * to replay the refcountbt metadata updates.
+ */
+
+/* kernel only CUI/CUD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_CUI_MAX_FAST_EXTENTS	16
+
+/*
+ * This is the "refcount update intent" log item.  It is used to log
+ * the fact that some reverse mappings need to change.  It is used in
+ * conjunction with the "refcount update done" log item described
+ * below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item;
+ * see the comments about that structure (in xfs_extfree_item.h) for
+ * more details.
+ */
+struct xfs_cui_log_item {
+	struct xfs_log_item		cui_item;
+	atomic_t			cui_refcount;
+	atomic_t			cui_next_extent;
+	struct xfs_cui_log_format	cui_format;
+};
+
+static inline size_t
+xfs_cui_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_cui_log_item, cui_format) +
+			xfs_cui_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "refcount update done" log item.  It is used to log the
+ * fact that some refcountbt updates mentioned in an earlier cui item
+ * have been performed.
+ */
+struct xfs_cud_log_item {
+	struct xfs_log_item		cud_item;
+	struct xfs_cui_log_item		*cud_cuip;
+	struct xfs_cud_log_format	cud_format;
+};
+
+extern struct kmem_cache	*xfs_cui_cache;
+extern struct kmem_cache	*xfs_cud_cache;
+
+struct xfs_refcount_intent;
+
+void xfs_refcount_defer_add(struct xfs_trans *tp,
+		struct xfs_refcount_intent *ri);
+
+unsigned int xfs_cui_log_space(unsigned int nr);
+unsigned int xfs_cud_log_space(void);
+
+#endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/libxlog/xfs_rmap_item.c b/libxlog/xfs_rmap_item.c
new file mode 100644
index 00000000..d9c7eb5f
--- /dev/null
+++ b/libxlog/xfs_rmap_item.c
@@ -0,0 +1,890 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_rmap_item.h"
+#include "xfs_log.h"
+#include "xfs_rmap.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_ag.h"
+#include "xfs_btree.h"
+#include "xfs_trace.h"
+#include "xfs_rtgroup.h"
+
+struct kmem_cache	*xfs_rui_cache;
+struct kmem_cache	*xfs_rud_cache;
+
+static const struct xfs_item_ops xfs_rui_item_ops;
+
+static inline struct xfs_rui_log_item *RUI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_rui_log_item, rui_item);
+}
+
+STATIC void
+xfs_rui_item_free(
+	struct xfs_rui_log_item	*ruip)
+{
+	kvfree(ruip->rui_item.li_lv_shadow);
+	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
+		kfree(ruip);
+	else
+		kmem_cache_free(xfs_rui_cache, ruip);
+}
+
+/*
+ * Freeing the RUI requires that we remove it from the AIL if it has already
+ * been placed there. However, the RUI may not yet have been placed in the AIL
+ * when called by xfs_rui_release() from RUD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the RUI.
+ */
+STATIC void
+xfs_rui_release(
+	struct xfs_rui_log_item	*ruip)
+{
+	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
+	if (!atomic_dec_and_test(&ruip->rui_refcount))
+		return;
+
+	xfs_trans_ail_delete(&ruip->rui_item, 0);
+	xfs_rui_item_free(ruip);
+}
+
+STATIC void
+xfs_rui_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_rui_log_item	*ruip = RUI_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents);
+}
+
+unsigned int xfs_rui_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given rui log item. We use only 1 iovec, and we point that
+ * at the rui_log_format structure embedded in the rui item.
+ * It is at this point that we assert that all of the extent
+ * slots in the rui item have been filled.
+ */
+STATIC void
+xfs_rui_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_rui_log_item	*ruip = RUI_ITEM(lip);
+
+	ASSERT(atomic_read(&ruip->rui_next_extent) ==
+			ruip->rui_format.rui_nextents);
+
+	ASSERT(lip->li_type == XFS_LI_RUI || lip->li_type == XFS_LI_RUI_RT);
+
+	ruip->rui_format.rui_type = lip->li_type;
+	ruip->rui_format.rui_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_RUI_FORMAT, &ruip->rui_format,
+			xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents));
+}
+
+/*
+ * The unpin operation is the last place an RUI is manipulated in the log. It is
+ * either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the RUI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the RUI to either construct
+ * and commit the RUD or drop the RUD's reference in the event of error. Simply
+ * drop the log's RUI reference now that the log is done with it.
+ */
+STATIC void
+xfs_rui_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_rui_log_item	*ruip = RUI_ITEM(lip);
+
+	xfs_rui_release(ruip);
+}
+
+/*
+ * The RUI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an RUD isn't going to be
+ * constructed and thus we free the RUI here directly.
+ */
+STATIC void
+xfs_rui_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_rui_release(RUI_ITEM(lip));
+}
+
+/*
+ * Allocate and initialize an rui item with the given number of extents.
+ */
+STATIC struct xfs_rui_log_item *
+xfs_rui_init(
+	struct xfs_mount		*mp,
+	unsigned short			item_type,
+	uint				nextents)
+
+{
+	struct xfs_rui_log_item		*ruip;
+
+	ASSERT(nextents > 0);
+	ASSERT(item_type == XFS_LI_RUI || item_type == XFS_LI_RUI_RT);
+
+	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
+		ruip = kzalloc(xfs_rui_log_item_sizeof(nextents),
+				GFP_KERNEL | __GFP_NOFAIL);
+	else
+		ruip = kmem_cache_zalloc(xfs_rui_cache,
+					 GFP_KERNEL | __GFP_NOFAIL);
+
+	xfs_log_item_init(mp, &ruip->rui_item, item_type, &xfs_rui_item_ops);
+	ruip->rui_format.rui_nextents = nextents;
+	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
+	atomic_set(&ruip->rui_next_extent, 0);
+	atomic_set(&ruip->rui_refcount, 2);
+
+	return ruip;
+}
+
+static inline struct xfs_rud_log_item *RUD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_rud_log_item, rud_item);
+}
+
+STATIC void
+xfs_rud_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_rud_log_format);
+}
+
+unsigned int xfs_rud_log_space(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given rud log item. We use only 1 iovec, and we point that
+ * at the rud_log_format structure embedded in the rud item.
+ * It is at this point that we assert that all of the extent
+ * slots in the rud item have been filled.
+ */
+STATIC void
+xfs_rud_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
+
+	ASSERT(lip->li_type == XFS_LI_RUD || lip->li_type == XFS_LI_RUD_RT);
+
+	rudp->rud_format.rud_type = lip->li_type;
+	rudp->rud_format.rud_size = 1;
+
+	xlog_format_copy(lfb, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
+			sizeof(struct xfs_rud_log_format));
+}
+
+/*
+ * The RUD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the RUI and free the
+ * RUD.
+ */
+STATIC void
+xfs_rud_item_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
+
+	xfs_rui_release(rudp->rud_ruip);
+	kvfree(rudp->rud_item.li_lv_shadow);
+	kmem_cache_free(xfs_rud_cache, rudp);
+}
+
+static struct xfs_log_item *
+xfs_rud_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &RUD_ITEM(lip)->rud_ruip->rui_item;
+}
+
+static const struct xfs_item_ops xfs_rud_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
+	.iop_size	= xfs_rud_item_size,
+	.iop_format	= xfs_rud_item_format,
+	.iop_release	= xfs_rud_item_release,
+	.iop_intent	= xfs_rud_item_intent,
+};
+
+static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_rmap_intent, ri_list);
+}
+
+static inline bool
+xfs_rui_item_isrt(const struct xfs_log_item *lip)
+{
+	ASSERT(lip->li_type == XFS_LI_RUI || lip->li_type == XFS_LI_RUI_RT);
+
+	return lip->li_type == XFS_LI_RUI_RT;
+}
+
+/* Sort rmap intents by AG. */
+static int
+xfs_rmap_update_diff_items(
+	void				*priv,
+	const struct list_head		*a,
+	const struct list_head		*b)
+{
+	struct xfs_rmap_intent		*ra = ri_entry(a);
+	struct xfs_rmap_intent		*rb = ri_entry(b);
+
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
+}
+
+/* Log rmap updates in the intent item. */
+STATIC void
+xfs_rmap_update_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_rui_log_item		*ruip,
+	struct xfs_rmap_intent		*ri)
+{
+	uint				next_extent;
+	struct xfs_map_extent		*map;
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&ruip->rui_next_extent) - 1;
+	ASSERT(next_extent < ruip->rui_format.rui_nextents);
+	map = &ruip->rui_format.rui_extents[next_extent];
+	map->me_owner = ri->ri_owner;
+	map->me_startblock = ri->ri_bmap.br_startblock;
+	map->me_startoff = ri->ri_bmap.br_startoff;
+	map->me_len = ri->ri_bmap.br_blockcount;
+
+	map->me_flags = 0;
+	if (ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN)
+		map->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
+	if (ri->ri_whichfork == XFS_ATTR_FORK)
+		map->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
+	switch (ri->ri_type) {
+	case XFS_RMAP_MAP:
+		map->me_flags |= XFS_RMAP_EXTENT_MAP;
+		break;
+	case XFS_RMAP_MAP_SHARED:
+		map->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
+		break;
+	case XFS_RMAP_UNMAP:
+		map->me_flags |= XFS_RMAP_EXTENT_UNMAP;
+		break;
+	case XFS_RMAP_UNMAP_SHARED:
+		map->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
+		break;
+	case XFS_RMAP_CONVERT:
+		map->me_flags |= XFS_RMAP_EXTENT_CONVERT;
+		break;
+	case XFS_RMAP_CONVERT_SHARED:
+		map->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
+		break;
+	case XFS_RMAP_ALLOC:
+		map->me_flags |= XFS_RMAP_EXTENT_ALLOC;
+		break;
+	case XFS_RMAP_FREE:
+		map->me_flags |= XFS_RMAP_EXTENT_FREE;
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+static struct xfs_log_item *
+__xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort,
+	unsigned short			item_type)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rmap_intent		*ri;
+
+	ASSERT(count > 0);
+
+	ruip = xfs_rui_init(mp, item_type, count);
+	if (sort)
+		list_sort(mp, items, xfs_rmap_update_diff_items);
+	list_for_each_entry(ri, items, ri_list)
+		xfs_rmap_update_log_item(tp, ruip, ri);
+	return &ruip->rui_item;
+}
+
+static struct xfs_log_item *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_rmap_update_create_intent(tp, items, count, sort,
+			XFS_LI_RUI);
+}
+
+static inline unsigned short
+xfs_rud_type_from_rui(const struct xfs_rui_log_item *ruip)
+{
+	return xfs_rui_item_isrt(&ruip->rui_item) ? XFS_LI_RUD_RT : XFS_LI_RUD;
+}
+
+/* Get an RUD so we can process all the deferred rmap updates. */
+static struct xfs_log_item *
+xfs_rmap_update_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	struct xfs_rui_log_item		*ruip = RUI_ITEM(intent);
+	struct xfs_rud_log_item		*rudp;
+
+	rudp = kmem_cache_zalloc(xfs_rud_cache, GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &rudp->rud_item,
+			xfs_rud_type_from_rui(ruip), &xfs_rud_item_ops);
+	rudp->rud_ruip = ruip;
+	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
+
+	return &rudp->rud_item;
+}
+
+/* Add this deferred RUI to the transaction. */
+void
+xfs_rmap_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_rmap_intent	*ri)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	/*
+	 * Deferred rmap updates for the realtime and data sections must use
+	 * separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
+	ri->ri_group = xfs_group_intent_get(mp, ri->ri_bmap.br_startblock,
+			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
+
+	trace_xfs_rmap_defer(mp, ri);
+	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
+			&xfs_rtrmap_update_defer_type :
+			&xfs_rmap_update_defer_type);
+}
+
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_rmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*ri = ri_entry(item);
+
+	xfs_group_intent_put(ri->ri_group);
+	kmem_cache_free(xfs_rmap_intent_cache, ri);
+}
+
+/* Process a deferred rmap update. */
+STATIC int
+xfs_rmap_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_rmap_intent		*ri = ri_entry(item);
+	int				error;
+
+	error = xfs_rmap_finish_one(tp, ri, state);
+
+	xfs_rmap_update_cancel_item(item);
+	return error;
+}
+
+/* Clean up after calling xfs_rmap_finish_one. */
+STATIC void
+xfs_rmap_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp = NULL;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_ag.agbp;
+	xfs_btree_del_cursor(rcur, error);
+	if (error && agbp)
+		xfs_trans_brelse(tp, agbp);
+}
+
+/* Abort all pending RUIs. */
+STATIC void
+xfs_rmap_update_abort_intent(
+	struct xfs_log_item	*intent)
+{
+	xfs_rui_release(RUI_ITEM(intent));
+}
+
+/* Is this recovered RUI ok? */
+static inline bool
+xfs_rui_validate_map(
+	struct xfs_mount		*mp,
+	bool				isrt,
+	struct xfs_map_extent		*map)
+{
+	if (!xfs_has_rmapbt(mp))
+		return false;
+
+	if (map->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+		return false;
+
+	switch (map->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+	case XFS_RMAP_EXTENT_MAP:
+	case XFS_RMAP_EXTENT_MAP_SHARED:
+	case XFS_RMAP_EXTENT_UNMAP:
+	case XFS_RMAP_EXTENT_UNMAP_SHARED:
+	case XFS_RMAP_EXTENT_CONVERT:
+	case XFS_RMAP_EXTENT_CONVERT_SHARED:
+	case XFS_RMAP_EXTENT_ALLOC:
+	case XFS_RMAP_EXTENT_FREE:
+		break;
+	default:
+		return false;
+	}
+
+	if (!XFS_RMAP_NON_INODE_OWNER(map->me_owner) &&
+	    !xfs_verify_ino(mp, map->me_owner))
+		return false;
+
+	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
+		return false;
+
+	if (isrt)
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
+
+	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
+}
+
+static inline void
+xfs_rui_recover_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	bool				isrt,
+	const struct xfs_map_extent	*map)
+{
+	struct xfs_rmap_intent		*ri;
+
+	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
+
+	switch (map->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+	case XFS_RMAP_EXTENT_MAP:
+		ri->ri_type = XFS_RMAP_MAP;
+		break;
+	case XFS_RMAP_EXTENT_MAP_SHARED:
+		ri->ri_type = XFS_RMAP_MAP_SHARED;
+		break;
+	case XFS_RMAP_EXTENT_UNMAP:
+		ri->ri_type = XFS_RMAP_UNMAP;
+		break;
+	case XFS_RMAP_EXTENT_UNMAP_SHARED:
+		ri->ri_type = XFS_RMAP_UNMAP_SHARED;
+		break;
+	case XFS_RMAP_EXTENT_CONVERT:
+		ri->ri_type = XFS_RMAP_CONVERT;
+		break;
+	case XFS_RMAP_EXTENT_CONVERT_SHARED:
+		ri->ri_type = XFS_RMAP_CONVERT_SHARED;
+		break;
+	case XFS_RMAP_EXTENT_ALLOC:
+		ri->ri_type = XFS_RMAP_ALLOC;
+		break;
+	case XFS_RMAP_EXTENT_FREE:
+		ri->ri_type = XFS_RMAP_FREE;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	ri->ri_owner = map->me_owner;
+	ri->ri_whichfork = (map->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
+			XFS_ATTR_FORK : XFS_DATA_FORK;
+	ri->ri_bmap.br_startblock = map->me_startblock;
+	ri->ri_bmap.br_startoff = map->me_startoff;
+	ri->ri_bmap.br_blockcount = map->me_len;
+	ri->ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+	ri->ri_group = xfs_group_intent_get(mp, map->me_startblock,
+			isrt ? XG_TYPE_RTG : XG_TYPE_AG);
+	ri->ri_realtime = isrt;
+
+	xfs_defer_add_item(dfp, &ri->ri_list);
+}
+
+/*
+ * Process an rmap update intent item that was recovered from the log.
+ * We need to update the rmapbt.
+ */
+STATIC int
+xfs_rmap_recover_work(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
+	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
+	struct xfs_trans		*tp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
+	bool				isrt = xfs_rui_item_isrt(lip);
+	int				i;
+	int				error = 0;
+
+	/*
+	 * First check the validity of the extents described by the
+	 * RUI.  If any are bad, then assume that all are bad and
+	 * just toss the RUI.
+	 */
+	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
+		if (!xfs_rui_validate_map(mp, isrt,
+					&ruip->rui_format.rui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&ruip->rui_format,
+					sizeof(ruip->rui_format));
+			return -EFSCORRUPTED;
+		}
+
+		xfs_rui_recover_work(mp, dfp, isrt,
+				&ruip->rui_format.rui_extents[i]);
+	}
+
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, mp->m_rmap_maxlevels, 0,
+			XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+
+	error = xlog_recover_finish_intent(tp, dfp);
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&ruip->rui_format,
+				sizeof(ruip->rui_format));
+	if (error)
+		goto abort_error;
+
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+
+abort_error:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Relog an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_rmap_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item)
+{
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_map_extent		*map;
+	unsigned int			count;
+
+	ASSERT(intent->li_type == XFS_LI_RUI ||
+	       intent->li_type == XFS_LI_RUI_RT);
+
+	count = RUI_ITEM(intent)->rui_format.rui_nextents;
+	map = RUI_ITEM(intent)->rui_format.rui_extents;
+
+	ruip = xfs_rui_init(tp->t_mountp, intent->li_type, count);
+	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
+	atomic_set(&ruip->rui_next_extent, count);
+
+	return &ruip->rui_item;
+}
+
+const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+	.name		= "rmap",
+	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rmap_finish_one_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
+	.recover_work	= xfs_rmap_recover_work,
+	.relog_intent	= xfs_rmap_relog_intent,
+};
+
+#ifdef CONFIG_XFS_RT
+static struct xfs_log_item *
+xfs_rtrmap_update_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return __xfs_rmap_update_create_intent(tp, items, count, sort,
+			XFS_LI_RUI_RT);
+}
+
+/* Clean up after calling xfs_rmap_finish_one. */
+STATIC void
+xfs_rtrmap_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	if (rcur)
+		xfs_btree_del_cursor(rcur, error);
+}
+
+const struct xfs_defer_op_type xfs_rtrmap_update_defer_type = {
+	.name		= "rtrmap",
+	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rtrmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rtrmap_finish_one_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
+	.recover_work	= xfs_rmap_recover_work,
+	.relog_intent	= xfs_rmap_relog_intent,
+};
+#else
+const struct xfs_defer_op_type xfs_rtrmap_update_defer_type = {
+	.name		= "rtrmap",
+};
+#endif
+
+STATIC bool
+xfs_rui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
+}
+
+static const struct xfs_item_ops xfs_rui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
+	.iop_size	= xfs_rui_item_size,
+	.iop_format	= xfs_rui_item_format,
+	.iop_unpin	= xfs_rui_item_unpin,
+	.iop_release	= xfs_rui_item_release,
+	.iop_match	= xfs_rui_item_match,
+};
+
+static inline void
+xfs_rui_copy_format(
+	struct xfs_rui_log_format	*dst,
+	const struct xfs_rui_log_format	*src)
+{
+	unsigned int			i;
+
+	memcpy(dst, src, offsetof(struct xfs_rui_log_format, rui_extents));
+
+	for (i = 0; i < src->rui_nextents; i++)
+		memcpy(&dst->rui_extents[i], &src->rui_extents[i],
+				sizeof(struct xfs_map_extent));
+}
+
+/*
+ * This routine is called to create an in-core extent rmap update
+ * item from the rui format structure which was logged on disk.
+ * It allocates an in-core rui, copies the extents from the format
+ * structure into it, and adds the rui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_rui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rui_log_format	*rui_formatp;
+	size_t				len;
+
+	rui_formatp = item->ri_buf[0].iov_base;
+
+	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
+	if (item->ri_buf[0].iov_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
+	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			&xfs_rmap_update_defer_type);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_rui_item_ops = {
+	.item_type		= XFS_LI_RUI,
+	.commit_pass2		= xlog_recover_rui_commit_pass2,
+};
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtrui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rui_log_format	*rui_formatp;
+	size_t				len;
+
+	rui_formatp = item->ri_buf[0].iov_base;
+
+	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
+	if (item->ri_buf[0].iov_len != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
+	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			&xfs_rtrmap_update_defer_type);
+	return 0;
+}
+#else
+STATIC int
+xlog_recover_rtrui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+			item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	return -EFSCORRUPTED;
+}
+#endif
+
+const struct xlog_recover_item_ops xlog_rtrui_item_ops = {
+	.item_type		= XFS_LI_RUI_RT,
+	.commit_pass2		= xlog_recover_rtrui_commit_pass2,
+};
+
+/*
+ * This routine is called when an RUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding RUI if it
+ * was still in the log. To do this it searches the AIL for the RUI with an id
+ * equal to that in the RUD format structure. If we find it we drop the RUD
+ * reference, which removes the RUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_rud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_rud_log_format	*rud_formatp;
+
+	rud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_rud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				rud_formatp, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_RUI, rud_formatp->rud_rui_id);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_rud_item_ops = {
+	.item_type		= XFS_LI_RUD,
+	.commit_pass2		= xlog_recover_rud_commit_pass2,
+};
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xlog_recover_rtrud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_rud_log_format	*rud_formatp;
+
+	rud_formatp = item->ri_buf[0].iov_base;
+	if (item->ri_buf[0].iov_len != sizeof(struct xfs_rud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				rud_formatp, item->ri_buf[0].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_RUI_RT,
+			rud_formatp->rud_rui_id);
+	return 0;
+}
+#else
+# define xlog_recover_rtrud_commit_pass2	xlog_recover_rtrui_commit_pass2
+#endif
+
+const struct xlog_recover_item_ops xlog_rtrud_item_ops = {
+	.item_type		= XFS_LI_RUD_RT,
+	.commit_pass2		= xlog_recover_rtrud_commit_pass2,
+};
diff --git a/libxlog/xfs_rmap_item.h b/libxlog/xfs_rmap_item.h
new file mode 100644
index 00000000..3a99f011
--- /dev/null
+++ b/libxlog/xfs_rmap_item.h
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef	__XFS_RMAP_ITEM_H__
+#define	__XFS_RMAP_ITEM_H__
+
+/*
+ * There are (currently) three pairs of rmap btree redo item types: map, unmap,
+ * and convert.  The common abbreviations for these are RUI (rmap update
+ * intent) and RUD (rmap update done).  The redo item type is encoded in the
+ * flags field of each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated rmapbt updates.  Typically, the first
+ * transaction will record a bmbt update, followed by some number of
+ * transactions containing rmapbt updates, and finally transactions with any
+ * bnobt/cntbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * (rmapbt/bnobt/cntbt) metadata updates in the non-first transaction.
+ */
+
+/* kernel only RUI/RUD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_RUI_MAX_FAST_EXTENTS	16
+
+/*
+ * This is the "rmap update intent" log item.  It is used to log the fact that
+ * some reverse mappings need to change.  It is used in conjunction with the
+ * "rmap update done" log item described below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_rui_log_item {
+	struct xfs_log_item		rui_item;
+	atomic_t			rui_refcount;
+	atomic_t			rui_next_extent;
+	struct xfs_rui_log_format	rui_format;
+};
+
+static inline size_t
+xfs_rui_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_rui_log_item, rui_format) +
+			xfs_rui_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "rmap update done" log item.  It is used to log the fact that
+ * some rmapbt updates mentioned in an earlier rui item have been performed.
+ */
+struct xfs_rud_log_item {
+	struct xfs_log_item		rud_item;
+	struct xfs_rui_log_item		*rud_ruip;
+	struct xfs_rud_log_format	rud_format;
+};
+
+extern struct kmem_cache	*xfs_rui_cache;
+extern struct kmem_cache	*xfs_rud_cache;
+
+struct xfs_rmap_intent;
+
+void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
+
+unsigned int xfs_rui_log_space(unsigned int nr);
+unsigned int xfs_rud_log_space(void);
+
+#endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/libxlog/xfs_trans_ail.c b/libxlog/xfs_trans_ail.c
new file mode 100644
index 00000000..312b4dd7
--- /dev/null
+++ b/libxlog/xfs_trans_ail.c
@@ -0,0 +1,978 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2008 Dave Chinner
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_trace.h"
+#include "xfs_errortag.h"
+#include "xfs_log_priv.h"
+
+#ifdef DEBUG
+/*
+ * Check that the list is sorted as it should be.
+ *
+ * Called with the ail lock held, but we don't want to assert fail with it
+ * held otherwise we'll lock everything up and won't be able to debug the
+ * cause. Hence we sample and check the state under the AIL lock and return if
+ * everything is fine, otherwise we drop the lock and run the ASSERT checks.
+ * Asserts may not be fatal, so pick the lock back up and continue onwards.
+ */
+STATIC void
+xfs_ail_check(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+	__must_hold(&ailp->ail_lock)
+{
+	struct xfs_log_item	*prev_lip;
+	struct xfs_log_item	*next_lip;
+	xfs_lsn_t		prev_lsn = NULLCOMMITLSN;
+	xfs_lsn_t		next_lsn = NULLCOMMITLSN;
+	xfs_lsn_t		lsn;
+	bool			in_ail;
+
+
+	if (list_empty(&ailp->ail_head))
+		return;
+
+	/*
+	 * Sample then check the next and previous entries are valid.
+	 */
+	in_ail = test_bit(XFS_LI_IN_AIL, &lip->li_flags);
+	prev_lip = list_entry(lip->li_ail.prev, struct xfs_log_item, li_ail);
+	if (&prev_lip->li_ail != &ailp->ail_head)
+		prev_lsn = prev_lip->li_lsn;
+	next_lip = list_entry(lip->li_ail.next, struct xfs_log_item, li_ail);
+	if (&next_lip->li_ail != &ailp->ail_head)
+		next_lsn = next_lip->li_lsn;
+	lsn = lip->li_lsn;
+
+	if (in_ail &&
+	    (prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0) &&
+	    (next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0))
+		return;
+
+	spin_unlock(&ailp->ail_lock);
+	ASSERT(in_ail);
+	ASSERT(prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0);
+	ASSERT(next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0);
+	spin_lock(&ailp->ail_lock);
+}
+#else /* !DEBUG */
+#define	xfs_ail_check(a,l)
+#endif /* DEBUG */
+
+/*
+ * Return a pointer to the last item in the AIL.  If the AIL is empty, then
+ * return NULL.
+ */
+static struct xfs_log_item *
+xfs_ail_max(
+	struct xfs_ail  *ailp)
+{
+	if (list_empty(&ailp->ail_head))
+		return NULL;
+
+	return list_entry(ailp->ail_head.prev, struct xfs_log_item, li_ail);
+}
+
+/*
+ * Return a pointer to the item which follows the given item in the AIL.  If
+ * the given item is the last item in the list, then return NULL.
+ */
+static struct xfs_log_item *
+xfs_ail_next(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+	if (lip->li_ail.next == &ailp->ail_head)
+		return NULL;
+
+	return list_first_entry(&lip->li_ail, struct xfs_log_item, li_ail);
+}
+
+/*
+ * This is called by the log manager code to determine the LSN of the tail of
+ * the log.  This is exactly the LSN of the first item in the AIL.  If the AIL
+ * is empty, then this function returns 0.
+ *
+ * We need the AIL lock in order to get a coherent read of the lsn of the last
+ * item in the AIL.
+ */
+static xfs_lsn_t
+__xfs_ail_min_lsn(
+	struct xfs_ail		*ailp)
+{
+	struct xfs_log_item	*lip = xfs_ail_min(ailp);
+
+	if (lip)
+		return lip->li_lsn;
+	return 0;
+}
+
+xfs_lsn_t
+xfs_ail_min_lsn(
+	struct xfs_ail		*ailp)
+{
+	xfs_lsn_t		lsn;
+
+	spin_lock(&ailp->ail_lock);
+	lsn = __xfs_ail_min_lsn(ailp);
+	spin_unlock(&ailp->ail_lock);
+
+	return lsn;
+}
+
+/*
+ * The cursor keeps track of where our current traversal is up to by tracking
+ * the next item in the list for us. However, for this to be safe, removing an
+ * object from the AIL needs to invalidate any cursor that points to it. hence
+ * the traversal cursor needs to be linked to the struct xfs_ail so that
+ * deletion can search all the active cursors for invalidation.
+ */
+STATIC void
+xfs_trans_ail_cursor_init(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur)
+{
+	cur->item = NULL;
+	list_add_tail(&cur->list, &ailp->ail_cursors);
+}
+
+/*
+ * Get the next item in the traversal and advance the cursor.  If the cursor
+ * was invalidated (indicated by a lip of 1), restart the traversal.
+ */
+struct xfs_log_item *
+xfs_trans_ail_cursor_next(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur)
+{
+	struct xfs_log_item	*lip = cur->item;
+
+	if ((uintptr_t)lip & 1)
+		lip = xfs_ail_min(ailp);
+	if (lip)
+		cur->item = xfs_ail_next(ailp, lip);
+	return lip;
+}
+
+/*
+ * When the traversal is complete, we need to remove the cursor from the list
+ * of traversing cursors.
+ */
+void
+xfs_trans_ail_cursor_done(
+	struct xfs_ail_cursor	*cur)
+{
+	cur->item = NULL;
+	list_del_init(&cur->list);
+}
+
+/*
+ * Invalidate any cursor that is pointing to this item. This is called when an
+ * item is removed from the AIL. Any cursor pointing to this object is now
+ * invalid and the traversal needs to be terminated so it doesn't reference a
+ * freed object. We set the low bit of the cursor item pointer so we can
+ * distinguish between an invalidation and the end of the list when getting the
+ * next item from the cursor.
+ */
+STATIC void
+xfs_trans_ail_cursor_clear(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_ail_cursor	*cur;
+
+	list_for_each_entry(cur, &ailp->ail_cursors, list) {
+		if (cur->item == lip)
+			cur->item = (struct xfs_log_item *)
+					((uintptr_t)cur->item | 1);
+	}
+}
+
+/*
+ * Find the first item in the AIL with the given @lsn by searching in ascending
+ * LSN order and initialise the cursor to point to the next item for a
+ * ascending traversal.  Pass a @lsn of zero to initialise the cursor to the
+ * first item in the AIL. Returns NULL if the list is empty.
+ */
+struct xfs_log_item *
+xfs_trans_ail_cursor_first(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	xfs_lsn_t		lsn)
+{
+	struct xfs_log_item	*lip;
+
+	xfs_trans_ail_cursor_init(ailp, cur);
+
+	if (lsn == 0) {
+		lip = xfs_ail_min(ailp);
+		goto out;
+	}
+
+	list_for_each_entry(lip, &ailp->ail_head, li_ail) {
+		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
+			goto out;
+	}
+	return NULL;
+
+out:
+	if (lip)
+		cur->item = xfs_ail_next(ailp, lip);
+	return lip;
+}
+
+static struct xfs_log_item *
+__xfs_trans_ail_cursor_last(
+	struct xfs_ail		*ailp,
+	xfs_lsn_t		lsn)
+{
+	struct xfs_log_item	*lip;
+
+	list_for_each_entry_reverse(lip, &ailp->ail_head, li_ail) {
+		if (XFS_LSN_CMP(lip->li_lsn, lsn) <= 0)
+			return lip;
+	}
+	return NULL;
+}
+
+/*
+ * Find the last item in the AIL with the given @lsn by searching in descending
+ * LSN order and initialise the cursor to point to that item.  If there is no
+ * item with the value of @lsn, then it sets the cursor to the last item with an
+ * LSN lower than @lsn.  Returns NULL if the list is empty.
+ */
+struct xfs_log_item *
+xfs_trans_ail_cursor_last(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	xfs_lsn_t		lsn)
+{
+	xfs_trans_ail_cursor_init(ailp, cur);
+	cur->item = __xfs_trans_ail_cursor_last(ailp, lsn);
+	return cur->item;
+}
+
+/*
+ * Splice the log item list into the AIL at the given LSN. We splice to the
+ * tail of the given LSN to maintain insert order for push traversals. The
+ * cursor is optional, allowing repeated updates to the same LSN to avoid
+ * repeated traversals.  This should not be called with an empty list.
+ */
+static void
+xfs_ail_splice(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	struct list_head	*list,
+	xfs_lsn_t		lsn)
+{
+	struct xfs_log_item	*lip;
+
+	ASSERT(!list_empty(list));
+
+	/*
+	 * Use the cursor to determine the insertion point if one is
+	 * provided.  If not, or if the one we got is not valid,
+	 * find the place in the AIL where the items belong.
+	 */
+	lip = cur ? cur->item : NULL;
+	if (!lip || (uintptr_t)lip & 1)
+		lip = __xfs_trans_ail_cursor_last(ailp, lsn);
+
+	/*
+	 * If a cursor is provided, we know we're processing the AIL
+	 * in lsn order, and future items to be spliced in will
+	 * follow the last one being inserted now.  Update the
+	 * cursor to point to that last item, now while we have a
+	 * reliable pointer to it.
+	 */
+	if (cur)
+		cur->item = list_entry(list->prev, struct xfs_log_item, li_ail);
+
+	/*
+	 * Finally perform the splice.  Unless the AIL was empty,
+	 * lip points to the item in the AIL _after_ which the new
+	 * items should go.  If lip is null the AIL was empty, so
+	 * the new items go at the head of the AIL.
+	 */
+	if (lip)
+		list_splice(list, &lip->li_ail);
+	else
+		list_splice(list, &ailp->ail_head);
+}
+
+/*
+ * Delete the given item from the AIL.
+ */
+static void
+xfs_ail_delete(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+	xfs_ail_check(ailp, lip);
+	list_del(&lip->li_ail);
+	xfs_trans_ail_cursor_clear(ailp, lip);
+}
+
+/*
+ * Requeue a failed buffer for writeback.
+ *
+ * We clear the log item failed state here as well, but we have to be careful
+ * about reference counts because the only active reference counts on the buffer
+ * may be the failed log items. Hence if we clear the log item failed state
+ * before queuing the buffer for IO we can release all active references to
+ * the buffer and free it, leading to use after free problems in
+ * xfs_buf_delwri_queue. It makes no difference to the buffer or log items which
+ * order we process them in - the buffer is locked, and we own the buffer list
+ * so nothing on them is going to change while we are performing this action.
+ *
+ * Hence we can safely queue the buffer for IO before we clear the failed log
+ * item state, therefore  always having an active reference to the buffer and
+ * avoiding the transient zero-reference state that leads to use-after-free.
+ */
+static inline int
+xfsaild_resubmit_item(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	struct xfs_buf		*bp = lip->li_buf;
+
+	if (!xfs_buf_trylock(bp))
+		return XFS_ITEM_LOCKED;
+
+	if (!xfs_buf_delwri_queue(bp, buffer_list)) {
+		xfs_buf_unlock(bp);
+		return XFS_ITEM_FLUSHING;
+	}
+
+	/* protected by ail_lock */
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		clear_bit(XFS_LI_FAILED, &lip->li_flags);
+	xfs_buf_unlock(bp);
+	return XFS_ITEM_SUCCESS;
+}
+
+/*
+ * Push a single log item from the AIL.
+ *
+ * @lip may have been released and freed by the time this function returns,
+ * so callers must not dereference the log item afterwards.
+ */
+static inline uint
+xfsaild_push_item(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+	/*
+	 * If log item pinning is enabled, skip the push and track the item as
+	 * pinned. This can help induce head-behind-tail conditions.
+	 */
+	if (XFS_TEST_ERROR(ailp->ail_log->l_mp, XFS_ERRTAG_LOG_ITEM_PIN))
+		return XFS_ITEM_PINNED;
+
+	/*
+	 * Consider the item pinned if a push callback is not defined so the
+	 * caller will force the log. This should only happen for intent items
+	 * as they are unpinned once the associated done item is committed to
+	 * the on-disk log.
+	 */
+	if (!lip->li_ops->iop_push)
+		return XFS_ITEM_PINNED;
+	if (test_bit(XFS_LI_FAILED, &lip->li_flags))
+		return xfsaild_resubmit_item(lip, &ailp->ail_buf_list);
+	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
+}
+
+/*
+ * Compute the LSN that we'd need to push the log tail towards in order to have
+ * at least 25% of the log space free.  If the log free space already meets this
+ * threshold, this function returns the lowest LSN in the AIL to slowly keep
+ * writeback ticking over and the tail of the log moving forward.
+ */
+static xfs_lsn_t
+xfs_ail_calc_push_target(
+	struct xfs_ail		*ailp)
+{
+	struct xlog		*log = ailp->ail_log;
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		target_lsn;
+	xfs_lsn_t		max_lsn;
+	xfs_lsn_t		min_lsn;
+	int32_t			free_bytes;
+	uint32_t		target_block;
+	uint32_t		target_cycle;
+
+	lockdep_assert_held(&ailp->ail_lock);
+
+	lip = xfs_ail_max(ailp);
+	if (!lip)
+		return NULLCOMMITLSN;
+
+	max_lsn = lip->li_lsn;
+	min_lsn = __xfs_ail_min_lsn(ailp);
+
+	/*
+	 * If we are supposed to push all the items in the AIL, we want to push
+	 * to the current head. We then clear the push flag so that we don't
+	 * keep pushing newly queued items beyond where the push all command was
+	 * run. If the push waiter wants to empty the ail, it should queue
+	 * itself on the ail_empty wait queue.
+	 */
+	if (test_and_clear_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate))
+		return max_lsn;
+
+	/* If someone wants the AIL empty, keep pushing everything we have. */
+	if (waitqueue_active(&ailp->ail_empty))
+		return max_lsn;
+
+	/*
+	 * Background pushing - attempt to keep 25% of the log free and if we
+	 * have that much free retain the existing target.
+	 */
+	free_bytes = log->l_logsize - xlog_lsn_sub(log, max_lsn, min_lsn);
+	if (free_bytes >= log->l_logsize >> 2)
+		return ailp->ail_target;
+
+	target_cycle = CYCLE_LSN(min_lsn);
+	target_block = BLOCK_LSN(min_lsn) + (log->l_logBBsize >> 2);
+	if (target_block >= log->l_logBBsize) {
+		target_block -= log->l_logBBsize;
+		target_cycle += 1;
+	}
+	target_lsn = xlog_assign_lsn(target_cycle, target_block);
+
+	/* Cap the target to the highest LSN known to be in the AIL. */
+	if (XFS_LSN_CMP(target_lsn, max_lsn) > 0)
+		return max_lsn;
+
+	/* If the existing target is higher than the new target, keep it. */
+	if (XFS_LSN_CMP(ailp->ail_target, target_lsn) >= 0)
+		return ailp->ail_target;
+	return target_lsn;
+}
+
+static void
+xfsaild_process_logitem(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip,
+	int			*stuck,
+	int			*flushing)
+{
+	struct xfs_mount	*mp = ailp->ail_log->l_mp;
+	uint			type = lip->li_type;
+	unsigned long		flags = lip->li_flags;
+	xfs_lsn_t		item_lsn = lip->li_lsn;
+	int			lock_result;
+
+	/*
+	 * Note that iop_push may unlock and reacquire the AIL lock. We
+	 * rely on the AIL cursor implementation to be able to deal with
+	 * the dropped lock.
+	 *
+	 * The log item may have been freed by the push, so it must not
+	 * be accessed or dereferenced below this line.
+	 */
+	lock_result = xfsaild_push_item(ailp, lip);
+	switch (lock_result) {
+	case XFS_ITEM_SUCCESS:
+		XFS_STATS_INC(mp, xs_push_ail_success);
+		trace_xfs_ail_push(ailp, type, flags, item_lsn);
+
+		ailp->ail_last_pushed_lsn = item_lsn;
+		break;
+
+	case XFS_ITEM_FLUSHING:
+		/*
+		 * The item or its backing buffer is already being
+		 * flushed.  The typical reason for that is that an
+		 * inode buffer is locked because we already pushed the
+		 * updates to it as part of inode clustering.
+		 *
+		 * We do not want to stop flushing just because lots
+		 * of items are already being flushed, but we need to
+		 * re-try the flushing relatively soon if most of the
+		 * AIL is being flushed.
+		 */
+		XFS_STATS_INC(mp, xs_push_ail_flushing);
+		trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
+
+		(*flushing)++;
+		ailp->ail_last_pushed_lsn = item_lsn;
+		break;
+
+	case XFS_ITEM_PINNED:
+		XFS_STATS_INC(mp, xs_push_ail_pinned);
+		trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
+
+		(*stuck)++;
+		ailp->ail_log_flush++;
+		break;
+	case XFS_ITEM_LOCKED:
+		XFS_STATS_INC(mp, xs_push_ail_locked);
+		trace_xfs_ail_locked(ailp, type, flags, item_lsn);
+
+		(*stuck)++;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+}
+
+static long
+xfsaild_push(
+	struct xfs_ail		*ailp)
+{
+	struct xfs_mount	*mp = ailp->ail_log->l_mp;
+	struct xfs_ail_cursor	cur;
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		lsn;
+	long			tout;
+	int			stuck = 0;
+	int			flushing = 0;
+	int			count = 0;
+
+	/*
+	 * If we encountered pinned items or did not finish writing out all
+	 * buffers the last time we ran, force a background CIL push to get the
+	 * items unpinned in the near future. We do not wait on the CIL push as
+	 * that could stall us for seconds if there is enough background IO
+	 * load. Stalling for that long when the tail of the log is pinned and
+	 * needs flushing will hard stop the transaction subsystem when log
+	 * space runs out.
+	 */
+	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
+	    (!list_empty_careful(&ailp->ail_buf_list) ||
+	     xfs_ail_min_lsn(ailp))) {
+		ailp->ail_log_flush = 0;
+
+		XFS_STATS_INC(mp, xs_push_ail_flush);
+		xlog_cil_flush(ailp->ail_log);
+	}
+
+	spin_lock(&ailp->ail_lock);
+	WRITE_ONCE(ailp->ail_target, xfs_ail_calc_push_target(ailp));
+	if (ailp->ail_target == NULLCOMMITLSN)
+		goto out_done;
+
+	/* we're done if the AIL is empty or our push has reached the end */
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
+	if (!lip)
+		goto out_done_cursor;
+
+	XFS_STATS_INC(mp, xs_push_ail);
+
+	ASSERT(ailp->ail_target != NULLCOMMITLSN);
+
+	lsn = lip->li_lsn;
+	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
+
+		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
+			goto next_item;
+
+		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
+		count++;
+
+		/*
+		 * Are there too many items we can't do anything with?
+		 *
+		 * If we are skipping too many items because we can't flush
+		 * them or they are already being flushed, we back off and
+		 * given them time to complete whatever operation is being
+		 * done. i.e. remove pressure from the AIL while we can't make
+		 * progress so traversals don't slow down further inserts and
+		 * removals to/from the AIL.
+		 *
+		 * The value of 100 is an arbitrary magic number based on
+		 * observation.
+		 */
+		if (stuck > 100)
+			break;
+
+next_item:
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+		if (lip == NULL)
+			break;
+		if (lip->li_lsn != lsn && count > 1000)
+			break;
+		lsn = lip->li_lsn;
+	}
+
+out_done_cursor:
+	xfs_trans_ail_cursor_done(&cur);
+out_done:
+	spin_unlock(&ailp->ail_lock);
+
+	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
+		ailp->ail_log_flush++;
+
+	if (!count || XFS_LSN_CMP(lsn, ailp->ail_target) >= 0) {
+		/*
+		 * We reached the target or the AIL is empty, so wait a bit
+		 * longer for I/O to complete and remove pushed items from the
+		 * AIL before we start the next scan from the start of the AIL.
+		 */
+		tout = 50;
+		ailp->ail_last_pushed_lsn = 0;
+	} else if (((stuck + flushing) * 100) / count > 90) {
+		/*
+		 * Either there is a lot of contention on the AIL or we are
+		 * stuck due to operations in progress. "Stuck" in this case
+		 * is defined as >90% of the items we tried to push were stuck.
+		 *
+		 * Backoff a bit more to allow some I/O to complete before
+		 * restarting from the start of the AIL. This prevents us from
+		 * spinning on the same items, and if they are pinned will all
+		 * the restart to issue a log force to unpin the stuck items.
+		 */
+		tout = 20;
+		ailp->ail_last_pushed_lsn = 0;
+	} else {
+		/*
+		 * Assume we have more work to do in a short while.
+		 */
+		tout = 0;
+	}
+
+	return tout;
+}
+
+static int
+xfsaild(
+	void		*data)
+{
+	struct xfs_ail	*ailp = data;
+	long		tout = 0;	/* milliseconds */
+	unsigned int	noreclaim_flag;
+
+	noreclaim_flag = memalloc_noreclaim_save();
+	set_freezable();
+
+	while (1) {
+		/*
+		 * Long waits of 50ms or more occur when we've run out of items
+		 * to push, so we only want uninterruptible state if we're
+		 * actually blocked on something.
+		 */
+		if (tout && tout <= 20)
+			set_current_state(TASK_KILLABLE|TASK_FREEZABLE);
+		else
+			set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
+
+		/*
+		 * Check kthread_should_stop() after we set the task state to
+		 * guarantee that we either see the stop bit and exit or the
+		 * task state is reset to runnable such that it's not scheduled
+		 * out indefinitely and detects the stop bit at next iteration.
+		 * A memory barrier is included in above task state set to
+		 * serialize again kthread_stop().
+		 */
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
+
+			/*
+			 * The caller forces out the AIL before stopping the
+			 * thread in the common case, which means the delwri
+			 * queue is drained. In the shutdown case, the queue may
+			 * still hold relogged buffers that haven't been
+			 * submitted because they were pinned since added to the
+			 * queue.
+			 *
+			 * Log I/O error processing stales the underlying buffer
+			 * and clears the delwri state, expecting the buf to be
+			 * removed on the next submission attempt. That won't
+			 * happen if we're shutting down, so this is the last
+			 * opportunity to release such buffers from the queue.
+			 */
+			ASSERT(list_empty(&ailp->ail_buf_list) ||
+			       xlog_is_shutdown(ailp->ail_log));
+			xfs_buf_delwri_cancel(&ailp->ail_buf_list);
+			break;
+		}
+
+		/* Idle if the AIL is empty. */
+		spin_lock(&ailp->ail_lock);
+		if (!xfs_ail_min(ailp) && list_empty(&ailp->ail_buf_list)) {
+			spin_unlock(&ailp->ail_lock);
+			schedule();
+			tout = 0;
+			continue;
+		}
+		spin_unlock(&ailp->ail_lock);
+
+		if (tout)
+			schedule_timeout(msecs_to_jiffies(tout));
+
+		__set_current_state(TASK_RUNNING);
+
+		try_to_freeze();
+
+		tout = xfsaild_push(ailp);
+	}
+
+	memalloc_noreclaim_restore(noreclaim_flag);
+	return 0;
+}
+
+/*
+ * Push out all items in the AIL immediately and wait until the AIL is empty.
+ */
+void
+xfs_ail_push_all_sync(
+	struct xfs_ail  *ailp)
+{
+	DEFINE_WAIT(wait);
+
+	spin_lock(&ailp->ail_lock);
+	while (xfs_ail_max(ailp) != NULL) {
+		prepare_to_wait(&ailp->ail_empty, &wait, TASK_UNINTERRUPTIBLE);
+		wake_up_process(ailp->ail_task);
+		spin_unlock(&ailp->ail_lock);
+		schedule();
+		spin_lock(&ailp->ail_lock);
+	}
+	spin_unlock(&ailp->ail_lock);
+
+	finish_wait(&ailp->ail_empty, &wait);
+}
+
+void
+__xfs_ail_assign_tail_lsn(
+	struct xfs_ail		*ailp)
+{
+	struct xlog		*log = ailp->ail_log;
+	xfs_lsn_t		tail_lsn;
+
+	assert_spin_locked(&ailp->ail_lock);
+
+	if (xlog_is_shutdown(log))
+		return;
+
+	tail_lsn = __xfs_ail_min_lsn(ailp);
+	if (!tail_lsn)
+		tail_lsn = ailp->ail_head_lsn;
+
+	WRITE_ONCE(log->l_tail_space,
+			xlog_lsn_sub(log, ailp->ail_head_lsn, tail_lsn));
+	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
+	atomic64_set(&log->l_tail_lsn, tail_lsn);
+}
+
+/*
+ * Callers should pass the original tail lsn so that we can detect if the tail
+ * has moved as a result of the operation that was performed. If the caller
+ * needs to force a tail space update, it should pass NULLCOMMITLSN to bypass
+ * the "did the tail LSN change?" checks. If the caller wants to avoid a tail
+ * update (e.g. it knows the tail did not change) it should pass an @old_lsn of
+ * 0.
+ */
+void
+xfs_ail_update_finish(
+	struct xfs_ail		*ailp,
+	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
+{
+	struct xlog		*log = ailp->ail_log;
+
+	/* If the tail lsn hasn't changed, don't do updates or wakeups. */
+	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
+		spin_unlock(&ailp->ail_lock);
+		return;
+	}
+
+	__xfs_ail_assign_tail_lsn(ailp);
+	if (list_empty(&ailp->ail_head))
+		wake_up_all(&ailp->ail_empty);
+	spin_unlock(&ailp->ail_lock);
+	xfs_log_space_wake(log->l_mp);
+}
+
+/*
+ * xfs_trans_ail_update_bulk - bulk AIL insertion operation.
+ *
+ * @xfs_trans_ail_update_bulk takes an array of log items that all need to be
+ * positioned at the same LSN in the AIL. If an item is not in the AIL, it will
+ * be added. Otherwise, it will be repositioned by removing it and re-adding
+ * it to the AIL.
+ *
+ * If we move the first item in the AIL, update the log tail to match the new
+ * minimum LSN in the AIL.
+ *
+ * This function should be called with the AIL lock held.
+ *
+ * To optimise the insert operation, we add all items to a temporary list, then
+ * splice this list into the correct position in the AIL.
+ *
+ * Items that are already in the AIL are first deleted from their current
+ * location before being added to the temporary list.
+ *
+ * This avoids needing to do an insert operation on every item.
+ *
+ * The AIL lock is dropped by xfs_ail_update_finish() before returning to
+ * the caller.
+ */
+void
+xfs_trans_ail_update_bulk(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	struct xfs_log_item	**log_items,
+	int			nr_items,
+	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
+{
+	struct xfs_log_item	*mlip;
+	xfs_lsn_t		tail_lsn = 0;
+	int			i;
+	LIST_HEAD(tmp);
+
+	ASSERT(nr_items > 0);		/* Not required, but true. */
+	mlip = xfs_ail_min(ailp);
+
+	for (i = 0; i < nr_items; i++) {
+		struct xfs_log_item *lip = log_items[i];
+		if (test_and_set_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
+			/* check if we really need to move the item */
+			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
+				continue;
+
+			trace_xfs_ail_move(lip, lip->li_lsn, lsn);
+			if (mlip == lip && !tail_lsn)
+				tail_lsn = lip->li_lsn;
+
+			xfs_ail_delete(ailp, lip);
+		} else {
+			trace_xfs_ail_insert(lip, 0, lsn);
+		}
+		lip->li_lsn = lsn;
+		list_add_tail(&lip->li_ail, &tmp);
+	}
+
+	if (!list_empty(&tmp))
+		xfs_ail_splice(ailp, cur, &tmp, lsn);
+
+	/*
+	 * If this is the first insert, wake up the push daemon so it can
+	 * actively scan for items to push. We also need to do a log tail
+	 * LSN update to ensure that it is correctly tracked by the log, so
+	 * set the tail_lsn to NULLCOMMITLSN so that xfs_ail_update_finish()
+	 * will see that the tail lsn has changed and will update the tail
+	 * appropriately.
+	 */
+	if (!mlip) {
+		wake_up_process(ailp->ail_task);
+		tail_lsn = NULLCOMMITLSN;
+	}
+
+	xfs_ail_update_finish(ailp, tail_lsn);
+}
+
+/* Insert a log item into the AIL. */
+void
+xfs_trans_ail_insert(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	spin_lock(&ailp->ail_lock);
+	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
+}
+
+/*
+ * Delete one log item from the AIL.
+ *
+ * If this item was at the tail of the AIL, return the LSN of the log item so
+ * that we can use it to check if the LSN of the tail of the log has moved
+ * when finishing up the AIL delete process in xfs_ail_update_finish().
+ */
+xfs_lsn_t
+xfs_ail_delete_one(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
+	xfs_lsn_t		lsn = lip->li_lsn;
+
+	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
+	xfs_ail_delete(ailp, lip);
+	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
+	lip->li_lsn = 0;
+
+	if (mlip == lip)
+		return lsn;
+	return 0;
+}
+
+void
+xfs_trans_ail_delete(
+	struct xfs_log_item	*lip,
+	int			shutdown_type)
+{
+	struct xfs_ail		*ailp = lip->li_ailp;
+	struct xlog		*log = ailp->ail_log;
+	xfs_lsn_t		tail_lsn;
+
+	spin_lock(&ailp->ail_lock);
+	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
+		spin_unlock(&ailp->ail_lock);
+		if (shutdown_type && !xlog_is_shutdown(log)) {
+			xfs_alert_tag(log->l_mp, XFS_PTAG_AILDELETE,
+	"%s: attempting to delete a log item that is not in the AIL",
+					__func__);
+			xlog_force_shutdown(log, shutdown_type);
+		}
+		return;
+	}
+
+	clear_bit(XFS_LI_FAILED, &lip->li_flags);
+	tail_lsn = xfs_ail_delete_one(ailp, lip);
+	xfs_ail_update_finish(ailp, tail_lsn);	/* drops the AIL lock */
+}
+
+int
+xfs_trans_ail_init(
+	xfs_mount_t	*mp)
+{
+	struct xfs_ail	*ailp;
+
+	ailp = kzalloc_obj(struct xfs_ail, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	if (!ailp)
+		return -ENOMEM;
+
+	ailp->ail_log = mp->m_log;
+	INIT_LIST_HEAD(&ailp->ail_head);
+	INIT_LIST_HEAD(&ailp->ail_cursors);
+	spin_lock_init(&ailp->ail_lock);
+	INIT_LIST_HEAD(&ailp->ail_buf_list);
+	init_waitqueue_head(&ailp->ail_empty);
+
+	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
+				mp->m_super->s_id);
+	if (IS_ERR(ailp->ail_task))
+		goto out_free_ailp;
+
+	mp->m_ail = ailp;
+	return 0;
+
+out_free_ailp:
+	kfree(ailp);
+	return -ENOMEM;
+}
+
+void
+xfs_trans_ail_destroy(
+	xfs_mount_t	*mp)
+{
+	struct xfs_ail	*ailp = mp->m_ail;
+
+	kthread_stop(ailp->ail_task);
+	kfree(ailp);
+}
diff --git a/libxlog/xfs_trans_priv.h b/libxlog/xfs_trans_priv.h
new file mode 100644
index 00000000..f945f045
--- /dev/null
+++ b/libxlog/xfs_trans_priv.h
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_TRANS_PRIV_H__
+#define	__XFS_TRANS_PRIV_H__
+
+struct xlog;
+struct xfs_log_item;
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_ail;
+struct xfs_log_vec;
+
+
+void	xfs_trans_init(struct xfs_mount *);
+void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
+void	xfs_trans_del_item(struct xfs_log_item *);
+void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
+
+/*
+ * AIL traversal cursor.
+ *
+ * Rather than using a generation number for detecting changes in the ail, use
+ * a cursor that is protected by the ail lock. The aild cursor exists in the
+ * struct xfs_ail, but other traversals can declare it on the stack and link it
+ * to the ail list.
+ *
+ * When an object is deleted from or moved int the AIL, the cursor list is
+ * searched to see if the object is a designated cursor item. If it is, it is
+ * deleted from the cursor so that the next time the cursor is used traversal
+ * will return to the start.
+ *
+ * This means a traversal colliding with a removal will cause a restart of the
+ * list scan, rather than any insertion or deletion anywhere in the list. The
+ * low bit of the item pointer is set if the cursor has been invalidated so
+ * that we can tell the difference between invalidation and reaching the end
+ * of the list to trigger traversal restarts.
+ */
+struct xfs_ail_cursor {
+	struct list_head	list;
+	struct xfs_log_item	*item;
+};
+
+/*
+ * Private AIL structures.
+ *
+ * Eventually we need to drive the locking in here as well.
+ */
+struct xfs_ail {
+	struct xlog		*ail_log;
+	struct task_struct	*ail_task;
+	struct list_head	ail_head;
+	struct list_head	ail_cursors;
+	spinlock_t		ail_lock;
+	xfs_lsn_t		ail_last_pushed_lsn;
+	xfs_lsn_t		ail_head_lsn;
+	int			ail_log_flush;
+	unsigned long		ail_opstate;
+	struct list_head	ail_buf_list;
+	wait_queue_head_t	ail_empty;
+	xfs_lsn_t		ail_target;
+};
+
+/* Push all items out of the AIL immediately. */
+#define XFS_AIL_OPSTATE_PUSH_ALL	0u
+
+/*
+ * From xfs_trans_ail.c
+ */
+void	xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
+				struct xfs_ail_cursor *cur,
+				struct xfs_log_item **log_items, int nr_items,
+				xfs_lsn_t lsn) __releases(ailp->ail_lock);
+/*
+ * Return a pointer to the first item in the AIL.  If the AIL is empty, then
+ * return NULL.
+ */
+static inline struct xfs_log_item *
+xfs_ail_min(
+	struct xfs_ail  *ailp)
+{
+	return list_first_entry_or_null(&ailp->ail_head, struct xfs_log_item,
+					li_ail);
+}
+
+static inline void
+xfs_trans_ail_update(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
+{
+	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
+}
+
+void xfs_trans_ail_insert(struct xfs_ail *ailp, struct xfs_log_item *lip,
+		xfs_lsn_t lsn);
+
+xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
+void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
+			__releases(ailp->ail_lock);
+void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
+
+static inline void xfs_ail_push(struct xfs_ail *ailp)
+{
+	wake_up_process(ailp->ail_task);
+}
+
+static inline void xfs_ail_push_all(struct xfs_ail *ailp)
+{
+	if (!test_and_set_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate))
+		xfs_ail_push(ailp);
+}
+
+static inline xfs_lsn_t xfs_ail_get_push_target(struct xfs_ail *ailp)
+{
+	return READ_ONCE(ailp->ail_target);
+}
+
+void			xfs_ail_push_all_sync(struct xfs_ail *ailp);
+xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
+
+struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
+					struct xfs_ail_cursor *cur,
+					xfs_lsn_t lsn);
+struct xfs_log_item *	xfs_trans_ail_cursor_last(struct xfs_ail *ailp,
+					struct xfs_ail_cursor *cur,
+					xfs_lsn_t lsn);
+struct xfs_log_item *	xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
+					struct xfs_ail_cursor *cur);
+void			xfs_trans_ail_cursor_done(struct xfs_ail_cursor *cur);
+
+void			__xfs_ail_assign_tail_lsn(struct xfs_ail *ailp);
+
+static inline void
+xfs_ail_assign_tail_lsn(
+	struct xfs_ail		*ailp)
+{
+
+	spin_lock(&ailp->ail_lock);
+	__xfs_ail_assign_tail_lsn(ailp);
+	spin_unlock(&ailp->ail_lock);
+}
+
+#if BITS_PER_LONG != 64
+static inline void
+xfs_trans_ail_copy_lsn(
+	struct xfs_ail	*ailp,
+	xfs_lsn_t	*dst,
+	xfs_lsn_t	*src)
+{
+	ASSERT(sizeof(xfs_lsn_t) == 8);	/* don't lock if it shrinks */
+	spin_lock(&ailp->ail_lock);
+	*dst = *src;
+	spin_unlock(&ailp->ail_lock);
+}
+#else
+static inline void
+xfs_trans_ail_copy_lsn(
+	struct xfs_ail	*ailp,
+	xfs_lsn_t	*dst,
+	xfs_lsn_t	*src)
+{
+	ASSERT(sizeof(xfs_lsn_t) == 8);
+	*dst = *src;
+}
+#endif
+
+#endif	/* __XFS_TRANS_PRIV_H__ */
-- 
2.47.3

