Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 16:32:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97NWgGF023306
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 16:32:43 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 913E213B5701
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 16:34:21 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id i4SBEMqA1kHctWbJ for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 16:34:21 -0700 (PDT)
Date: Wed, 8 Oct 2008 10:34:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs file system corruption
Message-ID: <20081007233418.GB7342@disturbed>
References: <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC8EC@NA-EXMSG-C121.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC8EC@NA-EXMSG-C121.redmond.corp.microsoft.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Allan Haywood <Allan.Haywood@microsoft.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

[Allan, please wrap text at 72 lines. Thx]

On Tue, Oct 07, 2008 at 04:18:57PM -0700, Allan Haywood wrote:
> We have a failover process where there are two servers connected
> to fiber storage, if the active server goes into failover (for
> numerous reasons) an automatic process kicks in that makes it
> inactive, and then makes the backup server active, here are the
> details:
> 
> 1.       On failed server database and other processes are shut
> down (attempts)
> 
> 2.       Fiber attached file system is unmounted (attempts)
> 
> 3.       Fiber ports are turned off for that server
> 
> 4.       On backup server fiber ports are turned on
> 
> 5.       Fiber attached file system is mounted (same filesystems
> that were on the previous server)
> 
> 6.       Database and other processes are started
> 
> 7.       The backup server is now active and processing queries
> 
> Here is where it got interesting, when recovering from the backup
> server back to the main server we pretty much just reverse the
> steps above. We had the file systems unmount cleanly on the backup
> server, however when we went to mount it on the main server it
> detected a file system corruption (using xfs_check it indicated a
> repair was needed so xfs_repair was then run on the filesystem),
> it proceded to "fix" the filesystem, at which point we lost files
> that the database needed for one of the tables.
> 
> What I am curious about is the following message in the system
> log:
> 
> Oct  2 08:15:09 arch-node4 kernel: Device dm-31, XFS metadata
> write error block 0x40 in dm-31
> 
> This is when the main node was fenced (fiber ports turned off), I
> am wondering if any pending XFS metadata still exists, later on
> when the fiber is unfenced that the metadata flushes to disk.

According to your above detail, you attempt to unmount the filesystem
before you fence the fibre ports. If you don't unmount the
filesystem before fencing, this is what you'll see - XFS trying
to writeback async metadata and failing.

> I could see this as an issue, if there are pending metadata writes
> to a filesystem, that filesystem through failure is mounted on
> another server and used as normal, then unmounted normally, then
> when the ports are re-activated on the server that has pending
> metadata, is it possible this does get flushed to the disk, but
> since the disk has been in use on another server the metadata no
> longer matches the filesystem properly and potentially writes over
> or changes the filesystem in a way that causes corruption.

Right.

Once you've fenced the server, you really, really need to make
sure that it has no further pending writes that could be issued
when the fence is removed. I'd suggest that if you failed to
unmount the filesystem before fencing, you need to reboot that
server to remove any possibility of it issuing stale I/O
once it is unfenced. i.e. step 3b = STONITH.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
