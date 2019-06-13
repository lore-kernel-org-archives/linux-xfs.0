Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbfFMDmZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jun 2019 23:42:25 -0400
Date: Wed, 12 Jun 2019 23:42:18 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <165204827.34945594.1560397338620.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190612162012.06b4af7f.cohuck@redhat.com>
References: <20190612124527.3763-1-pagupta@redhat.com> <20190612124527.3763-3-pagupta@redhat.com> <20190612162012.06b4af7f.cohuck@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v13 2/7] virtio-pmem: Add virtio pmem
 driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cornelia Huck <cohuck@redhat.com>
Cc: rdunlap@infradead.org, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, dave jiang <dave.jiang@intel.com>, jstaron@google.com, linux-nvdimm@lists.01.org, vishal l verma <vishal.l.verma@intel.com>, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, snitzer@redhat.com, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com


> 
> > This patch adds virtio-pmem driver for KVM guest.
> > 
> > Guest reads the persistent memory range information from
> > Qemu over VIRTIO and registers it on nvdimm_bus. It also
> > creates a nd_region object with the persistent memory
> > range information so that existing 'nvdimm/pmem' driver
> > can reserve this into system memory map. This way
> > 'virtio-pmem' driver uses existing functionality of pmem
> > driver to register persistent memory compatible for DAX
> > capable filesystems.
> > 
> > This also provides function to perform guest flush over
> > VIRTIO from 'pmem' driver when userspace performs flush
> > on DAX memory range.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > Acked-by: Jakub Staron <jstaron@google.com>
> > Tested-by: Jakub Staron <jstaron@google.com>
> > ---
> >  drivers/nvdimm/Makefile          |   1 +
> >  drivers/nvdimm/nd_virtio.c       | 125 +++++++++++++++++++++++++++++++
> >  drivers/nvdimm/virtio_pmem.c     | 122 ++++++++++++++++++++++++++++++
> >  drivers/nvdimm/virtio_pmem.h     |  55 ++++++++++++++
> >  drivers/virtio/Kconfig           |  11 +++
> >  include/uapi/linux/virtio_ids.h  |   1 +
> >  include/uapi/linux/virtio_pmem.h |  35 +++++++++
> >  7 files changed, 350 insertions(+)
> >  create mode 100644 drivers/nvdimm/nd_virtio.c
> >  create mode 100644 drivers/nvdimm/virtio_pmem.c
> >  create mode 100644 drivers/nvdimm/virtio_pmem.h
> >  create mode 100644 include/uapi/linux/virtio_pmem.h
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Thank you Cornelia for the review.

Best regards,
Pankaj
> 
> 
