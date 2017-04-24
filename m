Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S972523AbdDXP57 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 11:57:59 -0400
Date: Mon, 24 Apr 2017 17:57:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 09/20] 9p: set mapping error when writeback fails in
 launder_page
Message-ID: <20170424155755.GJ23988@quack2.suse.cz>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-10-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-10-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

On Mon 24-04-17 09:22:48, Jeff Layton wrote:
> launder_page is just writeback under the page lock. We still need to
> mark the mapping for errors there when they occur.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/9p/vfs_addr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> index adaf6f6dd858..7af6e6501698 100644
> --- a/fs/9p/vfs_addr.c
> +++ b/fs/9p/vfs_addr.c
> @@ -223,8 +223,11 @@ static int v9fs_launder_page(struct page *page)
>  	v9fs_fscache_wait_on_page_write(inode, page);
>  	if (clear_page_dirty_for_io(page)) {
>  		retval = v9fs_vfs_writepage_locked(page);
> -		if (retval)
> +		if (retval) {
> +			if (retval != -EAGAIN)
> +				mapping_set_error(page->mapping, retval);
>  			return retval;
> +		}
>  	}
>  	return 0;
>  }
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
