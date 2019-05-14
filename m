Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfENPZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 May 2019 11:25:21 -0400
Date: Tue, 14 May 2019 11:25:20 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1112624345.28705248.1557847520326.JavaMail.zimbra@redhat.com>
In-Reply-To: <c22d42f6-ef94-0310-36f2-e9085d3464c2@infradead.org>
References: <20190514145422.16923-1-pagupta@redhat.com> <20190514145422.16923-3-pagupta@redhat.com> <c22d42f6-ef94-0310-36f2-e9085d3464c2@infradead.org>
Subject: Re: [Qemu-devel] [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Randy Dunlap <rdunlap@infradead.org>, dan j williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, lcapitulino@redhat.com, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, dave jiang <dave.jiang@intel.com>, jstaron@google.com, darrick wong <darrick.wong@oracle.com>, vishal l verma <vishal.l.verma@intel.com>, david@redhat.com, willy@infradead.org, hch@infradead.org, jmoyer@redhat.com, nilal@redhat.com, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, kwolf@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, imammedo@redhat.com


> On 5/14/19 7:54 AM, Pankaj Gupta wrote:
> > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > index 35897649c24f..94bad084ebab 100644
> > --- a/drivers/virtio/Kconfig
> > +++ b/drivers/virtio/Kconfig
> > @@ -42,6 +42,17 @@ config VIRTIO_PCI_LEGACY
> >  
> >  	  If unsure, say Y.
> >  
> > +config VIRTIO_PMEM
> > +	tristate "Support for virtio pmem driver"
> > +	depends on VIRTIO
> > +	depends on LIBNVDIMM
> > +	help
> > +	This driver provides access to virtio-pmem devices, storage devices
> > +	that are mapped into the physical address space - similar to NVDIMMs
> > +	 - with a virtio-based flushing interface.
> > +
> > +	If unsure, say M.
> 
> <beep>
> from Documentation/process/coding-style.rst:
> "Lines under a ``config`` definition
> are indented with one tab, while help text is indented an additional two
> spaces."

ah... I changed help text and 'checkpatch' did not say anything :( .

Will wait for Dan, If its possible to add two spaces to help text while applying
the series.

Thanks,
Pankaj
  

> 
> > +
> >  config VIRTIO_BALLOON
> >  	tristate "Virtio balloon driver"
> >  	depends on VIRTIO
> 
> thanks.
> --
> ~Randy
> 
> 
