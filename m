Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAELFh8d175271 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 15:15:43 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	p3ZPY2z44yr0Yvmo for <xfs@oss.sgi.com>;
	Wed, 14 Nov 2012 13:17:46 -0800 (PST)
Date: Thu, 15 Nov 2012 08:17:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/32 V2] xfs: remove xfs_tosspages
Message-ID: <20121114211745.GK1710@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard> <50A3E807.5010403@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A3E807.5010403@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 14, 2012 at 12:50:47PM -0600, Andrew Dahl wrote:
> On 11/14/2012 12:42 AM, Dave Chinner wrote:
> > xfs: remove xfs_tosspages
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's a buggy, unnecessary wrapper that is duplicating
> > truncate_pagecache_range().
> > 
> > When replacing the call in xfs_change_file_space(), also ensure that
> > the length being allocated/freed is always positive before making
> > any changes. These checks are done in the lower extent manipulation
> > functions, too, but we need to do them before any page cache
> > operations.
> > 
> > Reported-by: Andrew Dahl <adahl@sgi.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> >  	case XFS_IOC_ZERO_RANGE:
> >  		prealloc_type |= XFS_BMAPI_CONVERT;
> > -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> > +		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
> > +		if (startoffset > end)
> 
> This should be
> 
> if (startoffset <= end)

Duh - that's quite a thinko. :/

And I missed the fact that 242 failed in my rush to get it out. I
should have caught that before I sent it. My mistake.

Thanks for getting it fixed, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
