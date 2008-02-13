Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Feb 2008 13:45:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1DLjYPZ031539
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 13:45:37 -0800
Date: Thu, 14 Feb 2008 08:45:51 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
Message-ID: <20080213214551.GR155407@sgi.com>
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 13, 2008 at 11:51:51AM +0100, Christian Røsnes wrote:
> Over the past month I've been hit with two cases of "xfs_trans_cancel
> at line 1150"
> The two errors occurred on different raid sets. In both cases the
> error happened during
> rsync from a remote server to this server, and the local partition
> which reported
> the error was 99% full (as reported by df -k, see below for details).
> 
> System: Dell 2850
> Mem: 4GB RAM
> OS: Debian 3 (32-bit)
> Kernel: 2.6.17.7 (custom compiled)
> 
> I've been running this kernel since Aug 2006 without any of these
> problems, until a month ago.
> 
> I've not used any of the previous kernel in the 2.6.17 series.
> 
> /usr/src/linux-2.6.17.7# grep 4K .config
> # CONFIG_4KSTACKS is not set
> 
> 
> Are there any known XFS problems with this kernel version and nearly
> full partitions ?

Yes. Deadlocks that weren't properly fixed until 2.6.18 (partially
fixed in 2.6.17) and an accounting problem in the transaction code
that leads to the shutdown you are seeing. The accounting problem is
fixed by this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=45c34141126a89da07197d5b89c04c6847f1171a

which I think went into 2.6.22.

Luckily, neither of these problems result in corruption.

> I'm thinking about upgrading the kernel to a newer version, to see if
> it fixes this problem.
> Are there any known XFS problems with version 2.6.24.2 ?

Yes - a problem with readdir. The fix is currently in the stable
queue (i.e for 2.6.24.3):

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=commit;h=ee864b866419890b019352412c7bc9634d96f61b

So we are just waiting for Greg to release 2.6.24.3 now.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
