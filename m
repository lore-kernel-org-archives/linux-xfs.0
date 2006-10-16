Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 13:34:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GKYcaG016843
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 13:34:40 -0700
Received: from mail.gmx.net (mail.gmx.de [213.165.64.20])
	by cuda.sgi.com (Spam Firewall) with SMTP id 6CEBA4AC499
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 12:17:02 -0700 (PDT)
From: peyytmek@gmx.de
Subject: xfs mounting problem, hdb1 just freezes
Date: Mon, 16 Oct 2006 21:14:35 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200610162114.36314.peyytmek@gmx.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've got a problem with my xfs-partition after my pc crashed.
Every programm that tries to use hdb1 just freezes like mount or even 
xfs_check (even killall -9 proc-name doesn't help)

thats what i get with dmesg. maybe someone of you can understand it.

thanks in advance.


under this line are the outputs of uname, lspci (ide) and dmesg

uname -a
Linux CLX 2.6.18-gentoo #7 PREEMPT Wed Oct 4 18:43:12 GMT 2006 i686 AMD 
Athlon(tm) XP 1800+ GNU/Linux

I'm using xfsprogs-2.7.11.

lscpi:
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a 
[Master SecP PriP])
        Subsystem: ASRock Incorporation K7VT2/K7VT6 motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Interrupt: pin A routed to IRQ 11
        Region 4: I/O ports at fc00 [size=16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


dmesg on hdb1 on boot:

XFS mounting filesystem hdb1
Starting XFS recovery on filesystem: hdb1 (logdev: internal)
Access to block zero: fs: <hdb1> inode: 950759 start_block : 0 start_off : 0 
blkcnt : 0 extent-state : 0
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:57!
invalid opcode: 0000 [#1]
PREEMPT
Modules linked in:
CPU:    0
EIP:    0060:[<c03378f9>]    Not tainted VLI
EFLAGS: 00010246   (2.6.18-gentoo #7)
EIP is at cmn_err+0xb9/0xe0
eax: 00000000   ebx: 00000297   ecx: ffffffff   edx: 00004301
esi: f78c97a0   edi: c064e2e0   ebp: 00000000   esp: f7c9b75c
ds: 007b   es: 007b   ss: 0068
Process mount (pid: 2114, ti=f7c9a000 task=f7c5d050 task.ti=f7c9a000)
Stack: c0556f3b c052284a c064e2e0 f7c9b788 f7c9b8f8 f78c97a0 f7c9b93c 00000000
       c02dec27 00000000 c0548610 f7cd54c0 000e81e7 00000000 00000000 00000000
       00000000 00000000 00000000 00000000 00000000 00000000 00000001 00000000
Call Trace:
 [<c02dec27>] xfs_bmap_search_extents+0x117/0x120
 [<c02e23d4>] xfs_bunmapi+0x1d4/0x1db0
 [<c04070c0>] ide_dma_exec_cmd+0x30/0x40
 [<c0406773>] ide_dma_start+0x33/0x50
 [<c03fea22>] ide_do_request+0x682/0x830
 [<c03fe33c>] ide_end_request+0x14c/0x160
 [<c0147658>] mempool_alloc+0x38/0x120
 [<c0147658>] mempool_alloc+0x38/0x120
 [<c034fcf6>] as_set_request+0x26/0x80
 [<c0143f5c>] find_lock_page+0x2c/0xc0
 [<c02e2200>] xfs_bunmapi+0x0/0x1db0
 [<c030672f>] xfs_itruncate_finish+0x28f/0x460
 [<c0329198>] xfs_inactive+0x668/0xca0
 [<c032f233>] xfs_buf_get_flags+0x293/0x4a0
 [<c032f474>] xfs_buf_read_flags+0x34/0xa0
 [<c031dfcc>] xfs_trans_read_buf+0x5c/0x3e0
 [<c032df74>] xfs_buf_offset+0x44/0x50
 [<c0336c3e>] xfs_fs_clear_inode+0x3e/0xa0
 [<c018063a>] clear_inode+0x5a/0xe0
 [<c01807b6>] generic_delete_inode+0xf6/0x130
 [<c0314ca9>] xlog_recover_process_iunlinks+0x559/0x580
 [<c032e3ab>] xfs_buf_free+0x5b/0x110
 [<c03150a2>] xlog_recover_finish+0x3d2/0x510
 [<c03368db>] xfs_initialize_vnode+0x3ab/0x3c0
 [<c03029c9>] xfs_iget+0x429/0x737
 [<c03198a0>] xfs_mountfs+0xe40/0x1060
 [<c0116d20>] default_wake_function+0x0/0x20
 [<c04fe527>] __down_failed+0x7/0xc
 [<c034aff0>] generic_unplug_device+0x0/0x40
 [<c032e485>] xfs_buf_rele+0x25/0xe0
 [<c03218d1>] xfs_mount+0x6e1/0xa60
 [<c0336a5d>] xfs_fs_fill_super+0x9d/0x240
 [<c035a78b>] snprintf+0x2b/0x30
 [<c01a3b98>] disk_name+0x98/0xd0
 [<c016cd3f>] sb_set_blocksize+0x1f/0x50
 [<c016c30b>] get_sb_bdev+0x13b/0x180
 [<c0335aa7>] xfs_fs_get_sb+0x37/0x40
 [<c03369c0>] xfs_fs_fill_super+0x0/0x240
 [<c016bfec>] vfs_kern_mount+0x4c/0xa0
 [<c016c0b2>] do_kern_mount+0x42/0x60
 [<c018464d>] do_mount+0x28d/0x730
 [<c017646d>] link_path_walk+0x7d/0x100
 [<c017ec43>] dput+0x23/0x190
 [<c0174fe1>] putname+0x31/0x40
 [<c0176720>] do_path_lookup+0xb0/0x2e0
 [<c01750a1>] getname+0xb1/0x100
 [<c016f4af>] vfs_stat+0x1f/0x30
 [<c01498b4>] __get_free_pages+0x34/0x60
 [<c0182fe4>] copy_mount_options+0x44/0x130
 [<c0184b8d>] sys_mount+0x9d/0xe0
 [<c010318b>] syscall_call+0x7/0xb
Code: e0 e2 64 c0 c7 04 24 3b 6f 55 c0 89 44 24 04 e8 7e 37 de ff 53 9d 89 e0 
25 00 e0 ff ff ff 48 14 8b 40 08 a8 08 75 20 85 ed 75 08 <0f> 0b 39 00 b8 ec 
52 c0 8b 5c 24 10 8b 74 24 14 8b 7c 24 18 8b
EIP: [<c03378f9>] cmn_err+0xb9/0xe0 SS:ESP 0068:f7c9b75c
 <6>Adding 1004020k swap on /dev/hda6.  Priority:-1 extents:1 across:1004020k
