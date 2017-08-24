Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751348AbdHXK4h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 06:56:37 -0400
Date: Thu, 24 Aug 2017 12:56:35 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] xfs: Drop setting redundant PF_KSWAPD in kswapd context
Message-ID: <20170824105635.GA5965@dhcp22.suse.cz>
References: <20170824104247.8288-1-khandual@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824104247.8288-1-khandual@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, dchinner@redhat.com, bfoster@redhat.com, sandeen@sandeen.net

On Thu 24-08-17 16:12:47, Anshuman Khandual wrote:
> xfs_btree_split() calls xfs_btree_split_worker() with args.kswapd set
> if current->flags alrady has PF_KSWAPD. Hence we should not again add
> PF_KSWAPD into the current flags inside kswapd context. So drop this
> redundant flag addition.

I am not familiar with the code but your change seems incorect. The
whole point of args->kswapd is to convey the kswapd context to the
worker which is obviously running in a different context. So this patch
loses the kswapd context.

> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index e0bcc4a..b3c85e3 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2895,7 +2895,7 @@ struct xfs_btree_split_args {
>  	 * in any way.
>  	 */
>  	if (args->kswapd)
> -		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> +		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE;
>  
>  	current_set_flags_nested(&pflags, new_pflags);
>  
> -- 
> 1.8.5.2

-- 
Michal Hocko
SUSE Labs
