Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbfAISVb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jan 2019 13:21:31 -0500
Date: Wed, 9 Jan 2019 13:21:29 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <888499462.61280342.1547058089165.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4jsa709BVPAx_BT5eFrODf-PUPOZ4aguDsjZVawVXTVHQ@mail.gmail.com>
References: <20190109135024.14093-1-pagupta@redhat.com> <20190109135024.14093-4-pagupta@redhat.com> <CAPcyv4jsa709BVPAx_BT5eFrODf-PUPOZ4aguDsjZVawVXTVHQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] libnvdimm: add nd_region buffered dax_dev flag
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@surriel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Ross Zwisler <zwisler@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@redhat.com>, jmoyer <jmoyer@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Christoph Hellwig <hch@infradead.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, lcapitulino@redhat.com, Igor Mammedov <imammedo@redhat.com>, Eric Blake <eblake@redhat.com>, Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>


> >
> > This patch adds 'DAXDEV_BUFFERED' flag which is set
> > for virtio pmem corresponding nd_region. This later
> > is used to disable MAP_SYNC functionality for ext4
> > & xfs filesystem.
> >
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  drivers/dax/super.c          | 17 +++++++++++++++++
> >  drivers/nvdimm/pmem.c        |  3 +++
> >  drivers/nvdimm/region_devs.c |  7 +++++++
> >  drivers/virtio/pmem.c        |  1 +
> >  include/linux/dax.h          |  9 +++++++++
> >  include/linux/libnvdimm.h    |  6 ++++++
> >  6 files changed, 43 insertions(+)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 6e928f3..9128740 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -167,6 +167,8 @@ enum dax_device_flags {
> >         DAXDEV_ALIVE,
> >         /* gate whether dax_flush() calls the low level flush routine */
> >         DAXDEV_WRITE_CACHE,
> > +       /* flag to disable MAP_SYNC for virtio based host page cache flush
> > */
> > +       DAXDEV_BUFFERED,
> >  };
> >
> >  /**
> > @@ -335,6 +337,21 @@ bool dax_write_cache_enabled(struct dax_device
> > *dax_dev)
> >  }
> >  EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
> >
> > +void virtio_pmem_host_cache(struct dax_device *dax_dev, bool wc)
> > +{
> > +       if (wc)
> > +               set_bit(DAXDEV_BUFFERED, &dax_dev->flags);
> > +       else
> > +               clear_bit(DAXDEV_BUFFERED, &dax_dev->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(virtio_pmem_host_cache);
> 
> The "write_cache" property was structured this way because it can
> conceivably change at runtime. The MAP_SYNC capability should be
> static and never changed after init.

o.k. Will change.

> 
> > +bool virtio_pmem_host_cache_enabled(struct dax_device *dax_dev)
> > +{
> > +       return test_bit(DAXDEV_BUFFERED, &dax_dev->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(virtio_pmem_host_cache_enabled);
> 
> Echoing Darrick and Jan this is should be a generic property of a
> dax_device and not specific to virtio. I don't like the "buffered"
> designation as that's not accurate. There may be hardware reasons why
> a dax_device is not synchronous, like a requirement to flush a
> write-pending queue or otherwise notify the device of new writes.

Agree.

> 
> I would just have a dax_synchronous() helper and a DAXDEV_SYNC flag. I
> would also modify alloc_dax() to take a flags argument so that the
> capability can be instantiated when the dax_device is allocated.

o.k. Will make the change.

Thanks,
Pankaj
> 
