Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 09E847CA2
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2016 15:07:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8200CAC004
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2016 13:07:07 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	p3g0UNyrfFQSAcws for <xfs@oss.sgi.com>;
	Sat, 30 Jan 2016 13:07:04 -0800 (PST)
Date: Sun, 31 Jan 2016 08:06:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: lock bitmap/summary inodes in xfs_rtbuf_get()
Message-ID: <20160130210650.GL20456@dastard>
References: <56AC2D64.2080907@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56AC2D64.2080907@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 29, 2016 at 09:26:28PM -0600, Eric Sandeen wrote:
> Commit eef334e added an ASSERT that the inode was locked in
> some way in xfs_bmapi_read(), but on realtime paths through
> xfs_rtbuf_get() this isn't the case; fix that.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I think we need the data_map_shared gyrations here, but not certain...
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 9b59ffa..e6da0b2 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -57,11 +57,14 @@ xfs_rtbuf_get(
>  	xfs_inode_t	*ip;		/* bitmap or summary inode */
>  	xfs_bmbt_irec_t	map;
>  	int		nmap = 1;
> +	int		lock_mode;
>  	int		error;		/* error value */
>  
>  	ip = issum ? mp->m_rsumip : mp->m_rbmip;
>  
> +	lock_mode = xfs_ilock_data_map_shared(ip);
>  	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, XFS_DATA_FORK);
> +	xfs_iunlock(ip, lock_mode);

I've looked into this recently and didn't think up a simple answer
to the problem. I didn't spend much time on it because it's nowhere
near the top of my priority list because it only affects debug
kernels as the summary inode is effectively protected by the bitmap
inode exclusion during allocation.

That said, the above change is not safe because xfs_rtbuf_get() can
be called with the bitmap inode lock already held. e.g:

  xfs_bmap_rtalloc
    xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);   << locks bitmap
    xfs_rtallocate_extent
      xfs_rtallocate_extent_exact
	xfs_rtcheck_range
	  xfs_rtbuf_get(issum = 0)
	    xfs_ilock_data_map_shared(mp->m_rbmip)
	    <self deadlock>

The issue here is that the summary inode is not locked early on in
the transaction, so modifications are done with it unlocked.

  xfs_bmap_rtalloc
    xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);   << locks bitmap
    xfs_rtallocate_extent
      xfs_rtallocate_extent_size
        xfs_rtget_summary
          xfs_rtmodify_summary_int
	    xfs_rtbuf_get
	      xfs_bmapi_read(summary inode)    << unlocked summary

The only path through which the summary inode is locked for
modification is the growfs path (xfs_rtcopy_summary()), so all the
other paths that modify/access the summary inode also need to be
locked at a higher level before calling into the summary functions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
