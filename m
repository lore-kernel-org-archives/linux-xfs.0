Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Mar 2007 04:32:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2SBVr6p003686
	for <xfs@oss.sgi.com>; Wed, 28 Mar 2007 04:31:55 -0700
Date: Wed, 28 Mar 2007 22:31:41 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
Message-ID: <20070328113141.GQ32597093@melbourne.sgi.com>
References: <46094344.4090007@j-o-a.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46094344.4090007@j-o-a.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Joa <oliver@j-o-a.de>
Cc: linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 27, 2007 at 06:16:04PM +0200, Oliver Joa wrote:
> Hi,
> 
> since some weeks i try to get my new hardware running:
> 
> Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
> Intel DP965LT Mainboard
> Seagate SATA-Harddisk in AHCI-Mode
> 
> After some hours of running or after some heavy file-i/o
> (find / | cpio -padm /test) I always get a corrupted
> XFS-filesystem.

What is the corruption message in the log from XFS?
Can you please post that? Without it we really can't help you.

Also, please check to see if there are any I/O errors
in the log around the time the corruption message appears.

> I used already the following Kernels:
> 2.6.19.2
> 2.6.19.7
> 2.6.20.2
> 2.6.20.4
> 
> After xfs_repair I get damaged files in lost+found.
> 
> I read in newsgroups that the write-cache of the harddisk
> should be turned of, but the messages are all very old.

That's really only an issue for crashes, not runtime failures.

> I also often get a sata-bus-reset with the kernels 2.6.19.2
> and 2.6.20.2.

I/O errors. That's what we need to isolate first. The reports in
your logs are the first thing we need to seeee.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
