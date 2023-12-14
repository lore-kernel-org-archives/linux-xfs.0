Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZX6FU+Uz"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9E2A7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:34 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9x72g018724
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=iwKfcbYqDQg6tmHeUezaWkHgRj/nNL2B3NRGqfOEgxg=;
 b=ZX6FU+Uz0hnRU6dZGvp5jFNUmPp9VyXWDaSnYteMh68sKBsJE+fEbezeOUvAlfnepUsz
 E9bzID9NN/lIdqsy9gNMEVOZ5vSVbitkjO29eA5ao9uax5L/Ln+vQnvwsHgwPpkzVeil
 PtGrPOrPnCVO7TCUl5ThPszbsFN03F+WGc9B6gajFgzAH4Q1rxhtzenyk/+FztHEizY3
 iIjIhCXakHqnnefDYV7g6s5qxN3aCrLVLx03kjM3+CYQmuLsCQRD8sBSG3Q5unHNQ67f
 1c8knhMgrALTDljevQg1Aka44Kdmv23H4T3GbvdrRRb2QsNLtEbadoWrRKe2+PyAjpx/ yg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvfuubauw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGwodj012811
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahctv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:32 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnd036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:31 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-1;
	Thu, 14 Dec 2023 17:05:31 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 0/9] xfs file non-exclusive online defragment
Date: Thu, 14 Dec 2023 09:05:21 -0800
Message-Id: <20231214170530.8664-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-14_11,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312140121
X-Proofpoint-GUID: MlbO3JeWS_mXvu0VO-1QwtWxzD0NxK7t
X-Proofpoint-ORIG-GUID: MlbO3JeWS_mXvu0VO-1QwtWxzD0NxK7t

Background:
We have the existing xfs_fsr tool which do defragment for files. It has the
following features:
1. Defragment is implemented by file copying.
2. The copy (to a temporary file) is exclusive. The source file is locked
   during the copy (to a temporary file) and all IO requests are blocked
   before the copy is done.
3. The copy could take long time for huge files with IO blocked.
4. The copy requires as many free blocks as the source file has.
   If the source is huge, say it’s 1TiB,  it’s hard to require the file
   system to have another 1TiB free.

The use case in concern is that the XFS files are used as images files for
Virtual Machines.
1. The image files are huge, they can reach hundreds of GiB and even to TiB.
2. Backups are made via reflink copies, and CoW makes the files badly fragmented.
3. fragmentation make reflink copies super slow.
4. during the reflink copy, all IO requests to the file are blocked for super
   long time. That makes timeout in VM and the timeout lead to disaster.

This feature aims to:
1. reduce the file fragmentation making future reflink (much) faster and
2. at the same time,  defragmentation works in non-exclusive manner, it doesn’t
   block file IOs long.

Non-exclusive defragment
Here we are introducing the non-exclusive manner to defragment a file,
especially for huge files, without blocking IO to it long. Non-exclusive
defragmentation divides the whole file into small pieces. For each piece,
we lock the file, defragment the piece and unlock the file. Defragmenting
the small piece doesn’t take long. File IO requests can get served between
pieces before blocked long.  Also we put (user adjustable) idle time between
defragmenting two consecutive pieces to balance the defragmentation and file IOs.
So though the defragmentation could take longer than xfs_fsr,  it balances
defragmentation and file IOs.

Operation target
The operation targets are files in XFS filesystem

User interface
A fresh new command xfs_defrag is provided. User can
start/stop/suspend/resume/get-status the defragmentation against a file.
With xfs_defrag command user can specify:
1. target extent size, extents under which are defragment target extents.
2. piece size, the whole file are divided into piece according to the piece size.
3. idle time, the idle time between defragmenting two adjacent pieces.

Piece
Piece is the smallest unit that we do defragmentation. A piece contains a range
of contiguous file blocks, it may contain one or more extents.

Target Extent Size
This is a configuration value in blocks indicating which extents are
defragmentation targets. Extents which are larger than this value are the Target
Extents. When a piece contains two or more Target Extents, the piece is a Target
Piece. Defragmenting a piece requires at least 2 x TES free file system contiguous
blocks. In case TES is set too big, the defragmentation could fail to allocate
that many contiguous file system blocks. By default it’s 64 blocks.

Piece Size
This is a configuration value indicating the size of the piece in blocks, a piece
is no larger than this size. Defragmenting a piece requires up to PS free
filesystem contiguous blocks. In case PS is set too big, the defragmentation could
fail to allocate that many contiguous file system blocks. 4096 blocks by default,
and 4096 blocks as maximum.

Error reporting
When the defragmentation fails (usually due to file system block allocation
failure), the error will return to user application when the application fetches
the defragmentation status.

Idle Time
Idle time is a configuration value, it is the time defragmentation would idle
between defragmenting two adjacent pieces. We have no limitation on IT.

Some test result:
50GiB file with 2013990 extents, average 6.5 blocks per extent.
Relink copy used 40s (then reflink copy removed before following tests)
Use above as block device in VM, creating XFS v5 on that VM block device.
Mount and build kernel from VM (buffered writes + fsync to backed image file) without defrag:   13m39.497s
Kernel build from VM (buffered writes + sync) with defrag (target extent = 256,
piece size = 4096, idle time = 1000 ms):   15m1.183s
Defrag used: 123m27.354s

Wengang Wang (9):
  xfs: defrag: introduce strucutures and numbers.
  xfs: defrag: initialization and cleanup
  xfs: defrag implement stop/suspend/resume/status
  xfs: defrag: allocate/cleanup defragmentation
  xfs: defrag: process some cases in xfs_defrag_process
  xfs: defrag: piece picking up
  xfs: defrag: guarantee contigurous blocks in cow fork
  xfs: defrag: copy data from old blocks to new blocks
  xfs: defrag: map new blocks

 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/xfs_bmap_util.c |    2 +-
 fs/xfs/xfs_defrag.c    | 1074 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_defrag.h    |   11 +
 fs/xfs/xfs_inode.c     |    4 +
 fs/xfs/xfs_inode.h     |    1 +
 fs/xfs/xfs_ioctl.c     |   17 +
 fs/xfs/xfs_iomap.c     |    2 +-
 fs/xfs/xfs_mount.c     |    3 +
 fs/xfs/xfs_mount.h     |   37 ++
 fs/xfs/xfs_reflink.c   |    7 +-
 fs/xfs/xfs_reflink.h   |    3 +-
 fs/xfs/xfs_super.c     |    3 +
 include/linux/fs.h     |    5 +
 15 files changed, 1165 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/xfs_defrag.c
 create mode 100644 fs/xfs/xfs_defrag.h

-- 
2.39.3 (Apple Git-145)

