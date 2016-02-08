Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E46907CA9
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 03:44:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 595D8AC001
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:44:22 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id lFPlxxOhdFzW0Kq0 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 01:44:18 -0800 (PST)
Date: Mon, 8 Feb 2016 10:44:30 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v8 6/9] dax: add support for fsync/msync
Message-ID: <20160208094430.GA9451@quack.suse.cz>
References: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
	<1452230879-18117-7-git-send-email-ross.zwisler@linux.intel.com>
	<878u2xrjrw.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878u2xrjrw.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonlist@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Sat 06-02-16 17:33:07, Dmitry Monakhov wrote:
> > +int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
> > +		loff_t end)
> > +{
> > +	struct inode *inode = mapping->host;
> > +	struct block_device *bdev = inode->i_sb->s_bdev;
> > +	pgoff_t indices[PAGEVEC_SIZE];
> > +	pgoff_t start_page, end_page;
> > +	struct pagevec pvec;
> > +	void *entry;
> > +	int i, ret = 0;
> > +
> > +	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
> > +		return -EIO;
> > +
> > +	rcu_read_lock();
> > +	entry = radix_tree_lookup(&mapping->page_tree, start & PMD_MASK);
> > +	rcu_read_unlock();
> > +
> > +	/* see if the start of our range is covered by a PMD entry */
> > +	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
> > +		start &= PMD_MASK;
> > +
> > +	start_page = start >> PAGE_CACHE_SHIFT;
> > +	end_page = end >> PAGE_CACHE_SHIFT;
> > +
> > +	tag_pages_for_writeback(mapping, start_page, end_page);
> > +
> > +	pagevec_init(&pvec, 0);
> > +	while (1) {
> > +		pvec.nr = find_get_entries_tag(mapping, start_page,
> > +				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
> > +				pvec.pages, indices);
> > +
> > +		if (pvec.nr == 0)
> > +			break;
> > +
> > +		for (i = 0; i < pvec.nr; i++) {
> > +			ret = dax_writeback_one(bdev, mapping, indices[i],
> > +					pvec.pages[i]);
> > +			if (ret < 0)
> > +				return ret;
> > +		}
> I think it would be more efficient to use batched locking like follows:
>                 spin_lock_irq(&mapping->tree_lock);
> 		for (i = 0; i < pvec.nr; i++) {
>                     struct blk_dax_ctl dax[PAGEVEC_SIZE];                
>                     radix_tree_tag_clear(page_tree, indices[i], PAGECACHE_TAG_TOWRITE);
>                     /* It is also reasonable to merge adjacent dax
>                      * regions in to one */
>                     dax[i].sector = RADIX_DAX_SECTOR(entry);
>                     dax[i].size = (type == RADIX_DAX_PMD ? PMD_SIZE : PAGE_SIZE);                    
> 
>                 }
>                 spin_unlock_irq(&mapping->tree_lock);
>                	if (blk_queue_enter(q, true) != 0)
>                     goto error;
>                 for (i = 0; i < pvec.nr; i++) {
>                     rc = bdev_direct_access(bdev, dax[i]);
>                     wb_cache_pmem(dax[i].addr, dax[i].size);
>                 }
>                 ret = blk_queue_exit(q, true)

We need to clear the radix tree tag only after flushing caches. But in
principle I agree that some batching of radix tree tag manipulations should
be doable. But frankly so far we have issues with correctness so speed is
not our main concern.

> > +	}
> > +	wmb_pmem();
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
> > +
> >  static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> >  			struct vm_area_struct *vma, struct vm_fault *vmf)
> >  {
> > @@ -363,6 +532,11 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> >  	}
> >  	dax_unmap_atomic(bdev, &dax);
> >  
> > +	error = dax_radix_entry(mapping, vmf->pgoff, dax.sector, false,
> > +			vmf->flags & FAULT_FLAG_WRITE);
> > +	if (error)
> > +		goto out;
> > +
> >  	error = vm_insert_mixed(vma, vaddr, dax.pfn);
> >  
> >   out:
> > @@ -487,6 +661,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> >  		delete_from_page_cache(page);
> >  		unlock_page(page);
> >  		page_cache_release(page);
> > +		page = NULL;
> >  	}
> I've realized that I do not understand why dax_fault code works at all.
> During dax_fault we want to remove page from mapping and insert dax-entry
>  Basically code looks like follows:
> 0 page = find_get_page()
> 1 lock_page(page)
> 2 delete_from_page_cache(page);
> 3 unlock_page(page);
> 4 dax_insert_mapping(inode, &bh, vma, vmf);
> 
> BUT what on earth protects us from other process to reinsert page again
> after step(2) but before (4)?

Nothing, it's a bug and Ross / Matthew are working on fixing it...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
