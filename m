Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:55569 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdJFXPJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 19:15:09 -0400
Received: by mail-oi0-f53.google.com with SMTP id g125so14432389oib.12
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2017 16:15:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507331434.29211.439.camel@infradead.org>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1507329939.29211.434.camel@infradead.org> <CAPcyv4jLj2WOgPA+B5eYME0uZyuoy3gp35w+4rCa_EZxm-QSKA@mail.gmail.com>
 <1507331434.29211.439.camel@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Oct 2017 16:15:08 -0700
Message-ID: <CAPcyv4j0gbXtyviEA00ktav_-VwZUpd1+BgBNfzBqFA9XOqXBw@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Woodhouse <dwmw2@infradead.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>

On Fri, Oct 6, 2017 at 4:10 PM, David Woodhouse <dwmw2@infradead.org> wrote=
:
> On Fri, 2017-10-06 at 15:52 -0700, Dan Williams wrote:
>> On Fri, Oct 6, 2017 at 3:45 PM, David Woodhouse <dwmw2@infradead.org> wr=
ote:
>> >
>> > On Fri, 2017-10-06 at 15:35 -0700, Dan Williams wrote:
>> > >
>> > > Add a helper to determine if the dma mappings set up for a given dev=
ice
>> > > are backed by an iommu. In particular, this lets code paths know tha=
t a
>> > > dma_unmap operation will revoke access to memory if the device can n=
ot
>> > > otherwise be quiesced. The need for this knowledge is driven by a ne=
ed
>> > > to make RDMA transfers to DAX mappings safe. If the DAX file's block=
 map
>> > > changes we need to be to reliably stop accesses to blocks that have =
been
>> > > freed or re-assigned to a new file.
>> > "a dma_unmap operation revoke access to memory"... but it's OK that th=
e
>> > next *map* will give the same DMA address to someone else, right?
>>
>> I'm assuming the next map will be to other physical addresses and a
>> different requester device since the memory is still registered
>> exclusively.
>
> I meant the next map for this device/group.
>
> It may well use the same virtual DMA address as the one you just
> unmapped, yet actually map to a different physical address. So if the
> DMA still occurs to the "old" address, that isn't revoked at all =E2=80=
=94 it's
> just going to the wrong physical location.
>
> And if you are sure that the DMA will never happen, why do you need to
> revoke the mapping in the first place?

Right, crossed mails. The semantic I want is that the IOVA is
invalidated / starts throwing errors to the device because the address
it thought it was talking to has been remapped in the file. Once
userspace wakes up and responds to this invalidation event it can do
the actual unmap to make the IOVA reusable again.
