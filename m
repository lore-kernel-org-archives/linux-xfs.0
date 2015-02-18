Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75AFC7F5E
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 04:40:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04554AC001
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 02:40:18 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id mAxXJxj4vmnVEl3f (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 02:40:16 -0800 (PST)
Date: Wed, 18 Feb 2015 11:40:09 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Message-ID: <20150218104009.GB4614@quack.suse.cz>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
	<20150115124106.GF12739@quack.suse.cz>
	<100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
	<20150119141858.GF5662@quack.suse.cz>
	<20150217085200.GA23192@quack.suse.cz>
	<20150217133745.GG3364@wil.cx>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150217133745.GG3364@wil.cx>
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
To: Matthew Wilcox <willy@linux.intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "boaz@plexistor.com" <boaz@plexistor.com>, xfs@oss.sgi.com, "Dilger, Andreas" <andreas.dilger@intel.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "hch@lst.de" <hch@lst.de>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, Jan Kara <jack@suse.cz>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>

On Tue 17-02-15 08:37:45, Matthew Wilcox wrote:
> On Tue, Feb 17, 2015 at 09:52:00AM +0100, Jan Kara wrote:
> >   Matthew, I think I still didn't see response to this. I think we can
> > fixup things after they are merged (since Andrew sent this patch to Linus)
> > but IMHO it needs some action...
> 
> Sorry, I thought I'd replied to this.
> 
> > On Mon 19-01-15 15:18:58, Jan Kara wrote:
> > > On Fri 16-01-15 21:16:03, Wilcox, Matthew R wrote:
> > > > Are you sure it shouldn't be ext4_get_block_write, or _write_nolock?
> > > > According to the comments, ext4_get_block() doesn't allocate
> > > > uninitialized extents, which we do want it to do.
> > >   Hum, so if I understand the code right dax_fault() will allocate a block
> > > (== page in persistent memory) for a faulted address and will map this
> > > block directly into process' address space. Thus that block has to be
> > > zeroed out before the fault finishes no matter what (so that userspace
> > > doesn't see garbage) - unwritten block handling in the filesystem doesn't
> > > really matter (and would only cause unnecessary overhead) because of the
> > > direct mapping of the block to process' address space. So I would think
> > > that it would be easiest if dax_fault() simply zeroed out blocks which got
> > > allocated. You could rewrite part of dax_fault() to something like:
> > > 
> > > 	create = !vmf->cow_page && (vmf->flags & FAULT_FLAG_WRITE);
> > > 	error = get_block(inode, block, &bh, create);
> > > 	if (!error && (bh.b_size < PAGE_SIZE))
> > > 		error = -EIO;
> > > 	if (error)
> > > 		goto unlock_page;
> > > 
> > > 	if (buffer_new(&bh)) {
> > > 		count_vm_event(PGMAJFAULT);
> > > 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> > > 		major = VM_FAULT_MAJOR;
> > > 		dax_clear_blocks(inode, bh->b_blocknr, PAGE_SIZE);
> > > 	} else if (!buffer_mapped(&bh))
> > > 		return dax_load_hole(mapping, page, vmf);
> > > 
> > > Note, that we also avoided calling get_block() callback twice on major fault
> > > as that's relatively expensive due to locking, extent tree lookups, etc.
> > > 
> > > Also note that ext2 then doesn't have to call dax_clear_blocks() at all if
> > > I understand the code right.
> 
> I think you've missed the case where we lose power after ext2 has
> allocated the block and before dax_clear_blocks() is called.  After power
> returns, ext4 will show an unwritten extent in the tree, which will be
> zeroed before being handed to a user.  ext2 must have zeroed the block
> before linking it into the inode's data blocks.
  So the way ext4 traditionally deals with this is that we remember inode
data needs to be flushed before transaction doing the allocation commits.

So to handle this it can start transaction in ext4_dax_fault() /
ext4_dax_mkwrite() if write is requested and call ext4_jbd2_file_inode()
after dax_fault() / dax_mkwrite() returns. Complete function will look
something like follows:

static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
	handle_t *handle;
	int create = !vmf->cow_page && (vmf->flags & FAULT_FLAG_WRITE);
	struct inode *inode = file_inode(vma->vm_file);
	int ret;
	int retries = 0;

	if (create) {
		sb_start_pagefault(inode->i_sb);
		file_update_time(vma->vm_file);
retry_alloc:
		handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
					ext4_writepage_trans_blocks(inode));
		if (IS_ERR(handle)) {
			ret = PTR_ERR(handle);
			goto out;
		}
	}
	ret = do_dax_fault(vma, vmf, ext4_get_block);
	if (create) {
		if (!ret &&
		    ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE))
			ret = ext4_jbd2_file_inode(handle, inode);
		ext4_journal_stop(handle);
		if (ret == -ENOSPC &&
		    ext4_should_retry_alloc(inode->i_sb, &retries))
			goto retry_alloc;
	}
out:
	if (create)
		sb_end_pagefault(sb);
	return block_page_mkwrite_return(ret);
}

This will be much faster than dances with unwritten extents. It seems more
complex but as a bonus you get proper retry logic on ENOSPC (ext4 can see
temporary ENOSPC errors due to pending transaction commit) and also you
won't rely on _ext4_get_block() to start a transaction for you - looking at
that current code has a lock ordering violation (at least for the case
where the page exists) because page lock ranks under transaction start but
you end up calling ext4_get_block() with create == 1 and without
transaction started under page lock (we don't have lockdep instrumentation
for page locks so these problems show up only as deadlocks under load).

You may notice that for this to work, I need do_dax_fault() exported
(that's due to lock ordering of sb_start_pagefault() which ranks above
transaction start). I also need do_dax_fault() to return standard errno
(similarly to __block_page_mkwrite()) which the caller then converts to
fault handler return value via block_page_mkwrite_return() (or you could
create your own dax_fault_return()).

> > > > This got added to fix a problem that Dave Chinner pointed out.  We need
> > > > the allocated extent to either be zeroed (as ext2 does), or marked as
> > > > unwritten (ext4, XFS) so that a racing read/page fault doesn't return
> > > > uninitialized data.  If it's marked as unwritten, we need to convert it
> > > > to a written extent after we've initialised the contents.  We use the
> > > > b_end_io() callback to do this, and it's called from the DAX code, not in
> > > > softirq context.
> > >   OK, I see. But I didn't find where ->b_end_io gets called from dax code
> > > (specifically I don't see it anywhere in dax_do_IO() or dax_io()). Can you
> > > point me please?
> 
> For faults, we call it in dax_insert_mapping(), the very last thing
> before returning in the fault path.  The normal I/O path gets to use
> the dio_iodone_t for the same purpose.
  I see. I didn't think of races with reads (hum, I actually wonder whether
we don't have this data exposure problem for ext4 for mmapped write into
a hole vs direct read as well). So I guess we do need those unwritten
extent dances after all (or we would need to have a page covering hole when
writing to it via mmap but I guess unwritten extent dances are somewhat
more standard).

So in that case you need ext4_get_block_write() in the above call to
do_dax_fault() (note that we still do need ext4 version of the fault
function like above due to lock ranking and retry on ENOSPC). And please
comment about the read races at that call site so that we have that
subtlety documented somewhere.

> > > Also abusing b_end_io of a phony buffer for that looks ugly to me (we are
> > > trying to get away from passing phony bh around and this would entangle us
> > > even more into that mess). Normally I would think that end_io() callback
> > > passed into dax_do_io() should perform necessary conversions and for
> > > dax_fault() we could do necessary conversions inside foofs_page_mkwrite()...
> 
> Dave sees to be the one trying the hardest to get rid of the phony BHs
> ... and it was his idea to (ab)use b_end_io for this.  The problem with
> doing the conversion in ext4_page_mkwrite() is that we don't know at
> that point whether the BH is unwritten or not.
  I see, thanks for explanation. So it would be enough to pass a bit of
information (unwritten / written) to a caller of do_dax_fault() and that
can then call conversion function. IMO doing that (either in a return value
or in a separate argument of do_dax_fault()) would be cleaner and more
readable than playing with b_private and b_end_io... Thoughts?

								Honza 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
