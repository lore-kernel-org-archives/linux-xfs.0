Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41939 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750785AbdJMHJb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 03:09:31 -0400
Date: Fri, 13 Oct 2017 09:09:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171013070929.GA26652@lst.de>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com> <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com> <20171009185840.GB15336@obsidianresearch.com> <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com> <20171009191820.GD15336@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009191820.GD15336@obsidianresearch.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>

On Mon, Oct 09, 2017 at 01:18:20PM -0600, Jason Gunthorpe wrote:
> > > If RDMA is driving this need, why not invalidate backing RDMA MRs
> > > instead of requiring a IOMMU to do it? RDMA MR are finer grained and
> > > do not suffer from the re-use problem David W. brought up with IOVAs..
> > 
> > Sounds promising. All I want in the end is to be sure that the kernel
> > is enabled to stop any in-flight RDMA at will without asking
> > userspace. Does this require per-RDMA driver opt-in or is there a
> > common call that can be made?
> 
> I don't think this has ever come up in the context of an all-device MR
> invalidate requirement. Drivers already have code to invalidate
> specifc MRs, but to find all MRs that touch certain pages and then
> invalidate them would be new code.

The whole point is that we should not need that IFF we provide the
right interface.

If we have a new 'register memory with a lease', the driver (or in fact
probably the umem core for the drivers using it) has the lease associated
with the ib_umem structure, which will just need a backpointer from the
ib_umem to the to the MR to unregister it.

Which might be a good opportunity to break the user MR from the in-kernel
ones and merge it with ib_umem, but that's a different story..
