Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n17KkgaM126711 for <xfs@oss.sgi.com>; Sat, 7 Feb 2009 14:46:43 -0600
Received: from wombat.diezmil.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3E9518E9E80
	for <xfs@oss.sgi.com>; Sat,  7 Feb 2009 12:46:03 -0800 (PST)
Received: from wombat.diezmil.com (aa.81.b6.static.xlhost.com
	[207.182.129.170]) by cuda.sgi.com with ESMTP id
	cSRzZn9ACLWJQE1y for <xfs@oss.sgi.com>;
	Sat, 07 Feb 2009 12:46:03 -0800 (PST)
Received: from wombat.diezmil.com (wombat.diezmil.com [127.0.0.1])
	by wombat.diezmil.com (8.14.2/8.14.2) with ESMTP id n17Kk1dk011752
	for <xfs@oss.sgi.com>; Sat, 7 Feb 2009 15:46:01 -0500
Date: Sat, 7 Feb 2009 15:46:01 -0500
From: kevin.dual@gmail.com
Message-ID: <22271900.11234039561556.JavaMail.root@wombat.diezmil.com>
In-Reply-To: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL>
Subject: Re: Power loss causes bad magic number??
MIME-Version: 1.0
Reply-To: kevin.dual@gmail.com
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
To: xfs@oss.sgi.com

I'm having a very similar problem... My 1TB RAID-5 array formatted with XFS assembles, but refuses to mount:

--------------------------------------------------
$ dmesg
...
[19827.704838] XFS: bad magic number
[19827.704847] XFS: SB validate failed

--------------------------------------------------
$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
      976767872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

--------------------------------------------------
$ sudo parted -l
Model: ATA ST3500641AS (scsi)
Disk /dev/sda: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End    Size    Type      File system  Flags
 1      32.3kB  480GB  480GB   primary   ext3         boot
 2      480GB   500GB  20.3GB  extended
 5      480GB   500GB  20.3GB  logical   linux-swap


Model: ATA ST3500641AS (scsi)
Disk /dev/sdb: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End    Size   Type     File system  Flags
 1      32.3kB  500GB  500GB  primary               raid


Model: ATA ST3500641AS (scsi)
Disk /dev/sdc: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End    Size   Type     File system  Flags
 1      32.3kB  500GB  500GB  primary               raid


Model: ATA ST3500641AS (scsi)
Disk /dev/sdd: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End    Size   Type     File system  Flags
 1      32.3kB  500GB  500GB  primary               raid


Error: /dev/md0: unrecognised disk label

--------------------------------------------------
$ sudo xfs_check /dev/md0
xfs_check: unexpected XFS SB magic number 0x110812af
cache_node_purge: refcount was 1, not zero (node=0x1300220)
xfs_check: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=0x1300440)
xfs_check: cannot read realtime bitmap inode (22)
Segmentation fault

$ sudo xfs_check /dev/sdb1
xfs_check: unexpected XFS SB magic number 0x110812af
cache_node_purge: refcount was 1, not zero (node=0x2213220)
xfs_check: cannot read root inode (22)
bad superblock magic number 110812af, giving up

$ sudo xfs_check /dev/sdc1
cache_node_purge: refcount was 1, not zero (node=0x2377220)
xfs_check: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=0x2377440)
xfs_check: cannot read realtime bitmap inode (22)
Segmentation fault

$ sudo xfs_check /dev/sdd1
xfs_check: unexpected XFS SB magic number 0x494e41ed
xfs_check: size check failed
xfs_check: read failed: Invalid argument
xfs_check: data size check failed
cache_node_purge: refcount was 1, not zero (node=0x24f1c20)
xfs_check: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=0x24f1d70)
xfs_check: cannot read realtime bitmap inode (22)
Segmentation fault


--------------------------------------------------
$ sudo xfs_repair -n /dev/md0
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
...etc...etc...fail fail fail

$ sudo xfs_repair -n /dev/sdb1
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
...etc...etc...fail fail fail

$ sudo xfs_repair -n /dev/sdc1
Phase 1 - find and verify superblock...                
error reading superblock 17 -- seek to offset 531361234944 failed
couldn't verify primary superblock - bad magic number !!!        

attempting to find secondary superblock...
...found candidate secondary superblock...
error reading superblock 17 -- seek to offset 531361234944 failed                                                                                                                                                                                                              
unable to verify superblock, continuing...              
...etc...etc...fail fail fail

you know the routine... 


--------------------------------------------------
$ sudo dd if=/dev/md0 bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
128+0 records in
128+0 records out
65536 bytes (66 kB) copied, 0.0257556 s, 2.5 MB/s

$ sudo dd if=/dev/sdb bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
128+0 records in
128+0 records out
65536 bytes (66 kB) copied, 0.0352348 s, 1.9 MB/s

$ sudo dd if=/dev/sdc bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
00007e00  58 46 53 42 00 00 10 00  00 00 00 00 0e 8e 12 00  |XFSB............|
128+0 records in
128+0 records out
65536 bytes (66 kB) copied, 0.0386271 s, 1.7 MB/s

$ sudo dd if=/dev/sdd bs=512 count=128 iflag=direct | hexdump -C | grep XFSB
128+0 records in
128+0 records out
65536 bytes (66 kB) copied, 0.0928554 s, 706 kB/s

Looks like /dev/sdc is the only one with any recognizable superblock data on it.
--------------------------------------------------

Now what should I do with all this information?  The array assembles fine, but the XFS volume seems to be screwed up somehow.  Is there any way the array could have put itself together wrong then re-synced and corrupted all my data?


--
This message was sent on behalf of kevin.dual@gmail.com at openSubscriber.com
http://www.opensubscriber.com/message/xfs@oss.sgi.com/9638260.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
