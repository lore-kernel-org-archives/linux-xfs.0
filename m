Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50456 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750897AbdGYMpP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 08:45:15 -0400
Date: Tue, 25 Jul 2017 14:45:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170725124511.GG19943@quack2.suse.cz>
References: <20170629135420.21357-1-hch@lst.de>
 <20170629135420.21357-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629135420.21357-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu 29-06-17 06:54:20, Christoph Hellwig wrote:
> @@ -3359,6 +3358,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	unsigned long first_block = offset >> blkbits;
>  	unsigned long last_block = (offset + length - 1) >> blkbits;
>  	struct ext4_map_blocks map;
> +	bool delalloc = false;
>  	int ret;
>  
>  	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> @@ -3369,6 +3369,27 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  
>  	if (!(flags & IOMAP_WRITE)) {
>  		ret = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (!ret) {
> +			struct extent_status es = {};
> +
> +			ext4_es_find_delayed_extent_range(inode, map.m_lblk,
> +					map.m_lblk + map.m_len - 1, &es);
> +			/* Is delalloc data before next block in extent tree? */
> +			if (es.es_len && es.es_lblk < map.m_lblk + map.m_len) {
> +				ext4_lblk_t offset = 0;
> +
> +				if (es.es_lblk < map.m_lblk)
> +					offset = map.m_lblk - es.es_lblk;
> +				map.m_lblk = es.es_lblk + offset;
> +				map.m_pblk = ext4_es_pblock(&es) + offset;

This is wrong for delalloc extent - adding offset to some magic block
value...

> +				map.m_len = es.es_len - offset;
> +				if (ext4_es_status(&es) & EXTENT_STATUS_UNWRITTEN)
> +					map.m_flags |= EXT4_MAP_UNWRITTEN;
> +				if (ext4_es_status(&es) & EXTENT_STATUS_DELAYED)
> +					delalloc = true;
> +				ret = 1;
> +			}
> +		}

Also the delalloc handling seems to be wrong that if we have file as:

HD

where H is hole, D is delalloc block, and iomap is called at offset 0, we
should be getting back "hole at 0" back but instead you will return
"delalloc at 1".

We deal with a similar situation in ext4_da_map_blocks() so it would be
good if we could reuse that one rather than reimplementing it here. But
factoring the necessary functionality out isn't that easy.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
