Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61147 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbfAMX3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Jan 2019 18:29:08 -0500
Date: Mon, 14 Jan 2019 10:29:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Message-ID: <20190113232902.GD4205@dastard>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190110012617.GA4205@dastard>
 <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com, dan j williams <dan.j.williams@intel.com>, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, david@redhat.com, jmoyer@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net

On Fri, Jan 11, 2019 at 02:45:04AM -0500, Pankaj Gupta wrote:
> 
> > 
> > On Wed, Jan 09, 2019 at 08:17:31PM +0530, Pankaj Gupta wrote:
> > >  This patch series has implementation for "virtio pmem".
> > >  "virtio pmem" is fake persistent memory(nvdimm) in guest
> > >  which allows to bypass the guest page cache. This also
> > >  implements a VIRTIO based asynchronous flush mechanism.
> > 
> > Hmmmm. Sharing the host page cache direct into the guest VM. Sounds
> > like a good idea, but.....
> > 
> > This means the guest VM can now run timing attacks to observe host
> > side page cache residency, and depending on the implementation I'm
> > guessing that the guest will be able to control host side page
> > cache eviction, too (e.g. via discard or hole punch operations).
> 
> Not sure how? this is similar to mmapping virtual memory by any userspace 
> process. Any host userspace process can do such attack on host page cache
> using mincore & mmap shared file. 

Mincore is for monitoring, not cached eviction. And it's not
required to observe cache residency, either. That's a wide open
field containing an uncountable number of moles...

> But i don't think guest can do this alone. For virtio-pmem usecase
> guest won't be using page cache so timing attack from only guest
> side is not possible unless host userspace can run checks on page
> cache eviction state using mincore etc.  As rightly described by
> Rik, guest will only access its own page cache pages and if guest
> page cache is managed directly by host, this saves alot of effort
> for guest in transferring guest state of page cache.  

Until you have images (and hence host page cache) shared between
multiple guests. People will want to do this, because it means they
only need a single set of pages in host memory for executable
binaries rather than a set of pages per guest. Then you have
multiple guests being able to detect residency of the same set of
pages. If the guests can then, in any way, control eviction of the
pages from the host cache, then we have a guest-to-guest information
leak channel.

i.e. it's something we need to be aware of and really careful about
enabling infrastructure that /will/ be abused if guests can find a
way to influence the host side cache residency.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
