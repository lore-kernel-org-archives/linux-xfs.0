Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 04:14:14 -0800 (PST)
Received: from pne-smtpout4-sn1.fre.skanova.net (pne-smtpout4-sn1.fre.skanova.net [81.228.11.168])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08CE5qw021469
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 04:14:08 -0800
Received: from safari.iki.fi (80.223.106.128) by pne-smtpout4-sn1.fre.skanova.net (7.2.075)
        id 44A36A0A008DA590 for xfs@oss.sgi.com; Mon, 8 Jan 2007 12:03:24 +0100
Date: Mon, 8 Jan 2007 13:03:23 +0200
From: Sami Farin <safari-xfs@safari.iki.fi>
Subject: Re: xfs_file_ioctl / xfs_freeze: BUG: warning at kernel/mutex-debug.c:80/debug_mutex_unlock()
Message-ID: <20070108110323.GA3803@m.safari.iki.fi>
References: <20070104001420.GA32440@m.safari.iki.fi> <20070107213734.GS44411608@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070107213734.GS44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 08:37:34 +1100, David Chinner wrote:
...
> > fstab was there just fine after -u.
> 
> Oh, that still hasn't been fixed?

Looked like it =)

> Generic bug, not XFS - the global
> semaphore->mutex cleanup converted the bd_mount_sem to a mutex, and
> mutexes complain loudly when a the process unlocking the mutex is
> not the process that locked it.
> 
> Basically, the generic code is broken - the bd_mount_mutex needs to
> be reverted back to a semaphore because it is locked and unlocked
> by different processes. The following patch does this....
> 
> BTW, Sami, can you cc xfs@oss.sgi.com on XFS bug reports in future;
> you'll get more XFS savvy eyes there.....

Forgot to.

Thanks for patch.  It fixed the issue, no more warnings.

BTW. the fix is not in 2.6.git, either.

-- 
Do what you love because life is too short for anything else.
