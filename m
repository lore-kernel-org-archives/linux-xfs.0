Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9E1CCA47D
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 11:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiFLL7R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 07:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiFLL7Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 07:59:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0229A1C13F;
        Sun, 12 Jun 2022 04:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3KXVdownPf+XtBYtHXzLfe4VCme34Fi24LyBj8hBMl0=; b=IcxYejTIgt1WEFCRwMXmCKg2KV
        r1OOz8KLjFQJ0dpy7Oo4ov1DJJ5PgwZBh3XQO/yZNUxofDwjrpw2h3KJcsQdWitcuK64Mcg71fCKk
        jMjs4zgrbjSr5gddJQu0ipPqOEk3z9IzDEs8radkDwC0LWcYfecOYEcQuCi27x27GpyUVcHyOzNfZ
        x2fhPGS0zdCKA7kPZYExnTv57ETJXLP0zxksrUF+UNCDIr1vFXaZqwW3eb63qKsxdPAoZQRaf4o68
        nPjITWNacWHlUKVzqvNHF3t7abPbnrdxS2W9bu0Ezrqppm19yU9//V4TnS9hn7//TxRzvfvTrk1JJ
        P4sBS1TA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0MF0-00FzUP-6Q; Sun, 12 Jun 2022 11:58:50 +0000
Date:   Sun, 12 Jun 2022 12:58:50 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <YqXU+oU7wayOcmCe@casper.infradead.org>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612044230.murerhsa765akogj@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 12:42:30PM +0800, Zorro Lang wrote:
> Looks likt it's not a s390x specific bug, I just hit this issue once (not 100%
> reproducible) on aarch64 with linux v5.19.0-rc1+ [1]. So back to cc linux-mm
> to get more review.
> 
> [1]
> [  980.200947] usercopy: Kernel memory exposure attempt detected from vmalloc 'no area' (offset 0, size 1)! 

       if (is_vmalloc_addr(ptr)) {
               struct vm_struct *area = find_vm_area(ptr);
               if (!area) {
                       usercopy_abort("vmalloc", "no area", to_user, 0, n);

Oh.  Looks like XFS uses vm_map_ram() and vm_map_ram() doesn't allocate
a vm_struct.

Ulad, how does this look to you?

diff --git a/mm/usercopy.c b/mm/usercopy.c
index baeacc735b83..6bc2a1407c59 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -173,7 +173,7 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 	}
 
 	if (is_vmalloc_addr(ptr)) {
-		struct vm_struct *area = find_vm_area(ptr);
+		struct vmap_area *area = find_vmap_area((unsigned long)ptr);
 		unsigned long offset;
 
 		if (!area) {
@@ -181,8 +181,9 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 			return;
 		}
 
-		offset = ptr - area->addr;
-		if (offset + n > get_vm_area_size(area))
+		/* XXX: We should also abort for free vmap_areas */
+		offset = (unsigned long)ptr - area->va_start;
+		if (offset + n >= area->va_end)
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
 

> [  980.200968] ------------[ cut here ]------------ 
> [  980.200969] kernel BUG at mm/usercopy.c:101! 
> [  980.201081] Internal error: Oops - BUG: 0 [#1] SMP 
> [  980.224192] Modules linked in: rfkill arm_spe_pmu mlx5_ib ast drm_vram_helper drm_ttm_helper ttm ib_uverbs acpi_ipmi drm_kms_helper ipmi_ssif fb_sys_fops syscopyarea sysfillrect ib_core sysimgblt arm_cmn arm_dmc620_pmu arm_dsu_pmu cppc_cpufreq sunrpc vfat fat drm fuse xfs libcrc32c mlx5_core crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce sbsa_gwdt nvme igb mlxfw nvme_core tls i2c_algo_bit psample pci_hyperv_intf i2c_designware_platform i2c_designware_core xgene_hwmon ipmi_devintf ipmi_msghandler 
> [  980.268449] CPU: 42 PID: 121940 Comm: rm Kdump: loaded Not tainted 5.19.0-rc1+ #1 
> [  980.275921] Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F16f (SCP: 1.06.20210615) 07/01/2021 
> [  980.285214] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--) 
> [  980.292165] pc : usercopy_abort+0x78/0x7c 
> [  980.296167] lr : usercopy_abort+0x78/0x7c 
> [  980.300166] sp : ffff80002b007730 
> [  980.303469] x29: ffff80002b007740 x28: ffff80002b007cc0 x27: ffffdc5683ecc880 
> [  980.310595] x26: 1ffff00005600f9b x25: ffffdc5681c90000 x24: ffff80002b007cdc 
> [  980.317722] x23: ffff800041a0004a x22: 0000000000000001 x21: 0000000000000001 
> [  980.324848] x20: 0000000000000000 x19: ffff800041a00049 x18: 0000000000000000 
> [  980.331974] x17: 2720636f6c6c616d x16: 76206d6f72662064 x15: 6574636574656420 
> [  980.339101] x14: 74706d6574746120 x13: 21293120657a6973 x12: ffff6106cbc4c03f 
> [  980.346227] x11: 1fffe106cbc4c03e x10: ffff6106cbc4c03e x9 : ffffdc5681f36e30 
> [  980.353353] x8 : ffff08365e2601f7 x7 : 0000000000000001 x6 : ffff6106cbc4c03e 
> [  980.360480] x5 : ffff08365e2601f0 x4 : 1fffe10044b11801 x3 : 0000000000000000 
> [  980.367606] x2 : 0000000000000000 x1 : ffff08022588c000 x0 : 000000000000005c 
> [  980.374733] Call trace: 
> [  980.377167]  usercopy_abort+0x78/0x7c 
> [  980.380819]  check_heap_object+0x3dc/0x3e0 
> [  980.384907]  __check_object_size.part.0+0x6c/0x1f0 
> [  980.389688]  __check_object_size+0x24/0x30 
> [  980.393774]  filldir64+0x548/0x84c 
> [  980.397165]  xfs_dir2_block_getdents+0x404/0x960 [xfs] 
> [  980.402437]  xfs_readdir+0x3c4/0x4b0 [xfs] 
> [  980.406652]  xfs_file_readdir+0x6c/0xa0 [xfs] 
> [  980.411127]  iterate_dir+0x3a4/0x500 
