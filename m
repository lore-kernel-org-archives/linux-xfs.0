Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FEEC33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBA4206B7
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mo6PZRha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgAQG76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:59:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgAQG76 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=f65oLRZZYm9tSetjMUi4vf9Cink6SP0ged+reu1UN70=; b=mo6PZRhaOXkh+3f5OA5rNrtWF
        s4yxrWo/D1zFq5lJ7ngK9iCLUjLpEJTEdj3Tc0RlKWEm244JWYg4H4zzsIfrlrTk6fzqi2gsARpmi
        2Txv7dmpRXUUPGOO+vyjy2zecOXd0bbNbHjPsY5OVzM7WI2b6ZRn60m06BN9H1emAYJevgjjlCKCa
        ANs1JQRJzIBWiXqKFsy5/Aoj7n082AGXTYHdM6qSAsIqw+PMWCPMrvtlcoIGHy8DFqFCvPMU+K7JK
        sdxpZawzOSeoaOL25WkWPzhEJVTnV3wj9zcpvZYPNpXXLM2HBKoBDWgx4YnvhlAff3dXtfLo8HeYD
        BTzPpA2eA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isLbp-0007zD-Lo; Fri, 17 Jan 2020 06:59:57 +0000
Date:   Thu, 16 Jan 2020 22:59:57 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 10/11] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
Message-ID: <20200117065957.GC26438@infradead.org>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924228165.3029431.1835481566077971155.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157924228165.3029431.1835481566077971155.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:24:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
> caller passed TRYLOCK and we weren't able to get the lock; and change
> the callers to recognize this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   31 +++++++++++++++----------------
>  fs/xfs/libxfs/xfs_bmap.c  |    9 +++++----
>  fs/xfs/xfs_filestream.c   |   11 ++++++-----
>  3 files changed, 26 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 83273975df77..26f3e4db84e0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2502,13 +2502,15 @@ xfs_alloc_fix_freelist(
>  
>  	if (!pag->pagf_init) {
>  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> -		if (error)
> -			goto out_no_agbp;
> -		if (!pag->pagf_init) {
> +		if (error == -EAGAIN) {
> +			/* Couldn't lock the AGF so skip this AG. */
>  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
>  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> -			goto out_agbp_relse;
> +			error = 0;
> +			goto out_no_agbp;
>  		}
> +		if (error)
> +			goto out_no_agbp;

I wonder if something like:

		if (error) {
			if (error == -EAGAIN) {
				/* Couldn't lock the AGF so skip this AG. */
	 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
	 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
				error = 0;
			}
			goto out_no_agbp;
		}

would be a little nicer here?

> @@ -2533,13 +2535,15 @@ xfs_alloc_fix_freelist(
>  	 */
>  	if (!agbp) {
>  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> -		if (error)
> -			goto out_no_agbp;
> -		if (!agbp) {
> +		if (error == -EAGAIN) {
> +			/* Couldn't lock the AGF so skip this AG. */
>  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
>  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> +			error = 0;
>  			goto out_no_agbp;
>  		}
> +		if (error)
> +			goto out_no_agbp;
>  	}

Same here.  Also shouldn't those asserts just move into
xfs_alloc_read_agf or go away now that we have a proper return value
and not the magic NULL buffer?

> +	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
> +	if (error)
>  		return error;
> +	xfs_trans_brelse(tp, bp);
>  	return 0;

Maybe simplify this further to:

	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
	if (!error)
		xfs_trans_brelse(tp, bp);
	return error;

> @@ -2958,12 +2962,9 @@ xfs_read_agf(
>  	trace_xfs_read_agf(mp, agno);
>  
>  	ASSERT(agno != NULLAGNUMBER);
> -	error = xfs_trans_read_buf(
> -			mp, tp, mp->m_ddev_targp,
> +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,

This hunk should probably go into the patch that changed the
xfs_trans_read_buf return value instead.

> +		if (error == -EAGAIN) {
> +			/* Couldn't lock the AGF, so skip this AG. */
>  			*notinit = 1;
> +			error = 0;
>  			goto out;
>  		}
> +		if (error)
> +			goto out;

Should probably be:

		if (error) {
			if (error == -EAGAIN) {
				/* Couldn't lock the AGF, so skip this AG. */
	 			*notinit = 1;
				error = 0;
			}
 			goto out;
