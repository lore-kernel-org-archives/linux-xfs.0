Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8IIYid157174 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 12:18:34 -0600
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 952E31A4684D
	for <xfs@oss.sgi.com>; Thu,  8 Dec 2011 10:03:52 -0800 (PST)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id AdEH7yNJW3yhmXBB
	for <xfs@oss.sgi.com>; Thu, 08 Dec 2011 10:03:52 -0800 (PST)
Received: by faaa5 with SMTP id a5so650579faa.26
	for <xfs@oss.sgi.com>; Thu, 08 Dec 2011 10:03:52 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Dec 2011 13:03:51 -0500
Message-ID: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
Subject: XFS causing stack overflow
From: "Ryan C. England" <ryan.england@corvidtec.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0726831706669447876=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0726831706669447876==
Content-Type: multipart/alternative; boundary=f46d04428800ae2df304b3987d7b

--f46d04428800ae2df304b3987d7b
Content-Type: text/plain; charset=ISO-8859-1

I am looking for assistance on XFS which is why I have joined this mailing
list.  I'm receiving a stack overflow on our file server.  The server is
running Scientific Linux 6.1 with the following kernel,
2.6.32-131.21.1.el6.x86_64.

This is causing random reboots which is more annoying than anything.  I
found a couple of links in the archives but wasn't quite sure how to apply
this patch.  I can provide whatever information necessary in order for
assistance in troubleshooting.

Thank you

http://oss.sgi.com/archives/xfs/2011-03/msg00399.html
http://oss.sgi.com/archives/xfs/2010-05/msg00385.html
http://oss.sgi.com/archives/xfs/2010-06/msg00312.html

Dec  6 20:27:55 localhost kernel: ------------[ cut here ]------------
Dec  6 20:27:55 localhost kernel: WARNING: at arch/x86/kernel/irq_64.c:47
handle_irq+0x8f/0xa0() (Not tainted)
Dec  6 20:27:55 localhost kernel: Hardware name: X8DTH-i/6/iF/6F
Dec  6 20:27:55 localhost kernel: do_IRQ: nfsd near stack overflow
(cur:ffff880622208000,sp:ffff880622208160)
Dec  6 20:27:55 localhost kernel: Modules linked in: mpt2sas
scsi_transport_sas raid_class mptctl mptbase nfsd lockd nfs_acl auth_rpcgss
autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables ipv6 xfs exportfs dm_mirror dm_region_hash dm_log ses enclosure
ixgbe mdio microcode igb serio_raw ghes hed i2c_i801 i2c_core sg iTCO_wdt
iTCO_vendor_support ioatdma dca i7core_edac edac_core shpchp ext4 mbcache
jbd2 megaraid_sas(U) sd_mod crc_t10dif ahci dm_mod [last unloaded:
scsi_wait_scan]
Dec  6 20:27:55 localhost kernel: Pid: 2898, comm: nfsd Not tainted
2.6.32-131.21.1.el6.x86_64 #1
Dec  6 20:27:55 localhost kernel: Call Trace:
Dec  6 20:27:55 localhost kernel: <IRQ>  [<ffffffff81067097>] ?
warn_slowpath_common+0x87/0xc0
Dec  6 20:27:55 localhost kernel: [<ffffffff8106f6da>] ?
__do_softirq+0x11a/0x1d0
Dec  6 20:27:55 localhost kernel: [<ffffffff81067186>] ?
warn_slowpath_fmt+0x46/0x50
Dec  6 20:27:55 localhost kernel: [<ffffffff8100c2cc>] ?
call_softirq+0x1c/0x30
Dec  6 20:27:55 localhost kernel: [<ffffffff8100dfcf>] ?
handle_irq+0x8f/0xa0
Dec  6 20:27:55 localhost kernel: [<ffffffff814e310c>] ? do_IRQ+0x6c/0xf0
Dec  6 20:27:55 localhost kernel: [<ffffffff8100bad3>] ?
ret_from_intr+0x0/0x11
Dec  6 20:27:55 localhost kernel: <EOI>  [<ffffffff8115b80f>] ?
kmem_cache_free+0xbf/0x2b0
Dec  6 20:27:55 localhost kernel: [<ffffffff811a2542>] ?
free_buffer_head+0x22/0x50
Dec  6 20:27:55 localhost kernel: [<ffffffff811a2919>] ?
try_to_free_buffers+0x79/0xc0
Dec  6 20:27:55 localhost kernel: [<ffffffffa0259a9c>] ?
xfs_vm_releasepage+0xbc/0x130 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff8110c6c0>] ?
try_to_release_page+0x30/0x60
Dec  6 20:27:55 localhost kernel: [<ffffffff811262c1>] ?
shrink_page_list.clone.0+0x4f1/0x5c0
Dec  6 20:27:55 localhost kernel: [<ffffffff81126688>] ?
shrink_inactive_list+0x2f8/0x740
Dec  6 20:27:55 localhost kernel: [<ffffffff8111f7f6>] ?
free_pcppages_bulk+0x2b6/0x390
Dec  6 20:27:55 localhost kernel: [<ffffffff811278df>] ?
shrink_zone+0x38f/0x520
Dec  6 20:27:55 localhost kernel: [<ffffffff811646f8>] ?
__mem_cgroup_uncharge_common+0x198/0x270
Dec  6 20:27:55 localhost kernel: [<ffffffff81128684>] ?
zone_reclaim+0x354/0x410
Dec  6 20:27:55 localhost kernel: [<ffffffff811292c0>] ?
isolate_pages_global+0x0/0x380
Dec  6 20:27:55 localhost kernel: [<ffffffff8111ebf4>] ?
get_page_from_freelist+0x694/0x820
Dec  6 20:27:55 localhost kernel: [<ffffffff81126882>] ?
shrink_inactive_list+0x4f2/0x740
Dec  6 20:27:55 localhost kernel: [<ffffffff8111fb01>] ?
__alloc_pages_nodemask+0x111/0x8b0
Dec  6 20:27:55 localhost kernel: [<ffffffff8110d17e>] ?
find_get_page+0x1e/0xa0
Dec  6 20:27:55 localhost kernel: [<ffffffff8110e307>] ?
find_lock_page+0x37/0x80
Dec  6 20:27:55 localhost kernel: [<ffffffff811546da>] ?
alloc_pages_current+0xaa/0x110
Dec  6 20:27:55 localhost kernel: [<ffffffff8110d6b7>] ?
__page_cache_alloc+0x87/0x90
Dec  6 20:27:55 localhost kernel: [<ffffffff8110e45f>] ?
find_or_create_page+0x4f/0xb0
Dec  6 20:27:55 localhost kernel: [<ffffffffa025b945>] ?
_xfs_buf_lookup_pages+0x145/0x360 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa025b2ab>] ?
_xfs_buf_initialize+0xcb/0x140 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa025cb57>] ?
xfs_buf_get+0x77/0x1b0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa025ccbc>] ?
xfs_buf_read+0x2c/0x100 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa0250e39>] ?
xfs_trans_read_buf+0x219/0x440 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021efde>] ?
xfs_btree_read_buf_block+0x5e/0xc0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021f6d4>] ?
xfs_btree_lookup_get_block+0x84/0xf0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021d64c>] ?
xfs_btree_ptr_offset+0x4c/0x90 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021fd5f>] ?
xfs_btree_lookup+0xbf/0x470 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa0209cfa>] ?
xfs_alloc_ag_vextent_near+0x98a/0xb70 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa0250afd>] ?
xfs_trans_log_buf+0x9d/0xe0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021348f>] ?
xfs_bmbt_lookup_eq+0x1f/0x30 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021a2e4>] ?
xfs_bmap_add_extent_delay_real+0xe54/0x18d0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa025737a>] ?
kmem_zone_alloc+0x9a/0xe0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa01ff009>] ?
xfs_trans_mod_dquot_byino+0x79/0xd0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021b15f>] ?
xfs_bmap_add_extent+0x3ff/0x420 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021ce7a>] ?
xfs_bmbt_init_cursor+0x4a/0x150 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa021bc94>] ?
xfs_bmapi+0xb14/0x11a0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff814dc986>] ?
down_write+0x16/0x40
Dec  6 20:27:55 localhost kernel: [<ffffffffa023ddd5>] ?
xfs_iomap_write_allocate+0x1c5/0x3b0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff81248a9e>] ?
generic_make_request+0x21e/0x5b0
Dec  6 20:27:55 localhost kernel: [<ffffffffa023eb19>] ?
xfs_iomap+0x389/0x440 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff8119b6ac>] ?
__mark_inode_dirty+0x6c/0x160
Dec  6 20:27:55 localhost kernel: [<ffffffffa0257f4d>] ?
xfs_map_blocks+0x2d/0x40 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa0259588>] ?
xfs_page_state_convert+0x2f8/0x750 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff81268505>] ?
radix_tree_gang_lookup_tag_slot+0x95/0xe0
Dec  6 20:27:55 localhost kernel: [<ffffffffa0259b96>] ?
xfs_vm_writepage+0x86/0x170 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff81120d67>] ?
__writepage+0x17/0x40
Dec  6 20:27:55 localhost kernel: [<ffffffff811220f9>] ?
write_cache_pages+0x1c9/0x4a0
Dec  6 20:27:55 localhost kernel: [<ffffffff81120d50>] ?
__writepage+0x0/0x40
Dec  6 20:27:55 localhost kernel: [<ffffffffa023ab93>] ?
xfs_iflush+0x203/0x210 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa025af9f>] ?
xfs_bdwrite+0x5f/0xa0 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa024fe99>] ?
xfs_trans_unlocked_item+0x39/0x60 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff811223f4>] ?
generic_writepages+0x24/0x30
Dec  6 20:27:55 localhost kernel: [<ffffffffa025898e>] ?
xfs_vm_writepages+0x5e/0x80 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff81122421>] ?
do_writepages+0x21/0x40
Dec  6 20:27:55 localhost kernel: [<ffffffff8119bc8d>] ?
writeback_single_inode+0xdd/0x2c0
Dec  6 20:27:55 localhost kernel: [<ffffffff8119c08e>] ?
writeback_sb_inodes+0xce/0x180
Dec  6 20:27:55 localhost kernel: [<ffffffff8119c1eb>] ?
writeback_inodes_wb+0xab/0x1b0
Dec  6 20:27:55 localhost kernel: [<ffffffff8112181e>] ?
balance_dirty_pages+0x21e/0x4d0
Dec  6 20:27:55 localhost kernel: [<ffffffff811a3851>] ?
mark_buffer_dirty+0x61/0xa0
Dec  6 20:27:55 localhost kernel: [<ffffffff81121b34>] ?
balance_dirty_pages_ratelimited_nr+0x64/0x70
Dec  6 20:27:55 localhost kernel: [<ffffffff8110dd23>] ?
generic_file_buffered_write+0x1c3/0x2a0
Dec  6 20:27:55 localhost kernel: [<ffffffff8106dcb7>] ?
current_fs_time+0x27/0x30
Dec  6 20:27:55 localhost kernel: [<ffffffffa0261e4f>] ?
xfs_write+0x76f/0xb70 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff814174b5>] ?
memcpy_toiovec+0x55/0x80
Dec  6 20:27:55 localhost kernel: [<ffffffffa025d800>] ?
xfs_file_aio_write+0x0/0x70 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffffa025d861>] ?
xfs_file_aio_write+0x61/0x70 [xfs]
Dec  6 20:27:55 localhost kernel: [<ffffffff811723bb>] ?
do_sync_readv_writev+0xfb/0x140
Dec  6 20:27:55 localhost kernel: [<ffffffff8118ae9d>] ?
d_obtain_alias+0x4d/0x160
Dec  6 20:27:55 localhost kernel: [<ffffffff8108e120>] ?
autoremove_wake_function+0x0/0x40
Dec  6 20:27:55 localhost kernel: [<ffffffff812056b6>] ?
security_task_setgroups+0x16/0x20
Dec  6 20:27:55 localhost kernel: [<ffffffff81205356>] ?
security_file_permission+0x16/0x20
Dec  6 20:27:55 localhost kernel: [<ffffffff8117347f>] ?
do_readv_writev+0xcf/0x1f0
Dec  6 20:27:55 localhost kernel: [<ffffffffa047f852>] ?
nfsd_setuser_and_check_port+0x62/0xb0 [nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffff811735e6>] ?
vfs_writev+0x46/0x60
Dec  6 20:27:55 localhost kernel: [<ffffffffa04813d7>] ?
nfsd_vfs_write+0x107/0x430 [nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffff8116fe22>] ?
dentry_open+0x52/0xc0
Dec  6 20:27:55 localhost kernel: [<ffffffffa04839fe>] ?
nfsd_open+0x13e/0x210 [nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffffa0483e87>] ?
nfsd_write+0xe7/0x100 [nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffffa048b7df>] ?
nfsd3_proc_write+0xaf/0x140 [nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffffa047c43e>] ?
nfsd_dispatch+0xfe/0x240 [nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffffa03f24d4>] ?
svc_process_common+0x344/0x640 [sunrpc]
Dec  6 20:27:55 localhost kernel: [<ffffffff8105dbc0>] ?
default_wake_function+0x0/0x20
Dec  6 20:27:55 localhost kernel: [<ffffffffa03f2b10>] ?
svc_process+0x110/0x160 [sunrpc]
Dec  6 20:27:55 localhost kernel: [<ffffffffa047cb62>] ? nfsd+0xc2/0x160
[nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffffa047caa0>] ? nfsd+0x0/0x160
[nfsd]
Dec  6 20:27:55 localhost kernel: [<ffffffff8108ddb6>] ? kthread+0x96/0xa0
Dec  6 20:27:55 localhost kernel: [<ffffffff8100c1ca>] ? child_rip+0xa/0x20
Dec  6 20:27:55 localhost kernel: [<ffffffff8108dd20>] ? kthread+0x0/0xa0
Dec  6 20:27:55 localhost kernel: [<ffffffff8100c1c0>] ? child_rip+0x0/0x20
Dec  6 20:27:55 localhost kernel: ---[ end trace e8b62253d4084e2b ]---

-- 
Ryan C. England
Corvid Technologies <http://www.corvidtec.com/>
office: 704-799-6944 x158
cell:    980-521-2297

--f46d04428800ae2df304b3987d7b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>I am looking for assistance on XFS which is why I have joined this mai=
ling list. =A0I&#39;m receiving a stack overflow on our file server. =A0The=
 server is running Scientific Linux 6.1 with the following kernel, 2.6.32-1=
31.21.1.el6.x86_64.</div>

<div><br></div><div>This is causing random reboots which is more annoying t=
han anything. =A0I found a couple of links in the archives but wasn&#39;t q=
uite sure how to apply this patch. =A0I can provide whatever information ne=
cessary in order for assistance in troubleshooting.</div>
<div><br></div><div>Thank you</div><div><br></div><div><div style=3D"color:=
 rgb(34, 34, 34); font-family: arial, sans-serif; font-size: 13px; backgrou=
nd-color: rgba(255, 255, 255, 0.917969); "><a href=3D"http://oss.sgi.com/ar=
chives/xfs/2011-03/msg00399.html" target=3D"_blank" style=3D"color: rgb(17,=
 85, 204); ">http://oss.sgi.com/archives/xfs/2011-03/msg00399.html</a></div=
>
<div style=3D"color: rgb(34, 34, 34); font-family: arial, sans-serif; font-=
size: 13px; background-color: rgba(255, 255, 255, 0.917969); "><a href=3D"h=
ttp://oss.sgi.com/archives/xfs/2010-05/msg00385.html" target=3D"_blank" sty=
le=3D"color: rgb(17, 85, 204); ">http://oss.sgi.com/archives/xfs/2010-05/ms=
g00385.html</a></div>
<div style=3D"color: rgb(34, 34, 34); font-family: arial, sans-serif; font-=
size: 13px; background-color: rgba(255, 255, 255, 0.917969); "><a href=3D"h=
ttp://oss.sgi.com/archives/xfs/2010-06/msg00312.html" target=3D"_blank" sty=
le=3D"color: rgb(17, 85, 204); ">http://oss.sgi.com/archives/xfs/2010-06/ms=
g00312.html</a></div>
</div><div><br></div><div>Dec =A06 20:27:55 localhost kernel: ------------[=
 cut here ]------------</div><div>Dec =A06 20:27:55 localhost kernel: WARNI=
NG: at arch/x86/kernel/irq_64.c:47 handle_irq+0x8f/0xa0() (Not tainted)</di=
v>

<div>Dec =A06 20:27:55 localhost kernel: Hardware name: X8DTH-i/6/iF/6F</di=
v><div>Dec =A06 20:27:55 localhost kernel: do_IRQ: nfsd near stack overflow=
 (cur:ffff880622208000,sp:ffff880622208160)</div><div>Dec =A06 20:27:55 loc=
alhost kernel: Modules linked in: mpt2sas scsi_transport_sas raid_class mpt=
ctl mptbase nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc cpufreq_ondemand =
acpi_cpufreq freq_table ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_sta=
te nf_conntrack ip6table_filter ip6_tables ipv6 xfs exportfs dm_mirror dm_r=
egion_hash dm_log ses enclosure ixgbe mdio microcode igb serio_raw ghes hed=
 i2c_i801 i2c_core sg iTCO_wdt iTCO_vendor_support ioatdma dca i7core_edac =
edac_core shpchp ext4 mbcache jbd2 megaraid_sas(U) sd_mod crc_t10dif ahci d=
m_mod [last unloaded: scsi_wait_scan]</div>

<div>Dec =A06 20:27:55 localhost kernel: Pid: 2898, comm: nfsd Not tainted =
2.6.32-131.21.1.el6.x86_64 #1</div><div>Dec =A06 20:27:55 localhost kernel:=
 Call Trace:</div><div>Dec =A06 20:27:55 localhost kernel: &lt;IRQ&gt; =A0[=
&lt;ffffffff81067097&gt;] ? warn_slowpath_common+0x87/0xc0</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8106f6da&gt;] ? __do_=
softirq+0x11a/0x1d0</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;ffff=
ffff81067186&gt;] ? warn_slowpath_fmt+0x46/0x50</div><div>Dec =A06 20:27:55=
 localhost kernel: [&lt;ffffffff8100c2cc&gt;] ? call_softirq+0x1c/0x30</div=
>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8100dfcf&gt;] ? handl=
e_irq+0x8f/0xa0</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff=
814e310c&gt;] ? do_IRQ+0x6c/0xf0</div><div>Dec =A06 20:27:55 localhost kern=
el: [&lt;ffffffff8100bad3&gt;] ? ret_from_intr+0x0/0x11</div>

<div>Dec =A06 20:27:55 localhost kernel: &lt;EOI&gt; =A0[&lt;ffffffff8115b8=
0f&gt;] ? kmem_cache_free+0xbf/0x2b0</div><div>Dec =A06 20:27:55 localhost =
kernel: [&lt;ffffffff811a2542&gt;] ? free_buffer_head+0x22/0x50</div><div>D=
ec =A06 20:27:55 localhost kernel: [&lt;ffffffff811a2919&gt;] ? try_to_free=
_buffers+0x79/0xc0</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa0259a9c&gt;] ? xfs_v=
m_releasepage+0xbc/0x130 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel=
: [&lt;ffffffff8110c6c0&gt;] ? try_to_release_page+0x30/0x60</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffff811262c1&gt;] ? shrink_page_li=
st.clone.0+0x4f1/0x5c0</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff81126688&gt;] ? shrin=
k_inactive_list+0x2f8/0x740</div><div>Dec =A06 20:27:55 localhost kernel: [=
&lt;ffffffff8111f7f6&gt;] ? free_pcppages_bulk+0x2b6/0x390</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffff811278df&gt;] ? shrink_zone+0x=
38f/0x520</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff811646f8&gt;] ? __mem=
_cgroup_uncharge_common+0x198/0x270</div><div>Dec =A06 20:27:55 localhost k=
ernel: [&lt;ffffffff81128684&gt;] ? zone_reclaim+0x354/0x410</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffff811292c0&gt;] ? isolate_pages_=
global+0x0/0x380</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8111ebf4&gt;] ? get_p=
age_from_freelist+0x694/0x820</div><div>Dec =A06 20:27:55 localhost kernel:=
 [&lt;ffffffff81126882&gt;] ? shrink_inactive_list+0x4f2/0x740</div><div>De=
c =A06 20:27:55 localhost kernel: [&lt;ffffffff8111fb01&gt;] ? __alloc_page=
s_nodemask+0x111/0x8b0</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8110d17e&gt;] ? find_=
get_page+0x1e/0xa0</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;fffff=
fff8110e307&gt;] ? find_lock_page+0x37/0x80</div><div>Dec =A06 20:27:55 loc=
alhost kernel: [&lt;ffffffff811546da&gt;] ? alloc_pages_current+0xaa/0x110<=
/div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8110d6b7&gt;] ? __pag=
e_cache_alloc+0x87/0x90</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;=
ffffffff8110e45f&gt;] ? find_or_create_page+0x4f/0xb0</div><div>Dec =A06 20=
:27:55 localhost kernel: [&lt;ffffffffa025b945&gt;] ? _xfs_buf_lookup_pages=
+0x145/0x360 [xfs]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa025b2ab&gt;] ? _xfs_=
buf_initialize+0xcb/0x140 [xfs]</div><div>Dec =A06 20:27:55 localhost kerne=
l: [&lt;ffffffffa025cb57&gt;] ? xfs_buf_get+0x77/0x1b0 [xfs]</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffffa025ccbc&gt;] ? xfs_buf_read+0=
x2c/0x100 [xfs]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa0250e39&gt;] ? xfs_t=
rans_read_buf+0x219/0x440 [xfs]</div><div>Dec =A06 20:27:55 localhost kerne=
l: [&lt;ffffffffa021efde&gt;] ? xfs_btree_read_buf_block+0x5e/0xc0 [xfs]</d=
iv>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa021f6d4&gt;] ? xfs_b=
tree_lookup_get_block+0x84/0xf0 [xfs]</div><div>Dec =A06 20:27:55 localhost=
 kernel: [&lt;ffffffffa021d64c&gt;] ? xfs_btree_ptr_offset+0x4c/0x90 [xfs]<=
/div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa021fd5f&gt;] ? xfs_b=
tree_lookup+0xbf/0x470 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel: =
[&lt;ffffffffa0209cfa&gt;] ? xfs_alloc_ag_vextent_near+0x98a/0xb70 [xfs]</d=
iv>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa0250afd&gt;] ? xfs_t=
rans_log_buf+0x9d/0xe0 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel: =
[&lt;ffffffffa021348f&gt;] ? xfs_bmbt_lookup_eq+0x1f/0x30 [xfs]</div><div>
Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa021a2e4&gt;] ? xfs_bmap_a=
dd_extent_delay_real+0xe54/0x18d0 [xfs]</div>
<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa025737a&gt;] ? kmem_=
zone_alloc+0x9a/0xe0 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel: [&=
lt;ffffffffa01ff009&gt;] ? xfs_trans_mod_dquot_byino+0x79/0xd0 [xfs]</div>
<div>
Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa021b15f&gt;] ? xfs_bmap_a=
dd_extent+0x3ff/0x420 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel: [=
&lt;ffffffffa021ce7a&gt;] ? xfs_bmbt_init_cursor+0x4a/0x150 [xfs]</div><div=
>

Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa021bc94&gt;] ? xfs_bmapi+=
0xb14/0x11a0 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;fffff=
fff814dc986&gt;] ? down_write+0x16/0x40</div><div>Dec =A06 20:27:55 localho=
st kernel: [&lt;ffffffffa023ddd5&gt;] ? xfs_iomap_write_allocate+0x1c5/0x3b=
0 [xfs]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff81248a9e&gt;] ? gener=
ic_make_request+0x21e/0x5b0</div><div>Dec =A06 20:27:55 localhost kernel: [=
&lt;ffffffffa023eb19&gt;] ? xfs_iomap+0x389/0x440 [xfs]</div><div>Dec =A06 =
20:27:55 localhost kernel: [&lt;ffffffff8119b6ac&gt;] ? __mark_inode_dirty+=
0x6c/0x160</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa0257f4d&gt;] ? xfs_m=
ap_blocks+0x2d/0x40 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel: [&l=
t;ffffffffa0259588&gt;] ? xfs_page_state_convert+0x2f8/0x750 [xfs]</div><di=
v>

Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff81268505&gt;] ? radix_tree=
_gang_lookup_tag_slot+0x95/0xe0</div><div>Dec =A06 20:27:55 localhost kerne=
l: [&lt;ffffffffa0259b96&gt;] ? xfs_vm_writepage+0x86/0x170 [xfs]</div><div=
>

Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff81120d67&gt;] ? __writepag=
e+0x17/0x40</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8112=
20f9&gt;] ? write_cache_pages+0x1c9/0x4a0</div><div>Dec =A06 20:27:55 local=
host kernel: [&lt;ffffffff81120d50&gt;] ? __writepage+0x0/0x40</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa023ab93&gt;] ? xfs_i=
flush+0x203/0x210 [xfs]</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;=
ffffffffa025af9f&gt;] ? xfs_bdwrite+0x5f/0xa0 [xfs]</div><div>Dec =A06 20:2=
7:55 localhost kernel: [&lt;ffffffffa024fe99&gt;] ? xfs_trans_unlocked_item=
+0x39/0x60 [xfs]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff811223f4&gt;] ? gener=
ic_writepages+0x24/0x30</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;=
ffffffffa025898e&gt;] ? xfs_vm_writepages+0x5e/0x80 [xfs]</div><div>Dec =A0=
6 20:27:55 localhost kernel: [&lt;ffffffff81122421&gt;] ? do_writepages+0x2=
1/0x40</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8119bc8d&gt;] ? write=
back_single_inode+0xdd/0x2c0</div><div>Dec =A06 20:27:55 localhost kernel: =
[&lt;ffffffff8119c08e&gt;] ? writeback_sb_inodes+0xce/0x180</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffff8119c1eb&gt;] ? writeback_inod=
es_wb+0xab/0x1b0</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8112181e&gt;] ? balan=
ce_dirty_pages+0x21e/0x4d0</div><div>Dec =A06 20:27:55 localhost kernel: [&=
lt;ffffffff811a3851&gt;] ? mark_buffer_dirty+0x61/0xa0</div><div>Dec =A06 2=
0:27:55 localhost kernel: [&lt;ffffffff81121b34&gt;] ? balance_dirty_pages_=
ratelimited_nr+0x64/0x70</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8110dd23&gt;] ? gener=
ic_file_buffered_write+0x1c3/0x2a0</div><div>Dec =A06 20:27:55 localhost ke=
rnel: [&lt;ffffffff8106dcb7&gt;] ? current_fs_time+0x27/0x30</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffffa0261e4f&gt;] ? xfs_write+0x76=
f/0xb70 [xfs]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff814174b5&gt;] ? memcp=
y_toiovec+0x55/0x80</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;ffff=
ffffa025d800&gt;] ? xfs_file_aio_write+0x0/0x70 [xfs]</div><div>Dec =A06 20=
:27:55 localhost kernel: [&lt;ffffffffa025d861&gt;] ? xfs_file_aio_write+0x=
61/0x70 [xfs]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff811723bb&gt;] ? do_sy=
nc_readv_writev+0xfb/0x140</div><div>Dec =A06 20:27:55 localhost kernel: [&=
lt;ffffffff8118ae9d&gt;] ? d_obtain_alias+0x4d/0x160</div><div>Dec =A06 20:=
27:55 localhost kernel: [&lt;ffffffff8108e120&gt;] ? autoremove_wake_functi=
on+0x0/0x40</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff812056b6&gt;] ? secur=
ity_task_setgroups+0x16/0x20</div><div>Dec =A06 20:27:55 localhost kernel: =
[&lt;ffffffff81205356&gt;] ? security_file_permission+0x16/0x20</div><div>
Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8117347f&gt;] ? do_readv_w=
ritev+0xcf/0x1f0</div>
<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa047f852&gt;] ? nfsd_=
setuser_and_check_port+0x62/0xb0 [nfsd]</div><div>Dec =A06 20:27:55 localho=
st kernel: [&lt;ffffffff811735e6&gt;] ? vfs_writev+0x46/0x60</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffffa04813d7&gt;] ? nfsd_vfs_write=
+0x107/0x430 [nfsd]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8116fe22&gt;] ? dentr=
y_open+0x52/0xc0</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;fffffff=
fa04839fe&gt;] ? nfsd_open+0x13e/0x210 [nfsd]</div><div>Dec =A06 20:27:55 l=
ocalhost kernel: [&lt;ffffffffa0483e87&gt;] ? nfsd_write+0xe7/0x100 [nfsd]<=
/div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa048b7df&gt;] ? nfsd3=
_proc_write+0xaf/0x140 [nfsd]</div><div>Dec =A06 20:27:55 localhost kernel:=
 [&lt;ffffffffa047c43e&gt;] ? nfsd_dispatch+0xfe/0x240 [nfsd]</div><div>Dec=
 =A06 20:27:55 localhost kernel: [&lt;ffffffffa03f24d4&gt;] ? svc_process_c=
ommon+0x344/0x640 [sunrpc]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8105dbc0&gt;] ? defau=
lt_wake_function+0x0/0x20</div><div>Dec =A06 20:27:55 localhost kernel: [&l=
t;ffffffffa03f2b10&gt;] ? svc_process+0x110/0x160 [sunrpc]</div><div>Dec =
=A06 20:27:55 localhost kernel: [&lt;ffffffffa047cb62&gt;] ? nfsd+0xc2/0x16=
0 [nfsd]</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffffa047caa0&gt;] ? nfsd+=
0x0/0x160 [nfsd]</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;fffffff=
f8108ddb6&gt;] ? kthread+0x96/0xa0</div><div>Dec =A06 20:27:55 localhost ke=
rnel: [&lt;ffffffff8100c1ca&gt;] ? child_rip+0xa/0x20</div>

<div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8108dd20&gt;] ? kthre=
ad+0x0/0xa0</div><div>Dec =A06 20:27:55 localhost kernel: [&lt;ffffffff8100=
c1c0&gt;] ? child_rip+0x0/0x20</div><div>Dec =A06 20:27:55 localhost kernel=
: ---[ end trace e8b62253d4084e2b ]---</div>

<div><br></div>-- <br><div>Ryan C. England</div><div><a href=3D"http://www.=
corvidtec.com/" target=3D"_blank">Corvid Technologies</a></div>office: <a h=
ref=3D"tel:704-799-6944%20x158" value=3D"+17047996944" target=3D"_blank">70=
4-799-6944 x158</a><br>
cell:=A0=A0=A0 <a href=3D"tel:980-521-2297" value=3D"+19805212297" target=
=3D"_blank">980-521-2297</a><br>

--f46d04428800ae2df304b3987d7b--


--===============0726831706669447876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0726831706669447876==--
