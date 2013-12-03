Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA3067F50
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 06:51:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8FEF8F8035
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 04:51:04 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Hec3XsbQjA4ivQ6G for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 04:51:01 -0800 (PST)
Date: Tue, 3 Dec 2013 23:50:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
	(mode:0x250)
Message-ID: <20131203125057.GU10988@dastard>
References: <20131128091322.GC5337@easter-eggs.com>
	<20131128100521.GO10988@dastard>
	<20131203095357.GC5405@easter-eggs.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203095357.GC5405@easter-eggs.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Lacour <elacour@easter-eggs.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 03, 2013 at 10:53:58AM +0100, Emmanuel Lacour wrote:
> On Thu, Nov 28, 2013 at 09:05:21PM +1100, Dave Chinner wrote:
> > On Thu, Nov 28, 2013 at 10:13:22AM +0100, Emmanuel Lacour wrote:
> > > 
> > > Dear XFS users,
> > > 
> > > 
> > > I run a Ceph cluster using XFS on Debian wheezy servers and Linux 3.10
> > > (debian backports). I see the following line in our logs:
> > > 
> > > XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> > > 
> > > does this reveal a problem in my setup or may I ignore it? If it's a
> > > problem, can someone give me any hint on solving this?
> > 
> > It might be, but you need to provide more information for us to be
> > able to make any intelligent comment on the message. Start here:
> > 
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> > 
> 
> 
> The problem continue and crashed my ceph cluster again, so here is all
> the informations said in the FAQ:
> 
> http://people.easter-eggs.org/~manu/xfs.log

OK, 32GB RAM, no obvious shortage, no dirty or writeback data.
2TB SATA drives, 32AGs, only unusual setting is 64k directory block
size.

Yup, there's your problem:

[4583991.478469] ceph-osd        D ffff88047fc93f40     0 22951
1 0x00000004
[4583991.478471]  ffff88046d241140 0000000000000082 ffffffff81047e75
ffff88046f949800
[4583991.478475]  0000000000013f40 ffff88039eb0bfd8 ffff88039eb0bfd8
ffff88046d241140
[4583991.478479]  0000000000000000 00000001444d68bd ffff88046d241140
0000000000000005
[4583991.478483] Call Trace:
[4583991.478487]  [<ffffffff81047e75>] ? internal_add_timer+0xd/0x28
[4583991.478491]  [<ffffffff8138e34a>] ? schedule_timeout+0xeb/0x123
[4583991.478494]  [<ffffffff81047e63>] ? ftrace_raw_event_timer_class+0x9d/0x9d
[4583991.478498]  [<ffffffff8138edb6>] ? io_schedule_timeout+0x60/0x86
[4583991.478502]  [<ffffffff810d85ad>] ? congestion_wait+0x70/0xdb
[4583991.478505]  [<ffffffff8105858f>] ? abort_exclusive_wait+0x79/0x79
[4583991.478518]  [<ffffffffa056e3f9>] ? kmem_alloc+0x65/0x6f [xfs]
[4583991.478535]  [<ffffffffa0592c4a>] ? xfs_dir2_block_to_sf+0x5b/0x1fb [xfs]
[4583991.478550]  [<ffffffffa0592be0>] ? xfs_dir2_block_sfsize+0x15b/0x16a [xfs]
[4583991.478566]  [<ffffffffa058bf9a>] ? xfs_dir2_block_removename+0x1c7/0x208 [xfs]
[4583991.478581]  [<ffffffffa058ab4a>] ? xfs_dir_removename+0xda/0x114 [xfs]
[4583991.478594]  [<ffffffffa056a55c>] ? xfs_rename+0x428/0x554 [xfs]
[4583991.478606]  [<ffffffffa0567321>] ? xfs_vn_rename+0x5e/0x65 [xfs]
[4583991.478610]  [<ffffffff8111677b>] ? vfs_rename+0x224/0x35f
[4583991.478614]  [<ffffffff81113d0b>] ? lookup_dcache+0x22/0x95
[4583991.478618]  [<ffffffff81116a7e>] ? SYSC_renameat+0x1c8/0x257
[4583991.478622]  [<ffffffff810fb0fd>] ? __cache_free.isra.45+0x178/0x187
[4583991.478625]  [<ffffffff81117eb1>] ? SyS_mkdirat+0x2e/0xce
[4583991.478629]  [<ffffffff8100d56a>] ? do_notify_resume+0x53/0x68
[4583991.478633]  [<ffffffff81395429>] ?  system_call_fastpath+0x16/0x1b

It'll be stuck on this:

	hdr = kmem_alloc(mp->m_dirblksize, KM_SLEEP);

which is trying to allocate a contiguous 64k buffer to copy the
direct contents into before freeing the block and then formatting
them into the inode. The failure will be caused by memory
fragmentation, and the only way around it is to avoid the contiguous
allocation of that size.

Which, I think, is pretty easy to do. Yup, barely smoke tested patch
below that demonstrates the fix. Beware - patch may eat babies and
ask for more. Use it at your own risk!

I'll post it for review once it's had some testing and I know it
doesn't corrupt directories all over the place.

> This may be related to a friend problem here:
> 
> http://tracker.ceph.com/issues/6386

Doesn't look related, unless the OOM killer is being triggered
somehow...

Hmmmm - there's also a good chance the the transaction commit code
has this same problem contiguous allocation problem given that it
has to allocate enough space to log an entire directory buffer. Good
guess - there's another thread stuck on exactly that:

[4583991.476833] ceph-osd        D ffff88047fc33f40     0 11072 1 0x00000004
[4583991.476836]  ffff88038b32a040 0000000000000082 ffffffff81047e75 ffff88046f946040
[4583991.476840]  0000000000013f40 ffff88048ea11fd8 ffff88048ea11fd8 ffff88038b32a040
[4583991.476844]  0000000000000000 00000001444d68be ffff88038b32a040 0000000000000005
[4583991.476848] Call Trace:
[4583991.476852]  [<ffffffff81047e75>] ? internal_add_timer+0xd/0x28
[4583991.476855]  [<ffffffff8138e34a>] ? schedule_timeout+0xeb/0x123
[4583991.476859]  [<ffffffff81047e63>] ? ftrace_raw_event_timer_class+0x9d/0x9d
[4583991.476862]  [<ffffffff8138edb6>] ? io_schedule_timeout+0x60/0x86
[4583991.476867]  [<ffffffff810d85ad>] ? congestion_wait+0x70/0xdb
[4583991.476870]  [<ffffffff8105858f>] ? abort_exclusive_wait+0x79/0x79
[4583991.476883]  [<ffffffffa056e3f9>] ? kmem_alloc+0x65/0x6f [xfs]
[4583991.476899]  [<ffffffffa05a77a6>] ? xfs_log_commit_cil+0xe8/0x3d1 [xfs]
[4583991.476904]  [<ffffffff810748ab>] ? current_kernel_time+0x9/0x30
[4583991.476909]  [<ffffffff81041942>] ? current_fs_time+0x27/0x2d
[4583991.476925]  [<ffffffffa05a3b7b>] ? xfs_trans_commit+0x62/0x1cf [xfs]
[4583991.476939]  [<ffffffffa056d3ad>] ? xfs_create+0x41e/0x54f [xfs]
[4583991.476943]  [<ffffffff81114574>] ? lookup_fast+0x3d/0x215
[4583991.476954]  [<ffffffffa056cf29>] ? xfs_lookup+0x88/0xee [xfs]
[4583991.476966]  [<ffffffffa0567428>] ? xfs_vn_mknod+0xb7/0x162 [xfs]
[4583991.476970]  [<ffffffff81115fda>] ? vfs_create+0x62/0x8b
[4583991.476974]  [<ffffffff81113d0b>] ? lookup_dcache+0x22/0x95
[4583991.476978]  [<ffffffff81117179>] ? do_last+0x595/0xa16
[4583991.476982]  [<ffffffff811176be>] ? path_openat+0xc4/0x335
[4583991.476985]  [<ffffffff81117bda>] ? do_filp_open+0x2a/0x6e
[4583991.476989]  [<ffffffff81120b62>] ? __alloc_fd+0xd0/0xe1
[4583991.476993]  [<ffffffff8110b684>] ? do_sys_open+0x5c/0xe0
[4583991.476996]  [<ffffffff81395429>] ? system_call_fastpath+0x16/0x1b

That one isn't so easy to fix, unfortunately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: xfs_dir2_block_to_sf temp buffer allocation fails 

From: Dave Chinner <dchinner@redhat.com>

If we are using a large directory block size, and memory becomes
fragmented, we can get memory allocation failures trying to
kmem_alloc(64k) for a temporary buffer. However, there is not need
for a directory buffer sized allocation, as the end result ends up
in the inode literal area. This is, at most, slightly less than 2k
of space, and hence we don't need an allocation larger than that
fora temporary buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_sf.c | 58 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index aafc6e4..3725fb1 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -170,6 +170,7 @@ xfs_dir2_block_to_sf(
 	char			*ptr;		/* current data pointer */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform directory header */
+	xfs_dir2_sf_hdr_t	*dst;		/* temporary data buffer */
 
 	trace_xfs_dir2_block_to_sf(args);
 
@@ -177,35 +178,20 @@ xfs_dir2_block_to_sf(
 	mp = dp->i_mount;
 
 	/*
-	 * Make a copy of the block data, so we can shrink the inode
-	 * and add local data.
+	 * allocate a temporary destination buffer the size of the inode
+	 * to format the data into. Once we have formatted the data, we
+	 * can free the block and copy the formatted data into the inode literal
+	 * area.
 	 */
-	hdr = kmem_alloc(mp->m_dirblksize, KM_SLEEP);
-	memcpy(hdr, bp->b_addr, mp->m_dirblksize);
-	logflags = XFS_ILOG_CORE;
-	if ((error = xfs_dir2_shrink_inode(args, mp->m_dirdatablk, bp))) {
-		ASSERT(error != ENOSPC);
-		goto out;
-	}
+	dst = kmem_alloc(mp->m_sb.sb_inodesize, KM_SLEEP);
+	hdr = bp->b_addr;
 
 	/*
-	 * The buffer is now unconditionally gone, whether
-	 * xfs_dir2_shrink_inode worked or not.
-	 *
-	 * Convert the inode to local format.
-	 */
-	dp->i_df.if_flags &= ~XFS_IFEXTENTS;
-	dp->i_df.if_flags |= XFS_IFINLINE;
-	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
-	ASSERT(dp->i_df.if_bytes == 0);
-	xfs_idata_realloc(dp, size, XFS_DATA_FORK);
-	logflags |= XFS_ILOG_DDATA;
-	/*
 	 * Copy the header into the newly allocate local space.
 	 */
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dst;
 	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
-	dp->i_d.di_size = size;
+
 	/*
 	 * Set up to loop over the block's entries.
 	 */
@@ -258,10 +244,34 @@ xfs_dir2_block_to_sf(
 		ptr += dp->d_ops->data_entsize(dep->namelen);
 	}
 	ASSERT((char *)sfep - (char *)sfp == size);
+
+	/* now we are done with the block, we can shrink the inode */
+	logflags = XFS_ILOG_CORE;
+	error = xfs_dir2_shrink_inode(args, mp->m_dirdatablk, bp);
+	if (error) {
+		ASSERT(error != ENOSPC);
+		goto out;
+	}
+
+	/*
+	 * The buffer is now unconditionally gone, whether
+	 * xfs_dir2_shrink_inode worked or not.
+	 *
+	 * Convert the inode to local format and copy the data in.
+	 */
+	dp->i_df.if_flags &= ~XFS_IFEXTENTS;
+	dp->i_df.if_flags |= XFS_IFINLINE;
+	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+	ASSERT(dp->i_df.if_bytes == 0);
+	xfs_idata_realloc(dp, size, XFS_DATA_FORK);
+
+	logflags |= XFS_ILOG_DDATA;
+	memcpy(dp->i_df.if_u1.if_data, dst, size);
+	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
 out:
 	xfs_trans_log_inode(args->trans, dp, logflags);
-	kmem_free(hdr);
+	kmem_free(dst);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
