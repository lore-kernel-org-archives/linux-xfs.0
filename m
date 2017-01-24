Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mifar.in ([46.101.129.31]:38044 "EHLO mifar.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750795AbdAXPi0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 10:38:26 -0500
Received: from mifar.in (host-109-204-179-171.tp-fne.tampereenpuhelin.net [109.204.179.171])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mifar.in", Issuer "mifar.in" (verified OK))
        by mifar.in (Postfix) with ESMTPS id 56BDF5FA63
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2017 17:30:51 +0200 (EET)
Date: Tue, 24 Jan 2017 17:30:50 +0200
From: Sami Farin <hvtaifwkbgefbaei@gmail.com>
Subject: 4.9.5: general protection fault: 0000:
 xfs_fs_destroy_inode+0x74/0x240
Message-ID: <20170124153050.7mhl6gzofnrkscop@m.mifar.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I got this after running borg backup (repo is 60 GiB).
x86_64 system..   

CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y

kernel: general protection fault: 0000 [#1] PREEMPT SMP
kernel: Modules linked in: nls_iso8859_1 nls_cp437 vfat fat snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi usblp uas usb_storage nf_conntrack_netlink fuse nfnetlink_acct ip6table_mangle nf_log_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6table_filter ip6_tables ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat iptable_raw xt_mark xt_connmark iptable_mangle ipt_REJECT nf_reject_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_length xt_limit xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_connlimit xt_owner xt_hashlimit xt_multiport xt_conntrack nf_conntrack xt_set iptable_filter ip_set_hash_net ip_set nfnetlink cls_fw sch_pie sch_htb arptable_filter arp_tables cfg80211 w83627ehf hwmon_vid btusb btrtl btbcm btintel bluetooth rfkill coretemp hwmon kvm_intel kvm iTCO_wdt iTCO_vendor_support
kernel: mxm_wmi irqbypass snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic i2c_i801 lpc_ich i2c_smbus snd_hda_intel snd_hda_codec snd_hda_core battery rtc_cmos acpi_cpufreq tcp_cubic sch_fq_codel binfmt_misc snd_pcm_oss snd_seq snd_seq_device snd_pcm snd_timer ip_tables x_tables algif_skcipher af_alg usbhid ehci_pci xhci_pci xhci_hcd ehci_hcd i915 r8169 mii e1000e ptp usbcore usb_common pps_core fjes wmi video button 8021q mrp scsi_transport_iscsi sunrpc snd_mixer_oss snd soundcore analog gameport joydev i2c_dev ecryptfs autofs4 [last unloaded: pcspkr]
kernel: CPU: 2 PID: 26508 Comm: rclone Not tainted 4.9.5+ #83
kernel: Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3402 05/07/2012
kernel: task: ffff8f0b65fb2a00 task.stack: ffff929c02f64000
kernel: RIP: 0010:[<ffffffffbc3aaf34>]  [<ffffffffbc3aaf34>] xfs_fs_destroy_inode+0x74/0x240
kernel: RSP: 0018:ffff929c02f67840  EFLAGS: 00010203
kernel: RAX: 6e690182d238636e RBX: ffff8f0afaad62c0 RCX: 0000000000000002
kernel: RDX: 0000000000022800 RSI: 0000000000000000 RDI: ffff8f0afaad62c0
kernel: RBP: ffff929c02f67860 R08: 0000000000000000 R09: 0000000000000000
kernel: R10: 0000000000000001 R11: 0000000000000000 R12: ffff8f0afaad62c0
kernel: R13: ffff8f0afaad6000 R14: 0000000000000000 R15: 0000000000000145
kernel: FS:  000000c422444068(0000) GS:ffff8f0e5f100000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00003a70c2a10000 CR3: 0000000402eb8000 CR4: 00000000000406e0
kernel: Stack:
kernel: ffff8f0afaad62c0 ffff8f0afaad6348 ffffffffbca3c380 0000000000000000
kernel: ffff929c02f67878 ffffffffbc228356 ffff8f0afaad62c0 ffff929c02f678a0
kernel: ffffffffbc2284ad ffff929c02f678c8 00000000000000ae ffff929c02f679d8
kernel: Call Trace:
kernel: [<ffffffffbc228356>] destroy_inode+0x36/0x60
kernel: [<ffffffffbc2284ad>] evict+0x12d/0x190
kernel: [<ffffffffbc228544>] dispose_list+0x34/0x40
kernel: [<ffffffffbc2297b6>] prune_icache_sb+0x46/0x60
kernel: [<ffffffffbc20f8e9>] super_cache_scan+0x149/0x1a0
kernel: [<ffffffffbc1aef7e>] shrink_slab.part.15+0x22e/0x4b0
kernel: [<ffffffffbc1af22f>] shrink_slab+0x2f/0x40
kernel: [<ffffffffbc1b2d5b>] shrink_node+0xeb/0x2e0
kernel: [<ffffffffbc1b3017>] do_try_to_free_pages+0xc7/0x2d0
kernel: [<ffffffffbc1b32ee>] try_to_free_pages+0xce/0x210
kernel: [<ffffffffbc1a3248>] __alloc_pages_nodemask+0x538/0xd60
kernel: [<ffffffffbc2088cf>] ? __check_object_size+0x4f/0x1e0
kernel: [<ffffffffbc7fa8a1>] skb_page_frag_refill+0xa1/0xd0
kernel: [<ffffffffbc7fa8e8>] sk_page_frag_refill+0x18/0x70
kernel: [<ffffffffbc86a49d>] tcp_sendmsg+0x1bd/0xb80
kernel: [<ffffffffbc8960c9>] inet_sendmsg+0xb9/0xe0
kernel: [<ffffffffbc896010>] ? inet_recvmsg+0xe0/0xe0
kernel: [<ffffffffbc7f63d3>] sock_sendmsg+0x33/0x40
kernel: [<ffffffffbc7f6456>] sock_write_iter+0x76/0xd0
kernel: [<ffffffffbc20b0e1>] __vfs_write+0xc1/0x120
kernel: [<ffffffffbc20bd81>] vfs_write+0xb1/0x1a0
kernel: [<ffffffffbc20d0a4>] SyS_write+0x44/0xb0
kernel: [<ffffffffbc94c177>] entry_SYSCALL_64_fastpath+0x1a/0xae
kernel: Code: 6d 01 48 89 d0 48 03 04 cd e0 63 d7 bc 83 80 fc 00 00 00 01 49 8b 84 24 40 fd ff ff 48 8b 80 b0 0c 00 00 48 03 04 cd e0 63 d7 bc <83> 80 fc 00 00 00 01 48 8b 0c cd e0 63 d7 bc 83 84 0a 04 01 00 
kernel: RIP  [<ffffffffbc3aaf34>] xfs_fs_destroy_inode+0x74/0x240
kernel: RSP <ffff929c02f67840>
kernel: ---[ end trace 80ed9d5315cd3a44 ]---

/proc/meminfo after borg exited:

MemTotal:       16290420 kB
MemFree:          626832 kB
MemAvailable:    9860784 kB
Buffers:             236 kB
Cached:          4914920 kB
SwapCached:            0 kB
Active:          7837260 kB
Inactive:        1215000 kB
Active(anon):    4160068 kB
Inactive(anon):   463596 kB
Active(file):    3677192 kB
Inactive(file):   751404 kB
Unevictable:          64 kB
Mlocked:              64 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:               164 kB
Writeback:             0 kB
AnonPages:       4123668 kB
Mapped:           545700 kB
Shmem:            486560 kB
Slab:            5419860 kB
SReclaimable:    5140848 kB
SUnreclaim:       279012 kB
KernelStack:       14208 kB
PageTables:        77948 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     8112440 kB
Committed_AS:   11563476 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
AnonHugePages:   1232896 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
HugePages_Total:      32
HugePages_Free:       32
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:     1777184 kB
DirectMap2M:    14895104 kB

I had vm.vfs_cache_pressure=50


-- 
