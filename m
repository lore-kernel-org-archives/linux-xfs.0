Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:26058 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754035AbeCFWWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 17:22:13 -0500
Date: Wed, 7 Mar 2018 09:22:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] Get rid of XFS_BUF_PTR() macro
Message-ID: <20180306222210.GL18129@dastard>
References: <20180306130053.13958-1-cmaiolino@redhat.com>
 <20180306130053.13958-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306130053.13958-2-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 06, 2018 at 02:00:50PM +0100, Carlos Maiolino wrote:
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
.....
> @@ -275,9 +275,9 @@ newfile(
>  		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
>  		bp = libxfs_trans_get_buf(logit ? tp : 0, mp->m_dev, d,
>  			nb << mp->m_blkbb_log, 0);
> -		memmove(XFS_BUF_PTR(bp), buf, len);
> +		memmove(bp->b_addr, buf, len);
>  		if (len < XFS_BUF_COUNT(bp))
> -			memset(XFS_BUF_PTR(bp) + len, 0, XFS_BUF_COUNT(bp) - len);
> +			memset(bp->b_addr + len, 0, XFS_BUF_COUNT(bp) - len);

Bug there. pointer arithmetic changed, needs (char *) cast.

>  	/* OK, now write the superblock... */
>  	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
>  	buf->b_ops = &xfs_sb_buf_ops;
> -	memset(XFS_BUF_PTR(buf), 0, cfg->sectorsize);
> -	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
> +	memset(buf->b_addr, 0, cfg->sectorsize);
> +	libxfs_sb_to_disk((void *)buf->b_addr, sbp);

Kill the cast - b_addr is already a void *

> @@ -3382,8 +3382,8 @@ initialise_ag_headers(
>  			XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
>  			XFS_FSS_TO_BB(mp, 1));
>  	buf->b_ops = &xfs_sb_buf_ops;
> -	memset(XFS_BUF_PTR(buf), 0, cfg->sectorsize);
> -	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
> +	memset(buf->b_addr, 0, cfg->sectorsize);
> +	libxfs_sb_to_disk((void *)buf->b_addr, sbp);

ditto.

> +++ b/repair/agheader.c
> @@ -290,8 +290,8 @@ secondary_sb_whack(
>  			+ sizeof(sb->sb_dirblklog);
>  
>  	/* Check the buffer we read from disk for garbage outside size */
> -	for (ip = XFS_BUF_PTR(sbuf) + size;
> -	     ip < XFS_BUF_PTR(sbuf) + mp->m_sb.sb_sectsize;
> +	for (ip = sbuf->b_addr + size;
> +	     ip < (char *)sbuf->b_addr + mp->m_sb.sb_sectsize;

Looks like another pointer math bug there...

>  	     ip++)  {
>  		if (*ip)  {
>  			do_bzero = 1;
> @@ -314,7 +314,7 @@ secondary_sb_whack(
>  			memcpy(&tmpuuid, &sb->sb_meta_uuid, sizeof(uuid_t));
>  			memset((void *)((intptr_t)sb + size), 0,
>  				mp->m_sb.sb_sectsize - size);
> -			memset(XFS_BUF_PTR(sbuf) + size, 0,
> +			memset(sbuf->b_addr + size, 0,

And another.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
