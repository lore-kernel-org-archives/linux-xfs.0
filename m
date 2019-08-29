Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6C4C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E636233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SR/CvN2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfH2HXT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 03:23:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfH2HXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TX4zzH/Rt40La0LybA3gschY5q28Luntz1x8QGcnjrM=; b=SR/CvN2iRX40W6sgE9LYa+E2x
        tTj913Somii3WVgEDVvGrAqmg9a8t0efw3Jm3Do+kEWv+w3ts2ZObI5fnuLYagEPTqYrztAiofVZP
        iJEzzrHk73nmLE8pgnMM5uJWPaljNc1IMr3NKPucYa8RWXYkFmtOVEyppMI0HchSYWz1up5leNCmc
        HjiEhT/cdijlmpz3OsbUCASvTNFcohZyx+sS5jj9j4LocjdHaXSGyIbUNdt0pdLRQXPy+M23pprQC
        sSHCWZHDEh9TdOSi7AIk4t9CcQCEwy5yUNDUeBv51tfTaPt+9FidMBW9dRgF9URJqQgNpNAUEJ3mm
        +xf0/vusQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Em6-0007o1-Av; Thu, 29 Aug 2019 07:23:18 +0000
Date:   Thu, 29 Aug 2019 00:23:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
Message-ID: <20190829072318.GA18102@infradead.org>
References: <20190826183803.GQ1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826183803.GQ1037350@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 11:38:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_bmbt_diff_two_keys, we perform a signed int64_t subtraction with
> two unsigned 64-bit quantities.  If the second quantity is actually the
> "maximum" key (all ones) as used in _query_all, the subtraction
> effectively becomes addition of two positive numbers and the function
> returns incorrect results.  Fix this with explicit comparisons of the
> unsigned values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap_btree.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index fbb18ba5d905..3c1a805b3775 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -400,8 +400,20 @@ xfs_bmbt_diff_two_keys(
>  	union xfs_btree_key	*k1,
>  	union xfs_btree_key	*k2)
>  {
> -	return (int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
> -			  be64_to_cpu(k2->bmbt.br_startoff);
> +	uint64_t		a = be64_to_cpu(k1->bmbt.br_startoff);
> +	uint64_t		b = be64_to_cpu(k2->bmbt.br_startoff);
> +
> +	/*
> +	 * Note: This routine previously casted a and b to int64 and subtracted
> +	 * them to generate a result.  This lead to problems if b was the
> +	 * "maximum" key value (all ones) being signed incorrectly, hence this
> +	 * somewhat less efficient version.

Comments documenting what was done previously are a bit of a weird
style, as the reader generally could not care less what there was
previously.

> +	 */
> +	if (a > b)
> +		return 1;
> +	else if (b > a)
> +		return -1;
> +	return 0;

Looks good.  I wonder if we should have a helper for this through,
as basically any compare function taking 64-bit values will have the
same boilerplate.

I suggest to add a helper like:

/*
 * Compare to signed 64-bit values and return an signed 32-bit integer
 * value that is 1, -1 or 0 for various compare callbacks.
 */
static inline int cmp_s64(s64 a, s64 b)
{
	if (a > b)
		return 1;
	else if (b > a)
		return -1;
	return 0;
}

and then the above just comes:

	return cmp_s64(be64_to_cpu(k1->bmbt.br_startoff),
		       be64_to_cpu(k2->bmbt.br_startof));

and we can probably clean up various other places inside (and outside,
but we can leave that for others) as well.  I'll cook up a patch if
you feel this is not worth your time.
