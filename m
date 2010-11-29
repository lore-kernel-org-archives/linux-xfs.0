Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT9EVCF136008 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 03:14:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E12F21C6243B
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 01:16:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PrNrh57qsyPj06BY for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 01:16:13 -0800 (PST)
Date: Mon, 29 Nov 2010 04:16:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: use generic per-cpu counter infrastructure
Message-ID: <20101129091610.GA13902@infradead.org>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
	<1290991002-18680-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290991002-18680-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 11:36:40AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has a per-cpu counter implementation for in-core superblock
> counters that pre-dated the generic implementation. It is complex
> and baroque as it is tailored directly to the needs of ENOSPC
> detection.
> 
> Now that the generic percpu counter infrastructure has the
> percpu_counter_add_unless_lt() function that implements the
> necessary threshold checks for us, switch the XFS per-cpu
> superblock counters to use the generic percpu counter
> infrastructure.

Looks good, but a few comments below:

> +/*
> + * Per-cpu incore superblock counters
> + *
> + * Simple concept, difficult implementation, now somewhat simplified by generic
> + * per-cpu counter support.  This provides distributed per cpu counters for
> + * contended fields (e.g.  free block count).

The kind of historic comments like now simplified by  .. don't make any
sense after only a short while.  I'd just remove the first senstence
above, as the details of the problems are explained much better later.

> +static inline int
> +xfs_icsb_add(
> +	struct xfs_mount	*mp,
> +	int			counter,
> +	int64_t			delta,
> +	int64_t			threshold)
> +{
> +	int			ret;
> +
> +	ret = percpu_counter_add_unless_lt(&mp->m_icsb[counter], delta,
> +								threshold);
> +	if (ret < 0)
> +		return -ENOSPC;
> +	return 0;
> +}
> +
> +static inline void
> +xfs_icsb_set(
> +	struct xfs_mount	*mp,
> +	int			counter,
> +	int64_t			value)
> +{
> +	percpu_counter_set(&mp->m_icsb[counter], value);
> +}
> +
> +static inline int64_t
> +xfs_icsb_sum(
> +	struct xfs_mount	*mp,
> +	int			counter)
> +{
> +	return percpu_counter_sum_positive(&mp->m_icsb[counter]);
> +}

I still don't like these wrappers.  They are all local to xfs_mount.c,
and only have a single function calling them.  See the RFC patch below
which removes them, and imho makes the code more readable.  Especially
in xfs _add case where we can get rid of one level of error remapping,
and go directly from the weird percpu return values to the positive
xfs errors instead of doing a detour via the negative linux errors.

> +static inline int64_t
> +xfs_icsb_read(
> +	struct xfs_mount	*mp,
> +	int			counter)
> +{
> +	return percpu_counter_read_positive(&mp->m_icsb[counter]);
> +}

this one is entirely unused.

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-11-29 09:43:31.423011248 +0100
+++ xfs/fs/xfs/xfs_mount.c	2010-11-29 09:56:32.546255345 +0100
@@ -282,54 +282,14 @@ xfs_free_perag(
  * so we only need to modify the fast path to handle per-cpu counter error
  * cases.
  */
-static inline int
-xfs_icsb_add(
-	struct xfs_mount	*mp,
-	int			counter,
-	int64_t			delta,
-	int64_t			threshold)
-{
-	int			ret;
-
-	ret = percpu_counter_add_unless_lt(&mp->m_icsb[counter], delta,
-								threshold);
-	if (ret < 0)
-		return -ENOSPC;
-	return 0;
-}
-
-static inline void
-xfs_icsb_set(
-	struct xfs_mount	*mp,
-	int			counter,
-	int64_t			value)
-{
-	percpu_counter_set(&mp->m_icsb[counter], value);
-}
-
-static inline int64_t
-xfs_icsb_sum(
-	struct xfs_mount	*mp,
-	int			counter)
-{
-	return percpu_counter_sum_positive(&mp->m_icsb[counter]);
-}
-
-static inline int64_t
-xfs_icsb_read(
-	struct xfs_mount	*mp,
-	int			counter)
-{
-	return percpu_counter_read_positive(&mp->m_icsb[counter]);
-}
-
 void
 xfs_icsb_reinit_counters(
 	struct xfs_mount	*mp)
 {
-	xfs_icsb_set(mp, XFS_ICSB_FDBLOCKS, mp->m_sb.sb_fdblocks);
-	xfs_icsb_set(mp, XFS_ICSB_IFREE, mp->m_sb.sb_ifree);
-	xfs_icsb_set(mp, XFS_ICSB_ICOUNT, mp->m_sb.sb_icount);
+	percpu_counter_set(&mp->m_icsb[XFS_ICSB_FDBLOCKS],
+			   mp->m_sb.sb_fdblocks);
+	percpu_counter_set(&mp->m_icsb[XFS_ICSB_IFREE], mp->m_sb.sb_ifree);
+	percpu_counter_set(&mp->m_icsb[XFS_ICSB_ICOUNT], mp->m_sb.sb_icount);
 }
 
 int
@@ -368,9 +328,12 @@ xfs_icsb_sync_counters(
 	xfs_mount_t	*mp)
 {
 	assert_spin_locked(&mp->m_sb_lock);
-	mp->m_sb.sb_icount = xfs_icsb_sum(mp, XFS_ICSB_ICOUNT);
-	mp->m_sb.sb_ifree = xfs_icsb_sum(mp, XFS_ICSB_IFREE);
-	mp->m_sb.sb_fdblocks = xfs_icsb_sum(mp, XFS_ICSB_FDBLOCKS);
+	mp->m_sb.sb_icount =
+		percpu_counter_sum_positive(&mp->m_icsb[XFS_ICSB_ICOUNT]);
+	mp->m_sb.sb_ifree =
+		percpu_counter_sum_positive(&mp->m_icsb[XFS_ICSB_IFREE]);
+	mp->m_sb.sb_fdblocks =
+		percpu_counter_sum_positive(&mp->m_icsb[XFS_ICSB_FDBLOCKS]);
 }
 
 /*
@@ -1953,7 +1916,7 @@ xfs_icsb_modify_counters(
 
 	switch (field) {
 	case XFS_SBS_ICOUNT:
-		ret = xfs_icsb_add(mp, cntr, delta, 0);
+		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_SBS_ICOUNT], delta, 0);
 		if (ret < 0) {
 			ASSERT(0);
 			return XFS_ERROR(EINVAL);
@@ -1961,7 +1924,7 @@ xfs_icsb_modify_counters(
 		return 0;
 
 	case XFS_SBS_IFREE:
-		ret = xfs_icsb_add(mp, XFS_ICSB_IFREE, delta, 0);
+		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_SBS_IFREE], delta, 0);
 		if (ret < 0) {
 			ASSERT(0);
 			return XFS_ERROR(EINVAL);
@@ -1990,13 +1953,12 @@ xfs_icsb_modify_counters(
 		}
 
 		/* try the change */
-		ret = xfs_icsb_add(mp, XFS_ICSB_FDBLOCKS, delta,
-						XFS_ALLOC_SET_ASIDE(mp));
+		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_ICSB_FDBLOCKS],
+						   delta, XFS_ALLOC_SET_ASIDE(mp));
 		if (likely(ret >= 0))
 			return 0;
 
 		/* ENOSPC */
-		ASSERT(ret == -ENOSPC);
 		ASSERT(delta < 0);
 
 		if (!rsvd)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
