Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35868 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdJKQB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 12:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <20171011115410.GF30803@8bytes.org>
References: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150764701194.16882.9682569707416653741.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171011115410.GF30803@8bytes.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 09:01:25 -0700
Message-ID: <CAA9_cmdN4N8nDdyhgn61A2_vwuTP3LJTgDCEHMQLoaFZg=DtHw@mail.gmail.com>
Subject: Re: [PATCH v8 13/14] IB/core: use MAP_DIRECT to fix / enable RDMA to
 DAX mappings
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joerg Roedel <joro@8bytes.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Sean Hefty <sean.hefty@intel.com>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Jeff Moyer <jmoyer@redhat.com>, iommu@lists.linux-foundation.org, Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm <linux-mm@kvack.org>, Doug Ledford <dledford@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, David Woodhouse <dwmw2@infradead.org>, Hal Rosenstock <hal.rosenstock@gmail.com>

On Wed, Oct 11, 2017 at 4:54 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Tue, Oct 10, 2017 at 07:50:12AM -0700, Dan Williams wrote:
>> +static void ib_umem_lease_break(void *__umem)
>> +{
>> +     struct ib_umem *umem = umem;
>> +     struct ib_device *idev = umem->context->device;
>> +     struct device *dev = idev->dma_device;
>> +     struct scatterlist *sgl = umem->sg_head.sgl;
>> +
>> +     iommu_unmap(umem->iommu, sg_dma_address(sgl) & PAGE_MASK,
>> +                     iommu_sg_num_pages(dev, sgl, umem->npages));
>> +}
>
> This looks like an invitation to break your code by random iommu-driver
> changes. There is no guarantee that an iommu-backed dma-api
> implemenation will map exactly iommu_sg_num_pages() pages for a given
> sg-list. In other words, you are mixing the use of the IOMMU-API and the
> DMA-API in an incompatible way that only works because you know the
> internals of the iommu-drivers.
>
> I've seen in another patch that your changes strictly require an IOMMU,
> so you what you should do instead is to switch from the DMA-API to the
> IOMMU-API and do the address-space management yourself.
>

Ok, I'll switch over completely to the iommu api for this. It will
also address Robin's concern.
