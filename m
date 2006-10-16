Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 02:13:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9G9DhaG004806
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 02:13:48 -0700
Date: Mon, 16 Oct 2006 19:12:51 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20060929032856.8DA9C18001A5E@sandeen.net>
References: <20060929032856.8DA9C18001A5E@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net, xfs@oss.sgi.com

Okay, started looking :-)

Some comments below...

--Tim

--On 28 September 2006 10:28:56 PM -0500 sandeen@sandeen.net wrote:

> Make things static which can be.
>
>  linux-2.4/xfs_vfs.c   |    2 -
>  linux-2.4/xfs_vfs.h   |    1
>  linux-2.4/xfs_vnode.c |    2 -
>  linux-2.6/xfs_vfs.c   |    2 -
>  linux-2.6/xfs_vfs.h   |    1
>  linux-2.6/xfs_vnode.c |    2 -
>  quota/xfs_dquot.c     |    2 -
>  quota/xfs_qm_bhv.c    |    2 -
>  xfs_attr.c            |    3 +-
>  xfs_attr.h            |    4 ---
>  xfs_bmap.c            |    5 +---
>  xfs_bmap_btree.c      |   52 ++++++++++++++++++++++++++------------------------
>  xfs_bmap_btree.h      |   10 ---------
>  xfs_btree.c           |    4 ++-
>  xfs_btree.h           |   12 +----------
>  xfs_dir2.h            |    4 ---
>  xfs_dir2_data.h       |    2 -
>  xfs_dir2_node.h       |    2 -
>  xfs_inode.c           |   49 ++++++++++++++++++++++++++++++-----------------
>  xfs_inode.h           |   29 +--------------------------
>  xfs_log_priv.h        |    7 ------
>  xfs_log_recover.c     |   10 ++++-----
>  xfs_mount.h           |    2 -
>  xfs_quota.h           |    2 -
>  xfs_trans_buf.c       |    2 -
>  25 files changed, 84 insertions(+), 129 deletions(-)
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> Index: xfs-linux/linux-2.4/xfs_vnode.c
> ===================================================================
> --- xfs-linux.orig/linux-2.4/xfs_vnode.c
> +++ xfs-linux/linux-2.4/xfs_vnode.c
> @@ -17,7 +17,7 @@
>  #include "xfs.h"
>
>  uint64_t vn_generation;		/* vnode generation number */
> -spinlock_t vnumber_lock = SPIN_LOCK_UNLOCKED;
> +static spinlock_t vnumber_lock = SPIN_LOCK_UNLOCKED;
>

Not STATIC? Curious.

>  /*
>   * Dedicated vnode inactive/reclaim sync semaphores.
> Index: xfs-linux/linux-2.6/xfs_vnode.c
> ===================================================================
> --- xfs-linux.orig/linux-2.6/xfs_vnode.c
> +++ xfs-linux/linux-2.6/xfs_vnode.c
> @@ -18,7 +18,7 @@
>  #include "xfs.h"
>
>  uint64_t vn_generation;		/* vnode generation number */
> -DEFINE_SPINLOCK(vnumber_lock);
> +static DEFINE_SPINLOCK(vnumber_lock);
>
Not STATIC?

>  /*
>   * Dedicated vnode inactive/reclaim sync semaphores.
> Index: xfs-linux/xfs_inode.c
> ===================================================================
> --- xfs-linux.orig/xfs_inode.c
> +++ xfs-linux/xfs_inode.c
> @@ -65,7 +65,22 @@ STATIC int xfs_iflush_int(xfs_inode_t *,
>  STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
>  STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
>  STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
> -
> +STATIC void xfs_iext_add_indirect_multi(xfs_ifork_t *, int, xfs_extnum_t, int);
> +STATIC void xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
> +STATIC void xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
> +STATIC void xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
> +STATIC void xfs_iext_inline_to_direct(xfs_ifork_t *, int);
> +STATIC void xfs_iext_realloc_direct(xfs_ifork_t *, int);
> +STATIC void xfs_iext_realloc_indirect(xfs_ifork_t *, int);
> +STATIC void xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
> +STATIC void xfs_iext_irec_init(xfs_ifork_t *);
> +STATIC void xfs_iext_irec_remove(xfs_ifork_t *, int);
> +STATIC void xfs_iext_irec_compact(xfs_ifork_t *);
> +STATIC void xfs_iext_irec_compact_pages(xfs_ifork_t *);
> +STATIC void xfs_iext_irec_compact_full(xfs_ifork_t *);
> +STATIC void xfs_iext_irec_update_extoffs(xfs_ifork_t *, int, int);
> +STATIC xfs_ext_irec_t *xfs_iext_bno_to_irec(xfs_ifork_t *, xfs_fileoff_t, int *);
> +STATIC xfs_ext_irec_t *xfs_iext_irec_new(xfs_ifork_t *, int);
>
Yeah, they all the xfs_iext_* seem to be local. see below...


>  #ifdef DEBUG
>  /*
> @@ -105,7 +120,7 @@ xfs_validate_extents(
>   * unlinked field of 0.
>   */
>  #if defined(DEBUG)
> -void
> +STATIC void
>  xfs_inobp_check(

Yep.

>  	xfs_mount_t	*mp,
>  	xfs_buf_t	*bp)
> @@ -1268,7 +1283,7 @@ xfs_ialloc(
>   * at least do it for regular files.
>   */
>  #ifdef DEBUG
> -void
> +STATIC void
>  xfs_isize_check(

Yep.

>  	xfs_mount_t	*mp,
>  	xfs_inode_t	*ip,
> @@ -3621,7 +3636,7 @@ xfs_iaccess(
>  /*
>   * xfs_iroundup: round up argument to next power of two
>   */
> -uint
> +STATIC uint
>  xfs_iroundup(

Yep.

>  	uint	v)
>  {
> @@ -3834,7 +3849,7 @@ xfs_iext_add(
>   *    | count |   | nex2  |    nex2 - number of extents after idx + count
>   *    |-------|   |-------|
>   */
> -void
> +STATIC void
>  xfs_iext_add_indirect_multi(

Yep for all xfs_iext_ funcs.

Well actually it looks like xfs_bmap.c uses these:
--------------------
xfs_iext_add
xfs_iext_bno_to_ext
xfs_iext_get_ext
xfs_iext_insert
xfs_iext_remove
---------------------

So I'm not sure why some are still here...
xfs_iext_destroy
xfs_iext_idx_to_irec
xfs_iext_realloc  (only exists in header???)

--Tim
