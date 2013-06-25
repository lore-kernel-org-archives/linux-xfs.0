Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 22B217F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 22:34:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D94768F8037
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 20:34:54 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 1sFtAoTGv9CCI8EI for
	<xfs@oss.sgi.com>; Mon, 24 Jun 2013 20:34:52 -0700 (PDT)
Received: from zmail14.collab.prod.int.phx2.redhat.com
	(zmail14.collab.prod.int.phx2.redhat.com [10.5.83.16])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r5P3YqX7028998
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 23:34:52 -0400
Date: Mon, 24 Jun 2013 23:34:51 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <115167995.4467705.1372131291931.JavaMail.root@redhat.com>
In-Reply-To: <510496923.4466531.1372130994988.JavaMail.root@redhat.com>
Subject: 3.10-rc7: general protection fault at
	xlog_state_do_callback+0x88/0x2c0 [xfs]
MIME-Version: 1.0
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

This looks like triggered by xfstests test #13
001	 17s
002	 1s
003	 1s
004	 2s
005	 0s
006	 28s
007	 51s
008	 3s
009	 2s
010	 [not run] dbtest was not built for this platform
011	 15s
012	 3s
013	

[32728.415359] general protection fault: 0000 [#1] SMP  
[32728.416010] Modules linked in: binfmt_misc(F) tun(F) fuse(F) rfcomm(F) hidp(F) ipt_ULOG(F) cmtp(F) kernelcapi(F) bnep(F) l2tp_ppp(F) l2tp_netlink(F) l2tp_core(F) scsi_transport_iscsi(F) af_key(F) af_802154(F) nfc(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) rds(F) atm(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) btrfs(F) zlib_deflate(F) raid6_pq(F) xor(F) vfat(F) fat(F) rpcsec_gss_krb5(F) auth_rpcgss(F) nfsv4(F) nfsv3(F) nfs_acl(F) nfsv2(F) nfs(F) lockd(F) sunrpc(F) fscache(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) arc4(F) md4(F) nls_utf8(F) cifs(F) dns_resolver(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) sctp(F) sg(F) tg3(F) e100(F) ppdev(F) mii(F) ptp(F) pps_core(F) pcspkr(F) parport_pc(F) shpchp(F) amd64_edac_mod(F) parport(F) serio_raw(F) k8temp(F) i2c_amd756(F) edac_mce_amd(F) i2c_amd8111(F) amd_rng(F) edac_core(F) i2c_core(F) xfs(F) libcrc32c(F) sr_mod(F) sd_mod(F) cdrom(F) crc_t10dif(F) ata_generic(F) pata_acpi(F) pat
 a_amd(F) sata_sil(F) libata(F) floppy(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloaded: ipt_REJECT] 
[32728.434486] CPU: 1 PID: 304 Comm: kworker/1:1H Tainted: GF            3.10.0-rc7+ #1 
[32728.434486] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./TYAN High-End Dual AMD Opteron, S2882, BIOS 080010  06/13/2005 
[32728.434486] Workqueue: xfslogd xfs_buf_iodone_work [xfs] 
[32728.434486] task: ffff8800f69a8000 ti: ffff8800f735e000 task.ti: ffff8800f735e000 
[32728.434486] RIP: 0010:[<ffffffffa01261b8>]  [<ffffffffa01261b8>] xlog_state_do_callback+0x88/0x2c0 [xfs] 
[32728.434486] RSP: 0018:ffff8800f735fd30  EFLAGS: 00010296 
[32728.434486] RAX: 0000000000006b6b RBX: 6b6b6b6b6b6b6b6b RCX: 00000000ffffffff 
[32728.434486] RDX: ffff8801e54b1d18 RSI: 0000000000000246 RDI: ffff88009eda5da8 
[32728.434486] RBP: ffff8800f735fd98 R08: 0000000000000000 R09: 0000000000000001 
[32728.434486] R10: 0000000000000002 R11: 0000000000000000 R12: ffff88009eda5e28 
[32728.434486] R13: ffff88009eda5e30 R14: ffffe8fef7d00800 R15: 0000000000000000 
[32728.434486] FS:  00007f1f14905740(0000) GS:ffff8800f7d00000(0000) knlGS:00000000f75906c0 
[32728.434486] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[32728.434486] CR2: 00007f1f1416d90d CR3: 00000000b4435000 CR4: 00000000000007e0 
[32728.434486] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[32728.434486] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[32728.434486] Stack: 
[32728.434486]  ffff88009eda5da8 0000000200000000 ffff8800c285fa90 ffff8800c285fa98 
[32728.434486]  0000000000000000 ffff8800c285f978 ffff8800c285faa0 ffff88009eda5b60 
[32728.434486]  ffff88009eda5da8 ffff8800c285f978 0000000000000000 ffffe8fef7d00800 
[32728.434486] Call Trace: 
[32728.434486]  [<ffffffffa012645e>] xlog_state_done_syncing+0x6e/0x90 [xfs] 
[32728.434486]  [<ffffffffa01264cb>] xlog_iodone+0x4b/0xa0 [xfs] 
[32728.434486]  [<ffffffffa00cca26>] xfs_buf_iodone_work+0x56/0xf0 [xfs] 
[32728.434486]  [<ffffffff8106a7a0>] process_one_work+0x170/0x420 
[32728.434486]  [<ffffffff8106b57b>] worker_thread+0x11b/0x390 
[32728.434486]  [<ffffffff8106b460>] ? manage_workers.isra.26+0x2b0/0x2b0 
[32728.434486]  [<ffffffff81071780>] kthread+0xc0/0xd0 
[32728.434486]  [<ffffffff810716c0>] ? insert_kthread_work+0x40/0x40 
[32728.434486]  [<ffffffff815e3cdc>] ret_from_fork+0x7c/0xb0 
[32728.434486]  [<ffffffff810716c0>] ? insert_kthread_work+0x40/0x40 
[32728.434486] Code: 00 48 89 4d b0 48 89 45 a8 48 8b 45 c0 83 45 a4 01 c7 45 bc 00 00 00 00 48 8b 80 20 01 00 00 48 89 45 d0 48 89 c3 0f 1f 44 00 00 <0f> b7 43 5c a8 41 0f 85 37 01 00 00 a8 80 0f 85 92 01 00 00 a8  
[32728.434486] RIP  [<ffffffffa01261b8>] xlog_state_do_callback+0x88/0x2c0 [xfs] 
[32728.434486]  RSP <ffff8800f735fd30> 
[32728.754820] ---[ end trace 2ee880d41ce749d4 ]--- 
[32728.759622] BUG: unable to handle kernel paging request at ffffffffffffffd8 
[32728.760482] IP: [<ffffffff81071cf0>] kthread_data+0x10/0x20 
[32728.760482] PGD 18ba067 PUD 18bc067 PMD 0  
[32728.760482] Oops: 0000 [#2] SMP  
[32728.760482] Modules linked in: binfmt_misc(F) tun(F) fuse(F) rfcomm(F) hidp(F) ipt_ULOG(F) cmtp(F) kernelcapi(F) bnep(F) l2tp_ppp(F) l2tp_netlink(F) l2tp_core(F) scsi_transport_iscsi(F) af_key(F) af_802154(F) nfc(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) rds(F) atm(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) btrfs(F) zlib_deflate(F) raid6_pq(F) xor(F) vfat(F) fat(F) rpcsec_gss_krb5(F) auth_rpcgss(F) nfsv4(F) nfsv3(F) nfs_acl(F) nfsv2(F) nfs(F) lockd(F) sunrpc(F) fscache(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) arc4(F) md4(F) nls_utf8(F) cifs(F) dns_resolver(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) sctp(F) sg(F) tg3(F) e100(F) ppdev(F) mii(F) ptp(F) pps_core(F) pcspkr(F) parport_pc(F) shpchp(F) amd64_edac_mod(F) parport(F) serio_raw(F) k8temp(F) i2c_amd756(F) edac_mce_amd(F) i2c_amd8111(F) amd_rng(F) edac_core(F) i2c_core(F) xfs(F) libcrc32c(F) sr_mod(F) sd_mod(F) cdrom(F) crc_t10dif(F) ata_generic(F) pata_acpi(F) pat
 a_amd(F) sata_sil(F) libata(F) floppy(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloaded: ipt_REJECT] 
[32728.760482] CPU: 1 PID: 304 Comm: kworker/1:1H Tainted: GF     D      3.10.0-rc7+ #1 
[32728.760482] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./TYAN High-End Dual AMD Opteron, S2882, BIOS 080010  06/13/2005 
[32728.760482] task: ffff8800f69a8000 ti: ffff8800f735e000 task.ti: ffff8800f735e000 
[32728.760482] RIP: 0010:[<ffffffff81071cf0>]  [<ffffffff81071cf0>] kthread_data+0x10/0x20 
[32728.760482] RSP: 0018:ffff8800f735fae8  EFLAGS: 00010002 
[32728.760482] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 000000000000000f 
[32728.760482] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8800f69a8000 
[32728.760482] RBP: ffff8800f735fae8 R08: ffff8800f69a8070 R09: 00001dc44215f390 
[32728.760482] R10: ffff8800f382cb40 R11: 0000000000000000 R12: ffff8800f7d133c0 
[32728.760482] R13: 0000000000000001 R14: ffff8800f69a7ff0 R15: ffff8800f69a8000 
[32728.760482] FS:  00007f1f14905740(0000) GS:ffff8800f7d00000(0000) knlGS:00000000f75906c0 
[32728.760482] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[32728.760482] CR2: 0000000000000028 CR3: 00000000018b9000 CR4: 00000000000007e0 
[32728.760482] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[32728.760482] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[32728.760482] Stack: 
[32728.760482]  ffff8800f735fb00 ffffffff8106b871 ffff8800f69a8000 ffff8800f735fb60 
[32728.760482]  ffffffff815d9c52 ffff8800f735ffd8 00000000000133c0 ffff8800f735ffd8 
[32728.760482]  00000000000133c0 ffff8800f69a8000 ffff8800f69a87e8 ffff8800f735f6d0 
[32728.760482] Call Trace: 
[32728.760482]  [<ffffffff8106b871>] wq_worker_sleeping+0x11/0x90 
[32728.760482]  [<ffffffff815d9c52>] __schedule+0x5b2/0x7f0 
[32728.760482]  [<ffffffff815d9eb9>] schedule+0x29/0x70 
[32728.760482]  [<ffffffff81052bc7>] do_exit+0x6c7/0xa20 
[32728.760482]  [<ffffffff815dcb41>] oops_end+0x91/0xd0 
[32728.760482]  [<ffffffff810058ab>] die+0x4b/0x70 
[32728.760482]  [<ffffffff815dc632>] do_general_protection+0xc2/0x150 
[32728.760482]  [<ffffffff815dc042>] general_protection+0x22/0x30 
[32728.760482]  [<ffffffffa01261b8>] ? xlog_state_do_callback+0x88/0x2c0 [xfs] 
[32728.760482]  [<ffffffffa012645e>] xlog_state_done_syncing+0x6e/0x90 [xfs] 
[32728.760482]  [<ffffffffa01264cb>] xlog_iodone+0x4b/0xa0 [xfs] 
[32728.760482]  [<ffffffffa00cca26>] xfs_buf_iodone_work+0x56/0xf0 [xfs] 
[32728.760482]  [<ffffffff8106a7a0>] process_one_work+0x170/0x420 
[32728.760482]  [<ffffffff8106b57b>] worker_thread+0x11b/0x390 
[32728.760482]  [<ffffffff8106b460>] ? manage_workers.isra.26+0x2b0/0x2b0 
[32728.760482]  [<ffffffff81071780>] kthread+0xc0/0xd0 
[32728.760482]  [<ffffffff810716c0>] ? insert_kthread_work+0x40/0x40 
[32728.760482]  [<ffffffff815e3cdc>] ret_from_fork+0x7c/0xb0 
[32728.760482]  [<ffffffff810716c0>] ? insert_kthread_work+0x40/0x40 
[32728.760482] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 80 05 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90  
[32728.760482] RIP  [<ffffffff81071cf0>] kthread_data+0x10/0x20 
[32728.760482]  RSP <ffff8800f735fae8> 
[32728.760482] CR2: ffffffffffffffd8 
[32728.760482] ---[ end trace 2ee880d41ce749d5 ]--- 
[32728.760482] Fixing recursive fault but reboot is needed! 
[32728.767010] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3 
[32728.767010] Shutting down cpus with NMI

More information here,
xfsprogs-3.1.10

+ cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=4017928k,nr_inodes=1004482,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
/dev/mapper/rhel_pogolinux--01-root / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=33,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/mapper/rhel_pogolinux--01-home /home xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
/dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
+ echo

+ lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
Thread(s) per core:    1
Core(s) per socket:    2
Socket(s):             2
NUMA node(s):          2
Vendor ID:             AuthenticAMD
CPU family:            15
Model:                 33
Model name:            Dual Core AMD Opteron(tm) Processor 265
Stepping:              2
CPU MHz:               1791.960
BogoMIPS:              3583.37
L1d cache:             64K
L1i cache:             64K
L2 cache:              1024K
NUMA node0 CPU(s):     0,1
NUMA node1 CPU(s):     2,3
+ echo
+ cat /proc/partitions

major minor  #blocks  name

   8        0   72613056 sda
   8        1     512000 sda1
   8        2   72099840 sda2
  11        0    1048575 sr0
 253        0    8142848 dm-0
 253        1   42975232 dm-1
 253        2   20979712 dm-2
+ echo

+ pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rhel_pogolinux-01
  PV Size               68.76 GiB / not usable 2.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              17602
  Free PE               0
  Allocated PE          17602
  PV UUID               LWpYzD-1Lai-AeB0-IScd-3YpG-XkFu-UEPsFD
   
+ echo
+ vgdisplay

  --- Volume group ---
  VG Name               rhel_pogolinux-01
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               68.76 GiB
  PE Size               4.00 MiB
  Total PE              17602
  Alloc PE / Size       17602 / 68.76 GiB
  Free  PE / Size       0 / 0   
  VG UUID               4wwoQC-A7yZ-DBhg-1j7c-fmcl-MWjh-jhhAIZ
   
+ echo
+ lvdisplay

  --- Logical volume ---
  LV Path                /dev/rhel_pogolinux-01/swap
  LV Name                swap
  VG Name                rhel_pogolinux-01
  LV UUID                AYFDvh-1YQV-JazZ-XjaS-Rdy9-mQlJ-IITCiM
  LV Write Access        read/write
  LV Creation host, time pogolinux-01.lab.eng.rdu.redhat.com, 2013-06-23 22:52:32 -0400
  LV Status              available
  # open                 2
  LV Size                7.77 GiB
  Current LE             1988
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/rhel_pogolinux-01/home
  LV Name                home
  VG Name                rhel_pogolinux-01
  LV UUID                tOKuBN-MIUa-vmCr-1h2N-rFrb-5L22-tBfZBc
  LV Write Access        read/write
  LV Creation host, time pogolinux-01.lab.eng.rdu.redhat.com, 2013-06-23 22:52:33 -0400
  LV Status              available
  # open                 1
  LV Size                20.01 GiB
  Current LE             5122
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/rhel_pogolinux-01/root
  LV Name                root
  VG Name                rhel_pogolinux-01
  LV UUID                PsnPNA-EtUd-n3yM-epTb-o9Lb-qJzj-I1sCKR
  LV Write Access        read/write
  LV Creation host, time pogolinux-01.lab.eng.rdu.redhat.com, 2013-06-23 22:52:33 -0400
  LV Status              available
  # open                 1
  LV Size                40.98 GiB
  Current LE             10492
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

+ mkfs.xfs -f /dev/mapper/rhel_pogolinux--01-swap
meta-data=/dev/mapper/rhel_pogolinux--01-swap isize=256    agcount=4, agsize=508928 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=2035712, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
+ mkfs.xfs -f /dev/mapper/rhel_pogolinux--01-home
meta-data=/dev/mapper/rhel_pogolinux--01-home isize=256    agcount=4, agsize=1311232 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=5244928, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2561, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

+ export TEST_DEV=/dev/mapper/rhel_pogolinux--01-swap
+ TEST_DEV=/dev/mapper/rhel_pogolinux--01-swap
+ export TEST_DIR=/mnt/testarea/test
+ TEST_DIR=/mnt/testarea/test
+ export SCRATCH_DEV=/dev/mapper/rhel_pogolinux--01-home
+ SCRATCH_DEV=/dev/mapper/rhel_pogolinux--01-home
+ export SCRATCH_MNT=/mnt/testarea/scratch
+ SCRATCH_MNT=/mnt/testarea/scratc

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
