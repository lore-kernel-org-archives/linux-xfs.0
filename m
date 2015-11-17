Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BF8A7F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 06:41:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ACBB8F8035
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 04:41:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9sx4lClpV9dMP3xv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 04:41:51 -0800 (PST)
Date: Tue, 17 Nov 2015 07:41:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Disk error, then endless loop
Message-ID: <20151117124148.GA20118@bfoster.bfoster>
References: <20151117080332.GA28936@onthe.net.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117080332.GA28936@onthe.net.au>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chris Dunlop <chris@onthe.net.au>
Cc: xfs@oss.sgi.com

On Tue, Nov 17, 2015 at 07:03:33PM +1100, Chris Dunlop wrote:
> Hi,
> 
> XFS error handling on linux 3.18.21 looks to be "suboptimal".
> 
> I had an XFS disk start returning read errors, then disappear from the
> controller altogether (only to come back under a different /dev/sdXX name).
> XFS is now endlessly flooding these messages into kern.log (55,000 copies
> and counting...):
> 

Note that disks returning errors and/or dropping on and offline is
outside the realm of the filesystem. There isn't much the fs can do in
that case.

> [5358213.926049] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.926141] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> 
> More info below, but some questions:
> 
> Is this a known issue, if so, has it been fixed, and if so, in which commit?
> 

This is expected and the most likely scenario is that the filesystem
eventually shuts itself down to avoid further damage. At this point,
most operations will return -EIO (-5) back to the user.

> I guess I'm going to have to hard boot the machine to get out of this,
> right?
> 

Normally you should be able to unmount a filesystem that has shut
down...

> More info...
> 
> The XFS the only thing on the gpt partitioned disk, on partition 1, with a
> log device on a partition of an SSD-backed md raid-1.
> 
> The disk is:
> 
> Device Model:     WDC WD60EFRX-68MYMN1
> User Capacity:    6,001,175,126,016 bytes [6.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> 
> The XFS was formatted like:
> 
> # mkfs.xfs -V
> mkfs.xfs version 3.2.1
> # mkfs.xfs -l logdev=/dev/md8p5 -i size=2048 /dev/sdu1
> meta-data=/dev/sdu1 isize=2048   agcount=6, agsize=268435455 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=1465130385, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =/dev/md8p5             bsize=4096   blocks=409600, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> I tried to umount the filesystem but the umount is now hung and unkillable:
> 
> # ps -ostat,wchan='WCHAN-xxxxxxxxxxxxxxxxxx',cmd -C umount
> STAT WCHAN-xxxxxxxxxxxxxxxxxx CMD
> D+   xfs_ail_push_all_sync    umount /var/lib/ceph/osd/ceph-18
> 

... but it appears you still have something pending in the AIL which is
holding everything up. The most likely case is an EFI/EFD item hanging
around from an extent free operation, as this was a known issue,
particularly on fs shutdowns. Fixes for this went into the v4.3 kernel.
Note that this won't address whatever is wrong with the disk in the
first place, just (hopefully) the ability to unmount when it ultimately
fails.

Does the umount process actually appear to be doing anything? E.g., are
you seeing noticeable CPU load or I/O errors continue to the logs, or
has everything pretty much locked up? You could also enable tracepoints
(trace-cmd start -e "xfs:*"; cat /sys/kernel/debug/tracing/trace_pipe)
to get a quick idea of what's going on.

> As previously mentioned, the disk has actually reappeared under a different
> /dev/sdXX name (it was sdu, now sdbh). Trying to mount the disk (read only)
> results in:
> 
> # mkdir /mnt/xfs && mount -ologdev=/dev/md8p5,ro /dev/sdbh1 /mnt/xfs
> mount: /dev/sdbh1 already mounted or /mnt/xfs busy
> 

Probably due to either a uuid check or blocking on access to the
external log device. You'll probably need to clean up the stale mount
before this will work.

As it is, something is clearly wrong with the drive. I can't really
interpret the I/O errors and whatnot (linux-scsi?), but you probably
want to look into health assessment tools (e.g., smart) to get an idea
of what's wrong and/or replace the device and restore from backups (or
perhaps heal via the ceph cluster, in your case).

Brian

> kern.log leading up to this event:
> 
> [5358213.665887] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
> [5358213.665939] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
> [5358213.665990] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
> [5358213.666042] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
> [5358213.666138] sd 0:0:20:0: [sdu]  
> [5358213.666165] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.666196] sd 0:0:20:0: [sdu] CDB: 
> [5358213.666222] Write(16): 8a 00 00 00 00 00 2e 99 9b 00 00 00 02 98 00 00
> [5358213.666295] blk_update_request: I/O error, dev sdu, sector 781818624
> [5358213.666423] Buffer I/O error on dev sdu1, logical block 363305032, lost async page write
> [5358213.666480] sd 0:0:20:0: [sdu]  
> [5358213.666504] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.666532] sd 0:0:20:0: [sdu] CDB: 
> [5358213.666555] Write(16): 8a 00 00 00 00 00 2e 99 97 00 00 00 04 00 00 00
> [5358213.666626] blk_update_request: I/O error, dev sdu, sector 781817600
> [5358213.666661] sd 0:0:20:0: [sdu]  
> [5358213.666684] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.666713] sd 0:0:20:0: [sdu] CDB: 
> [5358213.666736] Write(16): 8a 00 00 00 00 00 2e 99 93 00 00 00 04 00 00 00
> [5358213.666808] blk_update_request: I/O error, dev sdu, sector 781816576
> [5358213.666842] sd 0:0:20:0: [sdu]  
> [5358213.666865] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.666893] sd 0:0:20:0: [sdu] CDB: 
> [5358213.666917] Read(16): 88 00 00 00 00 01 27 9b 51 10 00 00 00 08 00 00
> [5358213.666988] blk_update_request: I/O error, dev sdu, sector 4959457552
> [5358213.667025] sd 0:0:20:0: [sdu]  
> [5358213.667048] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.667077] sd 0:0:20:0: [sdu] CDB: 
> [5358213.667100] Write(16): 8a 00 00 00 00 01 2c 40 b8 a8 00 00 01 78 00 00
> [5358213.667171] blk_update_request: I/O error, dev sdu, sector 5037406376
> [5358213.667206] sd 0:0:20:0: [sdu]  
> [5358213.667229] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.667257] sd 0:0:20:0: [sdu] CDB: 
> [5358213.667281] Write(16): 8a 00 00 00 00 01 2c 40 b4 a8 00 00 04 00 00 00
> [5358213.667351] blk_update_request: I/O error, dev sdu, sector 5037405352
> [5358213.667385] blk_update_request: I/O error, dev sdu, sector 0
> [5358213.667419] blk_update_request: I/O error, dev sdu, sector 0
> [5358213.667452] sd 0:0:20:0: [sdu]  
> [5358213.667475] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.667504] sd 0:0:20:0: [sdu] CDB: 
> [5358213.667527] Write(16): 8a 00 00 00 00 01 27 9b 50 b0 00 00 00 60 00 00
> [5358213.667598] blk_update_request: I/O error, dev sdu, sector 4959457456
> [5358213.667628] Buffer I/O error on dev sdu1, logical block 619931926, lost async page write
> [5358213.667678] Buffer I/O error on dev sdu1, logical block 619931927, lost async page write
> [5358213.667727] Buffer I/O error on dev sdu1, logical block 619931928, lost async page write
> [5358213.667774] Buffer I/O error on dev sdu1, logical block 619931929, lost async page write
> [5358213.667821] Buffer I/O error on dev sdu1, logical block 619931930, lost async page write
> [5358213.667868] Buffer I/O error on dev sdu1, logical block 619931931, lost async page write
> [5358213.667915] Buffer I/O error on dev sdu1, logical block 619931932, lost async page write
> [5358213.667962] Buffer I/O error on dev sdu1, logical block 619931933, lost async page write
> [5358213.668010] Buffer I/O error on dev sdu1, logical block 619931934, lost async page write
> [5358213.668065] sd 0:0:20:0: [sdu]  
> [5358213.668088] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.668118] sd 0:0:20:0: [sdu] CDB: 
> [5358213.668141] Write(16): 8a 00 00 00 00 00 2e 99 91 98 00 00 01 68 00 00
>   << above 4 errors repeat a number of times, then >>>
> [5358213.672847] sd 0:0:20:0: [sdu]  
> [5358213.672870] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.672898] sd 0:0:20:0: [sdu] CDB: 
> [5358213.672922] Write(16): 8a 00 00 00 00 00 ad 40 60 38 00 00 04 00 00 00
> [5358213.673083] XFS (sdu1): metadata I/O error: block 0x817f21d8 ("xfs_trans_read_buf_map") error 5 numblks 8
> [5358213.673086] XFS (sdu1): metadata I/O error: block 0x183698f78 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.673093] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [5358213.673225] sd 0:0:20:0: [sdu]  
> [5358213.673226] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [5358213.673227] sd 0:0:20:0: [sdu] CDB: 
> [5358213.673233] Write(16): 8a 00 00 00 00 01 ab b3 5a c8 00 00 04 00 00 00
> [5358213.678590] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.678686] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [5358213.679799] XFS (sdu1): metadata I/O error: block 0x28 ("xfs_buf_iodone_callbacks") error 5 numblks 8
> [5358213.725951] XFS (sdu1): Detected failing async write on buffer block 0x805d4cd8. Retrying async write.
> [5358213.725951]
> [5358213.726069] XFS (sdu1): Detected failing async write on buffer block 0x20d390918. Retrying async write.
> [5358213.726069]
> [5358213.726181] XFS (sdu1): Detected failing async write on buffer block 0x88a017f0. Retrying async write.
> [5358213.726181]
> [5358213.726292] XFS (sdu1): Detected failing async write on buffer block 0x80d04890. Retrying async write.
> [5358213.726292]
> [5358213.726428] XFS (sdu1): Detected failing async write on buffer block 0x85bd33d8. Retrying async write.
> [5358213.726428]
> [5358213.726539] XFS (sdu1): Detected failing async write on buffer block 0x80ca6110. Retrying async write.
> [5358213.726539]
> [5358213.726650] XFS (sdu1): Detected failing async write on buffer block 0x857f1bb8. Retrying async write.
> [5358213.726650]
> [5358213.726762] XFS (sdu1): Detected failing async write on buffer block 0x88a017e0. Retrying async write.
> [5358213.726762]
> [5358213.726873] XFS (sdu1): Detected failing async write on buffer block 0x804f1c10. Retrying async write.
> [5358213.726873]
> [5358213.726984] XFS (sdu1): Detected failing async write on buffer block 0x859381b8. Retrying async write.
> [5358213.726984]
> [5358213.727126] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.727212] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [5358213.775880] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.775972] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [5358213.825966] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.826061] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [5358213.876050] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.876142] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [5358213.926049] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
> [5358213.926141] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> 
> ...and the "metadata" and "xfs_imap_to_bp" messages continue to flood into
> kern.log (120,000 and counting...)
> 
> 
> Cheers,
> 
> Chris
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
