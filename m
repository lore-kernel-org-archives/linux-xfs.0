Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbfAMXiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Jan 2019 18:38:23 -0500
Date: Sun, 13 Jan 2019 15:38:21 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Message-ID: <20190113233820.GX6310@bombadil.infradead.org>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190110012617.GA4205@dastard>
 <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
 <20190113232902.GD4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190113232902.GD4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Pankaj Gupta <pagupta@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com, dan j williams <dan.j.williams@intel.com>, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, david@redhat.com, jmoyer@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net

On Mon, Jan 14, 2019 at 10:29:02AM +1100, Dave Chinner wrote:
> Until you have images (and hence host page cache) shared between
> multiple guests. People will want to do this, because it means they
> only need a single set of pages in host memory for executable
> binaries rather than a set of pages per guest. Then you have
> multiple guests being able to detect residency of the same set of
> pages. If the guests can then, in any way, control eviction of the
> pages from the host cache, then we have a guest-to-guest information
> leak channel.

I don't think we should ever be considering something that would allow a
guest to evict page's from the host's pagecache [1].  The guest should
be able to kick its own references to the host's pagecache out of its
own pagecache, but not be able to influence whether the host or another
guest has a read-only mapping cached.

[1] Unless the guest is allowed to modify the host's file; obviously
truncation, holepunching, etc are going to evict pages from the host's
page cache.
