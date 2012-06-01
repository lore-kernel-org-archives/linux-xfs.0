Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51KvgGM177966 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 15:57:43 -0500
Received: from mxf4.bahnhof.se (mxf4.bahnhof.se [213.80.101.28]) by
	cuda.sgi.com with ESMTP id J4QU2w26rGT2pS5L for
	<xfs@oss.sgi.com>; Fri, 01 Jun 2012 13:57:39 -0700 (PDT)
Received: from localhost (mxf4.local [127.0.0.1])
	by mxf4-reinject (Postfix) with ESMTP id 55B395F9A57
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 22:57:39 +0200 (CEST)
Received: from mxf4.bahnhof.se ([127.0.0.1])
	by localhost (mxf4.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1+Ri-zbaxzLg for <xfs@oss.sgi.com>;
	Fri,  1 Jun 2012 22:57:33 +0200 (CEST)
Received: from mx.ifconfig.se (h-73-232.a146.priv.bahnhof.se [94.254.73.232])
	by mxf4.bahnhof.se (Postfix) with ESMTP id 871865F9A43
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 22:57:33 +0200 (CEST)
Message-ID: <4FC92CB3.7080508@ifconfig.se>
Date: Fri, 01 Jun 2012 22:57:23 +0200
From: Jesper Wallin <jesper@ifconfig.se>
MIME-Version: 1.0
Subject: *** buffer overflow detected ***: xfs_repair terminated
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Hi, I'm new to this list so I apologize in advance if this is the wrong 
place to report/ask this.

I'm trying to recover the data of a crashes NAS server (some NAS based 
on a Intel SS4000-E thingie) .. The setup was 4 disks (1 spare and 3 
active) in raid5 and all of a sudden the NAS refused access even if all 
disks were marked as "ok". I removed the 3 active disks and plugged them 
into a regular desktop computer. I then assembled the raid using mdadm 
which resulted md0p1 and md0p2.. md0p1 was only ~8MB and md0p2 roughly 
990GB, both listed as "Linux plaintext" partitions and mount didn't let 
me mount either.

I used dd to copy the data from md0p1 to a regular file and opened it 
with vim. In there, I found a lot of XML data telling me which volumes 
existed and at what offset it starts. I then used losetup to create a 
loop-device with the offset provided from md0p1. This finally allowed me 
to mount the partition as a XFS disk.

Now to the "interesting" part, I noticed some warnings in dmesg which 
told me to unmount it and run xfs_repair on it. Here I decided to copy 
the entire raid volume (md0) to a new disk to make sure we don't damage 
anything. After 10 hours of dd'ing to a USB disk (and to make it worse, 
formatted with NTFS :P) I decided to give xfs_repair a try but in Phase 
3 it crashes. (see: http://www.nohack.se/dump.txt)

I noticed the live-cd came with xfsprogs 3.1.7 and manually compiled 
3.1.8 to give it a try, but without luck.

-- backtrace --
(gdb) bt
#0  0xb77bb424 in __kernel_vsyscall ()
#1  0xb76071ef in raise () from /lib/i386-linux-gnu/libc.so.6
#2  0xb760a835 in abort () from /lib/i386-linux-gnu/libc.so.6
#3  0xb76422fa in ?? () from /lib/i386-linux-gnu/libc.so.6
#4  0xb76d8dd5 in __fortify_fail () from /lib/i386-linux-gnu/libc.so.6
#5  0xb76d7baa in __chk_fail () from /lib/i386-linux-gnu/libc.so.6
#6  0x08062597 in memmove (__len=4294967295, __src=<optimized out>, 
__dest=0xbfd729ab) at /usr/include/i386-linux-gnu/bits/string3.h:58
#7  process_sf_dir2 (mp=0xbfd72f38, ino=<optimized out>, dip=0xb5533700, 
ino_discovery=1, dino_dirty=0xbfd72db8, parent=0xbfd72da8, 
repair=0xbfd72c00,
     dirname=<optimized out>) at dir2.c:1104
#8  0x0806352c in process_dir2 (mp=0xbfd72f38, ino=136564581, 
dip=0xb5533700, ino_discovery=1, dino_dirty=0xbfd72db8, 
dirname=0x80b9a31 "",
     parent=0xbfd72da8, blkmap=0x0) at dir2.c:2087
#9  0x0805a2d3 in process_dinode_int (mp=0xbfd72f38, dino=<optimized 
out>, agno=0, ino=2346853, was_free=0, dirty=0xbfd72db8, 
used=0xbfd72db4, verify_mode=0,
     uncertain=0, ino_discovery=1, check_dups=0, extra_attr_check=1, 
isa_dir=0xbfd72dbc, parent=0xbfd72da8) at dinode.c:2754
#10 0x08053133 in process_inode_chunk (mp=0xbfd72f38, agno=2, 
first_irec=0x5, ino_discovery=1, check_dups=0, extra_attr_check=1, 
bogus=0xbfd72e0c,
     num_inos=<optimized out>) at dino_chunks.c:769
#11 0x08054953 in process_aginodes (mp=0xbfd72f38, pf_args=0x913a600, 
agno=2, ino_discovery=1, check_dups=0, extra_attr_check=1) at 
dino_chunks.c:1008
#12 0x080688a6 in process_ag_func (wq=0x9122690, agno=2, arg=0x913a600) 
at phase3.c:77
#13 0x08068d2c in process_ags (mp=0xbfd72f38) at phase3.c:116
#14 phase3 (mp=0xbfd72f38) at phase3.c:155
#15 0x0804ab9a in main (argc=4, argv=0xbfd73274) at xfs_repair.c:747
(gdb)
-- backtrace --

If the core dump is required, I gladly share it in private if needed.


Regards,
Jesper Wallin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
