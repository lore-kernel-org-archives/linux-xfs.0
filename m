Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 05:49:20 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6GCnHbm032658
	for <linux-xfs@oss.sgi.com>; Mon, 16 Jul 2007 05:49:18 -0700
Received: by wa-out-1112.google.com with SMTP id k22so1713814waf
        for <linux-xfs@oss.sgi.com>; Mon, 16 Jul 2007 05:49:19 -0700 (PDT)
Message-ID: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>
Date: Mon, 16 Jul 2007 15:42:28 +0300
From: Raz <raziebe@gmail.com>
Subject: raid50 and 9TB volumes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello
I found that using xfs over raid50, ( two raid5's 8 disks each and
raid 0 over them ) crashes the file system when the file system is ~
9TB. crashing is easy: we simply create few hundred of files, then
erase them in bulk. the same test passes in 6.4TB filesystems.
this bug happens in 2.6.22 as well as 2.6.17.7.
thank you .

4391322.839000] Filesystem "md3": XFS internal error
xfs_alloc_read_agf at line 2176 of file fs/xfs/xfs_alloc.c.  Caller
0xc10d31ea
[4391322.863000]  <c10d36e9> xfs_alloc_read_agf+0x199/0x220
<c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0
[4391322.882000]  <c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0
<c10d31ea> xfs_alloc_fix_freelist+0x41a/0x4b0
[4391322.901000]  <c1114294> xfs_iext_remove+0x64/0x90  <c10e1020>
xfs_bmap_add_extent_delay_real+0x12a0/0x16d0
[4391322.921000]  <c10d0fce> xfs_alloc_ag_vextent+0xae/0x140
<c10d3a77> xfs_alloc_vextent+0x307/0x5b0
[4391322.939000]  <c10e49fb> xfs_bmap_btalloc+0x41b/0x980  <c1114a46>
xfs_iext_bno_to_ext+0x126/0x1d0
[4391322.958000]  <c1049845> get_page_from_freelist+0x75/0xa0
<c10e9355> xfs_bmapi+0x1495/0x18d0
[4391322.975000]  <c1114a46> xfs_iext_bno_to_ext+0x126/0x1d0
<c10e698c> xfs_bmap_search_multi_extents+0xfc/0x110
[4391322.995000]  <c1117a07> xfs_iomap_write_allocate+0x327/0x620
<f8871195> release_stripe+0x35/0x60 [raid5]
[4391323.015000]  <c11164a0> xfs_iomap+0x440/0x570  <c113979b>
xfs_map_blocks+0x5b/0xa0
[4391323.031000]  <c113aa3a> xfs_page_state_convert+0x46a/0x7a0
<c1044d7b> find_get_pages_tag+0x7b/0x90
[4391323.049000]  <c113add9> xfs_vm_writepage+0x69/0x100  <c108df58>
mpage_writepages+0x218/0x3f0
[4391323.067000]  <c113ad70> xfs_vm_writepage+0x0/0x100  <c104b614>
do_writepages+0x54/0x60
[4391323.083000]  <c108be86> __sync_single_inode+0x66/0x1f0
<c108c098> __writeback_single_inode+0x88/0x1b0
[4391323.102000]  <c1017fd7> find_busiest_group+0x287/0x2f0
<c108c3a7> sync_sb_inodes+0x1e7/0x300
[4391323.120000]  <c104bef0> pdflush+0x0/0x50  <c108c595>
writeback_inodes+0xd5/0xf0
[4391323.135000]  <c104b3ac> wb_kupdate+0xbc/0x130  <c1085cc0>
mark_mounts_for_expiry+0x0/0x180
[4391323.152000]  <c104be0a> __pdflush+0xca/0x1b0  <c104bf2f> pdflush+0x3f/0x50
[4391323.166000]  <c104b2f0> wb_kupdate+0x0/0x130  <c10330f7> kthread+0xb7/0xc0
[4391323.181000]  <c1033040> kthread+0x0/0xc0  <c10011ed>
kernel_thread_helper+0x5/0x18


-- 
Raz
