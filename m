Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42197 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbdFPTpn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 15:45:43 -0400
Date: Fri, 16 Jun 2017 13:45:40 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 3/3] dax: use common 4k zero page for dax mmap reads
Message-ID: <20170616194540.GB20742@linux.intel.com>
References: <20170614172211.19820-1-ross.zwisler@linux.intel.com>
 <20170614172211.19820-4-ross.zwisler@linux.intel.com>
 <20170615145856.GO1764@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170615145856.GO1764@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Thu, Jun 15, 2017 at 04:58:56PM +0200, Jan Kara wrote:
> On Wed 14-06-17 11:22:11, Ross Zwisler wrote:
> > @@ -216,17 +217,6 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
> >  	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
> >  }
> >  
> > -static void put_locked_mapping_entry(struct address_space *mapping,
> > -				     pgoff_t index, void *entry)
> > -{
> > -	if (!radix_tree_exceptional_entry(entry)) {
> > -		unlock_page(entry);
> > -		put_page(entry);
> > -	} else {
> > -		dax_unlock_mapping_entry(mapping, index);
> > -	}
> > -}
> > -
> 
> The naming becomes asymetric with this. So I'd prefer keeping
> put_locked_mapping_entry() as a trivial wrapper around
> dax_unlock_mapping_entry() unless we can craft more sensible naming / API
> for entry grabbing (and that would be a separate patch anyway).

Sure, that works for me.  I'll fix for v3.

> > -static int dax_load_hole(struct address_space *mapping, void **entry,
> > +static int dax_load_hole(struct address_space *mapping, void *entry,
> >  			 struct vm_fault *vmf)
> >  {
> >  	struct inode *inode = mapping->host;
> > -	struct page *page;
> > -	int ret;
> > -
> > -	/* Hole page already exists? Return it...  */
> > -	if (!radix_tree_exceptional_entry(*entry)) {
> > -		page = *entry;
> > -		goto finish_fault;
> > -	}
> > +	unsigned long vaddr = vmf->address;
> > +	int ret = VM_FAULT_NOPAGE;
> > +	struct page *zero_page;
> > +	void *entry2;
> >  
> > -	/* This will replace locked radix tree entry with a hole page */
> > -	page = find_or_create_page(mapping, vmf->pgoff,
> > -				   vmf->gfp_mask | __GFP_ZERO);
> 
> With this gone, you can also remove the special DAX handling from
> mm/filemap.c: page_cache_tree_insert() and remove from dax.h
> dax_wake_mapping_entry_waiter(), dax_radix_locked_entry() and RADIX_DAX
> definitions. Yay! As a separate patch please.

Oh, yay!  :)  Sure, I'll have this patch for v3.
