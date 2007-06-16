Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Jun 2007 12:56:30 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5GJuNWt015444
	for <xfs@oss.sgi.com>; Sat, 16 Jun 2007 12:56:26 -0700
Message-ID: <46744065.6060605@dgreaves.com>
Date: Sat, 16 Jun 2007 20:56:21 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: 2.6.22-rc4 XFS fails after hibernate/resume
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LVM general discussion and development <linux-lvm@redhat.com>
Cc: linux-pm <linux-pm@lists.osdl.org>

This isn't a regression.

I was seeing these problems on 2.6.21 (but 22 was in -rc so I waited to try it).
I tried 2.6.22-rc4 (with Tejun's patches) to see if it had improved - no.

Note this is a different (desktop) machine to that involved my recent bugs.

The machine will work for days (continually powered up) without a problem and 
then exhibits a filesystem failure within minutes of a resume.

I know xfs/raid are OK with hibernate. Is lvm?

The root filesystem is xfs on raid1 and that doesn't seem to have any problems.

System info:

/dev/mapper/video_vg-video_lv on /scratch type xfs (rw)

haze:~# vgdisplay
   --- Volume group ---
   VG Name               video_vg
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  19
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                1
   Open LV               1
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               372.61 GB
   PE Size               4.00 MB
   Total PE              95389
   Alloc PE / Size       95389 / 372.61 GB
   Free  PE / Size       0 / 0
   VG UUID               I2gW2x-aHcC-kqzs-Efpd-Q7TE-dkWf-KpHSO7

haze:~# pvdisplay
   --- Physical volume ---
   PV Name               /dev/md1
   VG Name               video_vg
   PV Size               372.62 GB / not usable 3.25 MB
   Allocatable           yes (but full)
   PE Size (KByte)       4096
   Total PE              95389
   Free PE               0
   Allocated PE          95389
   PV UUID               IUig5k-460l-sMZc-23Iz-MMFl-Cfh9-XuBMiq

md1 : active raid5 sdd1[0] sda1[2] sdc1[1]
       390716672 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]



00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host Bridge 
(rev 80)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
00:0a.0 Mass storage controller: Silicon Image, Inc. SiI 3112 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
00:0b.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit 
Ethernet Controller (rev 12)
00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID 
Controller (rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller 
(rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller 
(rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller 
(rev 81)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller 
(rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge 
[KT600/K8T800/K8T890 South]
00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 
AC97 Audio Controller (rev 60)
00:11.6 Communication controller: VIA Technologies, Inc. AC'97 Modem Controller 
(rev 80)
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 78)
01:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200 PRO] 
(rev 01)


tail end of info from dmesg:

k_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c0122a42>] __do_softirq+0x42/0x90
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b0d19>] xfs_alloc_ag_vextent_near+0x59/0xa30
  [<c01b177d>] xfs_alloc_ag_vextent+0x8d/0x100
  [<c01b1f93>] xfs_alloc_vextent+0x223/0x450
  [<c01bf7d0>] xfs_bmap_btalloc+0x400/0x770
  [<c01e183d>] xfs_iext_bno_to_ext+0x9d/0x1d0
  [<c01c483d>] xfs_bmapi+0x10bd/0x1490
  [<c01edace>] xlog_grant_log_space+0x22e/0x2b0
  [<c01edf60>] xfs_log_reserve+0xc0/0xe0
  [<c01e918f>] xfs_iomap_write_allocate+0x27f/0x4f0
  [<c0188861>] __block_prepare_write+0x421/0x490
  [<c01886b2>] __block_prepare_write+0x272/0x490
  [<c01e7c81>] xfs_iomap+0x391/0x4b0
  [<c020e3c0>] xfs_bmap+0x0/0x10
  [<c0207067>] xfs_map_blocks+0x47/0x90
  [<c020847c>] xfs_page_state_convert+0x3dc/0x7b0
  [<c01dff61>] xfs_ilock+0x71/0xa0
  [<c01dfed5>] xfs_iunlock+0x85/0x90
  [<c0208980>] xfs_vm_writepage+0x60/0xf0
  [<c014cd78>] __writepage+0x8/0x30
  [<c014d1bf>] write_cache_pages+0x1ff/0x320
  [<c014cd70>] __writepage+0x0/0x30
  [<c014d300>] generic_writepages+0x20/0x30
  [<c014d33b>] do_writepages+0x2b/0x50
  [<c0148592>] __filemap_fdatawrite_range+0x72/0x90
  [<c020b260>] xfs_file_fsync+0x0/0x80
  [<c0148893>] filemap_fdatawrite+0x23/0x30
  [<c018691e>] do_fsync+0x4e/0xb0
  [<c01869a5>] __do_fsync+0x25/0x40
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
Filesystem "dm-0": XFS internal error xfs_btree_check_sblock at line 334 of file 
fs/xfs/xfs_btree.c.  Caller 0xc01b27be
  [<c01cb73b>] xfs_btree_check_sblock+0x5b/0xd0
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b27be>] xfs_alloc_lookup+0x17e/0x390
  [<c01b000e>] xfs_free_ag_extent+0x2de/0x720
  [<c01b1d3b>] xfs_free_extent+0xbb/0xf0
  [<c01bc9b9>] xfs_bmap_finish+0x139/0x180
  [<c01c5540>] xfs_bunmapi+0x0/0xf80
  [<c01e320f>] xfs_itruncate_finish+0x26f/0x3f0
  [<c020447b>] xfs_inactive+0x48b/0x500
  [<c0210eb1>] xfs_fs_clear_inode+0x31/0x80
  [<c017a964>] clear_inode+0x54/0xf0
  [<c014f7b7>] truncate_inode_pages+0x17/0x20
  [<c017aad2>] generic_delete_inode+0xd2/0x100
  [<c017a11c>] iput+0x5c/0x70
  [<c01779e5>] d_kill+0x35/0x60
  [<c0177ab1>] dput+0xa1/0x150
  [<c0170ac8>] sys_renameat+0x1d8/0x200
  [<c0177a2c>] dput+0x1c/0x150
  [<c0167ab3>] __fput+0x113/0x180
  [<c017d053>] mntput_no_expire+0x13/0x90
  [<c0170b17>] sys_rename+0x27/0x30
  [<c0103fb4>] syscall_call+0x7/0xb
  =======================
xfs_force_shutdown(dm-0,0x8) called from line 4258 of file fs/xfs/xfs_bmap.c. 
Return address = 0xc02113cc
Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down 
filesystem: dm-0
Please umount the filesystem, and rectify the problem(s)
