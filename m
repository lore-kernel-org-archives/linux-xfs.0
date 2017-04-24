Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S972863AbdDXQEm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 12:04:42 -0400
Date: Mon, 24 Apr 2017 18:04:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 10/20] fuse: set mapping error in writepage_locked
 when it fails
Message-ID: <20170424160431.GK23988@quack2.suse.cz>
References: <20170424132259.8680-1-jlayton@redhat.com>
 <20170424132259.8680-11-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-11-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

On Mon 24-04-17 09:22:49, Jeff Layton wrote:
> This ensures that we see errors on fsync when writeback fails.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Hum, but do we really want to clobber mapping errors with temporary stuff
like ENOMEM? Or do you want to handle that in mapping_set_error?

								Honza

> ---
>  fs/fuse/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index ec238fb5a584..07d0efcb050c 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1669,6 +1669,7 @@ static int fuse_writepage_locked(struct page *page)
>  err_free:
>  	fuse_request_free(req);
>  err:
> +	mapping_set_error(page->mapping, error);
>  	end_page_writeback(page);
>  	return error;
>  }
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
