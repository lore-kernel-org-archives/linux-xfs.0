Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 16:45:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2ANjCUP018533
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 16:45:15 -0700
Date: Tue, 11 Mar 2008 10:45:40 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error
Message-ID: <20080310234539.GC155407@sgi.com>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <20080310122216.GG14256@slop.flatline.de> <20080310223018.GA155407@sgi.com> <20080310225927.GP14256@slop.flatline.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310225927.GP14256@slop.flatline.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Kotes <count@flatline.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Mar 10, 2008 at 11:59:27PM +0100, Andreas Kotes wrote:
> * David Chinner <dgc@sgi.com> [20080310 23:30]:
> > On Mon, Mar 10, 2008 at 01:22:16PM +0100, Andreas Kotes wrote:
> > > * David Chinner <dgc@sgi.com> [20080310 13:18]:
> > > > Yes, but those previous corruptions get left on disk as a landmine
> > > > for you to trip over some time later, even on a kernel that has the
> > > > bug fixed.
> > > > 
> > > > I suggest that you run xfs_check on the filesystem and if that
> > > > shows up errors, run xfs_repair onteh filesystem to correct them.
> > > 
> > > I seem to be having similiar problems, and xfs_repair is not helping :(
> > 
> > xfs_repair is ensuring that the problem is not being caused by on-disk
> > corruption. In this case, it does not appear to be caused by on-disk
> > corruption, so xfs_repair won't help.
> 
> ok, too bad - btw, is it a problem that I'm doing the xfs_repair on a
> mounted filesystem with xfs_repair -f -L after a remount rw?

If it was read only, and you rebooted immediately afterwards, you'd
probably be ok. Doing this to a mounted, rw filesystem is asking
for trouble. If the shutdown is occurring after you've run xfs_repair,
then it is almost certainly the cause....

I'd suggest getting a knoppix (or similar) rescue disk and repairing
from that, rebooting and seeing if the problem persists. If it
does, then we'll have to look further into it.

FWIW, you've got plenty of free inodes so this does not look
to be the same problem I've just found. 

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
