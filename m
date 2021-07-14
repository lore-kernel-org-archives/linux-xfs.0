Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1967EC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB70613B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhGNWt0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhGNWt0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C925F613C2;
        Wed, 14 Jul 2021 22:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626302793;
        bh=E06I3GlqH7oMzA4L2O8vvw0YPIcghwrv2MdUnmZMV6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmeecMaBmA8qd0pW9hKSYnVPGHX0A17+uHTifFIxDOKR5MOvbzmLfxxmI/9HpC7jj
         qxnm55eMJIHW2xITTQix8kRz4Q/AenJHUnY9Od+7odH88DkOdhiQTw7IT1uR4afR4r
         Ey+sC9/SdMCJBPVGWHYLB/fFRQAOj/uUSP7LWJ1SeHZbfTenzI9SQrvgqliG9G8U1b
         qMLOVX7UV3RuQ2881bkJFmVJNfmZuOIfuQWtW5vrQQK5EqyjIYdXCiy2Z35gcjKzXv
         oHldoxxq4adjWnOjw8rmEb/xnl1XG9DGfeBEdRXcneChw75+W40vW7BJuTpvsY1t89
         M7s6OG0lk9xpQ==
Date:   Wed, 14 Jul 2021 15:46:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: rename xfs_has_attr()
Message-ID: <20210714224633.GU22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:18:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_has_attr() is poorly named. It has global scope as it is defined
> in a header file, but it has no namespace scope that tells us what
> it is checking has attributes. It's not even clear what "has_attr"
> means, because what it is actually doing is an attribute fork lookup
> to see if the attribute exists.
> 
> Upcoming patches use this "xfs_has_<foo>" namespace for global
> filesystem features, which conflicts with this function.
> 
> Rename xfs_has_attr() to xfs_attr_lookup() and make it a static
> function, freeing up the "xfs_has_" namespace for global scope
> usage.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

LGTM, though Allison is probably the expert here ;)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 8 ++++----
>  fs/xfs/libxfs/xfs_attr.h | 1 -
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d9d7d5137b73..d31ea7f1a7fc 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -623,8 +623,8 @@ xfs_attr_set_iter(
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
> -int
> -xfs_has_attr(
> +static int
> +xfs_attr_lookup(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> @@ -762,7 +762,7 @@ xfs_attr_set(
>  	}
>  
>  	if (args->value) {
> -		error = xfs_has_attr(args);
> +		error = xfs_attr_lookup(args);
>  		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
>  			goto out_trans_cancel;
>  		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> @@ -777,7 +777,7 @@ xfs_attr_set(
>  		if (!args->trans)
>  			goto out_unlock;
>  	} else {
> -		error = xfs_has_attr(args);
> +		error = xfs_attr_lookup(args);
>  		if (error != -EEXIST)
>  			goto out_trans_cancel;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 8de5d1d2733e..5e71f719bdd5 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -490,7 +490,6 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> -int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> -- 
> 2.31.1
> 
