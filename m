Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 16:31:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0O0V21Z016499
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 16:31:06 -0800
Date: Thu, 24 Jan 2008 11:31:14 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS doesn't correctly account for IO-Wait for directory reading
Message-ID: <20080124003114.GD155259@sgi.com>
References: <20080123110027.GA10366@citd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123110027.GA10366@citd.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On Wed, Jan 23, 2008 at 12:00:27PM +0100, Matthias Schniedermeyer wrote:
> Hi
> 
> 
> Some days ago Mr. Chinner(?, don't have the e-mail anymore) said that 
> XFS fakes ( :-) ) it's way around IO-wait accounting for file-deletion 
> by deferring it to the log.
> 
> Today i thought again about the initial 'rm -rf'-isn't-accounted-properly
> "problem", and the bigger part of "rm -rf" is the 
> directory-traversal(IOW read) and not the actual "unlink"-part.
> 
> So what better test than a simple 'find'.
> 
> Situation: Cache is cold:
> find /<wherever> >/dev/null
> While running (which takes some time) it shows exactly 0.0%wa in top on 
> an otherwise completely idle system, where there should be a near 50%wa 
> (Dual-Core system) or 100% on a UP system.

XFS issues readahead on directories, so when the I/O has not completed,
it waits on semaphores in the xfs_buf layer, not on the I/O itself.
Hence we cannot account for the wait time as iowait as we cannot
tell the semaphore to call io_schedule() instead of schedule().

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
