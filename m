Return-Path: <SRS0=ClpI=2V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7005EC2D0C2
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Dec 2019 12:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CCDF206DA
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Dec 2019 12:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfLaMrM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 07:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfLaMrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Dec 2019 07:47:12 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206027] New: [xfstests generic/475]: WARNING: CPU: 4 PID: 32186
 at fs/iomap/buffered-io.c:1067 iomap_page_mkwrite_actor+0xd9/0x130
Date:   Tue, 31 Dec 2019 12:47:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206027-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206027

            Bug ID: 206027
           Summary: [xfstests generic/475]: WARNING: CPU: 4 PID: 32186 at
                    fs/iomap/buffered-io.c:1067
                    iomap_page_mkwrite_actor+0xd9/0x130
           Product: File System
           Version: 2.5
    Kernel Version: 5.5-rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

xfstests generic/475 hit below kernel warning on upstream mainline kernel
5.5-rc4(HEAD: fd6988496e79 Linux 5.5-rc4)

[94055.987303] XFS (dm-6): xfs_do_force_shutdown(0x2) called from line 1297 of
file fs/xfs/xfs_log.c. Return address = ffffffffc0f84e7d
[94055.987308] XFS (dm-6): Log I/O Error Detected. Shutting down filesystem
[94055.987312] XFS (dm-6): Please unmount the filesystem and rectify the
problem(s)
[94056.027156] WARNING: CPU: 4 PID: 32186 at fs/iomap/buffered-io.c:1067
iomap_page_mkwrite_actor+0xd9/0x130
[94056.037835] Modules linked in: loop rfkill sunrpc intel_rapl_msr
intel_rapl_common iTCO_wdt iTCO_vendor_support sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypa
ss crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore
ipmi_ssif cdc_ether usbnet mii intel_rapl_perf sg ipmi_si pcspkr ipmi_devintf
ioatdma ipmi_msghandler i2c_i801 l
pc_ich ip_tables xfs libcrc32c wmi sd_mod mgag200 drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops drm_vram_helper drm_ttm_helper ttm drm igb
dca crc32c_intel megaraid_sas i2c_alg
o_bit dm_mirror dm_region_hash dm_log dm_mod
[94056.097924] CPU: 4 PID: 32186 Comm: fsstress Tainted: G        W        
5.5.0-rc4-mainline #13
[94056.107642] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS
-[VVE124AUS-1.30]- 11/21/2012
[94056.118044] RIP: 0010:iomap_page_mkwrite_actor+0xd9/0x130
[94056.124064] Code: 0f 44 e5 4c 89 e7 e8 d6 2a da ff 4c 89 e2 48 b8 00 00 00
00 00 fc ff df 48 c1 ea 03 80 3c 02 00 75 53 49 8b 04 24 a8 04 75 23 <0f> 0b 48
89 ee 4c 89 ef e8 ca fb ff ff 48 
89 ef e8 72 29 c1 ff 48
[94056.145020] RSP: 0000:ffff88843c937910 EFLAGS: 00010246
[94056.150852] RAX: 0017ffffc0000011 RBX: 0000000000001000 RCX:
ffffffffa6b31fba
[94056.158817] RDX: 1ffffd4000cfa008 RSI: 0000000000000008 RDI:
ffffea00067d0040
[94056.166781] RBP: ffffea00067d0040 R08: fffff94000cfa009 R09:
fffff94000cfa009
[94056.174744] R10: fffff94000cfa008 R11: ffffea00067d0047 R12:
ffffea00067d0040
[94056.182707] R13: ffff8881947d2298 R14: ffff8881947d2298 R15:
ffffffffc10acd20
[94056.190671] FS:  00007f3d4f6dfb80(0000) GS:ffff8881e7800000(0000)
knlGS:0000000000000000
[94056.199700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[94056.206112] CR2: 00007f3d4f6d1010 CR3: 0000000430596001 CR4:
00000000000606e0
[94056.214074] Call Trace:
[94056.216810]  iomap_apply+0x25d/0xb24
[94056.220800]  ? iomap_page_create+0x350/0x350
[94056.225675]  ? xfs_trans_alloc+0x468/0x660 [xfs]
[94056.230830]  ? trace_event_raw_event_iomap_page_class+0x3d0/0x3d0
[94056.237696]  ? xfs_vn_fiemap+0xa0/0xa0 [xfs]
[94056.242469]  ? file_update_time+0x278/0x400
[94056.247140]  ? iomap_page_create+0x350/0x350
[94056.251905]  iomap_page_mkwrite+0x1f6/0x2e0
[94056.256575]  ? iomap_page_create+0x350/0x350
[94056.261397]  ? __xfs_filemap_fault+0x3db/0x700 [xfs]
[94056.267005]  __xfs_filemap_fault+0x495/0x700 [xfs]
[94056.272359]  ? lock_downgrade+0x6d0/0x6d0
[94056.276900]  ? xfs_file_read_iter+0x740/0x740 [xfs]
[94056.282353]  do_page_mkwrite+0x18a/0x3b0
[94056.286733]  do_wp_page+0xb2e/0x10b0
[94056.290724]  ? do_raw_spin_trylock+0xb2/0x180
[94056.295587]  ? finish_mkwrite_fault+0x610/0x610
[94056.300646]  ? pgd_free+0x270/0x270
[94056.304544]  __handle_mm_fault+0x1c38/0x3230
[94056.309313]  ? lockdep_hardirqs_on+0x590/0x590
[94056.314272]  ? lock_downgrade+0x6d0/0x6d0
[94056.318749]  ? copy_page_range+0x6f0/0x6f0
[94056.323323]  ? lock_acquire+0x15a/0x3d0
[94056.327611]  ? down_read_non_owner+0x490/0x490
[94056.332573]  handle_mm_fault+0x275/0x6f0
[94056.336957]  __do_page_fault+0x3db/0xa50
[94056.341339]  do_page_fault+0x37/0x550
[94056.345432]  page_fault+0x3e/0x50
[94056.349133] RIP: 0033:0x7f3d4eb7ec3a
[94056.353122] Code: 77 16 f3 0f 7f 07 f3 0f 7f 47 10 f3 0f 7f 44 17 f0 f3 0f
7f 44 17 e0 c3 48 8d 4f 40 f3 0f 7f 07 48 83 e1 c0 f3 0f 7f 44 17 f0 <f3> 0f 7f
47 10 f3 0f 7f 44 17 e0 f3 0f 7f 47 20 f3 0f 7f 44 17 d0
[94056.374077] RSP: 002b:00007ffe7c5c2f48 EFLAGS: 00010202
[94056.379909] RAX: 00007f3d4f6d1000 RBX: 0000000000055000 RCX:
00007f3d4f6d1040
[94056.387872] RDX: 000000000000db34 RSI: 000000000000004d RDI:
00007f3d4f6d1000
[94056.395835] RBP: 000000000007a120 R08: 0000000000000003 R09:
0000000000055000
[94056.403797] R10: 0000000000000008 R11: 0000000000000246 R12:
0000000051eb851f
[94056.411762] R13: 000000000040c5e0 R14: 000000000000db34 R15:
0000000000000000
[94056.419734] irq event stamp: 0
[94056.423140] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[94056.430138] hardirqs last disabled at (0): [<ffffffffa61e05a4>]
copy_process+0x1994/0x6430
[94056.439363] softirqs last  enabled at (0): [<ffffffffa61e0640>]
copy_process+0x1a30/0x6430
[94056.448587] softirqs last disabled at (0): [<0000000000000000>] 0x0
[94056.455581] ---[ end trace b6fdae90624bb004 ]---
[94056.682146] XFS (dm-6): Unmounting Filesystem


# cat results/generic/475.full
meta-data=/dev/mapper/rhel_ibm--x3650m4--10-xfscratch isize=512    agcount=4,
agsize=5570560 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=22282240, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=10880, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
device-mapper: remove ioctl on error-test  failed: No such device or address
Command failed.
seed = 1577643598
seed = 1578055977
seed = 1577955642
seed = 1577419009
...
...

This can be reproduced by loop running generic/475 on xfs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
