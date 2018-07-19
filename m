Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32932 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731784AbeGSQaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 12:30:06 -0400
Received: by mail-wm0-f68.google.com with SMTP id z6-v6so2090889wma.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 08:46:19 -0700 (PDT)
Date: Thu, 19 Jul 2018 17:46:16 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/8] xfs: check leaf attribute block freemap in
 verifier
Message-ID: <20180719154616.linuazyn3hadoslj@odin.usersys.redhat.com>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192903434.31685.282625226695514597.stgit@magnolia>
 <20180719152516.GG4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719152516.GG4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Thu, Jul 19, 2018 at 08:25:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the leaf attribute freemap when we're verifying the block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> v2: add comments about alignment
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 

Thanks for the comment and explanation

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 76e90046731c..a673037c7d37 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -244,6 +244,8 @@ xfs_attr3_leaf_verify(
>  	struct xfs_attr_leafblock	*leaf = bp->b_addr;
>  	struct xfs_perag		*pag = bp->b_pag;
>  	struct xfs_attr_leaf_entry	*entries;
> +	uint16_t			end;
> +	int				i;
>  
>  	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
>  
> @@ -289,6 +291,26 @@ xfs_attr3_leaf_verify(
>  	/* XXX: need to range check rest of attr header values */
>  	/* XXX: hash order check? */
>  
> +	/*
> +	 * Quickly check the freemap information.  Attribute data has to be
> +	 * aligned to 4-byte boundaries, and likewise for the free space.
> +	 */
> +	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
> +		if (ichdr.freemap[i].base > mp->m_attr_geo->blksize)
> +			return __this_address;
> +		if (ichdr.freemap[i].base & 0x3)
> +			return __this_address;
> +		if (ichdr.freemap[i].size > mp->m_attr_geo->blksize)
> +			return __this_address;
> +		if (ichdr.freemap[i].size & 0x3)
> +			return __this_address;
> +		end = ichdr.freemap[i].base + ichdr.freemap[i].size;
> +		if (end < ichdr.freemap[i].base)
> +			return __this_address;
> +		if (end > mp->m_attr_geo->blksize)
> +			return __this_address;
> +	}
> +
>  	return NULL;
>  }
>  

-- 
Carlos
