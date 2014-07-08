Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DC1D7F3F
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 06:59:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 030B3AC005
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 04:59:37 -0700 (PDT)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id 4viSYifkTRzZ2PgV (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 04:59:35 -0700 (PDT)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N8E00MFT6N8PC30@mailout2.samsung.com> for
	xfs@oss.sgi.com; Tue, 08 Jul 2014 20:59:32 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 0/3] fs: introduce IOC_MOV_DATA ioctl
Date: Tue, 08 Jul 2014 20:59:32 +0900
Message-id: <003d01cf9aa4$14386cf0$3ca946d0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

For speeding non linear media editing operations, we have already implemeted
FALLOC_FL_COLLAPSE_RANGE (merged in kernel since 3.15) and 
FALLOC_FL_INSERT_RANGE (currently awaiting review).
Both of these fallocate flags are used to remove/insert data within same file.
In continuation of our effort of speeding non linear media editing
(although the use case is not limited to just media editing) we introduce here
an ioctl FS_IOC_MOV_DATA which moves arbitrary (but fs block size aligned
as of now) bytes of data from one file into other file .

The movement takes place by transfering complete extents from donor file to
receiver file and leaves a hole in the donor file at the point from where
the blocks are moved. To eliminate the hole from donor, user can call
COLLAPSE_RANGE after the ioctl is finished if contiguous file space is required.

The main data structure for this ioctl is:
struct mov_data {
       int     donor_fd;               /* fd of donor file */
       int     receiver_fd;            /* fd of receiver file */
       loff_t  donor_offset;           /* offset into donor file */
       loff_t  receiver_offset;        /* offset into receiver file */
       loff_t  length;                 /* data length to be moved */
       loff_t  moved_len;              /* data length actually moved after completion */
       int     flags;                  /* Currently unused */
};

FS_IOC_MOV_DATA will move length bytes of data from donor_fd's donor_offset
to receiver_fd's receiver_offset. The prerequisite is that there must be 
atleast length size hole present @receiver_offset.

For inserting hole within file size at receiver_offset, FALLOC_FL_INSERT_RANGE
can be used. We will shortly post new version of FALLOC_FL_INSERT_RANGE which
enables inserting hole instead of current behavior of allocating unwritten
extents. If the requirement is to create hole at the end of file, truncate(2)
will suffice.

The semantics of this ioctl are:
1) Like collapse range, offsets and length should be file system block size
   aligned.
2) In the receiver file, atleast length size hole should be present at
   receiver_offset
3) It does not change file size of any of donor or receiver file.
4) It leaves a hole at the place from where blocks are moved out in donor file.
5) Both (donor_offset + length) and (receiver_offset + length) should be within
   size of donor file and receiver file respectively.
   Only unwritten extents resides beyond file size and it does not make sense
   to transfer unwritten extents, leave apart the security issues it may raise.
6) If the range to be transfered from donor file contain any holes, they are
   replicated as it is in receiver file. It mean holes are preserved and
   the length of hole will be added to moved_len signifying that the hole range
   is succesfully transfered.

Currently, flags field is unused but could be used to expand new functionalities
in future.
Some potential enhancements could be:
1) Instead of moving data, one could use it for zero copying between 2 regular
   files.
2) Can expand it for a generic VFS interface for defragmenting files.
   Copying data from donor to receiver and than swapping their extents.
   Currently xfs has swap_extent ioctl and ext4 has move_extent ioctl.
   These two calls could additionaly go through the common interface.
3) Or it can be expanded just for swapping extents without copying.

Note: These patchse are created on source included INSERT RANGE patches.
Please Firstly Apply INSERT RANGE patches before applying IOC_MOV_DATA patches.

Namjae Jeon (3):
 fs: Add support IOC_MOV_DATA ioctl
 xfs: Add support IOC_MOV_DATA ioctl
 ext4: Add support IOC_MOV_DATA ioctl
 TODO: Add testcases in xfstests
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
