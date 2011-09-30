Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8UEfPNH007132 for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 09:41:26 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAFED19E910
	for <xfs@oss.sgi.com>; Fri, 30 Sep 2011 07:41:24 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id AlneazPPhDFlSR6l for <xfs@oss.sgi.com>;
	Fri, 30 Sep 2011 07:41:24 -0700 (PDT)
Date: Fri, 30 Sep 2011 16:41:22 +0200
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 4/5] mm: filemap: pass __GFP_WRITE from
	grab_cache_page_write_begin()
Message-ID: <20110930144122.GD869@tiehlicka.suse.cz>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-5-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317367044-475-5-git-send-email-jweiner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, Shaohua Li <shaohua.li@intel.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On Fri 30-09-11 09:17:23, Johannes Weiner wrote:
> Tell the page allocator that pages allocated through
> grab_cache_page_write_begin() are expected to become dirty soon.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/filemap.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 645a080..cf0352d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2349,8 +2349,11 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
>  					pgoff_t index, unsigned flags)
>  {
>  	int status;
> +	gfp_t gfp_mask;
>  	struct page *page;
>  	gfp_t gfp_notmask = 0;
> +
> +	gfp_mask = mapping_gfp_mask(mapping) | __GFP_WRITE;
>  	if (flags & AOP_FLAG_NOFS)
>  		gfp_notmask = __GFP_FS;
>  repeat:
> @@ -2358,7 +2361,7 @@ repeat:
>  	if (page)
>  		goto found;
>  
> -	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
> +	page = __page_cache_alloc(gfp_mask & ~gfp_notmask);
>  	if (!page)
>  		return NULL;
>  	status = add_to_page_cache_lru(page, mapping, index,
> -- 
> 1.7.6.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
