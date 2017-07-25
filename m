Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47654 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750732AbdGYMQw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 08:16:52 -0400
Date: Tue, 25 Jul 2017 14:16:44 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 3/3] ext4: Add IOMAP_REPORT support for inline data
Message-ID: <20170725121644.GF19943@quack2.suse.cz>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
 <1499462881-4238-4-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499462881-4238-4-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri 07-07-17 23:28:01, Andreas Gruenbacher wrote:
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 82f3f7d..e2b0a8a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3361,8 +3361,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	bool delalloc = false;
>  	int ret;
>  
> -	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> -		return -ERANGE;
> +	if (ext4_has_inline_data(inode)) {
> +		if (WARN_ON_ONCE(!(flags & IOMAP_REPORT)))
> +			return -ERANGE;
> +		if (!ext4_inline_data_iomap(inode, iomap) &&
> +		    offset < iomap->length)

Hum, what's the thinking behind this "offset < iomap->length" check? If it
fails, we'd just fall through to the normal case which I'm not sure is
guaranteed to be safe? Shouldn't we return error instead?

								Honza

> +			return 0;
> +	}
>  
>  	map.m_lblk = first_block;
>  	map.m_len = last_block - first_block + 1;
> -- 
> 2.7.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
