Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfFLOVE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jun 2019 10:21:04 -0400
Date: Wed, 12 Jun 2019 16:20:12 +0200
From: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v13 2/7] virtio-pmem: Add virtio pmem driver
Message-ID: <20190612162012.06b4af7f.cohuck@redhat.com>
In-Reply-To: <20190612124527.3763-3-pagupta@redhat.com>
References: <20190612124527.3763-1-pagupta@redhat.com>
        <20190612124527.3763-3-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, yuval.shaia@oracle.com, kilobyte@angband.pl, jstaron@google.com, rdunlap@infradead.org, snitzer@redhat.com

On Wed, 12 Jun 2019 18:15:22 +0530
Pankaj Gupta <pagupta@redhat.com> wrote:

> This patch adds virtio-pmem driver for KVM guest.
> 
> Guest reads the persistent memory range information from
> Qemu over VIRTIO and registers it on nvdimm_bus. It also
> creates a nd_region object with the persistent memory
> range information so that existing 'nvdimm/pmem' driver
> can reserve this into system memory map. This way
> 'virtio-pmem' driver uses existing functionality of pmem
> driver to register persistent memory compatible for DAX
> capable filesystems.
> 
> This also provides function to perform guest flush over
> VIRTIO from 'pmem' driver when userspace performs flush
> on DAX memory range.
> 
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Jakub Staron <jstaron@google.com>
> Tested-by: Jakub Staron <jstaron@google.com>
> ---
>  drivers/nvdimm/Makefile          |   1 +
>  drivers/nvdimm/nd_virtio.c       | 125 +++++++++++++++++++++++++++++++
>  drivers/nvdimm/virtio_pmem.c     | 122 ++++++++++++++++++++++++++++++
>  drivers/nvdimm/virtio_pmem.h     |  55 ++++++++++++++
>  drivers/virtio/Kconfig           |  11 +++
>  include/uapi/linux/virtio_ids.h  |   1 +
>  include/uapi/linux/virtio_pmem.h |  35 +++++++++
>  7 files changed, 350 insertions(+)
>  create mode 100644 drivers/nvdimm/nd_virtio.c
>  create mode 100644 drivers/nvdimm/virtio_pmem.c
>  create mode 100644 drivers/nvdimm/virtio_pmem.h
>  create mode 100644 include/uapi/linux/virtio_pmem.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
