Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E06E7F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 18:57:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEAC9AC002
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 16:57:36 -0800 (PST)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id YgnTD33Ei3aW5Ej8
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 13 Nov 2014 16:57:34 -0800 (PST)
Received: by mail-la0-f53.google.com with SMTP id mc6so14402108lab.12
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 16:57:32 -0800 (PST)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 16:57:11 -0800
Message-ID: <CALCETrWN71T1JsSNix52+ez_Sxt4i+vL-fX_2RTNbt8Ex1p=vw@mail.gmail.com>
Subject: XFS locking issues in 3.18-rc3+
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

I'm running a kernel somewhere between 3.18-rc3 and 3.18-rc4.  I got
the warnings below.  Is this a known issue?

Thanks,
Andy

Nov 07 18:05:38 hostname kernel:
Nov 07 18:05:38 hostname kernel:
======================================================
Nov 07 18:05:38 hostname kernel: [ INFO: possible circular locking
dependency detected ]
Nov 07 18:05:38 hostname kernel: 3.18.0-rc3+ #508 Not tainted
Nov 07 18:05:38 hostname kernel:
-------------------------------------------------------
Nov 07 18:05:38 hostname kernel: gnome-session/2181 is trying to acquire lock:
Nov 07 18:05:38 hostname kernel:  (&mm->mmap_sem){++++++}, at:
[<ffffffff811b37f3>] might_fault+0x43/0xa0
Nov 07 18:05:38 hostname kernel:
                                                    but task is
already holding lock:
Nov 07 18:05:38 hostname kernel:  (&xfs_dir_ilock_class){.+.+..}, at:
[<ffffffffa051e92a>] xfs_ilock+0xda/0x110 [xfs]
Nov 07 18:05:38 hostname kernel:
                                                    which lock already
depends on the new lock.
Nov 07 18:05:38 hostname kernel:
                                                    the existing
dependency chain (in reverse order) is:
Nov 07 18:05:38 hostname kernel:
                                                    -> #2
(&xfs_dir_ilock_class){.+.+..}:
Nov 07 18:05:38 hostname kernel:        [<ffffffff810d34a0>]
lock_acquire+0xa0/0x120
Nov 07 18:05:38 hostname kernel:        [<ffffffff810cd95f>]
down_read_nested+0x3f/0x60
Nov 07 18:05:38 hostname kernel:        [<ffffffffa051e92a>]
xfs_ilock+0xda/0x110 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa051e9d8>]
xfs_ilock_attr_map_shared+0x38/0x50 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa04d64d1>]
xfs_attr_get+0xb1/0x190 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa052ba97>]
xfs_xattr_get+0x37/0x50 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffff8122655f>]
generic_getxattr+0x4f/0x70
Nov 07 18:05:38 hostname kernel:        [<ffffffff8130ea40>]
inode_doinit_with_dentry+0x150/0x640
Nov 07 18:05:38 hostname kernel:        [<ffffffff8130fb0c>]
selinux_d_instantiate+0x1c/0x20
Nov 07 18:05:38 hostname kernel:        [<ffffffff813049db>]
security_d_instantiate+0x1b/0x30
Nov 07 18:05:38 hostname kernel:        [<ffffffff812185a6>]
d_splice_alias+0x1b6/0x210
Nov 07 18:05:38 hostname kernel:        [<ffffffffa051cc12>]
xfs_vn_lookup+0x72/0xa0 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffff8120954d>]
lookup_real+0x1d/0x50
Nov 07 18:05:38 hostname kernel:        [<ffffffff81209f73>]
__lookup_hash+0x33/0x40
Nov 07 18:05:38 hostname kernel:        [<ffffffff8173d1ef>]
lookup_slow+0x47/0xad
Nov 07 18:05:38 hostname kernel:        [<ffffffff8120cc84>]
link_path_walk+0x364/0x820
Nov 07 18:05:38 hostname kernel:        [<ffffffff8120d195>]
path_lookupat+0x55/0x740
Nov 07 18:05:38 hostname kernel:        [<ffffffff8120d8ab>]
filename_lookup+0x2b/0xc0
Nov 07 18:05:38 hostname kernel:        [<ffffffff81211314>]
user_path_at_empty+0x54/0xa0
Nov 07 18:05:38 hostname kernel:        [<ffffffff81211371>]
user_path_at+0x11/0x20
Nov 07 18:05:38 hostname kernel:        [<ffffffff811fe082>]
SyS_access+0xa2/0x1f0
Nov 07 18:05:38 hostname kernel:        [<ffffffff817472e9>]
system_call_fastpath+0x12/0x17
Nov 07 18:05:38 hostname kernel:
                                                    -> #1 (&isec->lock){+.+.+.}:
Nov 07 18:05:38 hostname kernel:        [<ffffffff810d34a0>]
lock_acquire+0xa0/0x120
Nov 07 18:05:38 hostname kernel:        [<ffffffff8174333b>]
mutex_lock_nested+0x4b/0x3a0
Nov 07 18:05:38 hostname kernel:        [<ffffffff8130e995>]
inode_doinit_with_dentry+0xa5/0x640
Nov 07 18:05:38 hostname kernel:        [<ffffffff8130fb0c>]
selinux_d_instantiate+0x1c/0x20
Nov 07 18:05:38 hostname kernel:        [<ffffffff813049db>]
security_d_instantiate+0x1b/0x30
Nov 07 18:05:38 hostname kernel:        [<ffffffff81217c04>]
d_instantiate+0x54/0x70
Nov 07 18:05:38 hostname kernel:        [<ffffffff811a1b30>]
__shmem_file_setup+0xe0/0x1d0
Nov 07 18:05:38 hostname kernel:        [<ffffffff811a50c8>]
shmem_zero_setup+0x28/0x70
Nov 07 18:05:38 hostname kernel:        [<ffffffff811beb4d>]
mmap_region+0x5ad/0x620
Nov 07 18:05:38 hostname kernel:        [<ffffffff811beeb5>]
do_mmap_pgoff+0x2f5/0x3c0
Nov 07 18:05:38 hostname kernel:        [<ffffffff811a5600>]
vm_mmap_pgoff+0x90/0xc0
Nov 07 18:05:38 hostname kernel:        [<ffffffff811a565d>] vm_mmap+0x2d/0x40
Nov 07 18:05:38 hostname kernel:        [<ffffffffa0433177>]
kvm_arch_prepare_memory_region+0x47/0x60 [kvm]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa0419b64>]
__kvm_set_memory_region+0x214/0x820 [kvm]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa041a1a1>]
kvm_set_memory_region+0x31/0x50 [kvm]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa03c9e6a>]
vmx_set_tss_addr+0x4a/0x190 [kvm_intel]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa042da40>]
kvm_arch_vm_ioctl+0x9a0/0xb60 [kvm]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa041a24e>]
kvm_vm_ioctl+0x8e/0x780 [kvm]
Nov 07 18:05:38 hostname kernel:        [<ffffffff81213a90>]
do_vfs_ioctl+0x300/0x520
Nov 07 18:05:38 hostname kernel:        [<ffffffff81213d31>] SyS_ioctl+0x81/0xa0
Nov 07 18:05:38 hostname kernel:        [<ffffffff817472e9>]
system_call_fastpath+0x12/0x17
Nov 07 18:05:38 hostname kernel:
                                                    -> #0
(&mm->mmap_sem){++++++}:
Nov 07 18:05:38 hostname kernel:        [<ffffffff810d2a5d>]
__lock_acquire+0x183d/0x1b10
Nov 07 18:05:38 hostname kernel:        [<ffffffff810d34a0>]
lock_acquire+0xa0/0x120
Nov 07 18:05:38 hostname kernel:        [<ffffffff811b3820>]
might_fault+0x70/0xa0
Nov 07 18:05:38 hostname kernel:        [<ffffffff81214011>] filldir+0x91/0x120
Nov 07 18:05:38 hostname kernel:        [<ffffffffa0510b00>]
xfs_dir2_sf_getdents.isra.11+0x200/0x270 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa0510f1e>]
xfs_readdir+0x14e/0x170 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffffa0512afb>]
xfs_file_readdir+0x2b/0x30 [xfs]
Nov 07 18:05:38 hostname kernel:        [<ffffffff81213dfe>]
iterate_dir+0xae/0x140
Nov 07 18:05:38 hostname kernel:        [<ffffffff812142e1>]
SyS_getdents+0x81/0x100
Nov 07 18:05:38 hostname kernel:        [<ffffffff817472e9>]
system_call_fastpath+0x12/0x17
Nov 07 18:05:38 hostname kernel:
                                                    other info that
might help us debug this:
Nov 07 18:05:38 hostname kernel: Chain exists of:
                                                      &mm->mmap_sem
--> &isec->lock --> &xfs_dir_ilock_class
Nov 07 18:05:38 hostname kernel:  Possible unsafe locking scenario:
Nov 07 18:05:38 hostname kernel:        CPU0                    CPU1
Nov 07 18:05:38 hostname kernel:        ----                    ----
Nov 07 18:05:38 hostname kernel:   lock(&xfs_dir_ilock_class);
Nov 07 18:05:38 hostname kernel:
lock(&isec->lock);
Nov 07 18:05:38 hostname kernel:
lock(&xfs_dir_ilock_class);
Nov 07 18:05:38 hostname kernel:   lock(&mm->mmap_sem);
Nov 07 18:05:38 hostname kernel:
                                                     *** DEADLOCK ***
Nov 07 18:05:38 hostname kernel: 2 locks held by gnome-session/2181:
Nov 07 18:05:38 hostname kernel:  #0:
(&type->i_mutex_dir_key#5){+.+.+.}, at: [<ffffffff81213db9>]
iterate_dir+0x69/0x140
Nov 07 18:05:38 hostname kernel:  #1:  (&xfs_dir_ilock_class){.+.+..},
at: [<ffffffffa051e92a>] xfs_ilock+0xda/0x110 [xfs]
Nov 07 18:05:38 hostname kernel:
                                                    stack backtrace:
Nov 07 18:05:38 hostname kernel: CPU: 1 PID: 2181 Comm: gnome-session
Not tainted 3.18.0-rc3+ #508
Nov 07 18:05:38 hostname kernel: Hardware name: MSI MS-7760/X79A-GD65
(8D) (MS-7760), BIOS V1.8 10/18/2012
Nov 07 18:05:38 hostname kernel:  ffffffff82643e00 ffff88044486bb48
ffffffff8173e3ea 0000000000000000
Nov 07 18:05:38 hostname kernel:  ffffffff8265fb80 ffff88044486bb98
ffffffff81739f87 0000003fffffffc0
Nov 07 18:05:38 hostname kernel:  ffff88044486bbf8 0000000000000001
ffff880445bf4fd0 0000000000000001
Nov 07 18:05:38 hostname kernel: Call Trace:
Nov 07 18:05:38 hostname kernel:  [<ffffffff8173e3ea>] dump_stack+0x46/0x58
Nov 07 18:05:38 hostname kernel:  [<ffffffff81739f87>]
print_circular_bug+0x202/0x213
Nov 07 18:05:38 hostname kernel:  [<ffffffff810d2a5d>]
__lock_acquire+0x183d/0x1b10
Nov 07 18:05:38 hostname kernel:  [<ffffffff810d1582>] ?
__lock_acquire+0x362/0x1b10
Nov 07 18:05:38 hostname kernel:  [<ffffffff810d34a0>] lock_acquire+0xa0/0x120
Nov 07 18:05:38 hostname kernel:  [<ffffffff811b37f3>] ? might_fault+0x43/0xa0
Nov 07 18:05:38 hostname kernel:  [<ffffffff811b3820>] might_fault+0x70/0xa0
Nov 07 18:05:38 hostname kernel:  [<ffffffff811b37f3>] ? might_fault+0x43/0xa0
Nov 07 18:05:38 hostname kernel:  [<ffffffff81214011>] filldir+0x91/0x120
Nov 07 18:05:38 hostname kernel:  [<ffffffffa051e994>] ?
xfs_ilock_data_map_shared+0x34/0x40 [xfs]
Nov 07 18:05:38 hostname kernel:  [<ffffffffa0510b00>]
xfs_dir2_sf_getdents.isra.11+0x200/0x270 [xfs]
Nov 07 18:05:38 hostname kernel:  [<ffffffffa051e92a>] ?
xfs_ilock+0xda/0x110 [xfs]
Nov 07 18:05:38 hostname kernel:  [<ffffffffa0510f1e>]
xfs_readdir+0x14e/0x170 [xfs]
Nov 07 18:05:38 hostname kernel:  [<ffffffff810d0cea>] ?
mark_held_locks+0x6a/0x90
Nov 07 18:05:38 hostname kernel:  [<ffffffffa0512afb>]
xfs_file_readdir+0x2b/0x30 [xfs]
Nov 07 18:05:38 hostname kernel:  [<ffffffff81213dfe>] iterate_dir+0xae/0x140
Nov 07 18:05:38 hostname kernel:  [<ffffffff812142e1>] SyS_getdents+0x81/0x100
Nov 07 18:05:38 hostname kernel:  [<ffffffff81213f80>] ? fillonedir+0xf0/0xf0
Nov 07 18:05:38 hostname kernel:  [<ffffffff817472e9>]
system_call_fastpath+0x12/0x17

[...]

Nov 07 18:05:39 hostname kernel: ------------[ cut here ]------------
Nov 07 18:05:39 hostname kernel: WARNING: CPU: 4 PID: 2461 at
mm/truncate.c:758 pagecache_isize_extended+0x105/0x110()
Nov 07 18:05:39 hostname kernel: Modules linked in: fuse xt_CHECKSUM
tun ip6t_rpfilter bnep bluetooth ip6t_REJECT nf_reject_ipv6
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute
bridge stp llc ebtable_filter ebtables ip6table_mangle
ip6table_security ip6table_raw ip6table_filter ip6_tables
iptable_mangle iptable_security iptable_raw f71882fg xfs vfat fat
libcrc32c iTCO_wdt iTCO_vendor_support mxm_wmi x86_pkg_temp_thermal
coretemp kvm_intel joydev kvm snd_hda_codec_realtek sb_edac
snd_hda_codec_generic snd_hda_codec_hdmi microcode edac_core serio_raw
snd_hda_intel pcspkr snd_hda_controller snd_hda_codec snd_seq i2c_i801
snd_hwdep snd_seq_device snd_pcm lpc_ich mfd_core snd_timer wmi snd
mei_me mei shpchp soundcore binfmt_misc dm_crypt
Nov 07 18:05:39 hostname kernel:  radeon i2c_algo_bit drm_kms_helper
ttm drm crct10dif_pclmul firewire_ohci e1000e crc32_pclmul
crc32c_intel ghash_clmulni_intel firewire_core i2c_core ptp pps_core
crc_itu_t [last unloaded: ipmi_msghandler]
Nov 07 18:05:39 hostname kernel: CPU: 4 PID: 2461 Comm: dconf-service
Not tainted 3.18.0-rc3+ #508
Nov 07 18:05:39 hostname kernel: Hardware name: MSI MS-7760/X79A-GD65
(8D) (MS-7760), BIOS V1.8 10/18/2012
Nov 07 18:05:39 hostname kernel:  0000000000000009 ffff880444fffd38
ffffffff8173e3ea 0000000000000000
Nov 07 18:05:39 hostname kernel:  0000000000000000 ffff880444fffd78
ffffffff810886a1 ffffea000254d400
Nov 07 18:05:39 hostname kernel:  0000000000001000 ffff8804446b1550
0000000000000000 000000000000bf36
Nov 07 18:05:39 hostname kernel: Call Trace:
Nov 07 18:05:39 hostname kernel:  [<ffffffff8173e3ea>] dump_stack+0x46/0x58
Nov 07 18:05:39 hostname kernel:  [<ffffffff810886a1>]
warn_slowpath_common+0x81/0xa0
Nov 07 18:05:39 hostname kernel:  [<ffffffff8108877a>]
warn_slowpath_null+0x1a/0x20
Nov 07 18:05:39 hostname kernel:  [<ffffffff811982e5>]
pagecache_isize_extended+0x105/0x110
Nov 07 18:05:39 hostname kernel:  [<ffffffffa0508300>] ?
__xfs_get_blocks+0x4f0/0x4f0 [xfs]
Nov 07 18:05:39 hostname kernel:  [<ffffffff81199037>]
truncate_setsize+0x27/0x40
Nov 07 18:05:39 hostname kernel:  [<ffffffffa051d8cf>]
xfs_setattr_size+0x13f/0x3c0 [xfs]
Nov 07 18:05:39 hostname kernel:  [<ffffffffa052b736>] ?
xfs_trans_commit+0x146/0x220 [xfs]
Nov 07 18:05:39 hostname kernel:  [<ffffffffa05128c7>]
xfs_file_fallocate+0x2e7/0x300 [xfs]
Nov 07 18:05:39 hostname kernel:  [<ffffffff8130ab94>] ?
selinux_file_permission+0xc4/0x120
Nov 07 18:05:39 hostname kernel:  [<ffffffff811fdcbf>] do_fallocate+0x12f/0x1d0
Nov 07 18:05:39 hostname kernel:  [<ffffffff811fdda8>] SyS_fallocate+0x48/0x80
Nov 07 18:05:39 hostname kernel:  [<ffffffff817472e9>]
system_call_fastpath+0x12/0x17
Nov 07 18:05:39 hostname kernel: ---[ end trace 378b089d93843b4c ]---
Nov 07 18:05:39 hostname colord[1813]: Profile added:
icc-72594106bd9e2f43448d54e31e6440e9
Nov 07 18:05:39 hostname colord[1813]: Profile added:
icc-c1b5ce44c83f251815721a2420252919
Nov 07 18:05:40 hostname goa[2519]: goa-daemon version 3.10.5 starting
[main.c:117, main()]
Nov 07 18:05:40 hostname goa[2519]: GoaKerberosIdentityManager: Using
polling for change notification for credential cache type 'KEYRING'
[goakerberosidentitymanager.c:1386, monitor_credentials_cache()]
Nov 07 18:05:40 hostname polkitd[1090]: Registered Authentication
Agent for unix-session:2 (system bus name :1.88 [/usr/bin/gnome-shell
--mode=classic], object path
/org/freedesktop/PolicyKit1/AuthenticationAgent, locale en_US.UTF-8)
Nov 07 18:05:40 hostname sh[907]: abrt-dump-oops: Found oopses: 2
Nov 07 18:05:40 hostname sh[907]: abrt-dump-oops: Creating problem directories
Nov 07 18:05:40 hostname kernel: ------------[ cut here ]------------
Nov 07 18:05:40 hostname kernel: WARNING: CPU: 0 PID: 2515 at
mm/truncate.c:758 pagecache_isize_extended+0x105/0x110()
Nov 07 18:05:40 hostname kernel: Modules linked in: fuse xt_CHECKSUM
tun ip6t_rpfilter bnep bluetooth ip6t_REJECT nf_reject_ipv6
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute
bridge stp llc ebtable_filter ebtables ip6table_mangle
ip6table_security ip6table_raw ip6table_filter ip6_tables
iptable_mangle iptable_security iptable_raw f71882fg xfs vfat fat
libcrc32c iTCO_wdt iTCO_vendor_support mxm_wmi x86_pkg_temp_thermal
coretemp kvm_intel joydev kvm snd_hda_codec_realtek sb_edac
snd_hda_codec_generic snd_hda_codec_hdmi microcode edac_core serio_raw
snd_hda_intel pcspkr snd_hda_controller snd_hda_codec snd_seq i2c_i801
snd_hwdep snd_seq_device snd_pcm lpc_ich mfd_core snd_timer wmi snd
mei_me mei shpchp soundcore binfmt_misc dm_crypt
Nov 07 18:05:40 hostname kernel:  radeon i2c_algo_bit drm_kms_helper
ttm drm crct10dif_pclmul firewire_ohci e1000e crc32_pclmul
crc32c_intel ghash_clmulni_intel firewire_core i2c_core ptp pps_core
crc_itu_t [last unloaded: ipmi_msghandler]
Nov 07 18:05:40 hostname kernel: CPU: 0 PID: 2515 Comm:
mission-control Tainted: G        W      3.18.0-rc3+ #508
Nov 07 18:05:40 hostname kernel: Hardware name: MSI MS-7760/X79A-GD65
(8D) (MS-7760), BIOS V1.8 10/18/2012
Nov 07 18:05:40 hostname kernel:  0000000000000009 ffff88000c80fd38
ffffffff8173e3ea 0000000000000000
Nov 07 18:05:40 hostname kernel:  0000000000000000 ffff88000c80fd78
ffffffff810886a1 ffffea0010273000
Nov 07 18:05:40 hostname kernel:  0000000000001000 ffff8804447a0f10
0000000000000000 0000000000000026
Nov 07 18:05:40 hostname kernel: Call Trace:
Nov 07 18:05:40 hostname kernel:  [<ffffffff8173e3ea>] dump_stack+0x46/0x58
Nov 07 18:05:40 hostname kernel:  [<ffffffff810886a1>]
warn_slowpath_common+0x81/0xa0
Nov 07 18:05:40 hostname kernel:  [<ffffffff8108877a>]
warn_slowpath_null+0x1a/0x20
Nov 07 18:05:40 hostname kernel:  [<ffffffff811982e5>]
pagecache_isize_extended+0x105/0x110
Nov 07 18:05:40 hostname kernel:  [<ffffffffa0508300>] ?
__xfs_get_blocks+0x4f0/0x4f0 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffff81199037>]
truncate_setsize+0x27/0x40
Nov 07 18:05:40 hostname kernel:  [<ffffffffa051d8cf>]
xfs_setattr_size+0x13f/0x3c0 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffffa052b736>] ?
xfs_trans_commit+0x146/0x220 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffffa05128c7>]
xfs_file_fallocate+0x2e7/0x300 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffff8130ab94>] ?
selinux_file_permission+0xc4/0x120
Nov 07 18:05:40 hostname kernel:  [<ffffffff811fdcbf>] do_fallocate+0x12f/0x1d0
Nov 07 18:05:40 hostname kernel:  [<ffffffff811fdda8>] SyS_fallocate+0x48/0x80
Nov 07 18:05:40 hostname kernel:  [<ffffffff817472e9>]
system_call_fastpath+0x12/0x17
Nov 07 18:05:40 hostname kernel: ---[ end trace 378b089d93843b4d ]---
Nov 07 18:05:40 hostname kernel: ------------[ cut here ]------------
Nov 07 18:05:40 hostname kernel: WARNING: CPU: 5 PID: 2644 at
mm/truncate.c:758 pagecache_isize_extended+0x105/0x110()
Nov 07 18:05:40 hostname kernel: Modules linked in: fuse xt_CHECKSUM
tun ip6t_rpfilter bnep bluetooth ip6t_REJECT nf_reject_ipv6
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute
bridge stp llc ebtable_filter ebtables ip6table_mangle
ip6table_security ip6table_raw ip6table_filter ip6_tables
iptable_mangle iptable_security iptable_raw f71882fg xfs vfat fat
libcrc32c iTCO_wdt iTCO_vendor_support mxm_wmi x86_pkg_temp_thermal
coretemp kvm_intel joydev kvm snd_hda_codec_realtek sb_edac
snd_hda_codec_generic snd_hda_codec_hdmi microcode edac_core serio_raw
snd_hda_intel pcspkr snd_hda_controller snd_hda_codec snd_seq i2c_i801
snd_hwdep snd_seq_device snd_pcm lpc_ich mfd_core snd_timer wmi snd
mei_me mei shpchp soundcore binfmt_misc dm_crypt
Nov 07 18:05:40 hostname kernel:  radeon i2c_algo_bit drm_kms_helper
ttm drm crct10dif_pclmul firewire_ohci e1000e crc32_pclmul
crc32c_intel ghash_clmulni_intel firewire_core i2c_core ptp pps_core
crc_itu_t [last unloaded: ipmi_msghandler]
Nov 07 18:05:40 hostname kernel: CPU: 5 PID: 2644 Comm:
xdg-user-dirs-g Tainted: G        W      3.18.0-rc3+ #508
Nov 07 18:05:40 hostname kernel: Hardware name: MSI MS-7760/X79A-GD65
(8D) (MS-7760), BIOS V1.8 10/18/2012
Nov 07 18:05:40 hostname kernel:  0000000000000009 ffff88040549bd38
ffffffff8173e3ea 0000000000000000
Nov 07 18:05:40 hostname kernel:  0000000000000000 ffff88040549bd78
ffffffff810886a1 ffffea001012d880
Nov 07 18:05:40 hostname kernel:  0000000000001000 ffff8804446bd3d0
0000000000000000 00000000000000ad
Nov 07 18:05:40 hostname kernel: Call Trace:
Nov 07 18:05:40 hostname kernel:  [<ffffffff8173e3ea>] dump_stack+0x46/0x58
Nov 07 18:05:40 hostname kernel:  [<ffffffff810886a1>]
warn_slowpath_common+0x81/0xa0
Nov 07 18:05:40 hostname kernel:  [<ffffffff8108877a>]
warn_slowpath_null+0x1a/0x20
Nov 07 18:05:40 hostname kernel:  [<ffffffff811982e5>]
pagecache_isize_extended+0x105/0x110
Nov 07 18:05:40 hostname kernel:  [<ffffffffa0508300>] ?
__xfs_get_blocks+0x4f0/0x4f0 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffff81199037>]
truncate_setsize+0x27/0x40
Nov 07 18:05:40 hostname kernel:  [<ffffffffa051d8cf>]
xfs_setattr_size+0x13f/0x3c0 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffffa052b736>] ?
xfs_trans_commit+0x146/0x220 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffffa05128c7>]
xfs_file_fallocate+0x2e7/0x300 [xfs]
Nov 07 18:05:40 hostname kernel:  [<ffffffff8130ab94>] ?
selinux_file_permission+0xc4/0x120
Nov 07 18:05:40 hostname kernel:  [<ffffffff811fdcbf>] do_fallocate+0x12f/0x1d0
Nov 07 18:05:40 hostname kernel:  [<ffffffff811fdda8>] SyS_fallocate+0x48/0x80
Nov 07 18:05:40 hostname kernel:  [<ffffffff817472e9>]
system_call_fastpath+0x12/0x17
Nov 07 18:05:40 hostname kernel: ---[ end trace 378b089d93843b4e ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
