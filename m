Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BNL1ff169689 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 18:21:01 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4zfwq964Tx51ITjv for <xfs@oss.sgi.com>;
	Tue, 11 Sep 2012 16:22:04 -0700 (PDT)
Date: Wed, 12 Sep 2012 09:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] XFS: Print error when unable to allocate inodes or
	out of free inodes.
Message-ID: <20120911232144.GH11511@dastard>
References: <cover.1347396641.git.rprabhu@wnohang.net>
	<93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
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
To: raghu.prabhu13@gmail.com
Cc: open list <linux-kernel@vger.kernel.org>, Raghavendra D Prabhu <rprabhu@wnohang.net>, Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Sep 12, 2012 at 03:43:24AM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> When xfs_dialloc is unable to allocate required number of inodes or there are no
> AGs with free inodes, printk the error in ratelimited manner.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_ialloc.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index e75a39d..034131b 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -990,8 +990,11 @@ xfs_dialloc(
>  				goto out_error;
>  
>  			xfs_perag_put(pag);
> -			*inop = NULLFSINO;
> -			return 0;
> +
> +			xfs_err_ratelimited(mp,
> +				"Unable to allocate inodes in AG %d: Required %d, Current %llu, Maximum %llu",
> +				agno, XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
> +			goto out_spc;

This changes the error to be returned from 0 to ENOSPC. Adding error
messages shouldn't change the logic of the code.

Also, you might want tolook at how ENOSPC is returned from
xfs_ialloc_ag_alloc(). it only occurs when:

	if (mp->m_maxicount &&
            mp->m_sb.sb_icount + newlen > mp->m_maxicount) {

i.e. it is exactly the same error case as the "noroom" error below.
It has nothing to do with being unable to allocate inodes in the
specific AG - the global inode count is too high. IOWs, the error
message is not correct.

Also, 80 columns.

>  		}
>  
>  		if (ialloced) {
> @@ -1016,11 +1019,19 @@ nextag:
>  		if (++agno == mp->m_sb.sb_agcount)
>  			agno = 0;
>  		if (agno == start_agno) {
> -			*inop = NULLFSINO;
> -			return noroom ? ENOSPC : 0;
> +			if (noroom) {
> +				xfs_err_ratelimited(mp,
> +					"Out of AGs with free inodes: Required %d, Current %llu, Maximum %llu",
> +					 XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);

The error message here is misleading - the error is that we've
exceeded the maximum inode count for the filesystem (same as the
above error message case), so no further allocations are allowed.

What about the !noroom case? Isn't that a real ENOSPC condition?
i.e. we've tried to allocate inodes in every AG and yet we've failed
in all of them because there is no aligned, contiguous free space in
any of the AGs. Shouldn't that emit an appropriate warning?

> +				goto out_spc;
> +			}
> +			return 0;
>  		}
>  	}
>  
> +out_spc:
> +	*inop = NULLFSINO;
> +	return ENOSPC;
>  out_alloc:
>  	*IO_agbp = NULL;
>  	return xfs_dialloc_ag(tp, agbp, parent, inop);

Default behaviour on a loop break is to allocate inodes, not return
ENOSPC.

BTW, there's no need to cc LKML for XFS specific patches. LKML is
noisy enough as it is without unnecessary cross-posts....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
