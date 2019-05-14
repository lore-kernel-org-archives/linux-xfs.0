Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36718 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfENKCx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 May 2019 06:02:53 -0400
Date: Tue, 14 May 2019 06:02:48 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <919431491.28558886.1557828168896.JavaMail.zimbra@redhat.com>
In-Reply-To: <cd5572ac-14d0-f872-6321-c522daa70f49@redhat.com>
References: <20190510155202.14737-1-pagupta@redhat.com> <20190510155202.14737-3-pagupta@redhat.com> <f2ea35a6-ec98-447c-44fe-0cb3ab309340@redhat.com> <752392764.28554139.1557826022323.JavaMail.zimbra@redhat.com> <86298c2c-cc7c-5b97-0f11-335d7da8c450@redhat.com> <712871093.28555872.1557827242385.JavaMail.zimbra@redhat.com> <cd5572ac-14d0-f872-6321-c522daa70f49@redhat.com>
Subject: Re: [PATCH v8 2/6] virtio-pmem: Add virtio pmem driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Hildenbrand <david@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan j williams <dan.j.williams@intel.com>, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, darrick wong <darrick.wong@oracle.com>, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, pbonzini@redhat.com, kilobyte@angband.pl, yuval shaia <yuval.shaia@oracle.com>, jstaron@google.com


> >>
> >> I think you should do the same here, vdev->priv is allocated in
> >> virtio_pmem_probe.
> >>
> >> But maybe I am missing something important here :)
> > 
> > Because virtio_balloon use "kzalloc" for allocation and needs to be freed.
> > But virtio pmem uses "devm_kzalloc" which takes care of automatically
> > deleting
> > the device memory when associated device is detached.
> 
> Hehe, thanks, that was the part that I was missing!

Thank you for the review.

Best regards,
Pankaj
> 
> --
> 
> Thanks,
> 
> David / dhildenb
> 
