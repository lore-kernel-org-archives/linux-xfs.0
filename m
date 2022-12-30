Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9DAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiLaDYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiLaDYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:24:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF9A12A91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4824AB81E72
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E526BC433EF;
        Sat, 31 Dec 2022 03:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457040;
        bh=J6YR8zRhJZpruZtP2FPE/x3eJQnoO3RVhVoJKE2lQdk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=niCtc2EP/5bFqc5WurCX165b6Bxf9WDgEfW8Dj0GGwDWSeEH/r0GsBBappEdRP7Ry
         98MhGXV0w4UwTCGCrvF7MR2uSYs2lprv7HFjf2BEaZEPUcmO4whK0ZjmYem23Fy4f2
         80iNn8QgGFvv7k15rtAVuIRqlUw+ZovyQmzMjKe2MsYpl61iuusIN+AlNoI2NS2iaS
         Fxigewb21oRUu2M+ErelVBp3YD83q65GkJqParb3/KXufHRI/ldvhw9vUprUTwkPT3
         rnl7Ucq90mpTzteY89hvolV1pd5uTWRGOjsHglsSt592cIvvc3yYnZSCDuHST0aWrq
         W9Xh5Q+oHij9Q==
Subject: [PATCH 3/3] xfs: introduce vectored scrub mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876406.726950.13442781363007487800.stgit@magnolia>
In-Reply-To: <167243876361.726950.2109456102182372814.stgit@magnolia>
References: <167243876361.726950.2109456102182372814.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Introduce a variant on XFS_SCRUB_METADATA that allows for vectored mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h   |   37 ++++++++++++
 fs/xfs/scrub/scrub.c     |  148 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h     |   78 ++++++++++++++++++++++++
 fs/xfs/scrub/xfs_scrub.h |    2 +
 fs/xfs/xfs_ioctl.c       |   47 +++++++++++++++
 5 files changed, 311 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 453b08612256..067dd0b1315b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -751,6 +751,15 @@ struct xfs_scrub_metadata {
 /* Number of scrub subcommands. */
 #define XFS_SCRUB_TYPE_NR	32
 
+/*
+ * This special type code only applies to the vectored scrub implementation.
+ *
+ * If any of the previous scrub vectors recorded runtime errors or have
+ * sv_flags bits set that match the OFLAG bits in the barrier vector's
+ * sv_flags, set the barrier's sv_ret to -ECANCELED and return to userspace.
+ */
+#define XFS_SCRUB_TYPE_BARRIER	(-1U)
+
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
 
@@ -795,6 +804,33 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+struct xfs_scrub_vec {
+	__u32 sv_type;		/* XFS_SCRUB_TYPE_* */
+	__u32 sv_flags;		/* XFS_SCRUB_FLAGS_* */
+	__s32 sv_ret;		/* 0 or a negative error code */
+	__u32 sv_reserved;	/* must be zero */
+};
+
+/* Vectored metadata scrub control structure. */
+struct xfs_scrub_vec_head {
+	__u64 svh_ino;		/* inode number. */
+	__u32 svh_gen;		/* inode generation. */
+	__u32 svh_agno;		/* ag number. */
+	__u32 svh_flags;	/* XFS_SCRUB_VEC_FLAGS_* */
+	__u16 svh_rest_us;	/* wait this much time between vector items */
+	__u16 svh_nr;		/* number of svh_vecs */
+
+	struct xfs_scrub_vec svh_vecs[0];
+};
+
+#define XFS_SCRUB_VEC_FLAGS_ALL		(0)
+
+static inline size_t sizeof_xfs_scrub_vec(unsigned int nr)
+{
+	return sizeof(struct xfs_scrub_vec_head) +
+		nr * sizeof(struct xfs_scrub_vec);
+}
+
 /*
  * ioctl limits
  */
@@ -839,6 +875,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+#define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 60, struct xfs_scrub_vec_head)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 62, struct xfs_rtgroup_geometry)
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 342a50248650..fc2cfef68366 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -20,6 +20,7 @@
 #include "xfs_rmap.h"
 #include "xfs_xchgrange.h"
 #include "xfs_swapext.h"
+#include "xfs_icache.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -726,3 +727,150 @@ xfs_scrub_metadata(
 	sc->flags |= XCHK_TRY_HARDER;
 	goto retry_op;
 }
+
+/* Decide if there have been any scrub failures up to this point. */
+static inline bool
+xfs_scrubv_previous_failures(
+	struct xfs_mount		*mp,
+	struct xfs_scrub_vec_head	*vhead,
+	struct xfs_scrub_vec		*barrier_vec)
+{
+	struct xfs_scrub_vec		*v;
+	__u32				failmask;
+
+	failmask = barrier_vec->sv_flags & XFS_SCRUB_FLAGS_OUT;
+
+	for (v = vhead->svh_vecs; v < barrier_vec; v++) {
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER)
+			continue;
+
+		/*
+		 * Runtime errors count as a previous failure, except the ones
+		 * used to ask userspace to retry.
+		 */
+		if (v->sv_ret && v->sv_ret != -EBUSY && v->sv_ret != -ENOENT &&
+		    v->sv_ret != -EUSERS)
+			return true;
+
+		/*
+		 * If any of the out-flags on the scrub vector match the mask
+		 * that was set on the barrier vector, that's a previous fail.
+		 */
+		if (v->sv_flags & failmask)
+			return true;
+	}
+
+	return false;
+}
+
+/* Vectored scrub implementation to reduce ioctl calls. */
+int
+xfs_scrubv_metadata(
+	struct file			*file,
+	struct xfs_scrub_vec_head	*vhead)
+{
+	struct xfs_inode		*ip_in = XFS_I(file_inode(file));
+	struct xfs_mount		*mp = ip_in->i_mount;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_scrub_vec		*v;
+	bool				set_dontcache = false;
+	unsigned int			i;
+	int				error = 0;
+
+	BUILD_BUG_ON(sizeof(struct xfs_scrub_vec_head) ==
+		     sizeof(struct xfs_scrub_metadata));
+	BUILD_BUG_ON(XFS_IOC_SCRUB_METADATA == XFS_IOC_SCRUBV_METADATA);
+
+	trace_xchk_scrubv_start(ip_in, vhead);
+
+	if (vhead->svh_flags & ~XFS_SCRUB_VEC_FLAGS_ALL)
+		return -EINVAL;
+	for (i = 0, v = vhead->svh_vecs; i < vhead->svh_nr; i++, v++) {
+		if (v->sv_reserved)
+			return -EINVAL;
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER &&
+		    (v->sv_flags & ~XFS_SCRUB_FLAGS_OUT))
+			return -EINVAL;
+
+		/*
+		 * If we detect at least one inode-type scrub, we might
+		 * consider setting dontcache at the end.
+		 */
+		if (v->sv_type < XFS_SCRUB_TYPE_NR &&
+		    meta_scrub_ops[v->sv_type].type == ST_INODE)
+			set_dontcache = true;
+
+		trace_xchk_scrubv_item(mp, vhead, v);
+	}
+
+	/*
+	 * If the caller provided us with a nonzero inode number that isn't the
+	 * ioctl file, try to grab a reference to it to eliminate all further
+	 * untrusted inode lookups.  If we can't get the inode, let each scrub
+	 * function try again.
+	 */
+	if (vhead->svh_ino != ip_in->i_ino) {
+		xfs_iget(mp, NULL, vhead->svh_ino, XFS_IGET_UNTRUSTED, 0, &ip);
+		if (ip && (VFS_I(ip)->i_generation != vhead->svh_gen ||
+			   (xfs_is_metadata_inode(ip) &&
+			    !S_ISDIR(VFS_I(ip)->i_mode)))) {
+			xfs_irele(ip);
+			ip = NULL;
+		}
+	}
+	if (!ip) {
+		if (!igrab(VFS_I(ip_in)))
+			return -EFSCORRUPTED;
+		ip = ip_in;
+	}
+
+	/* Run all the scrubbers. */
+	for (i = 0, v = vhead->svh_vecs; i < vhead->svh_nr; i++, v++) {
+		struct xfs_scrub_metadata	sm = {
+			.sm_type	= v->sv_type,
+			.sm_flags	= v->sv_flags,
+			.sm_ino		= vhead->svh_ino,
+			.sm_gen		= vhead->svh_gen,
+			.sm_agno	= vhead->svh_agno,
+		};
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			if (xfs_scrubv_previous_failures(mp, vhead, v)) {
+				v->sv_ret = -ECANCELED;
+				trace_xchk_scrubv_barrier_fail(mp, vhead, v);
+				break;
+			}
+
+			continue;
+		}
+
+		v->sv_ret = xfs_scrub_metadata(file, &sm);
+		v->sv_flags = sm.sm_flags;
+
+		/* Leave the inode in memory if something's wrong with it. */
+		if (xchk_needs_repair(&sm))
+			set_dontcache = false;
+
+		if (vhead->svh_rest_us) {
+			ktime_t		expires;
+
+			expires = ktime_add_ns(ktime_get(),
+					vhead->svh_rest_us * 1000);
+			set_current_state(TASK_KILLABLE);
+			schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+		}
+		if (fatal_signal_pending(current)) {
+			error = -EINTR;
+			break;
+		}
+	}
+
+	/*
+	 * If we're holding the only reference to this inode and the scan was
+	 * clean, mark it dontcache so that we don't pollute the cache.
+	 */
+	if (set_dontcache && atomic_read(&VFS_I(ip)->i_count) == 1)
+		d_mark_dontcache(VFS_I(ip));
+	xfs_irele(ip);
+	return error;
+}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0e945f842732..8767dd39b80c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -80,6 +80,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTREFCBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -113,7 +114,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTREFCBT);
 	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }, \
 	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }, \
 	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }, \
-	{ XFS_SCRUB_TYPE_RTREFCBT,	"rtrefcountbt" }
+	{ XFS_SCRUB_TYPE_RTREFCBT,	"rtrefcountbt" }, \
+	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }
 
 const char *xchk_type_string(unsigned int type);
 
@@ -213,6 +215,80 @@ DEFINE_EVENT(xchk_fshook_class, name, \
 DEFINE_SCRUB_FSHOOK_EVENT(xchk_fshooks_enable);
 DEFINE_SCRUB_FSHOOK_EVENT(xchk_fshooks_disable);
 
+DECLARE_EVENT_CLASS(xchk_vector_head_class,
+	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_vec_head *vhead),
+	TP_ARGS(ip, vhead),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, inum)
+		__field(unsigned int, gen)
+		__field(unsigned int, flags)
+		__field(unsigned short, rest_us)
+		__field(unsigned short, nr_vecs)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->agno = vhead->svh_agno;
+		__entry->inum = vhead->svh_ino;
+		__entry->gen = vhead->svh_gen;
+		__entry->flags = vhead->svh_flags;
+		__entry->rest_us = vhead->svh_rest_us;
+		__entry->nr_vecs = vhead->svh_nr;
+	),
+	TP_printk("dev %d:%d ino 0x%llx agno 0x%x inum 0x%llx gen 0x%x flags 0x%x rest_us %u nr_vecs %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->agno,
+		  __entry->inum,
+		  __entry->gen,
+		  __entry->flags,
+		  __entry->rest_us,
+		  __entry->nr_vecs)
+)
+#define DEFINE_SCRUBV_HEAD_EVENT(name) \
+DEFINE_EVENT(xchk_vector_head_class, name, \
+	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_vec_head *vhead), \
+	TP_ARGS(ip, vhead))
+
+DEFINE_SCRUBV_HEAD_EVENT(xchk_scrubv_start);
+
+DECLARE_EVENT_CLASS(xchk_vector_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_scrub_vec_head *vhead,
+		 struct xfs_scrub_vec *v),
+	TP_ARGS(mp, vhead, v),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, vec_nr)
+		__field(unsigned int, vec_type)
+		__field(unsigned int, vec_flags)
+		__field(int, vec_ret)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->vec_nr = v - vhead->svh_vecs;
+		__entry->vec_type = v->sv_type;
+		__entry->vec_flags = v->sv_flags;
+		__entry->vec_ret = v->sv_ret;
+	),
+	TP_printk("dev %d:%d vec[%u] type %s flags 0x%x ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->vec_nr,
+		  __print_symbolic(__entry->vec_type, XFS_SCRUB_TYPE_STRINGS),
+		  __entry->vec_flags,
+		  __entry->vec_ret)
+)
+#define DEFINE_SCRUBV_EVENT(name) \
+DEFINE_EVENT(xchk_vector_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_scrub_vec_head *vhead, \
+		 struct xfs_scrub_vec *v), \
+	TP_ARGS(mp, vhead, v))
+
+DEFINE_SCRUBV_EVENT(xchk_scrubv_barrier_fail);
+DEFINE_SCRUBV_EVENT(xchk_scrubv_item);
+
 TRACE_EVENT(xchk_op_error,
 	TP_PROTO(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		 xfs_agblock_t bno, int error, void *ret_ip),
diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
index 2ceae614ade8..bdf89242e6cd 100644
--- a/fs/xfs/scrub/xfs_scrub.h
+++ b/fs/xfs/scrub/xfs_scrub.h
@@ -8,8 +8,10 @@
 
 #ifndef CONFIG_XFS_ONLINE_SCRUB
 # define xfs_scrub_metadata(file, sm)	(-ENOTTY)
+# define xfs_scrubv_metadata(file, vhead)	(-ENOTTY)
 #else
 int xfs_scrub_metadata(struct file *file, struct xfs_scrub_metadata *sm);
+int xfs_scrubv_metadata(struct file *file, struct xfs_scrub_vec_head *vhead);
 #endif /* CONFIG_XFS_ONLINE_SCRUB */
 
 #endif	/* __XFS_SCRUB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index abca384c86a4..47704a7854cf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1643,6 +1643,51 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_scrubv_metadata(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_scrub_vec_head	__user *uhead = arg;
+	struct xfs_scrub_vec_head	head;
+	struct xfs_scrub_vec_head	*vhead;
+	size_t				bytes;
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&head, uhead, sizeof(head)))
+		return -EFAULT;
+
+	bytes = sizeof_xfs_scrub_vec(head.svh_nr);
+	if (bytes > PAGE_SIZE)
+		return -ENOMEM;
+	vhead = kvmalloc(bytes, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	if (!vhead)
+		return -ENOMEM;
+	memcpy(vhead, &head, sizeof(struct xfs_scrub_vec_head));
+
+	if (copy_from_user(&vhead->svh_vecs, &uhead->svh_vecs,
+				head.svh_nr * sizeof(struct xfs_scrub_vec))) {
+		error = -EFAULT;
+		goto err_free;
+	}
+
+	error = xfs_scrubv_metadata(filp, vhead);
+	if (error)
+		goto err_free;
+
+	if (copy_to_user(uhead, vhead, bytes)) {
+		error = -EFAULT;
+		goto err_free;
+	}
+
+err_free:
+	kvfree(vhead);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	struct xfs_swapext	*sxp)
@@ -1908,6 +1953,8 @@ xfs_file_ioctl(
 	case FS_IOC_GETFSMAP:
 		return xfs_ioc_getfsmap(ip, arg);
 
+	case XFS_IOC_SCRUBV_METADATA:
+		return xfs_ioc_scrubv_metadata(filp, arg);
 	case XFS_IOC_SCRUB_METADATA:
 		return xfs_ioc_scrub_metadata(filp, arg);
 

