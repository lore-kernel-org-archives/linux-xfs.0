Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B6B17CB2
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 12:46:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 392CC8F8033
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 10:46:50 -0800 (PST)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id mHWJp2f17QS5wyHz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 10:46:46 -0800 (PST)
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage
References: <56C81D94.7090603@profihost.ag>
	<20160220144533.GA36182@bfoster.bfoster>
	<B833B258-1140-464C-94CD-09B840BD4220@profihost.ag>
From: Stefan Priebe <s.priebe@profihost.ag>
Message-ID: <56D9D834.2000303@profihost.ag>
Date: Fri, 4 Mar 2016 19:47:16 +0100
MIME-Version: 1.0
In-Reply-To: <B833B258-1140-464C-94CD-09B840BD4220@profihost.ag>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 20.02.2016 um 19:02 schrieb Stefan Priebe - Profihost AG:
>
>> Am 20.02.2016 um 15:45 schrieb Brian Foster <bfoster@redhat.com>:
>>
>>> On Sat, Feb 20, 2016 at 09:02:28AM +0100, Stefan Priebe wrote:
>>> Hi,
>>>
>>> got this one today. Not sure if this is a bug.
>>
>> That looks like the releasepage() delayed allocation block warning. I'm
>> not sure we've had any fixes for (or reports of) that issue since the
>> v4.2 timeframe.
>>
>> What is the xfs_info of the associated filesystem? Also, do you have any
>> insight as to the possible reproducer application or workload? Is this
>> reproducible at all? Note that this is a WARN_ON_ONCE(), so the warning
>> won't fire again regardless until after a reboot.

Toda i got this one running 4.3.3.

[154152.949610] ------------[ cut here ]------------
[154152.950704] WARNING: CPU: 0 PID: 79 at fs/xfs/xfs_aops.c:1232 
xfs_vm_releasepage+0xc3/0xf0()
[154152.952596] Modules linked in: netconsole mpt3sas raid_class 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp 
ipt_REJECT nf_reject_ipv4 xt_owner xt_multiport iptable_filter ip_tables 
x_tables 8021q garp coretemp k8temp ehci_pci ehci_hcd sb_edac ipmi_si 
usbcore edac_core ipmi_msghandler i2c_i801 usb_common button btrfs xor 
raid6_pq sg igb sd_mod i2c_algo_bit isci i2c_core libsas ahci ptp 
libahci scsi_transport_sas megaraid_sas pps_core
[154152.963240] CPU: 0 PID: 79 Comm: kswapd0 Not tainted 4.4.3+3-ph #1
[154152.964625] Hardware name: Supermicro 
X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 1.0a 
03/06/2012
[154152.967029]  0000000000000000 ffff88103dd67a98 ffffffffa73c3b5f 
0000000000000000
[154152.968836]  ffffffffa7a5063b ffff88103dd67ad8 ffffffffa7083757 
0000000000000000
[154152.970641]  0000000000000001 ffffea0001e7bfc0 ffff88071ef72dd0 
ffffea0001e7bfe0
[154152.972447] Call Trace:
[154152.973011]  [<ffffffffa73c3b5f>] dump_stack+0x63/0x84
[154152.974167]  [<ffffffffa7083757>] warn_slowpath_common+0x97/0xe0
[154152.975515]  [<ffffffffa70837ba>] warn_slowpath_null+0x1a/0x20
[154152.976826]  [<ffffffffa7324f23>] xfs_vm_releasepage+0xc3/0xf0
[154152.978137]  [<ffffffffa71510b2>] try_to_release_page+0x32/0x50
[154152.979467]  [<ffffffffa71659be>] shrink_active_list+0x3ce/0x3e0
[154152.980816]  [<ffffffffa7166057>] shrink_lruvec+0x687/0x7d0
[154152.982068]  [<ffffffffa716627c>] shrink_zone+0xdc/0x2c0
[154152.983262]  [<ffffffffa7167399>] kswapd+0x4f9/0x970
[154152.984380]  [<ffffffffa7166ea0>] ? 
mem_cgroup_shrink_node_zone+0x1a0/0x1a0
[154152.985942]  [<ffffffffa70a0ac9>] kthread+0xc9/0xe0
[154152.987040]  [<ffffffffa70a0a00>] ? kthread_stop+0x100/0x100
[154152.988313]  [<ffffffffa76b03cf>] ret_from_fork+0x3f/0x70
[154152.989527]  [<ffffffffa70a0a00>] ? kthread_stop+0x100/0x100
[154152.990818] ---[ end trace 3fac2515e92c7cb1 ]---

This time with an xfs info:
# xfs_info /
meta-data=/dev/disk/by-uuid/9befe321-e9cc-4e31-82df-efabb3211bac 
isize=256    agcount=4, agsize=58224256 blks
          =                       sectsz=512   attr=2, projid32bit=0
          =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=232897024, imaxpct=25
          =                       sunit=64     swidth=384 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=113728, version=2
          =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

>
>>
>> Brian
>>
>>> [67674.907736] ------------[ cut here ]------------
>>> [67674.955858] WARNING: CPU: 5 PID: 197 at fs/xfs/xfs_aops.c:1232
>>> xfs_vm_releasepage+0xa9/0xe0()
>>> [67675.005345] Modules linked in: dm_mod netconsole ipt_REJECT
>>> nf_reject_ipv4 mpt3sas raid_class xt_multiport iptable_filter ip_tabl
>>> es x_tables 8021q garp bonding coretemp loop usbhid ehci_pci ehci_hcd
>>> sb_edac ipmi_si usbcore i2c_i801 edac_core usb_common ipmi_msg
>>> handler button btrfs xor raid6_pq raid1 md_mod sg igb sd_mod i2c_algo_bit
>>> ixgbe ahci i2c_core mdio isci libahci libsas ptp megaraid_
>>> sas scsi_transport_sas pps_core
>>> [67675.221939] CPU: 5 PID: 197 Comm: kswapd0 Not tainted 4.4.2+1-ph #1
>>> [67675.277120] Hardware name: Supermicro
>>> X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.2 03/04/2015
>>> [67675.335176]  ffffffffa3a5065d ffff88007950fa98 ffffffffa33bd4e1
>>> 0000000000000001
>>> [67675.392983]  0000000000000000 ffff88007950fad8 ffffffffa3083587
>>> ffff88007950fae8
>>> [67675.449743]  0000000000000001 ffffea0020883480 ffff880cf4b9cdd0
>>> ffffea00208834a0
>>> [67675.506112] Call Trace:
>>> [67675.561285]  [<ffffffffa33bd4e1>] dump_stack+0x45/0x64
>>> [67675.619364]  [<ffffffffa3083587>] warn_slowpath_common+0x97/0xe0
>>> [67675.675719]  [<ffffffffa30835ea>] warn_slowpath_null+0x1a/0x20
>>> [67675.731113]  [<ffffffffa3320a89>] xfs_vm_releasepage+0xa9/0xe0
>>> [67675.786116]  [<ffffffffa318a4b0>] ? page_mkclean_one+0xd0/0xd0
>>> [67675.844216]  [<ffffffffa318b1d0>] ? anon_vma_prepare+0x150/0x150
>>> [67675.903862]  [<ffffffffa31506c2>] try_to_release_page+0x32/0x50
>>> [67675.957625]  [<ffffffffa3164d3e>] shrink_active_list+0x3ce/0x3e0
>>> [67676.011497]  [<ffffffffa31653d7>] shrink_lruvec+0x687/0x7d0
>>> [67676.064980]  [<ffffffffa31655fc>] shrink_zone+0xdc/0x2c0
>>> [67676.118828]  [<ffffffffa3166659>] kswapd+0x4f9/0x930
>>> [67676.172075]  [<ffffffffa3166160>] ?
>>> mem_cgroup_shrink_node_zone+0x150/0x150
>>> [67676.225139]  [<ffffffffa30a08c9>] kthread+0xc9/0xe0
>>> [67676.277539]  [<ffffffffa30a0800>] ? kthread_stop+0xe0/0xe0
>>> [67676.330124]  [<ffffffffa36a8c8f>] ret_from_fork+0x3f/0x70
>>> [67676.381816]  [<ffffffffa30a0800>] ? kthread_stop+0xe0/0xe0
>>> [67676.433499] ---[ end trace cb1827fe308f7f6b ]---
>>>
>>> Greets Stefan
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
