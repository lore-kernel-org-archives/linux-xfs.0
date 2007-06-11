Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 16:15:02 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5BNEuWt005344
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 16:14:59 -0700
Subject: Re: Review: Be smarter about handling ENOSPC during writeback
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070608073342.GW85884050@sgi.com>
References: <20070604045219.GG86004887@sgi.com>
	 <E436D9833B42EFAE6C2CE987@timothy-shimmins-power-mac-g5.local>
	 <F80A059A828DE0E57A655471@boing.melbourne.sgi.com>
	 <20070608073342.GW85884050@sgi.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 09:13:45 +1000
Message-Id: <1181603625.3758.53.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, 2007-06-08 at 17:33 +1000, David Chinner wrote:
> On Fri, Jun 08, 2007 at 03:28:14PM +1000, Timothy Shimmin wrote:

> > Will we get questions from people about reduced space from df? :)
> 
> If we do, I think you just volunteered to write the FAQ entry ;)

It would be more correct of XFS to start doing the right thing by
reporting different values for b_free and b_avail in statfs(2) -
this code in xfs_mount.c::xfs_statvfs() ...

    statp->f_bfree = statp->f_bavail =
                            sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);

I know this wasn't done for the original per-mount space reserving
ioctls (that was for one user though - dmapi, so I can see why there
may have been a shortcut done there) ... but if it affects everyone
now, there will be questions asked, and there is a standard interface
for reporting this space discrepency that tools like df(1) already
use.

cheers.
