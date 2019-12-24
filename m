Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F94CC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3C2206B7
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mrcq6Kkn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfLXIZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 03:25:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfLXIZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 03:25:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vWK2MfrYUPbsPGt8CVIB59N4KWaia3vhv7LZ0kOZSPE=; b=Mrcq6KknMv65DxjwyRa3Ju6bA
        hZOAZMF4me7wq49nu8WfdING7AOT93LgP/xQmTivP3SCAJmcCu5GNYZX1a+Hjuu3V4fEheWtqoXLY
        FDTJTV9f0uYrJe/rPcp6y7+v7coZDIKpIlINWkKJjDyl/LUngjVFnU2PyRhnPVjbvn2xPGgMrjbUs
        3LOi5+Yq2nxKtqVAuJyg2jF3pWF379Qa+USycDBQvX0D1xQNTSlt/HHs90YRptY/yWRabS/0EGI/C
        HtqpBnnw1yNAgHH4nyI5usDIjYbc3ZWZTY12r9NpWwB/9ISudxLaNMxaIqOySgqFOnpKb/fPfMRvA
        WhcQVOH7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijfUy-000423-3r; Tue, 24 Dec 2019 08:25:00 +0000
Date:   Tue, 24 Dec 2019 00:25:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix s_maxbytes computation on 32-bit kernels
Message-ID: <20191224082500.GB26649@infradead.org>
References: <20191222163711.GT7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191222163711.GT7489@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 22, 2019 at 08:37:11AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I observed a hang in generic/308 while running fstests on a i686 kernel.
> The hang occurred when trying to purge the pagecache on a large sparse
> file that had a page created past MAX_LFS_FILESIZE, which caused an
> integer overflow in the pagecache xarray and resulted in an infinite
> loop.
> 
> I then noticed that Linus changed the definition of MAX_LFS_FILESIZE in
> commit 0cc3b0ec23ce ("Clarify (and fix) MAX_LFS_FILESIZE macros") so
> that it is now one page short of the maximum page index on 32-bit
> kernels.  Because the XFS function to compute max offset open-codes the
> 2005-era MAX_LFS_FILESIZE computation and neither the vfs nor mm perform
> any sanity checking of s_maxbytes, the code in generic/308 can create a
> page above the pagecache's limit and kaboom.
> 
> So, fix the function to return MAX_LFS_FILESIZE, but check that bmbt
> record offsets have enough space to handle that many bytes.  I have no
> answer for why this seems to have been broken for years and nobody
> noticed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_super.c |   37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d9ae27ddf253..30a17e5ffa67 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -193,30 +193,25 @@ xfs_fs_show_options(
>  	return 0;
>  }
>  
> -static uint64_t
> +static loff_t
>  xfs_max_file_offset(
> -	unsigned int		blockshift)
> +	struct xfs_mount	*mp)
>  {
> -	unsigned int		pagefactor = 1;
> -	unsigned int		bitshift = BITS_PER_LONG - 1;
> -
> -	/* Figure out maximum filesize, on Linux this can depend on
> -	 * the filesystem blocksize (on 32 bit platforms).
> -	 * __block_write_begin does this in an [unsigned] long long...
> -	 *      page->index << (PAGE_SHIFT - bbits)
> -	 * So, for page sized blocks (4K on 32 bit platforms),
> -	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
> -	 *      (((u64)PAGE_SIZE << (BITS_PER_LONG-1))-1)
> -	 * but for smaller blocksizes it is less (bbits = log2 bsize).
> +	/*
> +	 * XFS block mappings use 54 bits to store the logical block offset.
> +	 * This should suffice to handle the maximum file size that the VFS
> +	 * supports (currently 2^63 bytes on 64-bit and ULONG_MAX << PAGE_SHIFT
> +	 * bytes on 32-bit), but as XFS and VFS have gotten the s_maxbytes
> +	 * calculation wrong on 32-bit kernels in the past, we'll add a WARN_ON
> +	 * to check this assertion before returning MAX_LFS_FILESIZE.
> +	 *
> +	 * Avoid integer overflow by comparing the maximum bmbt offset to the
> +	 * maximum pagecache offset in units of fs blocks.
>  	 */
> +	WARN_ON(((1ULL << BMBT_STARTOFF_BITLEN) - 1) <
> +		XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE));
>  
> -#if BITS_PER_LONG == 32
> -	ASSERT(sizeof(sector_t) == 8);
> -	pagefactor = PAGE_SIZE;
> -	bitshift = BITS_PER_LONG;
> -#endif
> -
> -	return (((uint64_t)pagefactor) << bitshift) - 1;
> +	return MAX_LFS_FILESIZE;
>  }
>  
>  /*
> @@ -1435,7 +1430,7 @@ xfs_fc_fill_super(
>  	sb->s_magic = XFS_SUPER_MAGIC;
>  	sb->s_blocksize = mp->m_sb.sb_blocksize;
>  	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
> -	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
> +	sb->s_maxbytes = xfs_max_file_offset(mp);

The code organization is really weird now.  Just assign MAX_LFS_FILESIZE
to s_maxbytes directly here, and move the WARN_ON right next to it -
preferably as a WARN_ON_ONCE with an actual error return instead of
just warning.
