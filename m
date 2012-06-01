Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51Ixi5q170976 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 13:59:44 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7F7030408A
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 11:59:40 -0700 (PDT)
Received: from arenaud-laptop (cf-vpn-hw-arenaud-1.corp.sgi.com [134.15.95.98])
	by estes.americas.sgi.com (Postfix) with ESMTP id AE01A7001DD1
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 13:59:40 -0500 (CDT)
Message-Id: <20120601185815.883227033@sgi.com>
Date: Fri, 01 Jun 2012 14:58:15 -0400
From: Alain Renaud <arenaud@sgi.com>
Subject: [PATCH 0/1] xfstest: using extsize cause corruption with multi buffer
	page
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi all,

  I just found a problem which cause file corruption with filesystem that 
have block size smaller then the page size. The problem occur when
using extsize on file and having multiple extents in the same PAGE.

The scenario that I am looking at is a page that look like this:
buffer  content
0       empty  b_state = 0
1       DATA   b_state = 0x1023
2       DATA   b_state = 0x1023
3       empty  b_state = 0
4       empty  b_state = 0
5       DATA   b_state = 0x1023
6       DATA   b_state = 0x1023
7       empty  b_state = 0

At the end the extent should look like this

0   : unwritten extent.
1-2 : real extent
3-4 : unwritten extent.
5-6 : real extent.
7-EOF : unwritten extent.

However the current version of xfs_vm_writepage() will put all the buffer in 
the page into 1 ioend which cause the extent list to look like this.

0   : unwritten extent.
1-4 : real extent
5-EOF : unwritten extent.

The test generate a 'template' file which is created
without using extsize look like this.

# xfs_bmap -vp /xfsqa_scratch/testdir/template 
/xfsqa_scratch/testdir/template:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..8]:          hole                                     9
   1: [9..23]:         48..62            0 (48..62)            15 00000
# hexdump  /xfsqa_scratch/testdir/template
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0001200 4242 4242 4242 4242 4242 4242 4242 4242
*
0001600 0000 0000 0000 0000 0000 0000 0000 0000
*
0001a00 4343 4343 4343 4343 4343 4343 4343 4343
*
0001e00 0000 0000 0000 0000 0000 0000 0000 0000
*
0003000

The test file which is created with 'extsize == 10 pages' give us
this result.
(notice block 13-12 are unwritten but should contain the 'C')

# xfs_bmap -vp /xfsqa_scratch/testdir/zfile-00 
/xfsqa_scratch/testdir/zfile-00:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..8]:          167..175          0 (167..175)           9 10000
   1: [9..12]:         176..179          0 (176..179)           4 00000
   2: [13..23]:        180..190          0 (180..190)          11 10000
# hexdump  /xfsqa_scratch/testdir/zfile-00 
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0001200 4242 4242 4242 4242 4242 4242 4242 4242
*
0001600 0691 3c24 d01f 3de9 0597 3e65 b312 3ebf
*
0003000

Looking at the xfs_db output I know that the data get correctly written
to disk but the coversion from unwritten to real seem broken. I have
Isolated the problem to the fact that all buffer in the page are put
into a single xfs_ioend instead of 2. I will propose a fix in a separate
patch. This test is only to show the problem

-- 
===============================================
Alain Renaud     - Cluster File System Engineer 
arenaud@sgi.com  - SGI
===============================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
