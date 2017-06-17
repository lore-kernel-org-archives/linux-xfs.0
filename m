Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34048 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752906AbdFQMj6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Jun 2017 08:39:58 -0400
Received: by mail-qk0-f171.google.com with SMTP id d14so8207434qkb.1
        for <linux-xfs@vger.kernel.org>; Sat, 17 Jun 2017 05:39:58 -0700 (PDT)
Message-ID: <1497703193.4684.9.camel@redhat.com>
Subject: Re: [PATCH v7 15/22] dax: set errors in mapping when writeback fails
From: Jeff Layton <jlayton@redhat.com>
Date: Sat, 17 Jun 2017 08:39:53 -0400
In-Reply-To: <20170616193427.13955-16-jlayton@redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
         <20170616193427.13955-16-jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Fri, 2017-06-16 at 15:34 -0400, Jeff Layton wrote:
> Jan Kara's description for this patch is much better than mine, so I'm
> quoting it verbatim here:
> 
> DAX currently doesn't set errors in the mapping when cache flushing
> fails in dax_writeback_mapping_range(). Since this function can get
> called only from fsync(2) or sync(2), this is actually as good as it can
> currently get since we correctly propagate the error up from
> dax_writeback_mapping_range() to filemap_fdatawrite()
> 
> However, in the future better writeback error handling will enable us to
> properly report these errors on fsync(2) even if there are multiple file
> descriptors open against the file or if sync(2) gets called before
> fsync(2). So convert DAX to using standard error reporting through the
> mapping.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-and-Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/dax.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 9899f07acf72..c663e8cc2a76 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -856,8 +856,10 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  
>  			ret = dax_writeback_one(bdev, dax_dev, mapping,
>  					indices[i], pvec.pages[i]);
> -			if (ret < 0)
> +			if (ret < 0) {
> +				mapping_set_error(mapping, ret);
>  				goto out;
> +			}
>  		}
>  	}
>  out:

I should point out here that Ross had an issue with this patch in an
earlier set, that I addressed with a flag in the last set. The flag is
icky though.

In this set, patch #6 should make it unnecessary:

    mm: clear AS_EIO/AS_ENOSPC when writeback initiation fails

Ross, could you test that this set still works ok for you with dax? It
should apply reasonably cleanly on top of linux-next.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
