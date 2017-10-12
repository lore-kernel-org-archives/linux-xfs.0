Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:54530 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750729AbdJLS1o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 14:27:44 -0400
Date: Thu, 12 Oct 2017 12:27:12 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171012182712.GA5772@obsidianresearch.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com>
 <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
 <20171010172516.GA29915@obsidianresearch.com>
 <CAPcyv4jL5fN7jjXkQum8ERQ45eW63dCYp5Pm6aHY4OPudz4Wsw@mail.gmail.com>
 <20171010180512.GA31734@obsidianresearch.com>
 <CAPcyv4gCBu5ptmWyof+Z-p7NbuCygEs2rMe2wdL0n3QQbXhrzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gCBu5ptmWyof+Z-p7NbuCygEs2rMe2wdL0n3QQbXhrzA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>

On Tue, Oct 10, 2017 at 01:17:26PM -0700, Dan Williams wrote:

> Also keep in mind that what triggers the lease break is another
> application trying to write or punch holes in a file that is mapped
> for RDMA. So, if the hardware can't handle the iommu mapping getting
> invalidated asynchronously and the application can't react in the
> lease break timeout period then the administrator should arrange for
> the file to not be written or truncated while it is mapped.

That makes sense, but why not return ENOSYS or something to the app
trying to alter the file if the RDMA hardware can't support this
instead of having the RDMA app deal with this lease break weirdness?

> It's already the case that get_user_pages() does not lock down file
> associations, so if your application is contending with these types of
> file changes it likely already has a problem keeping transactions in
> sync with the file state even without DAX.

Yes, things go weird in non-ODP RDMA cases like this..

Also, just to clear, I would expect an app using the SIGIO interface
to basically halt ongoing RDMA, wait for MRs to become unused locally
and remotely, destroy the MRs, then somehow, establish new MRs that
cover the same logical map (eg what ODP would do transparently) after
the lease breaker has made their changes, then restart their IO.

Does your SIGIO approach have a race-free way to do that last steps?

> > So, not being able to support DAX on certain RDMA hardware is not
> > an unreasonable situation in our space.
> 
> That makes sense, but it still seems to me that this proposed solution
> allows more than enough ways to avoid that worst case scenario where
> hardware reacts badly to iommu invalidation.

Yes, although I am concerned that returning PCI-E errors is such an
unusual and untested path for some of our RDMA drivers that they may
malfunction badly...

Again, going back to the question of who would ever use this, I would
be very relucant to deploy a production configuration relying on the iommu
invalidate or SIGIO techniques, when ODP HW is available and works
flawlessly.

> be blacklisted from supporting DAX altogether. In other words this is
> a starting point to incrementally enhance or disable specific drivers,
> but with the assurance that the kernel can always do the safe thing
> when / if the driver is missing a finer grained solution.

Seems reasonable.. I think existing HW will have an easier time adding
invalidate, while new hardware really should implement ODP.

Jason
