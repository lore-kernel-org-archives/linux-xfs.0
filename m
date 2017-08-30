Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751358AbdH3Mr1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 08:47:27 -0400
Date: Wed, 30 Aug 2017 14:47:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] ext4: Add iomap support for inline data
Message-ID: <20170830124724.GA31735@quack2.suse.cz>
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

Just one nit and one comment below. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>


> ---
>  fs/ext4/ext4.h   |  4 ++++
>  fs/ext4/inline.c | 33 +++++++++++++++++++++++++++++++++
>  fs/ext4/inode.c  | 10 ++++++++--
>  3 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index a2bb7d2870e4..017e55942a49 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3048,6 +3048,10 @@ extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
>  extern int ext4_inline_data_fiemap(struct inode *inode,
>  				   struct fiemap_extent_info *fieinfo,
>  				   int *has_inline, __u64 start, __u64 len);
> +
> +struct iomap;
> +extern int ext4_inline_data_iomap(struct inode *inode, struct iomap *iomap);
> +
>  extern int ext4_try_to_evict_inline_data(handle_t *handle,
>  					 struct inode *inode,
>  					 int needed);
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 28c5c3abddb3..21a078fef80f 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -12,6 +12,7 @@
>   * GNU General Public License for more details.
>   */
>  
> +#include <linux/iomap.h>
>  #include <linux/fiemap.h>
>  
>  #include "ext4_jbd2.h"
> @@ -1827,6 +1828,38 @@ int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
>  	return ret;
>  }
>  
> +int ext4_inline_data_iomap(struct inode *inode, struct iomap *iomap)
> +{
> +	__u64 addr;
> +	int error = -ENOENT;
> +	struct ext4_iloc iloc;
> +
> +	down_read(&EXT4_I(inode)->xattr_sem);
> +	if (!ext4_has_inline_data(inode))
> +		goto out;

Hum, ENOENT looks rather arbitrary for a lost race with inode conversion.
Maybe EAGAIN would be better? We use it in some other place as well to
indicate that inode has been converted...

> +
> +	error = ext4_get_inode_loc(inode, &iloc);
> +	if (error)
> +		goto out;

Using ext4_get_inode_loc() just to get block + offset of the inode is a bit
overkill since it will also allocate buffer_head, load the block with inode
from disk, etc. But since this is not performance critical and the buffer
is likely to be in cache anyway, I can live with this I guess.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
