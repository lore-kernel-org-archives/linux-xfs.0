Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43967 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfEQARt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 May 2019 20:17:49 -0400
Received: by mail-pg1-f195.google.com with SMTP id t22so2347240pgi.10
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 17:17:49 -0700 (PDT)
Subject: Re: [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
References: <20190514145422.16923-1-pagupta@redhat.com>
 <20190514145422.16923-3-pagupta@redhat.com>
From: =?UTF-8?Q?Jakub_Staro=c5=84?= <jstaron@google.com>
Message-ID: <c06514fd-8675-ba74-4b7b-ff0eb4a91605@google.com>
Date: Thu, 16 May 2019 17:12:36 -0700
MIME-Version: 1.0
In-Reply-To: <20190514145422.16923-3-pagupta@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, kilobyte@angband.pl, yuval.shaia@oracle.com, smbarber@google.com

On 5/14/19 7:54 AM, Pankaj Gupta wrote:
> +		if (!list_empty(&vpmem->req_list)) {
> +			req_buf = list_first_entry(&vpmem->req_list,
> +					struct virtio_pmem_request, list);
> +			req_buf->wq_buf_avail = true;
> +			wake_up(&req_buf->wq_buf);
> +			list_del(&req_buf->list);
Yes, this change is the right one, thank you!

> +	 /*
> +	  * If virtqueue_add_sgs returns -ENOSPC then req_vq virtual
> +	  * queue does not have free descriptor. We add the request
> +	  * to req_list and wait for host_ack to wake us up when free
> +	  * slots are available.
> +	  */
> +	while ((err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req,
> +					GFP_ATOMIC)) == -ENOSPC) {
> +
> +		dev_err(&vdev->dev, "failed to send command to virtio pmem" \
> +			"device, no free slots in the virtqueue\n");
> +		req->wq_buf_avail = false;
> +		list_add_tail(&req->list, &vpmem->req_list);
> +		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> +
> +		/* A host response results in "host_ack" getting called */
> +		wait_event(req->wq_buf, req->wq_buf_avail);
> +		spin_lock_irqsave(&vpmem->pmem_lock, flags);
> +	}
> +	err1 = virtqueue_kick(vpmem->req_vq);
> +	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> +
> +	/*
> +	 * virtqueue_add_sgs failed with error different than -ENOSPC, we can't
> +	 * do anything about that.
> +	 */
> +	if (err || !err1) {
> +		dev_info(&vdev->dev, "failed to send command to virtio pmem device\n");
> +		err = -EIO;
> +	} else {
> +		/* A host repsonse results in "host_ack" getting called */
> +		wait_event(req->host_acked, req->done);
> +		err = req->ret;
> +I confirm that the failures I was facing with the `-ENOSPC` error path are not present in v9.

Best,
Jakub Staron
