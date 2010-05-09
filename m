Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49NXCnf239450 for <xfs@oss.sgi.com>; Sun, 9 May 2010 18:33:13 -0500
Received: from mx05.kabsi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77CB312CFD0C
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 16:35:23 -0700 (PDT)
Received: from mx05.kabsi.at (mx05.kabsi.at [195.202.128.131]) by cuda.sgi.com
	with ESMTP id kuqLNikG77dPr77h for <xfs@oss.sgi.com>;
	Sun, 09 May 2010 16:35:23 -0700 (PDT)
Received: from 192.168.5.201 (h081217058120.dyn.cm.kabsi.at [81.217.58.120])
	by mx05.kabsi.at (8.13.8/8.13.8) with ESMTP id o49NZLsv002587
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 01:35:22 +0200
Date: Mon, 10 May 2010 01:35:11 +0200
From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Message-ID: <1743435018.20100510013511@kaneda.iguw.tuwien.ac.at>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
In-Reply-To: <1816344475.20100509204800@kaneda.iguw.tuwien.ac.at>
References: <1816344475.20100509204800@kaneda.iguw.tuwien.ac.at>
MIME-Version: 1.0
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


not sure if my original post made it to the list members since it
never arrived here, but it is already listed in the archive:
http://oss.sgi.com/pipermail/xfs/2010-May/045303.html

another update:
I restarted the server several times, always with the raid intact (no
syncing) and started to backup as much data as possible. in the last
hours the file system was heavily used (both read and write, about 2TB
copied to another SATA disk); during this time the error occured
a few times:

since raid is stable I suspect it is entirely an XFS (or hardware) problem?

find: ./Hana: Structure needs cleaning

00000000: aa b9 6a 52 fa 62 8c 36 17 19 b8 75 0f 2a 92 f5  =AA=B9jR=FAb.6..=
=B8u.*.=F5
Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2112 of file =
fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8834482e

Call Trace:
 [<ffffffff8834472d>] :xfs:xfs_da_do_buf+0x503/0x5b1
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff8020cb6c>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88346868>] :xfs:xfs_readdir+0xa7/0xb6
 [<ffffffff88373301>] :xfs:xfs_file_readdir+0xff/0x14c
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff802366f7>] vfs_readdir+0x77/0xa9
 [<ffffffff80239f2a>] sys_getdents+0x75/0xbd
 [<ffffffff80260295>] tracesys+0x47/0xb6
 [<ffffffff802602f9>] tracesys+0xab/0xb6

00000000: ea 4c ea e1 7a f1 2f 88 13 f9 a5 24 08 38 31 4e  =EAL=EA=E1z=F1/.=
.=F9=A5$.81N
Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2112 of file =
fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8834482e

Call Trace:
 [<ffffffff8834472d>] :xfs:xfs_da_do_buf+0x503/0x5b1
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff8020cb6c>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88346868>] :xfs:xfs_readdir+0xa7/0xb6
 [<ffffffff88373301>] :xfs:xfs_file_readdir+0xff/0x14c
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff802366f7>] vfs_readdir+0x77/0xa9
 [<ffffffff80239f2a>] sys_getdents+0x75/0xbd
 [<ffffffff80260295>] tracesys+0x47/0xb6
 [<ffffffff802602f9>] tracesys+0xab/0xb6

00000000: ea 4c ea e1 7a f1 2f 88 13 f9 a5 24 08 38 31 4e  =EAL=EA=E1z=F1/.=
.=F9=A5$.81N
Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2112 of file =
fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8834482e

Call Trace:
 [<ffffffff8834472d>] :xfs:xfs_da_do_buf+0x503/0x5b1
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff8020cb6c>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88346868>] :xfs:xfs_readdir+0xa7/0xb6
 [<ffffffff88373301>] :xfs:xfs_file_readdir+0xff/0x14c
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff802366f7>] vfs_readdir+0x77/0xa9
 [<ffffffff80239f2a>] sys_getdents+0x75/0xbd
 [<ffffffff80260295>] tracesys+0x47/0xb6
 [<ffffffff802602f9>] tracesys+0xab/0xb6

00000000: ea 4c ea e1 7a f1 2f 88 13 f9 a5 24 08 38 31 4e  =EAL=EA=E1z=F1/.=
.=F9=A5$.81N
Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2112 of file =
fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8834482e

Call Trace:
 [<ffffffff8834472d>] :xfs:xfs_da_do_buf+0x503/0x5b1
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff8020cb6c>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8834482e>] :xfs:xfs_da_read_buf+0x16/0x1b
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88349b0c>] :xfs:xfs_dir2_leaf_getdents+0x354/0x5ec
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88372c6c>] :xfs:xfs_hack_filldir+0x0/0x5b
 [<ffffffff88346868>] :xfs:xfs_readdir+0xa7/0xb6
 [<ffffffff88373301>] :xfs:xfs_file_readdir+0xff/0x14c
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff80225d93>] filldir+0x0/0xb7
 [<ffffffff802366f7>] vfs_readdir+0x77/0xa9
 [<ffffffff80239f2a>] sys_getdents+0x75/0xbd
 [<ffffffff80260295>] tracesys+0x47/0xb6
 [<ffffffff802602f9>] tracesys+0xab/0xb6

please advise.

tnx.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
