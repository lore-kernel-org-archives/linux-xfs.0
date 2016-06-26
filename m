Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27D737CA0
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2016 00:44:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B49DFAC003
	for <xfs@oss.sgi.com>; Sat, 25 Jun 2016 22:44:27 -0700 (PDT)
Received: from cloud1-vm154.de-nserver.de (cloud1-vm154.de-nserver.de
	[178.250.10.56]) by cuda.sgi.com with ESMTP id M0QmxeV8Z8a2d02v
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Jun 2016 22:44:24 -0700 (PDT)
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage
References: <20160324122417.GB4068@bfoster.bfoster>
	<57332508.307@profihost.ag> <20160511133417.GA42410@bfoster.bfoster>
	<57333BA4.4040402@profihost.ag>
	<20160511155951.GF42410@bfoster.bfoster>
	<5738576B.4010208@profihost.ag> <20160515115017.GA6433@laptop.bfoster>
	<57386E84.3090606@profihost.ag>
	<20160516010602.GA24980@bfoster.bfoster>
	<57420A47.2000700@profihost.ag> <20160522213850.GE26977@dastard>
	<5751C4B8.2080301@profihost.ag>
From: Stefan Priebe <s.priebe@profihost.ag>
Message-ID: <576F6BE7.80605@profihost.ag>
Date: Sun, 26 Jun 2016 07:45:11 +0200
MIME-Version: 1.0
In-Reply-To: <5751C4B8.2080301@profihost.ag>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

today i got this XFS trace while running 4.4.13. I'm not sure if it is 
related.

[282732.262739] ------------[ cut here ]------------
[282732.264093] kernel BUG at fs/xfs/xfs_aops.c:1054!
[282732.265459] invalid opcode: 0000 [#1] SMP
[282732.266753] Modules linked in: netconsole xt_multiport 
iptable_filter ip_tables x_tables bonding coretemp 8021q garp fuse 
sb_edac edac_core xhci_pci i40e(O) xhci_hcd i2c_i801 vxlan shpchp 
ip6_udp_tunnel udp_tunnel ipmi_si ipmi_msghandler button btrfs xor 
raid6_pq dm_mod raid1 md_mod usbhid usb_storage ohci_hcd sg sd_mod 
ehci_pci ehci_hcd usbcore usb_common ahci libahci igb i2c_algo_bit 
mpt3sas i2c_core raid_class ptp pps_core scsi_transport_sas
[282732.280494] CPU: 2 PID: 108 Comm: kswapd0 Tainted: G           O 
4.4.13+36-ph #1
[282732.282707] Hardware name: Supermicro Super Server/X10SRH-CF, BIOS 
2.0 12/17/2015
[282732.284873] task: ffff880c4d9ba500 ti: ffff880c4da28000 task.ti: 
ffff880c4da28000
[282732.287038] RIP: 0010:[<ffffffff943267f1>]  [<ffffffff943267f1>] 
xfs_vm_writepage+0x561/0x5c0
[282732.289554] RSP: 0018:ffff880c4da2b8e8  EFLAGS: 00010246
[282732.291095] RAX: 001fffff80020009 RBX: ffffea000186de80 RCX: 
000000000000000c
[282732.293161] RDX: 0000000000001800 RSI: ffff880c4da2b9b8 RDI: 
ffffea000186de80
[282732.295255] RBP: ffff880c4da2b9a8 R08: 0000000000000003 R09: 
7fffffffffffffff
[282732.297340] R10: ffff880c7ffdc6c0 R11: 0000000000000000 R12: 
ffffea000186de80
[282732.299405] R13: ffff88001ea855d0 R14: ffff880c4da2bad8 R15: 
ffffea000186dea0
[282732.301472] FS:  0000000000000000(0000) GS:ffff880c7fc40000(0000) 
knlGS:0000000000000000
[282732.303811] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[282732.305480] CR2: ffffffffff600400 CR3: 0000000014c0a000 CR4: 
00000000001406e0
[282732.307545] Stack:
[282732.308142]  ffff8806c1e980e0 ffff880c442dc800 ffff880100000001 
0000000100042000
[282732.310482]  ffffea00016db240 ffff880c4da2b968 0000000001800000 
ffff880c4da2b9b8
[282732.312822]  0000000000001000 0000000000297000 0000000000000000 
0000000000000246
[282732.315161] Call Trace:
[282732.315890]  [<ffffffff9415c72e>] ? clear_page_dirty_for_io+0xee/0x1b0
[282732.317782]  [<ffffffff94163974>] pageout.isra.43+0x164/0x280
[282732.319449]  [<ffffffff94165f4a>] shrink_page_list+0x5ba/0x760
[282732.321143]  [<ffffffff941667ce>] shrink_inactive_list+0x1ee/0x500
[282732.322934]  [<ffffffff941674e1>] shrink_lruvec+0x621/0x7d0
[282732.324554]  [<ffffffff9416776c>] shrink_zone+0xdc/0x2c0
[282732.326096]  [<ffffffff941688b9>] kswapd+0x4f9/0x970
[282732.327541]  [<ffffffff941683c0>] ? 
mem_cgroup_shrink_node_zone+0x1a0/0x1a0
[282732.329561]  [<ffffffff940a0dc9>] kthread+0xc9/0xe0
[282732.330979]  [<ffffffff940a0d00>] ? kthread_stop+0x100/0x100
[282732.332623]  [<ffffffff946b470f>] ret_from_fork+0x3f/0x70
[282732.334191]  [<ffffffff940a0d00>] ? kthread_stop+0x100/0x100
[282732.404901] Code: f8 f5 74 a3 4c 89 e7 89 85 50 ff ff ff e8 38 e8 ff 
ff f0 41 80 24 24 f7 4c 89 e7 e8 3a bf e2 ff 8b 85 50 ff ff ff e9 39 fd 
ff ff <0f> 0b 80 3d 04 fc 9c 00 00 0f 85 6d ff ff ff be d6 03 00 00 48
[282732.556398] RIP  [<ffffffff943267f1>] xfs_vm_writepage+0x561/0x5c0
[282732.630207]  RSP <ffff880c4da2b8e8>
[282732.703062] ---[ end trace 9ea1afce9e126cdc ]---
[282732.842462] ------------[ cut here ]------------
[282732.914729] WARNING: CPU: 2 PID: 108 at kernel/exit.c:661 
do_exit+0x50/0xab0()
[282732.989039] Modules linked in: netconsole xt_multiport 
iptable_filter ip_tables x_tables bonding coretemp 8021q garp fuse 
sb_edac edac_core xhci_pci i40e(O) xhci_hcd i2c_i801 vxlan shpchp 
ip6_udp_tunnel udp_tunnel ipmi_si ipmi_msghandler button btrfs xor 
raid6_pq dm_mod raid1 md_mod usbhid usb_storage ohci_hcd sg sd_mod 
ehci_pci ehci_hcd usbcore usb_common ahci libahci igb i2c_algo_bit 
mpt3sas i2c_core raid_class ptp pps_core scsi_transport_sas
[282733.306619] CPU: 2 PID: 108 Comm: kswapd0 Tainted: G      D    O 
4.4.13+36-ph #1
[282733.386805] Hardware name: Supermicro Super Server/X10SRH-CF, BIOS 
2.0 12/17/2015
[282733.467585]  0000000000000000 ffff880c4da2b5d8 ffffffff943c60ff 
0000000000000000
[282733.547861]  ffffffff94a330a8 ffff880c4da2b618 ffffffff940837a7 
ffff880c4da2b838
[282733.626144]  000000000000000b ffff880c4da2b838 0000000000000246 
ffff880c4d9ba500
[282733.702723] Call Trace:
[282733.776298]  [<ffffffff943c60ff>] dump_stack+0x63/0x84
[282733.849877]  [<ffffffff940837a7>] warn_slowpath_common+0x97/0xe0
[282733.922917]  [<ffffffff9408380a>] warn_slowpath_null+0x1a/0x20
[282733.994640]  [<ffffffff94085a90>] do_exit+0x50/0xab0
[282734.064858]  [<ffffffff94008a02>] oops_end+0xa2/0xe0
[282734.133974]  [<ffffffff94008b88>] die+0x58/0x80
[282734.202270]  [<ffffffff94005ba9>] do_trap+0x69/0x150
[282734.269913]  [<ffffffff940a1bc2>] ? 
__atomic_notifier_call_chain+0x12/0x20
[282734.337974]  [<ffffffff94005d5d>] do_error_trap+0xcd/0xf0
[282734.406008]  [<ffffffff943267f1>] ? xfs_vm_writepage+0x561/0x5c0
[282734.474472]  [<ffffffff9439c334>] ? generic_make_request+0x104/0x190
[282734.542216]  [<ffffffff94006000>] do_invalid_op+0x20/0x30
[282734.609276]  [<ffffffff946b5e8e>] invalid_op+0x1e/0x30
[282734.675516]  [<ffffffff943267f1>] ? xfs_vm_writepage+0x561/0x5c0
[282734.741307]  [<ffffffff94326528>] ? xfs_vm_writepage+0x298/0x5c0
[282734.805722]  [<ffffffff9415c72e>] ? clear_page_dirty_for_io+0xee/0x1b0
[282734.870589]  [<ffffffff94163974>] pageout.isra.43+0x164/0x280
[282734.934901]  [<ffffffff94165f4a>] shrink_page_list+0x5ba/0x760
[282734.998565]  [<ffffffff941667ce>] shrink_inactive_list+0x1ee/0x500
[282735.061845]  [<ffffffff941674e1>] shrink_lruvec+0x621/0x7d0
[282735.124441]  [<ffffffff9416776c>] shrink_zone+0xdc/0x2c0
[282735.186752]  [<ffffffff941688b9>] kswapd+0x4f9/0x970
[282735.249021]  [<ffffffff941683c0>] ? 
mem_cgroup_shrink_node_zone+0x1a0/0x1a0
[282735.312215]  [<ffffffff940a0dc9>] kthread+0xc9/0xe0
[282735.375420]  [<ffffffff940a0d00>] ? kthread_stop+0x100/0x100
[282735.439012]  [<ffffffff946b470f>] ret_from_fork+0x3f/0x70
[282735.502368]  [<ffffffff940a0d00>] ? kthread_stop+0x100/0x100
[282735.565534] ---[ end trace 9ea1afce9e126cdd ]---

Stefan

Am 03.06.2016 um 19:56 schrieb Stefan Priebe - Profihost AG:
> Hi,
>
> should i remove the complete if conditions incl. the return 0 or should
> id convert it to if without WARN_ONCE? like below?
>
>          if (WARN_ON_ONCE(delalloc))
>                  return 0;
>          if (WARN_ON_ONCE(unwritten))
>                  return 0;
>
> =>
>
>    if (delalloc)
>      return 0;
>    if (unwritten)
>      return 0;
>
>
>
> Am 22.05.2016 um 23:38 schrieb Dave Chinner:
>> On Sun, May 22, 2016 at 09:36:39PM +0200, Stefan Priebe - Profihost AG wrote:
>>> Am 16.05.2016 um 03:06 schrieb Brian Foster:
>>>>> sd_mod ehci_pci ehci_hcd usbcore usb_common igb ahci i2c_algo_bit libahci
>>>>> i2c_core ptp mpt3sas pps_core raid_class scsi_transport_sas
>>>>> [Sun May 15 07:00:44 2016] CPU: 2 PID: 108 Comm: kswapd0 Tainted: G       O
>>>>> 4.4.10+25-ph #1
>>>>
>>>> How close is this to an upstream kernel? Upstream XFS? Have you tried to
>>>> reproduce this on an upstream kernel?
>>>
>>> It's a vanilla 4.4.10 + a new adaptec driver and some sched and wq
>>> patches from 4.5 and 4.6 but i can try to replace the kernel on one
>>> machine with a 100% vanilla one if this helps.
>>
>> Please do.
>>
>>>>> [295086.353473] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>>> 0x52000 size 0x13d1c8
>>>>> [295086.353476] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>>> 0x53000 size 0x13d1c8
>>>>> [295086.353478] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>>> 0x54000 size 0x13d1c8
>>>> ...
>>>>> [295086.567508] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>>> 0xab000 size 0x13d1c8
>>>>> [295086.567510] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>>> 0xac000 size 0x13d1c8
>>>>> [295086.567515] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>>> 0xad000 size 0x13d1c8
>>>>>
>>>>> The file to the inode number is:
>>>>> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
>>>>>
>>>>
>>>> xfs_bmap -v might be interesting here as well.
>>>
>>> # xfs_bmap -v
>>> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
>>> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en:
>>>   EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
>>>     0: [0..2567]:       41268928..41271495  3 (374464..377031)  2568
>>
>> So the last file offset with a block is 0x140e00. This means the
>> file is fully allocated. However, the pages inside the file range
>> are still marked delayed allocation. That implies that we've failed
>> to write the pages over a delayed allocation region after we've
>> allocated the space.
>>
>> That, in turn, tends to indicate a problem in page writeback - the
>> first page to be written has triggered delayed allocation of the
>> entire range, but then the subsequent pages have not been written
>> (for some as yet unknown reason). When a page is written, we map it
>> to the current block via xfs_map_at_offset(), and that clears both
>> the buffer delay and unwritten flags.
>>
>> This clearly isn't happening which means either the VFS doesn't
>> think the inode is dirty anymore, writeback is never asking for
>> these pages to be written, or XFs is screwing something up in
>> ->writepage. The XFS writepage code changed significantly in 4.6, so
>> it might be worth seeing if a 4.6 kernel reproduces this same
>> problem....
>>
>> Cheers,
>>
>> Dave.
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
