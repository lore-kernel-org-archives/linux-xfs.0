Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbfAMBin (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 12 Jan 2019 20:38:43 -0500
Date: Sat, 12 Jan 2019 20:38:39 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1354249849.63357171.1547343519970.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190110101757.GC15790@quack2.suse.cz>
References: <20190109144736.17452-1-pagupta@redhat.com> <20190110012617.GA4205@dastard> <20190110101757.GC15790@quack2.suse.cz>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, stefanha@redhat.com, dan j williams <dan.j.williams@intel.com>, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, david@redhat.com, jmoyer@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net



> 
> On Thu 10-01-19 12:26:17, Dave Chinner wrote:
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
> > 
> > Which means this functionality looks to me like a new vector for
> > information leakage into and out of the guest VM via guest
> > controlled host page cache manipulation.
> > 
> > https://arxiv.org/pdf/1901.01161
> > 
> > I might be wrong, but if I'm not we're going to have to be very
> > careful about how guest VMs can access and manipulate host side
> > resources like the page cache.....
> 
> Right. Thinking about this I would be more concerned about the fact that
> guest can effectively pin amount of host's page cache upto size of the
> device/file passed to guest as PMEM, can't it Pankaj? Or is there some QEMU
> magic that avoids this?

Yes, guest will pin these host page cache pages using 'get_user_pages' by
elevating the page reference count. But these pages can be reclaimed by host
at any time when there is memory pressure.

KVM does not permanently pin pages. vfio does that but we are not using
it here.

Could you please elaborate what you are thinking?

Thanks,
Pankaj
