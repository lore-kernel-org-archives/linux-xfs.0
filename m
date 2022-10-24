Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94847ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 18:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiJXSUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 14:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiJXSTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 14:19:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DAAEB75A
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 10:00:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y4so8970955plb.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 10:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=own8ye662lUOdQaeWJaxYX3DyTPpqYUnB/yDKK35XDM=;
        b=J/kqzFiQWUX+/Rv/mE9fXKYNZbANBVZtUbSTi85yprWAzX+R5YMHoghhUN3lRq1Eou
         1MAbOBEfqVwdsUqbOMPv+yYDVUaX8IhJ6S+tBqcb0hmDkBYwK9esBVfnh5KSFhctfHRx
         NLOUHlpBIGcs0Llp1thDOz3uLmn0Jry0RJQnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=own8ye662lUOdQaeWJaxYX3DyTPpqYUnB/yDKK35XDM=;
        b=uWhrVX5+gVhnYvm3fovYCqxmuF81gVEMyNaN0aPqIsxqqf2MpyfYTYmd8OlViFdxdH
         tLiWUp5l4gsijajaGf+AO3sa7VxpshMr/Os+8P4JdCx9bnGGwF3r8XstidSkxnb1mnbH
         QJadY3HfUte2R13ZTwhAksiWfoqd3Gm7Hh3i2JCtHKalVTPtiPHnYvUc8itP1wX57Mkg
         LB8fElpmH9JM2hRT3L/O91rZ8cIZKxfp1GXri+stpNXAk50Fm3AiwpyfDJBh8OlGqdpb
         JJAJS3q/stjAxtc8G1iwaHkFzUVKscbaG4H8Se9t5P9nQIbxheTnV1gcRd+8FxvKp/NN
         5pSQ==
X-Gm-Message-State: ACrzQf1QHJfVl39zEDZOa+NMs2PMvZNAJEmwjEabx2sGVW9NlkeYnIqx
        cMFAY8wqWgREAzOSigh2W1p1EP8Kba+SKQ==
X-Google-Smtp-Source: AMsMyM7QQRDxR5qqHXdLenOvS3yqAV/wzgDDvRjKtKrCpesGicGRRAxE3OZn8H8Bg1RnuBAbY8Y0qw==
X-Received: by 2002:a17:90b:1bc9:b0:20d:75b8:ee5d with SMTP id oa9-20020a17090b1bc900b0020d75b8ee5dmr40608883pjb.147.1666630750055;
        Mon, 24 Oct 2022 09:59:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y11-20020aa79aeb000000b0056299fd2ba2sm43112pfp.162.2022.10.24.09.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 09:59:09 -0700 (PDT)
Date:   Mon, 24 Oct 2022 09:59:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: fix FORTIFY_SOURCE complaints about log item
 memcpy
Message-ID: <202210240937.A1404E5@keescook>
References: <Y1CQe9FWctRg3OZI@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1CQe9FWctRg3OZI@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 19, 2022 at 05:04:11PM -0700, Darrick J. Wong wrote:
> [...]
> -/*
> - * Copy an BUI format buffer from the given buf, and into the destination
> - * BUI format structure.  The BUI/BUD items were designed not to need any
> - * special alignment handling.
> - */
> -static int
> -xfs_bui_copy_format(
> -	struct xfs_log_iovec		*buf,
> -	struct xfs_bui_log_format	*dst_bui_fmt)
> -{
> -	struct xfs_bui_log_format	*src_bui_fmt;
> -	uint				len;
> -
> -	src_bui_fmt = buf->i_addr;
> -	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
> -
> -	if (buf->i_len == len) {
> -		memcpy(dst_bui_fmt, src_bui_fmt, len);
> -		return 0;
> -	}
> -	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> -	return -EFSCORRUPTED;
> -}

This is the place where flex_cpy() could be used:

	flex_cpy(dst_bui_fmt, src_bui_fmt);

> [...]
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 51f66e982484..5367e404aa0f 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -590,7 +590,7 @@ xfs_bui_item_relog(
>  	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
>  
>  	buip = xfs_bui_init(tp->t_mountp);
> -	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
> +	memcpy_array(buip->bui_format.bui_extents, extp, count, sizeof(*extp));
>  	atomic_set(&buip->bui_next_extent, count);
>  	xfs_trans_add_item(tp, &buip->bui_item);
>  	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);

Looking more closely, I don't understand why this is treated as a flex
array when it's actually fixed size:

xfs_bui_init():
        buip = kmem_cache_zalloc(xfs_bui_cache, GFP_KERNEL | __GFP_NOFAIL);
	...
        buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;

fs/xfs/xfs_bmap_item.h:#define  XFS_BUI_MAX_FAST_EXTENTS        1

> [...]
> +/*
> + * Copy an array from @src into the @dst buffer, allowing for @dst to be a
> + * structure with a VLAs at the end.  gcc11 is smart enough for
> + * __builtin_object_size to see through void * arguments to static inline
> + * function but not to detect VLAs, which leads to kernel warnings.
> + */
> +static inline int memcpy_array(void *dst, void *src, size_t nmemb, size_t size)
> +{
> +	size_t		bytes;
> +
> +	if (unlikely(check_mul_overflow(nmemb, size, &bytes))) {
> +		ASSERT(0);
> +		return -ENOMEM;
> +	}
> +
> +	unsafe_memcpy(dst, src, bytes, VLA size detection broken on gcc11 );
> +	return 0;
> +}

This "unsafe_memcpy" isn't needed. FORTIFY won't warn on this copy:
the destination is a flex array member, not a flex array struct
(i.e. __builtin_object_size() here will report "-1", rather than a
fixed size). And while the type bounds checking for overflow is nice,
it should also be checking the allocated size. (i.e. how large is "dst"?
this helper only knows how large src is.)

-Kees

-- 
Kees Cook
