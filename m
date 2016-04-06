Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B59CD7CB3
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 11:39:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16D60AC003
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 09:39:29 -0700 (PDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id Ck5oe1YhQQmqBjkY
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 09:39:26 -0700 (PDT)
Received: by mail-wm0-f44.google.com with SMTP id l6so73093819wml.1
	for <xfs@oss.sgi.com>; Wed, 06 Apr 2016 09:39:26 -0700 (PDT)
Message-ID: <A01B206564694781A7BE74415E4C6D1E@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
	<20150707000911.GT7943@dastard>
	<20150707090511.GA21863@infradead.org>
	<7792DA2A464640B1BC7220973CED41AE@alyakaslap>
	<20150723230912.GE3902@dastard>
	<77693FFEB62A474DA7F039FD92CC5304@alyakaslap>
	<20160405204106.GF11238@dastard>
In-Reply-To: <20160405204106.GF11238@dastard>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Date: Wed, 6 Apr 2016 19:39:21 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

Hello Dave,

Thank you for your response. We understand your concerns and will do further 
testing with the vmalloc alternative.

Meanwhile, I found another issue happening when files have many extents. 
When unmounting XFS, we call
xfs_inode_free => xfs_idestroy_fork => xfs_iext_destroy
This goes over the whole indirection array and calls xfs_iext_irec_remove 
for each one of the erps (from the last one to the first one). As a result, 
we keep shrinking (reallocating actually) the indirection array until we 
shrink out all of its elements. When we have files with huge numbers of 
extents, umount takes 30-80 sec, depending on the amount of files that XFS 
loaded and the amount of indirection entries of each file. The unmount stack 
looks like [1].

That patch in [2] seems to address the issue. Do you think it is reasonable? 
It was tested only on kernel 3.18.19.

Thanks,
Alex.

[1]
[<ffffffffc0b6d200>] xfs_iext_realloc_indirect+0x40/0x60 [xfs]
[<ffffffffc0b6cd8e>] xfs_iext_irec_remove+0xee/0xf0 [xfs]
[<ffffffffc0b6cdcd>] xfs_iext_destroy+0x3d/0xb0 [xfs]
[<ffffffffc0b6cef6>] xfs_idestroy_fork+0xb6/0xf0 [xfs]
[<ffffffffc0b87002>] xfs_inode_free+0xb2/0xc0 [xfs]
[<ffffffffc0b87260>] xfs_reclaim_inode+0x250/0x340 [xfs]
[<ffffffffc0b87583>] xfs_reclaim_inodes_ag+0x233/0x370 [xfs]
[<ffffffffc0b8823d>] xfs_reclaim_inodes+0x1d/0x20 [xfs]
[<ffffffffc0b96feb>] xfs_unmountfs+0x7b/0x1a0 [xfs]
[<ffffffffc0b98e4d>] xfs_fs_put_super+0x2d/0x70 [xfs]
[<ffffffff811e9e36>] generic_shutdown_super+0x76/0x100
[<ffffffff811ea207>] kill_block_super+0x27/0x70
[<ffffffff811ea519>] deactivate_locked_super+0x49/0x60
[<ffffffff811eaaee>] deactivate_super+0x4e/0x70
[<ffffffff81207593>] cleanup_mnt+0x43/0x90
[<ffffffff81207632>] __cleanup_mnt+0x12/0x20
[<ffffffff8108f8e7>] task_work_run+0xa7/0xe0
[<ffffffff81014ff7>] do_notify_resume+0x97/0xb0
[<ffffffff81717c6f>] int_signal+0x12/0x17

[2]
--- /mnt/work/alex/tmp/code/prev_xfs2/fs/xfs/libxfs/xfs_inode_fork.c 
2016-04-06 16:35:51.172255372 +0300
+++ fs/xfs/libxfs/xfs_inode_fork.c      2016-04-06 19:25:55.349593353 +0300
@@ -1499,34 +1499,48 @@
        kmem_free(ifp->if_u1.if_ext_irec);
        ifp->if_flags &= ~XFS_IFEXTIREC;
        ifp->if_u1.if_extents = ep;
        ifp->if_bytes = size;
        if (nextents < XFS_LINEAR_EXTS) {
                xfs_iext_realloc_direct(ifp, size);
        }
}

/*
+ * Remove all records from the indirection array.
+ */
+STATIC void
+xfs_iext_irec_remove_all(xfs_ifork_t *ifp)             /* inode fork 
pointer */
+{
+       int             nlists;         /* number of irec's (ex lists) */
+       int             i;              /* loop counter */
+
+       ASSERT(ifp->if_flags & XFS_IFEXTIREC);
+       nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+       for (i = 0; i < nlists; i++) {
+               xfs_ext_irec_t *erp = &ifp->if_u1.if_ext_irec[i];
+               if (erp->er_extbuf)
+                       kmem_free(erp->er_extbuf);
+       }
+       kmem_free(ifp->if_u1.if_ext_irec);
+       ifp->if_real_bytes = 0;
+}
+
+/*
  * Free incore file extents.
  */
void
xfs_iext_destroy(
        xfs_ifork_t     *ifp)           /* inode fork pointer */
{
        if (ifp->if_flags & XFS_IFEXTIREC) {
-               int     erp_idx;
-               int     nlists;
-
-               nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-               for (erp_idx = nlists - 1; erp_idx >= 0 ; erp_idx--) {
-                       xfs_iext_irec_remove(ifp, erp_idx);
-               }
+               xfs_iext_irec_remove_all(ifp);
                ifp->if_flags &= ~XFS_IFEXTIREC;
        } else if (ifp->if_real_bytes) {
                kmem_free(ifp->if_u1.if_extents);
        } else if (ifp->if_bytes) {
                memset(ifp->if_u2.if_inline_ext, 0, XFS_INLINE_EXTS *
                        sizeof(xfs_bmbt_rec_t));
        }
        ifp->if_u1.if_extents = NULL;
        ifp->if_real_bytes = 0;
        ifp->if_bytes = 0;


-----Original Message----- 
From: Dave Chinner
Sent: Tuesday, April 05, 2016 11:41 PM
To: Alex Lyakas
Cc: Christoph Hellwig ; Danny Shavit ; bfoster@redhat.com ; Yair Hershko ; 
Shyam Kaushik ; xfs@oss.sgi.com
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation 
deadlock"

On Tue, Apr 05, 2016 at 09:10:06PM +0300, Alex Lyakas wrote:
> Hello Dave, Brian, Christoph,
>
> We are still encountering cases, in which different IO patterns beat
> XFS preallocation schemes, resuling in highly fragmented files,
> having 100s of thousands and sometimes millions of extents. In these
> cases XFS tries to allocate large arrays of xfs_ext_irec_t structure
> with kmalloc, and this often gets into numerous retries, and
> sometimes triggers hung task panic (due to some other thread wanting
> to access the same file).
>
> We made a change to call kmem_zalloc_large, which resorts to
> __vmalloc in case kmalloc fails. kmem_free is already handling
> vmalloc addresses correctly. The change is only for the allocation
> done in xfs_iext_realloc_indirect, as this is the only place, in
> which we have seen the issue.

As I've said before, vmalloc is not a solution we can use in
general.  32 bit systems have less vmalloc area than normal kernel
memory (e.g. ia32 has 128MB of vmalloc space vs 896MB of kernel
address space by default) and hence if we get large vmap allocation
requests for non-temporary, not directly reclaimable memory then
we'll end up with worse problems than we already have due to vmalloc
area exhaustion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
