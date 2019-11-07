Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE831C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97836214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WvDtbGPh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbfKGSZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GgPJFolWXIlk/WUno4JgpKnCGQ0QA9YGgqRtPimNVuo=; b=WvDtbGPh17crqk2N2fLnaHfRd
        d2EJepNBAszo2hLMznAOr2ZGoLYQLGchTMd8fWoFVgN9aXVU+y+E4Z1FJdTdtuagR7of1OHLuMuj/
        ej7MEQbKowCNEsCUBLEjjoLln638WjtAukd/N7t0hJHvICrOy0J3su+8NLAv4+epv0I9z9RZHmtS0
        aF81HMj7licvwoK8Wf3YrhCfK1Jjh+vrN4jTkqxtpP8eBRBD8pV3sUSIzUnjWdweFWVckZzbuvOon
        S9N1YVmZbk938/R7jaGm/rgBdyZWRou0hjjuuwtyrwDCh72onK1HiK9DW/aMUwfCGMgKOPXWmC4JX
        z5Ypv61fg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTW-0004RW-S9; Thu, 07 Nov 2019 18:25:42 +0000
Date:   Thu, 7 Nov 2019 10:25:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/4] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191107182542.GC2682@infradead.org>
References: <157309570855.45542.14663613458519550414.stgit@magnolia>
 <157309572922.45542.2780240623887540291.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309572922.45542.2780240623887540291.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
> -	if (!bp) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
> +	if (XFS_IS_CORRUPT(tp->t_mountp, !bp)) {
>  		return -EFSCORRUPTED;
>  	}

We can kill the braces here now.  Same for various other spots later
down.

> +	if (XFS_IS_CORRUPT(mp,
> +			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {

Somewhat strange indentation here.

>  	ASSERT(map && *map);
> @@ -2566,14 +2551,16 @@ xfs_dabuf_map(
>  		nirecs = 1;
>  	}
>  
> -	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
> -		/* Caller ok with no mapping. */
> -		if (mappedbno == -2) {
> -			error = -1;
> -			goto out;
> -		}
> +	covers_blocks = xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb);
> +
> +	/* Caller ok with no mapping. */
> +	if (mappedbno == -2 && !covers_blocks) {
> +		error = -1;
> +		goto out;
> +	}
>  
> -		/* Caller expected a mapping, so abort. */
> +	/* Caller expected a mapping, so abort. */
> +	if (XFS_IS_CORRUPT(mp, !covers_blocks)) {

Why the restructure here?

This could have just become:

		if (!XFS_IS_CORRUPT(mp != -2)) {
			error = -1;
			goto out;
		}

not that I really like the current structure, but that change seems bit
out of place in these semi-mechanical fixups, and once we touch the
structure of this function and its callers there is so much more to
fix..

> index 7b845c052fb4..e1b9de6c7437 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -87,6 +87,10 @@ struct xfs_ifork {
>  #define XFS_IFORK_MAXEXT(ip, w) \
>  	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
>  
> +#define XFS_IFORK_MAPS_BLOCKS(ip, w) \
> +		(XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_EXTENTS || \
> +		 XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_BTREE)

Why the double indentation?  Also maybe XFS_IFORK_FORMAT_MAPS_BLOCKS
is a better name?  Or maybe even turn it into an inline function with
a less shouting name?  Also the addition of this helper is probably
worth being split into a separate patch.

> +		    head_block >= tail_block || head_cycle != (tail_cycle + 1)))

no need for the inner most braces here if you touch the line anyway.
