Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 49D177CBA
	for <xfs@oss.sgi.com>; Sat, 20 Feb 2016 02:20:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4A5E8F804B
	for <xfs@oss.sgi.com>; Sat, 20 Feb 2016 00:20:02 -0800 (PST)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id hq8D3JJeTY8c1gXy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 20 Feb 2016 00:01:21 -0800 (PST)
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: xfs trace in 4.4.2
Message-ID: <56C81D94.7090603@profihost.ag>
Date: Sat, 20 Feb 2016 09:02:28 +0100
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: linux-fsdevel@vger.kernel.org, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>

Hi,

got this one today. Not sure if this is a bug.

[67674.907736] ------------[ cut here ]------------
[67674.955858] WARNING: CPU: 5 PID: 197 at fs/xfs/xfs_aops.c:1232 
xfs_vm_releasepage+0xa9/0xe0()
[67675.005345] Modules linked in: dm_mod netconsole ipt_REJECT 
nf_reject_ipv4 mpt3sas raid_class xt_multiport iptable_filter ip_tabl
es x_tables 8021q garp bonding coretemp loop usbhid ehci_pci ehci_hcd 
sb_edac ipmi_si usbcore i2c_i801 edac_core usb_common ipmi_msg
handler button btrfs xor raid6_pq raid1 md_mod sg igb sd_mod 
i2c_algo_bit ixgbe ahci i2c_core mdio isci libahci libsas ptp megaraid_
sas scsi_transport_sas pps_core
[67675.221939] CPU: 5 PID: 197 Comm: kswapd0 Not tainted 4.4.2+1-ph #1
[67675.277120] Hardware name: Supermicro 
X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.2 03/04/2015
[67675.335176]  ffffffffa3a5065d ffff88007950fa98 ffffffffa33bd4e1 
0000000000000001
[67675.392983]  0000000000000000 ffff88007950fad8 ffffffffa3083587 
ffff88007950fae8
[67675.449743]  0000000000000001 ffffea0020883480 ffff880cf4b9cdd0 
ffffea00208834a0
[67675.506112] Call Trace:
[67675.561285]  [<ffffffffa33bd4e1>] dump_stack+0x45/0x64
[67675.619364]  [<ffffffffa3083587>] warn_slowpath_common+0x97/0xe0
[67675.675719]  [<ffffffffa30835ea>] warn_slowpath_null+0x1a/0x20
[67675.731113]  [<ffffffffa3320a89>] xfs_vm_releasepage+0xa9/0xe0
[67675.786116]  [<ffffffffa318a4b0>] ? page_mkclean_one+0xd0/0xd0
[67675.844216]  [<ffffffffa318b1d0>] ? anon_vma_prepare+0x150/0x150
[67675.903862]  [<ffffffffa31506c2>] try_to_release_page+0x32/0x50
[67675.957625]  [<ffffffffa3164d3e>] shrink_active_list+0x3ce/0x3e0
[67676.011497]  [<ffffffffa31653d7>] shrink_lruvec+0x687/0x7d0
[67676.064980]  [<ffffffffa31655fc>] shrink_zone+0xdc/0x2c0
[67676.118828]  [<ffffffffa3166659>] kswapd+0x4f9/0x930
[67676.172075]  [<ffffffffa3166160>] ? 
mem_cgroup_shrink_node_zone+0x150/0x150
[67676.225139]  [<ffffffffa30a08c9>] kthread+0xc9/0xe0
[67676.277539]  [<ffffffffa30a0800>] ? kthread_stop+0xe0/0xe0
[67676.330124]  [<ffffffffa36a8c8f>] ret_from_fork+0x3f/0x70
[67676.381816]  [<ffffffffa30a0800>] ? kthread_stop+0xe0/0xe0
[67676.433499] ---[ end trace cb1827fe308f7f6b ]---

Greets Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
