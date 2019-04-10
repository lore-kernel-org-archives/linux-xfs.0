Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731971AbfDJOme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 10:42:34 -0400
Date: Wed, 10 Apr 2019 17:41:47 +0300
From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH v5 2/5] virtio-pmem: Add virtio pmem driver
Message-ID: <20190410144147.GA7947@lap1>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-3-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410040826.24371-3-pagupta@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com, pbonzini@redhat.com, kilobyte@angband.pl

> +
> +static int virtio_pmem_probe(struct virtio_device *vdev)
> +{
> +	int err = 0;
> +	struct resource res;
> +	struct virtio_pmem *vpmem;
> +	struct nvdimm_bus *nvdimm_bus;
> +	struct nd_region_desc ndr_desc = {};
> +	int nid = dev_to_node(&vdev->dev);
> +	struct nd_region *nd_region;
> +
> +	if (!vdev->config->get) {
> +		dev_err(&vdev->dev, "%s failure: config disabled\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	vdev->priv = vpmem = devm_kzalloc(&vdev->dev, sizeof(*vpmem),
> +					GFP_KERNEL);
> +	if (!vpmem) {
> +		err = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	vpmem->vdev = vdev;
> +	err = init_vq(vpmem);
> +	if (err)
> +		goto out_err;
> +
> +	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> +			start, &vpmem->start);
> +	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> +			size, &vpmem->size);
> +
> +	res.start = vpmem->start;
> +	res.end   = vpmem->start + vpmem->size-1;
> +	vpmem->nd_desc.provider_name = "virtio-pmem";
> +	vpmem->nd_desc.module = THIS_MODULE;
> +
> +	vpmem->nvdimm_bus = nvdimm_bus = nvdimm_bus_register(&vdev->dev,
> +						&vpmem->nd_desc);
> +	if (!nvdimm_bus)
> +		goto out_vq;
> +
> +	dev_set_drvdata(&vdev->dev, nvdimm_bus);
> +
> +	ndr_desc.res = &res;
> +	ndr_desc.numa_node = nid;
> +	ndr_desc.flush = virtio_pmem_flush;
> +	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> +	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> +	nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
> +	nd_region->provider_data =  dev_to_virtio

Pleas delete the extra space.

> +					(nd_region->dev.parent->parent);
> +
> +	if (!nd_region)
> +		goto out_nd;
> +
> +	return 0;
> +out_nd:
> +	err = -ENXIO;
> +	nvdimm_bus_unregister(nvdimm_bus);
> +out_vq:
> +	vdev->config->del_vqs(vdev);
> +out_err:
> +	dev_err(&vdev->dev, "failed to register virtio pmem memory\n");
> +	return err;
> +}
