Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EDFC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 01:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiADBTE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jan 2022 20:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiADBTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jan 2022 20:19:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2A5C061761
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jan 2022 17:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22782B80259
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 01:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF165C36AEB;
        Tue,  4 Jan 2022 01:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641259140;
        bh=ZNx+EeamJzz6klXe7QpxQLM/s2aGYWPyu5zLzeVgGME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j2YxGifjM9DadQrh7RyAGpOCsSLBWhKjblSe89+1V/HCP1fpBb5p+02QFofhtTjiZ
         nPucs4YmN+5GZcHO1Jf18o0XJfaZcr6XjQuz4iCRIUD88i7jAH07pMWjE1r7GyXkWT
         9AqjOfkRVZevYzKeEQHR//OYwyPT6ltwxr92idLyt4GEgtB5YYEbwPb+ozvJ+qOyg4
         meLmVgVMrOqACap4jmGU1mKZcqWnSMgj8wvM3FAnOVT6gd1K6OlFSX1RrXMhQC4io+
         KukcshovMt23QXIf1WvREQYYYk7me9O9+jZDe+Moajc1NpVWKdDLCcdk4OT08nTJqJ
         BIa42gWJGlzvQ==
Date:   Mon, 3 Jan 2022 17:19:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH 1/7] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220104011900.GB31583@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961696098.3129691.10143704907338536631.stgit@magnolia>
 <20211216045609.GY449541@dread.disaster.area>
 <20211217185933.GJ27664@magnolia>
 <20211221010855.GW27664@magnolia>
 <20211221051004.GC945095@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221051004.GC945095@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 21, 2021 at 04:10:04PM +1100, Dave Chinner wrote:
> On Mon, Dec 20, 2021 at 05:08:55PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 17, 2021 at 10:59:33AM -0800, Darrick J. Wong wrote:
> > > On Thu, Dec 16, 2021 at 03:56:09PM +1100, Dave Chinner wrote:
> > > > On Wed, Dec 15, 2021 at 05:09:21PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > I was poking around in the directory code while diagnosing online fsck
> > > > > bugs, and noticed that xfs_readdir doesn't actually take the directory
> > > > > ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
> > > > > the data fork mappings
> > > > 
> > > > Yup, that is pretty much guaranteed. If the inode is extent or btree form as the
> > > > extent count will be non-zero, hence we can only get to the
> > > > xfs_dir2_isblock() check if the inode has moved from local to block
> > > > form between the open and xfs_dir2_isblock() get in the getdents
> > > > code.
> > > > 
> > > > > and the VFS took i_rwsem (aka IOLOCK_SHARED) so
> > > > > we're protected against writer threads, but we really need to follow the
> > > > > locking model like we do in other places.  The same applies to the
> > > > > shortform getdents function.
> > > > 
> > > > Locking rules should be the same as xfs_dir_lookup().....
> ....
> > > > Yup, I know, VFS holds i_rwsem, so directory can't be modified while
> > > > xfs_readdir() is running, but if you are going to make one of these
> > > > functions have to take the ILOCK, then they all need to. See
> > > > xfs_dir_lookup()....
> > > 
> > > Hmm.  I thought (and Chandan asked in passing) that the reason that we
> > > keep cycling the directory ILOCK in the block/leaf getdents functions is
> > > because the VFS ->actor functions (aka filldir) directly copy dirents to
> > > userspace and we could trigger a page fault.  The page fault could
> > > trigger memory reclaim, which could in turn route us to writeback with
> > > that ILOCK still held.
> > > 
> > > Though, thinking about this further, the directory we have ILOCKed
> > > doesn't itself use the page cache, so writeback will never touch it.
> > > So I /think/ it's ok to grab the xfs_ilock_data_map_shared once in
> > > xfs_readdir and hold it all the way to the end of the function?
> > > 
> > > Or at least I tried it and lockdep didn't complain immediately... :P
> > 
> > But lockdep does complain now:
> > 
> >  ======================================================
> >  WARNING: possible circular locking dependency detected
> >  5.16.0-rc6-xfsx #rc6 Not tainted
> >  ------------------------------------------------------
> >  xfs_scrub/8151 is trying to acquire lock:
> >  ffff888040abcbe8 (&mm->mmap_lock#2){++++}-{4:4}, at: do_user_addr_fault+0x386/0x600
> >  
> >  but task is already holding lock:
> >  ffff8880270b87e8 (&xfs_dir_ilock_class){++++}-{4:4}, at: xfs_ilock_data_map_shared+0x2a/0x30 [xfs]
> >  
> >  which lock already depends on the new lock.
> >  
> >  
> >  the existing dependency chain (in reverse order) is:
> >  
> >  -> #2 (&xfs_dir_ilock_class){++++}-{4:4}:
> >         down_write_nested+0x41/0x80
> >         xfs_ilock+0xc9/0x270 [xfs]
> >         xfs_rename+0x559/0xb80 [xfs]
> >         xfs_vn_rename+0xdb/0x150 [xfs]
> >         vfs_rename+0x775/0xa70
> >         do_renameat2+0x355/0x510
> >         __x64_sys_renameat2+0x4b/0x60
> >         do_syscall_64+0x35/0x80
> >         entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  
> >  -> #1 (sb_internal){.+.+}-{0:0}:
> >         xfs_trans_alloc+0x1a8/0x3e0 [xfs]
> >         xfs_vn_update_time+0xca/0x2a0 [xfs]
> >         touch_atime+0x17d/0x2b0
> >         xfs_file_mmap+0xa7/0xb0 [xfs]
> >         mmap_region+0x3d8/0x600
> >         do_mmap+0x337/0x4f0
> >         vm_mmap_pgoff+0xa6/0x150
> >         ksys_mmap_pgoff+0x16f/0x1c0
> >         do_syscall_64+0x35/0x80
> >         entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> IDGI. That's a mmap() syscall, not a page fault. You can't mmap() a
> directory inode, so this has to be a regular file inode...
> 
> >  -> #0 (&mm->mmap_lock#2){++++}-{4:4}:
> >         __lock_acquire+0x116a/0x1eb0
> >         lock_acquire+0xc9/0x2f0
> >         down_read+0x3e/0x50
> >         do_user_addr_fault+0x386/0x600
> >         exc_page_fault+0x65/0x250
> >         asm_exc_page_fault+0x1b/0x20
> >         filldir64+0xb5/0x1b0
> >         xfs_dir2_sf_getdents+0x14e/0x370 [xfs]
> >         xfs_readdir+0x1fd/0x2b0 [xfs]
> >         iterate_dir+0x142/0x190
> >         __x64_sys_getdents64+0x7a/0x130
> >         do_syscall_64+0x35/0x80
> >         entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  
> >  other info that might help us debug this:
> >  
> >  Chain exists of:
> >    &mm->mmap_lock#2 --> sb_internal --> &xfs_dir_ilock_class
> >  
> >   Possible unsafe locking scenario:
> >  
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(&xfs_dir_ilock_class);
> >                                 lock(sb_internal);
> >                                 lock(&xfs_dir_ilock_class);
> >    lock(&mm->mmap_lock#2);
> >  
> >   *** DEADLOCK ***
> >  
> >  3 locks held by xfs_scrub/8151:
> >   #0: ffff88800a8aeaf0 (&f->f_pos_lock){+.+.}-{4:4}, at: __fdget_pos+0x4a/0x60
> >   #1: ffff8880270b8a08 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{4:4}, at: iterate_dir+0x3d/0x190
> >   #2: ffff8880270b87e8 (&xfs_dir_ilock_class){++++}-{4:4}, at: xfs_ilock_data_map_shared+0x2a/0x30 [xfs]
> >  
> >  stack backtrace:
> >  CPU: 0 PID: 8151 Comm: xfs_scrub Not tainted 5.16.0-rc6-xfsx #rc6 574205e0343df89e2059bf7ee73cf2f2ec847f12
> >  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x45/0x59
> >   check_noncircular+0xf2/0x110
> >   __lock_acquire+0x116a/0x1eb0
> >   lock_acquire+0xc9/0x2f0
> >   ? do_user_addr_fault+0x386/0x600
> >   down_read+0x3e/0x50
> >   ? do_user_addr_fault+0x386/0x600
> >   do_user_addr_fault+0x386/0x600
> >   exc_page_fault+0x65/0x250
> >   asm_exc_page_fault+0x1b/0x20
> >  RIP: 0010:filldir64+0xb5/0x1b0
> >  Code: 01 c0 48 29 ca 48 98 48 01 d0 0f 82 9f 00 00 00 48 b9 00 f0 ff ff ff 7f 00 00 48 39 c8 0f 87 8c 00 00 00 0f ae e8 4c 89 6a 08 <4c> 89 36 66 44 89 46 10 44 88 7e 12 48 8d 46 13 48 63 d5 c6 44 16
> >  RSP: 0018:ffffc900041ebd38 EFLAGS: 00010283
> >  RAX: 00007f729c004020 RBX: ffff88804616a96b RCX: 00007ffffffff000
> >  RDX: 00007f729c003fe0 RSI: 00007f729c004000 RDI: ffff88804616a970
> >  RBP: 0000000000000005 R08: 0000000000000020 R09: 0000000000000000
> >  R10: 0000000000000002 R11: ffff88804616a96b R12: ffffc900041ebee0
> >  R13: 0000000000000022 R14: 0000000003009b6b R15: 0000000000000002
> >   ? filldir64+0x3b/0x1b0
> >   xfs_dir2_sf_getdents+0x14e/0x370 [xfs 802a19c6d5ac0a8a2cd22c73d30f7cd9e92f7194]
> >   xfs_readdir+0x1fd/0x2b0 [xfs 802a19c6d5ac0a8a2cd22c73d30f7cd9e92f7194]
> >   iterate_dir+0x142/0x190
> >   __x64_sys_getdents64+0x7a/0x130
> >   ? fillonedir+0x160/0x160
> >   do_syscall_64+0x35/0x80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  RIP: 0033:0x7f72ab7d543b
> >  Code: 0f 1e fa 48 8b 47 20 c3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 81 fa ff ff ff 7f b8 ff ff ff 7f 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 21 9a 10 00 f7 d8
> >  RSP: 002b:00007f72a88d6a58 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
> >  RAX: ffffffffffffffda RBX: 00007f729c003f00 RCX: 00007f72ab7d543b
> >  RDX: 0000000000008000 RSI: 00007f729c003f00 RDI: 0000000000000006
> >  RBP: fffffffffffffe00 R08: 0000000000000030 R09: 00007f729c000780
> >  R10: 00007f729c003c40 R11: 0000000000000293 R12: 00007f729c003ed4
> >  R13: 0000000000000000 R14: 00007f729c003ed0 R15: 00007f72a0003e10
> >   </TASK>
> > 
> > IOWs, we have to drop the ILOCK when calling dir_emit because:
> > 
> > 1. Rename takes sb_internal (xfs_trans_alloc) and then a directory ILOCK;
> > 2. A pagefault can take the MMAPLOCK and then sb_internal to update the
> >    file mtime;
> 
> Ok, let's assume that the lockdep report is actually a page fault
> rather than a completely independent mmap() syscall.
> 
> A page fault on a mmap()d data buffer that won't get this far - if
> there is a freeze in progress it will get stuck on on SB_PAGEFAULT
> in __xfs_filemap_fault() before it updates the mtime.
> 
> Hence, AFAICT, if we have an inode stuck there waiting for a freeze
> to make progress in a page fault, it means the readdir holds the
> directory i_rwsem (IOLOCK) in read mode,
> 
> If this is the case, then the rename() syscall cannot get past
> vfs_rename->lock_rename() as that will block trying to get the
> directory i_rwsem in write mode that the readdir already holds.
> 
> ANd if we have the opposite, where we are in xfs_rename() waiting
> for XFS_ILOCK_EXCL on the directory inodes, it means that the VFS is
> holding the i_rwsem in write mode on the directory and hence readdir
> gets locked out.
> 
> i.e. the vfs level i_rwsem locking prevents xfs_readdir() and
> xfs_rename() being called on the same directory are the same time
> and so the nested page fault recursion scenario indicated here does
> not seem possible.

Hmm, I think I agree that we can't have sb_internal->dir_ilock at the
same time as dir_ilock->mmap_lock->sb_internal because the first will
want IOLOCK_EXCL and the second will want IOLOCK_SHARED.  IOWs, I agree
that it's a false positive, and I couldn't find anywhere in the VFS that
allows mixed read and write access to a directory.  The directory mod
operations (link/unlink/create/rename) all seem to inode_lock(), as does
setattr and the xattr functions.  The only code paths that I could find
that use inode_lock_shared are readdir and certain lookups.

(Why didn't lockdep show i_rwsem as part of this chain?)

However, I also think this breaks my mental model of lock acquisition
order in XFS.

The chain, as presented, is this:

> >    &mm->mmap_lock#2 --> sb_internal --> &xfs_dir_ilock_class

But let me rearrange that to cover what I think can happen in the
readdir case with this patch applied:

IOLOCK_SHARED         // directory
ILOCK_SHARED          // also directory

mmap_lock             // file
sb_pagefault          // __xfs_filemap_fault
MMAPLOCK_SHARED       // file
sb_intwrite           // xfs_iomap_write_direct
ILOCK_EXCL            // file

Up until now, I've always written code to acquire resources in the order
IOLOCK -> MMAPLOCK -> transaction -> ILOCK, and I think everyone else
has done that too.  Allowing this new readdir behavior is awkward
because now there /is/ a place where we can try to allocate a
transaction while holding an ILOCK.

Call me a bureaucrat, but I'd rather keep the bright line rule that we
don't take sb_internal with an ILOCK held than deal with more locking
model nuance. :)

--D

> > 3. Now we've made readdir take the directory ILOCK and do something that
> >    can cause a userspace pagefault.
> 
> Yup, and while that fault on the regular file is being handled,
> the rename cannot get past the VFS because of the the directory
> IOLOCK/i_rwsem is held...
> 
> > So with that in mind, can I get a re-review of the original patch?  I'll
> > add the above to the commit message as a justification for why we can't
> > just move the ilock/iunlock calls.
> 
> On the above, I think it's a false positive. Can you go through the
> analysis again and check that I haven't missed a case where the VFS
> allows concurrent read and write access to a single directory?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
