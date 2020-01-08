Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69399C33C9B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E9CB205F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jFfbmLFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgAHIL6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:11:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAHIL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jNRCxeqVzK9MTvGrPR1z6iyg75WMPwCHdnh5/3NgoGc=; b=jFfbmLFo8YEZiOu4oIomttn5M
        WaTrXYCVMZKu+J5q2Kyfui0oTdV3fOuIt84wR8HPe34xbLAqh45LeP4zC6y9vK2E5j43boxW3TkRo
        +Sag/bWj5Lb5eugvvqBhoUQRC8Z66TxbKjuaBh7c9HSbWVzqjWmHmp3PK580hnrbg0v71mpomLYDf
        Aizt+MBEQKqulrXjnyhh9o9RcSBO0BujxPnJBjSUsyBKV8/3IW0KRQdWwxkxh+qXWBW2sEhJ7jyOk
        vLClT1Xly8/jvP6gpAcePU7rXRSzLSan90WF87sC6OOlXMWccpkvqL86Y8ayMNVwc2FPxsKSj2FR+
        2dwPvEo2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip6RZ-0008B3-Cn; Wed, 08 Jan 2020 08:11:57 +0000
Date:   Wed, 8 Jan 2020 00:11:57 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: truncate should remove all blocks, not just to
 the end of the page cache
Message-ID: <20200108081157.GB25201@infradead.org>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845706502.82882.5903950627987445484.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845706502.82882.5903950627987445484.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 08:17:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_itruncate_extents_flags() is supposed to unmap every block in a file
> from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
> bunmapi range, even though s_maxbytes reflects the highest offset the
> pagecache can support, not the highest offset that XFS supports.
> 
> The result of this confusion is that if you create a 20T file on a
> 64-bit machine, mount the filesystem on a 32-bit machine, and remove the
> file, we leak everything above 16T.  Fix this by capping the bunmapi
> request at the maximum possible block offset, not s_maxbytes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index fc3aec26ef87..79799ab30c93 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1518,7 +1518,6 @@ xfs_itruncate_extents_flags(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp = *tpp;
>  	xfs_fileoff_t		first_unmap_block;
> -	xfs_fileoff_t		last_block;
>  	xfs_filblks_t		unmap_len;
>  	int			error = 0;
>  
> @@ -1540,21 +1539,21 @@ xfs_itruncate_extents_flags(
>  	 * the end of the file (in a crash where the space is allocated
>  	 * but the inode size is not yet updated), simply remove any
>  	 * blocks which show up between the new EOF and the maximum
> -	 * possible file size.  If the first block to be removed is
> -	 * beyond the maximum file size (ie it is the same as last_block),
> -	 * then there is nothing to do.
> +	 * possible file size.
> +	 *
> +	 * We have to free all the blocks to the bmbt maximum offset, even if
> +	 * the page cache can't scale that far.
>  	 */
>  	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
> -	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> -	if (first_unmap_block == last_block)
> +	if (first_unmap_block == XFS_MAX_FILEOFF)
>  		return 0;
>  
> -	ASSERT(first_unmap_block < last_block);
> -	unmap_len = last_block - first_unmap_block + 1;
> -	while (!done) {
> +	ASSERT(first_unmap_block < XFS_MAX_FILEOFF);

Instead of the assert we could just do the early return for

	first_unmap_block >= XFS_MAX_FILEOFF

and throw in a WARN_ON_ONCE, as that condition really should be nothing
but a sanity check.

Otherwise this looks good to me.
