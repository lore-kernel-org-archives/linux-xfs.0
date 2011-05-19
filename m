Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JMZR7Y057286 for <xfs@oss.sgi.com>; Thu, 19 May 2011 17:35:27 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D169846C28B
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 15:35:24 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id TnuMKD5u6a2hkaSu
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 15:35:24 -0700 (PDT)
Received: by ewy8 with SMTP id 8so1076053ewy.26
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 15:35:24 -0700 (PDT)
MIME-Version: 1.0
From: Phil Karn <karn@philkarn.net>
Date: Thu, 19 May 2011 15:35:04 -0700
Message-ID: <BANLkTi=YSBY5Zq5ePCLZ2mLY70YEw=Yv7w@mail.gmail.com>
Subject: Kernel bug when running xfs_fsr
Reply-To: karn@ka9q.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7205729160337451245=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7205729160337451245==
Content-Type: multipart/alternative; boundary=bcaec52be42bfef08704a3a89e49

--bcaec52be42bfef08704a3a89e49
Content-Type: text/plain; charset=UTF-8

I just got the following on my console each time I invoked xfs_fsr on a XFS
file system. The file system resides on a OCZ SSD that I've been having
problems with. This morning my system deadlocked while running a program
that created and deleted many small files on the SSD (a Perl script feeding
a large number of email messages one at a time to procmail). I suspect bad
garbage collection algorithms in the SSD; I recovered by booting into single
user and running wiper.sh on the file system to replenish the drive's pool
of erased pages. Since then I've been running wiper.sh regularly to ensure a
sufficient erased page pool in the SSD. I had just run it when I ran
xfs_fsr.

So it's possible that my file system data structures are messed up. However,
the system otherwise seems normal, and I've been routinely tagging my files
with extended attributes containing their SHA-1 hashes so I can check their
integrity. So far my checks haven't found any corrupted files.

Here is the relevant output from my kernel log. Is this a XFS bug, or does
it simply indicate a corrupted file system due to my earlier crash?

[29847.045684] BUG: unable to handle kernel NULL pointer dereference at
0000000000000018
[29847.045690] IP: [<ffffffffa033c11b>] xfs_trans_log_inode+0xb/0x30 [xfs]
[29847.045708] PGD 2c3c7b067 PUD 1bf416067 PMD 0
[29847.045712] Oops: 0000 [#1] PREEMPT SMP
[29847.045714] last sysfs file: /sys/block/sda/queue/max_sectors_kb
[29847.045717] CPU 4
[29847.045718] Modules linked in: af_packet acpi_cpufreq mperf
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
binfmt_misc fuse nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc 8021q
garp stp llc ip6table_mangle ip6t_REJECT ip6t_LOG nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 xt_DSCP xt_owner
iptable_mangle iptable_nat nf_nat xt_NOTRACK iptable_raw ipt_REJECT ipt_LOG
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_recent
xt_multiport iptable_filter ip_tables x_tables w83627ehf hwmon_vid adm1021
ipmi_si ipmi_msghandler loop i2c_i801 i2c_core pcspkr evdev ioatdma rtc_cmos
processor rtc_core dca rtc_lib thermal_sys button hwmon xfs exportfs raid456
md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx dm_mirror dm_region_hash dm_log dm_mod zlib_deflate crc32c
libcrc32c usbhid hid sd_mod ahci uhci_hcd libahci ehci_hcd sata_sil24
usbcore libata scsi_mod nls_base e1000e unix [last unloaded: scsi_wait_scan]
[29847.045777]
[29847.045780] Pid: 21784, comm: xfs_fsr Not tainted 2.6.38.6-homer #1
Supermicro X8STi/X8STi
[29847.045784] RIP: 0010:[<ffffffffa033c11b>]  [<ffffffffa033c11b>]
xfs_trans_log_inode+0xb/0x30 [xfs]
[29847.045796] RSP: 0018:ffff88028280fc80  EFLAGS: 00010206
[29847.045797] RAX: 0000000000000000 RBX: ffffffffffffffff RCX:
0000000000000008
[29847.045799] RDX: 0000000000000005 RSI: ffff8802c4a87c00 RDI:
ffff88011939ce38
[29847.045801] RBP: 0000000000000000 R08: ffff8800df494ce0 R09:
ffff8802c4a87c78
[29847.045803] R10: ffff88011939ce38 R11: 0000000000000020 R12:
ffff8802c4a87c00
[29847.045805] R13: ffff8802c4a87c38 R14: 0000000000000000 R15:
ffff8802c4a87c68
[29847.045807] FS:  00007fa379359700(0000) GS:ffff8800df480000(0000)
knlGS:0000000000000000
[29847.045809] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[29847.045811] CR2: 0000000000000018 CR3: 00000002adfe0000 CR4:
00000000000006e0
[29847.045813] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[29847.045815] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[29847.045817] Process xfs_fsr (pid: 21784, threadinfo ffff88028280e000,
task ffff880159bbd1c0)
[29847.045819] Stack:
[29847.045820]  ffffffffa03044a1 ffff88028280fd48 ffffffff00000000
ffff880100000000
[29847.045824]  00000c3200014174 ffff8802c4a87c00 ffffffff00000000
ffff88031137c000
[29847.045827]  0000000000000000 ffff88011939ce38 0000000000000002
0000000000000000
[29847.045830] Call Trace:
[29847.045842]  [<ffffffffa03044a1>] ? xfs_bunmapi+0x991/0xcc0 [xfs]
[29847.045856]  [<ffffffffa03220e4>] ? xfs_itruncate_finish+0x154/0x380
[xfs]
[29847.045867]  [<ffffffffa033ede0>] ? xfs_inactive+0x320/0x480 [xfs]
[29847.045877]  [<ffffffffa034d55c>] ? xfs_fs_evict_inode+0x9c/0x100 [xfs]
[29847.045881]  [<ffffffff8113b3f7>] ? evict+0x17/0xa0
[29847.045884]  [<ffffffff8113b707>] ? iput+0x1b7/0x280
[29847.045887]  [<ffffffff81137808>] ? d_kill+0xe8/0x150
[29847.045889]  [<ffffffff81138eb0>] ? dput+0xd0/0x1a0
[29847.045892]  [<ffffffff81123f3a>] ? fput+0x16a/0x220
[29847.045896]  [<ffffffff811204b9>] ? filp_close+0x59/0x80
[29847.045899]  [<ffffffff8112058d>] ? sys_close+0xad/0x120
[29847.045902]  [<ffffffff81002dfb>] ? system_call_fastpath+0x16/0x1b
[29847.045904] Code: 48 39 93 78 02 00 00 74 b3 48 89 83 70 02 00 00 48 89
93 78 02 00 00 eb a3 0f 1f 80 00 00 00 00 83 4f 68 01 48 8b 86 80 00 00 00
<48> 8b 40 18 80 48 0a 01 48 8b 8e 80 00 00 00 8b 81 a4 00 00 00
[29847.045929] RIP  [<ffffffffa033c11b>] xfs_trans_log_inode+0xb/0x30 [xfs]
[29847.045940]  RSP <ffff88028280fc80>
[29847.045942] CR2: 0000000000000018
[29847.045944] ---[ end trace 71418fb74f018914 ]---
[29862.781270] ------------[ cut here ]------------
[29862.781275] kernel BUG at fs/xfs/xfs_iget.c:351!
[29862.781277] invalid opcode: 0000 [#2] PREEMPT SMP
[29862.781279] last sysfs file: /sys/block/sda/queue/max_sectors_kb
[29862.781281] CPU 4
[29862.781282] Modules linked in: af_packet acpi_cpufreq mperf
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative
binfmt_misc fuse nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc 8021q
garp stp llc ip6table_mangle ip6t_REJECT ip6t_LOG nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 xt_DSCP xt_owner
iptable_mangle iptable_nat nf_nat xt_NOTRACK iptable_raw ipt_REJECT ipt_LOG
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_recent
xt_multiport iptable_filter ip_tables x_tables w83627ehf hwmon_vid adm1021
ipmi_si ipmi_msghandler loop i2c_i801 i2c_core pcspkr evdev ioatdma rtc_cmos
processor rtc_core dca rtc_lib thermal_sys button hwmon xfs exportfs raid456
md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx dm_mirror dm_region_hash dm_log dm_mod zlib_deflate crc32c
libcrc32c usbhid hid sd_mod ahci uhci_hcd libahci ehci_hcd sata_sil24
usbcore libata scsi_mod nls_base e1000e unix [last unloaded: scsi_wait_scan]

and so on...it repeats a few times because I issued the xfs_fsr command a
few times.

Thanks,
Phil

--bcaec52be42bfef08704a3a89e49
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I just got the following on my console each time I invoked xfs_fsr on a XFS=
 file system. The file system resides on a OCZ SSD that I&#39;ve been havin=
g problems with. This morning my system deadlocked while running a program =
that created and deleted many small files on the SSD (a Perl script feeding=
 a large number of email messages one at a time to procmail). I suspect bad=
 garbage collection algorithms in the SSD; I recovered by booting into sing=
le user and running wiper.sh on the file system to replenish the drive&#39;=
s pool of erased pages. Since then I&#39;ve been running wiper.sh regularly=
 to ensure a sufficient erased page pool in the SSD. I had just run it when=
 I ran xfs_fsr.<br>

<br>So it&#39;s possible that my file system data structures are messed up.=
 However, the system otherwise seems normal, and I&#39;ve been routinely ta=
gging my files with extended attributes containing their SHA-1 hashes so I =
can check their integrity. So far my checks haven&#39;t found any corrupted=
 files.<br>

<br>Here is the relevant output from my kernel log. Is this a XFS bug, or d=
oes it simply indicate a corrupted file system due to my earlier crash?<br>=
<br>[29847.045684] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000018<br>

[29847.045690] IP: [&lt;ffffffffa033c11b&gt;] xfs_trans_log_inode+0xb/0x30 =
[xfs]<br>[29847.045708] PGD 2c3c7b067 PUD 1bf416067 PMD 0 <br>[29847.045712=
] Oops: 0000 [#1] PREEMPT SMP <br>[29847.045714] last sysfs file: /sys/bloc=
k/sda/queue/max_sectors_kb<br>

[29847.045717] CPU 4 <br>[29847.045718] Modules linked in: af_packet acpi_c=
pufreq mperf cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_cons=
ervative binfmt_misc fuse nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc=
 8021q garp stp llc ip6table_mangle ip6t_REJECT ip6t_LOG nf_conntrack_ipv6 =
nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 xt_DSCP xt_owner iptable_man=
gle iptable_nat nf_nat xt_NOTRACK iptable_raw ipt_REJECT ipt_LOG nf_conntra=
ck_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_recent xt_multipo=
rt iptable_filter ip_tables x_tables w83627ehf hwmon_vid adm1021 ipmi_si ip=
mi_msghandler loop i2c_i801 i2c_core pcspkr evdev ioatdma rtc_cmos processo=
r rtc_core dca rtc_lib thermal_sys button hwmon xfs exportfs raid456 md_mod=
 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx dm=
_mirror dm_region_hash dm_log dm_mod zlib_deflate crc32c libcrc32c usbhid h=
id sd_mod ahci uhci_hcd libahci ehci_hcd sata_sil24 usbcore libata scsi_mod=
 nls_base e1000e unix [last unloaded: scsi_wait_scan]<br>

[29847.045777] <br>[29847.045780] Pid: 21784, comm: xfs_fsr Not tainted 2.6=
.38.6-homer #1 Supermicro X8STi/X8STi<br>[29847.045784] RIP: 0010:[&lt;ffff=
ffffa033c11b&gt;]=C2=A0 [&lt;ffffffffa033c11b&gt;] xfs_trans_log_inode+0xb/=
0x30 [xfs]<br>

[29847.045796] RSP: 0018:ffff88028280fc80=C2=A0 EFLAGS: 00010206<br>[29847.=
045797] RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 0000000000000008<b=
r>[29847.045799] RDX: 0000000000000005 RSI: ffff8802c4a87c00 RDI: ffff88011=
939ce38<br>

[29847.045801] RBP: 0000000000000000 R08: ffff8800df494ce0 R09: ffff8802c4a=
87c78<br>[29847.045803] R10: ffff88011939ce38 R11: 0000000000000020 R12: ff=
ff8802c4a87c00<br>[29847.045805] R13: ffff8802c4a87c38 R14: 000000000000000=
0 R15: ffff8802c4a87c68<br>

[29847.045807] FS:=C2=A0 00007fa379359700(0000) GS:ffff8800df480000(0000) k=
nlGS:0000000000000000<br>[29847.045809] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR=
0: 0000000080050033<br>[29847.045811] CR2: 0000000000000018 CR3: 00000002ad=
fe0000 CR4: 00000000000006e0<br>

[29847.045813] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000<br>[29847.045815] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00=
00000000000400<br>[29847.045817] Process xfs_fsr (pid: 21784, threadinfo ff=
ff88028280e000, task ffff880159bbd1c0)<br>

[29847.045819] Stack:<br>[29847.045820]=C2=A0 ffffffffa03044a1 ffff88028280=
fd48 ffffffff00000000 ffff880100000000<br>[29847.045824]=C2=A0 00000c320001=
4174 ffff8802c4a87c00 ffffffff00000000 ffff88031137c000<br>[29847.045827]=
=C2=A0 0000000000000000 ffff88011939ce38 0000000000000002 0000000000000000<=
br>

[29847.045830] Call Trace:<br>[29847.045842]=C2=A0 [&lt;ffffffffa03044a1&gt=
;] ? xfs_bunmapi+0x991/0xcc0 [xfs]<br>[29847.045856]=C2=A0 [&lt;ffffffffa03=
220e4&gt;] ? xfs_itruncate_finish+0x154/0x380 [xfs]<br>[29847.045867]=C2=A0=
 [&lt;ffffffffa033ede0&gt;] ? xfs_inactive+0x320/0x480 [xfs]<br>

[29847.045877]=C2=A0 [&lt;ffffffffa034d55c&gt;] ? xfs_fs_evict_inode+0x9c/0=
x100 [xfs]<br>[29847.045881]=C2=A0 [&lt;ffffffff8113b3f7&gt;] ? evict+0x17/=
0xa0<br>[29847.045884]=C2=A0 [&lt;ffffffff8113b707&gt;] ? iput+0x1b7/0x280<=
br>[29847.045887]=C2=A0 [&lt;ffffffff81137808&gt;] ? d_kill+0xe8/0x150<br>

[29847.045889]=C2=A0 [&lt;ffffffff81138eb0&gt;] ? dput+0xd0/0x1a0<br>[29847=
.045892]=C2=A0 [&lt;ffffffff81123f3a&gt;] ? fput+0x16a/0x220<br>[29847.0458=
96]=C2=A0 [&lt;ffffffff811204b9&gt;] ? filp_close+0x59/0x80<br>[29847.04589=
9]=C2=A0 [&lt;ffffffff8112058d&gt;] ? sys_close+0xad/0x120<br>

[29847.045902]=C2=A0 [&lt;ffffffff81002dfb&gt;] ? system_call_fastpath+0x16=
/0x1b<br>[29847.045904] Code: 48 39 93 78 02 00 00 74 b3 48 89 83 70 02 00 =
00 48 89 93 78 02 00 00 eb a3 0f 1f 80 00 00 00 00 83 4f 68 01 48 8b 86 80 =
00 00 00 &lt;48&gt; 8b 40 18 80 48 0a 01 48 8b 8e 80 00 00 00 8b 81 a4 00 0=
0 00 <br>

[29847.045929] RIP=C2=A0 [&lt;ffffffffa033c11b&gt;] xfs_trans_log_inode+0xb=
/0x30 [xfs]<br>[29847.045940]=C2=A0 RSP &lt;ffff88028280fc80&gt;<br>[29847.=
045942] CR2: 0000000000000018<br>[29847.045944] ---[ end trace 71418fb74f01=
8914 ]---<br>

[29862.781270] ------------[ cut here ]------------<br>[29862.781275] kerne=
l BUG at fs/xfs/xfs_iget.c:351!<br>[29862.781277] invalid opcode: 0000 [#2]=
 PREEMPT SMP <br>[29862.781279] last sysfs file: /sys/block/sda/queue/max_s=
ectors_kb<br>

[29862.781281] CPU 4 <br>[29862.781282] Modules linked in: af_packet acpi_c=
pufreq mperf cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_cons=
ervative binfmt_misc fuse nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc=
 8021q garp stp llc ip6table_mangle ip6t_REJECT ip6t_LOG nf_conntrack_ipv6 =
nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 xt_DSCP xt_owner iptable_man=
gle iptable_nat nf_nat xt_NOTRACK iptable_raw ipt_REJECT ipt_LOG nf_conntra=
ck_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_recent xt_multipo=
rt iptable_filter ip_tables x_tables w83627ehf hwmon_vid adm1021 ipmi_si ip=
mi_msghandler loop i2c_i801 i2c_core pcspkr evdev ioatdma rtc_cmos processo=
r rtc_core dca rtc_lib thermal_sys button hwmon xfs exportfs raid456 md_mod=
 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx dm=
_mirror dm_region_hash dm_log dm_mod zlib_deflate crc32c libcrc32c usbhid h=
id sd_mod ahci uhci_hcd libahci ehci_hcd sata_sil24 usbcore libata scsi_mod=
 nls_base e1000e unix [last unloaded: scsi_wait_scan]<br>

<br>and so on...it repeats a few times because I issued the xfs_fsr command=
 a few times.<br><br>Thanks,<br>Phil<br><br><br><br>

--bcaec52be42bfef08704a3a89e49--


--===============7205729160337451245==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7205729160337451245==--
