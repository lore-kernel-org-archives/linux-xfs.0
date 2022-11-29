Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AF8C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 05:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiK2F0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 00:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiK2F0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 00:26:42 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29D66244
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 21:26:41 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id a16so12227853pfg.4
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 21:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zf6ROon4lYCRfX1xvfbXi8kyre98F7mQK1O4cqkXYbs=;
        b=TrfnrSKzZMsYJwTJ9L0yBpy15oKftyS3TGdsMhaFoqsTZtPh/gL9MIUbk9ggNLXo6v
         Vp6MkBN8hRNgFvlI/8pux8IHKGa4xQsFron6EwO3TqJkrb0VDP5pA/gq9HHNpISQdNZS
         EqlNy5yPaCbjDsTaZSmx1h+v02ZwGufFQrCSfMhSLEGtE8d0tnSKA0BVIastqctGmVak
         97SDkED1wMaFMo+XqTlyaT0DUI3Xyvs6KUcwVS7evuYpdnAn7N1GO9t5Ejfwpfxts5bW
         VFYEfqzh0ipMFYm67IBc9+ss6nHTjHTd7Pu8wtvi4EloPRGwhP1WQWOwozET6EJCzAUC
         YrXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zf6ROon4lYCRfX1xvfbXi8kyre98F7mQK1O4cqkXYbs=;
        b=l29f3D6OhtBua7KR8tWbP5aSYu9dLnD17Y8b+P+zPW78wLOwQGMQNq7F/r6zYiQ0qN
         AnRxJUtqR/+vNVI/kJxlhcfHSl54/MA8jRS3vc7XBC52FqsXrOtFijVhKZ4fcCsxOvyW
         Z56fpCr6wOi2rnYn9D04YgAhpGu8OaZwao+rCpn6a5LoQtPhhRGKtH4Ga1zDpk0AcNbz
         wP7q8/cZVXAYP3imFfAlna7xpCzckBn9sSg0pW6lD3K3hdqcNGKg9WTf/v5wV9iT1z69
         uyDIJ4a1xshg7xIaoeonmlWzQhkINmWgg3AVqOsL7pAIaHsX8hnogu1moiK/X3ea+wpX
         KDuw==
X-Gm-Message-State: ANoB5pkg5Pc+C2R2GR4/lsoIePulq/DI0J6C8f/Ph4IzSZSu+c0hgfRa
        Z4HmAsi9YUxskHa1vbCJwiIOxA==
X-Google-Smtp-Source: AA0mqf7gzAmnB2FcOE8i2qrMxwcl+trwTTNrC2WVar0MhtY1w+wn62aZzOxLCBARGgF/ooEwnnMmig==
X-Received: by 2002:a63:110d:0:b0:46e:bcc1:28df with SMTP id g13-20020a63110d000000b0046ebcc128dfmr31424708pgl.187.1669699601262;
        Mon, 28 Nov 2022 21:26:41 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id j2-20020a654282000000b0046fe244ed6esm7491869pgp.23.2022.11.28.21.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 21:26:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ozt8g-002JRQ-0m; Tue, 29 Nov 2022 16:26:38 +1100
Date:   Tue, 29 Nov 2022 16:26:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use memcpy, not strncpy, to format the attr
 prefix during listxattr
Message-ID: <20221129052638.GB3600936@dread.disaster.area>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <166930916972.2061853.5449429916617568478.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166930916972.2061853.5449429916617568478.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 24, 2022 at 08:59:29AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When -Wstringop-truncation is enabled, the compiler complains about
> truncation of the null byte at the end of the xattr name prefix.  This
> is intentional, since we're concatenating the two strings together and
> do _not_ want a null byte in the middle of the name.
> 
> We've already ensured that the name buffer is long enough to handle
> prefix and name, and the prefix_len is supposed to be the length of the
> prefix string without the null byte, so use memcpy here instead.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_xattr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index c325a28b89a8..10aa1fd39d2b 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -210,7 +210,7 @@ __xfs_xattr_put_listent(
>  		return;
>  	}
>  	offset = context->buffer + context->count;
> -	strncpy(offset, prefix, prefix_len);
> +	memcpy(offset, prefix, prefix_len);
>  	offset += prefix_len;
>  	strncpy(offset, (char *)name, namelen);			/* real name */
>  	offset += namelen;

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
