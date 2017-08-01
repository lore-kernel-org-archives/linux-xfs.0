Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdHAKwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 06:52:21 -0400
Date: Tue, 1 Aug 2017 03:52:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170801105219.GA6742@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jul 27, 2017 at 03:12:38PM +0200, Jan Kara wrote:
> So the functionality this patches implement: We have an inode flag (currently
> I abuse S_SYNC inode flag for this and IMHO it kind of makes sense but if
> people hate that I'm certainly open to using new flag in the final
> implementation) that marks inode as requiring synchronous page faults.
> The guarantee provided by this flag on inode is: While a block is writeably
> mapped into page tables, it is guaranteed to be visible in the file at that
> offset also after a crash.

I think the right interface for page fault behavior is a mmap
flag, MAP_SYNC or similar, which will be optional and a failure of
a MAP_SYNC mmap will indicated that this behavior can't be provided
for the given file descriptor.

> >From my (fairly limited) knowledge of XFS it seems XFS should be able to do the
> same and it should be even possible for filesystem to implement safe remapping
> of a file offset to a different block (i.e. break reflink, do defrag, or
> similar stuff) like:

It should.  But what I'm worried about for both ext4 and XFS is the
worst case behavior that the page faul path can now hit, e.g. flushing
a potentially full log.  Do you have any numbers of how long your
ext4 page faults take with this in the worst case?

> There are couple of open questions with this implementation:
> 
> 1) Is it worth the hassle?

For that I'd really like to see performance numbers.  And compared to
the immutable nightmare that Dan proposed this looks orders of magnitude
better.

> 2) Is S_SYNC good flag to use or should we use a new inode flag?

I think the right interface is mmap as said above.  But even if not
we should not simply reuse existing flags with a well defined (although
not particular useful) behavior.

> 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
>    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
>    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
>    things to make this cleaner.

I'll take a look.
