Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22076 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdFNPz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2017 11:55:27 -0400
Date: Wed, 14 Jun 2017 08:55:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS Calltraces by using XFS with Ceph
Message-ID: <20170614155513.GQ4530@birch.djwong.org>
References: <ff5af7a48b502752faac6f2bbc1c3bb7@jonas-server.de>
 <20170614120829.GA65212@bfoster.bfoster>
 <b447cdcdc5a7278c6a9cc46627e22c94@jonas-server.de>
 <20170614140732.GA857@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170614140732.GA857@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: list@jonas-server.de, linux-xfs@vger.kernel.org

On Wed, Jun 14, 2017 at 10:07:32AM -0400, Brian Foster wrote:
> On Wed, Jun 14, 2017 at 03:22:36PM +0200, list@jonas-server.de wrote:
> > I get this output of gdb:
> > 
> > # gdb /usr/lib/debug/lib/modules/4.4.0-75-generic/kernel/fs/xfs/xfs.ko
> > GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.04) 7.11.1
> > [...]
> > Reading symbols from
> > /usr/lib/debug/lib/modules/4.4.0-75-generic/kernel/fs/xfs/xfs.ko...done.
> > (gdb) list *xfs_da3_node_read+0x30
> > 0x2b5d0 is in xfs_da3_node_read
> > (/build/linux-Hlembm/linux-4.4.0/fs/xfs/libxfs/xfs_da_btree.c:270).
> > 265	/build/linux-Hlembm/linux-4.4.0/fs/xfs/libxfs/xfs_da_btree.c: No such
> > file or directory.
> > 
> 
> This would be more helpful if you had the source code available. :P
> 
> Anyways, I suspect you have a NULL buffer (though I'm not sure where the
> 0xa0 offset comes from). There have been a couple fixes in that area
> that come to mind, but it looks to me that v4.4 kernels should already
> have them.  Otherwise, this doesn't ring any bells for me. Perhaps
> somebody else can chime in on that.
> 
> I suppose the best next step is to try a more recent, non-distro kernel.
> If the problem still occurs, see if you can provide a crash dump for
> analysis.

I wonder if this is a longstanding quirk of the dabtree reader routines
where they call xfs_trans_buf_set_type() after xfs_da_read_buf() without
actually checking that *bpp point to a buffer, which is what you get if
the fork offset maps to a hole.  In theory the dabtree shouldn't ever
point to a hole, but I've seen occasional bug reports about that
happening, and we could do better than just crashing. :)

(I was working on a patch to fix all the places where we stumble over a
NULL bp, but it produced xfstest regressions and then I got distracted.)

Looking at the new Elixir[1], it looks like we're trying to deref
((*bpp)->b_addr)->magic, so that might explain the crash you see.

--D

[1] http://elixir.free-electrons.com/linux/v4.4.72/source/fs/xfs/libxfs/xfs_da_btree.c#L270

> 
> Brian
> 
> > Am 2017-06-14 14:08, schrieb Brian Foster:
> > > On Wed, Jun 14, 2017 at 10:22:38AM +0200, list@jonas-server.de wrote:
> > > > Hello guys,
> > > > 
> > > > we have currently an issue with our ceph setup based on XFS.
> > > > Sometimes some
> > > > nodes are dying with high load with this calltrace in dmesg:
> > > > 
> > > > [Tue Jun 13 13:18:48 2017] BUG: unable to handle kernel NULL pointer
> > > > dereference at 00000000000000a0
> > > > [Tue Jun 13 13:18:48 2017] IP: [<ffffffffc06555a0>]
> > > > xfs_da3_node_read+0x30/0xb0 [xfs]
> > > > [Tue Jun 13 13:18:48 2017] PGD 0
> > > > [Tue Jun 13 13:18:48 2017] Oops: 0000 [#1] SMP
> > > > [Tue Jun 13 13:18:48 2017] Modules linked in: cpuid arc4 md4
> > > > nls_utf8 cifs
> > > > fscache nfnetlink_queue nfnetlink xt_CHECKSUM xt_nat iptable_nat
> > > > nf_nat_ipv4
> > > > xt_NFQUEUE xt_CLASSIFY ip6table_mangle dccp_diag dccp tcp_diag
> > > > udp_diag
> > > > inet_diag unix_diag af_packet_diag netlink_diag veth dummy bridge
> > > > stp llc
> > > > ebtable_filter ebtables iptable_mangle xt_CT iptable_raw
> > > > nf_conntrack_ipv4
> > > > nf_defrag_ipv4 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6
> > > > nf_defrag_ipv6 xt_conntrack ip6table_filter ip6_tables x_tables xfs
> > > > ipmi_devintf dcdbas x86_pkg_temp_thermal intel_powerclamp coretemp
> > > > crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
> > > > ipmi_ssif
> > > > aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac
> > > > edac_core
> > > > input_leds joydev lpc_ich ioatdma shpchp 8250_fintek ipmi_si
> > > > ipmi_msghandler
> > > > acpi_pad acpi_power_meter
> > > > [Tue Jun 13 13:18:48 2017]  mac_hid vhost_net vhost macvtap macvlan
> > > > kvm_intel kvm irqbypass cdc_ether nf_nat_ftp tcp_htcp nf_nat_pptp
> > > > nf_nat_proto_gre nf_conntrack_ftp bonding nf_nat_sip
> > > > nf_conntrack_sip nf_nat
> > > > nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack usbnet mii lp
> > > > parport
> > > > autofs4 btrfs raid456 async_raid6_recov async_memcpy async_pq
> > > > async_xor
> > > > async_tx xor raid6_pq libcrc32c raid0 multipath linear raid10 raid1
> > > > hid_generic usbhid hid ixgbe igb vxlan ip6_udp_tunnel ahci dca
> > > > udp_tunnel
> > > > libahci i2c_algo_bit ptp megaraid_sas pps_core mdio wmi fjes
> > > > [Tue Jun 13 13:18:48 2017] CPU: 3 PID: 3844 Comm: tp_fstore_op Not
> > > > tainted
> > > > 4.4.0-75-generic #96-Ubuntu
> > > > [Tue Jun 13 13:18:48 2017] Hardware name: Dell Inc. PowerEdge
> > > > R720/0XH7F2,
> > > > BIOS 2.5.4 01/22/2016
> > > > [Tue Jun 13 13:18:48 2017] task: ffff881feda65400 ti: ffff883fbda08000
> > > > task.ti: ffff883fbda08000
> > > > [Tue Jun 13 13:18:48 2017] RIP: 0010:[<ffffffffc06555a0>]
> > > > [<ffffffffc06555a0>] xfs_da3_node_read+0x30/0xb0 [xfs]
> > > 
> > > What line does this point at (i.e., 'list *xfs_da3_node_read+0x30' from
> > > gdb) on your kernel?
> > > 
> > > Brian
> > > 
> > > > [Tue Jun 13 13:18:48 2017] RSP: 0018:ffff883fbda0bc88  EFLAGS:
> > > > 00010286
> > > > [Tue Jun 13 13:18:48 2017] RAX: 0000000000000000 RBX:
> > > > ffff8801102c5050 RCX:
> > > > 0000000000000001
> > > > [Tue Jun 13 13:18:48 2017] RDX: 0000000000000000 RSI:
> > > > 0000000000000000 RDI:
> > > > ffff883fbda0bc38
> > > > [Tue Jun 13 13:18:48 2017] RBP: ffff883fbda0bca8 R08:
> > > > 0000000000000001 R09:
> > > > fffffffffffffffe
> > > > [Tue Jun 13 13:18:48 2017] R10: ffff880007374ae0 R11:
> > > > 0000000000000001 R12:
> > > > ffff883fbda0bcd8
> > > > [Tue Jun 13 13:18:48 2017] R13: ffff880035ac4c80 R14:
> > > > 0000000000000001 R15:
> > > > 000000008b1f4885
> > > > [Tue Jun 13 13:18:48 2017] FS:  00007fc574607700(0000)
> > > > GS:ffff883fff040000(0000) knlGS:0000000000000000
> > > > [Tue Jun 13 13:18:48 2017] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > 0000000080050033
> > > > [Tue Jun 13 13:18:48 2017] CR2: 00000000000000a0 CR3:
> > > > 0000003fd828d000 CR4:
> > > > 00000000001426e0
> > > > [Tue Jun 13 13:18:48 2017] Stack:
> > > > [Tue Jun 13 13:18:48 2017]  ffffffffc06b4b50 ffffffffc0695ecc
> > > > ffff883fbda0bde0 0000000000000001
> > > > [Tue Jun 13 13:18:48 2017]  ffff883fbda0bd20 ffffffffc06718b3
> > > > 0000000300000008 ffff880e99b44010
> > > > [Tue Jun 13 13:18:48 2017]  00000000360c65a8 ffff88270f80b900
> > > > 0000000000000000 0000000000000000
> > > > [Tue Jun 13 13:18:48 2017] Call Trace:
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffffc0695ecc>] ?
> > > > xfs_trans_roll+0x2c/0x50
> > > > [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffffc06718b3>]
> > > > xfs_attr3_node_inactive+0x183/0x220 [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffffc06718f9>]
> > > > xfs_attr3_node_inactive+0x1c9/0x220 [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffffc06719fc>]
> > > > xfs_attr3_root_inactive+0xac/0x100 [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffffc0671b9c>]
> > > > xfs_attr_inactive+0x14c/0x1a0 [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffffc068bda5>]
> > > > xfs_inactive+0x85/0x120
> > > > [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffffc06912f5>]
> > > > xfs_fs_evict_inode+0xa5/0x100 [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffff8122a90e>] evict+0xbe/0x190
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffff8122abf1>] iput+0x1c1/0x240
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffff8121f6b9>]
> > > > do_unlinkat+0x199/0x2d0
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffff81220256>] SyS_unlink+0x16/0x20
> > > > [Tue Jun 13 13:18:48 2017]  [<ffffffff8183b972>]
> > > > entry_SYSCALL_64_fastpath+0x16/0x71
> > > > [Tue Jun 13 13:18:48 2017] Code: 55 48 89 e5 41 54 53 4d 89 c4 48 89
> > > > fb 48
> > > > 83 ec 10 48 c7 04 24 50 4b 6b c0 e8 dd fe ff ff 85 c0 75 46 48 85 db
> > > > 74 41
> > > > 49 8b 34 24 <48> 8b 96 a0 00 00 00 0f b7 52 08 66 c1 c2 08 66 81 fa
> > > > be 3e 74
> > > > [Tue Jun 13 13:18:48 2017] RIP  [<ffffffffc06555a0>]
> > > > xfs_da3_node_read+0x30/0xb0 [xfs]
> > > > [Tue Jun 13 13:18:48 2017]  RSP <ffff883fbda0bc88>
> > > > [Tue Jun 13 13:18:48 2017] CR2: 00000000000000a0
> > > > [Tue Jun 13 13:18:48 2017] ---[ end trace 5470d0d55cacb4ef ]---
> > > > 
> > > > The ceph OSD running on this server has then the issue that it can
> > > > not reach
> > > > any other osd in the pool.
> > > > 
> > > >  -1043> 2017-06-13 13:24:00.917597 7fc539a72700  0 --
> > > > 192.168.14.19:6827/3389 >> 192.168.14.7:6805/3658
> > > > pipe(0x558219846000 sd=23
> > > > :6827
> > > > s=0 pgs=0 cs=0 l=0 c=0x55821a330400).accept connect_seq 7 vs
> > > > existing 7
> > > > state standby
> > > >  -1042> 2017-06-13 13:24:00.918433 7fc539a72700  0 --
> > > > 192.168.14.19:6827/3389 >> 192.168.14.7:6805/3658
> > > > pipe(0x558219846000 sd=23
> > > > :6827
> > > > s=0 pgs=0 cs=0 l=0 c=0x55821a330400).accept connect_seq 8 vs
> > > > existing 7
> > > > state standby
> > > >  -1041> 2017-06-13 13:24:03.654983 7fc4dd21d700  0 --
> > > > 192.168.14.19:6825/3389 >> :/0 pipe(0x5581fa6ba000 sd=524 :6825 s=0
> > > > pgs=0
> > > > cs=0 l=0
> > > >  c=0x55820a9e5000).accept failed to getpeername (107) Transport
> > > > endpoint is
> > > > not connected
> > > > 
> > > > 
> > > > There are a lot more of these messages. Does any of you have the
> > > > same issue?
> > > > We are running Ubuntu 16.04 with kernel 4.4.0-75.96.
> > > > 
> > > > Best regards,
> > > > Jonas
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs"
> > > > in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
