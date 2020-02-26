Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35513C4BA18
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 077342467F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PQsVJKuq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgBZQ6x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:58:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgBZQ6x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 11:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eL1RCOsHieoZalQdHew6/pLiIN7lmre2UFBHwQoodBU=; b=PQsVJKuqU5jjxFdEr/bv5/dJ+v
        ITdalH3timaIEknHQwslI5ie6xv1Euo9VI6/C4v6uO5gb/CEhjBcfjFsN3jDskIBK+hoTjKEbII7E
        a6cmYcND6ZJXBNd4d7Z94x438vONgaQPS+/cjkfLtR9xpP020pVEtSPXG+ExDd/1JP1Wi+S51/j/8
        CHZOWJ7qPcPH+roA6GIw1KUX/Pga/d1/X5qVcamQLkHIraQOwLoaogClOffvVpxt7/Siw64DjJID3
        WFNUfNPCxfFVWgwXFS88dZQg+1NiBDXKK5IkSOe0rZLq8LaC2JJ1vskfebq18zCRsZMsKpWS3sOue
        CbIjwgFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j701M-0003ir-UB; Wed, 26 Feb 2020 16:58:52 +0000
Date:   Wed, 26 Feb 2020 08:58:52 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 1/7] xfs: Pass xattr name and value length
 explicitly to xfs_attr_leaf_newentsize
Message-ID: <20200226165852.GA10529@infradead.org>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-2-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fae322105457a..65a3bf40c4f9d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1403,6 +1404,7 @@ xfs_attr3_leaf_add_work(
>  	struct xfs_attr_leaf_name_local *name_loc;
>  	struct xfs_attr_leaf_name_remote *name_rmt;
>  	struct xfs_mount	*mp;
> +	int			entsize;
>  	int			tmp;
>  	int			i;
>  
> @@ -1432,11 +1434,14 @@ xfs_attr3_leaf_add_work(
>  	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
>  	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
>  	ASSERT(ichdr->freemap[mapindex].size >=
> -		xfs_attr_leaf_newentsize(args, NULL));
> +		xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +				args->valuelen, NULL));
>  	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
>  	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
>  
> -	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
> +	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +			args->valuelen, &tmp);
> +	ichdr->freemap[mapindex].size -= entsize;

As-is this entsize variable is a little pointless.  Please move the
assignment to it up and reuse it in the assert.

> @@ -1824,6 +1829,8 @@ xfs_attr3_leaf_figure_balance(
>  	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
>  	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
>  	struct xfs_attr_leaf_entry	*entry;
> +	struct xfs_da_args		*args;
> +	int				entsize;
>  	int				count;
>  	int				max;
>  	int				index;
> @@ -1833,14 +1840,16 @@ xfs_attr3_leaf_figure_balance(
>  	int				foundit = 0;
>  	int				tmp;
>  
> +	args = state->args;

Please assign the value to the variable at the time of declaration.

>  	/*
>  	 * Examine entries until we reduce the absolute difference in
>  	 * byte usage between the two blocks to a minimum.
>  	 */
>  	max = ichdr1->count + ichdr2->count;
>  	half = (max + 1) * sizeof(*entry);
> -	half += ichdr1->usedbytes + ichdr2->usedbytes +
> -			xfs_attr_leaf_newentsize(state->args, NULL);
> +	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +			args->valuelen, NULL);
> +	half += ichdr1->usedbytes + ichdr2->usedbytes + entsize;
>  	half /= 2;
>  	lastdelta = state->args->geo->blksize;
>  	entry = xfs_attr3_leaf_entryp(leaf1);
> @@ -1851,8 +1860,9 @@ xfs_attr3_leaf_figure_balance(
>  		 * The new entry is in the first block, account for it.
>  		 */
>  		if (count == blk1->index) {
> -			tmp = totallen + sizeof(*entry) +
> -				xfs_attr_leaf_newentsize(state->args, NULL);
> +			entsize = xfs_attr_leaf_newentsize(args->geo,
> +					args->namelen, args->valuelen, NULL);
> +			tmp = totallen + sizeof(*entry) + entsize;
>  			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
>  				break;
>  			lastdelta = XFS_ATTR_ABS(half - tmp);
> @@ -1887,8 +1897,9 @@ xfs_attr3_leaf_figure_balance(
>  	 */
>  	totallen -= count * sizeof(*entry);
>  	if (foundit) {
> -		totallen -= sizeof(*entry) +
> -				xfs_attr_leaf_newentsize(state->args, NULL);
> +		entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> +				args->valuelen, NULL);
> +		totallen -= sizeof(*entry) + entsize;

AFAICS there is no need to assign the same value to entsize again and
again in this function.  It should be enough to assign to it once and
then reuse the value.
