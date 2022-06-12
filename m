Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B260C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 11:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbiFLL7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 07:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiFLL7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 07:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B121408C
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 04:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 765B660EAE
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5D31C385A5
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jun 2022 11:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655035159;
        bh=HiZ/uPIWYfrhaEEwpImqq9iNcsHNIHBbEWkMwkLbrOc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LQ8G9CP3GKQigpFPmar9+YTLxnBSp2299mb8AcFP/VY6n7auWbcnXJYoxCZL5DqmA
         oYclJKAeyiCUY/rQ1V56/gijWZp1CS/kp1DOrkZey7vSd2ZvmgvoYCuYzinsULzJm5
         QQCaJCL9ZjKbAl61dJW9wbd2QGj0YZk2Xmmy98Efw/4tnwJvWM0/qu6g8/PdnNlkEf
         wzagf36ckPyywAX048HEDGuApPDsMZE0pr8Z+DqlWh38eC57NFtxDY5FmBYJqTZ6Pt
         F9zdNoqRA1Mah26vrLqigIisPDlfnmdTOI7Qke3xsBDy/xx5oqhXPD68jVi1XrE/+n
         q2qqflrX2UavA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C5CFECC13B3; Sun, 12 Jun 2022 11:59:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 12 Jun 2022 11:59:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: willy@infradead.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-iVDuXtwOzX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #11 from willy@infradead.org ---
On Sun, Jun 12, 2022 at 12:42:30PM +0800, Zorro Lang wrote:
> Looks likt it's not a s390x specific bug, I just hit this issue once (not
> 100%
> reproducible) on aarch64 with linux v5.19.0-rc1+ [1]. So back to cc linux=
-mm
> to get more review.
>=20
> [1]
> [  980.200947] usercopy: Kernel memory exposure attempt detected from vma=
lloc
> 'no area' (offset 0, size 1)!=20

       if (is_vmalloc_addr(ptr)) {
               struct vm_struct *area =3D find_vm_area(ptr);
               if (!area) {
                       usercopy_abort("vmalloc", "no area", to_user, 0, n);

Oh.  Looks like XFS uses vm_map_ram() and vm_map_ram() doesn't allocate
a vm_struct.

Ulad, how does this look to you?

diff --git a/mm/usercopy.c b/mm/usercopy.c
index baeacc735b83..6bc2a1407c59 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -173,7 +173,7 @@ static inline void check_heap_object(const void *ptr,
unsigned long n,
        }

        if (is_vmalloc_addr(ptr)) {
-               struct vm_struct *area =3D find_vm_area(ptr);
+               struct vmap_area *area =3D find_vmap_area((unsigned long)pt=
r);
                unsigned long offset;

                if (!area) {
@@ -181,8 +181,9 @@ static inline void check_heap_object(const void *ptr,
unsigned long n,
                        return;
                }

-               offset =3D ptr - area->addr;
-               if (offset + n > get_vm_area_size(area))
+               /* XXX: We should also abort for free vmap_areas */
+               offset =3D (unsigned long)ptr - area->va_start;
+               if (offset + n >=3D area->va_end)
                        usercopy_abort("vmalloc", NULL, to_user, offset, n);
                return;
        }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 07db42455dd4..effd1ff6a4b4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1798,7 +1798,7 @@ static void free_unmap_vmap_area(struct vmap_area *va)
        free_vmap_area_noflush(va);
 }

-static struct vmap_area *find_vmap_area(unsigned long addr)
+struct vmap_area *find_vmap_area(unsigned long addr)
 {
        struct vmap_area *va;


> [  980.200968] ------------[ cut here ]------------=20
> [  980.200969] kernel BUG at mm/usercopy.c:101!=20
> [  980.201081] Internal error: Oops - BUG: 0 [#1] SMP=20
> [  980.224192] Modules linked in: rfkill arm_spe_pmu mlx5_ib ast
> drm_vram_helper drm_ttm_helper ttm ib_uverbs acpi_ipmi drm_kms_helper
> ipmi_ssif fb_sys_fops syscopyarea sysfillrect ib_core sysimgblt arm_cmn
> arm_dmc620_pmu arm_dsu_pmu cppc_cpufreq sunrpc vfat fat drm fuse xfs
> libcrc32c mlx5_core crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce
> sbsa_gwdt nvme igb mlxfw nvme_core tls i2c_algo_bit psample pci_hyperv_in=
tf
> i2c_designware_platform i2c_designware_core xgene_hwmon ipmi_devintf
> ipmi_msghandler=20
> [  980.268449] CPU: 42 PID: 121940 Comm: rm Kdump: loaded Not tainted
> 5.19.0-rc1+ #1=20
> [  980.275921] Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F16f
> (SCP: 1.06.20210615) 07/01/2021=20
> [  980.285214] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS
> BTYPE=3D--)=20
> [  980.292165] pc : usercopy_abort+0x78/0x7c=20
> [  980.296167] lr : usercopy_abort+0x78/0x7c=20
> [  980.300166] sp : ffff80002b007730=20
> [  980.303469] x29: ffff80002b007740 x28: ffff80002b007cc0 x27:
> ffffdc5683ecc880=20
> [  980.310595] x26: 1ffff00005600f9b x25: ffffdc5681c90000 x24:
> ffff80002b007cdc=20
> [  980.317722] x23: ffff800041a0004a x22: 0000000000000001 x21:
> 0000000000000001=20
> [  980.324848] x20: 0000000000000000 x19: ffff800041a00049 x18:
> 0000000000000000=20
> [  980.331974] x17: 2720636f6c6c616d x16: 76206d6f72662064 x15:
> 6574636574656420=20
> [  980.339101] x14: 74706d6574746120 x13: 21293120657a6973 x12:
> ffff6106cbc4c03f=20
> [  980.346227] x11: 1fffe106cbc4c03e x10: ffff6106cbc4c03e x9 :
> ffffdc5681f36e30=20
> [  980.353353] x8 : ffff08365e2601f7 x7 : 0000000000000001 x6 :
> ffff6106cbc4c03e=20
> [  980.360480] x5 : ffff08365e2601f0 x4 : 1fffe10044b11801 x3 :
> 0000000000000000=20
> [  980.367606] x2 : 0000000000000000 x1 : ffff08022588c000 x0 :
> 000000000000005c=20
> [  980.374733] Call trace:=20
> [  980.377167]  usercopy_abort+0x78/0x7c=20
> [  980.380819]  check_heap_object+0x3dc/0x3e0=20
> [  980.384907]  __check_object_size.part.0+0x6c/0x1f0=20
> [  980.389688]  __check_object_size+0x24/0x30=20
> [  980.393774]  filldir64+0x548/0x84c=20
> [  980.397165]  xfs_dir2_block_getdents+0x404/0x960 [xfs]=20
> [  980.402437]  xfs_readdir+0x3c4/0x4b0 [xfs]=20
> [  980.406652]  xfs_file_readdir+0x6c/0xa0 [xfs]=20
> [  980.411127]  iterate_dir+0x3a4/0x500

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
