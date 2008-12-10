Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBAADuwe030555 for <xfs@oss.sgi.com>; Wed, 10 Dec 2008 04:13:59 -0600
Received: from ob3.cmich.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CA5780F6
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2008 02:13:55 -0800 (PST)
Received: from ob3.cmich.edu (ob3.cmich.edu [141.209.20.10]) by cuda.sgi.com
	with ESMTP id vz4yUyFSrR5HYE1U for <xfs@oss.sgi.com>;
	Wed, 10 Dec 2008 02:13:55 -0800 (PST)
Received: from mail.cps.cmich.edu (cps1.cps.cmich.edu [141.209.168.41])
	by ob3.cmich.edu (8.13.8/8.13.8/Debian-3) with ESMTP id mBAADrn3027494
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2008 05:13:54 -0500
Received: from mail.canal.cps.cmich.edu (cps-io [141.209.169.66])
	by mail.cps.cmich.edu (Postfix) with ESMTP id B76CA25613F
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2008 05:13:53 -0500 (EST)
Message-ID: <493F9661.20603@canal.cps.cmich.edu>
Date: Wed, 10 Dec 2008 05:13:53 -0500
From: Martin Murray <murrayma@canal.cps.cmich.edu>
MIME-Version: 1.0
Subject: repaired xfs corruption causing invalid directories?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

	I've got a ~3TB xfs filesystem build on an md raid5 of four 1TB drives. 
Ignoring a long, embarrassing story, I accidentally nuked the first 32 odd 
megabytes of the partition with dd. xfs_repair was able to recover almost 
everything. Unsurprisingly, I must have zero'd out a number of directory 
entries, as, suddenly, everything appeared in lost+found. We've been 
identifying, renaming, and moving entries in lost+found back to their 
original places, but have encountered something strange. I'm hoping someone 
can give me some advice.

	I do realize that my problem is due to operator error, but I'm hoping 
someone has a suggestion.

	Recently, after a reboot, doing an ls -li, as root, on the filesystem gives 
the following:

ls: cannot access debian: Invalid argument
ls: cannot access Documentation: Invalid argument
6988868050 ???????????    ? ?      ?               ?                ? debian
13645710122 ???????????    ? ?      ?               ?                ? 
Documentation
1073742080 drwxr-xr-x+    2 nobody nogroup        35 2008-11-03 20:20 temp/
  536872760 drwxrwsrw-+   51 nobody nogroup      4096 2008-11-01 06:20 
TigerLineData/
3221230395 drwsrwsrwx+   23 nobody nogroup      8192 2008-12-09 22:52 Win32/

	For brevity, I've omitted most of the working subdirectories. The strange 
part is that some of these directories, for example, the debian one, was 
created after the xfs_repair. Also, I cannot remove files in the directories 
nor even the directories themselves. I tried doing an xfsdump over the net 
to another machine and noticed screenfulls of errors similar to:

xfsdump: WARNING: unable to open directory: ino 4296482141: Invalid argument
xfsdump: WARNING: unable to open directory: ino 4296482142: Invalid argument
xfsdump: WARNING: unable to open directory: ino 4296482150: Invalid argument
...
xfsdump: WARNING: unable to open directory: ino 16796385598: Invalid argument
xfsdump: WARNING: unable to open directory: ino 16797367298: Invalid argument
xfsdump: WARNING: unable to open directory: ino 16797367299: Invalid argument

	The xfsdump is still running. I hope to backup the still-reachable data 
before addressing these invalid directories. Right before I did the xfsdump, 
however, I ran xfs_db and printed out one of the invalid directories:

xfs_db> inode 6988868050
xfs_db> print
core.magic = 0x494e
core.mode = 040755
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 5
core.onlink = 0
core.projid = 0
core.uid = 65534
core.gid = 65534
core.flushiter = 7
core.atime.sec = Sat Nov  8 00:50:05 2008
core.atime.nsec = 694489000
core.mtime.sec = Thu Oct 30 07:38:40 2008
core.mtime.nsec = 000000000
core.ctime.sec = Sat Nov  8 05:05:42 2008
core.ctime.nsec = 589799654
core.size = 4096
core.nblocks = 1
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 11
core.aformat = 1 (local)
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
core.gen = 3924941202
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,436805271,1,0]
a.sfattr.hdr.totsize = 62
a.sfattr.hdr.count = 1
a.sfattr.list[0].namelen = 15
a.sfattr.list[0].valuelen = 40
a.sfattr.list[0].root = 1
a.sfattr.list[0].secure = 0
a.sfattr.list[0].name = "SGI_ACL_DEFAULT"
a.sfattr.list[0].value = 
"\000\000\000\003\000\000\000\001\377\377\377\377\000\a\000\000\000\000\000\004\377\377\377\377\000\005\000\000\000\000\000 
\377\377\377\377\000\a\000\000"

	Lastly, here is a copy of the xfs_info for the filesystem:

meta-data=/dev/md0               isize=256    agcount=32, agsize=22892816 blks
          =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=732569856, imaxpct=5
          =                       sunit=16     swidth=48 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=196608 blocks=0, rtextents=0

	I've started reading the XFS filesystem structure PDF, but I cannot yet 
infer which field in the block would cause the invalid argument error. The 
one thing I've noticed so far, is that it appears that all the invalid 
directories are the extent format.

	Oh, I can provide an xfs_metadump as soon as the xfsdump finishes.

Thank you, Martin Murray

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
