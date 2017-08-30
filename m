Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751394AbdH3NDd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 09:03:33 -0400
Date: Wed, 30 Aug 2017 14:54:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] ext4: Add iomap support for inline data
Message-ID: <20170830125431.GB31735@quack2.suse.cz>
References: <20170829142942.21594-1-agruenba@redhat.com>
 <20170829142942.21594-4-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829142942.21594-4-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Tue 29-08-17 16:29:41, Andreas Gruenbacher wrote:
> Report inline data as an IOMAP_F_DATA_INLINE mapping.  This allows to
> switch to iomap_seek_hole and iomap_seek_data in ext4_llseek, and will
> make switching to iomap_fiemap in ext4_fiemap easier as well.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

...

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 429f0afde9f2..ab6ab835255e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3411,8 +3411,14 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	struct ext4_map_blocks map;
>  	int ret;
>  
> -	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> -		return -ERANGE;
> +	if ((flags & IOMAP_REPORT) && ext4_has_inline_data(inode)) {
> +		ret = ext4_inline_data_iomap(inode, iomap);
> +		if (ret != -ENOENT) {
> +			if (ret == 0 && offset >= iomap->length)
> +				ret = -ENOENT;
> +			return ret;
> +		}
> +	}

One more thing: Please keep that WARN_ON and bail out for !IOMAP_REPORT
cases. Thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
