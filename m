Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:57060 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756464AbdJJRZi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 13:25:38 -0400
Date: Tue, 10 Oct 2017 11:25:16 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171010172516.GA29915@obsidianresearch.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com>
 <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>

On Mon, Oct 09, 2017 at 12:28:29PM -0700, Dan Williams wrote:

> > I don't think this has ever come up in the context of an all-device MR
> > invalidate requirement. Drivers already have code to invalidate
> > specifc MRs, but to find all MRs that touch certain pages and then
> > invalidate them would be new code.
> >
> > We also have ODP aware drivers that can retarget a MR to new
> > physical pages. If the block map changes DAX should synchronously
> > retarget the ODP MR, not halt DMA.
> 
> Have a look at the patch [1], I don't touch the ODP path.

But, does ODP work OK already? I'm not clear on that..

> > Most likely ODP & DAX would need to be used together to get robust
> > user applications, as having the user QP's go to an error state at
> > random times (due to DMA failures) during operation is never going to
> > be acceptable...
> 
> It's not random. The process that set up the mapping and registered
> the memory gets SIGIO when someone else tries to modify the file map.
> That process then gets /proc/sys/fs/lease-break-time seconds to fix
> the problem before the kernel force revokes the DMA access.

Well, the process can't fix the problem in bounded time, so it is
random if it will fail or not.

MR life time is under the control of the remote side, and time to
complete the network exchanges required to release the MRs is hard to
bound. So even if I implement SIGIO properly my app will still likely
have random QP failures under various cases and work loads. :(

This is why ODP should be the focus because this cannot work fully
reliably otherwise..

> > Perhaps you might want to initially only support ODP MR mappings with
> > DAX and then the DMA fencing issue goes away?
> 
> I'd rather try to fix the non-ODP DAX case instead of just turning it off.

Well, what about using SIGKILL if the lease-break-time hits? The
kernel will clean up the MRs when the process exits and this will
fence DMA to that memory.

But, still, if you really want to be fined graned, then I think
invalidating the impacted MR's is a better solution for RDMA than
trying to do it with the IOMMU...

Jason
