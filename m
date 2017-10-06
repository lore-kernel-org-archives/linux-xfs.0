Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:54372 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbdJFXM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 19:12:29 -0400
Received: by mail-oi0-f47.google.com with SMTP id u130so31954143oib.11
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2017 16:12:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jLj2WOgPA+B5eYME0uZyuoy3gp35w+4rCa_EZxm-QSKA@mail.gmail.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1507329939.29211.434.camel@infradead.org> <CAPcyv4jLj2WOgPA+B5eYME0uZyuoy3gp35w+4rCa_EZxm-QSKA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Oct 2017 16:12:27 -0700
Message-ID: <CAPcyv4hgbTzCKbYkp1n2s4XVF-PXOYKVNhMFSRNDTJo9w-3HZw@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Woodhouse <dwmw2@infradead.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>

On Fri, Oct 6, 2017 at 3:52 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Oct 6, 2017 at 3:45 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>> On Fri, 2017-10-06 at 15:35 -0700, Dan Williams wrote:
>>> Add a helper to determine if the dma mappings set up for a given device
>>> are backed by an iommu. In particular, this lets code paths know that a
>>> dma_unmap operation will revoke access to memory if the device can not
>>> otherwise be quiesced. The need for this knowledge is driven by a need
>>> to make RDMA transfers to DAX mappings safe. If the DAX file's block map
>>> changes we need to be to reliably stop accesses to blocks that have been
>>> freed or re-assigned to a new file.
>>
>> "a dma_unmap operation revoke access to memory"... but it's OK that the
>> next *map* will give the same DMA address to someone else, right?
>
> I'm assuming the next map will be to other physical addresses and a
> different requester device since the memory is still registered
> exclusively.

[ chatted with Ashok ]

Yes, it seems we need a way to pin that IOVA as in use, but invalidate
it. Then we can wait for the unmap to occur when the memory is
unregistered to avoid this IOVA reuse problem.
