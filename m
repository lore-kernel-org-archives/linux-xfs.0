Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:12:25 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1INCMmr002811
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:12:22 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03801E55C6F
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:12:47 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id OB7BXMvUE4tvJUY7 for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:12:47 -0800 (PST)
Message-ID: <47BA10EC.3090004@tlinx.org>
Date: Mon, 18 Feb 2008 15:12:44 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: tuning, many small files, small blocksize
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
In-Reply-To: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>
Cc: xfs@oss.sgi.com

Jeff Breidenbach wrote:
> I'm testing xfs for use in storing 100 million+ small files
> (roughly 4 to 10KB each) and some directories will contain
> tens of thousands of files. There will be a lot of random
> reading, and also some random writing, and very little
> deletion. 
> 
> I am setting up the xfs partition now, and have only played
> with blocksize so far. 512 byte blocks are most space efficient,
> 1024 byte blocks cost 3.3% additional space, and 4096 byte
> blocks cost 22.3% additional space.
>
> a) Should I just go with the 512 byte blocksize or is that going to be
> bad for some performance reason? Going to 1024 is no problem,
> 
> b) Are there any other mkfs.xfs paramters that I should play with.

If your minimum file size is 4KB and max is 10KB, a blocksize of
2K might be give you a reasonable compaction level.

Might also play with the inode size.  I *usually* go with 1K-inode+4k block,
but with a 2k block, I'm slightly torn between 512-byte inodes and 1K
inodes, but I can't think of a _great_ reason to ever go with the default
256-byte inode size, since that size seems like it will always cause
the inode to be shared with another, possibly unrelated file.

Remember, in xfs, if the last bit of left-over data in an inode will fit
into the inode, it can save a block-allocation, though I don't know
how this will affect speed.

Space-wise, a 2k block size and 1k-inode size might be good, but don't
know how that would affect performance.

My concern about 512-byte blocks is, in general (don't recall having
used such a small block size on xfs), smaller blocks can lead to
greater fragmentation, but xfs is better than the average 'fs' in
laying out files.  While 'xfs_fsr' is good about keeping files
linear, it didn't used to work on directories -- and if you have
10's of thousands of files/directory...that might trigger some
more directory fragmentation.  Dunno.

After you write the many small files, will you be appending to them?

As for benchmarks, their's always the standard 'bonnie' and 'bonnie++'.
I don't know how they compare to iozone though -- I'm not familiar with
that benchmark.

I'm sure you are familiar with mount options noatime,nodiratime -- same
concepts, but dir's are split out.  Someone else mentioned using
logbsize=256k in the mount options.  My manpages may be dated, but
they "claim", that valid sizes are 16k and 32k.

Also, it depends on the situation, but sometimes flattening out the
directory structure can speed up lookup time.

Sometime back someone did some benchmarks involving log size and it seemed
that 32768b(4k) or ~128Meg seemed optimal if memory serves me correctly.

Good luck...
