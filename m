Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:44580 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbcJDN3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2016 09:29:42 -0400
Date: Tue, 4 Oct 2016 09:29:35 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1209071853.342152.1475587775353.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161003203539.GW19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20160923190032.GA25771@ZenIV.linux.org.uk> <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com> <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com> <20161003014218.GS19539@ZenIV.linux.org.uk> <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com> <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com> <20161003203539.GW19539@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "Al Viro" <viro@ZenIV.linux.org.uk>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>, "linux-xfs"
> <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> linux-fsdevel@vger.kernel.org
> Sent: Monday, October 3, 2016 4:35:40 PM
> Subject: Re: [RFC][CFT] splice_read reworked
> 
> On Mon, Oct 03, 2016 at 04:32:19PM -0400, CAI Qian wrote:
> > > It is pretty reproducible so far by just running the trinity from a
> > > docker
> > > container backed by overlayfs/xfs.
> > > 
> > > # su - test
> > > $ trinity
> > Also, AFACIT, this is NOT reproducible on v4.8 mainline, but only with this
> > splice_read reworked branch of vfs tree.
> 
> I would be very surprised if mainline had somehow managed to trip sanity
> checks added in vfs tree ;-)
> 
> Is there any way to record the sequence of syscalls leading to that?
> 
Yes, a bit long shot though.

http://people.redhat.com/qcai/tmp/trinity-child113.log

This one triggered the warning at lib/iov_iter.c:316 sanity+0x6b/0x6
3 times at once.

[ 2200.510753] ------------[ cut here ]------------
[ 2200.515929] WARNING: CPU: 9 PID: 116624 at lib/iov_iter.c:316 sanity+0x6b/0x6f
[ 2200.523999] Modules linked in: 8021q garp mrp fuse dlci vmw_vsock_vmci_transport vsock vmw_vmci af_key ieee802154_socket ieee802154 hidp cmtp kernelcapi bnep rfcomm bluetooth rfkill can_bcm can_raw can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr i2c_i801 i2c_smbus mei_me ipmi_ssif sg lpc_ich mei shpchp wmi ipmi_si ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm ahci mdio libahci ptp libata pps_core i2c_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[ 2200.644251] CPU: 9 PID: 116624 Comm: trinity-c113 Not tainted 4.8.0-rc8-splice+ #1
[ 2200.652708] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 2200.664062]  0000000000000286 00000000bad46fa7 ffff8803d1ca7b30 ffffffff813d2eac
[ 2200.672368]  0000000000000000 0000000000000000 ffff8803d1ca7b70 ffffffff8109cf11
[ 2200.680660]  0000013c2e32bdc8 ffffea000eea7540 0000000000001000 ffff88030e9a0000
[ 2200.688954] Call Trace:
[ 2200.691686]  [<ffffffff813d2eac>] dump_stack+0x85/0xc9
[ 2200.697433]  [<ffffffff8109cf11>] __warn+0xd1/0xf0
[ 2200.702777]  [<ffffffff8109d04d>] warn_slowpath_null+0x1d/0x20
[ 2200.709285]  [<ffffffff81418c93>] sanity+0x6b/0x6f
[ 2200.714630]  [<ffffffff813e9586>] copy_page_to_iter+0xf6/0x1e0
[ 2200.721139]  [<ffffffff811e3906>] generic_file_read_iter+0x406/0x800
[ 2200.728231]  [<ffffffff810f8afd>] ? down_read_nested+0x4d/0x80
[ 2200.734798]  [<ffffffffa02c46ae>] ? xfs_ilock+0x1ae/0x260 [xfs]
[ 2200.741433]  [<ffffffffa02b3f2f>] xfs_file_buffered_aio_read+0x6f/0x1b0 [xfs]
[ 2200.749412]  [<ffffffffa02b46e8>] xfs_file_read_iter+0x68/0xc0 [xfs]
[ 2200.756504]  [<ffffffff812bb359>] generic_file_splice_read+0xb9/0x1b0
[ 2200.763691]  [<ffffffff812bb913>] do_splice_to+0x73/0x90
[ 2200.769618]  [<ffffffff812bba1b>] splice_direct_to_actor+0xeb/0x220
[ 2200.776610]  [<ffffffff812baee0>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 2200.783893]  [<ffffffff812bbbd9>] do_splice_direct+0x89/0xd0
[ 2200.790207]  [<ffffffff8128261e>] do_sendfile+0x1ce/0x3b0
[ 2200.796231]  [<ffffffff812831df>] SyS_sendfile64+0x6f/0xd0
[ 2200.802351]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[ 2200.808471]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[ 2200.815723] ---[ end trace e02dda43787dce2a ]---
[ 2200.821003] ------------[ cut here ]------------
[ 2200.826168] WARNING: CPU: 9 PID: 116624 at lib/iov_iter.c:316 sanity+0x6b/0x6f
[ 2200.834765] Modules linked in: 8021q garp mrp fuse dlci vmw_vsock_vmci_transport vsock vmw_vmci af_key ieee802154_socket ieee802154 hidp cmtp kernelcapi bnep rfcomm bluetooth rfkill can_bcm can_raw can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr i2c_i801 i2c_smbus mei_me ipmi_ssif sg lpc_ich mei shpchp wmi ipmi_si ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm ahci mdio libahci ptp libata pps_core i2c_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[ 2200.951286] CPU: 9 PID: 116624 Comm: trinity-c113 Tainted: G        W       4.8.0-rc8-splice+ #1
[ 2200.961088] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 2200.972443]  0000000000000286 00000000bad46fa7 ffff8803d1ca7b30 ffffffff813d2eac
[ 2200.980747]  0000000000000000 0000000000000000 ffff8803d1ca7b70 ffffffff8109cf11
[ 2200.989078]  0000013c00000000 ffffea000b711880 0000000000001000 ffff88030e9a0000
[ 2200.997375] Call Trace:
[ 2201.000107]  [<ffffffff813d2eac>] dump_stack+0x85/0xc9
[ 2201.005842]  [<ffffffff8109cf11>] __warn+0xd1/0xf0
[ 2201.011199]  [<ffffffff8109d04d>] warn_slowpath_null+0x1d/0x20
[ 2201.017708]  [<ffffffff81418c93>] sanity+0x6b/0x6f
[ 2201.023053]  [<ffffffff813e9586>] copy_page_to_iter+0xf6/0x1e0
[ 2201.029562]  [<ffffffff811e3906>] generic_file_read_iter+0x406/0x800
[ 2201.036654]  [<ffffffff810f8afd>] ? down_read_nested+0x4d/0x80
[ 2201.043213]  [<ffffffffa02c46ae>] ? xfs_ilock+0x1ae/0x260 [xfs]
[ 2201.049849]  [<ffffffffa02b3f2f>] xfs_file_buffered_aio_read+0x6f/0x1b0 [xfs]
[ 2201.057828]  [<ffffffffa02b46e8>] xfs_file_read_iter+0x68/0xc0 [xfs]
[ 2201.064919]  [<ffffffff812bb359>] generic_file_splice_read+0xb9/0x1b0
[ 2201.072108]  [<ffffffff812bb913>] do_splice_to+0x73/0x90
[ 2201.078034]  [<ffffffff812bba1b>] splice_direct_to_actor+0xeb/0x220
[ 2201.085026]  [<ffffffff812baee0>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 2201.092309]  [<ffffffff812bbbd9>] do_splice_direct+0x89/0xd0
[ 2201.098623]  [<ffffffff8128261e>] do_sendfile+0x1ce/0x3b0
[ 2201.104646]  [<ffffffff812831df>] SyS_sendfile64+0x6f/0xd0
[ 2201.110768]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[ 2201.116890]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[ 2201.124136] ---[ end trace e02dda43787dce2b ]---
[ 2201.192680] ------------[ cut here ]------------
[ 2201.203826] WARNING: CPU: 9 PID: 116624 at lib/iov_iter.c:316 sanity+0x6b/0x6f
[ 2201.211899] Modules linked in: 8021q garp mrp fuse dlci vmw_vsock_vmci_transport vsock vmw_vmci af_key ieee802154_socket ieee802154 hidp cmtp kernelcapi bnep rfcomm bluetooth rfkill can_bcm can_raw can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr i2c_i801 i2c_smbus mei_me ipmi_ssif sg lpc_ich mei shpchp wmi ipmi_si ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm ahci mdio libahci ptp libata pps_core i2c_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[ 2201.329000] CPU: 9 PID: 116624 Comm: trinity-c113 Tainted: G        W       4.8.0-rc8-splice+ #1
[ 2201.338805] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 2201.350160]  0000000000000286 00000000bad46fa7 ffff8803d1ca7b30 ffffffff813d2eac
[ 2201.358455]  0000000000000000 0000000000000000 ffff8803d1ca7b70 ffffffff8109cf11
[ 2201.366747]  0000013c00000000 ffffea000be93cc0 0000000000001000 ffff88030e9a0000
[ 2201.375035] Call Trace:
[ 2201.377767]  [<ffffffff813d2eac>] dump_stack+0x85/0xc9
[ 2201.383499]  [<ffffffff8109cf11>] __warn+0xd1/0xf0
[ 2201.388843]  [<ffffffff8109d04d>] warn_slowpath_null+0x1d/0x20
[ 2201.395351]  [<ffffffff81418c93>] sanity+0x6b/0x6f
[ 2201.400695]  [<ffffffff813e9586>] copy_page_to_iter+0xf6/0x1e0
[ 2201.407204]  [<ffffffff811e3906>] generic_file_read_iter+0x406/0x800
[ 2201.414294]  [<ffffffff810f8afd>] ? down_read_nested+0x4d/0x80
[ 2201.420844]  [<ffffffffa02c46ae>] ? xfs_ilock+0x1ae/0x260 [xfs]
[ 2201.427463]  [<ffffffffa02b3f2f>] xfs_file_buffered_aio_read+0x6f/0x1b0 [xfs]
[ 2201.435451]  [<ffffffffa02b46e8>] xfs_file_read_iter+0x68/0xc0 [xfs]
[ 2201.442542]  [<ffffffff812bb359>] generic_file_splice_read+0xb9/0x1b0
[ 2201.449728]  [<ffffffff812bb913>] do_splice_to+0x73/0x90
[ 2201.455655]  [<ffffffff812bba1b>] splice_direct_to_actor+0xeb/0x220
[ 2201.462645]  [<ffffffff812baee0>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 2201.469928]  [<ffffffff812bbbd9>] do_splice_direct+0x89/0xd0
[ 2201.476242]  [<ffffffff8128261e>] do_sendfile+0x1ce/0x3b0
[ 2201.482264]  [<ffffffff812831df>] SyS_sendfile64+0x6f/0xd0
[ 2201.488383]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[ 2201.494504]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[ 2201.501736] ---[ end trace e02dda43787dce2c ]---

   CAI Qian
