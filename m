Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:32849 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752400AbdJITSf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 15:18:35 -0400
Date: Mon, 9 Oct 2017 13:18:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171009191820.GD15336@obsidianresearch.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>

On Mon, Oct 09, 2017 at 12:05:30PM -0700, Dan Williams wrote:
> On Mon, Oct 9, 2017 at 11:58 AM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Fri, Oct 06, 2017 at 03:35:54PM -0700, Dan Williams wrote:
> >> otherwise be quiesced. The need for this knowledge is driven by a need
> >> to make RDMA transfers to DAX mappings safe. If the DAX file's block map
> >> changes we need to be to reliably stop accesses to blocks that have been
> >> freed or re-assigned to a new file.
> >
> > If RDMA is driving this need, why not invalidate backing RDMA MRs
> > instead of requiring a IOMMU to do it? RDMA MR are finer grained and
> > do not suffer from the re-use problem David W. brought up with IOVAs..
> 
> Sounds promising. All I want in the end is to be sure that the kernel
> is enabled to stop any in-flight RDMA at will without asking
> userspace. Does this require per-RDMA driver opt-in or is there a
> common call that can be made?

I don't think this has ever come up in the context of an all-device MR
invalidate requirement. Drivers already have code to invalidate
specifc MRs, but to find all MRs that touch certain pages and then
invalidate them would be new code.

We also have ODP aware drivers that can retarget a MR to new
physical pages. If the block map changes DAX should synchronously
retarget the ODP MR, not halt DMA.

Most likely ODP & DAX would need to be used together to get robust
user applications, as having the user QP's go to an error state at
random times (due to DMA failures) during operation is never going to
be acceptable...

Perhaps you might want to initially only support ODP MR mappings with
DAX and then the DMA fencing issue goes away?

Cheers,
Jason
