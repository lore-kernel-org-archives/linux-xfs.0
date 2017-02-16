Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35964 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdBPDcE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 22:32:04 -0500
Date: Wed, 15 Feb 2017 19:31:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_metadump: ignore attr leaf with 0 entries
Message-ID: <20170216033158.GH6813@birch.djwong.org>
References: <7481b076-dbc6-ddaa-4e3f-9a1bc2b94e26@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7481b076-dbc6-ddaa-4e3f-9a1bc2b94e26@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Feb 02, 2017 at 09:54:56AM -0600, Eric Sandeen wrote:
> Another in the ongoing saga of attribute leaves with zero
> entries; in this case, if we try to metadump an inode with
> a zero-entries attribute leaf, the zeroing code will go off
> the rails and segfault at:
> 
>                 memset(&entries[nentries], 0,
>                        first_name - (char *)&entries[nentries]);
> 
> because first_name is null, and we try to memset a large
> (negative) number.

So what /does/ get metadumped in the !nentries case?  Is it the block
header and whatever else happens to be on disk?  I guess that's useful
for diagnostic purposes, since we don't know what's really "stale" when
the block is obviously bad.  (I was eyeing zero_stale_data but then
convinced myself it was fine to just exit.)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 38519f1..66952f6 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1654,7 +1654,8 @@ process_attr_block(
>  	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
>  
>  	nentries = hdr.count;
> -	if (nentries * sizeof(xfs_attr_leaf_entry_t) +
> +	if (nentries == 0 ||
> +	    nentries * sizeof(xfs_attr_leaf_entry_t) +
>  			xfs_attr3_leaf_hdr_size(leaf) >
>  				XFS_ATTR3_RMT_BUF_SPACE(mp, bs)) {
>  		if (show_warnings)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
