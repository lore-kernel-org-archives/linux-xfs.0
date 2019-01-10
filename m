Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:54468 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbfAJB0W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jan 2019 20:26:22 -0500
Date: Thu, 10 Jan 2019 12:26:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Message-ID: <20190110012617.GA4205@dastard>
References: <20190109144736.17452-1-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109144736.17452-1-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com, dan.j.williams@intel.com, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, david@redhat.com, jmoyer@redhat.com, xiaoguangrong.eric@gmail.com, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, rjw@rjwysocki.net

On Wed, Jan 09, 2019 at 08:17:31PM +0530, Pankaj Gupta wrote:
>  This patch series has implementation for "virtio pmem". 
>  "virtio pmem" is fake persistent memory(nvdimm) in guest 
>  which allows to bypass the guest page cache. This also
>  implements a VIRTIO based asynchronous flush mechanism.  

Hmmmm. Sharing the host page cache direct into the guest VM. Sounds
like a good idea, but.....

This means the guest VM can now run timing attacks to observe host
side page cache residency, and depending on the implementation I'm
guessing that the guest will be able to control host side page
cache eviction, too (e.g. via discard or hole punch operations).

Which means this functionality looks to me like a new vector for
information leakage into and out of the guest VM via guest
controlled host page cache manipulation.

https://arxiv.org/pdf/1901.01161

I might be wrong, but if I'm not we're going to have to be very
careful about how guest VMs can access and manipulate host side
resources like the page cache.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
