Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C2AD7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 16:01:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 664A7304043
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:01:41 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VXxTI7HSuDvFEz6x for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 14:01:39 -0800 (PST)
Date: Tue, 11 Feb 2014 09:01:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid AGI/AGF deadlock scenario for inode chunk
	allocation
Message-ID: <20140210220134.GU13647@dastard>
References: <1392042807-41697-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392042807-41697-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 10, 2014 at 09:33:27AM -0500, Brian Foster wrote:
> The inode chunk allocation path can lead to deadlock conditions if
> a transaction is dirtied with an AGF (to fix up the freelist) for
> an AG that cannot satisfy the actual allocation request. This code
> path is written to try and avoid this scenario, but it can be
> reproduced by running xfstests generic/270 in a loop on a 512b fs.

Yup, I've been seeing this problem for a few months now. Frequently
enough that I expunged 269 and 270 from my 1k block size test
machines. I simply hadn't found the time to debug it...

> An example situation is:
> - process A attempts an inode allocation on AG 3, modifies
>   the freelist, fails the allocation and ultimately moves on to
>   AG 0 with the AG 3 AGF held
> - process B is doing a free space operation (i.e., truncate) and
>   acquires the AG 0 AGF, waits on the AG 3 AGF
> - process A acquires the AG 0 AGI, waits on the AG 0 AGF (deadlock)

Yup, the "dirty an AGF then fail to allocate" is the typical cause
of shutdowns due to cancelling a dirty create transaction because of
ENOSPC. I'm not surprised that we can trigger deadlocks like this,
either.

> The problem here is that process A acquired the AG 3 AGF while
> moving on to AG 0 (and releasing the AG 3 AGI with the AG 3 AGF
> held).

Right, AGF/AGI locking order is ascending AG order only.

> xfs_dialloc() makes one pass through each of the AGs when
> attempting to allocate an inode chunk. The expectation is a clean
> transaction if a particular AG cannot satisfy the allocation
> request. xfs_ialloc_ag_alloc() is written to support this through
> use of the minalignslop allocation args field.

*nod*

> When using the agi->agi_newino optimization, we attempt an exact
> bno allocation request based on the location of the previously
> allocated chunk. minalignslop is set to inform the allocator that
> we will require alignment on this chunk, and thus to not allow the
> request for this AG if the extra space is not available. Suppose
> that the AG in question has just enough space for this request, but
> not at the requested bno.

Ok, so an exact (XFS_ALLOCTYPE_THIS_BNO) allocation fails?

>
> xfs_alloc_fix_freelist() will proceed as
> normal as it determines the request should succeed, and thus it is
> allowed to modify the agf. xfs_alloc_ag_vextent() ultimately fails
> because the requested bno is not available.

*nod*

> In response, the caller
> moves on to a NEAR_BNO allocation request for the same AG. The
> alignment is set, but the minalignslop field is never reset. This
> increases the overall requirement of the request from the first
> attempt. If this delta is the difference between allocation success
> and failure for the AG, xfs_alloc_fix_freelist() rejects this
> request outright the second time around and causes the allocation
> request to unnecessarily fail for this AG.

Yup, that looks like a bug.

> To address this situation, reset the minalignslop field when we
> transition from a THIS_BNO to a NEAR_BNO allocation request in
> xfs_ialloc_ag_alloc().
> 
> [NOTE: It appears at first glance that the optimized agi_newino
>  allocation case is problematic in that it doesn't consider use of
>  mp->m_sinoalign, if enabled. If the m_sinoalign allocation fails,
>  however, we revert back to normal cluster alignment, which I think
>  makes the overall sequence safe.]

The agi_newino allocation case is not meant to stripe align the new
inode chunk. What it is meant to do is cluster inode allocation
within a stripe. i.e. the first allocation will be stripe aligned,
which sets newino. then newino will move to the adjacent cluster,
and we'll try to allocate that. i.e. we try to densely pack inodes
within a stripe unit before we spread them out onto other stripe
units. Hence when you are doing large file workloads, inodes get
clustered into a single stripe unit rather than being distributed
around between files....

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_ialloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 5d7f105..584daf0 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -382,6 +382,8 @@ xfs_ialloc_ag_alloc(
>  			isaligned = 1;
>  		} else
>  			args.alignment = xfs_ialloc_cluster_alignment(&args);
> +		args.minalignslop = 0;
> +
>  		/*
>  		 * Need to figure out where to allocate the inode blocks.
>  		 * Ideally they should be spaced out through the a.g.

I think I'd prefer that this is cleared immediately after the
allocation that required it, regardless of whether it succeeds or
not. i.e. confine the minalignslop context to that specific
allocation call, and hence if we modify this code in future we don't
have a landmine to trip on. It also needs a comment to explain why
it needs to be cleared....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
