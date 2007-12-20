Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 09:55:44 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBKHtXK6025250
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 09:55:37 -0800
Received: from email.msoe.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 240FCB85A25
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 09:55:45 -0800 (PST)
Received: from email.msoe.edu (email.msoe.edu [155.92.194.61]) by cuda.sgi.com with ESMTP id KUc5pDG9OE8kxbuT for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 09:55:45 -0800 (PST)
Date: Thu, 20 Dec 2007 11:55:12 -0600
From: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Subject: Re: mount prob: "log inconsistent or not a log"
Message-ID: <20071220175512.GA6023@msoe.edu>
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011848.GV19770@msoe.edu> <20071220015425.GL4612@sgi.com> <20071220024453.GX19770@msoe.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220024453.GX19770@msoe.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

* Jonathan C. Detert <Jonathan.Detert@msoe.edu> [071219 20:44]:
> * David Chinner <dgc@sgi.com> [071219 19:59]:
> > On Wed, Dec 19, 2007 at 07:18:48PM -0600, Jonathan C. Detert wrote:
> > > * Timothy Shimmin <tes@sgi.com> [071219 18:53]:
> > > > Hi Jonathan,
> 
> -- snip --
> 
> > > > Jonathan.Detert@msoe.edu wrote:
> > > > >This is what /var/log/messages has to say about the mount attempt:
> > > > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > > > >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS mounting filesystem sdb
> > > > >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: Log inconsistent or not 
> > > > >a log (last==0, first!=1)
> > > 
> > > --snip --
> > > 
> > > > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > > > >
> > > > Every 512 bytes of the log is stamped with the cycle#.
> > > > The cycle# is effectively the number of times the log has wrapped
> > > 
> > > -- snip --
> > > 
> > > > An "xfs_logprint -d /dev/sdb" will show what the cycle#s are
> > > > and where the log records are. It might give an idea of the
> > > > extent of the corruption.
> > > 
> > > Something occurred to me to point out:  the snapshot from yesterday has
> > > the same problem.  How can that be?  Is is possible that the log has
> > > been hosed for some time, and that the problem only reared its head now
> > > because I had to remount?  I.e. is it possible for an xfs fs to be
> > > mounted and used, even while the log is messed up?
> > 
> > No, it should not.

I just want to clarify - I mean to ask:

	Is it possible that an xfs filesystem which is in use by an o.s.,
	last mounted by the o.s. months ago, could have a corrupted log, and
	yet keep functioning until such time as a remount of it is attempted?

	I.e. if a log gets corrupted while the f.s. is in use, will anyone
	notice, until such time as an attempt to remount the f.s. is made?

I don't mean to ask:

	Is it possible to mount an xfs fs whose log is corrupted?

Thanks
-- 
Jon Detert
IT Systems Administrator, Milwaukee School of Engineering
1025 N. Broadway, Milwaukee, Wisconsin 53202, U.S.A.
--
Half a truth is often a great lie.
