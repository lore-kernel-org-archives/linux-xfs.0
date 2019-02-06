Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38662 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfBFSIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 13:08:42 -0500
Date: Wed, 6 Feb 2019 10:08:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/9] xfs: set buffer ops when repair probes for btree
 type
Message-ID: <20190206180835.GQ7991@magnolia>
References: <20190204145231.47034-1-bfoster@redhat.com>
 <20190204145231.47034-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204145231.47034-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:52:23AM -0500, Brian Foster wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> In xrep_findroot_block, we work out the btree type and correctness of a
> given block by calling different btree verifiers on root block
> candidates.  However, we leave the NULL b_ops while ->verify_read
> validates the block, which means that if the verifier calls
> xfs_buf_verifier_error it'll crash on the null b_ops.  Fix it to set
> b_ops before calling the verifier and unsetting it if the verifier
> fails.
> 
> Furthermore, improve the documentation around xfs_buf_ensure_ops, which
> is the function that is responsible for cleaning up the b_ops state of
> buffers that go through xrep_findroot_block but don't match anything.
> 
> [bfoster: Renamed xfs_buf_ensure_ops() and modified comment.]

Heh, I already queued up the original patch for 5.0 so that we don't
oops the kernel. :/

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/scrub/repair.c  | 11 ++++++++---
>  fs/xfs/xfs_buf.c       | 22 ++++++++++++++++------
>  fs/xfs/xfs_buf.h       |  2 +-
>  fs/xfs/xfs_trans_buf.c |  2 +-
>  4 files changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 1c8eecfe52b8..6acf1bfa0bfe 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -768,18 +768,23 @@ xrep_findroot_block(
>  		if (!uuid_equal(&btblock->bb_u.s.bb_uuid,
>  				&mp->m_sb.sb_meta_uuid))
>  			goto out;
> +		/*
> +		 * Read verifiers can reference b_ops, so we set the pointer
> +		 * here.  If the verifier fails we'll reset the buffer state
> +		 * to what it was before we touched the buffer.
> +		 */
> +		bp->b_ops = fab->buf_ops;
>  		fab->buf_ops->verify_read(bp);
>  		if (bp->b_error) {
> +			bp->b_ops = NULL;
>  			bp->b_error = 0;
>  			goto out;
>  		}
>  
>  		/*
>  		 * Some read verifiers will (re)set b_ops, so we must be
> -		 * careful not to blow away any such assignment.
> +		 * careful not to change b_ops after running the verifier.
>  		 */
> -		if (!bp->b_ops)
> -			bp->b_ops = fab->buf_ops;
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index eedc5e0156ff..222b5260ed35 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -776,13 +776,23 @@ _xfs_buf_read(
>  }
>  
>  /*
> - * If the caller passed in an ops structure and the buffer doesn't have ops
> - * assigned, set the ops and use them to verify the contents.  If the contents
> - * cannot be verified, we'll clear XBF_DONE.  We assume the buffer has no
> - * recorded errors and is already in XBF_DONE state.
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
> + * type.

I would like to add a sentence here explicitly saying that if repair
can't establish the buffer type from the verifiers then the buffer is
left in memory with null b_ops.

>   */
>  int
> -xfs_buf_ensure_ops(
> +xfs_buf_reverify(

I like the name and the comment better than my original version, so I'll
rework this patch as a separate "rename and unfrobulate documentation"
thing and send it out.

--D

>  	struct xfs_buf		*bp,
>  	const struct xfs_buf_ops *ops)
>  {
> @@ -824,7 +834,7 @@ xfs_buf_read_map(
>  		return bp;
>  	}
>  
> -	xfs_buf_ensure_ops(bp, ops);
> +	xfs_buf_reverify(bp, ops);
>  
>  	if (flags & XBF_ASYNC) {
>  		/*
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index b9f5511ea998..1c436a85b71d 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -385,6 +385,6 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
>  #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
>  
> -int xfs_buf_ensure_ops(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
> +int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
>  
>  #endif	/* __XFS_BUF_H__ */
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 629f1479c9d2..7d65ebf1e847 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -277,7 +277,7 @@ xfs_trans_read_buf_map(
>  		 * release this buffer when it kills the tranaction.
>  		 */
>  		ASSERT(bp->b_ops != NULL);
> -		error = xfs_buf_ensure_ops(bp, ops);
> +		error = xfs_buf_reverify(bp, ops);
>  		if (error) {
>  			xfs_buf_ioerror_alert(bp, __func__);
>  
> -- 
> 2.17.2
> 
