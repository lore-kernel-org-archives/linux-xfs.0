Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27Fselh110256 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 09:54:40 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id E1hQSnQ4safGJ3FF for
	<xfs@oss.sgi.com>; Wed, 07 Mar 2012 07:54:39 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 6F3B97FE2
	for <xfs@oss.sgi.com>; Wed,  7 Mar 2012 10:54:38 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 64E127FD9
	for <xfs@oss.sgi.com>; Wed,  7 Mar 2012 10:54:38 -0500 (EST)
Received: from Brians-MacBook-Air.local (unknown [217.206.150.147]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	E5D8C7FD8 for
	<xfs@oss.sgi.com>; Wed,  7 Mar 2012 10:54:37 -0500 (EST)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id M0IUV3-000I17-RG for
	xfs@oss.sgi.com; Wed, 07 Mar 2012 15:54:39 +0000
Date: Wed, 7 Mar 2012 15:54:39 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: df bigger than ls?
Message-ID: <20120307155439.GA23360@nsrc.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I have created some files spread across 12 XFS filesystems, using a
glusterfs "striped" volume.  This writes files with lots of holes(*) - so I
would expect the space reported by 'du' to be less than the space reported
by 'ls'.

However it's the other way round - du is reporting more space used than ls! 
Here's what I mean:  I'm looking at the files directly on the underlying
disk mount point, not via glusterfs at all.

$ ls -lh /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
-rw-rw-r-- 1 brian brian 1.1G 2012-03-07 15:19 /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
$ ls -lk /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
-rw-rw-r-- 1 brian brian 1059968 2012-03-07 15:19 /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
$ du -h /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2.0G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
$ du -k /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
2096392	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff

And here's what xfs_bmap reports:

root@storage1:~# xfs_bmap -vp /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff:
 EXT: FILE-OFFSET         BLOCK-RANGE            AG AG-OFFSET              TOTAL FLAGS
   0: [0..255]:           2933325744..2933325999  2 (3059152..3059407)       256 00000
   1: [256..3071]:        hole                                              2816
   2: [3072..3327]:       2933326000..2933326255  2 (3059408..3059663)       256 00000
   3: [3328..6143]:       hole                                              2816
   4: [6144..8191]:       2933326472..2933328519  2 (3059880..3061927)      2048 00000
   5: [8192..9215]:       hole                                              1024
   6: [9216..13311]:      2933369480..2933373575  2 (3102888..3106983)      4096 00000
   7: [13312..15359]:     hole                                              2048
   8: [15360..23551]:     2933375624..2933383815  2 (3109032..3117223)      8192 00000
   9: [23552..24575]:     hole                                              1024
  10: [24576..40959]:     2933587168..2933603551  2 (3320576..3336959)     16384 00000
  11: [40960..43007]:     hole                                              2048
  12: [43008..75775]:     2933623008..2933655775  2 (3356416..3389183)     32768 00000
  13: [75776..76799]:     hole                                              1024
  14: [76800..142335]:    2933656800..2933722335  2 (3390208..3455743)     65536 00000
  15: [142336..144383]:   hole                                              2048
  16: [144384..275455]:   2933724384..2933855455  2 (3457792..3588863)    131072 00000
  17: [275456..276479]:   hole                                              1024
  18: [276480..538623]:   2935019808..2935281951  2 (4753216..5015359)    262144 00000
  19: [538624..540671]:   hole                                              2048
  20: [540672..1064959]:  2935284000..2935808287  2 (5017408..5541695)    524288 00000
  21: [1064960..1065983]: hole                                              1024
  22: [1065984..2114559]: 2935809312..2936857887  2 (5542720..6591295)   1048576 00000
  23: [2114560..2116607]: hole                                              2048
  24: [2116608..2119935]: 2943037984..2943041311  2 (12771392..12774719)    3328 00000
root@storage1:~# 

Given that these values are all in 512-byte disk blocks, the total file size
is (2119935 + 1) * 512 which agrees with ls. And some proportion of it
is holes, so du should report less than this, shouldn't it?

(Aside: it starts off being 11/12th holes as expected, but after a while
isn't.  This may be a different bug, possibly in glusterfs itself)

I guess 'du' gets its info from stat(), and stat() also says the file is
using 4192784 blocks which is 2096392 KB:

$ stat /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
  File: `/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff'
  Size: 1085407232	Blocks: 4192784    IO Block: 4096   regular file
Device: 810h/2064d	Inode: 8595657903  Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/   brian)   Gid: ( 1000/   brian)
Access: 2012-03-07 15:20:36.044365215 +0000
Modify: 2012-03-07 15:19:33.640364277 +0000
Change: 2012-03-07 15:19:33.640364277 +0000

Finally, here is xfs_db dump of the inode:

# ls -i /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
8595657903 /disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
...
xfs_db> inode 8595657903
xfs_db> p
core.magic = 0x494e
core.mode = 0100664
core.version = 2
core.format = 3 (btree)
core.nlinkv2 = 1
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 1000
core.gid = 1000
core.flushiter = 231
core.atime.sec = Wed Mar  7 15:20:36 2012
core.atime.nsec = 044365215
core.mtime.sec = Wed Mar  7 15:19:33 2012
core.mtime.nsec = 640364277
core.ctime.sec = Wed Mar  7 15:19:33 2012
core.ctime.nsec = 640364277
core.size = 1085407232
core.nblocks = 262370
core.extsize = 0
core.nextents = 13
core.naextents = 1
core.forkoff = 15
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
core.gen = 1875303423
next_unlinked = null
u.bmbt.level = 1
u.bmbt.numrecs = 1
u.bmbt.keys[1] = [startoff] 1:[0]
u.bmbt.ptrs[1] = 1:537294687
a.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,537253238,1,0]
xfs_db> 

Platform: ubuntu 11.10
Linux 3.0.0-15-server #26-Ubuntu SMP Fri Jan 20 19:07:39 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Have I missed something obvious, or is there a bug of some sort here?

Regards,

Brian.

(*) http://gluster.org/community/documentation//index.php/GlusterFS_Technical_FAQ#Stripe_behavior_not_working_as_expected

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
