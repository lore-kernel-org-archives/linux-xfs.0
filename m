Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750848AbdHaIZS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 04:25:18 -0400
Date: Thu, 31 Aug 2017 10:25:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 1/4] dax: introduce a fs_dax_get_by_bdev() helper
Message-ID: <20170831082515.GF7897@quack2.suse.cz>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150412223265.10177.11004612169458058274.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150412223265.10177.11004612169458058274.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org

On Wed 30-08-17 12:43:52, Dan Williams wrote:
> Add a helper that can replace the following common pattern:
> 
> 	if (blk_queue_dax(bdev->bd_queue))
> 		fs_dax_get_by_host(bdev->bd_disk->disk_name);
> 
> This will be used to move dax_device lookup from iomap-operation time to
> fs-mount time.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
