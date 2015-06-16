Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E6567F85
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2015 15:27:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75541304062
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2015 13:27:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OvCJdsFGeL5gP1F9 for <xfs@oss.sgi.com>;
	Tue, 16 Jun 2015 13:27:15 -0700 (PDT)
Date: Wed, 17 Jun 2015 06:26:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/28] xfsprogs: sparse inode chunks
Message-ID: <20150616202631.GI20262@dastard>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
	<20150616003344.GG20262@dastard> <20150616003923.GH20262@dastard>
	<20150616105504.GA24853@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150616105504.GA24853@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 16, 2015 at 06:55:04AM -0400, Brian Foster wrote:
> On Tue, Jun 16, 2015 at 10:39:23AM +1000, Dave Chinner wrote:
> > On Tue, Jun 16, 2015 at 10:33:44AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 02, 2015 at 02:41:33PM -0400, Brian Foster wrote:
> > > > Hi all,
> > > > 
> > > > Now that the sparse inode chunks feature is merged into the kernel tree
> > > > for 4.2, here is the first official drop of userspace support. This
> > > > series is based on the current libxfs-4.1-update branch.
> > > > 
> > > > Patches 1-10 are libxfs infrastructure and correspond to the similarly
> > > > named kernel patches. The bits not relevant to userspace are dropped
> > > > along with the bulk of the sparse inode chunk allocation logic from the
> > > > kernel due to the combination of non-existent dependencies in userspace
> > > > (e.g., xfs_bit.c) and the fact that this code isn't invoked from
> > > > userspace.
> > > 
> > > Ok, so this is causing problems with merging other code into
> > > userspace. What I'm trying to do is keepthe kernel fs/xfs/libxfs/
> > > code as close to identical with the xfsprogs libxfs/ code so that
> > > patches just port straight across. I came across this difference
> > > because my rmap btree patches fail to apply cleanly to xfs_ialloc.c
> > > and it's because of all this missing code in userspace.
> > > 
> > > Rather than wait another day or two for you to rework this, Brian,
> > > I'm simply going to rework this series to pull all the kernel patches
> > > across and make it compile in userspace so that I can pull all the
> > > rmap btree stuff across without needing to rework bits and peices of
> > > the patchset.
> > 
> > BTW, with patches I'll soon commit:
> > 
> > $ tools/libxfs-apply --source ../kern/xfsdev/ --commit 22419ac..22ce1e1
> > Commits to apply:
> > d4cc540 xfs: create individual inode alloc. helper
> > 999633d xfs: update free inode record logic to support sparse inode records
> > bfe46d4 xfs: support min/max agbno args in block allocator
> > fb4f2b4 xfs: add sparse inode chunk alignment superblock field
> > 066a188 xfs: use sparse chunk alignment for min. inode allocation requirement
> > e5376fc xfs: sparse inode chunks feature helpers and mount requirements
> > 502a4e7 xfs: add fs geometry bit for sparse inode chunks
> > 5419040 xfs: introduce inode record hole mask for sparse inode chunks
> > 12d0714 xfs: use actual inode count for sparse records in bulkstat/inumbers
> > 463958a xfs: pass inode count through ordered icreate log item
> > 7f43c90 xfs: handle sparse inode chunks in icreate log recovery
> > 4148c34 xfs: helper to convert holemask to inode alloc. bitmap
> > 56d1115 xfs: allocate sparse inode chunks on full chunk allocation failure
> > 1cdadee xfs: randomly do sparse inode allocations in DEBUG mode
> > 26dd521 xfs: filter out sparse regions from individual inode allocation
> > 10ae3dc7 xfs: only free allocated regions of inode chunks
> > 09b5660 xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
> > 22ce1e1 xfs: enable sparse inode chunks for v5 superblocks
> > Proceed [y|N]? y
> > Applying patch..xfs__create_individual_inode_alloc_helper
> > Patch applied.
> > Patch xfs__create_individual_inode_alloc_helper refreshed
> > Applying patch..xfs__update_free_inode_record_logic_to_support_sparse_inode_records
> > Patch applied.
> > Patch xfs__update_free_inode_record_logic_to_support_sparse_inode_records refreshed
> > Applying patch..xfs__support_min-max_agbno_args_in_block_allocator
> > Patch applied.
> > Patch xfs__support_min-max_agbno_args_in_block_allocator refreshed
> > Applying patch..xfs__add_sparse_inode_chunk_alignment_superblock_field
> > Patch applied.
> > Patch xfs__add_sparse_inode_chunk_alignment_superblock_field refreshed
> > Applying patch..xfs__use_sparse_chunk_alignment_for_min_inode_allocation_requirement
> > Patch applied.
> > Patch xfs__use_sparse_chunk_alignment_for_min_inode_allocation_requirement refreshed
> > Applying patch..xfs__sparse_inode_chunks_feature_helpers_and_mount_requirements
> > Patch applied.
> > Patch xfs__sparse_inode_chunks_feature_helpers_and_mount_requirements refreshed
> > Applying patch..xfs__add_fs_geometry_bit_for_sparse_inode_chunks
> > Patch applied.
> > Patch xfs__add_fs_geometry_bit_for_sparse_inode_chunks refreshed
> > Applying patch..xfs__introduce_inode_record_hole_mask_for_sparse_inode_chunks
> > Patch applied.
> > Patch xfs__introduce_inode_record_hole_mask_for_sparse_inode_chunks refreshed
> > Applying patch..xfs__use_actual_inode_count_for_sparse_records_in_bulkstat-inumbers
> > Patch applied.
> > Patch xfs__use_actual_inode_count_for_sparse_records_in_bulkstat-inumbers refreshed
> > Applying patch..xfs__pass_inode_count_through_ordered_icreate_log_item
> > Patch applied.
> > Patch xfs__pass_inode_count_through_ordered_icreate_log_item refreshed
> > Applying patch..xfs__handle_sparse_inode_chunks_in_icreate_log_recovery
> > Patch applied.
> > Patch xfs__handle_sparse_inode_chunks_in_icreate_log_recovery refreshed
> > Applying patch..xfs__helper_to_convert_holemask_to_inode_alloc_bitmap
> > Patch applied.
> > Patch xfs__helper_to_convert_holemask_to_inode_alloc_bitmap refreshed
> > Applying patch..xfs__allocate_sparse_inode_chunks_on_full_chunk_allocation_failure
> > Patch applied.
> > Patch xfs__allocate_sparse_inode_chunks_on_full_chunk_allocation_failure refreshed
> > Applying patch..xfs__randomly_do_sparse_inode_allocations_in_debug_mode
> > Patch applied.
> > Patch xfs__randomly_do_sparse_inode_allocations_in_debug_mode refreshed
> > Applying patch..xfs__filter_out_sparse_regions_from_individual_inode_allocation
> > Patch applied.
> > Patch xfs__filter_out_sparse_regions_from_individual_inode_allocation refreshed
> > Applying patch..xfs__only_free_allocated_regions_of_inode_chunks
> > Patch applied.
> > Patch xfs__only_free_allocated_regions_of_inode_chunks refreshed
> > Applying patch..xfs__skip_unallocated_regions_of_inode_chunks_in_xfs_ifree_cluster
> > Patch applied.
> > Patch xfs__skip_unallocated_regions_of_inode_chunks_in_xfs_ifree_cluster refreshed
> > Applying patch..xfs__enable_sparse_inode_chunks_for_v5_superblocks
> > Patch applied.
> > Patch xfs__enable_sparse_inode_chunks_for_v5_superblocks refreshed
> > $
> > 
> > The series has applied cleanly with less than 30s work, now I can go
> > and do the bits I need to make it compile....
> > 
> 
> Yeah, the issue was never that it didn't apply. For the most part,
> everything in the kernel series applied fine to userspace (save for
> non-existent files in userspace, etc.). The issue was that some of the
> bits didn't compile in userspace and it didn't seem worth the effort to
> port over the dependent bits for code that ultimately doesn't execute in
> userspace (and thus can't be tested easily either).
> 
> So what is the plan to handle that? I suppose we could comment out those
> particular bits, just leave stub functions for the depending or
> dependent code, move it to part of the shared libxfs assuming it doesn't
> create further dependencies, etc. The first couple options would
> probably still eventually lead to libxfs conflicts going forward,
> whereas outside stubs or pulling more into libxfs probably avoids
> that.

No stubs or partial files - that's where we were before I started on
the libxfs unification and it made merges hell. libxfs/ files should
be as close to identical as possible in both code bases.

I just pulled in xfs_bit.c (xfs_bit.h is already in libxfs/), and
I copied the bitmap pieces from the kernel files across into
libxfs_priv.h, and everything compiles and seems to work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
