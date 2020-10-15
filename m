Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF5AC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC5A22264
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n0myjy1R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJORqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 13:46:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgJORqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 13:46:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHdreO041422;
        Thu, 15 Oct 2020 17:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qL3s5oitclbzzt5Nb1Yw85AAx6B247eMdVz3DTDw4rg=;
 b=n0myjy1Ro9ktXw62T1nLkd+xd+/i7aVh6hD9EE/0TTawwKpI4ajMhs4Lhf7xMzy4Hb7i
 uyzmi/CBGwgw/osVQ8hGVAxNyXo+EaQkp2752U0VXURCqrLfdz5xBW9O3xLtKeERHneb
 Vn7QpSwT80owDjQuqCagWXiym2Bj5SO/wVYNMW63Ki9EQbciffl+QjYWViH3eMIpJpzM
 LkTQJ9ukIyPbYikdPnFYfkMCRSt96C5Nj5wwRkkOb9qo6QBj+o5pYAw+++DALI2dCG+D
 j27rK8HtqNl4N4CfLCuoBfBnIaNeDRS986XRk2ih1T+99pdGa4yCO9tX0MD0Cclj2w67 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vaemdyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 17:46:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHfLKT052284;
        Thu, 15 Oct 2020 17:46:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 343pv25cn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 17:46:22 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09FHkKK2022459;
        Thu, 15 Oct 2020 17:46:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 10:46:19 -0700
Date:   Thu, 15 Oct 2020 10:46:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/27] libxfs: introduce new buffer cache infrastructure
Message-ID: <20201015174618.GX9832@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-23-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=5 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=5 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150118
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have a separate buftarg infrastructure, we can introduce
> the kernel equivalent buffer cache infrastructure. This will
> (eventually) be shared with the kernel implementation, with all the
> differences being implemented in the private buftarg implementions.
> 
> Add the high level buffer lookup, IO and reference counting
> functions to libxfs/xfs_buf.c and the low level infrastructure this
> requires to libxfs/xfs_buftarg.c in preparation for switching the
> entire of xfsprogs over to using the new infrastructure.
> 
> The eventual shared kernel/userspace buffer definitions will end up
> in xfs_buf.h, so we start building that here to enable the code to
> compile and sort of function. It gets somewhat messy at this point,
> but patches after this can get on with switching over the cache
> implementation and cleaning up the mess.
> 
> Note: this uses an older xfs_buf.c from the kernel code, so there
> will be updates needed to bring it up to date once the initial
> conversion is complete.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/libxfs.h         |    1 +
>  include/xfs.h            |   23 +
>  include/xfs_mount.h      |    1 +
>  include/xfs_trace.h      |   24 +
>  libxfs/Makefile          |    2 +
>  libxfs/buftarg.c         |   54 +-
>  libxfs/libxfs_api_defs.h |    2 +
>  libxfs/libxfs_io.h       |   96 +--
>  libxfs/libxfs_priv.h     |   43 +-
>  libxfs/rdwr.c            |    4 +-
>  libxfs/xfs_buf.c         | 1350 ++++++++++++++++++++++++++++++++++++++
>  libxfs/xfs_buf.h         |  203 ++++++

Hmm, are you planning to move xfs_buf.c to libxfs in the kernel too?

>  libxfs/xfs_buftarg.h     |   31 +-
>  13 files changed, 1661 insertions(+), 173 deletions(-)
>  create mode 100644 libxfs/xfs_buf.c
>  create mode 100644 libxfs/xfs_buf.h
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 7dfc4d2fd3ab..d49f921a4429 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -52,6 +52,7 @@ struct iomap;
>   * every files via a similar include in the kernel xfs_linux.h.
>   */
>  #include "xfs_buftarg.h"
> +#include "xfs_buf.h"
>  #include "libxfs_io.h"
>  
>  #include "xfs_bit.h"
> diff --git a/include/xfs.h b/include/xfs.h
> index af0d36cef361..ae90eee7531e 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -38,6 +38,29 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  #endif
>  
> +/*
> + * Kernel side compiler address and barrier functionality we use
> + */
> +#ifdef __GNUC__
> +#define __return_address	__builtin_return_address(0)
> +
> +/*
> + * Return the address of a label.  Use barrier() so that the optimizer
> + * won't reorder code to refactor the error jumpouts into a single
> + * return, which throws off the reported address.
> + */
> +#define __this_address  ({ __label__ __here; __here: barrier(); &&__here; })
> +/* Optimization barrier */
> +
> +/* The "volatile" is due to gcc bugs */
> +#define barrier() __asm__ __volatile__("": : :"memory")
> +#endif
> +
> +/* Optimization barrier */
> +#ifndef barrier
> +# define barrier() __memory_barrier()
> +#endif
> +
>  #include <xfs/xfs_types.h>
>  /* Include deprecated/compat pre-vfs xfs-specific symbols */
>  #include <xfs/xfs_fs_compat.h>
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 114d9744d114..d72c011b46e6 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -157,6 +157,7 @@ typedef struct xfs_perag {
>  	/* reference count */
>  	uint8_t		pagf_refcount_level;
>  
> +	spinlock_t	pag_buf_lock;
>  	struct btcache	*pag_buf_hash;
>  } xfs_perag_t;
>  
> diff --git a/include/xfs_trace.h b/include/xfs_trace.h
> index 91f2b98b6c30..9dac4232bcc9 100644
> --- a/include/xfs_trace.h
> +++ b/include/xfs_trace.h
> @@ -312,4 +312,28 @@
>  #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
>  #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
>  
> +#define	trace_xfs_buf_init(...)			((void) 0)
> +#define	trace_xfs_buf_free(...)			((void) 0)

I started wondering if there was an easy way to hook all these up to
some kind of actual tracepoints, but uprobes still seem to require the
user to do /all/ the legwork of finding text offsets, decoding
registers, etc.  There seems to be some other library called usdt that
can create static dtrace tracepoints, but it doesn't exist in Debian
so... oh well.

--D

> +#define	trace_xfs_buf_find(...)			((void) 0)
> +#define	trace_xfs_buf_get(...)			((void) 0)
> +#define	trace_xfs_buf_read(...)			((void) 0)
> +#define	trace_xfs_buf_hold(...)			((void) 0)
> +#define	trace_xfs_buf_rele(...)			((void) 0)
> +#define	trace_xfs_buf_trylock(...)		((void) 0)
> +#define	trace_xfs_buf_trylock_fail(...)		((void) 0)
> +#define	trace_xfs_buf_lock(...)			((void) 0)
> +#define	trace_xfs_buf_lock_done(...)		((void) 0)
> +#define	trace_xfs_buf_unlock(...)		((void) 0)
> +#define	trace_xfs_buf_iodone(...)		((void) 0)
> +#define	trace_xfs_buf_ioerror(...)		((void) 0)
> +#define	trace_xfs_buf_iowait(...)		((void) 0)
> +#define	trace_xfs_buf_iowait_done(...)		((void) 0)
> +#define	trace_xfs_buf_submit(...)		((void) 0)
> +#define	trace_xfs_buf_wait_buftarg(...)		((void) 0)
> +#define	trace_xfs_buf_delwri_queued(...)	((void) 0)
> +#define	trace_xfs_buf_delwri_queue(...)		((void) 0)
> +#define	trace_xfs_buf_delwri_split(...)		((void) 0)
> +#define	trace_xfs_buf_delwri_pushbuf(...)	((void) 0)
> +#define	trace_xfs_buf_get_uncached(...)		((void) 0)
> +
>  #endif /* __TRACE_H__ */
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 7f2fc0f878e2..1f142fb36208 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -30,6 +30,7 @@ HFILES = \
>  	xfs_bmap_btree.h \
>  	xfs_btree.h \
>  	xfs_btree_staging.h \
> +	xfs_buf.h \
>  	xfs_buftarg.h \
>  	xfs_attr_remote.h \
>  	xfs_cksum.h \
> @@ -76,6 +77,7 @@ CFILES = buftarg.c \
>  	xfs_bmap_btree.c \
>  	xfs_btree.c \
>  	xfs_btree_staging.c \
> +	xfs_buf.c \
>  	xfs_da_btree.c \
>  	xfs_defer.c \
>  	xfs_dir2.c \
> diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
> index 6dc8e76d26ef..42806e433715 100644
> --- a/libxfs/buftarg.c
> +++ b/libxfs/buftarg.c
> @@ -104,45 +104,35 @@ xfs_buftarg_free(
>  }
>  
>  /*
> - * Low level IO routines
> + * Buffer memory buffer allocation routines
> + *
> + * Userspace just has a flat memory buffer, so it's quite simple compared
> + * to the kernel code.
>   */
> -static void
> -xfs_buf_ioend(
> +void
> +xfs_buf_free_memory(
>  	struct xfs_buf	*bp)
>  {
> -	bool		read = bp->b_flags & XBF_READ;
> -
> -//	printf("endio bn %ld l %d/%d, io err %d err %d f 0x%x\n", bp->b_maps[0].bm_bn,
> -//			bp->b_maps[0].bm_len, BBTOB(bp->b_length),
> -//			bp->b_io_error, bp->b_error, bp->b_flags);
> -
> -	bp->b_flags &= ~(XBF_READ | XBF_WRITE);
> -
> -	/*
> -	 * Pull in IO completion errors now. We are guaranteed to be running
> -	 * single threaded, so we don't need the lock to read b_io_error.
> -	 */
> -	if (!bp->b_error && bp->b_io_error)
> -		xfs_buf_ioerror(bp, bp->b_io_error);
> +	free(bp->b_addr);
> +}
>  
> -	/* Only validate buffers that were read without errors */
> -	if (read && !bp->b_error && bp->b_ops) {
> -		ASSERT(!bp->b_iodone);
> -		bp->b_ops->verify_read(bp);
> -	}
> +int
> +xfs_buf_allocate_memory(
> +	struct xfs_buf		*bp,
> +	uint			flags)
> +{
> +	size_t			size;
>  
> -	if (!bp->b_error) {
> -		bp->b_flags |= XBF_DONE;
> -		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> -	} else {
> -		fprintf(stderr,
> -			_("%s: IO failed on %s bno 0x%llx/0x%x, err=%d\n"),
> -			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
> -			(long long)bp->b_maps[0].bm_bn, bp->b_length,
> -			-bp->b_error);
> -	}
> +	size = BBTOB(bp->b_length);
> +	bp->b_addr = memalign(bp->b_target->bt_meta_sectorsize, size);
> +	if (!bp->b_addr)
> +		return -ENOMEM;
> +	return 0;
>  }
>  
> +/*
> + * Low level IO routines
> + */
>  static void
>  xfs_buf_complete_io(
>  	struct xfs_buf	*bp,
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index f4a31782020c..c45da9a2cd01 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -49,8 +49,10 @@
>  #define xfs_btree_init_block		libxfs_btree_init_block
>  #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
>  #define xfs_buf_get			libxfs_buf_get
> +#define xfs_buf_get_map			libxfs_buf_get_map
>  #define xfs_buf_get_uncached		libxfs_buf_get_uncached
>  #define xfs_buf_read			libxfs_buf_read
> +#define xfs_buf_read_map		libxfs_buf_read_map
>  #define xfs_buf_read_uncached		libxfs_buf_read_uncached
>  #define xfs_buf_relse			libxfs_buf_relse
>  #define xfs_bunmapi			libxfs_bunmapi
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index b4022a4e5dd8..3390b737fafe 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -10,7 +10,6 @@
>  /*
>   * Kernel equivalent buffer based I/O interface
>   */
> -
>  struct xfs_buf;
>  struct xfs_mount;
>  struct xfs_perag;
> @@ -20,60 +19,7 @@ void libxfs_open_devices(struct xfs_mount *mp, dev_t ddev,
>  			dev_t logdev, dev_t rtdev);
>  int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
>  
> -#define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
> -
> -#define XB_PAGES        2
> -struct xfs_buf_map {
> -	xfs_daddr_t		bm_bn;  /* block number for I/O */
> -	int			bm_len; /* size of I/O */
> -};
> -
> -#define DEFINE_SINGLE_BUF_MAP(map, blkno, numblk) \
> -	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
> -
> -struct xfs_buf_ops {
> -	char *name;
> -	union {
> -		__be32 magic[2];	/* v4 and v5 on disk magic values */
> -		__be16 magic16[2];	/* v4 and v5 on disk magic values */
> -	};
> -	void (*verify_read)(struct xfs_buf *);
> -	void (*verify_write)(struct xfs_buf *);
> -	xfs_failaddr_t (*verify_struct)(struct xfs_buf *);
> -};
> -
> -#define XFS_BSTATE_DISPOSE       (1 << 0)       /* buffer being discarded */
> -
> -struct xfs_buf {
> -	struct cache_node	b_node;
> -	struct list_head	b_hash;	/* will replace b_node */
> -	xfs_daddr_t		b_bn;
> -	unsigned int		b_length;
> -	unsigned int		b_flags;
> -	struct xfs_buftarg	*b_target;
> -	pthread_mutex_t		b_lock;
> -	pthread_t		b_holder;
> -	unsigned int		b_recur;
> -	void			*b_log_item;
> -	struct list_head	b_li_list;	/* Log items list head */
> -	void			*b_transp;
> -	void			*b_addr;
> -	int			b_error;
> -	const struct xfs_buf_ops *b_ops;
> -	struct xfs_perag	*b_pag;
> -	struct xfs_mount	*b_mount;
> -	struct xfs_buf_map	*b_maps;
> -	struct xfs_buf_map	__b_map;
> -	int			b_map_count;
> -	int			b_io_remaining;
> -	int			b_io_error;
> -	struct list_head	b_list;
> -
> -	struct list_head	b_btc_list;
> -	unsigned int		b_state;
> -	atomic_t		b_lru_ref;
> -	struct list_head	b_lru;
> -};
> +#define LIBXFS_BBTOOFF64(bbs)  (((xfs_off_t)(bbs)) << BBSHIFT)
>  
>  bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
>  bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
> @@ -93,9 +39,6 @@ typedef unsigned int xfs_buf_flags_t;
>  void libxfs_buf_set_priority(struct xfs_buf *bp, int priority);
>  int libxfs_buf_priority(struct xfs_buf *bp);
>  
> -#define xfs_buf_set_ref(bp,ref)		((void) 0)
> -#define xfs_buf_ioerror(bp,err)		((bp)->b_error = (err))
> -
>  #define xfs_daddr_to_agno(mp,d) \
>  	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
>  #define xfs_daddr_to_agbno(mp,d) \
> @@ -113,40 +56,9 @@ void libxfs_brelse(struct cache_node *node);
>  /* Return the buffer even if the verifiers fail. */
>  #define LIBXFS_READBUF_SALVAGE		(1 << 1)
>  
> -int libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
> -			int nmaps, int flags, struct xfs_buf **bpp,
> -			const struct xfs_buf_ops *ops);
>  void libxfs_buf_mark_dirty(struct xfs_buf *bp);
> -int libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
> -			int nmaps, int flags, struct xfs_buf **bpp);
>  void	libxfs_buf_relse(struct xfs_buf *bp);
>  
> -static inline int
> -libxfs_buf_get(
> -	struct xfs_buftarg	*target,
> -	xfs_daddr_t		blkno,
> -	size_t			numblks,
> -	struct xfs_buf		**bpp)
> -{
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -
> -	return libxfs_buf_get_map(target, &map, 1, 0, bpp);
> -}
> -
> -static inline int
> -libxfs_buf_read(
> -	struct xfs_buftarg	*target,
> -	xfs_daddr_t		blkno,
> -	size_t			numblks,
> -	xfs_buf_flags_t		flags,
> -	struct xfs_buf		**bpp,
> -	const struct xfs_buf_ops *ops)
> -{
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -
> -	return libxfs_buf_read_map(target, &map, 1, flags, bpp, ops);
> -}
> -
>  int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
>  struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
>  extern void	libxfs_bcache_purge(void);
> @@ -173,12 +85,6 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  			 cksum_offset);
>  }
>  
> -static inline void
> -xfs_buf_hold(struct xfs_buf *bp)
> -{
> -	bp->b_node.cn_count++;
> -}
> -
>  /* Push a single buffer on a delwri queue. */
>  static inline bool
>  xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 0e04ab910b8b..ac12a993d872 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -87,6 +87,7 @@ struct iomap;
>   * every files via a similar include in the kernel xfs_linux.h.
>   */
>  #include "xfs_buftarg.h"
> +#include "xfs_buf.h"
>  #include "libxfs_io.h"
>  
>  /* for all the support code that uses progname in error messages */
> @@ -131,8 +132,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
>  #define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
>  #define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)
>  
> -#define xfs_buf_ioerror_alert(bp,f)	((void) 0);
> -
>  #define xfs_hex_dump(d,n)		((void) 0)
>  #define xfs_stack_trace()		((void) 0)
>  
> @@ -173,25 +172,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
>  #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
>  #define XFS_TEST_ERROR(expr,a,b)	( expr )
>  
> -#ifdef __GNUC__
> -#define __return_address	__builtin_return_address(0)
> -
> -/*
> - * Return the address of a label.  Use barrier() so that the optimizer
> - * won't reorder code to refactor the error jumpouts into a single
> - * return, which throws off the reported address.
> - */
> -#define __this_address  ({ __label__ __here; __here: barrier(); &&__here; })
> -/* Optimization barrier */
> -
> -/* The "volatile" is due to gcc bugs */
> -#define barrier() __asm__ __volatile__("": : :"memory")
> -#endif
> -
> -/* Optimization barrier */
> -#ifndef barrier
> -# define barrier() __memory_barrier()
> -#endif
>  
>  /* miscellaneous kernel routines not in user space */
>  #define likely(x)		(x)
> @@ -407,22 +387,8 @@ howmany_64(uint64_t x, uint32_t y)
>  }
>  
>  /* buffer management */
> -#define XBF_TRYLOCK			0
> -#define XBF_UNMAPPED			0
> -#define xfs_buf_stale(bp)		((bp)->b_flags |= XBF_STALE)
>  #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
>  
> -/* buffer type flags for write callbacks */
> -#define _XBF_INODES	0 /* inode buffer */
> -#define _XBF_DQUOTS	0 /* dquot buffer */
> -#define _XBF_LOGRECOVERY	0 /* log recovery buffer */
> -
> -static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
> -		xfs_daddr_t blkno, size_t numblks, xfs_buf_flags_t flags)
> -{
> -	return NULL;
> -}
> -
>  #define xfs_buf_oneshot(bp)		((void) 0)
>  
>  #define xfs_buf_zero(bp, off, len) \
> @@ -454,13 +420,6 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
>  
>  #define xfs_trans_buf_copy_type(dbp, sbp)
>  
> -/* no readahead, need to avoid set-but-unused var warnings. */
> -#define xfs_buf_readahead(a,d,c,ops)		({	\
> -	xfs_daddr_t __d = d;				\
> -	__d = __d; /* no set-but-unused warning */	\
> -})
> -#define xfs_buf_readahead_map(a,b,c,ops)	((void) 0)	/* no readahead */
> -
>  #define xfs_sort					qsort
>  
>  #define xfs_ilock(ip,mode)				((void) 0)
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index fcc4ff9b394e..3bae6a813675 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -498,7 +498,7 @@ libxfs_buf_get_map(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> -	int			flags,
> +	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp)
>  {
>  	int			error;
> @@ -640,7 +640,7 @@ libxfs_buf_read_map(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> -	int			flags,
> +	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> diff --git a/libxfs/xfs_buf.c b/libxfs/xfs_buf.c
> new file mode 100644
> index 000000000000..a6752e45ab25
> --- /dev/null
> +++ b/libxfs/xfs_buf.c
> @@ -0,0 +1,1350 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> + * Copyright (c) 2019-2020 Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +#include "libxfs_priv.h"
> +#include "xfs_buf.h"	// temporary
> +#include "init.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_shared.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_sb.h"
> +#include "xfs_mount.h"
> +#include "xfs_trace.h"
> +#include "xfs_errortag.h"
> +#include "xfs_errortag.h"
> +
> +#include <libaio.h>
> +
> +#include "libxfs.h"	/* libxfs_device_to_fd */
> +
> +//struct kmem_zone *xfs_buf_zone;
> +
> +/*
> + * Locking orders
> + *
> + * xfs_buf_ioacct_inc:
> + * xfs_buf_ioacct_dec:
> + *	b_sema (caller holds)
> + *	  b_lock
> + *
> + * xfs_buf_stale:
> + *	b_sema (caller holds)
> + *	  b_lock
> + *	    lru_lock
> + *
> + * xfs_buf_rele:
> + *	b_lock
> + *	  pag_buf_lock
> + *	    lru_lock
> + *
> + * xfs_buftarg_wait_rele
> + *	lru_lock
> + *	  b_lock (trylock due to inversion)
> + *
> + * xfs_buftarg_isolate
> + *	lru_lock
> + *	  b_lock (trylock due to inversion)
> + */
> +
> +/*
> + * Bump the I/O in flight count on the buftarg if we haven't yet done so for
> + * this buffer. The count is incremented once per buffer (per hold cycle)
> + * because the corresponding decrement is deferred to buffer release. Buffers
> + * can undergo I/O multiple times in a hold-release cycle and per buffer I/O
> + * tracking adds unnecessary overhead. This is used for sychronization purposes
> + * with unmount (see xfs_wait_buftarg()), so all we really need is a count of
> + * in-flight buffers.
> + *
> + * Buffers that are never released (e.g., superblock, iclog buffers) must set
> + * the XBF_NO_IOACCT flag before I/O submission. Otherwise, the buftarg count
> + * never reaches zero and unmount hangs indefinitely.
> + */
> +static inline void
> +xfs_buf_ioacct_inc(
> +	struct xfs_buf	*bp)
> +{
> +	if (bp->b_flags & XBF_NO_IOACCT)
> +		return;
> +
> +	ASSERT(bp->b_flags & XBF_ASYNC);
> +	spin_lock(&bp->b_lock);
> +	if (!(bp->b_state & XFS_BSTATE_IN_FLIGHT)) {
> +		bp->b_state |= XFS_BSTATE_IN_FLIGHT;
> +		atomic_inc(&bp->b_target->bt_io_count);
> +	}
> +	spin_unlock(&bp->b_lock);
> +}
> +
> +/*
> + * Clear the in-flight state on a buffer about to be released to the LRU or
> + * freed and unaccount from the buftarg.
> + */
> +static inline void
> +__xfs_buf_ioacct_dec(
> +	struct xfs_buf	*bp)
> +{
> +	if (bp->b_state & XFS_BSTATE_IN_FLIGHT) {
> +		bp->b_state &= ~XFS_BSTATE_IN_FLIGHT;
> +		atomic_dec(&bp->b_target->bt_io_count);
> +	}
> +}
> +
> +static inline void
> +xfs_buf_ioacct_dec(
> +	struct xfs_buf	*bp)
> +{
> +	spin_lock(&bp->b_lock);
> +	__xfs_buf_ioacct_dec(bp);
> +	spin_unlock(&bp->b_lock);
> +}
> +
> +/*
> + * When we mark a buffer stale, we remove the buffer from the LRU and clear the
> + * b_lru_ref count so that the buffer is freed immediately when the buffer
> + * reference count falls to zero. If the buffer is already on the LRU, we need
> + * to remove the reference that LRU holds on the buffer.
> + *
> + * This prevents build-up of stale buffers on the LRU.
> + */
> +void
> +xfs_buf_stale(
> +	struct xfs_buf	*bp)
> +{
> +	ASSERT(xfs_buf_islocked(bp));
> +
> +	bp->b_flags |= XBF_STALE;
> +
> +	/*
> +	 * Clear the delwri status so that a delwri queue walker will not
> +	 * flush this buffer to disk now that it is stale. The delwri queue has
> +	 * a reference to the buffer, so this is safe to do.
> +	 */
> +	bp->b_flags &= ~_XBF_DELWRI_Q;
> +
> +	/*
> +	 * Once the buffer is marked stale and unlocked, a subsequent lookup
> +	 * could reset b_flags. There is no guarantee that the buffer is
> +	 * unaccounted (released to LRU) before that occurs. Drop in-flight
> +	 * status now to preserve accounting consistency.
> +	 */
> +	spin_lock(&bp->b_lock);
> +	__xfs_buf_ioacct_dec(bp);
> +
> +	atomic_set(&bp->b_lru_ref, 0);
> +	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
> +	    (list_lru_del(&bp->b_target->bt_lru, &bp->b_lru)))
> +		atomic_dec(&bp->b_hold);
> +
> +	ASSERT(atomic_read(&bp->b_hold) >= 1);
> +	spin_unlock(&bp->b_lock);
> +}
> +
> +#ifdef NOT_YET
> +static int
> +xfs_buf_get_maps(
> +	struct xfs_buf		*bp,
> +	int			map_count)
> +{
> +	ASSERT(bp->b_maps == NULL);
> +	bp->b_map_count = map_count;
> +
> +	if (map_count == 1) {
> +		bp->b_maps = &bp->__b_map;
> +		return 0;
> +	}
> +
> +	bp->b_maps = kmem_zalloc(map_count * sizeof(struct xfs_buf_map),
> +				KM_NOFS);
> +	if (!bp->b_maps)
> +		return -ENOMEM;
> +	return 0;
> +}
> +#endif /* not yet */
> +
> +static void
> +xfs_buf_free_maps(
> +	struct xfs_buf	*bp)
> +{
> +	if (bp->b_maps != &bp->__b_map) {
> +		kmem_free(bp->b_maps);
> +		bp->b_maps = NULL;
> +	}
> +}
> +
> +#ifdef NOT_YET
> +static int
> +_xfs_buf_alloc(
> +	struct xfs_buftarg	*target,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +	int			i;
> +
> +	*bpp = NULL;
> +	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
> +
> +	/*
> +	 * We don't want certain flags to appear in b_flags unless they are
> +	 * specifically set by later operations on the buffer.
> +	 */
> +	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
> +
> +	atomic_set(&bp->b_hold, 1);
> +	atomic_set(&bp->b_lru_ref, 1);
> +	init_completion(&bp->b_iowait);
> +	INIT_LIST_HEAD(&bp->b_lru);
> +	INIT_LIST_HEAD(&bp->b_list);
> +	INIT_LIST_HEAD(&bp->b_li_list);
> +	INIT_LIST_HEAD(&bp->b_btc_list);
> +	sema_init(&bp->b_sema, 0); /* held, no waiters */
> +	spin_lock_init(&bp->b_lock);
> +	bp->b_target = target;
> +	bp->b_mount = target->bt_mount;
> +	bp->b_flags = flags;
> +
> +	/*
> +	 * Set length and io_length to the same value initially.
> +	 * I/O routines should use io_length, which will be the same in
> +	 * most cases but may be reset (e.g. XFS recovery).
> +	 */
> +	error = xfs_buf_get_maps(bp, nmaps);
> +	if (error)  {
> +		kmem_cache_free(xfs_buf_zone, bp);
> +		return error;
> +	}
> +
> +	bp->b_bn = map[0].bm_bn;
> +	bp->b_length = 0;
> +	for (i = 0; i < nmaps; i++) {
> +		bp->b_maps[i].bm_bn = map[i].bm_bn;
> +		bp->b_maps[i].bm_len = map[i].bm_len;
> +		bp->b_length += map[i].bm_len;
> +	}
> +
> +	XFS_STATS_INC(bp->b_mount, xb_create);
> +	trace_xfs_buf_init(bp, _RET_IP_);
> +
> +	*bpp = bp;
> +	return 0;
> +}
> +#endif /* not yet */
> +
> +/*
> + * Releases the specified buffer.
> + *
> + * The modification state of any associated pages is left unchanged.  The buffer
> + * must not be on any hash - use xfs_buf_rele instead for hashed and refcounted
> + * buffers
> + */
> +void
> +xfs_buf_free(
> +	struct xfs_buf		*bp)
> +{
> +	trace_xfs_buf_free(bp, _RET_IP_);
> +
> +	ASSERT(list_empty(&bp->b_lru));
> +	xfs_buf_free_memory(bp);
> +	xfs_buf_free_maps(bp);
> +	kmem_cache_free(xfs_buf_zone, bp);
> +}
> +
> +/*
> + * Look up a buffer in the buffer cache and return it referenced and locked
> + * in @found_bp.
> + *
> + * If @new_bp is supplied and we have a lookup miss, insert @new_bp into the
> + * cache.
> + *
> + * If XBF_TRYLOCK is set in @flags, only try to lock the buffer and return
> + * -EAGAIN if we fail to lock it.
> + *
> + * Return values are:
> + *	-EFSCORRUPTED if have been supplied with an invalid address
> + *	-EAGAIN on trylock failure
> + *	-ENOENT if we fail to find a match and @new_bp was NULL
> + *	0, with @found_bp:
> + *		- @new_bp if we inserted it into the cache
> + *		- the buffer we found and locked.
> + */
> +static int
> +xfs_buf_find(
> +	struct xfs_buftarg	*btp,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		*new_bp,
> +	struct xfs_buf		**found_bp)
> +{
> +	struct xfs_perag	*pag;
> +	struct xfs_buf		*bp;
> +	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
> +	xfs_daddr_t		eofs;
> +	int			i;
> +
> +	*found_bp = NULL;
> +
> +	for (i = 0; i < nmaps; i++)
> +		cmap.bm_len += map[i].bm_len;
> +
> +	/* Check for IOs smaller than the sector size / not sector aligned */
> +	ASSERT(!(BBTOB(cmap.bm_len) < btp->bt_meta_sectorsize));
> +	ASSERT(!(BBTOB(cmap.bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
> +
> +	/*
> +	 * Corrupted block numbers can get through to here, unfortunately, so we
> +	 * have to check that the buffer falls within the filesystem bounds.
> +	 */
> +	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> +	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
> +		xfs_alert(btp->bt_mount,
> +			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
> +			  __func__, cmap.bm_bn, eofs);
> +		WARN_ON(1);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	pag = xfs_perag_get(btp->bt_mount,
> +			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
> +
> +	spin_lock(&pag->pag_buf_lock);
> +	bp = btc_node_find(pag->pag_buf_hash, &cmap);
> +	if (bp) {
> +		atomic_inc(&bp->b_hold);
> +		goto found;
> +	}
> +
> +	/* No match found */
> +	if (!new_bp) {
> +		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
> +		spin_unlock(&pag->pag_buf_lock);
> +		xfs_perag_put(pag);
> +		return -ENOENT;
> +	}
> +
> +	/* the buffer keeps the perag reference until it is freed */
> +	new_bp->b_pag = pag;
> +	btc_node_insert(pag->pag_buf_hash, new_bp);
> +	spin_unlock(&pag->pag_buf_lock);
> +	*found_bp = new_bp;
> +	return 0;
> +
> +found:
> +	spin_unlock(&pag->pag_buf_lock);
> +	xfs_perag_put(pag);
> +
> +	if (!xfs_buf_trylock(bp)) {
> +		if (flags & XBF_TRYLOCK) {
> +			xfs_buf_rele(bp);
> +			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
> +			return -EAGAIN;
> +		}
> +		xfs_buf_lock(bp);
> +		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
> +	}
> +
> +	/*
> +	 * if the buffer is stale, clear all the external state associated with
> +	 * it. We need to keep flags such as how we allocated the buffer memory
> +	 * intact here.
> +	 */
> +	if (bp->b_flags & XBF_STALE) {
> +		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> +		ASSERT(bp->b_iodone == NULL);
> +		bp->b_ops = NULL;
> +	}
> +
> +	trace_xfs_buf_find(bp, flags, _RET_IP_);
> +	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
> +	*found_bp = bp;
> +	return 0;
> +}
> +
> +struct xfs_buf *
> +xfs_buf_incore(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	size_t			numblks,
> +	xfs_buf_flags_t		flags)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +
> +	error = xfs_buf_find(target, &map, 1, flags, NULL, &bp);
> +	if (error)
> +		return NULL;
> +	return bp;
> +}
> +
> +
> +/*
> + * Assembles a buffer covering the specified range. The code is optimised for
> + * cache hits, as metadata intensive workloads will see 3 orders of magnitude
> + * more hits than misses.
> + */
> +#ifdef NOT_YET
> +int
> +xfs_buf_get_map(
> +	struct xfs_buftarg	*target,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_buf		*bp;
> +	struct xfs_buf		*new_bp;
> +	int			error = 0;
> +
> +	*bpp = NULL;
> +	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
> +	if (!error)
> +		goto found;
> +	if (error != -ENOENT)
> +		return error;
> +
> +	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
> +	if (error)
> +		return error;
> +
> +	error = xfs_buf_allocate_memory(new_bp, flags);
> +	if (error) {
> +		xfs_buf_free(new_bp);
> +		return error;
> +	}
> +
> +	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
> +	if (error) {
> +		xfs_buf_free(new_bp);
> +		return error;
> +	}
> +
> +	if (bp != new_bp)
> +		xfs_buf_free(new_bp);
> +
> +found:
> +	/*
> +	 * Clear b_error if this is a lookup from a caller that doesn't expect
> +	 * valid data to be found in the buffer.
> +	 */
> +	if (!(flags & XBF_READ))
> +		xfs_buf_ioerror(bp, 0);
> +
> +	XFS_STATS_INC(target->bt_mount, xb_get);
> +	trace_xfs_buf_get(bp, flags, _RET_IP_);
> +	*bpp = bp;
> +	return 0;
> +}
> +
> +STATIC int
> +_xfs_buf_read(
> +	struct xfs_buf		*bp,
> +	xfs_buf_flags_t		flags)
> +{
> +	ASSERT(!(flags & XBF_WRITE));
> +	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
> +
> +	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
> +	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
> +
> +	return xfs_buf_submit(bp);
> +}
> +#endif /* not yet */
> +
> +/*
> + * Reverify a buffer found in cache without an attached ->b_ops.
> + *
> + * If the caller passed an ops structure and the buffer doesn't have ops
> + * assigned, set the ops and use it to verify the contents. If verification
> + * fails, clear XBF_DONE. We assume the buffer has no recorded errors and is
> + * already in XBF_DONE state on entry.
> + *
> + * Under normal operations, every in-core buffer is verified on read I/O
> + * completion. There are two scenarios that can lead to in-core buffers without
> + * an assigned ->b_ops. The first is during log recovery of buffers on a V4
> + * filesystem, though these buffers are purged at the end of recovery. The
> + * other is online repair, which intentionally reads with a NULL buffer ops to
> + * run several verifiers across an in-core buffer in order to establish buffer
> + * type.  If repair can't establish that, the buffer will be left in memory
> + * with NULL buffer ops.
> + */
> +int
> +xfs_buf_reverify(
> +	struct xfs_buf		*bp,
> +	const struct xfs_buf_ops *ops)
> +{
> +	ASSERT(bp->b_flags & XBF_DONE);
> +	ASSERT(bp->b_error == 0);
> +
> +	if (!ops || bp->b_ops)
> +		return 0;
> +
> +	bp->b_ops = ops;
> +	bp->b_ops->verify_read(bp);
> +	if (bp->b_error)
> +		bp->b_flags &= ~XBF_DONE;
> +	return bp->b_error;
> +}
> +
> +#ifdef NOT_YET
> +int
> +xfs_buf_read_map(
> +	struct xfs_buftarg	*target,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp,
> +	const struct xfs_buf_ops *ops)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	flags |= XBF_READ;
> +	*bpp = NULL;
> +
> +	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
> +	if (error)
> +		return error;
> +
> +	trace_xfs_buf_read(bp, flags, _RET_IP_);
> +
> +	if (!(bp->b_flags & XBF_DONE)) {
> +		/* Initiate the buffer read and wait. */
> +		XFS_STATS_INC(target->bt_mount, xb_get_read);
> +		bp->b_ops = ops;
> +		error = _xfs_buf_read(bp, flags);
> +
> +		/* Readahead iodone already dropped the buffer, so exit. */
> +		if (flags & XBF_ASYNC)
> +			return 0;
> +	} else {
> +		/* Buffer already read; all we need to do is check it. */
> +		error = xfs_buf_reverify(bp, ops);
> +
> +		/* Readahead already finished; drop the buffer and exit. */
> +		if (flags & XBF_ASYNC) {
> +			xfs_buf_relse(bp);
> +			return 0;
> +		}
> +
> +		/* We do not want read in the flags */
> +		bp->b_flags &= ~XBF_READ;
> +		ASSERT(bp->b_ops != NULL || ops == NULL);
> +	}
> +
> +	/*
> +	 * If we've had a read error, then the contents of the buffer are
> +	 * invalid and should not be used. To ensure that a followup read tries
> +	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
> +	 * mark the buffer stale. This ensures that anyone who has a current
> +	 * reference to the buffer will interpret it's contents correctly and
> +	 * future cache lookups will also treat it as an empty, uninitialised
> +	 * buffer.
> +	 */
> +	if (error) {
> +		if (!XFS_FORCED_SHUTDOWN(target->bt_mount))
> +			xfs_buf_ioerror_alert(bp, __this_address);
> +
> +		bp->b_flags &= ~XBF_DONE;
> +		xfs_buf_stale(bp);
> +		xfs_buf_relse(bp);
> +
> +		/* bad CRC means corrupted metadata */
> +		if (error == -EFSBADCRC)
> +			error = -EFSCORRUPTED;
> +		return error;
> +	}
> +
> +	*bpp = bp;
> +	return 0;
> +}
> +#endif /* not yet */
> +
> +/*
> + *	If we are not low on memory then do the readahead in a deadlock
> + *	safe manner.
> + */
> +void
> +xfs_buf_readahead_map(
> +	struct xfs_buftarg	*target,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	const struct xfs_buf_ops *ops)
> +{
> +	struct xfs_buf		*bp;
> +
> +	if (bdi_read_congested(target->bt_bdev->bd_bdi))
> +		return;
> +
> +	xfs_buf_read_map(target, map, nmaps,
> +		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD, &bp, ops);
> +}
> +
> +/*
> + *	Increment reference count on buffer, to hold the buffer concurrently
> + *	with another thread which may release (free) the buffer asynchronously.
> + *	Must hold the buffer already to call this function.
> + */
> +void
> +xfs_buf_hold(
> +	struct xfs_buf	*bp)
> +{
> +	trace_xfs_buf_hold(bp, _RET_IP_);
> +	atomic_inc(&bp->b_hold);
> +	bp->b_node.cn_count++;
> +}
> +
> +/*
> + * Release a hold on the specified buffer. If the hold count is 1, the buffer is
> + * placed on LRU or freed (depending on b_lru_ref).
> + *
> + * XXX: purging via btc lru is broken in this code. Needs fixing.
> + */
> +void
> +xfs_buf_rele(
> +	struct xfs_buf	*bp)
> +{
> +	struct xfs_perag *pag = bp->b_pag;
> +	bool		release;
> +	bool		freebuf = false;
> +
> +	trace_xfs_buf_rele(bp, _RET_IP_);
> +
> +	if (!pag) {
> +		ASSERT(list_empty(&bp->b_lru));
> +		if (atomic_dec_and_test(&bp->b_hold)) {
> +			xfs_buf_ioacct_dec(bp);
> +			xfs_buf_free(bp);
> +		}
> +		return;
> +	}
> +
> +	ASSERT(atomic_read(&bp->b_hold) > 0);
> +
> +	/*
> +	 * We grab the b_lock here first to serialise racing xfs_buf_rele()
> +	 * calls. The pag_buf_lock being taken on the last reference only
> +	 * serialises against racing lookups in xfs_buf_find(). IOWs, the second
> +	 * to last reference we drop here is not serialised against the last
> +	 * reference until we take bp->b_lock. Hence if we don't grab b_lock
> +	 * first, the last "release" reference can win the race to the lock and
> +	 * free the buffer before the second-to-last reference is processed,
> +	 * leading to a use-after-free scenario.
> +	 */
> +	spin_lock(&bp->b_lock);
> +	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
> +	if (!release) {
> +		/*
> +		 * Drop the in-flight state if the buffer is already on the LRU
> +		 * and it holds the only reference. This is racy because we
> +		 * haven't acquired the pag lock, but the use of _XBF_IN_FLIGHT
> +		 * ensures the decrement occurs only once per-buf.
> +		 */
> +		if ((atomic_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
> +			__xfs_buf_ioacct_dec(bp);
> +		goto out_unlock;
> +	}
> +
> +	/* the last reference has been dropped ... */
> +	__xfs_buf_ioacct_dec(bp);
> +	//if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
> +	if (0) {
> +		/*
> +		 * If the buffer is added to the LRU take a new reference to the
> +		 * buffer for the LRU and clear the (now stale) dispose list
> +		 * state flag
> +		 */
> +		if (list_lru_add(&bp->b_target->bt_lru, &bp->b_lru)) {
> +			bp->b_state &= ~XFS_BSTATE_DISPOSE;
> +			atomic_inc(&bp->b_hold);
> +		}
> +		spin_unlock(&pag->pag_buf_lock);
> +	} else {
> +		/*
> +		 * most of the time buffers will already be removed from the
> +		 * LRU, so optimise that case by checking for the
> +		 * XFS_BSTATE_DISPOSE flag indicating the last list the buffer
> +		 * was on was the disposal list
> +		 */
> +		if (!(bp->b_state & XFS_BSTATE_DISPOSE)) {
> +			list_lru_del(&bp->b_target->bt_lru, &bp->b_lru);
> +		} else {
> +			ASSERT(list_empty(&bp->b_lru));
> +		}
> +
> +		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
> +		btc_node_remove(pag->pag_buf_hash, bp);
> +		spin_unlock(&pag->pag_buf_lock);
> +		xfs_perag_put(pag);
> +		freebuf = true;
> +	}
> +
> +out_unlock:
> +	spin_unlock(&bp->b_lock);
> +
> +	if (freebuf)
> +		xfs_buf_free(bp);
> +}
> +
> +
> +/*
> + *	Lock a buffer object, if it is not already locked.
> + *
> + *	If we come across a stale, pinned, locked buffer, we know that we are
> + *	being asked to lock a buffer that has been reallocated. Because it is
> + *	pinned, we know that the log has not been pushed to disk and hence it
> + *	will still be locked.  Rather than continuing to have trylock attempts
> + *	fail until someone else pushes the log, push it ourselves before
> + *	returning.  This means that the xfsaild will not get stuck trying
> + *	to push on stale inode buffers.
> + */
> +int
> +xfs_buf_trylock(
> +	struct xfs_buf		*bp)
> +{
> +	int			locked;
> +
> +	locked = down_trylock(&bp->b_sema) == 0;
> +	if (locked)
> +		trace_xfs_buf_trylock(bp, _RET_IP_);
> +	else
> +		trace_xfs_buf_trylock_fail(bp, _RET_IP_);
> +	return locked;
> +}
> +
> +/*
> + *	Lock a buffer object.
> + *
> + *	If we come across a stale, pinned, locked buffer, we know that we
> + *	are being asked to lock a buffer that has been reallocated. Because
> + *	it is pinned, we know that the log has not been pushed to disk and
> + *	hence it will still be locked. Rather than sleeping until someone
> + *	else pushes the log, push it ourselves before trying to get the lock.
> + */
> +void
> +xfs_buf_lock(
> +	struct xfs_buf		*bp)
> +{
> +	trace_xfs_buf_lock(bp, _RET_IP_);
> +
> +	down(&bp->b_sema);
> +
> +	trace_xfs_buf_lock_done(bp, _RET_IP_);
> +}
> +
> +void
> +xfs_buf_unlock(
> +	struct xfs_buf		*bp)
> +{
> +	ASSERT(xfs_buf_islocked(bp));
> +
> +	up(&bp->b_sema);
> +	trace_xfs_buf_unlock(bp, _RET_IP_);
> +}
> +
> +/*
> + *	Buffer Utility Routines
> + */
> +
> +void
> +xfs_buf_ioend(
> +	struct xfs_buf	*bp)
> +{
> +	bool		read = bp->b_flags & XBF_READ;
> +
> +	trace_xfs_buf_iodone(bp, _RET_IP_);
> +
> +//	printf("endio bn %ld l %d/%d, io err %d err %d f 0x%x\n", bp->b_maps[0].bm_bn,
> +//			bp->b_maps[0].bm_len, BBTOB(bp->b_length),
> +//			bp->b_io_error, bp->b_error, bp->b_flags);
> +
> +	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> +	/*
> +	 * Pull in IO completion errors now. We are guaranteed to be running
> +	 * single threaded, so we don't need the lock to read b_io_error.
> +	 */
> +	if (!bp->b_error && bp->b_io_error)
> +		xfs_buf_ioerror(bp, bp->b_io_error);
> +
> +	/* Only validate buffers that were read without errors */
> +	if (read && !bp->b_error && bp->b_ops) {
> +		ASSERT(!bp->b_iodone);
> +		bp->b_ops->verify_read(bp);
> +	}
> +
> +	if (!bp->b_error) {
> +		bp->b_flags |= XBF_DONE;
> +		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> +	} else {
> +		fprintf(stderr,
> +			_("%s: IO failed on %s bno 0x%llx/0x%x, err=%d\n"),
> +			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
> +			(long long)bp->b_maps[0].bm_bn, bp->b_length,
> +			-bp->b_error);
> +	}
> +
> +	if (bp->b_iodone)
> +		(*(bp->b_iodone))(bp);
> +	else if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_relse(bp);
> +	else
> +		complete(&bp->b_iowait);
> +}
> +
> +void
> +__xfs_buf_ioerror(
> +	struct xfs_buf	*bp,
> +	int		error,
> +	xfs_failaddr_t	failaddr)
> +{
> +	ASSERT(error <= 0 && error >= -1000);
> +	bp->b_error = error;
> +	trace_xfs_buf_ioerror(bp, error, failaddr);
> +}
> +
> +void
> +xfs_buf_ioerror_alert(
> +	struct xfs_buf		*bp,
> +	const char		*func)
> +{
> +	xfs_alert(bp->b_target->bt_mount,
> +"metadata I/O error in \"%s\" at daddr 0x%llx len %d error %d",
> +			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> +			-bp->b_error);
> +}
> +
> +#ifdef NOT_YET
> +int
> +xfs_bread(
> +	struct xfs_buf		*bp,
> +	size_t			bblen)
> +{
> +	int			error;
> +
> +	ASSERT(xfs_buf_islocked(bp));
> +
> +	bp->b_flags |= XBF_READ;
> +	bp->b_flags &= ~(XBF_ASYNC | XBF_WRITE | _XBF_DELWRI_Q |
> +			 XBF_WRITE_FAIL | XBF_DONE);
> +
> +	error = xfs_buf_submit(bp);
> +	if (error) {
> +		xfs_force_shutdown(bp->b_target->bt_mount,
> +				   SHUTDOWN_META_IO_ERROR);
> +	}
> +	return error;
> +}
> +
> +int
> +xfs_bwrite(
> +	struct xfs_buf		*bp)
> +{
> +	int			error;
> +
> +	ASSERT(xfs_buf_islocked(bp));
> +
> +	bp->b_flags |= XBF_WRITE;
> +	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
> +			 XBF_WRITE_FAIL | XBF_DONE);
> +
> +	error = xfs_buf_submit(bp);
> +	if (error) {
> +		xfs_force_shutdown(bp->b_target->bt_mount,
> +				   SHUTDOWN_META_IO_ERROR);
> +	}
> +	return error;
> +}
> +#endif /* not yet */
> +
> +/*
> + * Wait for I/O completion of a sync buffer and return the I/O error code.
> + */
> +static int
> +xfs_buf_iowait(
> +	struct xfs_buf	*bp)
> +{
> +	ASSERT(!(bp->b_flags & XBF_ASYNC));
> +
> +	trace_xfs_buf_iowait(bp, _RET_IP_);
> +	wait_for_completion(&bp->b_iowait);
> +	trace_xfs_buf_iowait_done(bp, _RET_IP_);
> +
> +	return bp->b_error;
> +}
> +
> +/*
> + * Buffer I/O submission path, read or write. Asynchronous submission transfers
> + * the buffer lock ownership and the current reference to the IO. It is not
> + * safe to reference the buffer after a call to this function unless the caller
> + * holds an additional reference itself.
> + */
> +int
> +__xfs_buf_submit(
> +	struct xfs_buf	*bp,
> +	bool		wait)
> +{
> +	int		error = 0;
> +
> +	trace_xfs_buf_submit(bp, _RET_IP_);
> +
> +	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
> +
> +	/* on shutdown we stale and complete the buffer immediately */
> +	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> +		xfs_buf_ioerror(bp, -EIO);
> +		bp->b_flags &= ~XBF_DONE;
> +		xfs_buf_stale(bp);
> +		xfs_buf_ioend(bp);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * Grab a reference so the buffer does not go away underneath us. For
> +	 * async buffers, I/O completion drops the callers reference, which
> +	 * could occur before submission returns.
> +	 */
> +	xfs_buf_hold(bp);
> +
> +	if (bp->b_flags & XBF_WRITE)
> +		xfs_buf_wait_unpin(bp);
> +
> +	/* clear the internal error state to avoid spurious errors */
> +	bp->b_io_error = 0;
> +
> +	/*
> +	 * Set the count to 1 initially, this will stop an I/O completion
> +	 * callout which happens before we have started all the I/O from calling
> +	 * xfs_buf_ioend too early.
> +	 */
> +	atomic_set(&bp->b_io_remaining, 1);
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_ioacct_inc(bp);
> +
> +	xfs_buftarg_submit_io(bp);
> +
> +	/*
> +	 * If _xfs_buf_ioapply failed, we can get back here with only the IO
> +	 * reference we took above. If we drop it to zero, run completion so
> +	 * that we don't return to the caller with completion still pending.
> +	 */
> +	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> +		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> +			xfs_buf_ioend(bp);
> +		else
> +			xfs_buf_ioend_async(bp);
> +	}
> +
> +	if (wait)
> +		error = xfs_buf_iowait(bp);
> +
> +	/*
> +	 * Release the hold that keeps the buffer referenced for the entire
> +	 * I/O. Note that if the buffer is async, it is not safe to reference
> +	 * after this release.
> +	 */
> +	xfs_buf_rele(bp);
> +	return error;
> +}
> +
> +/*
> + * Cancel a delayed write list.
> + *
> + * Remove each buffer from the list, clear the delwri queue flag and drop the
> + * associated buffer reference.
> + */
> +#ifdef NOT_YET
> +void
> +xfs_buf_delwri_cancel(
> +	struct list_head	*list)
> +{
> +	struct xfs_buf		*bp;
> +
> +	while (!list_empty(list)) {
> +		bp = list_first_entry(list, struct xfs_buf, b_list);
> +
> +		xfs_buf_lock(bp);
> +		bp->b_flags &= ~_XBF_DELWRI_Q;
> +		list_del_init(&bp->b_list);
> +		xfs_buf_relse(bp);
> +	}
> +}
> +
> +/*
> + * Add a buffer to the delayed write list.
> + *
> + * This queues a buffer for writeout if it hasn't already been.  Note that
> + * neither this routine nor the buffer list submission functions perform
> + * any internal synchronization.  It is expected that the lists are thread-local
> + * to the callers.
> + *
> + * Returns true if we queued up the buffer, or false if it already had
> + * been on the buffer list.
> + */
> +bool
> +xfs_buf_delwri_queue(
> +	struct xfs_buf		*bp,
> +	struct list_head	*list)
> +{
> +	ASSERT(xfs_buf_islocked(bp));
> +	ASSERT(!(bp->b_flags & XBF_READ));
> +
> +	/*
> +	 * If the buffer is already marked delwri it already is queued up
> +	 * by someone else for imediate writeout.  Just ignore it in that
> +	 * case.
> +	 */
> +	if (bp->b_flags & _XBF_DELWRI_Q) {
> +		trace_xfs_buf_delwri_queued(bp, _RET_IP_);
> +		return false;
> +	}
> +
> +	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
> +
> +	/*
> +	 * If a buffer gets written out synchronously or marked stale while it
> +	 * is on a delwri list we lazily remove it. To do this, the other party
> +	 * clears the  _XBF_DELWRI_Q flag but otherwise leaves the buffer alone.
> +	 * It remains referenced and on the list.  In a rare corner case it
> +	 * might get readded to a delwri list after the synchronous writeout, in
> +	 * which case we need just need to re-add the flag here.
> +	 */
> +	bp->b_flags |= _XBF_DELWRI_Q;
> +	if (list_empty(&bp->b_list)) {
> +		atomic_inc(&bp->b_hold);
> +		list_add_tail(&bp->b_list, list);
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Compare function is more complex than it needs to be because
> + * the return value is only 32 bits and we are doing comparisons
> + * on 64 bit values
> + */
> +static int
> +xfs_buf_cmp(
> +	void		*priv,
> +	struct list_head *a,
> +	struct list_head *b)
> +{
> +	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
> +	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
> +	xfs_daddr_t		diff;
> +
> +	diff = ap->b_maps[0].bm_bn - bp->b_maps[0].bm_bn;
> +	if (diff < 0)
> +		return -1;
> +	if (diff > 0)
> +		return 1;
> +	return 0;
> +}
> +
> +/*
> + * Submit buffers for write. If wait_list is specified, the buffers are
> + * submitted using sync I/O and placed on the wait list such that the caller can
> + * iowait each buffer. Otherwise async I/O is used and the buffers are released
> + * at I/O completion time. In either case, buffers remain locked until I/O
> + * completes and the buffer is released from the queue.
> + */
> +static int
> +xfs_buf_delwri_submit_buffers(
> +	struct list_head	*buffer_list,
> +	struct list_head	*wait_list)
> +{
> +	struct xfs_buf		*bp, *n;
> +	int			pinned = 0;
> +
> +	list_sort(NULL, buffer_list, xfs_buf_cmp);
> +
> +	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> +		if (!wait_list) {
> +			if (xfs_buf_ispinned(bp)) {
> +				pinned++;
> +				continue;
> +			}
> +			if (!xfs_buf_trylock(bp))
> +				continue;
> +		} else {
> +			xfs_buf_lock(bp);
> +		}
> +
> +		/*
> +		 * Someone else might have written the buffer synchronously or
> +		 * marked it stale in the meantime.  In that case only the
> +		 * _XBF_DELWRI_Q flag got cleared, and we have to drop the
> +		 * reference and remove it from the list here.
> +		 */
> +		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
> +			list_del_init(&bp->b_list);
> +			xfs_buf_relse(bp);
> +			continue;
> +		}
> +
> +		trace_xfs_buf_delwri_split(bp, _RET_IP_);
> +
> +		/*
> +		 * If we have a wait list, each buffer (and associated delwri
> +		 * queue reference) transfers to it and is submitted
> +		 * synchronously. Otherwise, drop the buffer from the delwri
> +		 * queue and submit async.
> +		 */
> +		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
> +		bp->b_flags |= XBF_WRITE;
> +		if (wait_list) {
> +			bp->b_flags &= ~XBF_ASYNC;
> +			list_move_tail(&bp->b_list, wait_list);
> +		} else {
> +			bp->b_flags |= XBF_ASYNC;
> +			list_del_init(&bp->b_list);
> +		}
> +		__xfs_buf_submit(bp, false);
> +	}
> +
> +	return pinned;
> +}
> +
> +/*
> + * Write out a buffer list asynchronously.
> + *
> + * This will take the @buffer_list, write all non-locked and non-pinned buffers
> + * out and not wait for I/O completion on any of the buffers.  This interface
> + * is only safely useable for callers that can track I/O completion by higher
> + * level means, e.g. AIL pushing as the @buffer_list is consumed in this
> + * function.
> + *
> + * Note: this function will skip buffers it would block on, and in doing so
> + * leaves them on @buffer_list so they can be retried on a later pass. As such,
> + * it is up to the caller to ensure that the buffer list is fully submitted or
> + * cancelled appropriately when they are finished with the list. Failure to
> + * cancel or resubmit the list until it is empty will result in leaked buffers
> + * at unmount time.
> + */
> +int
> +xfs_buf_delwri_submit_nowait(
> +	struct list_head	*buffer_list)
> +{
> +	return xfs_buf_delwri_submit_buffers(buffer_list, NULL);
> +}
> +
> +/*
> + * Write out a buffer list synchronously.
> + *
> + * This will take the @buffer_list, write all buffers out and wait for I/O
> + * completion on all of the buffers. @buffer_list is consumed by the function,
> + * so callers must have some other way of tracking buffers if they require such
> + * functionality.
> + */
> +int
> +xfs_buf_delwri_submit(
> +	struct list_head	*buffer_list)
> +{
> +	LIST_HEAD		(wait_list);
> +	int			error = 0, error2;
> +	struct xfs_buf		*bp;
> +
> +	xfs_buf_delwri_submit_buffers(buffer_list, &wait_list);
> +
> +	/* Wait for IO to complete. */
> +	while (!list_empty(&wait_list)) {
> +		bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
> +
> +		list_del_init(&bp->b_list);
> +
> +		/*
> +		 * Wait on the locked buffer, check for errors and unlock and
> +		 * release the delwri queue reference.
> +		 */
> +		error2 = xfs_buf_iowait(bp);
> +		xfs_buf_relse(bp);
> +		if (!error)
> +			error = error2;
> +	}
> +
> +	return error;
> +}
> +
> +/*
> + * Push a single buffer on a delwri queue.
> + *
> + * The purpose of this function is to submit a single buffer of a delwri queue
> + * and return with the buffer still on the original queue. The waiting delwri
> + * buffer submission infrastructure guarantees transfer of the delwri queue
> + * buffer reference to a temporary wait list. We reuse this infrastructure to
> + * transfer the buffer back to the original queue.
> + *
> + * Note the buffer transitions from the queued state, to the submitted and wait
> + * listed state and back to the queued state during this call. The buffer
> + * locking and queue management logic between _delwri_pushbuf() and
> + * _delwri_queue() guarantee that the buffer cannot be queued to another list
> + * before returning.
> + */
> +int
> +xfs_buf_delwri_pushbuf(
> +	struct xfs_buf		*bp,
> +	struct list_head	*buffer_list)
> +{
> +	LIST_HEAD		(submit_list);
> +	int			error;
> +
> +	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> +
> +	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
> +
> +	/*
> +	 * Isolate the buffer to a new local list so we can submit it for I/O
> +	 * independently from the rest of the original list.
> +	 */
> +	xfs_buf_lock(bp);
> +	list_move(&bp->b_list, &submit_list);
> +	xfs_buf_unlock(bp);
> +
> +	/*
> +	 * Delwri submission clears the DELWRI_Q buffer flag and returns with
> +	 * the buffer on the wait list with the original reference. Rather than
> +	 * bounce the buffer from a local wait list back to the original list
> +	 * after I/O completion, reuse the original list as the wait list.
> +	 */
> +	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> +
> +	/*
> +	 * The buffer is now locked, under I/O and wait listed on the original
> +	 * delwri queue. Wait for I/O completion, restore the DELWRI_Q flag and
> +	 * return with the buffer unlocked and on the original queue.
> +	 */
> +	error = xfs_buf_iowait(bp);
> +	bp->b_flags |= _XBF_DELWRI_Q;
> +	xfs_buf_unlock(bp);
> +
> +	return error;
> +}
> +#endif /* not yet */
> +
> +void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
> +{
> +	/*
> +	 * Set the lru reference count to 0 based on the error injection tag.
> +	 * This allows userspace to disrupt buffer caching for debug/testing
> +	 * purposes.
> +	 */
> +	if (XFS_TEST_ERROR(false, bp->b_target->bt_mount,
> +			   XFS_ERRTAG_BUF_LRU_REF))
> +		lru_ref = 0;
> +
> +	atomic_set(&bp->b_lru_ref, lru_ref);
> +}
> +
> +#ifdef NOT_YET
> +/*
> + * Verify an on-disk magic value against the magic value specified in the
> + * verifier structure. The verifier magic is in disk byte order so the caller is
> + * expected to pass the value directly from disk.
> + */
> +bool
> +xfs_verify_magic(
> +	struct xfs_buf		*bp,
> +	__be32			dmagic)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	int			idx;
> +
> +	idx = xfs_sb_version_hascrc(&mp->m_sb);
> +	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx])))
> +		return false;
> +	return dmagic == bp->b_ops->magic[idx];
> +}
> +
> +/*
> + * Verify an on-disk magic value against the magic value specified in the
> + * verifier structure. The verifier magic is in disk byte order so the caller is
> + * expected to pass the value directly from disk.
> + */
> +bool
> +xfs_verify_magic16(
> +	struct xfs_buf		*bp,
> +	__be16			dmagic)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	int			idx;
> +
> +	idx = xfs_sb_version_hascrc(&mp->m_sb);
> +	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx])))
> +		return false;
> +	return dmagic == bp->b_ops->magic16[idx];
> +}
> +
> +/*
> + * Read an uncached buffer from disk. Allocates and returns a locked
> + * buffer containing the disk contents or nothing.
> + */
> +int
> +xfs_buf_read_uncached(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		daddr,
> +	size_t			numblks,
> +	int			flags,
> +	struct xfs_buf		**bpp,
> +	const struct xfs_buf_ops *ops)
> +{
> +	struct xfs_buf		*bp;
> +
> +	*bpp = NULL;
> +
> +	bp = xfs_buf_get_uncached(target, numblks, flags);
> +	if (!bp)
> +		return -ENOMEM;
> +
> +	/* set up the buffer for a read IO */
> +	ASSERT(bp->b_map_count == 1);
> +	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
> +	bp->b_maps[0].bm_bn = daddr;
> +	bp->b_flags |= XBF_READ;
> +	bp->b_ops = ops;
> +
> +	xfs_buf_submit(bp);
> +	if (bp->b_error) {
> +		int	error = bp->b_error;
> +		xfs_buf_relse(bp);
> +		return error;
> +	}
> +
> +	*bpp = bp;
> +	return 0;
> +}
> +
> +struct xfs_buf *
> +xfs_buf_get_uncached(
> +	struct xfs_buftarg	*target,
> +	size_t			numblks,
> +	int			flags)
> +{
> +	int			error;
> +	struct xfs_buf		*bp;
> +	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
> +
> +	/* flags might contain irrelevant bits, pass only what we care about */
> +	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
> +	if (unlikely(bp == NULL))
> +		goto fail;
> +
> +	error = xfs_buf_allocate_memory(bp, flags);
> +	if (error)
> +		goto fail_free_buf;
> +
> +	trace_xfs_buf_get_uncached(bp, _RET_IP_);
> +	return bp;
> +
> + fail_free_buf:
> +	kmem_cache_free(xfs_buf_zone, bp);
> + fail:
> +	return NULL;
> +}
> +#endif
> diff --git a/libxfs/xfs_buf.h b/libxfs/xfs_buf.h
> new file mode 100644
> index 000000000000..0ed1f9793e15
> --- /dev/null
> +++ b/libxfs/xfs_buf.h
> @@ -0,0 +1,203 @@
> +#ifndef __LIBXFS_XFS_BUF_H_
> +#define __LIBXFS_XFS_BUF_H_
> +
> +struct xfs_buf;
> +struct xfs_mount;
> +struct xfs_perag;
> +struct xfs_buftarg;
> +
> +/*
> + * Base types
> + */
> +#define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
> +
> +typedef unsigned int xfs_buf_flags_t;
> +
> +bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
> +bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
> +
> +/* Finding and Reading Buffers */
> +struct xfs_buf_map {
> +	xfs_daddr_t		bm_bn;  /* block number for I/O */
> +	int			bm_len; /* size of I/O */
> +};
> +
> +#define DEFINE_SINGLE_BUF_MAP(map, blkno, numblk) \
> +	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
> +
> +struct xfs_buf_ops {
> +	char *name;
> +	union {
> +		__be32 magic[2];	/* v4 and v5 on disk magic values */
> +		__be16 magic16[2];	/* v4 and v5 on disk magic values */
> +	};
> +	void (*verify_read)(struct xfs_buf *);
> +	void (*verify_write)(struct xfs_buf *);
> +	xfs_failaddr_t (*verify_struct)(struct xfs_buf *);
> +};
> +
> +/*
> + * Internal state flags.
> + */
> +#define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
> +#define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
> +
> +typedef void (*xfs_buf_iodone_t)(struct xfs_buf *bp);
> +
> +/*
> + * This is a mess of userspace and kernel variables for the moment. It will
> + * clean up soon and should be identical between kernel and userspace..
> + */
> +struct xfs_buf {
> +	struct cache_node	b_node;
> +	struct list_head	b_hash;	/* will replace b_node */
> +	xfs_daddr_t		b_bn;
> +	unsigned int		b_length;
> +	unsigned int		b_flags;
> +	struct xfs_buftarg	*b_target;
> +	pthread_mutex_t		b_lock;
> +	pthread_t		b_holder;
> +	unsigned int		b_recur;
> +	void			*b_log_item;
> +	void			*b_transp;
> +	void			*b_addr;
> +	int			b_error;
> +	const struct xfs_buf_ops *b_ops;
> +	struct xfs_perag	*b_pag;
> +	struct xfs_mount	*b_mount;
> +	struct xfs_buf_map	*b_maps;
> +	struct xfs_buf_map	__b_map;
> +	int			b_map_count;
> +	int			b_io_remaining;
> +	int			b_io_error;
> +	struct list_head	b_list;
> +	struct list_head	b_li_list;	/* Log items list head */
> +
> +	struct list_head	b_btc_list;
> +	unsigned int		b_state;
> +	atomic_t		b_lru_ref;
> +	struct list_head	b_lru;
> +	atomic_t		b_hold;
> +	struct completion	b_iowait;
> +	struct semaphore	b_sema;
> +	xfs_buf_iodone_t	b_iodone;
> +};
> +
> +struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
> +			   xfs_daddr_t blkno, size_t numblks,
> +			   xfs_buf_flags_t flags);
> +
> +int xfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
> +			int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
> +int xfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
> +			int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp,
> +			const struct xfs_buf_ops *ops);
> +void xfs_buf_readahead_map(struct xfs_buftarg *target,
> +			       struct xfs_buf_map *map, int nmaps,
> +			       const struct xfs_buf_ops *ops);
> +
> +static inline int
> +xfs_buf_get(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	size_t			numblks,
> +	struct xfs_buf		**bpp)
> +{
> +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +
> +	return xfs_buf_get_map(target, &map, 1, 0, bpp);
> +}
> +
> +static inline int
> +xfs_buf_read(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	size_t			numblks,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp,
> +	const struct xfs_buf_ops *ops)
> +{
> +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +
> +	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
> +}
> +
> +static inline void
> +xfs_buf_readahead(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	size_t			numblks,
> +	const struct xfs_buf_ops *ops)
> +{
> +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	return xfs_buf_readahead_map(target, &map, 1, ops);
> +}
> +
> +int xfs_bwrite(struct xfs_buf *bp);
> +int xfs_bread(struct xfs_buf *bp, size_t bblen);
> +
> +#define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
> +
> +/* Locking and Unlocking Buffers */
> +int xfs_buf_trylock(struct xfs_buf *bp);
> +void xfs_buf_lock(struct xfs_buf *bp);
> +void xfs_buf_unlock(struct xfs_buf *bp);
> +
> +/* Releasing Buffers */
> +void xfs_buf_hold(struct xfs_buf *bp);
> +void xfs_buf_rele(struct xfs_buf *bp);
> +/*
> +static inline void xfs_buf_relse(struct xfs_buf *bp)
> +{
> +	xfs_buf_unlock(bp);
> +	xfs_buf_rele(bp);
> +}
> +*/
> +void xfs_buf_free(struct xfs_buf *bp);
> +
> +
> +/* Buffer Utility Routines */
> +extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
> +static inline int xfs_buf_submit(struct xfs_buf *bp)
> +{
> +	bool wait = bp->b_flags & XBF_ASYNC ? false : true;
> +	return __xfs_buf_submit(bp, wait);
> +}
> +
> +void xfs_buf_stale(struct xfs_buf *bp);
> +void xfs_buf_ioend(struct xfs_buf *bp);
> +void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
> +		xfs_failaddr_t failaddr);
> +void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
> +
> +#define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
> +
> +
> +/*
> + * These macros use the IO block map rather than b_bn. b_bn is now really
> + * just for the buffer cache index for cached buffers. As IO does not use b_bn
> + * anymore, uncached buffers do not use b_bn at all and hence must modify the IO
> + * map directly. Uncached buffers are not allowed to be discontiguous, so this
> + * is safe to do.
> + *
> + * In future, uncached buffers will pass the block number directly to the io
> + * request function and hence these macros will go away at that point.
> + */
> +#define XFS_BUF_ADDR(bp)		((bp)->b_maps[0].bm_bn)
> +
> +void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref);
> +
> +/*
> + * If the buffer is already on the LRU, do nothing. Otherwise set the buffer
> + * up with a reference count of 0 so it will be tossed from the cache when
> + * released.
> +static inline void xfs_buf_oneshot(struct xfs_buf *bp)
> +{
> +	if (!list_empty(&bp->b_lru) || atomic_read(&bp->b_lru_ref) > 1)
> +		return;
> +	atomic_set(&bp->b_lru_ref, 0);
> +}
> + */
> +
> + #endif	/* __LIBXFS_IO_H__ */
> +
> diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
> index 98b4996bea53..798980fdafeb 100644
> --- a/libxfs/xfs_buftarg.h
> +++ b/libxfs/xfs_buftarg.h
> @@ -85,9 +85,13 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
>  			  size_t bblen, int flags, struct xfs_buf **bpp,
>  			  const struct xfs_buf_ops *ops);
>  
> -int xfs_bread(struct xfs_buf *bp, size_t bblen);
> +void xfs_buftarg_submit_io(struct xfs_buf *bp);
>  
> -int xfs_bwrite(struct xfs_buf *bp);
> +/*
> + * Cached buffer memory manangement
> + */
> +int xfs_buf_allocate_memory(struct xfs_buf *bp, uint flags);
> +void xfs_buf_free_memory(struct xfs_buf *bp);
>  
>  /*
>   * Temporary: these need to be the same as the LIBXFS_B_* flags until we change
> @@ -99,6 +103,23 @@ int xfs_bwrite(struct xfs_buf *bp);
>  #define XBF_DONE	(1 << 3)	// LIBXFS_B_UPTODATE	0x0008
>  #define XBF_STALE	(1 << 2)	// LIBXFS_B_STALE	0x0004
>  
> +#define XBF_READ_AHEAD	(1 << 30) /* asynchronous read-ahead */
> +#define XBF_NO_IOACCT	(1 << 29) /* bypass I/O accounting (non-LRU bufs) */
> +#define XBF_ASYNC	(1 << 28) /* initiator will not wait for completion */
> +#define XBF_WRITE_FAIL	(0)	  /* unused in userspace */
> +
> +/* buffer type flags for write callbacks */
> +#define _XBF_INODES	(0)/* inode buffer */
> +#define _XBF_DQUOTS	(0)/* dquot buffer */
> +#define _XBF_LOGRECOVERY (0)/* log recovery buffer */
> +
> +/* flags used only as arguments to access routines */
> +#define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
> +#define XBF_UNMAPPED	 (0)	  /* unused in userspace */
> +
> +/* flags used only internally */
> +#define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> +
>  /*
>   * Raw buffer access functions. These exist as temporary bridges for uncached IO
>   * that uses direct access to the buffers to submit IO. These will go away with
> @@ -107,6 +128,12 @@ int xfs_bwrite(struct xfs_buf *bp);
>  struct xfs_buf *libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno,
>  			int bblen);
>  
> +/* temporary, just for compile for the moment */
> +#define xfs_buf_ioend_async(bp)		xfs_buf_ioend(bp)
> +#define bdi_read_congested(bdi)		(false)
> +#define xfs_buf_ispinned(bp)		(false)
> +#define xfs_buf_wait_unpin(bp)		((void)0)
> +
>  /*
>   * Hash cache implementation
>   */
> -- 
> 2.28.0
> 
