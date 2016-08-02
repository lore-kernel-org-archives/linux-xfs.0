Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E793B7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 18:42:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A451AC002
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 16:42:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jzMNgW5NA591nNjC for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 16:42:49 -0700 (PDT)
Date: Wed, 3 Aug 2016 09:42:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160802234247.GO16044@dastard>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<20160628002649.GI12670@dastard> <20160630172239.GA23082@lst.de>
	<20160718111400.GC16044@dastard> <20160718111851.GD16044@dastard>
	<20160731191900.GA29301@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160731191900.GA29301@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jul 31, 2016 at 09:19:00PM +0200, Christoph Hellwig wrote:
> Now after spending this much time I've started wondering why we even
> reserve blocks in xfs_iomap_write_allocate - after all we've reserved
> space for the actual data blocks and the indlen worst case in
> xfs_bmapi_reserve_delalloc.  And in fact a little hack to drop that
> reservation seems to solve both the root cause (depleted reserved pool)
> and the cleanup mess.  I just haven't spend enought time to convince
> myself that it's actually safe, and in fact looking at the allocator
> makes me thing it only works by accident currently despite generally
> postive test results.
> 
> Here is the quick patch if anyone wants to chime in:
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 620fc91..67c317f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -717,7 +717,7 @@ xfs_iomap_write_allocate(
>  
>  		nimaps = 0;
>  		while (nimaps == 0) {
> -			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> +			nres = 0; // XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  
>  			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, nres,
>  					0, XFS_TRANS_RESERVE, &tp);
> 

This solves the problem for me, and from history appears to be the
right thing to do. Christoph, can you send a proper patch for this?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
