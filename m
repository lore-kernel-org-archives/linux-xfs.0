Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbfEKBXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 21:23:20 -0400
Date: Fri, 10 May 2019 21:23:17 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <2003480558.28042237.1557537797923.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4gL3ODfOr52Ztgq7BM4gVf1cih6cj0271gcpVvpi9aFSA@mail.gmail.com>
References: <20190510155202.14737-1-pagupta@redhat.com> <20190510155202.14737-4-pagupta@redhat.com> <CAPcyv4hbVNRFSyS2CTbmO88uhnbeH4eiukAng2cxgbDzLfizwg@mail.gmail.com> <864186878.28040999.1557535549792.JavaMail.zimbra@redhat.com> <CAPcyv4gL3ODfOr52Ztgq7BM4gVf1cih6cj0271gcpVvpi9aFSA@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v8 3/6] libnvdimm: add dax_dev sync flag
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: cohuck@redhat.com, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Dave Jiang <dave.jiang@intel.com>, jstaron@google.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Vishal L Verma <vishal.l.verma@intel.com>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, Adam Borowski <kilobyte@angband.pl>, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>


> > > >
> > > > This patch adds 'DAXDEV_SYNC' flag which is set
> > > > for nd_region doing synchronous flush. This later
> > > > is used to disable MAP_SYNC functionality for
> > > > ext4 & xfs filesystem for devices don't support
> > > > synchronous flush.
> > > >
> > > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > > ---
> > > >  drivers/dax/bus.c            |  2 +-
> > > >  drivers/dax/super.c          | 13 ++++++++++++-
> > > >  drivers/md/dm.c              |  3 ++-
> > > >  drivers/nvdimm/pmem.c        |  5 ++++-
> > > >  drivers/nvdimm/region_devs.c |  7 +++++++
> > > >  include/linux/dax.h          |  8 ++++++--
> > > >  include/linux/libnvdimm.h    |  1 +
> > > >  7 files changed, 33 insertions(+), 6 deletions(-)
> > > [..]
> > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > index 043f0761e4a0..ee007b75d9fd 100644
> > > > --- a/drivers/md/dm.c
> > > > +++ b/drivers/md/dm.c
> > > > @@ -1969,7 +1969,8 @@ static struct mapped_device *alloc_dev(int minor)
> > > >         sprintf(md->disk->disk_name, "dm-%d", minor);
> > > >
> > > >         if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
> > > > -               dax_dev = alloc_dax(md, md->disk->disk_name,
> > > > &dm_dax_ops);
> > > > +               dax_dev = alloc_dax(md, md->disk->disk_name,
> > > > &dm_dax_ops,
> > > > +
> > > > DAXDEV_F_SYNC);
> > >
> > > Apologies for not realizing this until now, but this is broken.
> > > Imaging a device-mapper configuration composed of both 'async'
> > > virtio-pmem and 'sync' pmem. The 'sync' flag needs to be unified
> > > across all members. I would change this argument to '0' and then
> > > arrange for it to be set at dm_table_supports_dax() time after
> > > validating that all components support synchronous dax.
> >
> > o.k. Need to set 'DAXDEV_F_SYNC' flag after verifying all the target
> > components support synchronous DAX.
> >
> > Just a question, If device mapper configuration have composed of both
> > virtio-pmem or pmem devices, we want to configure device mapper for async
> > flush?
> 
> If it's composed of both then, yes, it needs to be async flush at the
> device-mapper level. Otherwise MAP_SYNC will succeed and fail to
> trigger fsync on the host file when necessary for the virtio-pmem
> backed portion of the device-mapper device.

o.k. Agree.

Thanks you,
Pankaj
> 
> 
