Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:62748 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751554AbcJCVMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 17:12:52 -0400
Date: Tue, 4 Oct 2016 08:12:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][CFT] splice_read reworked
Message-ID: <20161003211229.GN27872@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
 <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
 <20161003014218.GS19539@ZenIV.linux.org.uk>
 <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com>
 <59188294.61623.1475508050989.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <59188294.61623.1475508050989.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Mon, Oct 03, 2016 at 11:20:50AM -0400, CAI Qian wrote:
> > container backed by overlayfs/xfs.
> There is another warning happened once so far. Not sure if related.
> 
> [  447.961826] ------------[ cut here ]------------
> [  447.967020] WARNING: CPU: 39 PID: 27352 at fs/xfs/xfs_file.c:626 xfs_file_dio_aio_write+0x3dc/0x4b0 [xfs]
> [  447.977736] Modules linked in: ieee802154_socket ieee802154 af_key vmw_vsock_vmci_transport vsock vmw_vmci bluetooth rfkill can pptp gre l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppoe pppox ppp_generic slhc nfnetlink scsi_transport_iscsi atm sctp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc overlay intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr i2c_i801 i2c_smbus ipmi_ssif mei_me sg mei shpchp lpc_ich wmi ipmi_si ipmi_msghandler acpi_pad acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops crc32c_intel ttm ixgbe drm mdio ahci ptp libahci pps_core libata i2c_core dca fjes dm_mirror dm_region_hash dm_log dm_mod
> [  448.086775] CPU: 39 PID: 27352 Comm: trinity-c39 Not tainted 4.8.0-rc8-splice+ #1
> [  448.095126] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
> [  448.106483]  0000000000000286 00000000389140f2 ffff880404833c48 ffffffff813d2eac
> [  448.114776]  0000000000000000 0000000000000000 ffff880404833c88 ffffffff8109cf11
> [  448.123067]  00000272389140f2 ffff880404833d80 ffff880404833dd8 ffff8803bfba88e8
> [  448.131356] Call Trace:
> [  448.134088]  [<ffffffff813d2eac>] dump_stack+0x85/0xc9
> [  448.139821]  [<ffffffff8109cf11>] __warn+0xd1/0xf0
> [  448.145167]  [<ffffffff8109d04d>] warn_slowpath_null+0x1d/0x20
> [  448.151705]  [<ffffffffa044165c>] xfs_file_dio_aio_write+0x3dc/0x4b0 [xfs]
> [  448.159394]  [<ffffffffa0441b10>] xfs_file_write_iter+0x90/0x130 [xfs]
> [  448.166679]  [<ffffffff81280eee>] do_iter_readv_writev+0xae/0x130
> [  448.173479]  [<ffffffff81281992>] do_readv_writev+0x1a2/0x230
> [  448.179906]  [<ffffffffa0441a80>] ? xfs_file_buffered_aio_write+0x350/0x350 [xfs]
> [  448.188256]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
> [  448.195347]  [<ffffffff810fce1d>] ? trace_hardirqs_on+0xd/0x10
> [  448.201855]  [<ffffffff8117729f>] ? __audit_syscall_entry+0xaf/0x100
> [  448.208944]  [<ffffffff81281c6c>] vfs_writev+0x3c/0x50
> [  448.214675]  [<ffffffff81281e22>] do_pwritev+0xa2/0xc0
> [  448.220407]  [<ffffffff81282f11>] SyS_pwritev+0x11/0x20
> [  448.226237]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [  448.232358]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [  448.239560] ---[ end trace 1c54e743f1fa4f5e ]---

This usually happens when an application mixes mmap access and
direct IO to the same file. The warning fires when the direct IO
cannot invalidate the cached range after writeback (e.g. writeback
raced with mmap app faulting and dirtying the page again), and hence
results in the page cache containing stale data.  This warning fires
when that happens, indicating to developers who get a bug report
about data corruption that it's the userspace application that is
the problem, not the filesystem. i.e the application is doing
something we explicitly document they should not do:

$ man 2 open
....
  O_DIRECT
....
       Applications should avoid mixing O_DIRECT and normal I/O to
       the same file, and especially to overlapping byte regions in
       the  same  file.   Even  when  the filesystem  correctly
       handles the coherency issues in this situation, overall I/O
       throughput is likely to be slower than using either mode
       alone.  Likewise, applications should avoid mixing mmap(2) of
       files with direct I/O to the same files.

Splice should not have this problem if the IO path locking is
correct, as both direct IO and splice IO use the same inode lock for
exclusion. i.e. splice write should not be running at the same time
as a direct IO read or write....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
