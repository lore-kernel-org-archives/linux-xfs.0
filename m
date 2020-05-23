Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D8FC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 08:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E37C8206C3
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 08:45:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZLSN0kiM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgEWIpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 04:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387471AbgEWIpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 04:45:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D110C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 01:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MUUA41/MV9W01G1s5Dp8eElcK6harxVxG/XCjqD1/1Y=; b=ZLSN0kiMKjpba8ZXZdiIV8GE43
        yFxXV4coxgcGOfktPJ8PH6YJE1G4qh0MykF0594aWutn/YRfmGtXYlqgW94u8Bu3Lb9Rn6aT3a8n3
        PtWAgpH6A3qgkSZQX0GQw+JgGMAs/ZILxzGJQzZvFHTEX3xE/17H6gAN+auq8L4ASJvyGaYw20lB3
        DDTUrGhhDGuWsoQdcduzXItXoSgSWLb05szXT3J253byNmKVA4TPMqysNhrJCsD2j0IUC7SFmkqM9
        3S2vDGPGaEabwMp7jnXhG8RRmLS5DSzKd7IG8STDZhbPx39+N5DBvEWCK5lqfAZ0BHBqMkJEcJYhU
        LyNxXlzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcPmo-0000W0-Px; Sat, 23 May 2020 08:45:42 +0000
Date:   Sat, 23 May 2020 01:45:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/24] xfs: add an inode item lock
Message-ID: <20200523084542.GA31566@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

just a few minor style nipicks below:

> -	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
> -	    IS_I_VERSION(VFS_I(ip))) {
> -		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
> -			flags |= XFS_ILOG_CORE;
> +	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags) &&
> +	    IS_I_VERSION(inode)) {
> +		if (inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
> +			iversion_flags = XFS_ILOG_CORE;

I find the ordering of the conditionals here weird (and yes I know this
comes from the old code), given that test_and_set_bit is an action
applicable independend of IS_I_VERSION.  Maybe reshuffle this to:

	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags) {
		if (IS_I_VERSION(inode) &&
		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
			iversion_flags = XFS_ILOG_CORE;
 	}

> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	/*
> +	 * Record the specific change for fdatasync optimisation. This
> +	 * allows fdatasync to skip log forces for inodes that are only
> +	 * timestamp dirty. We do this before the change count so that
> +	 * the core being logged in this case does not impact on fdatasync
> +	 * behaviour.
> +	 */

This comment could save a precious line by using up all 80 characters :)

> +	flags |= iip->ili_last_fields | iversion_flags;
> +	iip->ili_fields |= flags;
> +	spin_unlock(&iip->ili_lock);
>  }

Maybe something like this:

	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);

would make more sense as the flags isn't used anywhere below.

> +			spin_lock(&iip->ili_lock);
>  			iip->ili_last_fields = iip->ili_fields;
>  			iip->ili_fields = 0;
>  			iip->ili_fsync_fields = 0;
> +			spin_unlock(&iip->ili_lock);
>  			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  						&iip->ili_item.li_lsn);

We have to copies of the exact above code sequence.  Maybe it makes
sense to be factored into a little helper?

> +	spin_lock(&iip->ili_lock);
> +	iip->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);

Please add whitespaces around the "|".
