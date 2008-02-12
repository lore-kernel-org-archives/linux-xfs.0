Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 04:15:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1CCF5fx011385
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 04:15:10 -0800
Date: Tue, 12 Feb 2008 23:15:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: inode size benchmarking
Message-ID: <20080212121518.GD155407@sgi.com>
References: <1a4a774c0802120337x55fa2eb6qb7d52511fba3d11c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a4a774c0802120337x55fa2eb6qb7d52511fba3d11c@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 12, 2008 at 12:37:36PM +0100, Christian Røsnes wrote:
> I'm trying to figure out how different inode sizes on my system
> affect the time it takes to:
> 
>   1) Create <n1> directories each with <n2> files (using different file sizes)
> 
>   2) Read all the files from dir1,
>           all the files from dir2,
>           ...
> 
>   3) Read file1 from dir1,
>           file1 from dir2,
>           ...
>           file2 from dir1,
>           file2 from dir2,
>           ...

Ok, and destination file names are "file.XXX" so there's about 12
bytes per shorform dir entry. That means the 2k inodes hold all the
100 files in them directly. That's the only on disk difference that
changing the inode size will make, and it clearly does not explain
a 50% difference in perfomrance between 256 byte and 2k inodes in
these tests.

> The test server used:
> 
>  * Debian 4 (Etch)
>  * Kernel: Debian 2.6.18-6-amd64 #1 SMP Wed Jan 23 06:27:23 UTC 2008
> x86_64 GNU/Linux
>  * CPU: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
>  * MEM: 4GB RAM
>  * DISK: DELL MD1000 7 disks (1TB SATA) in RAID5. PERC6/E controller
>  * The test partition is 6TB.
                           ^^^

This does, though.

With 256 byte inodes, the allocator changes behaviour at filesystem
sizes > 1TB to keep inodes at smaller than 32 bits. This change
means that data is no longer close to the inodes, thereby seeking
the disks more as it moves between writing data and writing inodes.

With 2k inodes, that change doesn't occur until 8TB in size (as that
is the 32bit inode number limit with 2k inodes), so the allocator is
still keeping inode+data locality as close as possible on a fs size
of 6TB.

I suggest running the 256 byte inode numbers again with the "inode64"
mount option (so the allocator behaves the same as for 2k inodes) and
seeing how much difference remains....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
