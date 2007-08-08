Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 19:56:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l782uKbm028771
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 19:56:22 -0700
Date: Wed, 8 Aug 2007 12:56:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: qa 166 failure on f8 kernel
Message-ID: <20070808025615.GH52011508@sgi.com>
References: <46B91EBA.10407@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B91EBA.10407@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 07, 2007 at 08:39:06PM -0500, Eric Sandeen wrote:
> Posting this just in case it rings any bells, though I plan to
> investigate...
> 
> [root@inode xfstests]# ./check  166
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 inode 2.6.23-0.71.rc2.fc8
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
> MOUNT_OPTIONS -- /dev/sdb6 /mnt/sdb6
> 
> 166      - output mismatch (see 166.out.bad)
> 2,6c2,7
> < 0: [0..31]: XX..YY AG (AA..BB) 32
> < 1: [32..127]: XX..YY AG (AA..BB) 96 10000
> < 2: [128..159]: XX..YY AG (AA..BB) 32
> < 3: [160..223]: XX..YY AG (AA..BB) 64 10000
> < 4: [224..255]: XX..YY AG (AA..BB) 32
> ---
> > /mnt/sdb6/test_file:  XX..YY AG (AA..BB)
> > 0: [0..7]: XX..YY AG (AA..BB) 8
> > 1: [8..127]: XX..YY AG (AA..BB) 120 10000
> > 2: [128..135]: XX..YY AG (AA..BB) 8
> > 3: [136..247]: XX..YY AG (AA..BB) 112 10000
> > 4: [248..255]: XX..YY AG (AA..BB) 8

When you post the failure, someone will say, "Duh, that's obvious".

Well: Duh! That's obvious. ;)

You've got 3x4k written blocks in the file which is *correct*.
There's nothing wrong with the kernel code. It's just that the test
is expecting 3x16k extents to be marked written.

See the problem yet?

mmap dirties entire pages. page size differs between platforms -
ia64 = 16k, x86 = 4k - so the size of the extent allocated is
different. Guess what platform I wrote the test on and use as my
primary platform?

The output needs better filtering, methinks.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
