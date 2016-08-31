Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7C577CA0
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 03:56:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2510CAC003
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 01:56:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zH9gVHbrV8Fe36s0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 31 Aug 2016 01:56:03 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 02F0D4E4CC
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 08:56:03 +0000 (UTC)
Received: from localhost (dhcp-13-153.nay.redhat.com [10.66.13.153])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7V8u1jZ023276
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2016 04:56:02 -0400
Date: Wed, 31 Aug 2016 16:56:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: BUG: Internal error xfs_trans_cancel at line 984 of file
	fs/xfs/xfs_trans.c
Message-ID: <20160831085601.GR27776@eguan.usersys.redhat.com>
References: <20160829103754.GH27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829103754.GH27776@eguan.usersys.redhat.com>
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
To: xfs@oss.sgi.com

On Mon, Aug 29, 2016 at 06:37:54PM +0800, Eryu Guan wrote:
> Hi,
> 
> I've hit an XFS internal error then filesystem shutdown with 4.8-rc3
> kernel but not with 4.8-rc2

Sometimes I hit the following warning instead of the fs shutdown, if I
lowered the stress load.

[15276.032482] ------------[ cut here ]------------
[15276.055649] WARNING: CPU: 1 PID: 5535 at fs/xfs/xfs_aops.c:1069 xfs_vm_releasepage+0x106/0x130 [xfs]
[15276.101221] Modules linked in: xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ipt_REJECT nf_reject_ipv4 ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul iTCO_wdt glue_helper ipmi_ssif ablk_helper iTCO_vendor_support cryptd i2c_i801 hpwdt ipmi_si hpilo sg pcspkr wmi i2c_smbus ioatdma ipmi_msghandler pcc_cpufreq lpc_ich dca shpchp acpi_cpufreq acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit 
 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm tg3 uas ptp serio_raw usb_storage crc32c_intel hpsa i2c_core pps_core scsi_transport_sas fjes dm_mirror dm_region_hash dm_log dm_mod
[15276.593111] CPU: 1 PID: 5535 Comm: bash-shared-map Not tainted 4.8.0-rc3 #1
[15276.627509] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[15276.658663]  0000000000000286 00000000b9ab484d ffff88085269f500 ffffffff8135c53c
[15276.693463]  0000000000000000 0000000000000000 ffff88085269f540 ffffffff8108d661
[15276.728306]  0000042d18524440 ffffea0018524460 ffffea0018524440 ffff88085e615028
[15276.762986] Call Trace:
[15276.774250]  [<ffffffff8135c53c>] dump_stack+0x63/0x87
[15276.798320]  [<ffffffff8108d661>] __warn+0xd1/0xf0
[15276.820742]  [<ffffffff8108d79d>] warn_slowpath_null+0x1d/0x20
[15276.848141]  [<ffffffffa02c3226>] xfs_vm_releasepage+0x106/0x130 [xfs]
[15276.878802]  [<ffffffff8119a9fd>] try_to_release_page+0x3d/0x60
[15276.906568]  [<ffffffff811b1fec>] shrink_page_list+0x83c/0x9b0
[15276.933952]  [<ffffffff811b293d>] shrink_inactive_list+0x21d/0x570
[15276.962881]  [<ffffffff811b350e>] shrink_node_memcg+0x51e/0x7d0
[15276.990564]  [<ffffffff812176d7>] ? mem_cgroup_iter+0x127/0x2c0
[15277.017923]  [<ffffffff811b38a1>] shrink_node+0xe1/0x310
[15277.042940]  [<ffffffff811b3dcb>] do_try_to_free_pages+0xeb/0x370
[15277.071624]  [<ffffffff811b413f>] try_to_free_pages+0xef/0x1b0
[15277.100457]  [<ffffffff81225b96>] __alloc_pages_slowpath+0x33d/0x865
[15277.132333]  [<ffffffff811a4874>] __alloc_pages_nodemask+0x2d4/0x320
[15277.162990]  [<ffffffff811f5de8>] alloc_pages_current+0x88/0x120
[15277.191163]  [<ffffffff8119a9ae>] __page_cache_alloc+0xae/0xc0
[15277.218596]  [<ffffffff811a93c8>] __do_page_cache_readahead+0xf8/0x250
[15277.249416]  [<ffffffff81262841>] ? mark_buffer_dirty+0x91/0x120
[15277.277823]  [<ffffffff813628dd>] ? radix_tree_lookup+0xd/0x10
[15277.305062]  [<ffffffff811a9655>] ondemand_readahead+0x135/0x260
[15277.332764]  [<ffffffff811a97ec>] page_cache_async_readahead+0x6c/0x70
[15277.363440]  [<ffffffff8119e1a3>] filemap_fault+0x393/0x550
[15277.389663]  [<ffffffffa02cce3f>] xfs_filemap_fault+0x5f/0xf0 [xfs]
[15277.418997]  [<ffffffff811cda3f>] __do_fault+0x7f/0x100
[15277.443617]  [<ffffffffa02c29d4>] ? xfs_vm_set_page_dirty+0xc4/0x1e0 [xfs]
[15277.475880]  [<ffffffff811d319d>] handle_mm_fault+0x65d/0x1300
[15277.503198]  [<ffffffff8106b04b>] __do_page_fault+0x1cb/0x4a0
[15277.530218]  [<ffffffff8106b350>] do_page_fault+0x30/0x80
[15277.555708]  [<ffffffff816fa048>] page_fault+0x28/0x30
[15277.579871] ---[ end trace 5211814c2a051103 ]---

And I'm still trying to find a more reliable & efficient reproducer.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
