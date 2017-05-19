Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48114 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdESELV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 00:11:21 -0400
Date: Thu, 18 May 2017 21:07:31 -0700
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH v4 05/27] btrfs: btrfs_wait_tree_block_writeback can be
 void return
Message-ID: <20170519040731.GA30704@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-6-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-6-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com

On Tue, May 09, 2017 at 11:49:08AM -0400, Jeff Layton wrote:
> Nothing checks its return value.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/btrfs/disk-io.c | 6 +++---
>  fs/btrfs/disk-io.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index eb1ee7b6f532..8c479bd5534a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1222,10 +1222,10 @@ int btrfs_write_tree_block(struct extent_buffer *buf)
>  					buf->start + buf->len - 1);
>  }
>  
> -int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
> +void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
>  {
> -	return filemap_fdatawait_range(buf->pages[0]->mapping,
> -				       buf->start, buf->start + buf->len - 1);
> +	filemap_fdatawait_range(buf->pages[0]->mapping,
> +			        buf->start, buf->start + buf->len - 1);
>  }
>  
>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 2e0ec29bfd69..9cc87835abb5 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -127,7 +127,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
>  			extent_submit_bio_hook_t *submit_bio_done);
>  unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
>  int btrfs_write_tree_block(struct extent_buffer *buf);
> -int btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
> +void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
>  int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
>  			     struct btrfs_fs_info *fs_info);
>  int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
> -- 
> 2.9.3
> 
