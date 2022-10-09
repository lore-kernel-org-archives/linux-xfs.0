Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BDBC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 17:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJIR5O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 13:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiJIR5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 13:57:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF3913EA3
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 10:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E93B60187
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CEA3C43470
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665338230;
        bh=NOKZP9zeDcv5NxaxF8f7vod+fNmYp6QWqJB7BVsjK/8=;
        h=From:To:Subject:Date:From;
        b=b8aPRCWoNHLeXVaKrBhflss/kyS+XHgeQigb1siHiCWWU2RLpsUs+fpU159CEKdHo
         XgqMg3zASvvyl0hjd8AP8zBspTp1Q4nPnSfzARtw/EjWcotaWRFMTvUgepCVCQA592
         vNh07pRqV/6pA6u3UIWBo25KODnFmM3dADl28BM5KS6iSry84amKHW9jEzsMjDH6NU
         uZe8nacUdDjAvLyukRhrjm0W7gV4iy5ILAg/B/A/RxkJKbM6sZQBv9MxugW/S8JkOs
         ElDWGk8PCmXETQt2kyY8X1Sr0HK1l3TYhFKzx/iwO9P0SnrEWBZ/ShSQIBw4ogstBw
         0Yl5ogRW0fT2Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 796FEC05F8A; Sun,  9 Oct 2022 17:57:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216567] New: [xfstests generic/451] kernel BUG at
 mm/truncate.c:669!
Date:   Sun, 09 Oct 2022 17:57:10 +0000
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
Message-ID: <bug-216567-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216567

            Bug ID: 216567
           Summary: [xfstests generic/451] kernel BUG at
                    mm/truncate.c:669!
           Product: File System
           Version: 2.5
    Kernel Version: v6.1-rc0
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

xfstests generic/451 hit panic[1] on xfs with 64k directory block size (-n
size=3D65536). I hit this panic once, then reproduce it once by loop running
generic/450 + generic/451 (panic on g/451) on xfs(-n size=3D65536) hundreds=
 of
times.

The last time I hit this panic on linux which HEAD=3D

commit a6afa4199d3d038fbfdff5511f7523b0e30cb774
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Oct 8 10:30:44 2022 -0700

    Merge tag 'mailbox-v6.1' of
git://git.linaro.org/landing-teams/working/fujitsu/integration

[1]
[ 1235.090869] run fstests generic/451 at 2022-10-09 11:14:23=20
[ 1263.860224] page:000000002e63229f refcount:4 mapcount:0
mapping:0000000002dcf476 index:0x43 pfn:0x4006a5=20
[ 1263.869953] memcg:ff110010ca620000=20
[ 1263.873384] aops:xfs_address_space_operations [xfs] ino:83 dentry
name:"tst-aio-dio-cycle-write.451"=20
[ 1263.882714] flags:
0x17ffffc0000027(locked|referenced|uptodate|active|node=3D0|zone=3D2|lastcp=
upid=3D0x1fffff)=20
[ 1263.892329] raw: 0017ffffc0000027 0000000000000000 dead000000000122
ff110002040cfc48=20
[ 1263.900095] raw: 0000000000000043 0000000000000000 00000011ffffffff
ff110010ca620000=20
[ 1263.907858] page dumped because: VM_BUG_ON_FOLIO(!folio_contains(folio,
index))=20
[ 1263.915205] ------------[ cut here ]------------=20
[ 1263.919838] kernel BUG at mm/truncate.c:669!=20
[ 1263.924136] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI=20
[ 1263.929887] CPU: 110 PID: 739 Comm: kworker/110:1 Kdump: loaded Not tain=
ted
6.0.0+ #1=20
[ 1263.937711] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[ 1263.945192] Workqueue: dio/sda3 iomap_dio_complete_work=20
[ 1263.950426] RIP: 0010:invalidate_inode_pages2_range+0x2e2/0x9a0=20
[ 1263.956352] Code: c0 03 38 d0 7c 08 84 d2 0f 85 c9 05 00 00 41 8b 47 5c =
4c
39 f0 0f 87 80 fe ff ff 48 c7 c6 60 98 75 8b 4c 89 ff e8 4e af 07 00 <0f> 0=
b e8
c7 1f fe ff 4c 89 ff e8 bf bf 03 00 84 c0 0f 85 24 02 00=20
[ 1263.975099] RSP: 0018:ffa000000a6efaa8 EFLAGS: 00010286=20
[ 1263.980325] RAX: 0000000000000043 RBX: dffffc0000000000 RCX:
0000000000000000=20
[ 1263.987458] RDX: 0000000000000001 RSI: ffffffff8b8ce8e0 RDI:
fff3fc00014ddf45=20
[ 1263.994592] RBP: 0000000000000000 R08: 0000000000000043 R09:
ff11000c32bfd487=20
[ 1264.001723] R10: ffe21c018657fa90 R11: 0000000000000001 R12:
ff110002040cfc48=20
[ 1264.008855] R13: 0000000000000041 R14: fffffffffffffffe R15:
ffd400001001a940=20
[ 1264.015989] FS:  0000000000000000(0000) GS:ff11000c32a00000(0000)
knlGS:0000000000000000=20
[ 1264.024073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1264.029822] CR2: 0000000001f3c018 CR3: 00000011525a8002 CR4:
0000000000771ee0=20
[ 1264.036953] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1264.044085] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1264.051219] PKRU: 55555554=20
[ 1264.053932] Call Trace:=20
[ 1264.056384]  <TASK>=20
[ 1264.058492]  ? mapping_evict_folio.part.0+0x1e0/0x1e0=20
[ 1264.063551]  ? xfs_dio_write_end_io+0x13f/0x810 [xfs]=20
[ 1264.068745]  iomap_dio_complete+0x413/0x870=20
[ 1264.072930]  ? aio_fsync_work+0x2a0/0x2a0=20
[ 1264.076942]  iomap_dio_complete_work+0x52/0x80=20
[ 1264.081388]  process_one_work+0x8b7/0x1540=20
[ 1264.085490]  ? __lock_acquired+0x209/0x890=20
[ 1264.089596]  ? pwq_dec_nr_in_flight+0x230/0x230=20
[ 1264.094127]  ? __lock_contended+0x980/0x980=20
[ 1264.098317]  ? worker_thread+0x160/0xed0=20
[ 1264.102249]  worker_thread+0x5ac/0xed0=20
[ 1264.106005]  ? process_one_work+0x1540/0x1540=20
[ 1264.110370]  kthread+0x29f/0x340=20
[ 1264.113600]  ? kthread_complete_and_exit+0x20/0x20=20
[ 1264.118396]  ret_from_fork+0x1f/0x30=20
[ 1264.121986]  </TASK>=20
[ 1264.124175] Modules linked in: ipmi_ssif intel_rapl_msr intel_rapl_common
intel_uncore_frequency intel_uncore_frequency_common mgag200 mlx5_ib
i2c_algo_bit drm_shmem_helper drm_kms_helper dell_smbios syscopyarea i10nm_=
edac
nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel dcdbas kvm rf=
kill
irqbypass rapl ib_uverbs intel_cstate intel_uncore dell_wmi_descriptor wmi_=
bmof
ib_core pcspkr isst_if_mbox_pci isst_if_mmio acpi_ipmi sysfillrect mei_me
isst_if_common i2c_i801 sysimgblt ipmi_si fb_sys_fops i2c_smbus mei
intel_pch_thermal intel_vsec ipmi_devintf ipmi_msghandler acpi_power_meter
sunrpc drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul
crc32_pclmul crc32c_intel mlxfw ghash_clmulni_intel tls ahci libahci psample
megaraid_sas pci_hyperv_intf tg3 libata wmi=20
[ 1264.193575] ---[ end trace 0000000000000000 ]---=20
[ 1264.226461] RIP: 0010:invalidate_inode_pages2_range+0x2e2/0x9a0=20
[ 1264.232402] Code: c0 03 38 d0 7c 08 84 d2 0f 85 c9 05 00 00 41 8b 47 5c =
4c
39 f0 0f 87 80 fe ff ff 48 c7 c6 60 98 75 8b 4c 89 ff e8 4e af 07 00 <0f> 0=
b e8
c7 1f fe ff 4c 89 ff e8 bf bf 03 00 84 c0 0f 85 24 02 00=20
[ 1264.251156] RSP: 0018:ffa000000a6efaa8 EFLAGS: 00010286=20
[ 1264.256388] RAX: 0000000000000043 RBX: dffffc0000000000 RCX:
0000000000000000=20
[ 1264.263536] RDX: 0000000000000001 RSI: ffffffff8b8ce8e0 RDI:
fff3fc00014ddf45=20
[ 1264.270673] RBP: 0000000000000000 R08: 0000000000000043 R09:
ff11000c32bfd487=20
[ 1264.277814] R10: ffe21c018657fa90 R11: 0000000000000001 R12:
ff110002040cfc48=20
[ 1264.284955] R13: 0000000000000041 R14: fffffffffffffffe R15:
ffd400001001a940=20
[ 1264.292095] FS:  0000000000000000(0000) GS:ff11000c32a00000(0000)
knlGS:0000000000000000=20
[ 1264.300190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1264.305946] CR2: 0000000001f3c018 CR3: 00000011525a8002 CR4:
0000000000771ee0=20
[ 1264.313086] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1264.320229] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1264.327372] PKRU: 55555554=20
[-- MARK -- Sun Oct  9 15:15:00 2022]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
