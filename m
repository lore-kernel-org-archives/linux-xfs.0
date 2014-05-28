Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5807E7F57
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:40:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F1938F807A
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:40:48 -0700 (PDT)
Received: from mail-pa0-f45.google.com (mail-pa0-f45.google.com
	[209.85.220.45]) by cuda.sgi.com with ESMTP id 6zdbhjCxjOvPqXUX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 23:40:46 -0700 (PDT)
Received: by mail-pa0-f45.google.com with SMTP id ey11so10478605pad.18
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:40:46 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 28 May 2014 08:40:46 +0200
Message-ID: <CACyNnZM7o2Sqzt+ygThJn=ibWsy+eUVLJ9d1+03kjVXW=t-b3Q@mail.gmail.com>
Subject: Finding the pointer array in XFS_DINODE_FMT_BTREE inodes
From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
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

Hello,

I am writing an application which reads XFS partitions, so I am trying
to understand the internal working of XFS. I read the documentation.

But there is one issue which I cannot figure out. In an inode which is
a directory with data format XFS_DINODE_FMT_BTREE I see that the first
structure is the 4-byte header, which in my case has these values:

  xfs_bmdr_block = packed record
    bb_level = 1;       // 0 is a leaf */
    bb_numrecs = 1;     // current # of data records */

And after that I get the key array as expected. But after the key
array there is a lot of empty space, $40 bytes of empty space to be
exact, enough for 8 more keys, even while my inode has "bb_numrecs =
1" and only after that empty space I get the pointers array.

My current "guess" is that the key array has at least 9 elements in
it, being that only bb_numrecs are valid, but I'd prefer to know what
is going on instead of doing random guesses =D So my question is:

How can I know the start point of the pointer array? In this case it
starts at offset $B0 from the inode start while I would expect $70
(just after the key array)

Please see my xfs_db values bellow:

xfs_db> inode 1067904
xfs_db> print
core.magic = 0x494e
core.mode = 040755
core.version = 2
core.format = 3 (btree)
core.nlinkv2 = 2
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 1
core.atime.sec = Mon Dec 30 09:40:08 2013
core.atime.nsec = 000000000
core.mtime.sec = Mon Dec 30 09:40:08 2013
core.mtime.nsec = 000000000
core.ctime.sec = Sat May  3 14:55:10 2014
core.ctime.nsec = 657000000
core.size = 323584
core.nblocks = 116
core.extsize = 0
core.nextents = 82
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 247601121
next_unlinked = null
u.bmbt.level = 1
u.bmbt.numrecs = 1
u.bmbt.keys[1] = [startoff] 1:[0]
u.bmbt.ptrs[1] = 1:66821
xfs_db> type text
xfs_db> p
00:  49 4e 41 ed 02 03 00 00 00 00 00 00 00 00 00 00  INA.............
10:  00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01  ................
20:  52 c1 31 68 00 00 00 00 52 c1 31 68 00 00 00 00  R.1h....R.1h....
30:  53 64 e7 2e 27 29 06 40 00 00 00 00 00 04 f0 00  Sd..............
40:  00 00 00 00 00 00 00 74 00 00 00 00 00 00 00 52  .......t.......R
50:  00 00 00 02 00 00 00 00 00 00 00 00 0e c2 17 e1  ................

Here I get the terminator FF FF FF FF, then the 4 byte header then the key value

60:  ff ff ff ff 00 01 00 01 00 00 00 00 00 00 00 00  ................

Unexpected empty space!?!?

70:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
80:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
90:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
a0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

Here starts the pointer array:

b0:  00 00 00 00 00 01 05 05 00 00 00 00 00 00 00 00  ................
c0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

Just for reference purposes, someone has already asked this same
question many years ago somewhere, but he never got any answer =D

http://permalink.gmane.org/gmane.comp.file-systems.xfs.general/15285

thanks,
-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
