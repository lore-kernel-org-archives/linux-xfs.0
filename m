Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-sn1nam01on0099.outbound.protection.outlook.com ([104.47.32.99]:26432
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753490AbcIJEM2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Sep 2016 00:12:28 -0400
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Sat, 10 Sep 2016 01:38:59 +0000
Message-ID: <DF4PR84MB0169843EFC69F8B00E19C9EFABFD0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
In-Reply-To: <1473438884-674-7-git-send-email-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of Christoph Hellwig
> Sent: Friday, September 09, 2016 11:35 AM
> Subject: [PATCH 06/10] dax: provide an iomap based fault handler
> 
...
> diff --git a/fs/dax.c b/fs/dax.c
> @@ -1343,4 +1343,117 @@ iomap_dax_rw(struct kiocb *iocb, struct
...
> +	default:
> +		WARN_ON_ONCE(1);
> +		error = -EIO;
> +	}
> +
> +	/* Filesystem should not return unwritten buffers to us! */
> +	error = dax_insert_mapping(mapping, iomap.bdev, sector, PAGE_SIZE,
> +			&entry, vma, vmf);

That -EIO value would be immediately overwritten.


