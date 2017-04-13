Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752196AbdDMTJe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 15:09:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9DCA75745
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 19:09:33 +0000 (UTC)
Date: Thu, 13 Apr 2017 21:09:28 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: handle array index overrun in
 xfs_dir2_leaf_readbuf()
Message-ID: <20170413190928.6d7lxlhi4wibbwoe@eorzea.usersys.redhat.com>
References: <9d5a5529-894d-bacd-501e-e0d9ece473b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d5a5529-894d-bacd-501e-e0d9ece473b8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolin@redhat.com>

On Thu, Apr 13, 2017 at 01:45:43PM -0500, Eric Sandeen wrote:
> Carlos had a case where "find" seemed to start spinning
> forever and never return.
> 
> This was on a filesystem with non-default multi-fsb (8k)
> directory blocks, and a fragmented directory with extents
> like this:
> 
> 0:[0,133646,2,0]
> 1:[2,195888,1,0]
> 2:[3,195890,1,0]
> 3:[4,195892,1,0]
> 4:[5,195894,1,0]
> 5:[6,195896,1,0]
> 6:[7,195898,1,0]
> 7:[8,195900,1,0]
> 8:[9,195902,1,0]
> 9:[10,195908,1,0]
> 10:[11,195910,1,0]
> 11:[12,195912,1,0]
> 12:[13,195914,1,0]
> ...
> 
> i.e. the first extent is a contiguous 2-fsb dir block, but
> after that it is fragmented into 1 block extents.
> 
> Huge appreciation for Carlos for debugging and isolating
> the problem.

Thank you :)
> 
> Debugged-and-analyzed-by: Carlos Maiolino <cmaiolin@redhat.com>
Darrick, if this goes in, could you change the email to <cmaiolino@redhat.com>?


The patch looks good to me, and I've tested it with the broken image I've been
working with, so, you can add:

Tested-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>



Thanks Eric
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index ad9396e..c45de72 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -394,6 +394,7 @@ struct xfs_dir2_leaf_map_info {
>  
>  	/*
>  	 * Do we need more readahead?
> +	 * Each loop tries to process 1 full dir blk; last may be partial.
>  	 */
>  	blk_start_plug(&plug);
>  	for (mip->ra_index = mip->ra_offset = i = 0;
> @@ -425,9 +426,14 @@ struct xfs_dir2_leaf_map_info {
>  		}
>  
>  		/*
> -		 * Advance offset through the mapping table.
> +		 * Advance offset through the mapping table, processing a full
> +		 * dir block even if it is fragmented into several extents.
> +		 * But stop if we have consumed all valid mappings, even if
> +		 * it's not yet a full directory block.
>  		 */
> -		for (j = 0; j < geo->fsbcount; j += length ) {
> +		for (j = 0;
> +		     j < geo->fsbcount && mip->ra_index < mip->map_valid;
> +		     j += length ) {
>  			/*
>  			 * The rest of this extent but not more than a dir
>  			 * block.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
