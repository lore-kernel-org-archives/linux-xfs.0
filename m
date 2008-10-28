Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 08:40:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SFdup2007298
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 08:39:58 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 805E9149B07D
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 08:39:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id vFTmb7Oz2R8CPQSK for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 08:39:55 -0700 (PDT)
Date: Tue, 28 Oct 2008 16:39:53 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081028153953.GB3082@wotan.suse.de>
References: <20081028144715.683011000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028144715.683011000@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: akpm@linux-foundation.org, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 01:47:15AM +1100, npiggin@suse.de wrote:
> OK, I'm happier with this patchset now. Note that I've taken your patch
> and mangled it a bit at the end of the series.
> 
> This one survives and seems to run OK here, but I'm mainly doing dumb
> stress testing with a handful of filesystems, and data-io error injection
> testing. There are a lot of combinations of ways this function can operate
> and interact obviously, so it would be helpful to get more review.
> 
> Chris, would you possibly have time to run your btrfs tests that are
> sensitive to problems in this code? I could provide you a single patch
> rollup against mainline if it helps.

BTW. XFS seems to be doing something interesting with my simple sync
test case with IO error injection. I map a file MAP_SHARED into a number of
processes, which then each run a loop that dirties the memory then calls
msync(MS_SYNC) on the range.

ext2 mostly reports -EIO back to userspace when a failure is injected AFAIKS.
ext3 (ordered) doesn't until a lot of errors have been injected, but eventually
reports -EIO and shuts down the filesystem. reiserfs seems to report failure
more consistently.

I haven't seen any -EIO failures from XFS... maybe I'm just not doing the
right thing, or there is a caveat I'm not aware of.

All fault injections I noticed had a trace like this:
FAULT_INJECTION: forcing a failure
Call Trace:
9f9cd758:  [<6019f1de>] random32+0xe/0x20
9f9cd768:  [<601a31b9>] should_fail+0xd9/0x130
9f9cd798:  [<6018d0c4>] generic_make_request+0x304/0x4e0
9f9cd7a8:  [<60062301>] mempool_alloc+0x51/0x130
9f9cd858:  [<6018e6bf>] submit_bio+0x4f/0xe0
9f9cd8a8:  [<60165505>] xfs_submit_ioend_bio+0x25/0x40
9f9cd8c8:  [<6016603c>] xfs_submit_ioend+0xbc/0xf0
9f9cd908:  [<60166bf9>] xfs_page_state_convert+0x3d9/0x6a0
9f9cd928:  [<6005d515>] delayacct_end+0x95/0xb0
9f9cda08:  [<60166ffd>] xfs_vm_writepage+0x6d/0x110
9f9cda18:  [<6006618b>] set_page_dirty+0x4b/0xd0
9f9cda58:  [<60066115>] __writepage+0x15/0x40
9f9cda78:  [<60066775>] write_cache_pages+0x255/0x470
9f9cda90:  [<60066100>] __writepage+0x0/0x40
9f9cdb98:  [<600669b0>] generic_writepages+0x20/0x30
9f9cdba8:  [<60165ba3>] xfs_vm_writepages+0x53/0x70
9f9cdbd8:  [<600669eb>] do_writepages+0x2b/0x40
9f9cdbf8:  [<6006004c>] __filemap_fdatawrite_range+0x5c/0x70
9f9cdc58:  [<6006026a>] filemap_fdatawrite+0x1a/0x20
9f9cdc68:  [<600a7a05>] do_fsync+0x45/0xe0
9f9cdc98:  [<6007794b>] sys_msync+0x14b/0x1d0
9f9cdcf8:  [<60019a70>] handle_syscall+0x50/0x80
9f9cdd18:  [<6002a10f>] userspace+0x44f/0x510
9f9cdfc8:  [<60016792>] fork_handler+0x62/0x70

And the kernel would sometimes say this:
Buffer I/O error on device ram0, logical block 279
lost page write due to I/O error on ram0
Buffer I/O error on device ram0, logical block 379
lost page write due to I/O error on ram0
Buffer I/O error on device ram0, logical block 389
lost page write due to I/O error on ram0


I think I also saw a slab bug when running dbench with fault injection on.
Running latest Linus kernel.

bash-3.1# dbench -t10 -c ../client.txt 8
dbench version 3.04 - Copyright Andrew Tridgell 1999-2004

Running for 10 seconds with load '../client.txt' and minimum warmup 2 secs
8 clients started
FAULT_INJECTION: forcing a failure
Call Trace:
9e7bb548:  [<601623ae>] random32+0xe/0x20
9e7bb558:  [<60166389>] should_fail+0xd9/0x130
9e7bb588:  [<60150294>] generic_make_request+0x304/0x4e0
9e7bb598:  [<60062301>] mempool_alloc+0x51/0x130
9e7bb648:  [<6015188f>] submit_bio+0x4f/0xe0
9e7bb698:  [<6012b440>] _xfs_buf_ioapply+0x180/0x2a0
9e7bb6a0:  [<6002f600>] default_wake_function+0x0/0x10
9e7bb6f8:  [<6012bae1>] xfs_buf_iorequest+0x31/0x90
9e7bb718:  [<60112f75>] xlog_bdstrat_cb+0x45/0x50
9e7bb738:  [<60114135>] xlog_sync+0x195/0x440
9e7bb778:  [<60114491>] xlog_state_release_iclog+0xb1/0xc0
9e7bb7a8:  [<60114ca9>] xlog_write+0x539/0x550
9e7bb858:  [<60114e60>] xfs_log_write+0x40/0x60
9e7bb888:  [<6011fbaa>] _xfs_trans_commit+0x19a/0x360
9e7bb8b8:  [<600838e2>] poison_obj+0x42/0x60
9e7bb8d0:  [<60082cb3>] dbg_redzone1+0x13/0x30
9e7bb8e8:  [<60083999>] cache_alloc_debugcheck_after+0x99/0x1c0
9e7bb918:  [<6008517b>] kmem_cache_alloc+0x8b/0x100
9e7bb958:  [<60128084>] kmem_zone_alloc+0x74/0xe0
9e7bb998:  [<60082ad9>] kmem_cache_size+0x9/0x10
9e7bb9a8:  [<60128124>] kmem_zone_zalloc+0x34/0x50
9e7bb9e8:  [<60121e8b>] xfs_dir_ialloc+0x13b/0x2e0
9e7bba58:  [<601f534b>] __down_write+0xb/0x10
9e7bbaa8:  [<60125b9e>] xfs_mkdir+0x37e/0x4b0
9e7bbb38:  [<601f5589>] _spin_unlock+0x9/0x10
9e7bbb78:  [<601301a4>] xfs_vn_mknod+0xf4/0x1a0
9e7bbbd8:  [<6013025e>] xfs_vn_mkdir+0xe/0x10
9e7bbbe8:  [<60091010>] vfs_mkdir+0x90/0xc0
9e7bbc18:  [<600934d6>] sys_mkdirat+0x106/0x120
9e7bbc88:  [<6008629b>] filp_close+0x4b/0x80
9e7bbce8:  [<60093503>] sys_mkdir+0x13/0x20
9e7bbcf8:  [<60019a70>] handle_syscall+0x50/0x80
9e7bbd18:  [<6002a10f>] userspace+0x44f/0x510
9e7bbfc8:  [<60016792>] fork_handler+0x62/0x70

I/O error in filesystem ("ram0") meta-data dev ram0 block 0x8002c       ("xlog_i
odone") error 5 buf count 32768
xfs_force_shutdown(ram0,0x2) called from line 1056 of file /home/npiggin/usr/src
/linux-2.6/fs/xfs/xfs_log.c.  Return address = 0x000000006011370d
Filesystem "ram0": Log I/O Error Detected.  Shutting down filesystem: ram0
Please umount the filesystem, and rectify the problem(s)
xfs_force_shutdown(ram0,0x2) called from line 818 of file /home/npiggin/usr/src/
linux-2.6/fs/xfs/xfs_log.c.  Return address = 0x0000000060114e7d
slab error in verify_redzone_free(): cache `xfs_log_ticket': double free detecte
d
Call Trace:
9e7bb998:  [<6008372f>] __slab_error+0x1f/0x30
9e7bb9a8:  [<60083cae>] cache_free_debugcheck+0x1ee/0x240
9e7bb9b0:  [<60112ef0>] xlog_ticket_put+0x10/0x20
9e7bb9e8:  [<60083f70>] kmem_cache_free+0x50/0xc0
9e7bba18:  [<60112ef0>] xlog_ticket_put+0x10/0x20
9e7bba28:  [<60114dc9>] xfs_log_done+0x59/0xb0
9e7bba68:  [<6011f5de>] xfs_trans_cancel+0x7e/0x140
9e7bbaa8:  [<60125a1e>] xfs_mkdir+0x1fe/0x4b0
9e7bbb38:  [<601f5589>] _spin_unlock+0x9/0x10
9e7bbb78:  [<601301a4>] xfs_vn_mknod+0xf4/0x1a0
9e7bbbd8:  [<6013025e>] xfs_vn_mkdir+0xe/0x10
9e7bbbe8:  [<60091010>] vfs_mkdir+0x90/0xc0
9e7bbc18:  [<600934d6>] sys_mkdirat+0x106/0x120
9e7bbc88:  [<6008629b>] filp_close+0x4b/0x80
9e7bbce8:  [<60093503>] sys_mkdir+0x13/0x20
9e7bbcf8:  [<60019a70>] handle_syscall+0x50/0x80
9e7bbd18:  [<6002a10f>] userspace+0x44f/0x510
9e7bbfc8:  [<60016792>] fork_handler+0x62/0x70

000000009e0d4ec0: redzone 1:0x9f911029d74e35b, redzone 2:0x9f911029d74e35b.
(3) open ./clients/client1 failed for handle 16385 (No such file or directory)
(4) ERROR: handle 16385 was not found
Child failed with status 1

(kernel died soon afterwards)
