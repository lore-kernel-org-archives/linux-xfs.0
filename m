Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38712 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbdH2AfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 20:35:02 -0400
Date: Mon, 28 Aug 2017 17:34:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: consolidate the various page fault handlers
Message-ID: <20170829003452.GL4757@magnolia>
References: <20170828063659.21045-1-hch@lst.de>
 <20170828063659.21045-3-hch@lst.de>
 <20170828170340.GC4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828170340.GC4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz

On Mon, Aug 28, 2017 at 10:03:40AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 28, 2017 at 08:36:59AM +0200, Christoph Hellwig wrote:
> > Add a new __xfs_filemap_fault helper that implements all four page fault
> > callouts, and make these methods themselves small stubs that set the
> > correct write_fault flag, and exit early for the non-DAX case for the
> > hugepage related ones.
> > 
> > Also remove the extra size checking in the pfn_fault path, which is now
> > handled in the core DAX code.
> > 
> > Life would be so much simpler if we only had one method for all this.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Looks ok, will test....
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

This patch causes generic/413 to get stuck somehow on my qemu vms that
have fake pmem.  Not sure what's going on since previously it spat out:

 QA output created by 413
+read(Bad address) len 1024 dio dax to nondax
+read(Bad address) len 4096 dio dax to nondax
+read(Bad address) len 16777216 dio dax to nondax
+read(Bad address) len 67108864 dio dax to nondax
 Silence is golden

Whereas now it just hangs in:

src/t_mmap_dio /opt/tf_s /opt/tf_d 1024 dio both dax

Which I can't attach to with gdb or strace or kill it.  Not sure exactly
what was messsed up with the VM, though I can feed you a qemu command
line if need be.  ISTR it's something to do with qemu not emulating the
pmem quite correctly[1].

--D

[1] https://lists.01.org/pipermail/linux-nvdimm/2017-February/008959.html

> 
> --D
> 
> > ---
> >  fs/xfs/xfs_file.c  | 127 ++++++++++++++++-------------------------------------
> >  fs/xfs/xfs_trace.h |  29 ++++++++++--
> >  2 files changed, 62 insertions(+), 94 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 8b0181c6d2a6..d2b53fefa6a5 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1011,129 +1011,76 @@ xfs_file_llseek(
> >   *       page_lock (MM)
> >   *         i_lock (XFS - extent map serialisation)
> >   */
> > -
> > -/*
> > - * mmap()d file has taken write protection fault and is being made writable. We
> > - * can set the page state up correctly for a writable page, which means we can
> > - * do correct delalloc accounting (ENOSPC checking!) and unwritten extent
> > - * mapping.
> > - */
> > -STATIC int
> > -xfs_filemap_page_mkwrite(
> > -	struct vm_fault		*vmf)
> > +static int
> > +__xfs_filemap_fault(
> > +	struct vm_fault		*vmf,
> > +	enum page_entry_size	pe_size,
> > +	bool			write_fault)
> >  {
> >  	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > +	struct xfs_inode	*ip = XFS_I(inode);
> >  	int			ret;
> >  
> > -	trace_xfs_filemap_page_mkwrite(XFS_I(inode));
> > +	trace_xfs_filemap_fault(ip, pe_size, write_fault);
> >  
> > -	sb_start_pagefault(inode->i_sb);
> > -	file_update_time(vmf->vma->vm_file);
> > -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> > +	if (write_fault) {
> > +		sb_start_pagefault(inode->i_sb);
> > +		file_update_time(vmf->vma->vm_file);
> > +	}
> >  
> > +	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> >  	if (IS_DAX(inode)) {
> > -		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
> > +		ret = dax_iomap_fault(vmf, pe_size, &xfs_iomap_ops);
> >  	} else {
> > -		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
> > +		if (write_fault)
> > +			ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
> > +		else
> > +			ret = filemap_fault(vmf);
> >  	}
> > -
> >  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> > -	sb_end_pagefault(inode->i_sb);
> >  
> > +	if (write_fault)
> > +		sb_end_pagefault(inode->i_sb);
> >  	return ret;
> >  }
> >  
> > -STATIC int
> > +static int
> >  xfs_filemap_fault(
> >  	struct vm_fault		*vmf)
> >  {
> > -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > -	int			ret;
> > -
> > -	trace_xfs_filemap_fault(XFS_I(inode));
> > -
> >  	/* DAX can shortcut the normal fault path on write faults! */
> > -	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
> > -		return xfs_filemap_page_mkwrite(vmf);
> > -
> > -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> > -	if (IS_DAX(inode))
> > -		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &xfs_iomap_ops);
> > -	else
> > -		ret = filemap_fault(vmf);
> > -	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> > -
> > -	return ret;
> > +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE,
> > +			IS_DAX(file_inode(vmf->vma->vm_file)) &&
> > +			(vmf->flags & FAULT_FLAG_WRITE));
> >  }
> >  
> > -/*
> > - * Similar to xfs_filemap_fault(), the DAX fault path can call into here on
> > - * both read and write faults. Hence we need to handle both cases. There is no
> > - * ->huge_mkwrite callout for huge pages, so we have a single function here to
> > - * handle both cases here. @flags carries the information on the type of fault
> > - * occuring.
> > - */
> > -STATIC int
> > +static int
> >  xfs_filemap_huge_fault(
> >  	struct vm_fault		*vmf,
> >  	enum page_entry_size	pe_size)
> >  {
> > -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > -	struct xfs_inode	*ip = XFS_I(inode);
> > -	int			ret;
> > -
> > -	if (!IS_DAX(inode))
> > +	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
> >  		return VM_FAULT_FALLBACK;
> >  
> > -	trace_xfs_filemap_huge_fault(ip);
> > -
> > -	if (vmf->flags & FAULT_FLAG_WRITE) {
> > -		sb_start_pagefault(inode->i_sb);
> > -		file_update_time(vmf->vma->vm_file);
> > -	}
> > -
> > -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> > -	ret = dax_iomap_fault(vmf, pe_size, &xfs_iomap_ops);
> > -	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> > -
> > -	if (vmf->flags & FAULT_FLAG_WRITE)
> > -		sb_end_pagefault(inode->i_sb);
> > +	/* DAX can shortcut the normal fault path on write faults! */
> > +	return __xfs_filemap_fault(vmf, pe_size,
> > +			(vmf->flags & FAULT_FLAG_WRITE));
> > +}
> >  
> > -	return ret;
> > +static int
> > +xfs_filemap_page_mkwrite(
> > +	struct vm_fault		*vmf)
> > +{
> > +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
> >  }
> >  
> > -/*
> > - * pfn_mkwrite was originally inteneded to ensure we capture time stamp
> > - * updates on write faults. In reality, it's need to serialise against
> > - * truncate similar to page_mkwrite. Hence we cycle the XFS_MMAPLOCK_SHARED
> > - * to ensure we serialise the fault barrier in place.
> > - */
> >  static int
> >  xfs_filemap_pfn_mkwrite(
> >  	struct vm_fault		*vmf)
> >  {
> > -
> > -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > -	struct xfs_inode	*ip = XFS_I(inode);
> > -	int			ret = VM_FAULT_NOPAGE;
> > -	loff_t			size;
> > -
> > -	trace_xfs_filemap_pfn_mkwrite(ip);
> > -
> > -	sb_start_pagefault(inode->i_sb);
> > -	file_update_time(vmf->vma->vm_file);
> > -
> > -	/* check if the faulting page hasn't raced with truncate */
> > -	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> > -	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > -	if (vmf->pgoff >= size)
> > -		ret = VM_FAULT_SIGBUS;
> > -	else if (IS_DAX(inode))
> > -		ret = dax_pfn_mkwrite(vmf);
> > -	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> > -	sb_end_pagefault(inode->i_sb);
> > -	return ret;
> > -
> > +	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
> > +		return VM_FAULT_NOPAGE;
> > +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
> >  }
> >  
> >  static const struct vm_operations_struct xfs_file_vm_ops = {
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index bcc3cdf8e1c5..78626f77fe3e 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -689,10 +689,31 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
> >  DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
> >  DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
> >  
> > -DEFINE_INODE_EVENT(xfs_filemap_fault);
> > -DEFINE_INODE_EVENT(xfs_filemap_huge_fault);
> > -DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
> > -DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
> > +TRACE_EVENT(xfs_filemap_fault,
> > +	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
> > +		 bool write_fault),
> > +	TP_ARGS(ip, pe_size, write_fault),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_ino_t, ino)
> > +		__field(enum page_entry_size, pe_size)
> > +		__field(bool, write_fault)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> > +		__entry->ino = ip->i_ino;
> > +		__entry->pe_size = pe_size;
> > +		__entry->write_fault = write_fault;
> > +	),
> > +	TP_printk("dev %d:%d ino 0x%llx %s write_fault %d",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->ino,
> > +		  __print_symbolic(__entry->pe_size,
> > +			{ PE_SIZE_PTE,	"PTE" },
> > +			{ PE_SIZE_PMD,	"PMD" },
> > +			{ PE_SIZE_PUD,	"PUD" }),
> > +		  __entry->write_fault)
> > +)
> >  
> >  DECLARE_EVENT_CLASS(xfs_iref_class,
> >  	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
> > -- 
> > 2.11.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
