Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 22:50:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5P5oCdq020911
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 22:50:20 -0700
Date: Fri, 22 Jun 2007 09:52:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS_IOC_RESVSP64 for swap files
Message-ID: <20070621235222.GY85884050@sgi.com>
References: <20070617100822.GA4586@cordes.ca> <20070619043333.GJ86004887@sgi.com> <20070621061449.GB11200@cordes.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621061449.GB11200@cordes.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Cordes <peter@cordes.ca>
Cc: xfs@oss.sgi.com

On Thu, Jun 21, 2007 at 03:14:49AM -0300, Peter Cordes wrote:
> On Tue, Jun 19, 2007 at 02:33:33PM +1000, David Chinner wrote:
> > On Sun, Jun 17, 2007 at 07:08:23AM -0300, Peter Cordes wrote:
> > >  Hi XFS list.  I'm not subscribed, please CC me.
> > > 
> > >  Programs such as swapspace and swapd create new swap files when vmem runs
> > > low.  They would benefit hugely from being able to create a swapfile without
> > > any significant disk I/O.  (If a process grabs a lot of memory quickly, the
> > > system will be swapping hard while swapspace(8) is writing a swapfile.)
> 
> 
> > > but it [exposing stale data] would still be useful for making swap files
> > > even if only root could do it.
> > 
> > Still a potential security hole.
> 
>  Root can read the device file, so how is letting root expose stale data any
> worse?  If a program run by root makes a file with mode 0600, and then calls
> XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE, where's the security problem?

If a file is not 0600 or is not owned by root, then you've got a
problem.  Even if you only allow root to use the ioctl, there's
still plenty of ways that you can screw up and expose data to normal
users with something that causes persistent exposure.....

>  Ok.  I didn't really want to recreate my /var/tmp filesystem with
> unwritten=0, but I really wish I had
> XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE on my desktop machine.  I think
> dynamic swap file creation is a cool idea, and that ioctl would make it work
> perfectly.

I don't think XFS specific hacks are the way to acheive this.
Perhaps you want to look at ->fallocate and introduce a new mode
there for preallocating uninitialised swapfile extents.

>  This ioctl is only useful for making swap files.  Nothing else cares if the
> file has "holes" or not.  But for that one application, it's great.  There
> are lots of ways root can shoot himself in the foot, and I don't think
> adding one more is enough reason to not add an ioctl.
> 
>  Is it just that you don't want to take time to implement such a feature, or
> would you reject a patch that added it?  (Not that I'm volunteering,
> necessarily.)

I think XFS is the wrong place to do this.  If you want
pre-allocated swap files then a generic solution needs to be
implemented.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
