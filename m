Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39757 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934254AbcIZOtW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Sep 2016 10:49:22 -0400
Date: Mon, 26 Sep 2016 16:49:18 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/12] ext2: use iomap to implement DAX
Message-ID: <20160926144918.GG7733@quack2.suse.cz>
References: <1474025234-13804-1-git-send-email-hch@lst.de>
 <1474025234-13804-13-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474025234-13804-13-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, ross.zwisler@linux.intel.com

When looking through this patch I've noticed one bug:

On Fri 16-09-16 13:27:14, Christoph Hellwig wrote:
> +static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> +		unsigned flags, struct iomap *iomap)
> +{
...
> +	iomap->offset = first_block << blkbits;

Here is a missing cast to u64. Otherwise on 32-bit arch the shift could
overflow. I guess DAX is not expected to be used on 32-bit archs but
still... 

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
