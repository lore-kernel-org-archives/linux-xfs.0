Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p17Ax0cu038386 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 04:59:00 -0600
Received: from mailout1.samsung.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8CE8122CA8B
	for <xfs@oss.sgi.com>; Mon,  7 Feb 2011 03:01:29 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id K93WGJN6W3bLTo4h for
	<xfs@oss.sgi.com>; Mon, 07 Feb 2011 03:01:29 -0800 (PST)
MIME-version: 1.0
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
	by mailout1.samsung.com
	(Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built
	Sep 7
	2010)) with ESMTP id <0LG800A57UMBV620@mailout1.samsung.com> for
	xfs@oss.sgi.com; Mon, 07 Feb 2011 20:01:23 +0900 (KST)
Received: from unisistPC ([165.213.110.204])
	by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
	2004))
	with ESMTPA id <0LG800H6KUMB9O@mmp1.samsung.com> for xfs@oss.sgi.com;
	Mon, 07 Feb 2011 20:01:23 +0900 (KST)
Date: Mon, 07 Feb 2011 20:01:23 +0900
From: Ryan Roh <unisist.roh@samsung.com>
Subject: segmentation fault during mount
Message-id: <02b401cbc6b6$5b7ac0b0$12704210$@samsung.com>
Content-language: en-us
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6543077400249762475=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multipart message in MIME format.

--===============6543077400249762475==
Content-type: multipart/alternative;
 boundary="Boundary_(ID_ukvDY3C06QY6i2VrXCthQQ)"
Content-language: en-us

This is a multipart message in MIME format.

--Boundary_(ID_ukvDY3C06QY6i2VrXCthQQ)
Content-type: text/plain; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT

Dear Members,

 

I'm using XFS based on STMicro SH4 based chip (STi7105).

and I have some issue on xfs log mounting.

 

1. chip : sh4 STi7105

2. HDD : 320GB USB HDD USB 2.0 port.

3. OS : Linux 2.6.23.17 + patch for fixing cache aliasing issue.

4. XFSProgs version : 3.1.1

 

 

mounting and repairing log in the below. This segmentation fault is caused
by

the assert in xfs_alloc_increment function of xfs_alloc_btree.c file. The
btree

level is equal to root level in the below code.

 

    /*

     * If we went off the root then we are seriously confused.

     */

    ASSERT(lev < cur->bc_nlevels);

 

I want to know why and how this error can be happen. Would you please
explain or give any hint for this?

 

Thank you in advance.

 

 

============================================================================
===

XFS mounting filesystem sdb3

Starting XFS recovery on filesystem: sdb3 (logdev: internal)

Unable to handle kernel NULL pointer dereference at virtual address 00000058

pc = 80830d8c

*pde = 00000000

Oops: 0000 [#1]

Modules linked in: stsectoolfuse_ioctl(P) adf(P) asf(P) ath_hif_usb

embxloopback(P) embxmailbox(P) sec_nvram ath_htc_hst ath_dfs(P) embxshell(P)

sttkdma_ioctl(P) ath_rate_atheros(P) mme_host(P) embxshm(P) sttkdma_core(P)

stpti4_ioctl(P) stsectoolfuse_core(P) MHFSWRAPGPL_KERN ath_dev(P) xsr(P)

ath_hal(P) xsr_stl(P) stuart_core(P) MHFSWRAP_KERN(P) stsmart_core(P)
wifitt(P)

umac stapi_core(P) CDIDVB_ST_REF(P)

 

Pid : 885, Comm:                mount

PC is at xfs_alloc_increment+0x1ec/0x220

PC  : 80830d8c SP  : 8aeb5ad0 SR  : 40008000 TEA : c15f3524    Tainted: P


R0  : 00000003 R1  : 00000040 R2  : 00000008 R3  : 000001ff

R4  : 8354c84c R5  : 00000001 R6  : 00000002 R7  : 00000001

R8  : 8354c894 R9  : 00000002 R10 : 8354c84c R11 : 8354c8ae

R12 : 00000000 R13 : 8aeb5a98 R14 : 8354c8b4

MACH: 00000000 MACL: 8aa92322 GBR : 004d2290 PR  : 80830bd0

 

Call trace: 

[<8082ea66>] xfs_free_ag_extent+0xe6/0x5c0

[<80a45f16>] __down_read+0x136/0x180

[<80830560>] xfs_free_extent+0x0/0xc0

[<808305e2>] xfs_free_extent+0x82/0xc0

[<80830560>] xfs_free_extent+0x0/0xc0

[<8087be00>] xfs_trans_log_efd_extent+0x0/0x60

[<8086eb1a>] xlog_recover_process_efi+0x25a/0x320

[<808706c8>] xlog_recover_process_efis+0x68/0xe0

[<8086e8c0>] xlog_recover_process_efi+0x0/0x320

[<8087ac20>] xfs_trans_next_ail+0x0/0x60

[<80870766>] xlog_recover_finish+0x26/0xe0

[<8087625c>] xfs_mountfs+0xc1c/0xe40

[<808876d2>] kmem_alloc+0x52/0x100

[<808877ec>] kmem_zalloc+0xc/0x40

[<808584c0>] xfs_fstrm_free_func+0x0/0xc0

[<8087f30a>] xfs_mount+0x3ca/0x420

[<80893318>] xfs_fs_fill_super+0x58/0x240

[<80774d20>] path_lookup+0x0/0x20

[<808ba576>] snprintf+0x16/0x40

[<80774d20>] path_lookup+0x0/0x20

[<807aab2e>] disk_name+0x8e/0xc0

[<80794f54>] sb_set_blocksize+0x14/0x40

[<8076ae32>] get_sb_bdev+0x152/0x1e0

[<807644a8>] __kmalloc+0x48/0x100

[<80892250>] xfs_fs_get_sb+0x10/0x20

[<808932c0>] xfs_fs_fill_super+0x0/0x240

[<8076a596>] vfs_kern_mount+0x36/0xc0

[<8076a66e>] do_kern_mount+0x2e/0xe0

[<80783390>] do_mount+0x130/0x6c0

[<80770900>] path_release+0x0/0x40

[<80712b3a>] enqueue_entity+0x9a/0x2a0

[<80712ee0>] sub_preempt_count+0x0/0xa0

[<80a45f16>] __down_read+0x136/0x180

[<80712a58>] dequeue_entity+0x58/0xa0

[<80712d66>] task_tick_fair+0x26/0x80

[<8070faa0>] do_page_fault+0x60/0x380

[<808b852e>] __up_read+0x4e/0xe0

[<8070e9ce>] fixup_exception+0xe/0x40

[<8070fb30>] do_page_fault+0xf0/0x380

[<80722b3a>] run_timer_softirq+0x1a/0x200

[<80763870>] kmem_cache_free+0x50/0xe0

[<8072c760>] __rcu_process_callbacks+0x60/0x2c0

[<8072c9ce>] rcu_process_callbacks+0xe/0x40

[<8071ea7a>] tasklet_action+0x7a/0xe0

[<8071e8e4>] __do_softirq+0x64/0x100

[<808bca60>] debug_smp_processor_id+0x0/0xc0

[<8071e8f6>] __do_softirq+0x76/0x100

[<8071e9e4>] do_softirq+0x64/0x80

[<80749020>] get_page_from_freelist+0x160/0x3e0

[<80748fc2>] get_page_from_freelist+0x102/0x3e0

[<8074980e>] __alloc_pages+0x6e/0x2e0

[<80749aa0>] __get_free_pages+0x20/0x60

[<80783986>] sys_mount+0x66/0xe0

[<80749740>] free_pages+0x0/0x60

[<807078f8>] syscall_call+0xa/0xe

[<80783920>] sys_mount+0x0/0xe0

 

Process: mount (pid: 885, stack limit = 8aeb4001)

Stack: (0x8aeb5ad0 to 0x8aeb6000)

5ac0:                                     8aeb5b14 00000000 8082ea66
83853400 

5ae0: 8aeb5ae4 006bfa43 8adff680 8354c84c 8a5f8c78 00000000 00000002
00000000 

5b00: 00020250 00000001 000000bc 004f8880 00000001 8a5ecc80 00000000
80a45f16 

5b20: 80830560 808305e2 80830560 8087be00 000002f0 000001cc 8aeb5b4c
8a5f8c78 

5b40: 00000000 000002f0 00000000 8a5f8c78 83853400 8adff680 83c37f78
00000000 

5b60: 00000002 006bfa43 00000000 00000000 00000000 00000000 00000000
00000000 

5b80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
8086eb1a 

5ba0: 83c43e90 00000000 8a5f8c78 83c36edc 83c36ed4 0000001d 0000001c
00000007 

5bc0: 00000006 ffffffe7 fffffff9 83c36ed0 02bc2417 00000000 00000002
00000000 

5be0: 83c36e90 83853400 012814ea 01ffffff 00000003 00000002 04a053a7
00000000 

5c00: 808706c8 8086e8c0 00001236 8087ac20 8aeb4000 8382631c 83853400
83c36e90 

5c20: 00000001 80870766 8aeb5c90 83853440 8386ce20 838262e0 8382631c
00000000 

5c40: 838262a0 8087625c 83853400 00000000 00000000 838536bc 00000002
00000000 

5c60: 00000000 00000000 00000002 00000000 00000040 83fea8c0 25029d38
00000000 

5c80: 00000000 00000000 00000001 00000000 808876d2 00000000 000002d0
00000058 

5ca0: 00000001 808877ec 816f01e0 808584c0 1fef00fc dfdd5f0f 83853754
00000058 

5cc0: 00000000 00000000 8a6acde0 8adffb00 8087f30a 816f01e0 83fea8c0
836ea000 

5ce0: 8aeb5cc0 83853400 00000000 00000000 00000000 00000040 00000000
00000000 

5d00: 80893318 80774d20 8adfd000 836ea000 83fea8c0 8ae55200 8adfd000
00000001 

5d20: 00000002 8aeb5d93 0000000a ffffffff ffffffff 00000002 00000020
8aeb5d90 

5d40: 8116028c ffffffff 80ab6bdc 808ba576 80774d20 8adfd000 816f0220
8aeb5d90 

5d60: 8116028c 00000003 81160280 8aeb5d74 807aab2e 80794f54 8076ae32
816f0220 

5d80: 8ae55200 816f01f8 00000001 8ae55200 33626473 00000000 00000001
00000000 

5da0: 00000080 8381115c 807644a8 00000000 80892250 8a733000 8adfd000
00008000 

5dc0: 8a4f7000 816f58a0 80b2b2e4 808932c0 816f58a0 8076a596 816f58a0
8076a66e 

5de0: ffffffed 80b2b2e4 8adfd000 8a4f7000 00008000 80783390 00008000
00000000 

5e00: 8a733000 80770900 00000000 00000000 80712b3a 8aeb5e30 83810e60
80712ee0 

5e20: 8132d758 8132d3a8 80a45f16 83d718b4 83810e60 80712a58 8132d758
80712d66 

5e40: 8070faa0 808b852e 8070e9ce 8aeb5f44 8070fb30 83810e60 000541a4
8aeb4000 

5e60: 00000000 00000002 00000050 80722b3a 80763870 00000000 00000000
8072c760 

5e80: 000000f0 8133335c 00000002 00000000 8072c9ce 813320e4 8071ea7a
813320e4 

5ea0: 00000000 ffffff0f 8071e8e4 813320c0 808bca60 0000000a 8071e8f6
00000000 

5ec0: 8133212c 8071e9e4 00008000 80749020 80748fc2 00000000 00000000
80b267bc 

5ee0: 00000044 00000000 000200d0 80b26944 00000000 00000000 8074980e
80b26940 

5f00: 80d330b8 816f57a0 83810e60 8ade8000 8aeb5f84 00000001 00000001
00000000 

5f20: 00000080 8381115c 00000010 00000eb1 814abfa0 8a4f7000 000200d0
00008000 

5f40: 80749aa0 00008000 00402c9c 00008000 7bc48eb1 8ade8000 80783986
00008000 

5f60: 00402c9c 00008000 80749740 8ade8000 8aeb5f48 00000000 8adfd000
8a4f7000 

5f80: 8a733000 8adfd000 807078f8 00000514 00000000 00000021 00000054
80783920 

5fa0: 004d22c0 0044b4b4 ffffffff 00000015 7bc48eb1 7bc48ebb 004d3518
00008000 

5fc0: 00008000 7bc48aa4 004d2298 004d22c0 004736cc 00402c9c 00008000
7bc489e0 

5fe0: 0044b4bc 00423268 00008000 004d2290 00000000 0000004e 00000054
00000160 

Segmentation fault

============================================================================
===

 

 

============================================================================
===

# xfs_repair -n /dev/sdb3

Phase 1 - find and verify superblock...

Phase 2 - using internal log

        - scan filesystem freespace and inode maps...

out-of-order bno btree record 416 (3934652 1) block 2/3

block (2,3934652-3934652) multiply claimed by bno space tree, state - 1

out-of-order bno btree record 417 (3938602 187) block 2/3

block (2,3938602-3938602) multiply claimed by bno space tree, state - 1

bno freespace btree block claimed (state 2), agno 2, bno 37902, suspect 0

cnt freespace btree block claimed (state 2), agno 2, bno 193058, suspect 0

block (2,924189-924189) multiply claimed by cnt space tree, state - 2

block (2,930675-930675) multiply claimed by cnt space tree, state - 2

block (2,930957-930957) multiply claimed by cnt space tree, state - 2

block (2,934623-934623) multiply claimed by cnt space tree, state - 2

block (2,934905-934905) multiply claimed by cnt space tree, state - 2

block (2,936315-936315) multiply claimed by cnt space tree, state - 2

block (2,936597-936597) multiply claimed by cnt space tree, state - 2

block (2,939135-939135) multiply claimed by cnt space tree, state - 2

block (2,939417-939417) multiply claimed by cnt space tree, state - 2

block (2,947595-947595) multiply claimed by cnt space tree, state - 2

block (2,948065-948065) multiply claimed by cnt space tree, state - 2

block (2,1028435-1028435) multiply claimed by cnt space tree, state - 2

block (2,1028906-1028906) multiply claimed by cnt space tree, state - 2

block (2,1031443-1031443) multiply claimed by cnt space tree, state - 2

out-of-order cnt btree record 238 (5971248 187) block 2/193054

out-of-order cnt btree record 239 (6003209 187) block 2/193054

out-of-order cnt btree record 240 (6100543 187) block 2/193054

out-of-order cnt btree record 241 (6192053 187) block 2/193054

out-of-order cnt btree record 242 (6237549 187) block 2/193054

out-of-order cnt btree record 243 (6292821 187) block 2/193054

out-of-order cnt btree record 244 (6388878 187) block 2/193054

cnt freespace btree block claimed (state 2), agno 2, bno 37955, suspect 0

agf_freeblks 12415209, counted 12444225 in ag 2

agi unlinked bucket 18 is 6331218 in ag 2 (inode=1080073042)

sb_ifree 162, counted 166

sb_fdblocks 69539078, counted 69568099

        - found root inode chunk

Phase 3 - for each AG...

        - scan (but don't clear) agi unlinked lists...

        - process known inodes and perform inode discovery...

        - agno = 0

        - agno = 1

        - agno = 2

29560000: Badness in key lookup (length)

bp=(bno 313629760, len 16384 bytes) key=(bno 313629760, len 8192 bytes)

bmap rec out of order, inode 1080073043 entry 105 [o s c] [21592 71839253
188],

104 [19592 101671866 22184]

bad data fork in inode 1080073043

would have cleared inode 1080073043

        - agno = 3

        - process newly discovered inodes...

Phase 4 - check for duplicate blocks...

        - setting up duplicate extent list...

        - check for inodes claiming duplicate blocks...

        - agno = 0

        - agno = 1

        - agno = 2

entry "00000123" at block 0 offset 1104 in directory inode 1074348320

references free inode 1080073043

        would clear inode number in entry at offset 1104...

bmap rec out of order, inode 1080073043 entry 105 [o s c] [21592 71839253
188],

104 [19592 101671866 22184]

bad data fork in inode 1080073043

would have cleared inode 1080073043

        - agno = 3

No modify flag set, skipping phase 5

Phase 6 - check inode connectivity...

        - traversing filesystem ...

entry "00000123" in directory inode 1074348320 points to free inode
1080073043,

would junk entry

bad hash table for directory inode 1074348320 (no data entry): would rebuild

        - traversal finished ...

        - moving disconnected inodes to lost+found ...

disconnected inode 1080073042, would move to lost+found

Phase 7 - verify link counts...

would have reset inode 1080073042 nlinks from 0 to 1

No modify flag set, skipping filesystem flush and exiting.

============================================================================
===

 

 

============================================================================
===

# xfs_logprint -t /dev/sdb3

xfs_logprint:

    data device: 0x813

    log device: 0x813 daddr: 310464192 length: 303184

 

    log tail: 303165 head: 303169 state: <DIRTY>

 

 

LOG REC AT LSN cycle 4 block 303165 (0x4, 0x4a03d)

============================================================================

TRANS: tid:0x83fa10ac  type:  #items:1  trans:0x0  q:0x434c08

EFD: cnt:1 total:1 a:0x42c6f8 len:52 

        EFD:  #regs: 1    num_extents: 3  id: 0xffffffff81eaae90

 

LOG REC AT LSN cycle 4 block 303167 (0x4, 0x4a03f)

============================================================================

TRANS: tid:0x83fa1158  type:INACTIVE  #items:3  trans:0x0  q:0x434c08

INO: cnt:2 total:2 a:0x42c6f8 len:52 a:0x42c760 len:96 

        INODE: #regs:2   ino:0x40609b52  flags:0x1   dsize:0

        CORE inode:

BUF: cnt:2 total:2 a:0x42c7c8 len:28 a:0x42ca48 len:128 

        BUF:  #regs:2   start blkno:0x157aba00   len:8   bmap size:2  

flags:0x0

        BUF DATA

EFI: cnt:1 total:1 a:0x42cad0 len:40 

        EFI:  #regs:1    num_extents:2  id:0xffffffff8239e058

        (s: 0x46bfa43, l: 752) (s: 0x46bfdef, l: 1128) 

 

============================================================================
===

 

 

Regards,

Ryan. 

 

 


--Boundary_(ID_ukvDY3C06QY6i2VrXCthQQ)
Content-type: text/html; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT

<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40"><head><META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii"><meta name=Generator content="Microsoft Word 14 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"\B9D1\C740 \ACE0\B515";
	panose-1:2 11 5 3 2 0 0 2 0 4;}
@font-face
	{font-family:"\@\B9D1\C740 \ACE0\B515";
	panose-1:2 11 5 3 2 0 0 2 0 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	text-autospace:none;
	word-break:break-hangul;
	font-size:10.0pt;
	font-family:"\B9D1\C740 \ACE0\B515";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"\B9D1\C740 \ACE0\B515";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"\B9D1\C740 \ACE0\B515";}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:3.0cm 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext="edit" spidmax="1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext="edit">
<o:idmap v:ext="edit" data="1" />
</o:shapelayout></xml><![endif]--></head><body lang=KO link=blue vlink=purple><div class=WordSection1><p class=MsoNormal><span lang=EN-US>Dear Members,<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>I'm using XFS based on STMicro SH4 based chip (STi7105).<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>and I have some issue on xfs log mounting.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>1. chip : sh4 STi7105<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>2. HDD : 320GB USB HDD USB 2.0 port.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>3. OS : Linux 2.6.23.17 + patch for fixing cache aliasing issue.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>4. XFSProgs version : 3.1.1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=E
 N-US><o:
<p class=MsoNormal><span lang=EN-US>mounting and repairing log in the below. This segmentation fault is caused by<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>the assert in xfs_alloc_increment function of xfs_alloc_btree.c file. The btree<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>level is equal to root level in the below code.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; /*<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp; * If we went off the root then we are seriously confused.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp; */<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; ASSERT(lev &lt; cur-&gt;bc_nlevels);<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>I want to know why and how this 
 error ca
ease explain or give any hint for this?<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Thank you in advance.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>===============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>XFS mounting filesystem sdb3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Starting XFS recovery on filesystem: sdb3 (logdev: internal)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Unable to handle kernel NULL pointer dereference at virtual address 00000058<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>pc = 80830d8c<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>*pde = 00000000<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Oop
 s: 0000 
><p class=MsoNormal><span lang=EN-US>Modules linked in: stsectoolfuse_ioctl(P) adf(P) asf(P) ath_hif_usb<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>embxloopback(P) embxmailbox(P) sec_nvram ath_htc_hst ath_dfs(P) embxshell(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>sttkdma_ioctl(P) ath_rate_atheros(P) mme_host(P) embxshm(P) sttkdma_core(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>stpti4_ioctl(P) stsectoolfuse_core(P) MHFSWRAPGPL_KERN ath_dev(P) xsr(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>ath_hal(P) xsr_stl(P) stuart_core(P) MHFSWRAP_KERN(P) stsmart_core(P) wifitt(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>umac stapi_core(P) CDIDVB_ST_REF(P)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Pid : 885, Comm:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mount<o:p></o:p></span></p><p 
 class=Ms
PC is at xfs_alloc_increment+0x1ec/0x220<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>PC&nbsp; : 80830d8c SP&nbsp; : 8aeb5ad0 SR&nbsp; : 40008000 TEA : c15f3524&nbsp;&nbsp;&nbsp; Tainted: P&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>R0&nbsp; : 00000003 R1&nbsp; : 00000040 R2&nbsp; : 00000008 R3&nbsp; : 000001ff<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>R4&nbsp; : 8354c84c R5&nbsp; : 00000001 R6&nbsp; : 00000002 R7&nbsp; : 00000001<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>R8&nbsp; : 8354c894 R9&nbsp; : 00000002 R10 : 8354c84c R11 : 8354c8ae<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>R12 : 00000000 R13 : 8aeb5a98 R14 : 8354c8b4<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>MACH: 00000000 MACL: 8aa92322 GBR : 004d2290 PR&nbsp; : 80830bd0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Call 
 trace: <
lass=MsoNormal><span lang=EN-US>[&lt;8082ea66&gt;] xfs_free_ag_extent+0xe6/0x5c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80a45f16&gt;] __down_read+0x136/0x180<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80830560&gt;] xfs_free_extent+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808305e2&gt;] xfs_free_extent+0x82/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80830560&gt;] xfs_free_extent+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087be00&gt;] xfs_trans_log_efd_extent+0x0/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8086eb1a&gt;] xlog_recover_process_efi+0x25a/0x320<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808706c8&gt;] xlog_recover_process_efis+0x68/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8086e8c0&gt;] xlog_recover_process_efi+0x0/0x320<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&
 lt;8087a
il+0x0/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80870766&gt;] xlog_recover_finish+0x26/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087625c&gt;] xfs_mountfs+0xc1c/0xe40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808876d2&gt;] kmem_alloc+0x52/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808877ec&gt;] kmem_zalloc+0xc/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808584c0&gt;] xfs_fstrm_free_func+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8087f30a&gt;] xfs_mount+0x3ca/0x420<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80893318&gt;] xfs_fs_fill_super+0x58/0x240<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80774d20&gt;] path_lookup+0x0/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808ba576&gt;] snprintf+0x16/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80774d20&gt;] p
 ath_look
pan></p><p class=MsoNormal><span lang=EN-US>[&lt;807aab2e&gt;] disk_name+0x8e/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80794f54&gt;] sb_set_blocksize+0x14/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076ae32&gt;] get_sb_bdev+0x152/0x1e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807644a8&gt;] __kmalloc+0x48/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80892250&gt;] xfs_fs_get_sb+0x10/0x20<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808932c0&gt;] xfs_fs_fill_super+0x0/0x240<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076a596&gt;] vfs_kern_mount+0x36/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8076a66e&gt;] do_kern_mount+0x2e/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783390&gt;] do_mount+0x130/0x6c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80770900&gt;] path_release+0x0/0x40<o:p></o
 :p></spa
<span lang=EN-US>[&lt;80712b3a&gt;] enqueue_entity+0x9a/0x2a0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712ee0&gt;] sub_preempt_count+0x0/0xa0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80a45f16&gt;] __down_read+0x136/0x180<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712a58&gt;] dequeue_entity+0x58/0xa0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80712d66&gt;] task_tick_fair+0x26/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8070faa0&gt;] do_page_fault+0x60/0x380<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808b852e&gt;] __up_read+0x4e/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8070e9ce&gt;] fixup_exception+0xe/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8070fb30&gt;] do_page_fault+0xf0/0x380<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80722b3a&gt;] run_timer_softirq+0x1a/0x200<o:p></o:p></span></
 p><p cla
N-US>[&lt;80763870&gt;] kmem_cache_free+0x50/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8072c760&gt;] __rcu_process_callbacks+0x60/0x2c0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8072c9ce&gt;] rcu_process_callbacks+0xe/0x40<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071ea7a&gt;] tasklet_action+0x7a/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071e8e4&gt;] __do_softirq+0x64/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;808bca60&gt;] debug_smp_processor_id+0x0/0xc0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071e8f6&gt;] __do_softirq+0x76/0x100<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;8071e9e4&gt;] do_softirq+0x64/0x80<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80749020&gt;] get_page_from_freelist+0x160/0x3e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80748fc2&gt;] get_page_from_freelist+0x102/
 0x3e0<o:
ss=MsoNormal><span lang=EN-US>[&lt;8074980e&gt;] __alloc_pages+0x6e/0x2e0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80749aa0&gt;] __get_free_pages+0x20/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783986&gt;] sys_mount+0x66/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80749740&gt;] free_pages+0x0/0x60<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;807078f8&gt;] syscall_call+0xa/0xe<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>[&lt;80783920&gt;] sys_mount+0x0/0xe0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Process: mount (pid: 885, stack limit = 8aeb4001)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Stack: (0x8aeb5ad0 to 0x8aeb6000)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ac0:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb
 sp;&nbsp
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8aeb5b14 00000000 8082ea66 83853400 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ae0: 8aeb5ae4 006bfa43 8adff680 8354c84c 8a5f8c78 00000000 00000002 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b00: 00020250 00000001 000000bc 004f8880 00000001 8a5ecc80 00000000 80a45f16 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b20: 80830560 808305e2 80830560 8087be00 000002f0 000001cc 8aeb5b4c 8a5f8c78 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b40: 00000000 000002f0 00000000 8a5f8c78 83853400 8adff680 83c37f78 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b60: 00000002 006bfa43 00000000 00000000 00000000 00000000 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5b80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 8086eb1a <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5
 ba0: 83c
3c36edc 83c36ed4 0000001d 0000001c 00000007 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5bc0: 00000006 ffffffe7 fffffff9 83c36ed0 02bc2417 00000000 00000002 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5be0: 83c36e90 83853400 012814ea 01ffffff 00000003 00000002 04a053a7 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c00: 808706c8 8086e8c0 00001236 8087ac20 8aeb4000 8382631c 83853400 83c36e90 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c20: 00000001 80870766 8aeb5c90 83853440 8386ce20 838262e0 8382631c 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c40: 838262a0 8087625c 83853400 00000000 00000000 838536bc 00000002 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c60: 00000000 00000000 00000002 00000000 00000040 83fea8c0 25029d38 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5c80: 00000000 00000000 00000001 00000000 808876d2 00000000 000002d0 000
 00058 <o
ass=MsoNormal><span lang=EN-US>5ca0: 00000001 808877ec 816f01e0 808584c0 1fef00fc dfdd5f0f 83853754 00000058 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5cc0: 00000000 00000000 8a6acde0 8adffb00 8087f30a 816f01e0 83fea8c0 836ea000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ce0: 8aeb5cc0 83853400 00000000 00000000 00000000 00000040 00000000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d00: 80893318 80774d20 8adfd000 836ea000 83fea8c0 8ae55200 8adfd000 00000001 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d20: 00000002 8aeb5d93 0000000a ffffffff ffffffff 00000002 00000020 8aeb5d90 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d40: 8116028c ffffffff 80ab6bdc 808ba576 80774d20 8adfd000 816f0220 8aeb5d90 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d60: 8116028c 00000003 81160280 8aeb5d74 807aab2e 80794f54 8076ae32 816f0220 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5d80: 8
 ae55200 
0 33626473 00000000 00000001 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5da0: 00000080 8381115c 807644a8 00000000 80892250 8a733000 8adfd000 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5dc0: 8a4f7000 816f58a0 80b2b2e4 808932c0 816f58a0 8076a596 816f58a0 8076a66e <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5de0: ffffffed 80b2b2e4 8adfd000 8a4f7000 00008000 80783390 00008000 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e00: 8a733000 80770900 00000000 00000000 80712b3a 8aeb5e30 83810e60 80712ee0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e20: 8132d758 8132d3a8 80a45f16 83d718b4 83810e60 80712a58 8132d758 80712d66 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e40: 8070faa0 808b852e 8070e9ce 8aeb5f44 8070fb30 83810e60 000541a4 8aeb4000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5e60: 00000000 00000002 00000050 80722b3a 80763870 00000000 00000000 8072c760 
 <o:p></o
oNormal><span lang=EN-US>5e80: 000000f0 8133335c 00000002 00000000 8072c9ce 813320e4 8071ea7a 813320e4 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ea0: 00000000 ffffff0f 8071e8e4 813320c0 808bca60 0000000a 8071e8f6 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ec0: 8133212c 8071e9e4 00008000 80749020 80748fc2 00000000 00000000 80b267bc <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5ee0: 00000044 00000000 000200d0 80b26944 00000000 00000000 8074980e 80b26940 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f00: 80d330b8 816f57a0 83810e60 8ade8000 8aeb5f84 00000001 00000001 00000000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f20: 00000080 8381115c 00000010 00000eb1 814abfa0 8a4f7000 000200d0 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f40: 80749aa0 00008000 00402c9c 00008000 7bc48eb1 8ade8000 80783986 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f60: 00402c9
 c 000080
5f48 00000000 8adfd000 8a4f7000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5f80: 8a733000 8adfd000 807078f8 00000514 00000000 00000021 00000054 80783920 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5fa0: 004d22c0 0044b4b4 ffffffff 00000015 7bc48eb1 7bc48ebb 004d3518 00008000 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5fc0: 00008000 7bc48aa4 004d2298 004d22c0 004736cc 00402c9c 00008000 7bc489e0 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>5fe0: 0044b4bc 00423268 00008000 004d2290 00000000 0000004e 00000054 00000160 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Segmentation fault<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>===============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>===============
 ========
===============================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US># xfs_repair -n /dev/sdb3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 1 - find and verify superblock...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 2 - using internal log<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace and inode maps...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order bno btree record 416 (3934652 1) block 2/3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,3934652-3934652) multiply claimed by bno space tree, state - 1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order bno btree record 417 (3938602 187) block 2/3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,3938602-3938602) multiply claimed by bno space tree, state - 1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bno
  freespa
tate 2), agno 2, bno 37902, suspect 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>cnt freespace btree block claimed (state 2), agno 2, bno 193058, suspect 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,924189-924189) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,930675-930675) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,930957-930957) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,934623-934623) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,934905-934905) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,936315-936315) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>b
 lock (2,
laimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,939135-939135) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,939417-939417) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,947595-947595) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,948065-948065) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,1028435-1028435) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,1028906-1028906) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>block (2,1031443-1031443) multiply claimed by cnt space tree, state - 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>ou
 t-of-ord
5971248 187) block 2/193054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order cnt btree record 239 (6003209 187) block 2/193054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order cnt btree record 240 (6100543 187) block 2/193054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order cnt btree record 241 (6192053 187) block 2/193054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order cnt btree record 242 (6237549 187) block 2/193054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order cnt btree record 243 (6292821 187) block 2/193054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>out-of-order cnt btree record 244 (6388878 187) block 2/193054<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>cnt freespace btree block claimed (state 2), agno 2, bno 37955, suspect 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>agf_freeblks 12415209, counted 12444225 in ag 2<o:p></
 o:p></sp
><span lang=EN-US>agi unlinked bucket 18 is 6331218 in ag 2 (inode=1080073042)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>sb_ifree 162, counted 166<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>sb_fdblocks 69539078, counted 69568099<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - found root inode chunk<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 3 - for each AG...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan (but don't clear) agi unlinked lists...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process known inodes and perform inode discovery...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 1<o:
 p></o:p>
rmal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>29560000: Badness in key lookup (length)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bp=(bno 313629760, len 16384 bytes) key=(bno 313629760, len 8192 bytes)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bmap rec out of order, inode 1080073043 entry 105 [o s c] [21592 71839253 188],<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>104 [19592 101671866 22184]<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bad data fork in inode 1080073043<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>would have cleared inode 1080073043<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process newly discovered inodes...<o:p></o:p></span></p><p class=Mso
 Normal><
 check for duplicate blocks...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - setting up duplicate extent list...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - check for inodes claiming duplicate blocks...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 2<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>entry &quot;00000123&quot; at block 0 offset 1104 in directory inode 1074348320<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>references free inode 1080073043<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; would clear i
 node num
04...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bmap rec out of order, inode 1080073043 entry 105 [o s c] [21592 71839253 188],<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>104 [19592 101671866 22184]<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bad data fork in inode 1080073043<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>would have cleared inode 1080073043<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno = 3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>No modify flag set, skipping phase 5<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 6 - check inode connectivity...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversing filesystem ...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>entry &quot;00000123&quot; in directory inode 1074348320 points to free inode 1080073043,<o:p
 ></o:p><
mal><span lang=EN-US>would junk entry<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>bad hash table for directory inode 1074348320 (no data entry): would rebuild<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversal finished ...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - moving disconnected inodes to lost+found ...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>disconnected inode 1080073042, would move to lost+found<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Phase 7 - verify link counts...<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>would have reset inode 1080073042 nlinks from 0 to 1<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>No modify flag set, skipping filesystem flush and exiting.<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>=============================================================
 ========
an></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>===============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US># xfs_logprint -t /dev/sdb3<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>xfs_logprint:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; data device: 0x813<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; log device: 0x813 daddr: 310464192 length: 303184<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp; log tail: 303165 head: 303169 state: &lt;DIRTY&gt;<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><sp
 an lang=
e 4 block 303165 (0x4, 0x4a03d)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83fa10ac&nbsp; type:&nbsp; #items:1&nbsp; trans:0x0&nbsp; q:0x434c08<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFD: cnt:1 total:1 a:0x42c6f8 len:52 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFD:&nbsp; #regs: 1&nbsp;&nbsp;&nbsp; num_extents: 3&nbsp; id: 0xffffffff81eaae90<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>LOG REC AT LSN cycle 4 block 303167 (0x4, 0x4a03f)<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>TRANS: tid:0x83fa1158&nbsp; type:INACTIV
 E&nbsp; 
nbsp; q:0x434c08<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>INO: cnt:2 total:2 a:0x42c6f8 len:52 a:0x42c760 len:96 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INODE: #regs:2&nbsp;&nbsp; ino:0x40609b52&nbsp; flags:0x1&nbsp;&nbsp; dsize:0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CORE inode:<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>BUF: cnt:2 total:2 a:0x42c7c8 len:28 a:0x42ca48 len:128 <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUF:&nbsp; #regs:2&nbsp;&nbsp; start blkno:0x157aba00&nbsp;&nbsp; len:8&nbsp;&nbsp; bmap size:2&nbsp; <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>flags:0x0<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUF DATA<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>EFI: cnt:1
  total:1
/o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EFI:&nbsp; #regs:1&nbsp;&nbsp;&nbsp; num_extents:2&nbsp; id:0xffffffff8239e058<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (s: 0x46bfa43, l: 752) (s: 0x46bfdef, l: 1128) <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>===============================================================================<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US>Regards,<o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US>Ryan. <o:p></o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p><p class=MsoNormal><span lang=EN-US><o:p>&nbsp;</o:p></span></p></div></body></html>

--Boundary_(ID_ukvDY3C06QY6i2VrXCthQQ)--


--===============6543077400249762475==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6543077400249762475==--
