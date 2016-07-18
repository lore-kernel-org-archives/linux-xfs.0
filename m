Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C3517CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:25:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3EAA30404E
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 04:25:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P3QXXeF0sQrYHj35 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 04:25:46 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id F071AF2631
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 11:25:45 +0000 (UTC)
Received: from localhost (dhcp-12-123.nay.redhat.com [10.66.12.123])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6IBPiQe011505
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 07:25:45 -0400
Date: Mon, 18 Jul 2016 19:25:44 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Metadata corruption detected at xfs_agf block
Message-ID: <20160718112544.GF27776@eguan.usersys.redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I hit metadata corruption reported by xfs_repair after running fsstress
on the test XFS.

# xfs_repair -n /dev/mapper/testvg-testlv
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
Metadata corruption detected at xfs_agf block 0x59fa001/0x200
flfirst 118 in agf 3 too large (max = 118)
agf 118 freelist blocks bad, skipping freelist scan
sb_fdblocks 15716842, counted 15716838
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 0
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

Kernel is 4.7-rc7, xfsprogs is v4.3.0 (v4.5.0/v4.7-rc1 reported no
corruption, I think that's because of commit 96f859d ("libxfs: pack the
agfl header structure so XFS_AGFL_SIZE is correct"))

This is similar to this thread:

new fs, xfs_admin new label, metadata corruption detected
http://oss.sgi.com/archives/xfs/2016-03/msg00297.html

which ended up a new patch in growfs code, commit ad747e3b2996 ("xfs:
Don't wrap growfs AGFL indexes"), so I think I'd better report this
similar issue anyway, though I'm not sure if it's really a bug.

It's not reproducible everytime, but I can reproduce it in a loop run

i=0; ret=0
mkfs -t xfs -f /dev/mapper/testvg-testlv
while [ $i -lt 10 -a $ret -eq 0 ]; do
	mount /dev/mapper/testvg-testlv /mnt/xfs
	fsstress -d /mnt/xfs -n 1000 -p 1000
	umount /mnt/xfs
	xfs_repair -n /dev/mapper/testvg-testlv
	ret=$?
	((i++))
done

mkfs.xfs output
meta-data=/dev/mapper/testvg-testlv isize=512    agcount=4, agsize=3931136 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=15724544, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=7678, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

lvm info
[root@bootp-73-5-205 ~]# pvs
  PV         VG     Fmt  Attr PSize  PFree
  /dev/vda10 testvg lvm2 a--  15.00g    0 
  /dev/vda7  testvg lvm2 a--  15.00g    0 
  /dev/vda8  testvg lvm2 a--  15.00g    0 
  /dev/vda9  testvg lvm2 a--  15.00g    0 
[root@bootp-73-5-205 ~]# vgs
  VG     #PV #LV #SN Attr   VSize  VFree
  testvg   4   1   0 wz--n- 59.98g    0 
[root@bootp-73-5-205 ~]# lvs
  LV     VG     Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  testlv testvg -wi-a----- 59.98g

host info (x86_64 kvm guest running on RHEL6 host)
[root@bootp-73-5-205 ~]# uname -a
Linux localhost.localdomain 4.7.0-rc7 #21 SMP Fri Jul 15 12:50:03 CST 2016 x86_64 x86_64 x86_64 GNU/Linux
[root@bootp-73-5-205 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:           7983         113        5569           8        2299        7577
Swap:          8191           0        8191
[root@bootp-73-5-205 ~]# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
Thread(s) per core:    1
Core(s) per socket:    1
Socket(s):             4
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 13
Model name:            QEMU Virtual CPU version (cpu64-rhel6)
Stepping:              3
CPU MHz:               2892.748
BogoMIPS:              5785.49
Hypervisor vendor:     KVM
Virtualization type:   full
L1d cache:             32K
L1i cache:             32K
L2 cache:              4096K
NUMA node0 CPU(s):     0-3

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
