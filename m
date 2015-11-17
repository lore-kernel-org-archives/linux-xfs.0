Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 176457F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 02:04:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 13798304039
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 00:03:59 -0800 (PST)
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249]) by
	cuda.sgi.com with ESMTP id anWxGO24WE75XuvS for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 00:03:55 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by smtp1.onthe.net.au (Postfix) with ESMTP id 6D060617C3
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 19:03:52 +1100 (EST)
Received: from smtp1.onthe.net.au ([127.0.0.1])
	by localhost (smtp1.onthe.net.au [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZXTKnyA8yGi7 for <xfs@oss.sgi.com>;
	Tue, 17 Nov 2015 19:03:51 +1100 (EST)
Received: from o1.private.otn.net.au (o1.private.onthe.net.au [10.200.63.41])
	by smtp1.onthe.net.au (Postfix) with ESMTP id 7B619617C1
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 19:03:33 +1100 (EST)
Received: from hestia (pony.office.onthe.net.au [10.9.1.6])
	by o1.private.otn.net.au (Postfix) with ESMTP id 760DEE122D
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 19:03:33 +1100 (AEDT)
Date: Tue, 17 Nov 2015 19:03:33 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: Disk error, then endless loop
Message-ID: <20151117080332.GA28936@onthe.net.au>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi,

XFS error handling on linux 3.18.21 looks to be "suboptimal".

I had an XFS disk start returning read errors, then disappear from the
controller altogether (only to come back under a different /dev/sdXX name).
XFS is now endlessly flooding these messages into kern.log (55,000 copies
and counting...):

[5358213.926049] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.926141] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.

More info below, but some questions:

Is this a known issue, if so, has it been fixed, and if so, in which commit?

I guess I'm going to have to hard boot the machine to get out of this,
right?

More info...

The XFS the only thing on the gpt partitioned disk, on partition 1, with a
log device on a partition of an SSD-backed md raid-1.

The disk is:

Device Model:     WDC WD60EFRX-68MYMN1
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical

The XFS was formatted like:

# mkfs.xfs -V
mkfs.xfs version 3.2.1
# mkfs.xfs -l logdev=/dev/md8p5 -i size=2048 /dev/sdu1
meta-data=/dev/sdu1 isize=2048   agcount=6, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=1465130385, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =/dev/md8p5             bsize=4096   blocks=409600, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I tried to umount the filesystem but the umount is now hung and unkillable:

# ps -ostat,wchan='WCHAN-xxxxxxxxxxxxxxxxxx',cmd -C umount
STAT WCHAN-xxxxxxxxxxxxxxxxxx CMD
D+   xfs_ail_push_all_sync    umount /var/lib/ceph/osd/ceph-18

As previously mentioned, the disk has actually reappeared under a different
/dev/sdXX name (it was sdu, now sdbh). Trying to mount the disk (read only)
results in:

# mkdir /mnt/xfs && mount -ologdev=/dev/md8p5,ro /dev/sdbh1 /mnt/xfs
mount: /dev/sdbh1 already mounted or /mnt/xfs busy

kern.log leading up to this event:

[5358213.665887] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
[5358213.665939] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
[5358213.665990] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
[5358213.666042] mpt2sas0: log_info(0x31120436): originator(PL), code(0x12), sub_code(0x0436)
[5358213.666138] sd 0:0:20:0: [sdu]  
[5358213.666165] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.666196] sd 0:0:20:0: [sdu] CDB: 
[5358213.666222] Write(16): 8a 00 00 00 00 00 2e 99 9b 00 00 00 02 98 00 00
[5358213.666295] blk_update_request: I/O error, dev sdu, sector 781818624
[5358213.666423] Buffer I/O error on dev sdu1, logical block 363305032, lost async page write
[5358213.666480] sd 0:0:20:0: [sdu]  
[5358213.666504] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.666532] sd 0:0:20:0: [sdu] CDB: 
[5358213.666555] Write(16): 8a 00 00 00 00 00 2e 99 97 00 00 00 04 00 00 00
[5358213.666626] blk_update_request: I/O error, dev sdu, sector 781817600
[5358213.666661] sd 0:0:20:0: [sdu]  
[5358213.666684] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.666713] sd 0:0:20:0: [sdu] CDB: 
[5358213.666736] Write(16): 8a 00 00 00 00 00 2e 99 93 00 00 00 04 00 00 00
[5358213.666808] blk_update_request: I/O error, dev sdu, sector 781816576
[5358213.666842] sd 0:0:20:0: [sdu]  
[5358213.666865] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.666893] sd 0:0:20:0: [sdu] CDB: 
[5358213.666917] Read(16): 88 00 00 00 00 01 27 9b 51 10 00 00 00 08 00 00
[5358213.666988] blk_update_request: I/O error, dev sdu, sector 4959457552
[5358213.667025] sd 0:0:20:0: [sdu]  
[5358213.667048] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.667077] sd 0:0:20:0: [sdu] CDB: 
[5358213.667100] Write(16): 8a 00 00 00 00 01 2c 40 b8 a8 00 00 01 78 00 00
[5358213.667171] blk_update_request: I/O error, dev sdu, sector 5037406376
[5358213.667206] sd 0:0:20:0: [sdu]  
[5358213.667229] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.667257] sd 0:0:20:0: [sdu] CDB: 
[5358213.667281] Write(16): 8a 00 00 00 00 01 2c 40 b4 a8 00 00 04 00 00 00
[5358213.667351] blk_update_request: I/O error, dev sdu, sector 5037405352
[5358213.667385] blk_update_request: I/O error, dev sdu, sector 0
[5358213.667419] blk_update_request: I/O error, dev sdu, sector 0
[5358213.667452] sd 0:0:20:0: [sdu]  
[5358213.667475] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.667504] sd 0:0:20:0: [sdu] CDB: 
[5358213.667527] Write(16): 8a 00 00 00 00 01 27 9b 50 b0 00 00 00 60 00 00
[5358213.667598] blk_update_request: I/O error, dev sdu, sector 4959457456
[5358213.667628] Buffer I/O error on dev sdu1, logical block 619931926, lost async page write
[5358213.667678] Buffer I/O error on dev sdu1, logical block 619931927, lost async page write
[5358213.667727] Buffer I/O error on dev sdu1, logical block 619931928, lost async page write
[5358213.667774] Buffer I/O error on dev sdu1, logical block 619931929, lost async page write
[5358213.667821] Buffer I/O error on dev sdu1, logical block 619931930, lost async page write
[5358213.667868] Buffer I/O error on dev sdu1, logical block 619931931, lost async page write
[5358213.667915] Buffer I/O error on dev sdu1, logical block 619931932, lost async page write
[5358213.667962] Buffer I/O error on dev sdu1, logical block 619931933, lost async page write
[5358213.668010] Buffer I/O error on dev sdu1, logical block 619931934, lost async page write
[5358213.668065] sd 0:0:20:0: [sdu]  
[5358213.668088] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.668118] sd 0:0:20:0: [sdu] CDB: 
[5358213.668141] Write(16): 8a 00 00 00 00 00 2e 99 91 98 00 00 01 68 00 00
  << above 4 errors repeat a number of times, then >>>
[5358213.672847] sd 0:0:20:0: [sdu]  
[5358213.672870] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.672898] sd 0:0:20:0: [sdu] CDB: 
[5358213.672922] Write(16): 8a 00 00 00 00 00 ad 40 60 38 00 00 04 00 00 00
[5358213.673083] XFS (sdu1): metadata I/O error: block 0x817f21d8 ("xfs_trans_read_buf_map") error 5 numblks 8
[5358213.673086] XFS (sdu1): metadata I/O error: block 0x183698f78 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.673093] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[5358213.673225] sd 0:0:20:0: [sdu]  
[5358213.673226] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5358213.673227] sd 0:0:20:0: [sdu] CDB: 
[5358213.673233] Write(16): 8a 00 00 00 00 01 ab b3 5a c8 00 00 04 00 00 00
[5358213.678590] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.678686] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[5358213.679799] XFS (sdu1): metadata I/O error: block 0x28 ("xfs_buf_iodone_callbacks") error 5 numblks 8
[5358213.725951] XFS (sdu1): Detected failing async write on buffer block 0x805d4cd8. Retrying async write.
[5358213.725951]
[5358213.726069] XFS (sdu1): Detected failing async write on buffer block 0x20d390918. Retrying async write.
[5358213.726069]
[5358213.726181] XFS (sdu1): Detected failing async write on buffer block 0x88a017f0. Retrying async write.
[5358213.726181]
[5358213.726292] XFS (sdu1): Detected failing async write on buffer block 0x80d04890. Retrying async write.
[5358213.726292]
[5358213.726428] XFS (sdu1): Detected failing async write on buffer block 0x85bd33d8. Retrying async write.
[5358213.726428]
[5358213.726539] XFS (sdu1): Detected failing async write on buffer block 0x80ca6110. Retrying async write.
[5358213.726539]
[5358213.726650] XFS (sdu1): Detected failing async write on buffer block 0x857f1bb8. Retrying async write.
[5358213.726650]
[5358213.726762] XFS (sdu1): Detected failing async write on buffer block 0x88a017e0. Retrying async write.
[5358213.726762]
[5358213.726873] XFS (sdu1): Detected failing async write on buffer block 0x804f1c10. Retrying async write.
[5358213.726873]
[5358213.726984] XFS (sdu1): Detected failing async write on buffer block 0x859381b8. Retrying async write.
[5358213.726984]
[5358213.727126] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.727212] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[5358213.775880] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.775972] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[5358213.825966] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.826061] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[5358213.876050] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.876142] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[5358213.926049] XFS (sdu1): metadata I/O error: block 0x2b163a0 ("xfs_trans_read_buf_map") error 5 numblks 16
[5358213.926141] XFS (sdu1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.

...and the "metadata" and "xfs_imap_to_bp" messages continue to flood into
kern.log (120,000 and counting...)


Cheers,

Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
