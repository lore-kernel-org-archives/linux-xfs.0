Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B815C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 10:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiEXKwW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 06:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbiEXKwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 06:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5E4793AE
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F02EB8185F
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A98AC341CC
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653389534;
        bh=nifCsaBRSkoSxjnMWkBZ9xjg8hijoPtxY4hXfMDDJ4g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Ab2kdFOw8QwLlti4o2mXk0SEtWxwhlaU35bbAa7iNj57jKyeNH29RsSfRSG4LpZWS
         RjY0/sriQxLuaZbj6ktzX96pzjh5M5RnGT978+eaHFhMk7UupsMLvUIQa/Cdjhm7B+
         m6fHfDyapB7x6AS1NSjUwj+auhzMgNxN6aoHeekpNtYXig9QnJaoFNf7hX3GnAW18s
         XUg5IOE+C0eZWRfzUq7wCoeKig96Yj/mtzMFyYBdr78LiGVLt1X8uKojxhDB6B1mhs
         DiHYbceYcvWglssVz7wqhIFHChwD8fDMm3zDuJ/bXw+VNGYSNneLjBZuA6lt9sPxvT
         nEggMdUkbosIg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 07254CC13B4; Tue, 24 May 2022 10:52:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 10:52:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzkernelorg8392@araxon.sk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-CUO8demllI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #13 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
(In reply to Dave Chinner from comment #5)
> Doesn't tell us a whole lot except for "no free memory to allocate
> without reclaim". /proc/meminfo, /proc/vmstat and /proc/slabinfo
> would tell us a lot more.

Notice: all values in this comment are from the kernel version 5.13.0-rc2+,
commit c9fa563072e1, recorded at the time of the endless iowait

> /proc/meminfo

MemTotal:        3996092 kB
MemFree:           42176 kB
MemAvailable:    3668964 kB
Buffers:           15684 kB
Cached:          3400932 kB
SwapCached:            0 kB
Active:            58840 kB
Inactive:        3405468 kB
Active(anon):        268 kB
Inactive(anon):    47836 kB
Active(file):      58572 kB
Inactive(file):  3357632 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2097084 kB
SwapFree:        2097084 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:         47700 kB
Mapped:            19504 kB
Shmem:               412 kB
KReclaimable:     266460 kB
Slab:             404388 kB
SReclaimable:     266460 kB
SUnreclaim:       137928 kB
KernelStack:        1904 kB
PageTables:         1672 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4095128 kB
Committed_AS:     117700 kB
VmallocTotal:   34359738367 kB
VmallocUsed:        2732 kB
VmallocChunk:          0 kB
Percpu:              896 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:       20364 kB
DirectMap2M:     4139008 kB

> /proc/vmstat

nr_free_pages 10607
nr_zone_inactive_anon 11978
nr_zone_active_anon 67
nr_zone_inactive_file 839409
nr_zone_active_file 14643
nr_zone_unevictable 0
nr_zone_write_pending 0
nr_mlock 0
nr_bounce 0
nr_free_cma 0
nr_inactive_anon 11978
nr_active_anon 67
nr_inactive_file 839409
nr_active_file 14643
nr_unevictable 0
nr_slab_reclaimable 66615
nr_slab_unreclaimable 34482
nr_isolated_anon 0
nr_isolated_file 0
workingset_nodes 130210
workingset_refault_anon 0
workingset_refault_file 1345
workingset_activate_anon 0
workingset_activate_file 24
workingset_restore_anon 0
workingset_restore_file 0
workingset_nodereclaim 208053
nr_anon_pages 11931
nr_mapped 4876
nr_file_pages 854155
nr_dirty 0
nr_writeback 0
nr_writeback_temp 0
nr_shmem 103
nr_shmem_hugepages 0
nr_shmem_pmdmapped 0
nr_file_hugepages 0
nr_file_pmdmapped 0
nr_anon_transparent_hugepages 0
nr_vmscan_write 0
nr_vmscan_immediate_reclaim 8243
nr_dirtied 9075788
nr_written 9075787
nr_kernel_misc_reclaimable 0
nr_foll_pin_acquired 0
nr_foll_pin_released 0
nr_kernel_stack 1904
nr_page_table_pages 418
nr_swapcached 0
nr_dirty_threshold 171292
nr_dirty_background_threshold 85541
pgpgin 36279336
pgpgout 36908703
pswpin 0
pswpout 0
pgalloc_dma 1473
pgalloc_dma32 18299092
pgalloc_normal 325690
pgalloc_movable 0
allocstall_dma 0
allocstall_dma32 0
allocstall_normal 0
allocstall_movable 5
pgskip_dma 0
pgskip_dma32 0
pgskip_normal 35
pgskip_movable 0
pgfree 18637453
pgactivate 20445
pgdeactivate 266
pglazyfree 0
pgfault 397160
pgmajfault 585
pglazyfreed 0
pgrefill 34
pgreuse 87282
pgsteal_kswapd 17283321
pgsteal_direct 1048
pgscan_kswapd 17292764
pgscan_direct 1048
pgscan_direct_throttle 0
pgscan_anon 13
pgscan_file 17293799
pgsteal_anon 0
pgsteal_file 17284369
pginodesteal 0
slabs_scanned 212096
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 11222
kswapd_high_wmark_hit_quickly 48
pageoutrun 11290
pgrotated 8478
drop_pagecache 0
drop_slab 0
oom_kill 0
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 0
unevictable_pgs_scanned 0
unevictable_pgs_rescued 0
unevictable_pgs_mlocked 0
unevictable_pgs_munlocked 0
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
swap_ra 0
swap_ra_hit 0
direct_map_level2_splits 1
direct_map_level3_splits 0
nr_unstable 0

> /proc/slabinfo

too big, I will upload it as an attachment

> Also, knowing if you've tweaked things like dirty ratios, etc would
> also be helpful...

I didn't tweak any sysctl value, but I can't say if the defaults in Gentoo =
are
the same as in other linux flavors

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
