Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F7757F37
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 13:59:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4DE6C8F8033
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 11:59:01 -0700 (PDT)
Received: from c.mail.sonic.net (c.mail.sonic.net [64.142.111.80]) by
	cuda.sgi.com with ESMTP id kg7CaDGYdvyEIyFH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 11:58:59 -0700 (PDT)
Received: from [64.142.18.25] (gwork.noc.sonic.net [64.142.18.25])
	(authenticated bits=0)
	by c.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id t8EIwvau003336
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 11:58:58 -0700
From: Grant Keller <grant.keller@sonic.com>
Subject: rm Tainted warning after kernel update.
Message-ID: <55F718A1.10801@sonic.com>
Date: Mon, 14 Sep 2015 11:57:37 -0700
MIME-Version: 1.0
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

Hello,

I have a server running Scientific Linux 6.7, and since updating to
kernel 2.6.32-573.3.1.el6.x86_64 the following error has begun appearing
in our message logs:

Sep 14 11:43:03 localhost kernel: ------------[ cut here ]------------
Sep 14 11:43:03 localhost kernel: WARNING: at fs/dcache.c:758
d_delete+0x260/0x2c0() (Tainted: G        W  -- ------------   )
Sep 14 11:43:03 localhost kernel: Hardware name: X7DB8
Sep 14 11:43:03 localhost kernel: Modules linked in: nfsd nfs_acl
auth_rpcgss autofs4 lockd sunrpc p4_clockmod freq_table speedstep_lib
nf_conntrack_ftp iptable_mangle xt_comment nf_conntrack_ipv4
nf_defrag_ipv4 xt_multiport iptable_filter ip_tables ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm
iw_cm ib_sa ib_mad ib_core ib_addr ipv6 xfs exportfs ppdev parport_pc
parport sg e1000e microcode serio_raw iTCO_wdt iTCO_vendor_support ixgbe
ptp pps_core mdio i2c_i801 lpc_ich mfd_core i5000_edac edac_core i5k_amb
ioatdma dca shpchp ext4 jbd2 mbcache sd_mod crc_t10dif 3w_9xxx pata_acpi
ata_generic ata_piix radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_msghandler]
Sep 14 11:43:03 localhost kernel: Pid: 15893, comm: rm Tainted: G       
W  -- ------------    2.6.32-573.3.1.el6.x86_64 #1
Sep 14 11:43:03 localhost kernel: Call Trace:
Sep 14 11:43:03 localhost kernel: [<ffffffff81077491>] ?
warn_slowpath_common+0x91/0xe0
Sep 14 11:43:03 localhost kernel: [<ffffffff810774fa>] ?
warn_slowpath_null+0x1a/0x20
Sep 14 11:43:03 localhost kernel: [<ffffffff811ae660>] ?
d_delete+0x260/0x2c0
Sep 14 11:43:03 localhost kernel: [<ffffffff811a0908>] ? vfs_rmdir+0xe8/0xf0
Sep 14 11:43:03 localhost kernel: [<ffffffff811a3b64>] ?
do_rmdir+0x184/0x1f0
Sep 14 11:43:03 localhost kernel: [<ffffffff81193511>] ? __fput+0x1a1/0x210
Sep 14 11:43:03 localhost kernel: [<ffffffff810e8ab7>] ?
audit_syscall_entry+0x1d7/0x200
Sep 14 11:43:03 localhost kernel: [<ffffffff811a3bfd>] ?
sys_unlinkat+0x2d/0x40
Sep 14 11:43:03 localhost kernel: [<ffffffff8100b0d2>] ?
system_call_fastpath+0x16/0x1b
Sep 14 11:43:03 localhost kernel: ---[ end trace 6080ec4a7ec5ec25 ]---

This happens when we are expiring older backups from the archives, so I
have quite a few of these. We have xfsprogs 3.1.1-16.el6.x86_64
installed. Looking for advice on how to proceed.

-- 
Grant Keller
System Operations
707-237-2451
grant.keller@sonic.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
