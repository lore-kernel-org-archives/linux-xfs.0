Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:53257 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753912AbcJDQVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2016 12:21:35 -0400
Date: Tue, 4 Oct 2016 12:21:28 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <307867218.381779.1475598088901.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161004142805.GX19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com> <20161003014218.GS19539@ZenIV.linux.org.uk> <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com> <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com> <20161003203539.GW19539@ZenIV.linux.org.uk> <1209071853.342152.1475587775353.JavaMail.zimbra@redhat.com> <20161004142805.GX19539@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org


> Not enough information, unfortunately (descriptor in question opened
> outside of that log, sendfile(out_fd=578, in_fd=578, offset=0x7f8318a07000,
> count=0x3ffc00) doesn't tell what *offset was before the call) ;-/
> 
> Anyway, I've found and fixed a bug in pipe_advance(), which might or might
> not help with those.  Could you try vfs.git#work.splice_read (or #for-next)
> and see if these persist?
I am afraid that this can also reproduced in the latest #for-next . The warning
always showed up at the end of trinity run. I captured more information this time.

http://people.redhat.com/qcai/tmp/trinity-child150.log
http://people.redhat.com/qcai/tmp/tri-full.log (big file so may just grep "child150")
http://people.redhat.com/qcai/tmp/trinity.log

[ 2187.697999] ------------[ cut here ]------------
[ 2187.703181] WARNING: CPU: 34 PID: 67630 at lib/iov_iter.c:316 sanity+0x6b/0x6f
[ 2187.713890] Modules linked in: fuse vmac tcp_diag udp_diag inet_diag ieee802154_socket ieee802154 af_key vmw_vsock_vmci_transport vsock vmw_vmci bluetooth rfkill can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr ipmi_ssif i2c_i801 i2c_smbus mei_me sg lpc_ich mei shpchp wmi ipmi_si ipmi_msghandler acpi_pad acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm ahci libahci mdio ptp libata i2c_core pps_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[ 2187.828488] CPU: 29 PID: 67630 Comm: trinity-c150 Not tainted 4.8.0-rc8-fornext+ #1
[ 2187.837034] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 2187.848392]  0000000000000286 00000000a4c9de22 ffff8803f0d5bb30 ffffffff813d30ac
[ 2187.856687]  0000000000000000 0000000000000000 ffff8803f0d5bb70 ffffffff8109cf31
[ 2187.864983]  0000013c1923e8c0 ffffea000db71000 0000000000001000 ffff88044b127200
[ 2187.873282] Call Trace:
[ 2187.876017]  [<ffffffff813d30ac>] dump_stack+0x85/0xc9
[ 2187.881756]  [<ffffffff8109cf31>] __warn+0xd1/0xf0
[ 2187.887104]  [<ffffffff8109d06d>] warn_slowpath_null+0x1d/0x20
[ 2187.893616]  [<ffffffff81418ec8>] sanity+0x6b/0x6f
[ 2187.898967]  [<ffffffff813e97a6>] copy_page_to_iter+0xf6/0x1e0
[ 2187.905478]  [<ffffffff811e3926>] generic_file_read_iter+0x406/0x800
[ 2187.912570]  [<ffffffff810f8b1d>] ? down_read_nested+0x4d/0x80
[ 2187.919123]  [<ffffffffa029b74e>] ? xfs_ilock+0x1ae/0x260 [xfs]
[ 2187.925746]  [<ffffffffa028af2f>] xfs_file_buffered_aio_read+0x6f/0x1b0 [xfs]
[ 2187.933756]  [<ffffffffa028b6e8>] xfs_file_read_iter+0x68/0xc0 [xfs]
[ 2187.940847]  [<ffffffff812bb559>] generic_file_splice_read+0xb9/0x1b0
[ 2187.948034]  [<ffffffff812bbb13>] do_splice_to+0x73/0x90
[ 2187.953962]  [<ffffffff812bbc1b>] splice_direct_to_actor+0xeb/0x220
[ 2187.960955]  [<ffffffff812bb0e0>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 2187.968243]  [<ffffffff812bbdd9>] do_splice_direct+0x89/0xd0
[ 2187.974561]  [<ffffffff8128263e>] do_sendfile+0x1ce/0x3b0
[ 2187.980580]  [<ffffffff812831ef>] SyS_sendfile64+0x6f/0xd0
[ 2187.986698]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[ 2187.992823]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[ 2188.000349] ---[ end trace a3a1d0412c1a1214 ]---
[ 2188.006348] ------------[ cut here ]------------
[ 2188.011842] WARNING: CPU: 26 PID: 67630 at lib/iov_iter.c:316 sanity+0x6b/0x6f
[ 2188.019914] Modules linked in: fuse vmac tcp_diag udp_diag inet_diag ieee802154_socket ieee802154 af_key vmw_vsock_vmci_transport vsock vmw_vmci bluetooth rfkill can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr ipmi_ssif i2c_i801 i2c_smbus mei_me sg lpc_ich mei shpchp wmi ipmi_si ipmi_msghandler acpi_pad acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm ahci libahci mdio ptp libata i2c_core pps_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[ 2188.133408] CPU: 54 PID: 67630 Comm: trinity-c150 Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 2188.143310] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 2188.154667]  0000000000000286 00000000a4c9de22 ffff8803f0d5bb30 ffffffff813d30ac
[ 2188.162962]  0000000000000000 0000000000000000 ffff8803f0d5bb70 ffffffff8109cf31
[ 2188.171257]  0000013c1923e8c8 ffffea000dbbd700 0000000000001000 ffff88044b127200
[ 2188.179551] Call Trace:
[ 2188.182284]  [<ffffffff813d30ac>] dump_stack+0x85/0xc9
[ 2188.188022]  [<ffffffff8109cf31>] __warn+0xd1/0xf0
[ 2188.193368]  [<ffffffff8109d06d>] warn_slowpath_null+0x1d/0x20
[ 2188.199879]  [<ffffffff81418ec8>] sanity+0x6b/0x6f
[ 2188.205227]  [<ffffffff813e97a6>] copy_page_to_iter+0xf6/0x1e0
[ 2188.211738]  [<ffffffff811e3926>] generic_file_read_iter+0x406/0x800
[ 2188.218824]  [<ffffffff810f8b1d>] ? down_read_nested+0x4d/0x80
[ 2188.225363]  [<ffffffffa029b74e>] ? xfs_ilock+0x1ae/0x260 [xfs]
[ 2188.231988]  [<ffffffffa028af2f>] xfs_file_buffered_aio_read+0x6f/0x1b0 [xfs]
[ 2188.239967]  [<ffffffffa028b6e8>] xfs_file_read_iter+0x68/0xc0 [xfs]
[ 2188.247059]  [<ffffffff812bb559>] generic_file_splice_read+0xb9/0x1b0
[ 2188.254246]  [<ffffffff812bbb13>] do_splice_to+0x73/0x90
[ 2188.260174]  [<ffffffff812bbc1b>] splice_direct_to_actor+0xeb/0x220
[ 2188.267168]  [<ffffffff812bb0e0>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 2188.274453]  [<ffffffff812bbdd9>] do_splice_direct+0x89/0xd0
[ 2188.280771]  [<ffffffff8128263e>] do_sendfile+0x1ce/0x3b0
[ 2188.286796]  [<ffffffff812831ef>] SyS_sendfile64+0x6f/0xd0
[ 2188.292918]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[ 2188.299040]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[ 2188.313523] ---[ end trace a3a1d0412c1a1215 ]---
[ 2188.458941] ------------[ cut here ]------------
[ 2188.464181] WARNING: CPU: 10 PID: 67630 at lib/iov_iter.c:316 sanity+0x6b/0x6f
[ 2188.472261] Modules linked in: fuse vmac tcp_diag udp_diag inet_diag ieee802154_socket ieee802154 af_key vmw_vsock_vmci_transport vsock vmw_vmci bluetooth rfkill can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr ipmi_ssif i2c_i801 i2c_smbus mei_me sg lpc_ich mei shpchp wmi ipmi_si ipmi_msghandler acpi_pad acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm ahci libahci mdio ptp libata i2c_core pps_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[ 2188.585528] CPU: 38 PID: 67630 Comm: trinity-c150 Tainted: G        W       4.8.0-rc8-fornext+ #1
[ 2188.595431] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 2188.606786]  0000000000000286 00000000a4c9de22 ffff8803f0d5bb30 ffffffff813d30ac
[ 2188.615082]  0000000000000000 0000000000000000 ffff8803f0d5bb70 ffffffff8109cf31
[ 2188.623379]  0000013c11bafb58 ffffea000ee78980 0000000000001000 ffff88044b127200
[ 2188.631675] Call Trace:
[ 2188.634410]  [<ffffffff813d30ac>] dump_stack+0x85/0xc9
[ 2188.640148]  [<ffffffff8109cf31>] __warn+0xd1/0xf0
[ 2188.645497]  [<ffffffff8109d06d>] warn_slowpath_null+0x1d/0x20
[ 2188.652324]  [<ffffffff81418ec8>] sanity+0x6b/0x6f
[ 2188.657672]  [<ffffffff813e97a6>] copy_page_to_iter+0xf6/0x1e0
[ 2188.664185]  [<ffffffff811e3926>] generic_file_read_iter+0x406/0x800
[ 2188.671268]  [<ffffffff810f8b1d>] ? down_read_nested+0x4d/0x80
[ 2188.677825]  [<ffffffffa029b74e>] ? xfs_ilock+0x1ae/0x260 [xfs]
[ 2188.684450]  [<ffffffffa028af2f>] xfs_file_buffered_aio_read+0x6f/0x1b0 [xfs]
[ 2188.692433]  [<ffffffffa028b6e8>] xfs_file_read_iter+0x68/0xc0 [xfs]
[ 2188.699525]  [<ffffffff812bb559>] generic_file_splice_read+0xb9/0x1b0
[ 2188.706711]  [<ffffffff812bbb13>] do_splice_to+0x73/0x90
[ 2188.712638]  [<ffffffff812bbc1b>] splice_direct_to_actor+0xeb/0x220
[ 2188.719632]  [<ffffffff812bb0e0>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 2188.726916]  [<ffffffff812bbdd9>] do_splice_direct+0x89/0xd0
[ 2188.733231]  [<ffffffff8128263e>] do_sendfile+0x1ce/0x3b0
[ 2188.739255]  [<ffffffff812831ef>] SyS_sendfile64+0x6f/0xd0
[ 2188.745377]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[ 2188.751500]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[ 2188.760216] ---[ end trace a3a1d0412c1a1216 ]---
