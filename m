Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (unknown [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 900007F4E
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 08:38:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B295EAC001
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 06:38:37 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 5qvnQZuBqMYBXlKf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Jan 2015 06:19:01 -0800 (PST)
Date: Mon, 19 Jan 2015 15:18:58 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Message-ID: <20150119141858.GF5662@quack.suse.cz>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
	<20150115124106.GF12739@quack.suse.cz>
	<100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
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
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "boaz@plexistor.com" <boaz@plexistor.com>, xfs@oss.sgi.com, "Dilger, Andreas" <andreas.dilger@intel.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "hch@lst.de" <hch@lst.de>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "tytso@mit.edu" <tytso@mit.edu>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Jan Kara <jack@suse.cz>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>

On Fri 16-01-15 21:16:03, Wilcox, Matthew R wrote:
> On Mon 12-01-15 15:11:17, Andrew Morton wrote:
> > > +#ifdef CONFIG_FS_DAX
> > > +static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > > +{
> > > +	return dax_fault(vma, vmf, ext4_get_block);
> > > +					/* Is this the right get_block? */
> >   You can remove the comment. It is the right get_block function.
> 
> Are you sure it shouldn't be ext4_get_block_write, or _write_nolock?
> According to the comments, ext4_get_block() doesn't allocate
> uninitialized extents, which we do want it to do.
  Hum, so if I understand the code right dax_fault() will allocate a block
(== page in persistent memory) for a faulted address and will map this
block directly into process' address space. Thus that block has to be
zeroed out before the fault finishes no matter what (so that userspace
doesn't see garbage) - unwritten block handling in the filesystem doesn't
really matter (and would only cause unnecessary overhead) because of the
direct mapping of the block to process' address space. So I would think
that it would be easiest if dax_fault() simply zeroed out blocks which got
allocated. You could rewrite part of dax_fault() to something like:

	create = !vmf->cow_page && (vmf->flags & FAULT_FLAG_WRITE);
	error = get_block(inode, block, &bh, create);
	if (!error && (bh.b_size < PAGE_SIZE))
		error = -EIO;
	if (error)
		goto unlock_page;

	if (buffer_new(&bh)) {
		count_vm_event(PGMAJFAULT);
		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
		major = VM_FAULT_MAJOR;
		dax_clear_blocks(inode, bh->b_blocknr, PAGE_SIZE);
	} else if (!buffer_mapped(&bh))
		return dax_load_hole(mapping, page, vmf);

Note, that we also avoided calling get_block() callback twice on major fault
as that's relatively expensive due to locking, extent tree lookups, etc.

Also note that ext2 then doesn't have to call dax_clear_blocks() at all if
I understand the code right.

And with this change to dax_fault() using ext4_get_block() is the right
function to call. It will just allocate a block if necessary and attach it
to an appropriate place in the extent tree which is all you need.

> > > @@ -694,6 +706,11 @@ static int _ext4_get_block(struct inode
> > >  
> > >  		map_bh(bh, inode->i_sb, map.m_pblk);
> > >  		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
> > > +		if (IS_DAX(inode) && buffer_unwritten(bh) && !io_end) {
> > > +			bh->b_assoc_map = inode->i_mapping;
> > > +			bh->b_private = (void *)(unsigned long)iblock;
> > > +			bh->b_end_io = ext4_end_io_unwritten;
> > > +		}
> >   So why is this needed? It would deserve a comment. It confuses me in
> > particular because:
> > 1) This is a often a phony bh used just as a container for passed data and
> >    b_end_io is just ignored.
> > 2) Even if it was real bh attached to a page, for DAX we don't do any
> >    writeback and thus ->b_end_io will never get called?
> > 3) And if it does get called, you certainly cannot call
> >    ext4_convert_unwritten_extents() from softirq context where ->b_end_io
> >    gets called.
> 
> This got added to fix a problem that Dave Chinner pointed out.  We need
> the allocated extent to either be zeroed (as ext2 does), or marked as
> unwritten (ext4, XFS) so that a racing read/page fault doesn't return
> uninitialized data.  If it's marked as unwritten, we need to convert it
> to a written extent after we've initialised the contents.  We use the
> b_end_io() callback to do this, and it's called from the DAX code, not in
> softirq context.
  OK, I see. But I didn't find where ->b_end_io gets called from dax code
(specifically I don't see it anywhere in dax_do_IO() or dax_io()). Can you
point me please?

Also abusing b_end_io of a phony buffer for that looks ugly to me (we are
trying to get away from passing phony bh around and this would entangle us
even more into that mess). Normally I would think that end_io() callback
passed into dax_do_io() should perform necessary conversions and for
dax_fault() we could do necessary conversions inside foofs_page_mkwrite()...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
