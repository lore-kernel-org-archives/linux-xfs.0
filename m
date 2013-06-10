Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2547E7F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 08:13:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDC45304039
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 06:13:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wHeZBS7gzBMdC07G for
	<xfs@oss.sgi.com>; Mon, 10 Jun 2013 06:13:48 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5ADDlGT013852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 09:13:47 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r5ADDlLU023666
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 09:13:47 -0400
Message-ID: <51B5D1EB.9080200@redhat.com>
Date: Mon, 10 Jun 2013 09:17:31 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: fsx failure on 3.10.0-rc1+ (xfstests 263) -- Mapped Read: non-zero
	data past EOF
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

Hi guys,

I wanted to get this onto the list... I suspect this could be
similar/related to the issue reported here:

http://oss.sgi.com/archives/xfs/2013-06/msg00066.html

While running xfstests, the only apparent regression I hit from 3.9.0
was generic/263. This test fails due to the following command (and
resulting output):

# fsx -N 10000 -o 128000 -l 500000 -r 4096 -t 512 -w 512 -Z /mnt/junk
truncating to largest ever: 0x12a00
truncating to largest ever: 0x75400
fallocating to largest ever: 0x7a120
Mapped Read: non-zero data past EOF (0x79dff) page offset 0xe00 is 0xe927
	offset = 0x78000, size = 0x1220
LOG DUMP (7966 total operations):
...
7959( 23 mod 256): TRUNCATE DOWN	from 0x2d200 to 0x1e200
7960( 24 mod 256): MAPWRITE 0x54800 thru 0x655e7	(0x10de8 bytes)
7961( 25 mod 256): FALLOC   0x448b4 thru 0x5835d	(0x13aa9 bytes) INTERIOR
7962( 26 mod 256): WRITE    0x8200 thru 0xb7ff	(0x3600 bytes)
7963( 27 mod 256): READ     0x61000 thru 0x64fff	(0x4000 bytes)
7964( 28 mod 256): MAPREAD  0x6000 thru 0xe5fe	(0x85ff bytes)
7965( 29 mod 256): WRITE    0x6ca00 thru 0x79dff	(0xd400 bytes) HOLE
7966( 30 mod 256): MAPREAD  0x78000 thru 0x7921f	(0x1220 bytes)
Correct content saved for comparison
(maybe hexdump "/mnt/junk" vs "/mnt/junk.fsxgood")

So if I'm following that correctly, we truncate the file down to
0x1e200, extend it with an mmap write to 0x655e7, do a couple internal
reads/writes, extend to 0x79dff with a direct write and hit stale data
on an mmap read at eof.

Post-mortem on the file:

# stat /mnt/junk
  File: `/mnt/junk'
  Size: 499200    	Blocks: 704        IO Block: 4096   regular file
Device: fd02h/64770d	Inode: 131         Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2013-06-05 11:04:04.968000000 -0400
Modify: 2013-06-05 11:04:04.967000000 -0400
Change: 2013-06-05 11:04:04.967000000 -0400
 Birth: -

# xfs_bmap -v /mnt/junk
junk:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..31]:         96..127           0 (96..127)           32
   1: [32..127]:       256..351          0 (256..351)          96
   2: [128..223]:      896..991          0 (896..991)          96
   3: [224..543]:      hole                                   320
   4: [544..1023]:     1312..1791        0 (1312..1791)       480 10000

I ran a bisect between tot and 3.9 and narrowed down to:

e114b5fc xfs: increase prealloc size to double that of the previous extent

... though IIRC, this was an additive fix on top of the recent sparse
speculative prealloc updates, so it might not be much more than a data
point:

a1e16c26 xfs: limit speculative prealloc size on sparse files

This is interesting from a release perspective in that the latter change
is included in 3.9 and the former fix is not. Therefore, I went back to
3.8 and found I can reproduce it there as well. FWIW, I can also
reproduce this on tot with allocsize=131072 (though it appears to be
intermittent) and on 3.8 under similar circumstances (w/ speculative
prealloc or allocsize >= 131072). Given all that, my speculation at this
point is that the more recent prealloc changes probably don't introduce
the core issue, but rather alter the behavior enough to determine
whether this test case triggers it.

Brian

P.S., I also came across the following thread which, if related,
suggests this might be known/understood to a degree:

http://oss.sgi.com/archives/xfs/2012-04/msg00703.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
