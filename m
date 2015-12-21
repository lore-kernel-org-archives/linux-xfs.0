Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CCF47F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 11:05:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C4F9304059
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 09:05:48 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	oFyGSkr2RbfYVSvA for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 09:05:46 -0800 (PST)
Date: Mon, 21 Dec 2015 10:05:45 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 4/7] dax: add support for fsync/sync
Message-ID: <20151221170545.GA13494@linux.intel.com>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-5-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4irspQEPVdYfLK+QfW4t-1_y1gFFVuBm00=i03PFQwEYw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4irspQEPVdYfLK+QfW4t-1_y1gFFVuBm00=i03PFQwEYw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Sat, Dec 19, 2015 at 10:37:46AM -0800, Dan Williams wrote:
> On Fri, Dec 18, 2015 at 9:22 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > To properly handle fsync/msync in an efficient way DAX needs to track dirty
> > pages so it is able to flush them durably to media on demand.
> >
> > The tracking of dirty pages is done via the radix tree in struct
> > address_space.  This radix tree is already used by the page writeback
> > infrastructure for tracking dirty pages associated with an open file, and
> > it already has support for exceptional (non struct page*) entries.  We
> > build upon these features to add exceptional entries to the radix tree for
> > DAX dirty PMD or PTE pages at fault time.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> [..]
> > +static void dax_writeback_one(struct address_space *mapping, pgoff_t index,
> > +               void *entry)
> > +{
> > +       struct radix_tree_root *page_tree = &mapping->page_tree;
> > +       int type = RADIX_DAX_TYPE(entry);
> > +       struct radix_tree_node *node;
> > +       void **slot;
> > +
> > +       if (type != RADIX_DAX_PTE && type != RADIX_DAX_PMD) {
> > +               WARN_ON_ONCE(1);
> > +               return;
> > +       }
> > +
> > +       spin_lock_irq(&mapping->tree_lock);
> > +       /*
> > +        * Regular page slots are stabilized by the page lock even
> > +        * without the tree itself locked.  These unlocked entries
> > +        * need verification under the tree lock.
> > +        */
> > +       if (!__radix_tree_lookup(page_tree, index, &node, &slot))
> > +               goto unlock;
> > +       if (*slot != entry)
> > +               goto unlock;
> > +
> > +       /* another fsync thread may have already written back this entry */
> > +       if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
> > +               goto unlock;
> > +
> > +       radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
> > +
> > +       if (type == RADIX_DAX_PMD)
> > +               wb_cache_pmem(RADIX_DAX_ADDR(entry), PMD_SIZE);
> > +       else
> > +               wb_cache_pmem(RADIX_DAX_ADDR(entry), PAGE_SIZE);
> 
> Hi Ross, I should have realized this sooner, but what guarantees that
> the address returned by RADIX_DAX_ADDR(entry) is still valid at this
> point?  I think we need to store the sector in the radix tree and then
> perform a new dax_map_atomic() operation to either lookup a valid
> address or fail the sync request.  Otherwise, if the device is gone
> we'll crash, or write into some other random vmalloc address space.

Ah, good point, thank you.  v4 of this series is based on a version of
DAX where we aren't properly dealing with PMEM device removal.  I've got an
updated version that merges with your dax_map_atomic() changes, and I'll add
this change into v5 which I will send out today.  Thank you for the
suggestion.

One clarification, with the code as it is in v4 we are only doing
clflush/clflushopt/clwb instructions on the kaddr we've stored in the radix
tree, so I don't think that there is actually a risk of us doing a "write into
some other random vmalloc address space"?  I think at worse we will end up
clflushing an address that either isn't mapped or has been remapped by someone
else.  Or are you worried that the clflush would trigger a cache writeback to
a memory address where writes have side effects, thus triggering the side
effect?

I definitely think it needs to be fixed, I'm just trying to make sure I
understood your comment.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
