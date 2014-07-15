Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C625C7FAD
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:50:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8753304043
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 03:50:40 -0700 (PDT)
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140]) by
	cuda.sgi.com with ESMTP id oM1RLu4crnKs8ogq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 03:50:38 -0700 (PDT)
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Tue, 15 Jul 2014 20:50:34 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 0C2B32CE8040
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:50:32 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	s6FAoFYd11862378
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:50:15 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	s6FAoV4D016599 for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:50:31 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Fiemap inconsistent behaviour when file offset range isn't on a block
	boundary
Date: Tue, 15 Jul 2014 16:20:29 +0630
Message-ID: <2891198.LvUkX379bh@localhost.localdomain>
MIME-Version: 1.0
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

All the filesystems created and used below have 4k blocksize. The
"file.bin" file mentioned below is 8k in size and has two 4k
extents. The test program used can be found at http://fpaste.org/118057/.

1. First run (file range being passed is on block boundaries).
   ,----
   | [root@guest0 btrfs]# for f in $(ls -1 /mnt/{btrfs,ext4,xfs}/file.bin) ;
   | >        do
   | >        echo "-------------- File: $f -----------";
   | >        /root/print-fiemap 0 8192 $f;
   | >        done
   | -------------- File: /mnt/btrfs/file.bin -----------
   | File range: 0 - 8191.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 12582912
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 12656640
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   | 
   | -------------- File: /mnt/ext4/file.bin -----------
   | File range: 0 - 8191.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 135270400
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 135278592
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   | 
   | -------------- File: /mnt/xfs/file.bin -----------
   | File range: 0 - 8191.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 49152
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 57344
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   `----

2. If the file offset range being passed as input to fiemap ioctl is
   not on block boundaries and falls within an extent's range then that
   extent is skipped.
   ,----
   | [root@guest0 btrfs]# for f in $(ls -1 /mnt/{btrfs,ext4,xfs}/file.bin) ;
   | > do
   | > echo "-------------- File: $f -----------";
   | > /root/print-fiemap 1 4095 $f;
   | > done
   | -------------- File: /mnt/btrfs/file.bin -----------
   | File range: 1 - 4095.
   | Found 0 extents.
   | 
   | 
   | -------------- File: /mnt/ext4/file.bin -----------
   | File range: 1 - 4095.
   | Found 1 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 135270400
   | 		Length: 4096
   | 		Flags:
   | 
   | -------------- File: /mnt/xfs/file.bin -----------
   | File range: 1 - 4095.
   | Found 2 extents.
   | Fiemap information:
   | 		Logical: 0
   | 		Physical: 49152
   | 		Length: 4096
   | 		Flags:
   | 
   | 		Logical: 4096
   | 		Physical: 57344
   | 		Length: 4096
   | 		Flags: FIEMAP_EXTENT_LAST |
   `----

   From linux/Documentation/filesystems/fiemap.txt, "fm_start, and
   fm_length specify the logical range within the file which the
   process would like mappings for. Extents returned mirror those on
   disk - that is, the logical offset of the 1st returned extent may
   start before fm_start, and the range covered by the last returned
   extent may end after fm_length. All offsets and lengths are in
   bytes."

   So IMHO, the above would mean that all the extents that map the
   file range [fm_start, fm_start + fm_length - 1] should be returned
   by a fiemap ioctl call (as done by ext4).

   In the case of Btrfs, the commit
   ea8efc74bd0402b4d5f663d007b4e25fa29ea778 i.e. "Btrfs: make sure not
   to return overlapping extents to fiemap", forces the first extent
   returned by btrfs_fiemap() to start from fm_start (if fm_start is
   greater than the file offset mapped by the containing extent's
   first byte). Can somebody please list some example scenarios where
   extent_fiemap() ends up returning dupclicate and overlapping
   extents?
   Also, the commit 4d479cf010d56ec9c54f3099992d039918f1296b
   i.e. "Btrfs: sectorsize align offsets in fiemap", rounds up first
   byte of the file offset range to the next block. Shouldn't it be
   rounded down instead?

   XFS lists both the extents even though the first one encompasses the
   file range specified in the input.
     
-- 
chandan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
