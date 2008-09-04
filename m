Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 16:00:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m84N0qQC027978
	for <linux-xfs@oss.sgi.com>; Thu, 4 Sep 2008 16:00:52 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B22963F1783
	for <linux-xfs@oss.sgi.com>; Thu,  4 Sep 2008 16:02:18 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id JtcF9CGbBlcjVglo for <linux-xfs@oss.sgi.com>; Thu, 04 Sep 2008 16:02:18 -0700 (PDT)
Date: Fri, 5 Sep 2008 09:02:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs corruptions
Message-ID: <20080904230210.GA5991@disturbed>
References: <g9p4sl$smg$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g9p4sl$smg$1@ger.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-xfs@oss.sgi.com

On Thu, Sep 04, 2008 at 07:11:48PM +0200, Bernd Schubert wrote:
> Hello,
> 
> I'm presently debugging the error handler of the MPT fusion driver and
> therefore causing errors on the disk (Infortrend scsi hardware raids).
> When I later on try to delete files and directories having been created
> before and during the failures, "rm -fr" simply says directory not empty.
> No message in dmesg about it, but xfs_repair reports errors, see below.
> Once xfs_repair has done its jobs, removing these directories works fine.
> But this shouldn't happen, should it? This is with 2.6.26

So we have an inode that is marked free in the AGI btree, but
apparently still in use according to the shortform directory that
referenced it.

There are two possibilities here:

The first possibility is the inode btree buffer containing the
record indicating the inode is free/used never got written to
disk while the other metadata blocks made it to disk. Seeing as
the filesystem didn't hang here, it implies that the buffer was
written so that on I/O completion the tail of the log could
move forward. That is, the I/O was issued, no error was reported,
but the I/O never made it to disk. If there was an error, you
should see something like:

Warning: Device <bdevname>, XFS metadata write error, block 0x456 in <bdev>

in the syslog indicating a write error. In this case it woul dbe
non-fatal and XFS would try to write it again a little later.

The second possibility is that the write of the inode containing the 
shortform directory to disk did not actually hit the disk, but that
implies unlinks had already taken place well before the 'rm -rf'
was executed. Perhaps your workload does that....

However, both cases imply that an I/O was indicated as completing
successfully when they did not get written to disk, and that points
to a bug in the error handling in the underlying driver.

That being said - it could be a bug in the XFS error handling that
is causing this, but XFS tends to be pretty noisy when errors occur.
I guess that you need to add more tracing to indicate when errors
are induced so we can check if errors are being created against
the same buffers that the inconsistent state is being found in. That
will help point out if the errors are being reported to XFS or not
correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
