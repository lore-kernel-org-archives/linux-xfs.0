Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 18:55:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L2t9EH030670
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 18:55:11 -0800
Date: Mon, 21 Jan 2008 13:55:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.24-rc8: possible circular locking dependency detected
Message-ID: <20080121025510.GY155259@sgi.com>
References: <alpine.DEB.1.00.0801182240310.6521@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0801182240310.6521@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org, mingo@redhat.com

On Fri, Jan 18, 2008 at 10:45:17PM +0100, Christian Kujau wrote:
> Hi,
> 
> just FYI, upgrading to -rc8 gave the following messages in kern.log in
> the morning hours, when the backups were run:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.24-rc8 #2
> -------------------------------------------------------
> rsync/23295 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<c017a552>] shrink_icache_memory+0x72/0x220
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0275056>] xfs_ilock+0x96/0xb0
> 
> which lock already depends on the new lock.

memory reclaim can occur when an inode lock is held,
causing i_iolock -> iprune_mutex to occur. This is quite
common.

During reclaim, while holding iprune_mutex, we lock a
different inode to complete the cleaning up of it,
resulting in iprune_mutex -> i_iolock.

At this point, lockdep gets upset and blats out a warning.

But, there's no problem here as it is always safe for us
to take the i_iolock in inode reclaim because it can never
be the same as the i_iolock that we've taken prior to memory
reclaim being entered. Therefore false positive.

Lockdep folk - we really need an annotation to prevent this false
positive from being reported because we are getting reports at
least once a week....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
