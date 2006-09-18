Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 15:25:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8IMOnZd025648
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:25:01 -0700
Date: Tue, 19 Sep 2006 08:23:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_check - out of memory | xfs_repair - superblock error reading
Message-ID: <20060918222348.GY3034@melbourne.sgi.com>
References: <200609181519.18448.christian.gattermair@mci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200609181519.18448.christian.gattermair@mci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: christian gattermair <christian.gattermair@mci.edu>
Cc: xfs@oss.sgi.com

On Mon, Sep 18, 2006 at 03:19:18PM +0200, christian gattermair wrote:
> hi!
> 
> after a reboot of our box (debian sarge, 3ware controller, raid 5 - 3tb xfs) 
> we can not mount it any more.
> 
> from syslog:
> 
> Sep 18 12:51:36 localhost kernel: SGI XFS with ACLs, security attributes, 
> realtime, large block numbers, no debug enabled
> Sep 18 12:51:36 localhost kernel: SGI XFS Quota Management subsystem
> Sep 18 12:51:53 localhost kernel: attempt to access beyond end of device
> Sep 18 12:51:53 localhost kernel: sdb1: rw=0, want=6445069056, 
> limit=2150101796
> Sep 18 12:51:53 localhost kernel: I/O error in filesystem ("sdb1") meta-data 
> dev sdb1 block 0x18027f2ff       ("xfs_read_buf") error 5 buf count 512
> Sep 18 12:51:53 localhost kernel: XFS: size check 2 failed

I/O error - something is not right with your raid controller i think.
Are there any other errors in dmesg? What does /proc/partitions tell
you about the size of the device?

> xfs_check fails with:
> 
> xfs_check /dev/sdb1
> XFS: totally zeroed log
> xfs_check: out of memory

3TB filesystem - you won't be able to xfs_check that on a 32 bit system,
and you'll need >6GiB RAM to check it on a 64bit system.

> there is a lot of space (i tryed more swap)
> 
> Mem:          1011       1006          5          0        750        111
> -/+ buffers/cache:        144        867
> Swap:        57812          0      57812
> 
> does xfs_check only looks at the mem or also an swap??? is there any hint to 
> use the swap?

Sounds like a 32 bit system where a process can't use more than 2-3GB of RAM.
No amount of swap will help if the process requires more then the maximum
thæt can be addressed per process.

> second question:
> 
> xfs_repair works but can not find any superblock. any hints?
> 
> xfs_repair /dev/sdb1
> Phase 1 - find and verify superblock...
> error reading superblock 11 -- seek to offset 1134332153856 failed
> couldn't verify primary superblock - bad magic number !!!

As already commented, that's about 1TB into 3TB volume. I'd suggest
raid controller problems....

Did you boot the same kernel you'd been running previously?

> the whole system runs one year without any errors. only today one shutdown for 
> chaning the usv ....

What's a usv? Did you change anything else?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
