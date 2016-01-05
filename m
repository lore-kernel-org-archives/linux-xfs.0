Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 80E937F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 09:50:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62BBD304053
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 07:50:47 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id b0jgu9gcHEt2mtzt for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 07:50:42 -0800 (PST)
Date: Tue, 5 Jan 2016 08:50:39 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v6 4/7] dax: add support for fsync/msync
Message-ID: <20160105155039.GA6462@linux.intel.com>
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450899560-26708-5-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jVJGPO8Yhz8WgSJTFw+o8=5n6yx17zchXA6C+wEKcajg@mail.gmail.com>
	<20160105111346.GC2724@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160105111346.GC2724@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Tue, Jan 05, 2016 at 12:13:46PM +0100, Jan Kara wrote:
> On Sun 03-01-16 10:13:06, Dan Williams wrote:
> > On Wed, Dec 23, 2015 at 11:39 AM, Ross Zwisler
> > <ross.zwisler@linux.intel.com> wrote:
> > > To properly handle fsync/msync in an efficient way DAX needs to track dirty
> > > pages so it is able to flush them durably to media on demand.
> > >
> > > The tracking of dirty pages is done via the radix tree in struct
> > > address_space.  This radix tree is already used by the page writeback
> > > infrastructure for tracking dirty pages associated with an open file, and
> > > it already has support for exceptional (non struct page*) entries.  We
> > > build upon these features to add exceptional entries to the radix tree for
> > > DAX dirty PMD or PTE pages at fault time.
> > >
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > I'm hitting the following report with the ndctl dax test [1] on
> > next-20151231.  I bisected it to
> >  commit 3cb108f941de "dax-add-support-for-fsync-sync-v6".  I'll take a
> > closer look tomorrow, but in case someone can beat me to it, here's
> > the back-trace:
> > 
> > ------------[ cut here ]------------
> > kernel BUG at fs/inode.c:497!
> 
> I suppose this is the check that mapping->nr_exceptional is zero, isn't it?
> Hum, I don't see how that could happen given we call
> truncate_inode_pages_final() just before the clear_inode() call which
> removes all the exceptional entries from the radix tree.  And there's not
> much room for a race during umount... Does the radix tree really contain
> any entry or is it an accounting bug?
> 
> 								Honza

I think this is a bug with the existing way that we handle PMD faults.  The
issue is that the PMD path doesn't properly remove radix tree entries for zero
pages covering holes.  The PMD path calls unmap_mapping_range() to unmap the
range out of the struct address_space, but it is missing a call to
truncate_inode_pages_range() or similar to clear out those entries in the
radix tree.  Up until now we didn't notice, we just had an orphaned entry in
the radix tree, but with my code we then find the page entry in the radix
tree when handling a PMD fault, we remove it and add in a PMD entry.  This
causes us to be off on both our mapping->nrpages and mapping->nrexceptional
counts.	

In the PTE path we properly remove the pages from the radix tree when
upgrading from a hole to a real DAX entry via the delete_from_page_cache()
call, which eventually calls page_cache_tree_delete().

I'm working on a fix now (and making sure all the above is correct).

- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
