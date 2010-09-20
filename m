Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8K0vLwK193870 for <xfs@oss.sgi.com>; Sun, 19 Sep 2010 19:57:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55420865D4
	for <xfs@oss.sgi.com>; Sun, 19 Sep 2010 17:58:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	05syMuBaWTaKrhGj for <xfs@oss.sgi.com>;
	Sun, 19 Sep 2010 17:58:12 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39959528-1927428
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 10:28:10 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1OxUhr-0004MU-V0
	for xfs@oss.sgi.com; Mon, 20 Sep 2010 10:58:08 +1000
Date: Mon, 20 Sep 2010 10:58:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: prevent bmap btree from using alloc btree
	reserved blocks
Message-ID: <20100920005807.GN24409@dastard>
References: <1282657533-3400-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282657533-3400-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

ping?

On Tue, Aug 24, 2010 at 11:45:33PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recently we've had WANT_CORRUPTED_GOTO filesystem shutdowns reported
> on filesystems with large numbers of small AGs. RedHat QA found a
> simple test case at:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=626244
> 
> Which was further refined to:
> 
> # mkfs.xfs -f -d agsize=16m,size=50g <dev>
> # mount <dev> /mnt
> # xfs_io -f -c 'resvsp 0 40G' /mnt/foo
> 
> The initial analysis is in the above bug. The fundamental problem is
> that the data extent allocation is using all the free blocks in the
> allocation group, and then the bmap btree block allocation is
> dipping into the reserved block pool that each AG holds for
> freespace btree manipulations. This results in failures when
> multiple bmap btree blocks are needed for a multilevel split of the
> bmap btree.
> 
> The reason this is occurring is that when we do a btree block
> allocation after a data extent allocation we run down the path that
> does not set up the minleft allocation parameter. That is, we allow
> the btree block allocation to use up all the blocks in the current
> AG if that is what will make the current allocation succeed. This
> what we are supposed to only allow the low space allocation
> algorithm to do, not a normal allocation. The result is that we can
> allocate the first block from the AG freelist, and then the second
> block allocation in the split will fail in the same AG because we do
> not have a minleft parameter set and hence will not pass the checks
> in xfs_alloc_fix_freelist() and hence the allocation will fail.
> Further, because no minleft parameter is set, the btree block
> allocation will not retry the allocation with different parameters
> and (potentially) enable the low space algorithm.
> 
> The result is that we fail a btree block allocation and hence fail
> the extent allocation with a dirty btree and transaction. The dirty
> btree causes the WANT_CORRUPTED_GOTO warning, and cancelling the
> dirty transaction triggers the shutdown.
> 
> The fix appears to be to ensure that we set the minleft parameter
> correctly to reflect the potential number of btree blocks we still
> need to allocate from the same AG if we are doing a worst case
> split. By doing so, the particular case results in the first btree
> block allocation setting minleft to the number of blocks needed for
> a split. Hence the AG that we just allocated all the free blocks out
> of for the data extent will fail because there are not enough free
> blocks for all the blocks in the split in the AG. It will fail this
> without dirtying anything, and because minleft is now > 0, will
> trigger the retry algorithm.
> 
> The fallback algorithm also needs a slight modification. It
> currently assumes that if minleft is set, no allocation has been
> done yet, so it can scan from AG 0 to find a free block. If it is
> left like this, it can trigger deadlocks from the new case as we
> have a prior allocation and hence cannot allocate from an AG less
> than the current AG. Hence it is modified to use a START_AG
> allocation to scan upwards from the current AG, hence avoiding the
> known AG locking deadlocks.
> 
> As far as I can tell, the bmap btree code has never handled this
> case properly - I checked as far back as 1995 and minleft has never
> been set to avoid selecting an AG that cannot be allocated out of...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_btree.c |   51 ++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 42 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
> index 87d3c10..d5ef4e3 100644
> --- a/fs/xfs/xfs_bmap_btree.c
> +++ b/fs/xfs/xfs_bmap_btree.c
> @@ -538,6 +538,25 @@ xfs_bmbt_alloc_block(
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> +
> +		/*
> +		 * we've come in here because this is the second or subsequent
> +		 * btree block we need to allocate for the bmap btree
> +		 * modification. If we've just emptied the AG and there are
> +		 * only free list blocks left, we need to make sure that we
> +		 * take into account the minleft value that was reserved on the
> +		 * first allocation through here (the NULLFSBLOCK branch
> +		 * above). In that case, minleft will already take into account
> +		 * the maximum number of blocks needed for a btree split, and
> +		 * the number of blocks already allocated is recorded in the
> +		 * cursor. From that, we can work out exactly how much smaller
> +		 * the minleft should be so that we don't select an AG that
> +		 * does not have enough blocks available to continue the entire
> +		 * btree split.
> +		 */
> +		args.minleft = XFS_BM_MAXLEVELS(args.mp,
> +					(int)cur->bc_private.b.whichfork) - 1 -
> +				cur->bc_private.b.allocated;
>  	}
>  
>  	args.minlen = args.maxlen = args.prod = 1;
> @@ -550,15 +569,29 @@ xfs_bmbt_alloc_block(
>  	if (error)
>  		goto error0;
>  
> -	if (args.fsbno == NULLFSBLOCK && args.minleft) {
> -		/*
> -		 * Could not find an AG with enough free space to satisfy
> -		 * a full btree split.  Try again without minleft and if
> -		 * successful activate the lowspace algorithm.
> -		 */
> -		args.fsbno = 0;
> -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		args.minleft = 0;
> +	while (args.fsbno == NULLFSBLOCK && args.minleft) {
> +		if (cur->bc_private.b.firstblock == NULLFSBLOCK) {
> +			/*
> +			 * Could not find an AG with enough free space to satisfy
> +			 * a full btree split.  Try again without minleft and if
> +			 * successful activate the lowspace algorithm.
> +			 */
> +			args.type = XFS_ALLOCTYPE_FIRST_AG;
> +			args.fsbno = 0;
> +			args.minleft = 0;
> +		} else {
> +			/*
> +			 * Failed to find enough space for a btree block after
> +			 * a extent allocation has already occurred. Continue
> +			 * searching other AGs that can hold the remaining
> +			 * blocks. If we fail with minleft set, then clear it
> +			 * and try again.
> +			 */
> +			args.type = XFS_ALLOCTYPE_START_AG;
> +			args.fsbno = cur->bc_private.b.firstblock;
> +			if (cur->bc_private.b.flist->xbf_low)
> +				args.minleft = 0;
> +		}
>  		error = xfs_alloc_vextent(&args);
>  		if (error)
>  			goto error0;
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
