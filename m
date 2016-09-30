Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:53901 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932430AbcI3RmZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 13:42:25 -0400
Date: Fri, 30 Sep 2016 13:42:17 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
In-Reply-To: <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com> <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk> <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk> <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
Subject: Re: [RFC][CFT] splice_read reworked
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "Al Viro" <viro@ZenIV.linux.org.uk>
> Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>, "linux-xfs"
> <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> linux-fsdevel@vger.kernel.org
> Sent: Friday, September 30, 2016 9:32:53 AM
> Subject: Re: [RFC][CFT] splice_read reworked
> 
> 
> 
> ----- Original Message -----
> > From: "Al Viro" <viro@ZenIV.linux.org.uk>
> > To: "Linus Torvalds" <torvalds@linux-foundation.org>
> > Cc: "Dave Chinner" <david@fromorbit.com>, "CAI Qian" <caiqian@redhat.com>,
> > "linux-xfs" <linux-xfs@vger.kernel.org>,
> > xfs@oss.sgi.com, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin"
> > <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org
> > Sent: Friday, September 23, 2016 3:00:32 PM
> > Subject: [RFC][CFT] splice_read reworked
> > 
> > The series is supposed to solve the locking order problems for
> > ->splice_read() and get rid of code duplication between the read-side
> > methods.
> > 	pipe_lock is lifted out of ->splice_read() instances, along with
> > waiting for empty space in pipe, etc. - we do that stuff in callers.
> > 	A new variant of iov_iter is introduced - it's backed by a pipe,
> > copy_to_iter() results in allocating pages and copying into those,
> > copy_page_to_iter() just sticks a reference to that page into pipe.
> > Running out of space in pipe yields a short read, as a fault in
> > iovec-backed
> > iov_iter would have.  Enough primitives are implemented for normal
> > ->read_iter() instances to work.
> > 	generic_file_splice_read() switched to feeding such iov_iter to
> > ->read_iter() instance.  That turns out to be enough to kill almost all
> > ->splice_read() instances; the only ones _not_ using
> > generic_file_splice_read()
> > or default_file_splice_read() (== no zero-copy fallback) are
> > fuse_dev_splice_read(), 3 instances in kernel/{relay.c,trace/trace.c} and
> > sock_splice_read().  It's almost certainly possible to convert fuse one
> > and the same might be possible to do to socket one.  relay and tracing
> > stuff is just plain weird; might or might not be doable.
> > 
> > 	Something hopefully working is in
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
> > #work.splice_read
> Tested-by: CAI Qian <caiqian@redhat.com>

Except...

One warning just pop up while running trinity.

[ 1599.151286] ------------[ cut here ]------------
[ 1599.156457] WARNING: CPU: 37 PID: 95143 at lib/iov_iter.c:316 sanity+0x75/0x80
[ 1599.164818] Modules linked in: af_key ieee802154_socket ieee802154 vmw_vsock_vmci_transport vsock vmw_vmci hidp cmtp kernelcapi bnep rfcomm bluetooth rfkill can_bcm can_raw can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr mei_me sg i2c_i801 mei shpchp lpc_ich i2c_smbus ipmi_ssif wmi ipmi_si ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod sr_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm ahci mdio libahci ptp libata i2c_core pps_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
[ 1599.278669] CPU: 50 PID: 95143 Comm: trinity-c142 Not tainted 4.8.0-rc8-usrns-scale+ #8
[ 1599.287604] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 1599.298962]  0000000000000286 000000007794c41e ffff8803c6c7fbb0 ffffffff813d5e93
[ 1599.307259]  0000000000000000 0000000000000000 ffff8803c6c7fbf0 ffffffff8109c87b
[ 1599.315553]  0000013c00000000 0000000000000efe ffffea001de95240 ffff8802e1aca600
[ 1599.323847] Call Trace:
[ 1599.326580]  [<ffffffff813d5e93>] dump_stack+0x85/0xc2
[ 1599.332315]  [<ffffffff8109c87b>] __warn+0xcb/0xf0
[ 1599.337660]  [<ffffffff8109c9ad>] warn_slowpath_null+0x1d/0x20
[ 1599.344171]  [<ffffffff813e9b45>] sanity+0x75/0x80
[ 1599.349518]  [<ffffffff813ec739>] copy_page_to_iter+0xf9/0x1e0
[ 1599.356027]  [<ffffffff8120691f>] shmem_file_read_iter+0x9f/0x340
[ 1599.362829]  [<ffffffff812bbeb9>] generic_file_splice_read+0xb9/0x1b0
[ 1599.370015]  [<ffffffff812bc206>] do_splice_to+0x76/0x90
[ 1599.375941]  [<ffffffff812bc2db>] splice_direct_to_actor+0xbb/0x220
[ 1599.382935]  [<ffffffff812bba80>] ? generic_pipe_buf_nosteal+0x10/0x10
[ 1599.390220]  [<ffffffff812bc4d8>] do_splice_direct+0x98/0xd0
[ 1599.396537]  [<ffffffff81281dd1>] do_sendfile+0x1d1/0x3b0
[ 1599.402563]  [<ffffffff81282973>] SyS_sendfile64+0x73/0xd0
[ 1599.408685]  [<ffffffff81003f8c>] do_syscall_64+0x6c/0x1e0
[ 1599.414820]  [<ffffffff817d927f>] entry_SYSCALL64_slow_path+0x25/0x25
[ 1599.422087] ---[ end trace a3fb2953df356f80 ]---

    CAI Qian
