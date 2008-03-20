Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 21:35:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K4ZcEV023718
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:35:41 -0700
Date: Thu, 20 Mar 2008 15:35:57 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Duplicate directory entries
Message-ID: <20080320043557.GX95344431@sgi.com>
References: <20080320000254.GC103321673@sgi.com> <D9A1816327F7BF4F931ADE74C248DFC90A42D366@it-004.Isys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9A1816327F7BF4F931ADE74C248DFC90A42D366@it-004.Isys.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jim Paradis <jparadis@exagrid.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 19, 2008 at 11:32:42PM -0400, Jim Paradis wrote:
> David Chinner:
> >On Wed, Mar 19, 2008 at 03:26:05PM -0400, Jim Paradis wrote:
> >> We recently ran across a situation where we saw two directory entries
> >> that were exactly the same.
> >
> >What kernel version?
> 
> 2.6.18.

No, it was originnally diagnosed on 2.6.5 kernels (sles9) and was fixed around
2.6.17 by the inode i_sem -> i_mutex conversion in mainline before we tracked
it down. The root problem there was a semaphore lock leak in the direct I/O
code causing problems when the inode was recycled and reused as a directory.
The system would panic in the dentry cache, but log recovery would result in
creating duplicate entries in the directory.

I don't think this is your problem unless you've only recently upgraded
from an old kernel and your applications do direct I/O.....

Can you reproduce the problem or provide any information on events
that may have occurred around the time of the duplicates being created?
I suspect that a reproducable test case will be the only way we can track
this down....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
