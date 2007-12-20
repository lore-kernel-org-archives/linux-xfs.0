Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 17:54:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBK1sLWP012864
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 17:54:25 -0800
Date: Thu, 20 Dec 2007 12:54:25 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mount prob: "log inconsistent or not a log"
Message-ID: <20071220015425.GL4612@sgi.com>
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011848.GV19770@msoe.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220011848.GV19770@msoe.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Cc: xfs@oss.sgi.com

On Wed, Dec 19, 2007 at 07:18:48PM -0600, Jonathan C. Detert wrote:
> * Timothy Shimmin <tes@sgi.com> [071219 18:53]:
> > Hi Jonathan,
> > 
> > I'm not giving a high level view but
> > in regards to the log message about the xfs log :)
> > 
> > Jonathan.Detert@msoe.edu wrote:
> > >This is what /var/log/messages has to say about the mount attempt:
> > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS mounting filesystem sdb
> > >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: Log inconsistent or not 
> > >a log (last==0, first!=1)
> 
> --snip --
> 
> > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > >
> > Every 512 bytes of the log is stamped with the cycle#.
> > The cycle# is effectively the number of times the log has wrapped
> 
> -- snip --
> 
> > An "xfs_logprint -d /dev/sdb" will show what the cycle#s are
> > and where the log records are. It might give an idea of the
> > extent of the corruption.
> 
> Something occurred to me to point out:  the snapshot from yesterday has
> the same problem.  How can that be?  Is is possible that the log has
> been hosed for some time, and that the problem only reared its head now
> because I had to remount?  I.e. is it possible for an xfs fs to be
> mounted and used, even while the log is messed up?

No, it should not.

BTW, does "lost it's iSCSI connection" == "iSCSI server crashed"?
If so, is it possible that the iSCSI server is corrupted in some way?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
