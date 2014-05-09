Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1AD157F5D
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 21:14:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2AC4304043
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 19:14:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QADrpC64gXE2JHkB for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 19:14:27 -0700 (PDT)
Message-ID: <536C3A07.2050100@sandeen.net>
Date: Thu, 08 May 2014 21:14:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] repair: don't unlock prefetch tree to read discontig
	buffers
References: <1399598222-4349-1-git-send-email-david@fromorbit.com>
	<1399598222-4349-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1399598222-4349-2-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 5/8/14, 8:17 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The way discontiguous buffers are currently handled in prefetch is
> by unlocking the prefetch tree and reading them one at a time in
> pf_read_discontig(), inside the normal loop of searching for buffers
> to read in a more optimized fashion.
> 
> But by unlocking the tree, we allow other threads to come in and
> find buffers which we've already stashed locally on our bplist[].
> If 2 threads think they own the same set of buffers, they may both
> try to delete them from the prefetch btree, and the second one to
> arrive will not find it, resulting in:
> 
>         fatal error -- prefetch corruption
> 
> To fix this, simply abort the buffer gathering loop when we come
> across a discontiguous buffer, process the gathered list as per
> normal, and then after running the large optimised read, check to
> see if the last buffer on the list is a discontiguous buffer.
> If is is discontiguous, then issue the discontiguous buffer read
> while the locks are not held. We only ever have one discontiguous
> buffer per read loop, so it is safe just to check the last buffer in
> the list.
> 
> The fix is loosely based on a a patch provided by Eric Sandeen, who
> did all the hard work of finding the bug and demonstrating how to
> fix it.

Ok, this makes sense to me.  The comment above the discontig read
seems a bit confusing; you say it's safe to read while unlocked,
but I wouldn't have expected it not to be - the lock is just for
btree manipulation, and that's not being done.  So I think the
comment adds a little confusion rather than clarification.

But the code looks fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Reported-by:Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/prefetch.c | 53 +++++++++++++++++++++++++++--------------------------
>  1 file changed, 27 insertions(+), 26 deletions(-)
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 65fedf5..e269f1f 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -444,27 +444,6 @@ pf_read_inode_dirs(
>  }
>  
>  /*
> - * Discontiguous buffers require multiple IOs to fill, so we can't use any
> - * linearising, hole filling algorithms on them to avoid seeks. Just remove them
> - * for the prefetch queue and read them straight into the cache and release
> - * them.
> - */
> -static void
> -pf_read_discontig(
> -	struct prefetch_args	*args,
> -	struct xfs_buf		*bp)
> -{
> -	if (!btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp, bp->b_bn)))
> -		do_error(_("prefetch corruption\n"));
> -
> -	pthread_mutex_unlock(&args->lock);
> -	libxfs_readbufr_map(mp->m_ddev_targp, bp, 0);
> -	bp->b_flags |= LIBXFS_B_UNCHECKED;
> -	libxfs_putbuf(bp);
> -	pthread_mutex_lock(&args->lock);
> -}
> -
> -/*
>   * pf_batch_read must be called with the lock locked.
>   */
>  static void
> @@ -496,13 +475,19 @@ pf_batch_read(
>  		}
>  		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
>  			/*
> -			 * Handle discontiguous buffers outside the seek
> -			 * optimised IO loop below.
> +			 * Discontiguous buffers need special handling, so stop
> +			 * gathering new buffers and process the list and this
> +			 * discontigous buffer immediately. This avoids the
> +			 * complexity of keeping a separate discontigous buffer
> +			 * list and seeking back over ranges we've already done
> +			 * optimised reads for.
>  			 */
>  			if ((bplist[num]->b_flags & LIBXFS_B_DISCONTIG)) {
> -				pf_read_discontig(args, bplist[num]);
> -				bplist[num] = NULL;
> -			} else if (which != PF_META_ONLY ||
> +				num++;
> +				break;
> +			}
> +
> +			if (which != PF_META_ONLY ||
>  				   !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
>  				num++;
>  			if (num == MAX_BUFS)
> @@ -570,6 +555,22 @@ pf_batch_read(
>  		 * now read the data and put into the xfs_but_t's
>  		 */
>  		len = pread64(mp_fd, buf, (int)(last_off - first_off), first_off);
> +
> +		/*
> +		 * Check the last buffer on the list to see if we need to
> +		 * process a discontiguous buffer. The gather loop guarantees
> +		 * we only ever have a single discontig buffer on the list,
> +		 * and that it is the last buffer, so it is safe to do this
> +		 * check and read here like this while we aren't holding any
> +		 * locks.
> +		 */
> +		if ((bplist[num - 1]->b_flags & LIBXFS_B_DISCONTIG)) {
> +			libxfs_readbufr_map(mp->m_ddev_targp, bplist[num - 1], 0);
> +			bplist[num - 1]->b_flags |= LIBXFS_B_UNCHECKED;
> +			libxfs_putbuf(bplist[num - 1]);
> +			num--;
> +		}
> +
>  		if (len > 0) {
>  			/*
>  			 * go through the xfs_buf_t list copying from the
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
