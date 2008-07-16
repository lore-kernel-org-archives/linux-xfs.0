Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jul 2008 19:18:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6G2HZM5010798
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 19:17:38 -0700
Received: from rsbne02.RSBNE.LOCAL (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D48018D9E10
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 19:18:38 -0700 (PDT)
Received: from rsbne02.RSBNE.LOCAL (robert87.lnk.telstra.net [203.45.17.90]) by cuda.sgi.com with ESMTP id 8FqwLCPnv7zYHQkW for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 19:18:38 -0700 (PDT)
MIME-Version: 1.0
Subject: Power loss causes bad magic number??
Date: Wed, 16 Jul 2008 12:18:35 +1000
Message-ID: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL>
From: "Stephen Porter" <stephenp@r-s.com.au>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

 

Hoping someone may be able to offer some advice/assistance.

 

I lost power twice (within a few hours) to my machine which had a ~2.2TB
XFS volume on it.  The first time the machine (running Xubuntu 8.04)
came back up ok, the second time the XFS volume will not mount.  Is
there any chance of recovering the data? /dev/sdc is seen by xubuntu as
one ~2.2TB disk, and I put the XFS file system straight onto the disk.
It's 4x750GB drives on a hardware raid controller (rocketraid 2320).
Driver/module for rocket raid (rr232x) is loaded ok.

 

In the system log I see:

 

XFS: bad magic number

XFS: SB validate failed

 

I tried running xfs_check, the result of this was:

 

xfs_check /dev/sdc
xfs_check: unexpected XFS SB magic number 0x33c08ed0
xfs_check: size check failed
xfs_check: read failed: Invalid argument
xfs_check: data size check failed
xfs_check: failed to alloc -225176656 bytes: Cannot allocate memory

 

I looked at running xfs_repair, but the man page states that this will
only work on a volume that has been unmounted cleanly... as I lost power
the volume has not been unmounted cleanly, but I cannot mount it again
to unmount it cleanly.

 

Running xfs_repair gives the following:

 

xfs_repair -n /dev/sdc

Phase 1 - find and verify superblock...

bad primary superblock - bad magic number !!!

 

...attempting to find secondary superblock...

 

...found candidate secondary superblock... unable to verify superblock,
continuing...

(the above appears a few times, until finally)

...Sorry, could not find valid secondary superblock

Exiting now.

 

I've seen it mentioned in other posts to the xfs archive to check that
there is an xfs volume there, so I've also included the output of "dd
if=/dev/sdc bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x" below:

 

$ dd if=/dev/sdc bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x

000000 c033 d08e 00bc fb7c 0750 1f50 befc 7c1b

000010 1bbf 5006 b957 01e5 a4f3 bdcb 07be 04b1

000020 6e38 7c00 7509 8313 10c5 f4e2 18cd f58b

000030 c683 4910 1974 2c38 f674 b5a0 b407 8b07

000040 acf0 003c fc74 07bb b400 cd0e eb10 88f2

000050 104e 46e8 7300 fe2a 1046 7e80 0b04 0b74

000060 7e80 0c04 0574 b6a0 7507 80d2 0246 8306

000070 0846 8306 0a56 e800 0021 0573 b6a0 eb07

000080 81bc fe3e 557d 74aa 800b 107e 7400 a0c8

000090 07b7 a9eb fc8b 571e f58b bfcb 0005 568a

0000a0 b400 cd08 7213 8a23 24c1 983f de8a fc8a

0000b0 f743 8be3 86d1 b1d6 d206 42ee e2f7 5639

0000c0 770a 7223 3905 0846 1c73 01b8 bb02 7c00

0000d0 4e8b 8b02 0056 13cd 5173 744f 324e 8ae4

0000e0 0056 13cd e4eb 568a 6000 aabb b455 cd41

0000f0 7213 8136 55fb 75aa f630 01c1 2b74 6061

000100 006a 006a 76ff ff0a 0876 006a 0068 6a7c

000110 6a01 b410 8b42 cdf4 6113 7361 4f0e 0b74

000120 e432 568a cd00 eb13 61d6 c3f9 6e49 6176

000130 696c 2064 6170 7472 7469 6f69 206e 6174

000140 6c62 0065 7245 6f72 2072 6f6c 6461 6e69

000150 2067 706f 7265 7461 6e69 2067 7973 7473

000160 6d65 4d00 7369 6973 676e 6f20 6570 6172

000170 6974 676e 7320 7379 6574 006d 0000 0000

000180 0000 0000 0000 0000 0000 0000 0000 0000

*

0001b0 0000 0000 2c00 6344 089d 089e 0000 0100

0001c0 0001 fefd 3c3f 003f 0000 f3be 000e 0000

0001d0 3d01 fefd ffff f3fd 000e cbe5 0e40 0000

0001e0 0000 0000 0000 0000 0000 0000 0000 0000

0001f0 0000 0000 0000 0000 0000 0000 0000 aa55

000200

 

 

 

Any help greatly appreciated.

 

Thanks,

Stephen 



 



[[HTML alternate version deleted]]
