Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753671AbcJKSyq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Oct 2016 14:54:46 -0400
Date: Tue, 11 Oct 2016 08:50:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 07/17] dax: remove the last BUG_ON() from fs/dax.c
Message-ID: <20161011065001.GB6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-8-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475874544-24842-8-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Fri 07-10-16 15:08:54, Ross Zwisler wrote:
> Don't take down the kernel if we get an invalid 'from' and 'length'
> argument pair.  Just warn once and return an error.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/dax.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ac28cdf..98189ac 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1194,7 +1194,8 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
>  	/* Block boundary? Nothing to do */
>  	if (!length)
>  		return 0;
> -	BUG_ON((offset + length) > PAGE_SIZE);
> +	if (WARN_ON_ONCE((offset + length) > PAGE_SIZE))
> +		return -EINVAL;
>  
>  	memset(&bh, 0, sizeof(bh));
>  	bh.b_bdev = inode->i_sb->s_bdev;
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
