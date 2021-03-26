Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6F3C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 06:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB5861936
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 06:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhCZGbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 02:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhCZGbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 02:31:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77242C0613AA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 23:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=co+fYnkT3sywuAfX1ICqo2RUGQjJFmpSFKFDk0Stj2s=; b=EtbCh3WH/KeJ9nVcGUM3l1s8U8
        Bo1HZkKFKTuwinXaOeJWpwyrfRq7rEBieGIJWJJEoYeaDmDLPMD3Rfu3j4c9yWxrmKq5+EVdjou2W
        zjOxKTdAfQfvJvkCkC8SQGBbQfLi+zheim9GURgYAAOfkIoEI5zeAswHh+ZIAaJSEiRngrB/MaLIz
        8WMEKkF36DJZi/y7XQLqLKD4JLknNe5FIrWfBMxFLHPbhVrFQNwllIEC1TaZ+VzzqwYoxIDTln8YI
        acJvWMOsthh5+aAnRmiXT9WkCYx8s9YKdUX72BZc04KyBGr9KqkQKMMMCmLSfuvcCuhKg0o08X9AA
        GhyNYB1w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfzk-00EOrU-Dr; Fri, 26 Mar 2021 06:30:56 +0000
Date:   Fri, 26 Mar 2021 06:30:56 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 5/6] xfs: merge xfs_reclaim_inodes_ag into
 xfs_inode_walk_ag
Message-ID: <20210326063056.GF3421955@infradead.org>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671810078.621936.339407186528826628.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671810078.621936.339407186528826628.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:21:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Merge these two inode walk loops together, since they're pretty similar
> now.  Get rid of XFS_ICI_NO_TAG since nobody uses it.

The laster user of XFS_ICI_NO_TAG was quotoff, and the last reference
was removed in "xfs: remove indirect calls from xfs_inode_walk{,_ag}".
So I think it should be dropped there, or even better in a prep patch
removing all the XFS_ICI_NO_TAG code before that one.

> +static inline bool
> +selected_for_walk(
> +	unsigned int		tag,
> +	struct xfs_inode	*ip)
> +{
> +	switch (tag) {
> +	case XFS_ICI_BLOCKGC_TAG:
> +		return xfs_blockgc_grab(ip);
> +	case XFS_ICI_RECLAIM_TAG:
> +		return xfs_reclaim_inode_grab(ip);
> +	default:
> +		return false;
> +	}
> +}

Maybe name ths something that starts with xfs_ and ends with _grab?

>   * and release all incore inodes with the given radix tree @tag.
> @@ -786,12 +803,14 @@ xfs_inode_walk_ag(
>  	bool			done;
>  	int			nr_found;
>  
> -	ASSERT(tag == XFS_ICI_BLOCKGC_TAG);
> +	ASSERT(tag < RADIX_TREE_MAX_TAGS);
>  
>  restart:
>  	done = false;
>  	skipped = 0;
>  	first_index = 0;
> +	if (tag == XFS_ICI_RECLAIM_TAG)
> +		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);

if / else to make this clear?

>  		for (i = 0; i < nr_found; i++) {
>  			if (!batch[i])
>  				continue;
> -			error = xfs_blockgc_scan_inode(batch[i], eofb);
> -			xfs_irele(batch[i]);
> +			switch (tag) {
> +			case XFS_ICI_BLOCKGC_TAG:
> +				error = xfs_blockgc_scan_inode(batch[i], eofb);
> +				xfs_irele(batch[i]);
> +				break;
> +			case XFS_ICI_RECLAIM_TAG:
> +				xfs_reclaim_inode(batch[i], pag);
> +				error = 0;

Maybe move the irele into xfs_blockgc_scan_inode to make the calling
conventions more similar?
