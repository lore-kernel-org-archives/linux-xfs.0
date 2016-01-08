Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D450C7F37
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 22:18:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 649D7AC002
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 20:18:06 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	eYjJVbsaQOmm8ASa for <xfs@oss.sgi.com>;
	Thu, 07 Jan 2016 20:18:04 -0800 (PST)
Date: Thu, 7 Jan 2016 21:18:02 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v7 2/9] dax: fix conversion of holes to PMDs
Message-ID: <20160108041802.GA568@linux.intel.com>
References: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
	<1452103263-1592-3-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4ig1W8LpC6ORYCZd65idK3QuOYa40FsbujWXXaZT_WMRA@mail.gmail.com>
	<20160107223455.GC20802@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160107223455.GC20802@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "J. Bruce Fields" <bfields@fieldses.org>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Matthew Wilcox <willy@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Thu, Jan 07, 2016 at 03:34:55PM -0700, Ross Zwisler wrote:
> On Wed, Jan 06, 2016 at 11:04:35AM -0800, Dan Williams wrote:
> > On Wed, Jan 6, 2016 at 10:00 AM, Ross Zwisler
> > <ross.zwisler@linux.intel.com> wrote:
> > > When we get a DAX PMD fault for a write it is possible that there could be
> > > some number of 4k zero pages already present for the same range that were
> > > inserted to service reads from a hole.  These 4k zero pages need to be
> > > unmapped from the VMAs and removed from the struct address_space radix tree
> > > before the real DAX PMD entry can be inserted.
> > >
> > > For PTE faults this same use case also exists and is handled by a
> > > combination of unmap_mapping_range() to unmap the VMAs and
> > > delete_from_page_cache() to remove the page from the address_space radix
> > > tree.
> > >
> > > For PMD faults we do have a call to unmap_mapping_range() (protected by a
> > > buffer_new() check), but nothing clears out the radix tree entry.  The
> > > buffer_new() check is also incorrect as the current ext4 and XFS filesystem
> > > code will never return a buffer_head with BH_New set, even when allocating
> > > new blocks over a hole.  Instead the filesystem will zero the blocks
> > > manually and return a buffer_head with only BH_Mapped set.
> > >
> > > Fix this situation by removing the buffer_new() check and adding a call to
> > > truncate_inode_pages_range() to clear out the radix tree entries before we
> > > insert the DAX PMD.
> > >
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > Replaced the current contents of v6 in -mm from next-20160106 with
> > this v7 set and it looks good.
> > 
> > Reported-by: Dan Williams <dan.j.williams@intel.com>
> > Tested-by: Dan Williams <dan.j.williams@intel.com>
> > 
> > One question below...
> > 
> > > ---
> > >  fs/dax.c | 20 ++++++++++----------
> > >  1 file changed, 10 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index 03cc4a3..9dc0c97 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -594,6 +594,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> > >         bool write = flags & FAULT_FLAG_WRITE;
> > >         struct block_device *bdev;
> > >         pgoff_t size, pgoff;
> > > +       loff_t lstart, lend;
> > >         sector_t block;
> > >         int result = 0;
> > >
> > > @@ -647,15 +648,13 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> > >                 goto fallback;
> > >         }
> > >
> > > -       /*
> > > -        * If we allocated new storage, make sure no process has any
> > > -        * zero pages covering this hole
> > > -        */
> > > -       if (buffer_new(&bh)) {
> > > -               i_mmap_unlock_read(mapping);
> > > -               unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
> > > -               i_mmap_lock_read(mapping);
> > > -       }
> > > +       /* make sure no process has any zero pages covering this hole */
> > > +       lstart = pgoff << PAGE_SHIFT;
> > > +       lend = lstart + PMD_SIZE - 1; /* inclusive */
> > > +       i_mmap_unlock_read(mapping);
> > > +       unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
> > > +       truncate_inode_pages_range(mapping, lstart, lend);
> > 
> > Do we need to do both unmap and truncate given that
> > truncate_inode_page() optionally does an unmap_mapping_range()
> > internally?
> 
> Ah, indeed it does.  Sure, having just the call to truncate_inode_page() seems
> cleaner.  I'll re-test and send this out in v8.

Actually, in testing it doesn't look like unmap_mapping_range() in
truncate_inode_page() gets called.  We fail the page_mapped(page) check for
our read-only zero pages.  I think we need to keep the unmap_mapping_range()
call in __dax_pmd_fault().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
