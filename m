Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A866CBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boa49uWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA4BC433C7;
	Sun, 31 Dec 2023 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056430;
	bh=so0/pz+sXc6KpOm5oAbmhhDo/ESVpTM7tx8rPvxDkcY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=boa49uWko0P7qQl1gMkKbE0jyrgT89NQrjjUjjcN9yVzzyT5zRJVQ35Vn97t6f3aS
	 8hiqtHze/P/DzLJZNzX05N9trDWEvabRS6+E6qaG1x27eCq6YNXK1R9MDYmFsSksNL
	 CdC34EeElXtdFPP7utTZ3qmjmE8rxvM8Gy0YBN8CqdSD9phtIi8DS2b002kSjR/F92
	 eqsvYMmSWYVB36PbIXm/rFNwFdEyclJf8wcKnE46edWIcP1K0AAeSd4pETiQ1F6jN6
	 k+Y3HHgybd0AcN+SvzV5HxWVDHfKpzoWna46+Dt2JbPnVE6jPIVXgbr4+O+Ot5qzhy
	 viUhQpFkYdefQ==
Date: Sun, 31 Dec 2023 13:00:29 -0800
Subject: [PATCH 2/3] xfs: introduce vectored scrub mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842896.1758126.2465786099675496546.stgit@frogsfrogsfrogs>
In-Reply-To: <170404842857.1758126.13889834380054922462.stgit@frogsfrogsfrogs>
References: <170404842857.1758126.13889834380054922462.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Introduce a variant on XFS_SCRUB_METADATA that allows for a vectored
mode.  The caller specifies the principal metadata object that they want
to scrub (allocation group, inode, etc.) once, followed by an array of
scrub types they want called on that object.  The kernel runs the scrub
operations and writes the output flags and errno code to the
corresponding array element.

A new pseudo scrub type BARRIER is introduced to force the kernel to
return to userspace if any corruptions have been found when scrubbing
the previous scrub types in the array.  This enables userspace to
schedule, for example, the sequence:

 1. data fork
 2. barrier
 3. directory

If the data fork scrub is clean, then the kernel will perform the
directory scrub.  If not, the barrier in 2 will exit back to userspace.

When running fstests in "rebuild all metadata after each test" mode, I
observed a 10% reduction in runtime due to fewer transitions across the
system call boundary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h         |   10 ++++
 fs/xfs/libxfs/xfs_fs_staging.h |   32 ++++++++++++
 fs/xfs/scrub/scrub.c           |  106 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h           |   78 +++++++++++++++++++++++++++++
 fs/xfs/scrub/xfs_scrub.h       |    2 +
 fs/xfs/xfs_ioctl.c             |   50 +++++++++++++++++++
 6 files changed, 277 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2499a20f5f774..77fbca573e164 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -725,6 +725,15 @@ struct xfs_scrub_metadata {
 /* Number of scrub subcommands. */
 #define XFS_SCRUB_TYPE_NR	29
 
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
 
@@ -813,6 +822,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+/*	XFS_IOC_SCRUBV_METADATA -- staging 60	   */
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 /*	XFS_IOC_GETPARENTS ---- staging 62         */
 
diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index e0650af055895..69d29f213af3a 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
@@ -170,4 +170,36 @@ xfs_getparents_rec(
 
 #define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 
+/* Vectored scrub calls to reduce the number of kernel transitions. */
+
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
+	__u64 svh_reserved;	/* must be zero */
+
+	struct xfs_scrub_vec svh_vecs[];
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
+#define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 60, struct xfs_scrub_vec_head)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8874c28c2e7a8..1a0018537b054 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -21,6 +21,7 @@
 #include "xfs_swapext.h"
 #include "xfs_dir2.h"
 #include "xfs_parent.h"
+#include "xfs_icache.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -727,3 +728,108 @@ xfs_scrub_metadata(
 	run.retries++;
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
+	struct xfs_scrub_vec		*v;
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
+		trace_xchk_scrubv_item(mp, vhead, v);
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
+	return error;
+}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cf209ac9b5329..cc2af405cd3a7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -80,6 +80,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -110,7 +111,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
-	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }
+	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
+	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -210,6 +212,80 @@ DEFINE_EVENT(xchk_fsgate_class, name, \
 DEFINE_SCRUB_FSHOOK_EVENT(xchk_fsgates_enable);
 DEFINE_SCRUB_FSHOOK_EVENT(xchk_fsgates_disable);
 
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
+	TP_printk("dev %d:%d vec[%u] type %s flags %s ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->vec_nr,
+		  __print_symbolic(__entry->vec_type, XFS_SCRUB_TYPE_STRINGS),
+		  __print_flags(__entry->vec_flags, "|", XFS_SCRUB_FLAG_STRINGS),
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
index a39befa743ce0..61d010f19f003 100644
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
index 5db70a11151dd..a0dfefdf4c491 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1936,6 +1936,54 @@ xfs_ioc_setlabel(
 	return error;
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
+	if (head.svh_reserved)
+		return -EINVAL;
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
 static inline int
 xfs_fs_eofblocks_from_user(
 	struct xfs_fs_eofblocks		*src,
@@ -2099,6 +2147,8 @@ xfs_file_ioctl(
 	case FS_IOC_GETFSMAP:
 		return xfs_ioc_getfsmap(ip, arg);
 
+	case XFS_IOC_SCRUBV_METADATA:
+		return xfs_ioc_scrubv_metadata(filp, arg);
 	case XFS_IOC_SCRUB_METADATA:
 		return xfs_ioc_scrub_metadata(filp, arg);
 

