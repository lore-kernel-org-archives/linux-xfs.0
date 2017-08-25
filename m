Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53591 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754476AbdHYHPk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 03:15:40 -0400
Date: Fri, 25 Aug 2017 09:15:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: consolidate the various page fault handlers
Message-ID: <20170825071538.GB9191@lst.de>
References: <20170824152207.30729-1-hch@lst.de> <20170824152207.30729-3-hch@lst.de> <20170824212942.GB20489@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824212942.GB20489@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Thu, Aug 24, 2017 at 03:29:42PM -0600, Ross Zwisler wrote:
> > +	/* DAX can shortcut the normal fault path on write faults! */
> 
> Does this comment still make sense for the PMD case?

I kept the code as before, and also kept the comment intent as-is
(although I shortend it a bit).

> Here's what I *think* it
> means: For DAX write faults we make the PTE writeable in the ->fault() code
> and don't rely on a follow-up ->page_mkwrite() call.  This happens in
> do_shared_fault(), where we return before the ->page_mkwrite() call because
> the DAX write fault returns VM_FAULT_NOPAGE.
> 
> This is in contrast to the normal page fault case where the ->fault() call
> ends up calling filemap_fault(), which populates the page read-only, and then
> do_shared_fault() does a follow-up ->page_mkwrite() call which makes the page
> writable.
> 
> First, is the above correct?  :)

Yes.

> If so, I think the comment doesn't make
> sense for the PMD fault path because in that case we always make the PMD
> writeable in the first ->huge_fault() call, as there is no follow-up
> *_mkwrite()?

Well, there is non-DAX huge_fault case.  It still is different from the
normal non-hugepage fault case, so the comment still makes some sense,
but maybe I should remove the DAX.  That being said if we eventually
get huge page page cache support (patches are on the list) I suspect
they'll work like the normal fault path, not the DAX path.

> >  static int
> 
>    STATIC

We're phasing that out, so I should probably remove it where it's
currently newly added/moved in the patch.

> I see that this size check is gone from the new code, and we now rely on the
> equivalent check in dax_iomap_fault().  Nice.

Yes.  And I actually used to mention that in the changelog, but it got
lost.  I'll re-add it.

> I wonder if pe_size would be more readable as a string via __print_symbolic()
> so we see "pe_size PMD" instead of "pe_size 1" from enum page_entry_size?

Probably.  I was just lazy :)  If I want to go all the way I could also
use a __print_flags for the FAULT_FLAG_* flags.
