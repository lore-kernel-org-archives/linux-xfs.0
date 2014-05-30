Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 453E57F5A
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 18:38:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30119304043
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 16:38:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZOf0O9AOJhTHHmoP for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 16:38:02 -0700 (PDT)
Date: Sat, 31 May 2014 09:37:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/16 V3] xfs: introduce struct xfs_da_geometry
Message-ID: <20140530233759.GK6677@dastard>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
	<20140530190534.GC3146@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140530190534.GC3146@laptop.bfoster>
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

On Fri, May 30, 2014 at 03:05:35PM -0400, Brian Foster wrote:
> On Wed, May 28, 2014 at 04:04:27PM +1000, Dave Chinner wrote:
> > Hi folks, 
> > 
> > Version three of the patchset first posted here:
> > 
> > http://oss.sgi.com/pipermail/xfs/2014-May/036125.html
> > 
> > This version addresses the review comments so far.
> > 
> > Changelog:
> > 
> > Version 3:
> > - added xfs_da_unmount
> > - moved dir2 conversion functions to xfs_dir2_priv.h
> > - converted xfs_dir2_readdir.c to use local geo variables
> > - added a patch to remove newly redundant geometry fields
> >   from the struct xfs_da_state
> 
> I don't see this bit anywhere in the series...

Oops, I got the wrong head commit when patchbombing. I've replied to
the original patch 0 with a 17/16....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
