Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 17:29:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m310TeAT001755
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 17:29:42 -0700
Date: Tue, 1 Apr 2008 10:30:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Does XFS prevent disk spindown?
Message-ID: <20080401003005.GJ103491721@sgi.com>
References: <m2tzimbvif.fsf@getmail.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2tzimbvif.fsf@getmail.no>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thor Kristoffersen <thorkr@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 31, 2008 at 08:26:00PM +0200, Thor Kristoffersen wrote:
> I've noticed that when I spin down XFS-mounted disks they spin up again
> shortly afterwards.  I used iostat to monitor disk accesses to a mounted
> partition (with noatime) in single user mode.  Apparently there is a write
> access to the partition approximately every 35 seconds, even if the
> partition is idle.  As far as I can understand, since there is no data that
> needs to be flushed this must be done by an XFS daemon for some purpose.
> 
> Is there any setting or mount option I can use to get rid of this behavior?
> I know I can freeze the filesystem, but then I have to remember to unfreeze
> it every time I need to write to it, so it's not an ideal solution.

Turn on laptop mode?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
