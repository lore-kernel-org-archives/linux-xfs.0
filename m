Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfA1M1j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jan 2019 07:27:39 -0500
Date: Mon, 28 Jan 2019 07:27:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: set buffer ops when repair probes for btree type
Message-ID: <20190128122736.GA6662@bfoster>
References: <20190127180050.GE4368@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190127180050.GE4368@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sun, Jan 27, 2019 at 10:00:50AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
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
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/repair.c |   11 ++++++++---
>  fs/xfs/xfs_buf.c      |   16 ++++++++++++++++
>  2 files changed, 24 insertions(+), 3 deletions(-)
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
> index eedc5e0156ff..3316e444b973 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -776,10 +776,26 @@ _xfs_buf_read(
>  }
>  
>  /*
> + * Set buffer ops on an unchecked buffer and validate it, if possible.
> + *
>   * If the caller passed in an ops structure and the buffer doesn't have ops
>   * assigned, set the ops and use them to verify the contents.  If the contents
>   * cannot be verified, we'll clear XBF_DONE.  We assume the buffer has no
>   * recorded errors and is already in XBF_DONE state.
> + *
> + * Under normal operations, every in-core buffer must have buffer ops assigned
> + * to them when the buffer is read in from disk so that we can validate the
> + * metadata.
> + *
> + * However, there are two scenarios where one can encounter in-core buffers
> + * that don't have buffer ops.  The first is during log recovery of buffers on
> + * a V4 filesystem, though these buffers are purged at the end of recovery.
> + *
> + * The other is online repair, which tries to match arbitrary metadata blocks
> + * with btree types in order to find the root.  If online repair doesn't match
> + * the buffer with /any/ btree type, the buffer remains in memory in DONE state
> + * with no ops, and a subsequent read_buf call from elsewhere will not set the
> + * ops.  This function helps us fix this situation.
>   */
>  int
>  xfs_buf_ensure_ops(
