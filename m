Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:49807 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750700AbcJEOay (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 10:30:54 -0400
Date: Wed, 5 Oct 2016 10:30:46 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <2021832942.615635.1475677846489.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161004201232.GA19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com> <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com> <20161003203539.GW19539@ZenIV.linux.org.uk> <1209071853.342152.1475587775353.JavaMail.zimbra@redhat.com> <20161004142805.GX19539@ZenIV.linux.org.uk> <307867218.381779.1475598088901.JavaMail.zimbra@redhat.com> <20161004201232.GA19539@ZenIV.linux.org.uk>
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
> Sent: Tuesday, October 4, 2016 4:12:33 PM
> Subject: Re: [RFC][CFT] splice_read reworked
> 
> On Tue, Oct 04, 2016 at 12:21:28PM -0400, CAI Qian wrote:
> > 
> > > Not enough information, unfortunately (descriptor in question opened
> > > outside of that log, sendfile(out_fd=578, in_fd=578,
> > > offset=0x7f8318a07000,
> > > count=0x3ffc00) doesn't tell what *offset was before the call) ;-/
> > > 
> > > Anyway, I've found and fixed a bug in pipe_advance(), which might or
> > > might
> > > not help with those.  Could you try vfs.git#work.splice_read (or
> > > #for-next)
> > > and see if these persist?
> > I am afraid that this can also reproduced in the latest #for-next . The
> > warning
> > always showed up at the end of trinity run. I captured more information
> > this time.
> 
> OK, let's try to get more information about what's going on (this is on top
> of either for-next or work.splice_read):
Here you go,

http://people.redhat.com/qcai/tmp/trinity-child89.log


[  856.537452] idx = 0, offset = 12
[  856.541066] curbuf = 0, nrbufs = 1, buffers = 1
[  856.546149] [ffffffff81836660 ffffea001e2e1ec0 0 12]
[  856.551750] ------------[ cut here ]------------
[  856.556921] WARNING: CPU: 24 PID: 13756 at lib/iov_iter.c:325 sanity+0xdb/0xe2
[  856.565000] Modules linked in: ieee802154_socket ieee802154 af_key vmw_vsock_vmci_transport vsock vmw_vmci bluetooth rfkill can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr mei_me i2c_i801 ipmi_ssif sg i2c_smbus mei shpchp lpc_ich wmi ipmi_si ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod cdrom sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect crc32c_intel sysimgblt fb_sys_fops ttm ixgbe ahci drm mdio libahci ptp libata pps_core i2c_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[  856.683348] CPU: 27 PID: 13756 Comm: trinity-c89 Not tainted 4.8.0-rc8-fornext-debug+ #2
[  856.692380] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[  856.703736]  0000000000000286 00000000cf291d96 ffff8803c355fae0 ffffffff813d30ac
[  856.712034]  0000000000000000 0000000000000000 ffff8803c355fb20 ffffffff8109cf31
[  856.720329]  00000145c355fb00 ffff8804586e3200 0000000000000001 0000000000000000
[  856.728627] Call Trace:
[  856.731362]  [<ffffffff813d30ac>] dump_stack+0x85/0xc9
[  856.737099]  [<ffffffff8109cf31>] __warn+0xd1/0xf0
[  856.742444]  [<ffffffff8109d06d>] warn_slowpath_null+0x1d/0x20
[  856.748953]  [<ffffffff81418ff8>] sanity+0xdb/0xe2
[  856.754299]  [<ffffffff813e9676>] iov_iter_advance+0x1d6/0x3c0
[  856.760810]  [<ffffffff812bc7d3>] default_file_splice_read+0x223/0x2c0
[  856.768099]  [<ffffffff812503bb>] ? __slab_free+0x9b/0x270
[  856.774222]  [<ffffffff811222d8>] ? __call_rcu+0xd8/0x380
[  856.780258]  [<ffffffff810cbaa9>] ? __might_sleep+0x49/0x80
[  856.786480]  [<ffffffff81349ded>] ? security_file_permission+0x9d/0xc0
[  856.793777]  [<ffffffff812bbb13>] do_splice_to+0x73/0x90
[  856.799703]  [<ffffffff812bbc1b>] splice_direct_to_actor+0xeb/0x220
[  856.806696]  [<ffffffff812bb0e0>] ? generic_pipe_buf_nosteal+0x10/0x10
[  856.813982]  [<ffffffff812bbdd9>] do_splice_direct+0x89/0xd0
[  856.820299]  [<ffffffff8128263e>] do_sendfile+0x1ce/0x3b0
[  856.826323]  [<ffffffff812831ef>] SyS_sendfile64+0x6f/0xd0
[  856.832445]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[  856.838568]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
[  856.845810] ---[ end trace 702eb33216129766 ]---
[  856.851032] buggered pipe_advance by 12 from [0.0]
