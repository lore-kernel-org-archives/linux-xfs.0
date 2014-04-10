Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2962F7F63
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:23:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B2028F804B
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:23:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	feElkgSRN94tdeOy for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 05:23:04 -0700 (PDT)
Date: Thu, 10 Apr 2014 22:22:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: zeroing space needs to punch delalloc blocks
Message-ID: <20140410122259.GC27519@dastard>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-5-git-send-email-david@fromorbit.com>
	<20140410104001.GG17641@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410104001.GG17641@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 03:40:01AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 10, 2014 at 03:00:51PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we are zeroing space andit is covered by a delalloc range, we
> > need to punch the delalloc range out before we truncate the page
> > cache. Failing to do so leaves and inconsistency between the page
> > cache and the extent tree, which we later trip over when doing
> > direct IO over the same range.
> 
> Looks good.
> 
> Which test found this?

The fsstress tests - any of them will do. It showed after I merged
Lukas' FALLOC_FL_ZERO_RANGE support patches for fsstress and fsx
into xfstests, but it wasn't reliably triggering until I fixed the
__xfs_get_blocks DIO bug that Al found...

> > @@ -1432,9 +1434,18 @@ xfs_zero_file_space(
> >  	ASSERT(end_boundary <= offset + len);
> >  
> >  	if (start_boundary < end_boundary - 1) {
> > -		/* punch out the page cache over the conversion range */
> > +		/*
> > +		 * punch out delayed allocation blocks and the page cache over
> > +		 * the conversion range
> > +		 */
> > +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +		error = xfs_bmap_punch_delalloc_range(ip,
> > +				XFS_B_TO_FSB(mp, start_boundary),
> 
> Shouldn't this be XFS_B_TO_FSBT?

XFS_B_TO_FSB gives the same result given that we've already rounded
start_boundary to block granularity....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
