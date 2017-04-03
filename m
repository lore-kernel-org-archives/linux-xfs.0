Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42465 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdDCRSZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 13:18:25 -0400
Date: Mon, 3 Apr 2017 10:18:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of
 files
Message-ID: <20170403171812.GK4864@birch.djwong.org>
References: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com>
 <19504ff40a16efff2e51d85388fce5be578edbc3.1489985397.git.calvinowens@fb.com>
 <20170321113932.GA58653@bfoster.bfoster>
 <ab15bba5-601a-3297-959c-ddb04b42d082@fb.com>
 <20170331041800.ugi4wgmbqx44mbwa@Haydn>
 <20170403171531.GJ4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403171531.GJ4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Calvin Owens <calvinowens@fb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, kernel-team@fb.com, stable@vger.kernel.org

On Mon, Apr 03, 2017 at 10:15:31AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 30, 2017 at 09:18:00PM -0700, Calvin Owens wrote:
> > When punching past EOF on XFS, fallocate(mode=PUNCH_HOLE|KEEP_SIZE) will
> > round the file size up to the nearest multiple of PAGE_SIZE:
> > 
> >   calvinow@vm-disks/generic-xfs-1 ~$ dd if=/dev/urandom of=test bs=2048 count=1
> >   calvinow@vm-disks/generic-xfs-1 ~$ stat test
> >     Size: 2048            Blocks: 8          IO Block: 4096   regular file
> >   calvinow@vm-disks/generic-xfs-1 ~$ fallocate -n -l 2048 -o 2048 -p test
> >   calvinow@vm-disks/generic-xfs-1 ~$ stat test
> >     Size: 4096            Blocks: 8          IO Block: 4096   regular file
> > 
> > Commit 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes") replaced
> > xfs_zero_remaining_bytes() with calls to iomap helpers. The new helpers
> > don't enforce that [pos,offset) lies strictly on [0,i_size) when being
> > called from xfs_free_file_space(), so by "leaking" these ranges into
> > xfs_zero_range() we get this buggy behavior.
> > 
> > Fix this by reintroducing the checks xfs_zero_remaining_bytes() did
> > against i_size at the bottom of xfs_free_file_space().
> > 
> > Reported-by: Aaron Gao <gzh@fb.com>
> > Fixes: 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes")
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Brian Foster <bfoster@redhat.com>
> > Cc: <stable@vger.kernel.org> # 4.8+
> > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 8b75dce..828532c 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1311,8 +1311,16 @@ xfs_free_file_space(
> >  	/*
> >  	 * Now that we've unmap all full blocks we'll have to zero out any
> >  	 * partial block at the beginning and/or end.  xfs_zero_range is
> > -	 * smart enough to skip any holes, including those we just created.
> > +	 * smart enough to skip any holes, including those we just created,
> > +	 * but we must take care not to zero beyond EOF and enlarge i_size.
> >  	 */
> > +
> > +	if (offset >= XFS_ISIZE(ip))
> > +		return 0;
> > +
> > +	if (offset + len > XFS_ISIZE(ip))
> > +		len = XFS_ISIZE(ip) - offset;
> > +
> 
> I'll pick this up for 4.12.

Bah, hit send too quickly.

I'll pick this up for 4.12, unless anyone wants me to push this for -rc6?

--D

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> >  	return xfs_zero_range(ip, offset, len, NULL);
> >  }
> >  
> > -- 
> > 2.9.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
