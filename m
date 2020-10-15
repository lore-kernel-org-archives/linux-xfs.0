Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7556C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D5B2225D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:16:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rhi8Klkt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404748AbgJORQc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 13:16:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404754AbgJORQc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 13:16:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHAYKO106924;
        Thu, 15 Oct 2020 17:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MTq5L5mct48xB3QK5tzmjo83oMDdaofLVS1p7Lkj168=;
 b=rhi8Klkt5sIPr2F3c7Y6qadhamTMQv1PS1xscy5TEuluzbsI+nGcPuMsYDDxwRjPRlJM
 EbUAoKLX1qcIgzv+t9TJwEy//M5wgJi2YYPNId+xyFfoVwpGvClwDzwxNY6r5sKPY++e
 I2TtRiQxidJpVaQJjFFXzPoO49yl4xuZz8zqa++E7NqZA2jE8FpB46wXIW2sjkamTEIW
 xkyegSgnkqRfUBAoqP7cq6f7ONsN/wEbDlnN4dFmbusdoAJu0DlGHNWyl9ZGg9ffqkJm
 haj/M9RBYXdAumgF+h7A9rz9SQWyjnTnY2JvfnBToQkSsN5LlFz/a5kkc+IbVK194WWk ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3434wkwx9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 17:16:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHBLgB123480;
        Thu, 15 Oct 2020 17:16:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 343pv24a10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 17:16:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09FHGRCS008190;
        Thu, 15 Oct 2020 17:16:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 10:16:26 -0700
Date:   Thu, 15 Oct 2020 10:16:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/27] libxfs: introduce userspace buftarg infrastructure
Message-ID: <20201015171625.GW9832@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-16-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=1 suspectscore=5 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=5 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move the uncached buffer IO API into the xfs_buftarg.h and the local
> buftarg implementation. The uncached buffer IO implementation is
> different between kernel and userspace, but the API is the same.
> Hence implement it via the buftarg abstraction.
> 
> Pull the "alloc_write_buf()" function from mkfs up into the API as
> xfs_buf_get_uncached_daddr() so that it can be used in other places
> that need the same functionality.

But this doesn't actually remove alloc_write_buf from xfs_mkfs.c...

> The API movement still uses the existing raw buffer allocation
> and read IO implementation. This requires us to temporarily export
> the the prototypes for these functions in xfs_buftarg.h. They will
> go away once the buftarg has it's own buffer allocation and IO
> engine implementations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/buftarg.c     | 90 ++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_io.h   | 22 +----------
>  libxfs/rdwr.c        | 88 ++++++-------------------------------------
>  libxfs/xfs_buftarg.h | 39 +++++++++++++++++++
>  mkfs/xfs_mkfs.c      | 29 ++++++++++----
>  5 files changed, 164 insertions(+), 104 deletions(-)
> 
> diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
> index d4bcb2936f01..2a0aad2e0f8c 100644
> --- a/libxfs/buftarg.c
> +++ b/libxfs/buftarg.c
> @@ -97,3 +97,93 @@ xfs_buftarg_free(
>  	platform_flush_device(btp->bt_fd, btp->bt_bdev);
>  	free(btp);
>  }
> +
> +/*
> + * Allocate an uncached buffer that points at daddr.  The refcount will be 1,
> + * and the cache node hash list will be empty to indicate that it's uncached.
> + */
> +int
> +xfs_buf_get_uncached_daddr(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		daddr,
> +	size_t			bblen,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_buf	*bp;
> +
> +	bp = libxfs_getbufr(target, daddr, bblen);
> +	if (!bp)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&bp->b_node.cn_hash);
> +	bp->b_node.cn_count = 1;
> +	bp->b_bn = daddr;
> +        bp->b_maps[0].bm_bn = daddr;

This function has all kinds of indent weirdness.

The general approach seems ok so far, but WIP indeed. :)

--D

> +	*bpp = bp;
> +	return 0;
> +}
> +
> +int
> +xfs_buf_read_uncached(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		daddr,
> +	size_t			bblen,
> +	int			flags,
> +	struct xfs_buf		**bpp,
> +	const struct xfs_buf_ops *ops)
> +{
> +	struct xfs_buf		 *bp;
> +	int			error;
> +
> +
> +	error = xfs_buf_get_uncached(target, bblen, flags, &bp);
> +	if (error)
> +		return error;
> +
> +	error = libxfs_readbufr(target, daddr, bp, bblen, flags);
> +	if (error)
> +		goto release_buf;
> +
> +	error = libxfs_readbuf_verify(bp, ops);
> +	if (error)
> +		goto release_buf;
> +
> +	*bpp = bp;
> +	return 0;
> +
> +release_buf:
> +	libxfs_buf_relse(bp);
> +	return error;
> +}
> +
> +/*
> + * Return a buffer associated to external memory via xfs_buf_associate_memory()
> + * back to it's empty state.
> + */
> +void
> +xfs_buf_set_empty(
> +	struct xfs_buf		*bp,
> +	size_t			numblks)
> +{
> +	bp->b_addr = NULL;
> +	bp->b_length = numblks;
> +
> +	ASSERT(bp->b_map_count == 1);
> +	bp->b_bn = XFS_BUF_DADDR_NULL;
> +	bp->b_maps[0].bm_bn = XFS_BUF_DADDR_NULL;
> +	bp->b_maps[0].bm_len = bp->b_length;
> +}
> +
> +/*
> + * Associate external memory with an empty uncached buffer.
> + */
> +int
> +xfs_buf_associate_memory(
> +	struct xfs_buf		*bp,
> +	void			*mem,
> +	size_t			len)
> +{
> +	bp->b_addr = mem;
> +	bp->b_length = BTOBB(len);
> +	return 0;
> +}
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 0f9630e8e17a..7f8fd88f7de8 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -61,7 +61,7 @@ struct xfs_buf {
>  	struct xfs_mount	*b_mount;
>  	struct xfs_buf_map	*b_maps;
>  	struct xfs_buf_map	__b_map;
> -	int			b_nmaps;
> +	int			b_map_count;
>  	struct list_head	b_list;
>  };
>  
> @@ -77,8 +77,6 @@ bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
>  
>  typedef unsigned int xfs_buf_flags_t;
>  
> -#define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
> -
>  #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
>  #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
>  
> @@ -148,10 +146,6 @@ extern int	libxfs_bcache_overflowed(void);
>  
>  /* Buffer (Raw) Interfaces */
>  int		libxfs_bwrite(struct xfs_buf *bp);
> -extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t,
> -				struct xfs_buf *, int, int);
> -extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
> -
>  extern int	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
>  
>  extern int libxfs_bhash_size;
> @@ -170,26 +164,12 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  			 cksum_offset);
>  }
>  
> -static inline int
> -xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
> -{
> -	bp->b_addr = mem;
> -	bp->b_length = BTOBB(len);
> -	return 0;
> -}
> -
>  static inline void
>  xfs_buf_hold(struct xfs_buf *bp)
>  {
>  	bp->b_node.cn_count++;
>  }
>  
> -int libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags,
> -		struct xfs_buf **bpp);
> -int libxfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
> -		size_t bblen, int flags, struct xfs_buf **bpp,
> -		const struct xfs_buf_ops *ops);
> -
>  /* Push a single buffer on a delwri queue. */
>  static inline bool
>  xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 5ab1987eb0fe..3e755402b024 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -249,7 +249,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
>  	INIT_LIST_HEAD(&bp->b_li_list);
>  
>  	if (!bp->b_maps) {
> -		bp->b_nmaps = 1;
> +		bp->b_map_count = 1;
>  		bp->b_maps = &bp->__b_map;
>  		bp->b_maps[0].bm_bn = bp->b_bn;
>  		bp->b_maps[0].bm_len = bp->b_length;
> @@ -279,7 +279,7 @@ libxfs_initbuf_map(struct xfs_buf *bp, struct xfs_buftarg *btp,
>  			strerror(errno));
>  		exit(1);
>  	}
> -	bp->b_nmaps = nmaps;
> +	bp->b_map_count = nmaps;
>  
>  	bytes = 0;
>  	for ( i = 0; i < nmaps; i++) {
> @@ -331,7 +331,7 @@ __libxfs_getbufr(int blen)
>  	return bp;
>  }
>  
> -static struct xfs_buf *
> +struct xfs_buf *
>  libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
>  {
>  	struct xfs_buf	*bp;
> @@ -617,7 +617,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
>  
>  	fd = libxfs_device_to_fd(btp->bt_bdev);
>  	buf = bp->b_addr;
> -	for (i = 0; i < bp->b_nmaps; i++) {
> +	for (i = 0; i < bp->b_map_count; i++) {
>  		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
>  		int len = BBTOB(bp->b_maps[i].bm_len);
>  
> @@ -707,75 +707,6 @@ err:
>  	return error;
>  }
>  
> -/* Allocate a raw uncached buffer. */
> -static inline struct xfs_buf *
> -libxfs_getbufr_uncached(
> -	struct xfs_buftarg	*targ,
> -	xfs_daddr_t		daddr,
> -	size_t			bblen)
> -{
> -	struct xfs_buf		*bp;
> -
> -	bp = libxfs_getbufr(targ, daddr, bblen);
> -	if (!bp)
> -		return NULL;
> -
> -	INIT_LIST_HEAD(&bp->b_node.cn_hash);
> -	bp->b_node.cn_count = 1;
> -	return bp;
> -}
> -
> -/*
> - * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
> - * and the cache node hash list will be empty to indicate that it's uncached.
> - */
> -int
> -libxfs_buf_get_uncached(
> -	struct xfs_buftarg	*targ,
> -	size_t			bblen,
> -	int			flags,
> -	struct xfs_buf		**bpp)
> -{
> -	*bpp = libxfs_getbufr_uncached(targ, XFS_BUF_DADDR_NULL, bblen);
> -	return *bpp != NULL ? 0 : -ENOMEM;
> -}
> -
> -/*
> - * Allocate and read an uncached buffer.  The refcount will be 1, and the cache
> - * node hash list will be empty to indicate that it's uncached.
> - */
> -int
> -libxfs_buf_read_uncached(
> -	struct xfs_buftarg	*targ,
> -	xfs_daddr_t		daddr,
> -	size_t			bblen,
> -	int			flags,
> -	struct xfs_buf		**bpp,
> -	const struct xfs_buf_ops *ops)
> -{
> -	struct xfs_buf		*bp;
> -	int			error;
> -
> -	*bpp = NULL;
> -	bp = libxfs_getbufr_uncached(targ, daddr, bblen);
> -	if (!bp)
> -		return -ENOMEM;
> -
> -	error = libxfs_readbufr(targ, daddr, bp, bblen, flags);
> -	if (error)
> -		goto err;
> -
> -	error = libxfs_readbuf_verify(bp, ops);
> -	if (error)
> -		goto err;
> -
> -	*bpp = bp;
> -	return 0;
> -err:
> -	libxfs_buf_relse(bp);
> -	return error;
> -}
> -
>  static int
>  __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
>  {
> @@ -836,7 +767,7 @@ libxfs_bwrite(
>  		int	i;
>  		void	*buf = bp->b_addr;
>  
> -		for (i = 0; i < bp->b_nmaps; i++) {
> +		for (i = 0; i < bp->b_map_count; i++) {
>  			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
>  			int len = BBTOB(bp->b_maps[i].bm_len);
>  
> @@ -1207,6 +1138,7 @@ libxfs_log_clear(
>  	xfs_daddr_t		blk;
>  	xfs_daddr_t		end_blk;
>  	char			*ptr;
> +	int			error;
>  
>  	if (((btp && dptr) || (!btp && !dptr)) ||
>  	    (btp && !btp->bt_bdev) || !fs_uuid)
> @@ -1236,7 +1168,9 @@ libxfs_log_clear(
>  	/* write out the first log record */
>  	ptr = dptr;
>  	if (btp) {
> -		bp = libxfs_getbufr_uncached(btp, start, len);
> +		error = xfs_buf_get_uncached_daddr(btp, start, len, &bp);
> +		if (error)
> +			return error;
>  		ptr = bp->b_addr;
>  	}
>  	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
> @@ -1284,7 +1218,9 @@ libxfs_log_clear(
>  
>  		ptr = dptr;
>  		if (btp) {
> -			bp = libxfs_getbufr_uncached(btp, blk, len);
> +			error = xfs_buf_get_uncached_daddr(btp, blk, len, &bp);
> +			if (error)
> +				return error;
>  			ptr = bp->b_addr;
>  		}
>  		/*
> diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
> index 1bc3a4d0bc9c..5429c96c0547 100644
> --- a/libxfs/xfs_buftarg.h
> +++ b/libxfs/xfs_buftarg.h
> @@ -11,6 +11,8 @@ struct xfs_mount;
>  struct xfs_buf;
>  struct xfs_buf_ops;
>  
> +#define XFS_BUF_DADDR_NULL ((xfs_daddr_t) (-1LL))
> +
>  /*
>   * The xfs_buftarg contains 2 notions of "sector size" -
>   *
> @@ -52,4 +54,41 @@ int xfs_buftarg_setsize(struct xfs_buftarg *target, unsigned int size);
>  
>  #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
>  
> +/*
> + * Low level buftarg IO routines.
> + *
> + * This includes the uncached buffer IO API, as the memory management associated
> + * with uncached buffers is tightly tied to the kernel buffer implementation.
> + */
> +
> +void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
> +int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
> +
> +int xfs_buf_get_uncached_daddr(struct xfs_buftarg *target, xfs_daddr_t daddr,
> +				size_t bblen, struct xfs_buf **bpp);
> +static inline int
> +xfs_buf_get_uncached(
> +	struct xfs_buftarg	*target,
> +	size_t			bblen,
> +	int			flags,
> +	struct xfs_buf		**bpp)
> +{
> +	return xfs_buf_get_uncached_daddr(target, XFS_BUF_DADDR_NULL, bblen, bpp);
> +}
> +
> +int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
> +			  size_t bblen, int flags, struct xfs_buf **bpp,
> +			  const struct xfs_buf_ops *ops);
> +
> +/*
> + * Raw buffer access functions. These exist as temporary bridges for uncached IO
> + * that uses direct access to the buffers to submit IO. These will go away with
> + * the new buffer cache IO engine.
> + */
> +struct xfs_buf *libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno,
> +			int bblen);
> +int libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, struct xfs_buf *, int,
> +			int);
> +int libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
> +
>  #endif /* __XFS_BUFTARG_H */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 794955a9624c..87e1881e3152 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3463,6 +3463,7 @@ prepare_devices(
>  	struct xfs_buf		*buf;
>  	int			whack_blks = BTOBB(WHACK_SIZE);
>  	int			lsunit;
> +	int			error;
>  
>  	/*
>  	 * If there's an old XFS filesystem on the device with enough intact
> @@ -3496,8 +3497,10 @@ prepare_devices(
>  	 * the end of the device.  (MD sb is ~64k from the end, take out a wider
>  	 * swath to be sure)
>  	 */
> -	buf = alloc_write_buf(mp->m_ddev_targp, (xi->dsize - whack_blks),
> -			whack_blks);
> +	error = xfs_buf_get_uncached_daddr(mp->m_ddev_targp,
> +				(xi->dsize - whack_blks), whack_blks, &buf);
> +	if (error)
> +		goto out_error;
>  	memset(buf->b_addr, 0, WHACK_SIZE);
>  	libxfs_buf_mark_dirty(buf);
>  	libxfs_buf_relse(buf);
> @@ -3508,14 +3511,18 @@ prepare_devices(
>  	 * swap (somewhere around the page size), jfs (32k),
>  	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
>  	 */
> -	buf = alloc_write_buf(mp->m_ddev_targp, 0, whack_blks);
> +	error = xfs_buf_get_uncached_daddr(mp->m_ddev_targp, 0, whack_blks, &buf);
> +	if (error)
> +		goto out_error;
>  	memset(buf->b_addr, 0, WHACK_SIZE);
>  	libxfs_buf_mark_dirty(buf);
>  	libxfs_buf_relse(buf);
>  
>  	/* OK, now write the superblock... */
> -	buf = alloc_write_buf(mp->m_ddev_targp, XFS_SB_DADDR,
> -			XFS_FSS_TO_BB(mp, 1));
> +	error = xfs_buf_get_uncached_daddr(mp->m_ddev_targp, XFS_SB_DADDR,
> +			XFS_FSS_TO_BB(mp, 1), &buf);
> +	if (error)
> +		goto out_error;
>  	buf->b_ops = &xfs_sb_buf_ops;
>  	memset(buf->b_addr, 0, cfg->sectorsize);
>  	libxfs_sb_to_disk(buf->b_addr, sbp);
> @@ -3536,14 +3543,22 @@ prepare_devices(
>  	/* finally, check we can write the last block in the realtime area */
>  	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_bdev &&
>  	    cfg->rtblocks > 0) {
> -		buf = alloc_write_buf(mp->m_rtdev_targp,
> +		error = xfs_buf_get_uncached_daddr(mp->m_rtdev_targp,
>  				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
> -				BTOBB(cfg->blocksize));
> +				BTOBB(cfg->blocksize), &buf);
> +		if (error)
> +			goto out_error;
>  		memset(buf->b_addr, 0, cfg->blocksize);
>  		libxfs_buf_mark_dirty(buf);
>  		libxfs_buf_relse(buf);
>  	}
>  
> +	return;
> +
> +out_error:
> +	fprintf(stderr, _("Could not get memory for buffer, err=%d\n"),
> +			error);
> +	exit(1);
>  }
>  
>  static void
> -- 
> 2.28.0
> 
