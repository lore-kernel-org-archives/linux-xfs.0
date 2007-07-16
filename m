Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 06:01:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6GD1mbm006484
	for <linux-xfs@oss.sgi.com>; Mon, 16 Jul 2007 06:01:50 -0700
Date: Mon, 16 Jul 2007 23:01:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid50 and 9TB volumes
Message-ID: <20070716130140.GC31489@sgi.com>
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Mon, Jul 16, 2007 at 03:42:28PM +0300, Raz wrote:
> Hello
> I found that using xfs over raid50, ( two raid5's 8 disks each and
> raid 0 over them ) crashes the file system when the file system is ~
> 9TB. crashing is easy: we simply create few hundred of files, then
> erase them in bulk. the same test passes in 6.4TB filesystems.
> this bug happens in 2.6.22 as well as 2.6.17.7.
> thank you .
> 
> 4391322.839000] Filesystem "md3": XFS internal error
> xfs_alloc_read_agf at line 2176 of file fs/xfs/xfs_alloc.c.  Caller
> 0xc10d31ea
> [4391322.863000]  <c10d36e9> xfs_alloc_read_agf+0x199/0x220
> <c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0

Judging by the kernel addresses (<c10d36e9>) you're running
an i386 kernel right? Which means there's probably a wrapping
issue at 8TB somewhere in the code which has caused an AGF
header to be trashed somewhere lower down in the filesystem.
what does /proc/partitions say? I.e. does the kernel see
the whole 9TB of space?

What does xfs_repair tell you about the corruption? (assuming
it doesn't OOM, which is a good chance if you really are on
i386).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
