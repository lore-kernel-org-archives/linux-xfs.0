Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 16:06:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1N06565030504
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 16:06:16 -0800
Date: Sat, 23 Feb 2008 11:06:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Marking inode dirty latency > 1000 msec on XFS!
Message-ID: <20080223000612.GE155259@sgi.com>
References: <47B5DD9C.3080906@gmail.com> <47BE6C5C.2000605@sgi.com> <47BE8EE8.5020005@gmail.com> <47BEA1E7.3010107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47BEA1E7.3010107@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: lachlan@sgi.com, Arjan van de Ven <arjan@linux.intel.com>, xfs@oss.sgi.com, David Chinner <dgc@sgi.com>

On Fri, Feb 22, 2008 at 12:20:23PM +0200, Török Edwin wrote:
> Török Edwin wrote:
> >> What would be useful here is the
> >> average latency time.  The average might actually be quite low but if
> >> just
> >> once we have a maximum that is unusually large then just looking at that
> >> figure can be misleading.
> >>     
> >
> > I'll try to collect the raw numbers from /proc/latency_stats, that
> > contain a count, total time, and max time.
> 
> I was not able to reproduce the 1 second latency with David Chinner's
> reduce xaild wakeups patch, the maximum latency  I got was 685 msec.
.....
> 
> <count> <sum> <maximum> <stacktrace>
> ----------------
> 2 47699 36897 xfs_buf_free default_wake_function xfs_buf_lock xfs_getsb
....
> 
> Average = 478072 usecs
> -----------------
.....
> -----------
> 1 685021 685021 xfs_buf_free default_wake_function xfs_buf_lock
> xfs_getsb xfs_trans_getsb xfs_trans_apply_sb_deltas _xfs_trans_commit
......

Note the xfs_getsb() call in there - that's what the lazy-count option
avoids. That's waiting in the transaction subsystem to apply delta's
to the superblock that is currently locked.

Converting to a lazy-count filesystem is experimental right now;
it may eat your data. If you still want to try, apply the patch
in this email and convert it:

http://oss.sgi.com/archives/xfs/2008-02/msg00295.html

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
