Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 15:56:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5OMuTuV010116
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:56:30 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3319F1802087
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:57:28 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id r63WJ28vdkrkZolz for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:57:28 -0700 (PDT)
Date: Wed, 25 Jun 2008 08:57:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
Message-ID: <20080624225724.GN29319@disturbed>
References: <48605A8E.9070903@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48605A8E.9070903@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 23, 2008 at 09:23:10PM -0500, Eric Sandeen wrote:
> So md raid1 is happy to pass down any barrier writes that it sees, but
> this bit in xfs_mountfs_check_barriers() at mount time:
> 
>         if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
>                                         QUEUE_ORDERED_NONE) {
>                 xfs_fs_cmn_err(CE_NOTE, mp,
>                   "Disabling barriers, not supported by the underlying
> device");
>                 mp->m_flags &= ~XFS_MOUNT_BARRIER;
>                 return;
>         }
> 
> winds up with XFS disabling barriers on these devices.  However, if this
> is simply commented out, XFS happily tests barriers, finds that they
> work, leaves them turned on and all subsequent barrier writes to the
> device succeed.
> 
> Perhaps what we have here is a failure to communicate?  :)

What we have is MD doing something strange and non-standard to
implement barriers on RAID1. All other devices that support barriers
define the barrier implementation as something other than
QUEUE_ORDERED_NONE.

> I'm not sure; *should* XFS be looking for a QUEUE_ORDERED tag?

It was put there for some reason - now lost in the mists of time, I
think. I suspect it was for detecting volume managers that didn't
support barriers properly and weren't returning the correct
errors to barrier I/O....

> Should MD be setting one?

If it supports barriers, then it probably should be.

> Maybe there should be a QUEUE_ORDERED_PASSTHRU flag?
> Or should XFS just stick with the test write and ignore the flag?  I'm
> not sure of the queue->ordered flag details, but it seems that XFS & md
> raid1 both try hard to keep barriers in force, and there's a disconnect
> here somewhere.

Yeah, the problem was that last time this check was removed was
that a bunch of existing hardware had barriers enabled on them when
not necessary (e.g. had NVRAM) and they went 5x slower on MD raid1
devices. Having to change the root drive config on a wide install
base was considered much more of support pain than leaving the
check there. I guess that was more of a distro upgrade issue than
a mainline problem, but that's the history. Hence I think we
should probably do whatever everyone else is doing here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
