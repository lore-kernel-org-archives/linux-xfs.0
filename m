Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q950ZQA3244909 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 19:35:26 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vYWkSW75NyKvklfj for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 17:36:51 -0700 (PDT)
Date: Fri, 5 Oct 2012 10:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_freeze same as umount?   How is that helpful?
Message-ID: <20121005003647.GD23644@dastard>
References: <506DAB8C.9000601@tlinx.org>
	<CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
	<506E1025.8050605@tlinx.org> <20121004233204.GB23644@dastard>
	<506E2558.2050003@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506E2558.2050003@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 04, 2012 at 05:10:00PM -0700, Linda Walsh wrote:
> Dave Chinner wrote:
> >On Thu, Oct 04, 2012 at 03:39:33PM -0700, Linda Walsh wrote:
> >>When I tried xfs_freeze / fs_freeze got fs-busy -- same as I would
> >>if I tried to umount it.
> >
> >Of course - it's got to write all the dirty data andmetadata in
> >memory to disk. Freeze is about providing a stable, consistent disk
> >image of the filesystem, so it must flush dirty objects from memory
> >to disk to provide that.
> ----
> 	But it says the freeze failed.... huh.
> 
> Just tried it again .. ( first time after reboot.. froze it no
> messages or complaints) ?!?!  I don't get it.
> 
> 
> It gave me a file system busy message before and as near as I could tell --
> it wouldn't allow me to xfs_freeze it.

You mean EBUSY?

That means the filesystem was already frozen.

> >the problem you saw. So:
> ----
> 	Wasn't sure what I saw or that it was related -- exactly...
> 
> A possible theory... but nothing I'd blaim on xfs,  -- last message in log was:
> 
> 
> Oct  4 13:52:50 Ishtar kernel: [985735.911825] INFO: task fetchmail:25872 blocke
> d for more than 120 seconds.
> Oct  4 13:52:50 Ishtar kernel: [985735.918777] "echo 0 > /proc/sys/kernel/hung_t
> ask_timeout_secs" disables this message.

And the full stack trace?

> So if I xfs-freeze something, then take a snapshot, -- I don't see that any of that
> would help in doing an xfs_blockget o get a dump of inodes->blocks, as it sounds
> like it would still be dirty...

Only the log is dirty - it has a single dummy record in it to mark
it dirty. Otherwise everything is consistent, and the tools will
work fine on the snapshot image. You just have to know the magic
incantations to run the xfs_db commands directly with the extra flag
to tel it to ignore a dirty log.

i.e. xfs_ncheck is a diagnostic tool, not something that should be
run as part of a regular "get some info from the fs" workflow...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
