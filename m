Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17JZhgs256833
	for <linux-xfs@oss.sgi.com>; Tue, 7 Feb 2012 13:35:44 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id d954bQCgFQ40fMmG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 11:35:41 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RuqpF-0003KV-Mj
	for linux-xfs@oss.sgi.com; Tue, 07 Feb 2012 20:35:37 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.64])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 07 Feb 2012 20:35:37 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 07 Feb 2012 20:35:37 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: xfs_repair, xfs_metadump trouble with fs
Date: Tue, 07 Feb 2012 11:33:11 -0800
Message-ID: <nsa809x68g.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hi XFS list,

I'm having some strange trouble with xfs_repair and xfs_metadump, which
I am hoping you can help with.  I have an xfs filesystem which is backed
by an mdraid/LVM combination.  Recently two drives failed in the RAID6,
then during the rebuild another disk failed.  I was able to salvage the
array by using ddrescue to copy the failed drive to a new drive (only
8k were lost).  Once I did that, I turned to xfs_repair to check that
the filesystem was okay.

So far, it has reported a large number of errors, but consistently gets
stuck during phase 3.  I have used xfsprogs 3.1.7 as well as the latest
clone from git, and have also used -P and not used -P, with no luck.  I
have saved stderr, but it is extremely large.  Nothing obvious
distinguishes the last stderr messages from previous messages, where it
might indicate why xfs_repair has stalled.  (I can post stderr or make
it available by HTTP if it helps.)

Next, I tried to take an xfs_metadump, as suggested by the man page.
2.9.4 reported a glibc error and got stuck, so I tried the latest
version, and got this (a few messages from xfs_metadump before the
error):

Copied 4653824 of 28351936 inodes (0 of 65 AGs)
xfs_metadump: badly aligned inode (start = 10366393)
Copied 4654656 of 28351936 inodes (0 of 65 AGs)
xfs_metadump: bad number of extents 189 in inode 10383406
xfs_metadump: bad number of extents 2003136628 in inode 10383425
Copied 4654912 of 28351936 inodes (0 of 65 AGs)
xfs_metadump: invalid size (139315) in symlink inode 10362975
Copied 4654976 of 28351936 inodes (0 of 65 AGs)            *** glibc detected *** /root/xfsprogs-dev/db/xfs_db: free(): invalid next size (normal): 0x0000000000a1c000 ***
======= Backtrace: =========
/lib64/libc.so.6[0x7f36324d245f]
/lib64/libc.so.6(cfree+0x4b)[0x7f36324d28bb]
/root/xfsprogs-dev/db/xfs_db[0x419a93]
/root/xfsprogs-dev/db/xfs_db[0x41d6a3]
/root/xfsprogs-dev/db/xfs_db[0x41b182]
/root/xfsprogs-dev/db/xfs_db[0x41d772]
/root/xfsprogs-dev/db/xfs_db[0x41b182]
/root/xfsprogs-dev/db/xfs_db[0x41d466]
/root/xfsprogs-dev/db/xfs_db[0x417ee8]
/lib64/libc.so.6(__libc_start_main+0xf4)[0x7f363247d994]
/root/xfsprogs-dev/db/xfs_db[0x402519]
======= Memory map: ========
00400000-00473000 r-xp 00000000 08:02 97846 /root/xfsprogs-dev/db/xfs_db
00673000-00674000 rw-p 00073000 08:02 97846 /root/xfsprogs-dev/db/xfs_db
00674000-00687000 rw-p 00000000 00:00 0
009e8000-01120000 rw-p 00000000 00:00 0 [heap]
3a91a00000-3a91a04000 r-xp 00000000 08:02 384575 /lib64/libuuid.so.1.2
3a91a04000-3a91c03000 ---p 00004000 08:02 384575 /lib64/libuuid.so.1.2
3a91c03000-3a91c04000 rw-p 00003000 08:02 384575 /lib64/libuuid.so.1.2
3a91e00000-3a91e0d000 r-xp 00000000 08:02 384716 /lib64/libgcc_s-4.1.2-20080825.so.1
3a91e0d000-3a9200d000 ---p 0000d000 08:02 384716 /lib64/libgcc_s-4.1.2-20080825.so.1
3a9200d000-3a9200e000 rw-p 0000d000 08:02 384716 /lib64/libgcc_s-4.1.2-20080825.so.1
7f362ee86000-7f3632460000 r--p 00000000 fd:01 1351115 /usr/lib/locale/locale-archive
7f3632460000-7f36325ae000 r-xp 00000000 08:02 384393 /lib64/libc-2.5.so
7f36325ae000-7f36327ae000 ---p 0014e000 08:02 384393 /lib64/libc-2.5.so
7f36327ae000-7f36327b2000 r--p 0014e000 08:02 384393 /lib64/libc-2.5.so
7f36327b2000-7f36327b3000 rw-p 00152000 08:02 384393 /lib64/libc-2.5.so
7f36327b3000-7f36327b8000 rw-p 00000000 00:00 0
7f36327b8000-7f36327ce000 r-xp 00000000 08:02 384418 /lib64/libpthread-2.5.so
7f36327ce000-7f36329cd000 ---p 00016000 08:02 384418 /lib64/libpthread-2.5.so
7f36329cd000-7f36329ce000 r--p 00015000 08:02 384418 /lib64/libpthread-2.5.so
7f36329ce000-7f36329cf000 rw-p 00016000 08:02 384418 /lib64/libpthread-2.5.so
7f36329cf000-7f36329d3000 rw-p 00000000 00:00 0
7f36329d3000-7f36329da000 r-xp 00000000 08:02 384422 /lib64/librt-2.5.so
7f36329da000-7f3632bda000 ---p 00007000 08:02 384422 /lib64/librt-2.5.so
7f3632bda000-7f3632bdb000 r--p 00007000 08:02 384422 /lib64/librt-2.5.so
7f3632bdb000-7f3632bdc000 rw-p 00008000 08:02 384422 /lib64/librt-2.5.so
7f3632bdc000-7f3632bf8000 r-xp 00000000 08:02 448663 /lib64/ld-2.5.so
7f3632da0000-7f3632de4000 rw-p 00000000 00:00 0
7f3632df4000-7f3632df8000 rw-p 00000000 00:00 0
7f3632df8000-7f3632df9000 r--p 0001c000 08:02 448663 /lib64/ld-2.5.so
7f3632df9000-7f3632dfa000 rw-p 0001d000 08:02 448663 /lib64/ld-2.5.so
7fffbe85e000-7fffbe87f000 rw-p 00000000 00:00 0 [stack]
7fffbe899000-7fffbe89a000 r-xp 00000000 00:00 0 [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0 [vsyscall]
./xfsprogs-dev/db/xfs_metadump.sh: line 31: 20422 Aborted
/root/xfsprogs-dev/db/xfs_db$DBOPTS -F -i -p xfs_metadump -c "metadump$OPTS $2" $1

Here's xfs_info on the filesystem as mounted:

# xfs_info /mnt/sonoran/
meta-data=/dev/sonoranVG/sonoranLV isize=256    agcount=65,
agsize=61034784 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=3906227200,
imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


Currently the filesystem is mountable, but I am fairly sure that there
are some errors.  This is a snapshot backup server, so I could simply
start over without too much pain, but it'd be nice to be able to recover
the work I've done if possible.  Alternatively, if I can at least have
xfs_repair finish, it might be possible to recreate the snapshot in less
time using the data that did survive.

If you need any more information please let me know.  Thanks!

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
