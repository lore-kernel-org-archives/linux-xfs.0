Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:55224 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdJGXdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Oct 2017 19:33:37 -0400
Received: by mail-oi0-f46.google.com with SMTP id u130so34649969oib.11
        for <linux-xfs@vger.kernel.org>; Sat, 07 Oct 2017 16:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507374524.25529.13.camel@infradead.org>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1507329939.29211.434.camel@infradead.org> <CAPcyv4jLj2WOgPA+B5eYME0uZyuoy3gp35w+4rCa_EZxm-QSKA@mail.gmail.com>
 <1507331434.29211.439.camel@infradead.org> <CAPcyv4j0gbXtyviEA00ktav_-VwZUpd1+BgBNfzBqFA9XOqXBw@mail.gmail.com>
 <1507374524.25529.13.camel@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Oct 2017 16:33:36 -0700
Message-ID: <CAPcyv4gJY6AJX99V49eo_dY0Ov45xYtq1SDEBnnsz=6caJvo0w@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Woodhouse <dwmw2@infradead.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>

On Sat, Oct 7, 2017 at 4:08 AM, David Woodhouse <dwmw2@infradead.org> wrote=
:
> On Fri, 2017-10-06 at 16:15 -0700, Dan Williams wrote:
>>
>> Right, crossed mails. The semantic I want is that the IOVA is
>> invalidated / starts throwing errors to the device because the address
>> it thought it was talking to has been remapped in the file. Once
>> userspace wakes up and responds to this invalidation event it can do
>> the actual unmap to make the IOVA reusable again.
>
> So basically you want to unmap it by removing it from the page tables
> and flushing the IOTLB, but you want the IOVA to still be reserved.
>
> The normal device-facing DMA API doesn't give you that today. You could
> do it with the IOMMU API though =E2=80=94 that one does let you manage th=
e IOVA
> space yourself. You don't want that IOVA used again? Well don't use it
> as the IOVA in a subsequent iommu_map() call then :)

Ah, nice. So I think I'll just add a dma_get_iommu_domain() so the
dma_ops implementation can exclude identity-mapped devices, and then
iommu_unmap() does the rest. Thanks for the pointer.
