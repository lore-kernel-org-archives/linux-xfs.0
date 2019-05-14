Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37804 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfENPKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 May 2019 11:10:03 -0400
Subject: Re: [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
References: <20190514145422.16923-1-pagupta@redhat.com>
 <20190514145422.16923-3-pagupta@redhat.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c22d42f6-ef94-0310-36f2-e9085d3464c2@infradead.org>
Date: Tue, 14 May 2019 08:09:03 -0700
MIME-Version: 1.0
In-Reply-To: <20190514145422.16923-3-pagupta@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, kilobyte@angband.pl, yuval.shaia@oracle.com, jstaron@google.com

On 5/14/19 7:54 AM, Pankaj Gupta wrote:
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 35897649c24f..94bad084ebab 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -42,6 +42,17 @@ config VIRTIO_PCI_LEGACY
>  
>  	  If unsure, say Y.
>  
> +config VIRTIO_PMEM
> +	tristate "Support for virtio pmem driver"
> +	depends on VIRTIO
> +	depends on LIBNVDIMM
> +	help
> +	This driver provides access to virtio-pmem devices, storage devices
> +	that are mapped into the physical address space - similar to NVDIMMs
> +	 - with a virtio-based flushing interface.
> +
> +	If unsure, say M.

<beep>
from Documentation/process/coding-style.rst:
"Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces."

> +
>  config VIRTIO_BALLOON
>  	tristate "Virtio balloon driver"
>  	depends on VIRTIO

thanks.
-- 
~Randy
