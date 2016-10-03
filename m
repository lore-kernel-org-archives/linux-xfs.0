Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10992 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbcJCSkP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Oct 2016 14:40:15 -0400
Date: Mon, 3 Oct 2016 12:40:02 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 07/12] dax: coordinate locking for offsets in PMD range
Message-ID: <20161003184002.GB2044@linux.intel.com>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475189370-31634-8-git-send-email-ross.zwisler@linux.intel.com>
 <20161003095518.GM6457@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161003095518.GM6457@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Mon, Oct 03, 2016 at 11:55:18AM +0200, Jan Kara wrote:
> On Thu 29-09-16 16:49:25, Ross Zwisler wrote:
> > DAX radix tree locking currently locks entries based on the unique
> > combination of the 'mapping' pointer and the pgoff_t 'index' for the entry.
> > This works for PTEs, but as we move to PMDs we will need to have all the
> > offsets within the range covered by the PMD to map to the same bit lock.
> > To accomplish this, for ranges covered by a PMD entry we will instead lock
> > based on the page offset of the beginning of the PMD entry.  The 'mapping'
> > pointer is still used in the same way.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> >  fs/dax.c            | 37 ++++++++++++++++++++++++-------------
> >  include/linux/dax.h |  2 +-
> >  mm/filemap.c        |  2 +-
> >  3 files changed, 26 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index baef586..406feea 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -64,10 +64,17 @@ static int __init init_dax_wait_table(void)
> >  }
> >  fs_initcall(init_dax_wait_table);
> >  
> > +static pgoff_t dax_entry_start(pgoff_t index, void *entry)
> > +{
> > +	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
> > +		index &= (PMD_MASK >> PAGE_SHIFT);
> 
> Hum, but if we shift right, top bits of PMD_MASK will become zero - not
> something we want I guess... You rather want to mask with something like:
> 	~((1UL << (PMD_SHIFT - PAGE_SHIFT)) - 1)

Great catch, thanks.  Fixed for v5.

> > @@ -447,10 +457,11 @@ restart:
> >  	return entry;
> >  }
> >  
> > -void dax_wake_mapping_entry_waiter(struct address_space *mapping,
> > +void dax_wake_mapping_entry_waiter(void *entry, struct address_space *mapping,
> >  				   pgoff_t index, bool wake_all)
> 
> Nitpick: Ordering of arguments would look more logical to me like:
> 
> dax_wake_mapping_entry_waiter(mapping, index, entry, wake_all)

Cool, I'll reorder them for v5.

Thanks for the review!
