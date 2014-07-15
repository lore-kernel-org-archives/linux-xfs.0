Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6389B7F9E
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 07:15:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1DE8AC006
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:15:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y9Pvw0CGIUABWDmG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 05:15:17 -0700 (PDT)
Date: Tue, 15 Jul 2014 08:15:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Fiemap inconsistent behaviour when file offset range isn't on a
	block boundary
Message-ID: <20140715121512.GA54811@bfoster.bfoster>
References: <2891198.LvUkX379bh@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2891198.LvUkX379bh@localhost.localdomain>
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
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 15, 2014 at 04:20:29PM +0630, Chandan Rajendra wrote:
> All the filesystems created and used below have 4k blocksize. The
> "file.bin" file mentioned below is 8k in size and has two 4k
> extents. The test program used can be found at http://fpaste.org/118057/.
> 
> 1. First run (file range being passed is on block boundaries).
>    ,----
>    | [root@guest0 btrfs]# for f in $(ls -1 /mnt/{btrfs,ext4,xfs}/file.bin) ;
>    | >        do
>    | >        echo "-------------- File: $f -----------";
>    | >        /root/print-fiemap 0 8192 $f;
>    | >        done
>    | -------------- File: /mnt/btrfs/file.bin -----------
>    | File range: 0 - 8191.
>    | Found 2 extents.
>    | Fiemap information:
>    | 		Logical: 0
>    | 		Physical: 12582912
>    | 		Length: 4096
>    | 		Flags:
>    | 
>    | 		Logical: 4096
>    | 		Physical: 12656640
>    | 		Length: 4096
>    | 		Flags: FIEMAP_EXTENT_LAST |
>    | 
>    | -------------- File: /mnt/ext4/file.bin -----------
>    | File range: 0 - 8191.
>    | Found 2 extents.
>    | Fiemap information:
>    | 		Logical: 0
>    | 		Physical: 135270400
>    | 		Length: 4096
>    | 		Flags:
>    | 
>    | 		Logical: 4096
>    | 		Physical: 135278592
>    | 		Length: 4096
>    | 		Flags: FIEMAP_EXTENT_LAST |
>    | 
>    | -------------- File: /mnt/xfs/file.bin -----------
>    | File range: 0 - 8191.
>    | Found 2 extents.
>    | Fiemap information:
>    | 		Logical: 0
>    | 		Physical: 49152
>    | 		Length: 4096
>    | 		Flags:
>    | 
>    | 		Logical: 4096
>    | 		Physical: 57344
>    | 		Length: 4096
>    | 		Flags: FIEMAP_EXTENT_LAST |
>    `----
> 
> 2. If the file offset range being passed as input to fiemap ioctl is
>    not on block boundaries and falls within an extent's range then that
>    extent is skipped.
>    ,----
>    | [root@guest0 btrfs]# for f in $(ls -1 /mnt/{btrfs,ext4,xfs}/file.bin) ;
>    | > do
>    | > echo "-------------- File: $f -----------";
>    | > /root/print-fiemap 1 4095 $f;
>    | > done
>    | -------------- File: /mnt/btrfs/file.bin -----------
>    | File range: 1 - 4095.
>    | Found 0 extents.
>    | 
>    | 
>    | -------------- File: /mnt/ext4/file.bin -----------
>    | File range: 1 - 4095.
>    | Found 1 extents.
>    | Fiemap information:
>    | 		Logical: 0
>    | 		Physical: 135270400
>    | 		Length: 4096
>    | 		Flags:
>    | 
>    | -------------- File: /mnt/xfs/file.bin -----------
>    | File range: 1 - 4095.
>    | Found 2 extents.
>    | Fiemap information:
>    | 		Logical: 0
>    | 		Physical: 49152
>    | 		Length: 4096
>    | 		Flags:
>    | 
>    | 		Logical: 4096
>    | 		Physical: 57344
>    | 		Length: 4096
>    | 		Flags: FIEMAP_EXTENT_LAST |
>    `----
> 
>    From linux/Documentation/filesystems/fiemap.txt, "fm_start, and
>    fm_length specify the logical range within the file which the
>    process would like mappings for. Extents returned mirror those on
>    disk - that is, the logical offset of the 1st returned extent may
>    start before fm_start, and the range covered by the last returned
>    extent may end after fm_length. All offsets and lengths are in
>    bytes."
> 
>    So IMHO, the above would mean that all the extents that map the
>    file range [fm_start, fm_start + fm_length - 1] should be returned
>    by a fiemap ioctl call (as done by ext4).
> 
>    In the case of Btrfs, the commit
>    ea8efc74bd0402b4d5f663d007b4e25fa29ea778 i.e. "Btrfs: make sure not
>    to return overlapping extents to fiemap", forces the first extent
>    returned by btrfs_fiemap() to start from fm_start (if fm_start is
>    greater than the file offset mapped by the containing extent's
>    first byte). Can somebody please list some example scenarios where
>    extent_fiemap() ends up returning dupclicate and overlapping
>    extents?
>    Also, the commit 4d479cf010d56ec9c54f3099992d039918f1296b
>    i.e. "Btrfs: sectorsize align offsets in fiemap", rounds up first
>    byte of the file offset range to the next block. Shouldn't it be
>    rounded down instead?
> 
>    XFS lists both the extents even though the first one encompasses the
>    file range specified in the input.
>      

I gave this a test on XFS with a file that looks like this:

# xfs_bmap -v /mnt/file 
/mnt/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..15]:         102368..102383    1 (51168..51183)      16 10000
   1: [16..63]:        1832..1879        0 (1832..1879)        48 10000

I narrowed the print_fiemap behavior down to this:

# ./print_fiemap 1 7680 /mnt/file 
File range: 1 - 7680.
Found 1 extents.
Fiemap information:
		Logical: 0
		Physical: 52412416
		Length: 8192
		Flags: FIEMAP_EXTENT_UNWRITTEN | 

# ./print_fiemap 1 7681 /mnt/file 
File range: 1 - 7681.
Found 2 extents.
Fiemap information:
		Logical: 0
		Physical: 52412416
		Length: 8192
		Flags: FIEMAP_EXTENT_UNWRITTEN | 

		Logical: 8192
		Physical: 937984
		Length: 4096
		Flags: FIEMAP_EXTENT_LAST | FIEMAP_EXTENT_UNWRITTEN | 

... which is caused by using the BTOBB() macro on the provided length
value. This rounds the length up by a basic block (512 bytes). Switching
this to use BTOBBT() fixes it for me. Patch below, care to test? Thanks.

Brian

---8<---

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d75621a..d2fbc42 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1060,7 +1060,7 @@ xfs_vn_fiemap(
 	if (length == FIEMAP_MAX_OFFSET)
 		bm.bmv_length = -1LL;
 	else
-		bm.bmv_length = BTOBB(length);
+		bm.bmv_length = BTOBBT(length);
 
 	/* We add one because in getbmap world count includes the header */
 	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :

> -- 
> chandan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
