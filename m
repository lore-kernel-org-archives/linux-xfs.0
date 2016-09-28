Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13883 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752977AbcI1SrS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Sep 2016 14:47:18 -0400
Date: Wed, 28 Sep 2016 12:46:43 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 04/11] ext2: remove support for DAX PMD faults
Message-ID: <20160928184643.GA16000@linux.intel.com>
References: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475009282-9818-5-git-send-email-ross.zwisler@linux.intel.com>
 <20160927214720.GD27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160927214720.GD27872@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Wed, Sep 28, 2016 at 07:47:20AM +1000, Dave Chinner wrote:
> On Tue, Sep 27, 2016 at 02:47:55PM -0600, Ross Zwisler wrote:
> > DAX PMD support was added via the following commit:
> > 
> > commit e7b1ea2ad658 ("ext2: huge page fault support")
> > 
> > I believe this path to be untested as ext2 doesn't reliably provide block
> > allocations that are aligned to 2MiB.  In my testing I've been unable to
> > get ext2 to actually fault in a PMD.  It always fails with a "pfn
> > unaligned" message because the sector returned by ext2_get_block() isn't
> > aligned.
> > 
> > I've tried various settings for the "stride" and "stripe_width" extended
> > options to mkfs.ext2, without any luck.
> > 
> > Since we can't reliably get PMDs, remove support so that we don't have an
> > untested code path that we may someday traverse when we happen to get an
> > aligned block allocation.  This should also make 4k DAX faults in ext2 a
> > bit faster since they will no longer have to call the PMD fault handler
> > only to get a response of VM_FAULT_FALLBACK.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ....
> > @@ -154,7 +133,6 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
> >  
> >  static const struct vm_operations_struct ext2_dax_vm_ops = {
> >  	.fault		= ext2_dax_fault,
> > -	.pmd_fault	= ext2_dax_pmd_fault,
> >  	.page_mkwrite	= ext2_dax_fault,
> >  	.pfn_mkwrite	= ext2_dax_pfn_mkwrite,
> >  };
> 
> Would it be better to put a comment mentioning this here? So as the
> years go by, this reminds people not to bother trying to implement
> it?
> 
> /*
>  * .pmd_fault is not supported for DAX because allocation in ext2
>  * cannot be reliably aligned to huge page sizes and so pmd faults
>  * will always fail and fail back to regular faults.
>  */

Sure, this seems like a good idea.  I'll add it, thanks.
