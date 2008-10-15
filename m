Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 18:22:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F1Mfnl000407
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:22:41 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A64544FCAE4
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:24:22 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 2XvR2teLsZpGtJpF for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:24:22 -0700 (PDT)
Date: Wed, 15 Oct 2008 12:18:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: crash with latest code drop.
Message-ID: <20081015011857.GS10716@disturbed>
References: <48F54C20.8060704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F54C20.8060704@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 15, 2008 at 11:49:20AM +1000, Peter Leckie wrote:
> Hi Dave and list, I hit the following crash with the latest code drop  
> that was pushed in yesterday
> while running test 177 in a loop, after 4-5 loops it crashed as follows:
> "<0>general protection fault: 0000 [1] SMP"
....
>
>
> [1]kdb> bt
> Stack traceback for pid 5425
> 0xffff88007b9b38d0     5425     5242  1    1   R  0xffff88007b9b3c38 *sync
> sp                ip                Function (args)
> 0xffff88006c45fde8 0xffffffff80320990 radix_tree_tagged+0xa  
> (0x6b6b6b6b6b6b6b73, 0x0)
> 0xffff88006c45fe10 0xffffffffa01f36c6 [xfs]xfs_sync_inodes_ag+0x197  
> (0xffff88007d4025c8, invalid, invalid)
> 0xffff88006c45fe80 0xffffffffa01f38d1 [xfs]xfs_sync_inodes+0x63  
> (0xffff88007d4025c8, invalid)
> 0xffff88006c45fec0 0xffffffffa01f3997 [xfs]xfs_quiesce_data+0x13  
> (0xffff88007d4025c8)
> 0xffff88006c45fee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b  
> (0xffff88007d9f10b8)
> 0xffff88006c45ff40 0xffffffff80292fd2 sync_filesystems+0xae (invalid)
> 0xffff88006c45ff60 0xffffffff802af48b do_sync+0x2f (0x1)
> 0xffff88006c45ff70 0xffffffff802af4c4 sys_sync+0xe
> bb_special_case: Invalid bb_reg_state.memory, missing trailing entries
> bb_special_case: on transfer to int_with_check
>  Assuming system_call_fastpath is 'pass through' with 6 register parameters
> kdb_bb: 0xffffffff8020be0b [kernel]system_call_fastpath failed at  
> 0xffffffff8020be98
>
> Using old style backtrace, unreliable with no arguments
> sp                ip                Function (args)
> 0xffff88006c45fdb0 0xffffffffa01f369a [xfs]xfs_sync_inodes_ag+0x16b
> 0xffff88006c45fde8 0xffffffff80320990 radix_tree_tagged+0xa
> 0xffff88006c45fe10 0xffffffffa01f36c6 [xfs]xfs_sync_inodes_ag+0x197
> 0xffff88006c45fe80 0xffffffffa01f38d1 [xfs]xfs_sync_inodes+0x63
> 0xffff88006c45fec0 0xffffffffa01f3997 [xfs]xfs_quiesce_data+0x13
> 0xffff88006c45fec8 0xffffffff802452b9 autoremove_wake_function
> 0xffff88006c45fee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b
> 0xffff88006c45ff00 0xffffffff8043b871 __down_read+0x12
> 0xffff88006c45ff10 0xffffffffa024d395 [ext3]ext3_sync_fs+0x46
> 0xffff88006c45ff40 0xffffffff80292fd2 sync_filesystems+0xae
> 0xffff88006c45ff60 0xffffffff802af48b do_sync+0x2f
> 0xffff88006c45ff70 0xffffffff802af4c4 sys_sync+0xe
>
>
> [1]kdb> rd
>     r15 = 0x0000000000000002      r14 = 0x0000000000000000
>     r13 = 0x000000000000000a      r12 = 0x0000000000000040
>      bp = 0xffff88003793a9d8       bx = 0xffff880055c10250
>     r11 = 0x0000000000000001      r10 = 0xffff880055d0ade8
>      r9 = 0x000000000002309f       r8 = 0xffffffffa01f369a
>      ax = 0x0000000000200000       cx = 0x0000000000000015
>      dx = 0x0000000000000000       si = 0x0000000000000000
>      di = 0x6b6b6b6b6b6b6b73  orig_ax = 0xffffffffffffffff
>      ip = 0xffffffff80320990       cs = 0x0000000000000010
>   flags = 0x0000000000010206       sp = 0xffff88006c45fe00
>      ss = 0x0000000000000018 &regs = 0xffff88006c45fd68
>
>
> [1]kdb> id %ip
> 0xffffffff80320990 radix_tree_tagged+0xa:     and    0x4(%rdi),%eax
> 0xffffffff80320993 radix_tree_tagged+0xd:     retq
> 0xffffffff80320994 radix_tree_callback:         cmp    $0x7,%rsi
> 0xffffffff80320998 radix_tree_callback+0x4:     push   %rbx
> 0xffffffff80320999 radix_tree_callback+0x5:     je      
> 0xffffffff803209a1 radix_tree_callback+0xd
> 0xffffffff8032099b radix_tree_callback+0x7:     cmp    $0x17,%rsi
> 0xffffffff8032099f radix_tree_callback+0xb:     jne     
> 0xffffffff803209e1 radix_tree_callback+0x4d
> 0xffffffff803209a1 radix_tree_callback+0xd:     movslq %edx,%rax
> 0xffffffff803209a4 radix_tree_callback+0x10:    mov     
> 3961501(%rip),%rdx             # 0xffffffff806e7c48 _cpu_pda
> 0xffffffff803209ab radix_tree_callback+0x17:    mov     
> $0xffffffff80796480,%rbx
> 0xffffffff803209b2 radix_tree_callback+0x1e:    mov    (%rdx,%rax,8),%rax
> 0xffffffff803209b6 radix_tree_callback+0x22:    add    0x8(%rax),%rbx
> 0xffffffff803209ba radix_tree_callback+0x26:    jmp     
> 0xffffffff803209db radix_tree_callback+0x47
> 0xffffffff803209bc radix_tree_callback+0x28:    cltq
> 0xffffffff803209be radix_tree_callback+0x2a:    mov     
> 5545627(%rip),%rdi             # 0xffffffff8086a860 __key.8127
> 0xffffffff803209c5 radix_tree_callback+0x31:    mov    (%rbx,%rax,8),%rsi
>
>
>
> The back trace is a little busted xfs_sync_inodes_ag appears to be calling:
> xfs_sync_inodes_ag->xfs_flush_pages->mapping_tagged->radix_tree_tagged()

I think you'll find it's VN_DIRTY() here:

158                 /*
159                  * If we have to flush data or wait for I/O completion
160                  * we need to drop the ilock that we currently hold.
161                  * If we need to drop the lock, insert a marker if we
162                  * have not already done so.
163                  */
164                 if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
165                         xfs_iunlock(ip, XFS_ILOCK_SHARED);
166                         error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
167                         if (flags & SYNC_IOWAIT)
168                                 vn_iowait(ip);
169                         xfs_ilock(ip, XFS_ILOCK_SHARED);
170                 }

As:

#define VN_DIRTY(vp)    mapping_tagged(vp->i_mapping, \
                                        PAGECACHE_TAG_DIRTY)

Seems like we have a possible race with reclaim - we've found the
dirty inode in the radix tree, then checked the reclaim state, then
locked the inode, then tried to access the linux inode which is now
now longer present.

Can you confirm that the xfs_inode has either the I_RECLAIM or
I_RECLAIMABLE flag set on it when the panic occurred? If this
is the case, then the patch below will probably fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: avoid all reclaimable inodes in xfs_sync_inodes_ag

If we are syncing data in xfs_sync_inodes_ag(), the VFS
inode must still be referencable as the dirty data state
is carried on the VFS inode. hence if we can't get a
reference via igrab(), the inode must be in reclaim which
implies that it has no dirty data attached.

Leave such inodes to the reclaim code to flush the dirty
inode state to disk and so avoid attempting to access the
VFS inode when it may not exist in xfs_sync_inodes_ag().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 08b2acf..85495df 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -80,7 +80,6 @@ xfs_sync_inodes_ag(
 
 	do {
 		struct inode	*inode;
-		boolean_t	inode_refed;
 		xfs_inode_t	*ip = NULL;
 
 		/*
@@ -133,26 +132,15 @@ xfs_sync_inodes_ag(
 
 		/*
 		 * If we can't get a reference on the VFS_I, the inode must be
-		 * in reclaim. If we can get the inode lock without blocking,
-		 * it is safe to flush the inode because we hold the tree lock
-		 * and xfs_iextract will block right now. Hence if we lock the
-		 * inode while holding the tree lock, xfs_ireclaim() is
-		 * guaranteed to block on the inode lock we now hold and hence
-		 * it is safe to reference the inode until we drop the inode
-		 * locks completely.
+		 * in reclaim. Leave it for the reclaim code to flush.
 		 */
-		inode_refed = B_FALSE;
 		if (igrab(inode)) {
 			read_unlock(&pag->pag_ici_lock);
 			xfs_ilock(ip, lock_flags);
-			inode_refed = B_TRUE;
 		} else {
-			if (!xfs_ilock_nowait(ip, lock_flags)) {
-				/* leave it to reclaim */
-				read_unlock(&pag->pag_ici_lock);
-				continue;
-			}
+			/* leave it to reclaim */
 			read_unlock(&pag->pag_ici_lock);
+			continue;
 		}
 
 		/*
@@ -186,10 +174,7 @@ xfs_sync_inodes_ag(
 
 		if (lock_flags)
 			xfs_iunlock(ip, lock_flags);
-
-		if (inode_refed) {
-			IRELE(ip);
-		}
+		IRELE(ip);
 
 		if (error)
 			last_error = error;
