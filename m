Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B58A7F90
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 04:07:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8714AC006
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 02:07:35 -0700 (PDT)
Received: from mail-vn0-f43.google.com (mail-vn0-f43.google.com
	[209.85.216.43]) by cuda.sgi.com with ESMTP id lt65YSxTzOHajzFg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jul 2015 02:07:30 -0700 (PDT)
Received: by vnbg190 with SMTP id g190so14612564vnb.13
	for <xfs@oss.sgi.com>; Fri, 03 Jul 2015 02:07:29 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Jul 2015 05:07:29 -0400
Message-ID: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
Subject: Failing XFS filesystem underlying Ceph OSDs
From: Alex Gorbachev <ag@iss-integration.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5999564450861952362=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5999564450861952362==
Content-Type: multipart/alternative; boundary=20cf302ef3caaa8f5f0519f4e22d

--20cf302ef3caaa8f5f0519f4e22d
Content-Type: text/plain; charset=UTF-8

Hello, we are seeing this and similar errors on multiple Supermicro nodes
running Ceph.  OS is Ubuntu 14.04.2 with kernel 4.1

Thank you for any info and troubleshooting advice.

Alex Gorbachev

Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.261899] BUG: unable to handle
kernel paging request at 000000190000001c
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.261923] IP:
[<ffffffff8118e476>] find_get_entries+0x66/0x160
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.261941] PGD 1035954067 PUD 0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.261955] Oops: 0000 [#1] SMP
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.261969] Modules linked in:
xfs libcrc32c ipmi_ssif intel_rapl iosf_mbi x86_pkg_temp_thermal
intel_powerclamp coretemp kvm crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd sb_edac edac_core lpc_ich joydev mei_me mei ioatdma wmi
8021q ipmi_si garp 8250_fintek mrp ipmi_msghandler stp llc bonding mac_hid
lp parport mlx4_en vxlan ip6_udp_tunnel udp_tunnel hid_generic usbhid hid
igb ahci mpt2sas mlx4_core i2c_algo_bit libahci dca raid_class ptp
scsi_transport_sas pps_core arcmsr
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262182] CPU: 10 PID: 8711
Comm: ceph-osd Not tainted 4.1.0-040100-generic #201506220235
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262197] Hardware name:
Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262215] task:
ffff8800721f1420 ti: ffff880fbad54000 task.ti: ffff880fbad54000
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262229] RIP:
0010:[<ffffffff8118e476>]  [<ffffffff8118e476>] find_get_entries+0x66/0x160
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262248] RSP:
0018:ffff880fbad571a8  EFLAGS: 00010246
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262258] RAX: ffff880004000158
RBX: 000000000000000e RCX: 0000000000000000
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262303] RDX: ffff880004000158
RSI: ffff880fbad571c0 RDI: 0000001900000000
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262347] RBP: ffff880fbad57208
R08: 00000000000000c0 R09: 00000000000000ff
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262391] R10: 0000000000000000
R11: 0000000000000220 R12: 00000000000000b6
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262435] R13: ffff880fbad57268
R14: 000000000000000a R15: ffff880fbad572d8
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262479] FS:
 00007f98cb0e0700(0000) GS:ffff88103f480000(0000) knlGS:0000000000000000
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262524] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262551] CR2: 000000190000001c
CR3: 0000001034f0e000 CR4: 00000000000407e0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262596] Stack:
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262618]  ffff880fbad571f8
ffff880cf6076b30 ffff880bdde05da8 00000000000000e6
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262669]  0000000000000100
ffff880cf6076b28 00000000000000b5 ffff880fbad57258
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262721]  ffff880fbad57258
ffff880fbad572d8 ffffffffffffffff ffff880cf6076b28
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262772] Call Trace:
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262801]  [<ffffffff8119b482>]
pagevec_lookup_entries+0x22/0x30
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262831]  [<ffffffff8119bd84>]
truncate_inode_pages_range+0xf4/0x700
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262862]  [<ffffffff8119c415>]
truncate_inode_pages+0x15/0x20
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262891]  [<ffffffff8119c53f>]
truncate_inode_pages_final+0x5f/0xa0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262949]  [<ffffffffc0431c2c>]
xfs_fs_evict_inode+0x3c/0xe0 [xfs]
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.262981]  [<ffffffff81220558>]
evict+0xb8/0x190
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263009]  [<ffffffff81220671>]
dispose_list+0x41/0x50
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263037]  [<ffffffff8122176f>]
prune_icache_sb+0x4f/0x60
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263067]  [<ffffffff81208ab5>]
super_cache_scan+0x155/0x1a0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263096]  [<ffffffff8119d26f>]
do_shrink_slab+0x13f/0x2c0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263126]  [<ffffffff811a22b0>]
? shrink_lruvec+0x330/0x370
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263157]  [<ffffffff811b4189>]
? isolate_migratepages_block+0x299/0x5c0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263188]  [<ffffffff8119d558>]
shrink_slab+0xd8/0x110
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263217]  [<ffffffff811a25bf>]
shrink_zone+0x2cf/0x300
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263246]  [<ffffffff811b4d3d>]
? compact_zone+0x7d/0x4f0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263275]  [<ffffffff811a2a64>]
shrink_zones+0x104/0x2a0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263304]  [<ffffffff811b53ad>]
? compact_zone_order+0x5d/0x70
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263336]  [<ffffffff810f1666>]
? ktime_get+0x46/0xb0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263365]  [<ffffffff811a2cd7>]
do_try_to_free_pages+0xd7/0x160
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263396]  [<ffffffff811a3017>]
try_to_free_pages+0xb7/0x170
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263427]  [<ffffffff8119571a>]
__alloc_pages_nodemask+0x5ba/0x9c0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263460]  [<ffffffff811dc9bc>]
alloc_pages_current+0x9c/0x110
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263492]  [<ffffffff811e4f2a>]
allocate_slab+0x20a/0x2e0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263522]  [<ffffffff811e5031>]
new_slab+0x31/0x1f0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263553]  [<ffffffff817f8dd9>]
__slab_alloc+0x18e/0x2a3
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263584]  [<ffffffff816d7817>]
? __alloc_skb+0x87/0x2b0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263614]  [<ffffffff816d77e7>]
? __alloc_skb+0x57/0x2b0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263643]  [<ffffffff811e9b7b>]
__kmalloc_node_track_caller+0xbb/0x2b0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263675]  [<ffffffff816d7817>]
? __alloc_skb+0x87/0x2b0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263704]  [<ffffffff816d737c>]
__kmalloc_reserve.isra.57+0x3c/0xa0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263734]  [<ffffffff816d7817>]
__alloc_skb+0x87/0x2b0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263766]  [<ffffffff81737de1>]
sk_stream_alloc_skb+0x41/0x130
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263796]  [<ffffffff817388b3>]
tcp_sendmsg+0x2d3/0xa90
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263827]  [<ffffffff81764477>]
inet_sendmsg+0x67/0xa0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263858]  [<ffffffff816cea54>]
? copy_msghdr_from_user+0x154/0x1b0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263891]  [<ffffffff816cdcfd>]
sock_sendmsg+0x4d/0x60
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263920]  [<ffffffff816cef93>]
___sys_sendmsg+0x2b3/0x2c0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263950]  [<ffffffff810a853c>]
? ttwu_do_wakeup+0x2c/0x100
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.263979]  [<ffffffff810a8826>]
? ttwu_do_activate.constprop.121+0x66/0x70
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264011]  [<ffffffff810abef5>]
? try_to_wake_up+0x215/0x2a0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264040]  [<ffffffff810abfb0>]
? wake_up_state+0x10/0x20
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264071]  [<ffffffff810fce86>]
? wake_futex+0x76/0xb0
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264099]  [<ffffffff810fe192>]
? futex_wake+0x72/0x140
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264127]  [<ffffffff81222675>]
? __fget_light+0x25/0x70
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264155]  [<ffffffff816cf9b9>]
__sys_sendmsg+0x49/0x90
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264184]  [<ffffffff816cfa19>]
SyS_sendmsg+0x19/0x20
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264215]  [<ffffffff8180d272>]
system_call_fastpath+0x16/0x75
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264243] Code: 00 4c 89 65 c0
31 d2 e9 86 00 00 00 66 0f 1f 84 00 00 00 00 00 48 8b 3a 48 85 ff 0f 84 ad
00 00 00 40 f6 c7 03 0f 85 a9 00 00 00 <8b> 4f 1c 85 c9 74 e3 8d 71 01 4c
8d 47 1c 89 c8 f0 0f b1 77 1c
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264467] RIP
 [<ffffffff8118e476>] find_get_entries+0x66/0x160
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264499]  RSP
<ffff880fbad571a8>
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264522] CR2: 000000190000001c
Jul  3 03:42:06 roc-4r-sca020 kernel: [554036.264824] ---[ end trace
ae271fe24c8d817e ]---

--20cf302ef3caaa8f5f0519f4e22d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello, we are seeing this and similar errors on multiple S=
upermicro nodes running Ceph.=C2=A0 OS is Ubuntu 14.04.2 with kernel 4.1<di=
v><br></div><div>Thank you for any info and troubleshooting advice.</div><d=
iv><br></div><div>Alex Gorbachev</div><div><br></div><div><div>Jul =C2=A03 =
03:42:06 roc-4r-sca020 kernel: [554036.261899] BUG: unable to handle kernel=
 paging request at 000000190000001c</div><div>Jul =C2=A03 03:42:06 roc-4r-s=
ca020 kernel: [554036.261923] IP: [&lt;ffffffff8118e476&gt;] find_get_entri=
es+0x66/0x160</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.=
261941] PGD 1035954067 PUD 0=C2=A0</div><div>Jul =C2=A03 03:42:06 roc-4r-sc=
a020 kernel: [554036.261955] Oops: 0000 [#1] SMP=C2=A0</div><div>Jul =C2=A0=
3 03:42:06 roc-4r-sca020 kernel: [554036.261969] Modules linked in: xfs lib=
crc32c ipmi_ssif intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp =
coretemp kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel =
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac edac_core lp=
c_ich joydev mei_me mei ioatdma wmi 8021q ipmi_si garp 8250_fintek mrp ipmi=
_msghandler stp llc bonding mac_hid lp parport mlx4_en vxlan ip6_udp_tunnel=
 udp_tunnel hid_generic usbhid hid igb ahci mpt2sas mlx4_core i2c_algo_bit =
libahci dca raid_class ptp scsi_transport_sas pps_core arcmsr</div><div>Jul=
 =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262182] CPU: 10 PID: 8711 C=
omm: ceph-osd Not tainted 4.1.0-040100-generic #201506220235</div><div>Jul =
=C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262197] Hardware name: Super=
micro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013</div><d=
iv>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262215] task: ffff880=
0721f1420 ti: ffff880fbad54000 task.ti: ffff880fbad54000</div><div>Jul =C2=
=A03 03:42:06 roc-4r-sca020 kernel: [554036.262229] RIP: 0010:[&lt;ffffffff=
8118e476&gt;] =C2=A0[&lt;ffffffff8118e476&gt;] find_get_entries+0x66/0x160<=
/div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262248] RSP: 0=
018:ffff880fbad571a8 =C2=A0EFLAGS: 00010246</div><div>Jul =C2=A03 03:42:06 =
roc-4r-sca020 kernel: [554036.262258] RAX: ffff880004000158 RBX: 0000000000=
00000e RCX: 0000000000000000</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 k=
ernel: [554036.262303] RDX: ffff880004000158 RSI: ffff880fbad571c0 RDI: 000=
0001900000000</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.=
262347] RBP: ffff880fbad57208 R08: 00000000000000c0 R09: 00000000000000ff</=
div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262391] R10: 00=
00000000000000 R11: 0000000000000220 R12: 00000000000000b6</div><div>Jul =
=C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262435] R13: ffff880fbad5726=
8 R14: 000000000000000a R15: ffff880fbad572d8</div><div>Jul =C2=A03 03:42:0=
6 roc-4r-sca020 kernel: [554036.262479] FS: =C2=A000007f98cb0e0700(0000) GS=
:ffff88103f480000(0000) knlGS:0000000000000000</div><div>Jul =C2=A03 03:42:=
06 roc-4r-sca020 kernel: [554036.262524] CS: =C2=A00010 DS: 0000 ES: 0000 C=
R0: 0000000080050033</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [=
554036.262551] CR2: 000000190000001c CR3: 0000001034f0e000 CR4: 00000000000=
407e0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262596] =
Stack:</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262618]=
 =C2=A0ffff880fbad571f8 ffff880cf6076b30 ffff880bdde05da8 00000000000000e6<=
/div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262669] =C2=A0=
0000000000000100 ffff880cf6076b28 00000000000000b5 ffff880fbad57258</div><d=
iv>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262721] =C2=A0ffff880=
fbad57258 ffff880fbad572d8 ffffffffffffffff ffff880cf6076b28</div><div>Jul =
=C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262772] Call Trace:</div><di=
v>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262801] =C2=A0[&lt;fff=
fffff8119b482&gt;] pagevec_lookup_entries+0x22/0x30</div><div>Jul =C2=A03 0=
3:42:06 roc-4r-sca020 kernel: [554036.262831] =C2=A0[&lt;ffffffff8119bd84&g=
t;] truncate_inode_pages_range+0xf4/0x700</div><div>Jul =C2=A03 03:42:06 ro=
c-4r-sca020 kernel: [554036.262862] =C2=A0[&lt;ffffffff8119c415&gt;] trunca=
te_inode_pages+0x15/0x20</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kerne=
l: [554036.262891] =C2=A0[&lt;ffffffff8119c53f&gt;] truncate_inode_pages_fi=
nal+0x5f/0xa0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.=
262949] =C2=A0[&lt;ffffffffc0431c2c&gt;] xfs_fs_evict_inode+0x3c/0xe0 [xfs]=
</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.262981] =C2=
=A0[&lt;ffffffff81220558&gt;] evict+0xb8/0x190</div><div>Jul =C2=A03 03:42:=
06 roc-4r-sca020 kernel: [554036.263009] =C2=A0[&lt;ffffffff81220671&gt;] d=
ispose_list+0x41/0x50</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: =
[554036.263037] =C2=A0[&lt;ffffffff8122176f&gt;] prune_icache_sb+0x4f/0x60<=
/div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263067] =C2=A0=
[&lt;ffffffff81208ab5&gt;] super_cache_scan+0x155/0x1a0</div><div>Jul =C2=
=A03 03:42:06 roc-4r-sca020 kernel: [554036.263096] =C2=A0[&lt;ffffffff8119=
d26f&gt;] do_shrink_slab+0x13f/0x2c0</div><div>Jul =C2=A03 03:42:06 roc-4r-=
sca020 kernel: [554036.263126] =C2=A0[&lt;ffffffff811a22b0&gt;] ? shrink_lr=
uvec+0x330/0x370</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [5540=
36.263157] =C2=A0[&lt;ffffffff811b4189&gt;] ? isolate_migratepages_block+0x=
299/0x5c0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.2631=
88] =C2=A0[&lt;ffffffff8119d558&gt;] shrink_slab+0xd8/0x110</div><div>Jul =
=C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263217] =C2=A0[&lt;ffffffff8=
11a25bf&gt;] shrink_zone+0x2cf/0x300</div><div>Jul =C2=A03 03:42:06 roc-4r-=
sca020 kernel: [554036.263246] =C2=A0[&lt;ffffffff811b4d3d&gt;] ? compact_z=
one+0x7d/0x4f0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036=
.263275] =C2=A0[&lt;ffffffff811a2a64&gt;] shrink_zones+0x104/0x2a0</div><di=
v>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263304] =C2=A0[&lt;fff=
fffff811b53ad&gt;] ? compact_zone_order+0x5d/0x70</div><div>Jul =C2=A03 03:=
42:06 roc-4r-sca020 kernel: [554036.263336] =C2=A0[&lt;ffffffff810f1666&gt;=
] ? ktime_get+0x46/0xb0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel=
: [554036.263365] =C2=A0[&lt;ffffffff811a2cd7&gt;] do_try_to_free_pages+0xd=
7/0x160</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263396=
] =C2=A0[&lt;ffffffff811a3017&gt;] try_to_free_pages+0xb7/0x170</div><div>J=
ul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263427] =C2=A0[&lt;ffffff=
ff8119571a&gt;] __alloc_pages_nodemask+0x5ba/0x9c0</div><div>Jul =C2=A03 03=
:42:06 roc-4r-sca020 kernel: [554036.263460] =C2=A0[&lt;ffffffff811dc9bc&gt=
;] alloc_pages_current+0x9c/0x110</div><div>Jul =C2=A03 03:42:06 roc-4r-sca=
020 kernel: [554036.263492] =C2=A0[&lt;ffffffff811e4f2a&gt;] allocate_slab+=
0x20a/0x2e0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.26=
3522] =C2=A0[&lt;ffffffff811e5031&gt;] new_slab+0x31/0x1f0</div><div>Jul =
=C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263553] =C2=A0[&lt;ffffffff8=
17f8dd9&gt;] __slab_alloc+0x18e/0x2a3</div><div>Jul =C2=A03 03:42:06 roc-4r=
-sca020 kernel: [554036.263584] =C2=A0[&lt;ffffffff816d7817&gt;] ? __alloc_=
skb+0x87/0x2b0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036=
.263614] =C2=A0[&lt;ffffffff816d77e7&gt;] ? __alloc_skb+0x57/0x2b0</div><di=
v>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263643] =C2=A0[&lt;fff=
fffff811e9b7b&gt;] __kmalloc_node_track_caller+0xbb/0x2b0</div><div>Jul =C2=
=A03 03:42:06 roc-4r-sca020 kernel: [554036.263675] =C2=A0[&lt;ffffffff816d=
7817&gt;] ? __alloc_skb+0x87/0x2b0</div><div>Jul =C2=A03 03:42:06 roc-4r-sc=
a020 kernel: [554036.263704] =C2=A0[&lt;ffffffff816d737c&gt;] __kmalloc_res=
erve.isra.57+0x3c/0xa0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel:=
 [554036.263734] =C2=A0[&lt;ffffffff816d7817&gt;] __alloc_skb+0x87/0x2b0</d=
iv><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263766] =C2=A0[&=
lt;ffffffff81737de1&gt;] sk_stream_alloc_skb+0x41/0x130</div><div>Jul =C2=
=A03 03:42:06 roc-4r-sca020 kernel: [554036.263796] =C2=A0[&lt;ffffffff8173=
88b3&gt;] tcp_sendmsg+0x2d3/0xa90</div><div>Jul =C2=A03 03:42:06 roc-4r-sca=
020 kernel: [554036.263827] =C2=A0[&lt;ffffffff81764477&gt;] inet_sendmsg+0=
x67/0xa0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.26385=
8] =C2=A0[&lt;ffffffff816cea54&gt;] ? copy_msghdr_from_user+0x154/0x1b0</di=
v><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263891] =C2=A0[&l=
t;ffffffff816cdcfd&gt;] sock_sendmsg+0x4d/0x60</div><div>Jul =C2=A03 03:42:=
06 roc-4r-sca020 kernel: [554036.263920] =C2=A0[&lt;ffffffff816cef93&gt;] _=
__sys_sendmsg+0x2b3/0x2c0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kern=
el: [554036.263950] =C2=A0[&lt;ffffffff810a853c&gt;] ? ttwu_do_wakeup+0x2c/=
0x100</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.263979] =
=C2=A0[&lt;ffffffff810a8826&gt;] ? ttwu_do_activate.constprop.121+0x66/0x70=
</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.264011] =C2=
=A0[&lt;ffffffff810abef5&gt;] ? try_to_wake_up+0x215/0x2a0</div><div>Jul =
=C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.264040] =C2=A0[&lt;ffffffff8=
10abfb0&gt;] ? wake_up_state+0x10/0x20</div><div>Jul =C2=A03 03:42:06 roc-4=
r-sca020 kernel: [554036.264071] =C2=A0[&lt;ffffffff810fce86&gt;] ? wake_fu=
tex+0x76/0xb0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.=
264099] =C2=A0[&lt;ffffffff810fe192&gt;] ? futex_wake+0x72/0x140</div><div>=
Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.264127] =C2=A0[&lt;fffff=
fff81222675&gt;] ? __fget_light+0x25/0x70</div><div>Jul =C2=A03 03:42:06 ro=
c-4r-sca020 kernel: [554036.264155] =C2=A0[&lt;ffffffff816cf9b9&gt;] __sys_=
sendmsg+0x49/0x90</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554=
036.264184] =C2=A0[&lt;ffffffff816cfa19&gt;] SyS_sendmsg+0x19/0x20</div><di=
v>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.264215] =C2=A0[&lt;fff=
fffff8180d272&gt;] system_call_fastpath+0x16/0x75</div><div>Jul =C2=A03 03:=
42:06 roc-4r-sca020 kernel: [554036.264243] Code: 00 4c 89 65 c0 31 d2 e9 8=
6 00 00 00 66 0f 1f 84 00 00 00 00 00 48 8b 3a 48 85 ff 0f 84 ad 00 00 00 4=
0 f6 c7 03 0f 85 a9 00 00 00 &lt;8b&gt; 4f 1c 85 c9 74 e3 8d 71 01 4c 8d 47=
 1c 89 c8 f0 0f b1 77 1c=C2=A0</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020=
 kernel: [554036.264467] RIP =C2=A0[&lt;ffffffff8118e476&gt;] find_get_entr=
ies+0x66/0x160</div><div>Jul =C2=A03 03:42:06 roc-4r-sca020 kernel: [554036=
.264499] =C2=A0RSP &lt;ffff880fbad571a8&gt;</div><div>Jul =C2=A03 03:42:06 =
roc-4r-sca020 kernel: [554036.264522] CR2: 000000190000001c</div><div>Jul =
=C2=A03 03:42:06 roc-4r-sca020 kernel: [554036.264824] ---[ end trace ae271=
fe24c8d817e ]---</div></div></div>

--20cf302ef3caaa8f5f0519f4e22d--


--===============5999564450861952362==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5999564450861952362==--
