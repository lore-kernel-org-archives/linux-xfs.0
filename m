Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n17LHCrB128871 for <xfs@oss.sgi.com>; Sat, 7 Feb 2009 15:17:12 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C479F9689
	for <xfs@oss.sgi.com>; Sat,  7 Feb 2009 13:16:33 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id G26s1jhob1GeFuHe for <xfs@oss.sgi.com>;
	Sat, 07 Feb 2009 13:16:33 -0800 (PST)
Message-ID: <498DF8AD.3020903@sandeen.net>
Date: Sat, 07 Feb 2009 15:10:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Power loss causes bad magic number??
References: <22271900.11234039561556.JavaMail.root@wombat.diezmil.com>
In-Reply-To: <22271900.11234039561556.JavaMail.root@wombat.diezmil.com>
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
To: kevin.dual@gmail.com
Cc: xfs@oss.sgi.com

kevin.dual@gmail.com wrote:
> I'm having a very similar problem... My 1TB RAID-5 array formatted with XFS assembles, but refuses to mount:

...

> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
>       976767872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> unused devices: <none>

...


> --------------------------------------------------
> $ sudo xfs_check /dev/md0
> xfs_check: unexpected XFS SB magic number 0x110812af
> cache_node_purge: refcount was 1, not zero (node=0x1300220)
> xfs_check: cannot read root inode (22)
> cache_node_purge: refcount was 1, not zero (node=0x1300440)
> xfs_check: cannot read realtime bitmap inode (22)
> Segmentation fault

hm, ok...

but below you don't expect each component drive to be a consistent xfs
fs do you?  It's not a mirror :)

> $ sudo xfs_check /dev/sdb1
> xfs_check: unexpected XFS SB magic number 0x110812af
> cache_node_purge: refcount was 1, not zero (node=0x2213220)
> xfs_check: cannot read root inode (22)
> bad superblock magic number 110812af, giving up
> 
> $ sudo xfs_check /dev/sdc1
> cache_node_purge: refcount was 1, not zero (node=0x2377220)
> xfs_check: cannot read root inode (22)
> cache_node_purge: refcount was 1, not zero (node=0x2377440)
> xfs_check: cannot read realtime bitmap inode (22)
> Segmentation fault
> 
> $ sudo xfs_check /dev/sdd1
> xfs_check: unexpected XFS SB magic number 0x494e41ed
> xfs_check: size check failed
> xfs_check: read failed: Invalid argument
> xfs_check: data size check failed
> cache_node_purge: refcount was 1, not zero (node=0x24f1c20)
> xfs_check: cannot read root inode (22)
> cache_node_purge: refcount was 1, not zero (node=0x24f1d70)
> xfs_check: cannot read realtime bitmap inode (22)
> Segmentation fault
> 

none of the above surprises me

> --------------------------------------------------
> $ sudo xfs_repair -n /dev/md0
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> 
> attempting to find secondary superblock...
> ...etc...etc...fail fail fail

Ok so above is the real problem.

again below is not expected to work!

> $ sudo xfs_repair -n /dev/sdb1
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> 
> attempting to find secondary superblock...
> ...etc...etc...fail fail fail
> 
> $ sudo xfs_repair -n /dev/sdc1
> Phase 1 - find and verify superblock...                
> error reading superblock 17 -- seek to offset 531361234944 failed
> couldn't verify primary superblock - bad magic number !!!        
> 
> attempting to find secondary superblock...
> ...found candidate secondary superblock...
> error reading superblock 17 -- seek to offset 531361234944 failed                                                                                                                                                                                                              
> unable to verify superblock, continuing...              
> ...etc...etc...fail fail fail
> 
> you know the routine... 
> 
> 
> --------------------------------------------------
> $ sudo dd if=/dev/md0 bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
> 128+0 records in
> 128+0 records out
> 65536 bytes (66 kB) copied, 0.0257556 s, 2.5 MB/s
>
> $ sudo dd if=/dev/sdb bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
> 128+0 records in
> 128+0 records out
> 65536 bytes (66 kB) copied, 0.0352348 s, 1.9 MB/s
> 
> $ sudo dd if=/dev/sdc bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
> 00007e00  58 46 53 42 00 00 10 00  00 00 00 00 0e 8e 12 00  |XFSB............|

ibase=16
7E00
32256, or 63x512

and sdc was:

> Model: ATA ST3500641AS (scsi)
> Disk /dev/sdc: 500GB
> Sector size (logical/physical): 512B/512B
> Partition Table: msdos
> 
> Number  Start   End    Size   Type     File system  Flags
>  1      32.3kB  500GB  500GB  primary               raid

IOW the normal msdos 63 sectors.

> 128+0 records in
> 128+0 records out
> 65536 bytes (66 kB) copied, 0.0386271 s, 1.7 MB/s
> 
> $ sudo dd if=/dev/sdd bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
> 128+0 records in
> 128+0 records out
> 65536 bytes (66 kB) copied, 0.0928554 s, 706 kB/s
> 
> Looks like /dev/sdc is the only one with any recognizable superblock data on it.
> --------------------------------------------------
> 
> Now what should I do with all this information?  The array assembles fine, but the XFS volume seems to be screwed up somehow.  Is there any way the array could have put itself together wrong then re-synced and corrupted all my data?

It seems like maybe it assembled out of order, as if sdc1 should be the
first drive, since it has the magic at the right place.

Dunno how much damage could have been done, or if you can just try to
fix the assembly perhaps...?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
