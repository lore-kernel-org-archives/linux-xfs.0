Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbfAOFhY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jan 2019 00:37:24 -0500
Date: Tue, 15 Jan 2019 00:37:22 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <208236727.64320322.1547530642536.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190114205031-mutt-send-email-mst@kernel.org>
References: <20190109144736.17452-1-pagupta@redhat.com> <20190113232902.GD4205@dastard> <20190113233820.GX6310@bombadil.infradead.org> <942065073.64011540.1547450140670.JavaMail.zimbra@redhat.com> <20190114212501.GG4205@dastard> <CAPcyv4jtPcLV-s0sKNHwwk0ug7GLBV6699dpm1h3r2xSo879dg@mail.gmail.com> <20190114222132.GH4205@dastard> <20190114205031-mutt-send-email-mst@kernel.org>
Subject: Re: [Qemu-devel] [PATCH v3 0/5] kvm "virtio pmem" device
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Jason Wang <jasowang@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, dave jiang <dave.jiang@intel.com>, darrick wong <darrick.wong@oracle.com>, vishal l verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Rik van Riel <riel@surriel.com>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Dan Williams <dan.j.williams@intel.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>


> > > >
> > > > On Mon, Jan 14, 2019 at 02:15:40AM -0500, Pankaj Gupta wrote:
> > > > >
> > > > > > > Until you have images (and hence host page cache) shared between
> > > > > > > multiple guests. People will want to do this, because it means
> > > > > > > they
> > > > > > > only need a single set of pages in host memory for executable
> > > > > > > binaries rather than a set of pages per guest. Then you have
> > > > > > > multiple guests being able to detect residency of the same set of
> > > > > > > pages. If the guests can then, in any way, control eviction of
> > > > > > > the
> > > > > > > pages from the host cache, then we have a guest-to-guest
> > > > > > > information
> > > > > > > leak channel.
> > > > > >
> > > > > > I don't think we should ever be considering something that would
> > > > > > allow a
> > > > > > guest to evict page's from the host's pagecache [1].  The guest
> > > > > > should
> > > > > > be able to kick its own references to the host's pagecache out of
> > > > > > its
> > > > > > own pagecache, but not be able to influence whether the host or
> > > > > > another
> > > > > > guest has a read-only mapping cached.
> > > > > >
> > > > > > [1] Unless the guest is allowed to modify the host's file;
> > > > > > obviously
> > > > > > truncation, holepunching, etc are going to evict pages from the
> > > > > > host's
> > > > > > page cache.
> > > > >
> > > > > This is so correct. Guest does not not evict host page cache pages
> > > > > directly.
> > > >
> > > > They don't right now.
> > > >
> > > > But someone is going to end up asking for discard to work so that
> > > > the guest can free unused space in the underlying spares image (i.e.
> > > > make use of fstrim or mount -o discard) because they have workloads
> > > > that have bursts of space usage and they need to trim the image
> > > > files afterwards to keep their overall space usage under control.
> > > >
> > > > And then....
> > > 
> > > ...we reject / push back on that patch citing the above concern.
> > 
> > So at what point do we draw the line?
> > 
> > We're allowing writable DAX mappings, but as I've pointed out that
> > means we are going to be allowing  a potential information leak via
> > files with shared extents to be directly mapped and written to.
> > 
> > But we won't allow useful admin operations that allow better
> > management of host side storage space similar to how normal image
> > files are used by guests because it's an information leak vector?
> > 
> > That's splitting some really fine hairs there...
> 
> May I summarize that th security implications need to
> be documented?
> 
> In fact that would make a fine security implications section
> in the device specification.

This is a very good suggestion. 

I will document the security implications in details in device specification
with details of what all filesystem features we don't support and why.

Best regards,
Pankaj

> 
> 
> 
> 
> 
> > > > > In case of virtio-pmem & DAX, guest clears guest page cache
> > > > > exceptional entries.
> > > > > Its solely decision of host to take action on the host page cache
> > > > > pages.
> > > > >
> > > > > In case of virtio-pmem, guest does not modify host file directly i.e
> > > > > don't
> > > > > perform hole punch & truncation operation directly on host file.
> > > >
> > > > ... this will no longer be true, and the nuclear landmine in this
> > > > driver interface will have been armed....
> > > 
> > > I agree with the need to be careful when / if explicit cache control
> > > is added, but that's not the case today.
> > 
> > "if"?
> > 
> > I expect it to be "when", not if. Expect the worst, plan for it now.
> > 
> > Cheers,
> > 
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> 
> 
