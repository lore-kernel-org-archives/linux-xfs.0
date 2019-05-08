Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbfEHPXe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 May 2019 11:23:34 -0400
Date: Wed, 8 May 2019 11:23:32 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1482604497.27348783.1557329012320.JavaMail.zimbra@redhat.com>
In-Reply-To: <1555943483.27247564.1557313967518.JavaMail.zimbra@redhat.com>
References: <20190426050039.17460-1-pagupta@redhat.com> <20190426050039.17460-3-pagupta@redhat.com> <3d6479ae-6c39-d614-f1d9-aa1978e2e438@google.com> <1555943483.27247564.1557313967518.JavaMail.zimbra@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v7 2/6] virtio-pmem: Add virtio pmem driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jakub =?utf-8?Q?Staro=C5=84?= <jstaron@google.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, lcapitulino@redhat.com, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, dave jiang <dave.jiang@intel.com>, darrick wong <darrick.wong@oracle.com>, vishal l verma <vishal.l.verma@intel.com>, david@redhat.com, willy@infradead.org, hch@infradead.org, jmoyer@redhat.com, nilal@redhat.com, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>, kwolf@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, imammedo@redhat.com, smbarber@google.com


> > 
> > > +int virtio_pmem_flush(struct nd_region *nd_region)
> > > +{
> > > +        int err;
> > > +        unsigned long flags;
> > > +        struct scatterlist *sgs[2], sg, ret;
> > > +        struct virtio_device *vdev = nd_region->provider_data;
> > > +        struct virtio_pmem *vpmem = vdev->priv;
> > > +        struct virtio_pmem_request *req;
> > > +
> > > +        might_sleep();
> > > +        req = kmalloc(sizeof(*req), GFP_KERNEL);
> > > +        if (!req)
> > > +                return -ENOMEM;
> > > +
> > > +        req->done = req->wq_buf_avail = false;
> > > +        strcpy(req->name, "FLUSH");
> > > +        init_waitqueue_head(&req->host_acked);
> > > +        init_waitqueue_head(&req->wq_buf);
> > > +        sg_init_one(&sg, req->name, strlen(req->name));
> > > +        sgs[0] = &sg;
> > > +        sg_init_one(&ret, &req->ret, sizeof(req->ret));
> > > +        sgs[1] = &ret;
> > > +
> > > +        spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > > +        err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
> > > +        if (err) {
> > > +                dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");
> > > +
> > > +                list_add_tail(&vpmem->req_list, &req->list);
> > > +                spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > > +
> > > +                /* When host has read buffer, this completes via host_ack */
> > > +                wait_event(req->wq_buf, req->wq_buf_avail);
> > > +                spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > > +        }
> > 
> > Aren't the arguments in `list_add_tail` swapped? The element we are adding
> 

Yes, arguments for 'list_add_tail' should be swapped.

list_add_tail(&req->list, &vpmem->req_list);


Thank you,
Pankaj
