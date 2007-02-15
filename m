Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Feb 2007 01:16:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1F9GMm7014276
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 01:16:25 -0800
Date: Thu, 15 Feb 2007 20:16:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs internal error on a new filesystem
Message-ID: <20070215091610.GB5743@melbourne.sgi.com>
References: <20070214102432.6346.qmail@info6.gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214102432.6346.qmail@info6.gawab.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Ramy M. Hassan " <ramy@gawab.com>
Cc: linux-kernel@vger.kernel.org, Ahmed El Zein <a.elzein@gawab.net>, xfs@oss.sgi.com

On Wed, Feb 14, 2007 at 10:24:27AM +0000, Ramy M. Hassan  wrote:
> Hello,
> We got the following xfs internal error on one of our production servers:
> 
> Feb 14 08:28:52 info6 kernel: [238186.676483] Filesystem "sdd8": XFS
> internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c. 
> Caller 0xf8b906e7

Real stack looks to be:

 xfs_trans_cancel
 xfs_mkdir
 xfs_vn_mknod
 xfs_vn_mkdir
 vfs_mkdir
 sys_mkdirat
 sys_mkdir

We aborted a transaction for some reason. We got an error somewhere in
a mkdir while we had a dirty transaction.  Unfortunately, this tells us very
little about the error that actually caused the shutdown.

What is your filessytem layout? (xfs_info <mntpt>) How much memory
do you have and were you near enomem conditions?

> We were able to unmount/remount the volume (didn't do xfs_repair because we
> thought it might take long time, and the server was already in production
> at the moement)

Risky to run a production system on a filesystem that might be corrupted.
You risk further problems if you don't run repair....

> The file system was created less than 48hours ago, and 370G of sensitve
> production data was moved to the server before it xfs crash.

So that's not a "new" filesystem at all...

FWIW, did you do any offline testing before you put it into production?

> System details :
> Kernel: 2.6.18
> Controller: 3ware 9550SX-8LP (RAID 10)

Can you describe your dm/md volume layout?

> We are wondering here if this problem is an indicator to data corruption on
> disk ?

It might be. You didn't run xfs_check or xfs_repair, so we don't know if
there is any on disk corruption here.

> is it really necessary to run xfs_repair ?

If you want to know if you haven't left any landmines around for the
filesystem to trip over again. i.e. You should run repair after any
sort of XFS shutdown to make sure nothing is corrupted on disk.
If nothing is corrupted on disk, then we are looking at an in-memory
problem....

> Do u recommend that we switch back to reiserfs ?

Not yet.

> Could it be a hardware related problems  ?

Yes. Do you have ECC memory on your server? Have you run memtest86?
Were there any I/O errors in the log prior to the shutdown message?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
