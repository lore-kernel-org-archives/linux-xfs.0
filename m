Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAACTTCN220783 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 06:29:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E888D169F35
	for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 04:30:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	zFXoBKOSX93oDdc8 for <xfs@oss.sgi.com>;
	Wed, 10 Nov 2010 04:30:55 -0800 (PST)
Date: Wed, 10 Nov 2010 23:30:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: vmap allocation for size 1048576 failed
Message-ID: <20101110123052.GW2715@dastard>
References: <4CD924A6.6040200@dermichi.com> <20101109120701.GN2715@dastard>
	<4CDA54E3.308@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CDA54E3.308@dermichi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 10, 2010 at 09:16:35AM +0100, Michael Weissenbacher wrote:
> Hi Dave!
> 
> > I didn't think anything other than log recovery tries to vmap
> > buffers. This is clearly not in log recovery. Can you post an
> > unedited error log, how much data you are rsyncing, the
> > configuration of your filesystem (xfs_info, mount options, loop dev
> > config, etc) to give us an idea of what you are doing to trigger
> > this?
>  * I'm attaching the latest kern.log, unedited
>  * I am syncing the gentoo portage tree, not much data but many small
> files (currently 228MiB in 117880 files). This sync is done twice per hour.
>  * I already posted my xfs_info and mount options in another post. Maybe
> i should note that the loop file system was deliberately created with
> blocksize=512 to accommodate the fs to the nature of the portage tree
> (many small files...)
>  * TBH i don't know about any special configuration of the loop device.
> I just created an empty file with "dd if=/dev/zero ..." and then did
> mkfs.xfs on it.

Ok, thanks for the info. I'm struggling to work out what is actually
consuming vmap space given what you are doing and the storage
config. None of the operations you are doing should be triggering
mapping of multipage metadata buffers given the filesystem
configuration....

> > Can't you run on a 64-bit machine?
> 80% of my machines are 64-bit and i never saw anything like that on
> them. But otoh i dont' use loop devices very much. Unfortunately this is
> machine is old hardware (P4 class) which can't run a 64-bit kernel.
> 
> > Can you downgrade your kernel and run the loop device there to tell
> > us whether this is actually a regression or not? If it is a
> > regression, then if you could run a bisect to find the exact patch
> > that causes it woul dbe very helpful....
> Already did that yesterday and i can confirm it has the same problem -
> so no regression. The kern.log i attached to this mail is from Kernel
> 2.6.35.8

Ok, I havent looked at this yet, but having looked at the code I
don't think it will tell me anything useful. However, if you can
reproduce the problem easily, the tracing output (google for
trace-cmd and/or kernelshark) of the xfs trace events for the short
period across the error condition (just a couple of seconds before
and after the error occurs) would tell me a lot more about what is
going wrong...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
