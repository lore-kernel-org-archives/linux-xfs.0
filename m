Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45081 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755065AbcLSJg5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Dec 2016 04:36:57 -0500
Date: Fri, 16 Dec 2016 09:41:26 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 8/9] Revert "ext4: avoid deadlocks in the writeback path
 by using sb_getblk_gfp"
Message-ID: <20161216084126.GF26608@quack2.suse.cz>
References: <20161215140715.12732-1-mhocko@kernel.org>
 <20161215140715.12732-9-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215140715.12732-9-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

On Thu 15-12-16 15:07:14, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> This reverts commit c45653c341f5c8a0ce19c8f0ad4678640849cb86 because
> sb_getblk_gfp is not really needed as
> sb_getblk
>   __getblk_gfp
>     __getblk_slow
>       grow_buffers
>         grow_dev_page
> 	  gfp_mask = mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS) | gfp
> 
> so __GFP_FS is cleared unconditionally and therefore the above commit
> didn't have any real effect in fact.
> 
> This patch should not introduce any functional change. The main point
> of this change is to reduce explicit GFP_NOFS usage inside ext4 code to
> make the review of the remaining usage easier.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b1f8416923ab..ef815eb72389 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -518,7 +518,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
>  	struct buffer_head		*bh;
>  	int				err;
>  
> -	bh = sb_getblk_gfp(inode->i_sb, pblk, __GFP_MOVABLE | GFP_NOFS);
> +	bh = sb_getblk(inode->i_sb, pblk);
>  	if (unlikely(!bh))
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -1096,7 +1096,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
>  		err = -EFSCORRUPTED;
>  		goto cleanup;
>  	}
> -	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
> +	bh = sb_getblk(inode->i_sb, newblock);
>  	if (unlikely(!bh)) {
>  		err = -ENOMEM;
>  		goto cleanup;
> @@ -1290,7 +1290,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>  	if (newblock == 0)
>  		return err;
>  
> -	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
> +	bh = sb_getblk(inode->i_sb, newblock);
>  	if (unlikely(!bh))
>  		return -ENOMEM;
>  	lock_buffer(bh);
> -- 
> 2.10.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
