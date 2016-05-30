Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B701E7CBC
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 02:23:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87E618F8035
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 00:23:54 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id 5dBj8gTSxWwxwMhi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 May 2016 00:23:51 -0700 (PDT)
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
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <574BEA84.3010206@profihost.ag>
Date: Mon, 30 May 2016 09:23:48 +0200
MIME-Version: 1.0
In-Reply-To: <20160522213850.GE26977@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,
  Hi Brian,

below are the results with a vanilla 4.4.11 kernel.

Am 22.05.2016 um 23:38 schrieb Dave Chinner:
> On Sun, May 22, 2016 at 09:36:39PM +0200, Stefan Priebe - Profihost AG wrote:
>> Am 16.05.2016 um 03:06 schrieb Brian Foster:
>>>> sd_mod ehci_pci ehci_hcd usbcore usb_common igb ahci i2c_algo_bit libahci
>>>> i2c_core ptp mpt3sas pps_core raid_class scsi_transport_sas
>>>> [Sun May 15 07:00:44 2016] CPU: 2 PID: 108 Comm: kswapd0 Tainted: G       O
>>>> 4.4.10+25-ph #1
>>>
>>> How close is this to an upstream kernel? Upstream XFS? Have you tried to
>>> reproduce this on an upstream kernel?
>>
>> It's a vanilla 4.4.10 + a new adaptec driver and some sched and wq
>> patches from 4.5 and 4.6 but i can try to replace the kernel on one
>> machine with a 100% vanilla one if this helps.
> 
> Please do.
> 
>>>> [295086.353473] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>> 0x52000 size 0x13d1c8
>>>> [295086.353476] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>> 0x53000 size 0x13d1c8
>>>> [295086.353478] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>> 0x54000 size 0x13d1c8
>>> ...
>>>> [295086.567508] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>> 0xab000 size 0x13d1c8
>>>> [295086.567510] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>> 0xac000 size 0x13d1c8
>>>> [295086.567515] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>>>> 0xad000 size 0x13d1c8
>>>>
>>>> The file to the inode number is:
>>>> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
>>>>
>>>
>>> xfs_bmap -v might be interesting here as well.
>>
>> # xfs_bmap -v
>> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
>> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en:
>>  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
>>    0: [0..2567]:       41268928..41271495  3 (374464..377031)  2568
> 
> So the last file offset with a block is 0x140e00. This means the
> file is fully allocated. However, the pages inside the file range
> are still marked delayed allocation. That implies that we've failed
> to write the pages over a delayed allocation region after we've
> allocated the space.
> 
> That, in turn, tends to indicate a problem in page writeback - the
> first page to be written has triggered delayed allocation of the
> entire range, but then the subsequent pages have not been written
> (for some as yet unknown reason). When a page is written, we map it
> to the current block via xfs_map_at_offset(), and that clears both
> the buffer delay and unwritten flags.
> 
> This clearly isn't happening which means either the VFS doesn't
> think the inode is dirty anymore, writeback is never asking for
> these pages to be written, or XFs is screwing something up in
> ->writepage. The XFS writepage code changed significantly in 4.6, so
> it might be worth seeing if a 4.6 kernel reproduces this same
> problem....

i've now used a vanilla 4.4.11 Kernel and the issue remains. After a
fresh reboot it has happened again on the root FS for a debian apt file:

XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x0 size 0x12b990
------------[ cut here ]------------
WARNING: CPU: 1 PID: 111 at fs/xfs/xfs_aops.c:1239
xfs_vm_releasepage+0x10f/0x140()
Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 xt_multiport
iptable_filter ip_tables x_tables bonding coretemp 8021q garp fuse
sb_edac edac_core i2c_i801 i40e(O) xhci_pci xhci_hcd shpchp vxlan
ip6_udp_tunnel udp_tunnel ipmi_si ipmi_msghandler button btrfs xor
raid6_pq dm_mod raid1 md_mod usbhid usb_storage ohci_hcd sg sd_mod
ehci_pci ehci_hcd usbcore usb_common igb ahci i2c_algo_bit libahci
i2c_core mpt3sas ptp pps_core raid_class scsi_transport_sas
CPU: 1 PID: 111 Comm: kswapd0 Tainted: G           O    4.4.11 #1
Hardware name: Supermicro Super Server/X10SRH-CF, BIOS 1.0b 05/18/2015
 0000000000000000 ffff880c4dacfa88 ffffffffa23c5b8f 0000000000000000
 ffffffffa2a51ab4 ffff880c4dacfac8 ffffffffa20837a7 ffff880c4dacfae8
 0000000000000001 ffffea00010c3640 ffff8802176b49d0 ffffea00010c3660
Call Trace:
 [<ffffffffa23c5b8f>] dump_stack+0x63/0x84
 [<ffffffffa20837a7>] warn_slowpath_common+0x97/0xe0
 [<ffffffffa208380a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa2326caf>] xfs_vm_releasepage+0x10f/0x140
 [<ffffffffa218c680>] ? page_mkclean_one+0xd0/0xd0
 [<ffffffffa218d3a0>] ? anon_vma_prepare+0x150/0x150
 [<ffffffffa21521c2>] try_to_release_page+0x32/0x50
 [<ffffffffa2166b2e>] shrink_active_list+0x3ce/0x3e0
 [<ffffffffa21671c7>] shrink_lruvec+0x687/0x7d0
 [<ffffffffa21673ec>] shrink_zone+0xdc/0x2c0
 [<ffffffffa2168539>] kswapd+0x4f9/0x970
 [<ffffffffa2168040>] ? mem_cgroup_shrink_node_zone+0x1a0/0x1a0
 [<ffffffffa20a0d99>] kthread+0xc9/0xe0
 [<ffffffffa20a0cd0>] ? kthread_stop+0x100/0x100
 [<ffffffffa26b404f>] ret_from_fork+0x3f/0x70
 [<ffffffffa20a0cd0>] ? kthread_stop+0x100/0x100
---[ end trace c9d679f8ed4d7610 ]---
XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x1000 size
0x12b990
XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x2000 size
0x12b990
XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x3000 size
0x12b990
XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x4000 size
0x12b990
XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x5000 size
0x12b990
XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x6000 size
0x12b990
XFS (md127p3): ino 0x41221d1 delalloc 1 unwritten 0 pgoff 0x7000 size
0x12b990
XFS (md127p3): ino 0x400de4c delalloc 1 unwritten 0 pgoff 0x12000 size
0x2cc69

# find / -inum $(printf "%d" 0x41221d1) -print
/var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_source_Sources

# xfs_bmap -v
/var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_source_Sources
/var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_source_Sources:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
   0: [0..2399]:       27851552..27853951  2 (588576..590975)  2400

So you mean the next step would be to test 4.6? I hope this is stable
enough for production usage.

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
