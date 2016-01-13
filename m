Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 081857F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 03:35:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9FC88F804B
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:35:21 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id dhbHfu6LZpVcN3LG (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:35:18 -0800 (PST)
Date: Wed, 13 Jan 2016 10:35:25 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v8 6/9] dax: add support for fsync/msync
Message-ID: <20160113093525.GD14630@quack.suse.cz>
References: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
	<1452230879-18117-7-git-send-email-ross.zwisler@linux.intel.com>
	<20160112105716.GT6262@quack.suse.cz>
	<20160113073019.GB30496@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160113073019.GB30496@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Wed 13-01-16 00:30:19, Ross Zwisler wrote:
> > And secondly: You must write-protect all mappings of the flushed range so
> > that you get fault when the sector gets written-to again. We spoke about
> > this in the past already but somehow it got lost and I forgot about it as
> > well. You need something like rmap_walk_file()...
> 
> The code that write protected mappings and then cleaned the radix tree entries
> did get written, and was part of v2:
> 
> https://lkml.org/lkml/2015/11/13/759
> 
> I removed all the code that cleaned PTE entries and radix tree entries for v3.
> The reason behind this was that there was a race that I couldn't figure out
> how to solve between the cleaning of the PTEs and the cleaning of the radix
> tree entries.
> 
> The race goes like this:
> 
> Thread 1 (write)			Thread 2 (fsync)
> ================			================
> wp_pfn_shared()
> pfn_mkwrite()
> dax_radix_entry()
> radix_tree_tag_set(DIRTY)
> 					dax_writeback_mapping_range()
> 					dax_writeback_one()
> 					radix_tag_clear(DIRTY)
> 					pgoff_mkclean()
> ... return up to wp_pfn_shared()
> wp_page_reuse()
> pte_mkdirty()
> 
> After this sequence we end up with a dirty PTE that is writeable, but with a
> clean radix tree entry.  This means that users can write to the page, but that
> a follow-up fsync or msync won't flush this dirty data to media.
> 
> The overall issue is that in the write path that goes through wp_pfn_shared(),
> the DAX code has control over when the radix tree entry is dirtied but not
> when the PTE is made dirty and writeable.  This happens up in wp_page_reuse().
> This means that we can't easily add locking, etc. to protect ourselves.
> 
> I spoke a bit about this with Dave Chinner and with Dave Hansen, but no really
> easy solutions presented themselves in the absence of a page lock.  I do have
> one idea, but I think it's pretty invasive and will need to wait for another
> kernel cycle.
> 
> The current code that leaves the radix tree entry will give us correct
> behavior - it'll just be less efficient because we will have an ever-growing
> dirty set to flush.

Ahaa! Somehow I imagined tag_pages_for_writeback() clears DIRTY radix tree
tags but it does not (I should have known, I have written that functions
few years ago ;). Makes sense. Thanks for clarification.

> > > @@ -791,15 +976,12 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
> > >   * dax_pfn_mkwrite - handle first write to DAX page
> > >   * @vma: The virtual memory area where the fault occurred
> > >   * @vmf: The description of the fault
> > > - *
> > >   */
> > >  int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > >  {
> > > -	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> > > +	struct file *file = vma->vm_file;
> > >  
> > > -	sb_start_pagefault(sb);
> > > -	file_update_time(vma->vm_file);
> > > -	sb_end_pagefault(sb);
> > > +	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
> > 
> > Why is NO_SECTOR argument correct here?
> 
> Right - so NO_SECTOR means "I expect there to already be an entry in the radix
> tree - just make that entry dirty".  This works because pfn_mkwrite() always
> follows a normal __dax_fault() or __dax_pmd_fault() call.  These fault calls
> will insert the radix tree entry, regardless of whether the fault was for a
> read or a write.  If the fault was for a write, the radix tree entry will also
> be made dirty.
>
> For reads the radix tree entry will be inserted but left clean.  When the
> first write happens we will get a pfn_mkwrite() call, which will call
> dax_radix_entry() with the NO_SECTOR argument.  This will look up the radix
> tree entry & set the dirty tag.

So the explanation of this should be somewhere so that everyone knows that
we must have radix tree entries even for clean mapped blocks. Because upto
know that was not clear to me.  Also __dax_pmd_fault() seems to insert
entries only for write fault so the assumption doesn't seem to hold there?

I'm somewhat uneasy that a bug in this logic can be hidden as a simple race
with hole punching. But I guess I can live with that.
 
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
