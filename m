Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 May 2007 15:45:37 -0700 (PDT)
Received: from mail.ggsys.net (mail.ggsys.net [69.26.161.131])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4SMjVWt024369
	for <xfs@oss.sgi.com>; Mon, 28 May 2007 15:45:33 -0700
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable
	problem
From: Alberto Alonso <alberto@ggsys.net>
In-Reply-To: <20070525083650.GO85884050@sgi.com>
References: <200705241318.30711.dap@mail.index.hu>
	 <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan>
	 <20070525000547.GH85884050@sgi.com>
	 <1180056948.6183.10.camel@daptopfc.localdomain>
	 <20070525045500.GF86004887@sgi.com> <1180071831.21028.125.camel@w100>
	 <20070525083650.GO85884050@sgi.com>
Content-Type: text/plain
Date: Mon, 28 May 2007 17:45:27 -0500
Message-Id: <1180392327.21028.140.camel@w100>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Pallai Roland <dap@mail.index.hu>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Fri, 2007-05-25 at 18:36 +1000, David Chinner wrote:
> On Fri, May 25, 2007 at 12:43:51AM -0500, Alberto Alonso wrote:
> > I think his point was that going into a read only mode causes a
> > less catastrophic situation (ie. a web server can still serve
> > pages).
> 
> Sure - but once you've detected one corruption or had metadata
> I/O errors, can you trust the rest of the filesystem?
> 
> > I think that is a valid point, rather than shutting down
> > the file system completely, an automatic switch to where the least
> > disruption of service can occur is always desired.
> 
> I consider the possibility of serving out bad data (i.e after
> a remount to readonly) to be the worst possible disruption of
> service that can happen ;)

I guess it does depend on the nature of the failure. A write failure
on block 2000 does not imply corruption of the other 2TB of data.

I wish I knew more on the internals of file systems, unfortunately since
I don't, I was just commenting on feature that would be nice, but maybe
there is no way to implement them. I figured that a dynamic table
with bad blocks could be kept, if an attempt to access those blocks is
generated (read or write) an I/O error is returned, if the block is
not on the list, the access is processed. This would help a server
with large file systems continue operations for most users.

> > I personally have found the XFS file system to be great for
> > my needs (except issues with NFS interaction, where the bug report
> > never got answered), but that doesn't mean it can not be improved.
> 
> Got a pointer?

I can't seem to find it. I'm pretty sure I used bugzilla to report
it. I did find the kernel dump file though, so here it is:

Oct  3 15:34:07 localhost kernel: xfs_iget_core: ambiguous vns:
vp/0xd1e69c80, invp/0xc989e380
Oct  3 15:34:07 localhost kernel: ------------[ cut here ]------------
Oct  3 15:34:07 localhost kernel: kernel BUG at
fs/xfs/support/debug.c:106!
Oct  3 15:34:07 localhost kernel: invalid operand: 0000 [#1]
Oct  3 15:34:07 localhost kernel: PREEMPT SMP
Oct  3 15:34:07 localhost kernel: Modules linked in: af_packet
iptable_filter ip_tables nfsd exportfs lockd sunrpc ipv6xfs capability
commoncap ext3 jbd mbc
ache aic7xxx i2c_dev tsdev floppy mousedev parport_pc parport psmouse
evdev pcspkrhw_random shpchp pciehp pci_hotplug intel_agp intel_mch_agp
agpgart uhci_h
cd usbcore piix ide_core e1000 cfi_cmdset_0001 cfi_util mtdpart mtdcore
jedec_probe gen_probe chipreg dm_mod w83781d i2c_sensor i2c_i801
i2c_core raid5 xor
genrtc sd_mod aic79xx scsi_mod raid1 md unix font vesafb cfbcopyarea
cfbimgblt cfbfillrect
Oct  3 15:34:07 localhost kernel: CPU:    0
Oct  3 15:34:07 localhost kernel: EIP:    0060:[__crc_pm_idle
+3334982/5290900]    Not tainted
Oct  3 15:34:07 localhost kernel: EFLAGS: 00010246   (2.6.8-2-686-smp)
Oct  3 15:34:07 localhost kernel: EIP is at cmn_err+0xc5/0xe0 [xfs]
Oct  3 15:34:07 localhost kernel: eax: 00000000   ebx: f602c000   ecx:
c02dcfbc   edx: c02dcfbc
Oct  3 15:34:07 localhost kernel: esi: f8c40e28   edi: f8c56a3e   ebp:
00000293   esp: f602da08
Oct  3 15:34:07 localhost kernel: ds: 007b   es: 007b   ss: 0068
Oct  3 15:34:07 localhost kernel: Process nfsd (pid: 2740,
threadinfo=f602c000 task=f71a7210)
Oct  3 15:34:07 localhost kernel: Stack: f8c40e28 f8c40def f8c56a00
00000000 f602c000 074aa1aa f8c41700 ea2f0a40
Oct  3 15:34:07 localhost kernel:        f8c0a745 00000000 f8c41700
d1e69c80 c989e380 f7d4cc00 c2934754 074aa1aa
Oct  3 15:34:07 localhost kernel:        00000000 f6555624 074aa1aa
f7d4cc00 c017d6bd f6555620 00000000 00000000
Oct  3 15:34:07 localhost kernel: Call Trace:
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3123398/5290900]
xfs_iget_core+0x565/0x6b0 [xfs]
Oct  3 15:34:07 localhost kernel:  [iget_locked+189/256] iget_locked
+0xbd/0x100
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3124083/5290900]
xfs_iget+0x162/0x1a0 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3252484/5290900]
xfs_vget+0x63/0x100 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3331204/5290900]
vfs_vget+0x43/0x50 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3329570/5290900]
linvfs_get_dentry+0x51/0x90 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+1536451/5290900]
find_exported_dentry+0x42/0x830 [exportfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3234969/5290900]
xfs_trans_tail_ail+0x38/0x80 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3174595/5290900]
xlog_write+0x102/0x580 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3234969/5290900]
xfs_trans_tail_ail+0x38/0x80 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3170617/5290900]
xlog_assign_tail_lsn+0x18/0x90 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3234969/5290900]
xfs_trans_tail_ail+0x38/0x80 [xfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+3174595/5290900]
xlog_write+0x102/0x580 [xfs]
Oct  3 15:34:07 localhost kernel:  [alloc_skb+71/240] alloc_skb
+0x47/0xf0
Oct  3 15:34:07 localhost kernel:  [sock_alloc_send_pskb+197/464]
sock_alloc_send_pskb+0xc5/0x1d0
Oct  3 15:34:07 localhost kernel:  [sock_alloc_send_skb+45/64]
sock_alloc_send_skb+0x2d/0x40
Oct  3 15:34:07 localhost kernel:  [ip_append_data+1810/2016]
ip_append_data+0x712/0x7e0
Oct  3 15:34:07 localhost kernel:  [recalc_task_prio+168/416]
recalc_task_prio+0xa8/0x1a0
Oct  3 15:34:07 localhost kernel:  [__ip_route_output_key+47/288]
__ip_route_output_key+0x2f/0x120
Oct  3 15:34:07 localhost kernel:  [udp_sendmsg+831/1888] udp_sendmsg
+0x33f/0x760
Oct  3 15:34:07 localhost kernel:  [ip_generic_getfrag+0/192]
ip_generic_getfrag+0x0/0xc0
Oct  3 15:34:07 localhost kernel:  [qdisc_restart+23/560] qdisc_restart
+0x17/0x230
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+1539451/5290900]
export_decode_fh+0x5a/0x7a [exportfs]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4695505/5290900]
nfsd_acceptable+0x0/0x140 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4696349/5290900]
fh_verify+0x20c/0x5a0 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4695505/5290900]
nfsd_acceptable+0x0/0x140 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4702954/5290900]
nfsd_open+0x39/0x1a0 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4704974/5290900]
nfsd_write+0x5d/0x360 [nfsd]
Oct  3 15:34:07 localhost kernel:  [skb_copy_and_csum_bits+102/784]
skb_copy_and_csum_bits+0x66/0x310
Oct  3 15:34:07 localhost kernel:  [resched_task+83/144] resched_task
+0x53/0x90
Oct  3 15:34:07 localhost kernel:  [skb_copy_and_csum_bits+556/784]
skb_copy_and_csum_bits+0x22c/0x310
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+2136279/5290900]
skb_read_and_csum_bits+0x46/0x90 [sunrpc]
Oct  3 15:34:07 localhost kernel:  [kfree_skbmem+36/48] kfree_skbmem
+0x24/0x30
Oct  3 15:34:07 localhost kernel:  [__kfree_skb+173/336] __kfree_skb
+0xad/0x150
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+2184090/5290900]
xdr_partial_copy_from_skb+0x169/0x180 [sunrpc]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+2180355/5290900]
svcauth_unix_accept+0x272/0x2c0 [sunrpc]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4735417/5290900]
nfsd3_proc_write+0xb8/0x120 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4688328/5290900]
nfsd_dispatch+0xd7/0x1e0 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4688113/5290900]
nfsd_dispatch+0x0/0x1e0 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+2162754/5290900]
svc_process+0x4b1/0x619 [sunrpc]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4687545/5290900] nfsd
+0x248/0x480 [nfsd]
Oct  3 15:34:07 localhost kernel:  [__crc_pm_idle+4686961/5290900] nfsd
+0x0/0x480 [nfsd]
Oct  3 15:34:07 localhost kernel:  [kernel_thread_helper+5/16]
kernel_thread_helper+0x5/0x10
Oct  3 15:34:07 localhost kernel: Code: 0f 0b 6a 00 0f 0e c4 f8 83 c4 10
5b 5e 5f 5d c3 e8 c6 03 66
Oct  3 15:34:07 localhost kernel:  <6>note: nfsd[2740] exited with
preempt_count 1
Oct  3 15:51:23 localhost kernel: klogd 1.4.1#17, log source
= /proc/kmsg started.
Oct  3 15:51:23 localhost kernel:
Inspecting /boot/System.map-2.6.8-2-686-smp
Oct  3 15:51:24 localhost kernel: Loaded 27755 symbols
from /boot/System.map-2.6.8-2-686-smp.
Oct  3 15:51:24 localhost kernel: Symbols match kernel version 2.6.8.
Oct  3 15:51:24 localhost kernel: No module symbols loaded - kernel
modules not enabled.
Oct  3 15:51:24 localhost kernel: fef0000 (usable)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000bfef0000 -
00000000bfefc000 (ACPI data)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000bfefc000 -
00000000bff00000 (ACPI NVS)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000bff00000 -
00000000bff80000 (usable)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000bff80000 -
00000000c0000000 (reserved)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000fec00000 -
00000000fec10000 (reserved)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000fee00000 -
00000000fee01000 (reserved)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000ff800000 -
00000000ffc00000 (reserved)
Oct  3 15:51:24 localhost kernel:  BIOS-e820: 00000000fff00000 -
0000000100000000 (reserved)
Oct  3 15:51:24 localhost kernel: 2175MB HIGHMEM available.
Oct  3 15:51:24 localhost kernel: 896MB LOWMEM available.
Oct  3 15:51:24 localhost kernel: found SMP MP-table at 000f6810
Oct  3 15:51:24 localhost kernel: On node 0 totalpages: 786304
Oct  3 15:51:24 localhost kernel:   DMA zone: 4096 pages, LIFO batch:1
Oct  3 15:51:24 localhost kernel:   Normal zone: 225280 pages, LIFO
batch:16
Oct  3 15:51:24 localhost kernel:   HighMem zone: 556928 pages, LIFO
batch:16
Oct  3 15:51:24 localhost kernel: DMI present.


Thanks,

Alberto
