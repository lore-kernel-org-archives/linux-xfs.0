Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB8497CA2
	for <xfs@oss.sgi.com>; Sat, 27 Feb 2016 07:03:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1246AC002
	for <xfs@oss.sgi.com>; Sat, 27 Feb 2016 05:03:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tVzVBDXVCiFSuwun (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 27 Feb 2016 05:03:01 -0800 (PST)
Date: Sat, 27 Feb 2016 21:02:56 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: generic/320 triggers "list_add attempted on force-poisoned entry"
	warning on XFS
Message-ID: <20160227130256.GJ11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

Hi,

Starting from 4.5-rc1 kernel, I sometimes see generic/320 triggers
"list_add attempted on force-poisoned entry" warnings on XFS, test hosts
are arm64/ppc64/ppc64le, haven't seen it on x86_64 hosts.

[ 2441.772340] run fstests generic/320 at 2016-02-27 05:52:05
[ 2441.916302] XFS (sda5): Unmounting Filesystem
[ 2442.180551] XFS (sda5): Mounting V5 Filesystem
[ 2442.231940] XFS (sda5): Ending clean mount
[ 2460.142155] list_add attempted on force-poisoned entry
[ 2460.142278] ------------[ cut here ]------------
[ 2460.142326] WARNING: at lib/list_debug.c:34
[ 2460.142362] Modules linked in: rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_
ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ses enclosure scsi_transport_sas sg shpchp powernv_rng rtc_opal nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_
mod sd_mod cdrom mlx4_ib ib_sa ib_mad mlx4_en ib_core vxlan ip6_udp_tunnel ib_addr udp_tunnel mlx4_core ipr libata tg3 ptp pps_core
[ 2460.143083] CPU: 21 PID: 134288 Comm: cp Not tainted 4.5.0-rc5 #25
[ 2460.143141] task: c000000f550adb00 ti: c000000fb5fc0000 task.ti: c000000fb5fc0000
[ 2460.143209] NIP: c00000000043c390 LR: c00000000043c38c CTR: 0000000030041bec
[ 2460.143278] REGS: c000000fb5fc30a0 TRAP: 0700   Not tainted (4.5.0-rc5)
[ 2460.143334] MSR: 900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 22028422  XER: 00000000
[ 2460.143575] CFAR: c0000000008259d8 SOFTE: 0
GPR00: c00000000043c38c c000000fb5fc3320 c00000000108bc00 000000000000002a
GPR04: c000000ff8d49c50 c000000ff8d5b4a0 900000010280b033 0000000000000065
GPR08: 0000000000000000 c000000000bcb284 0000000ff8180000 000000000000076b
GPR12: 0000000000008800 c00000000fb8bd00 0000000000000000 0000000000000000
GPR16: 0000000000000000 00003ffffa430978 0000000000000000 0000000000000001
GPR20: c000000fb08ab880 0000000000008180 d00000002024bae0 0000000000000000
GPR24: 0000000000000000 c000000fc73c9e40 c000000fe914a740 0000000000000002
GPR28: 0000000000000001 c000000fc812ab38 c000000fc812ab38 c000000fb5fc33c0
[ 2460.144450] NIP [c00000000043c390] __list_add+0xb0/0x150
[ 2460.144497] LR [c00000000043c38c] __list_add+0xac/0x150
[ 2460.144542] Call Trace:
[ 2460.144566] [c000000fb5fc3320] [c00000000043c38c] __list_add+0xac/0x150 (unreliable)
[ 2460.144648] [c000000fb5fc33a0] [c00000000081b454] __down+0x4c/0xf8
[ 2460.144718] [c000000fb5fc3410] [c00000000010b6f8] down+0x68/0x70
[ 2460.144809] [c000000fb5fc3450] [d0000000201ebf4c] xfs_buf_lock+0x4c/0x150 [xfs]
[ 2460.144902] [c000000fb5fc3490] [d0000000201ec2f0] _xfs_buf_find+0x2a0/0x4d0 [xfs]
[ 2460.144995] [c000000fb5fc3530] [d0000000201ec70c] xfs_buf_get_map+0x4c/0x250 [xfs]
[ 2460.145088] [c000000fb5fc35d0] [d0000000201ed740] xfs_buf_read_map+0x50/0x1f0 [xfs]
[ 2460.145244] [c000000fb5fc3630] [d0000000202280d8] xfs_trans_read_buf_map+0x1d8/0x390 [xfs]
[ 2460.145412] [c000000fb5fc36a0] [d0000000201d849c] xfs_read_agi+0x9c/0x130 [xfs]
[ 2460.145580] [c000000fb5fc3700] [d0000000201d8580] xfs_ialloc_read_agi+0x50/0x160 [xfs]
[ 2460.145748] [c000000fb5fc3750] [d0000000201d92f0] xfs_dialloc+0x130/0x2f0 [xfs]
[ 2460.145918] [c000000fb5fc37e0] [d000000020203274] xfs_ialloc+0x84/0x550 [xfs]
[ 2460.146068] [c000000fb5fc3860] [d0000000202037d8] xfs_dir_ialloc+0x98/0x270 [xfs]
[ 2460.146240] [c000000fb5fc3960] [d000000020203f24] xfs_create+0x4f4/0x750 [xfs]
[ 2460.146412] [c000000fb5fc3a60] [d0000000201ff0a8] xfs_generic_create+0x208/0x3d0 [xfs]
[ 2460.146572] [c000000fb5fc3af0] [c0000000002af0f8] vfs_create+0x158/0x1f0
[ 2460.146708] [c000000fb5fc3b40] [c0000000002b0cd8] do_last+0x698/0xf40
[ 2460.146845] [c000000fb5fc3c10] [c0000000002b1624] path_openat+0xa4/0x3c0
[ 2460.146982] [c000000fb5fc3c90] [c0000000002b2ec4] do_filp_open+0x74/0xf0
[ 2460.147120] [c000000fb5fc3dc0] [c00000000029c654] do_sys_open+0x1b4/0x2d0
[ 2460.147257] [c000000fb5fc3e30] [c000000000009204] system_call+0x38/0xb4
[ 2460.147392] Instruction dump:
[ 2460.147459] fbfe0000 38210080 e8010010 eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4e800020
[ 2460.147680] 3c62ff9e 38631a78 483e95f9 60000000 <0fe00000> 4bffff98 60000000 60420000
[ 2460.147902] ---[ end trace aa6c4f990634a77c ]---

The warning itself is introduced by commit 5c2c2587b132 ("mm, dax, pmem:
introduce {get|put}_dev_pagemap() for dax-gup") in 4.5-rc1, and git
bisect points to the same commit. But I'm not sure if it's a regression
or just exposes an old issue.

If more infomation is needed please let me know.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
