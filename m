Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F37C63777
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 08:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96E122206
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 08:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgLCIk4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgLCIkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 03:40:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A321EC061A4D
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 00:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MPlQPJwgOkG1jvis7c7YeZh9nHdMKzGBZmdmhc0kfrc=; b=tjkSMLF6N7wPFO+8NM9X2gmkt3
        q3AHTWUkSfyUbEzCs64hEtyHj0WHcQf2Hr7B+6Vl7b2JlKIezl+df7/yF7MTrvZYExvpReE8pU4Gd
        RAskNsZvPA7Im+1jRs1SEWn94TJc2HwZdWnPh2B5zua4o/oYpQpjMVQ6V9SfFeIsSq+dWTbKTDJvV
        5ko6CMp3veoex4EXkoJJ287m71IrvlA67dBVOkuX8zztWLxrj3nNEtXgZCY3l5Kkllq+bhpD3wZGN
        5ukzcAS0/EwBkTKMb1ePH5XMv/uPRLhsR7zyb7dkBpIN7YO6JKKrwKRQD606Y2Bel8K9i1NZHOobw
        6O7NXB5g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkk9s-0000Fx-4Y; Thu, 03 Dec 2020 08:40:12 +0000
Date:   Thu, 3 Dec 2020 08:40:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201203084012.GA32480@infradead.org>
References: <20201202232724.1730114-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202232724.1730114-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks pretty sensible, and pretty simple.  Why the RFC?

This looks good to me modulo a few tiny nitpicks below:

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1414ab79eacf..75b44b82ad1f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -126,6 +126,7 @@ xfs_cleanup_inode(
>  	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
>  }
>  
> +
>  STATIC int
>  xfs_generic_create(
>  	struct inode	*dir,

Nit: this adds a spuurious empty line.

> @@ -161,7 +162,14 @@ xfs_generic_create(
>  		goto out_free_acl;
>  
>  	if (!tmpfile) {
> -		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
> +		bool need_xattr = false;
> +
> +		if ((IS_ENABLED(CONFIG_SECURITY) && dir->i_sb->s_security) ||
> +		    default_acl || acl)
> +			need_xattr = true;
> +
> +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> +					need_xattr, &ip);

It might be wort to factor the condition into a little helper.  Also
I think we also have security labels for O_TMPFILE inodes, so it might
be worth plugging into that path as well.
