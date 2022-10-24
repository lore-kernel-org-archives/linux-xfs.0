Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B04C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 00:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiJYAON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJYANr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 20:13:47 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECBB1911C9
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 15:32:39 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso7886122pjc.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 15:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vjAI3DlGSh8RPzipkc203udR6/2dGb7ItFm4F9lWP4U=;
        b=KT/eiXDCTvYE+85gBpe44ldMO7OPzDaURemK29ooN/nWK3lEjoDpMISaZ5bgSQtGmE
         q8Jskl9VdM/j6njDxrGaxsXnqP6wpMpAiNtB0G4WlvMt7IVElFV0D0fEB6c7YeDNxW1c
         IK/EzF/TDaF+L17MSvJhn4iabqQdT8E7vZiZLt0WAL84LIr3h/U5+/bsXLwaEizG3yWY
         UOzQxdxIJ+D4Y4EkDBUt7BP1sd3/qYTzUsKveeoigX390oy/4OGW/FNGnLiAnaSwRHUC
         /VTvnp+vWfA83clKeSDzh4O2df1QUAYJT1AXKqTPE/wtV0Fi8xaHGDS0dhlWC2wW2xyN
         SkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjAI3DlGSh8RPzipkc203udR6/2dGb7ItFm4F9lWP4U=;
        b=vQ36s+zD/NYd3UhstN1X2qW5E9gsTWVD7YcUaeho4Yyad5M+tCSD3lQenMk1UNyqT9
         5rSMcMW90zscp0QPd90Qy6ExP83bZmzn2jOdFVHjfojXIygDoL6AF+svXyspEV7W6tgT
         o/bJXRevMC7wNOVeAgHsyxFbdYORr7qCZxSzZ8OmuTxGYDlBTxss7tAzO7LaEf8VulGw
         B0EEESOex3TZd67GyJAQpOPm+KMJ5B1Y/+8V7FqDczVUvXaa0daAh+xSZVzXt1OsLm5f
         hCC7f613LNdapSWfCC+KU6Hy0iPPZN4nV0p8jJ+wAzGjoAXQhWemIQNf+kCr9BwTnbkE
         1z7g==
X-Gm-Message-State: ACrzQf3rk8x9qg4EfPXqLx7zD8iDNgFbVHUrs6PruvtbtnsHGzkK8pyI
        gJ7NdyjedIZyUqhuaP1AuEnXQuqx7J61zQ==
X-Google-Smtp-Source: AMsMyM4+Q4hW+V3D7Y5cGgdG/QrxeniQBV2keucR82bljItFnl4YW2w+aAwRZ4gWdLW8D40fg27QUA==
X-Received: by 2002:a17:90b:2751:b0:20a:e437:a9e8 with SMTP id qi17-20020a17090b275100b0020ae437a9e8mr75415533pjb.181.1666650759111;
        Mon, 24 Oct 2022 15:32:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090add8800b00210125b789dsm322831pjv.54.2022.10.24.15.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 15:32:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1on5zn-005zcy-3y; Tue, 25 Oct 2022 09:32:35 +1100
Date:   Tue, 25 Oct 2022 09:32:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: fix FORTIFY_SOURCE complaints about log item
 memcpy
Message-ID: <20221024223235.GA3600936@dread.disaster.area>
References: <Y1CQe9FWctRg3OZI@magnolia>
 <202210240937.A1404E5@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210240937.A1404E5@keescook>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 09:59:08AM -0700, Kees Cook wrote:
> On Wed, Oct 19, 2022 at 05:04:11PM -0700, Darrick J. Wong wrote:
> > [...]
> > -/*
> > - * Copy an BUI format buffer from the given buf, and into the destination
> > - * BUI format structure.  The BUI/BUD items were designed not to need any
> > - * special alignment handling.
> > - */
> > -static int
> > -xfs_bui_copy_format(
> > -	struct xfs_log_iovec		*buf,
> > -	struct xfs_bui_log_format	*dst_bui_fmt)
> > -{
> > -	struct xfs_bui_log_format	*src_bui_fmt;
> > -	uint				len;
> > -
> > -	src_bui_fmt = buf->i_addr;
> > -	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
> > -
> > -	if (buf->i_len == len) {
> > -		memcpy(dst_bui_fmt, src_bui_fmt, len);
> > -		return 0;
> > -	}
> > -	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> > -	return -EFSCORRUPTED;
> > -}
> 
> This is the place where flex_cpy() could be used:
> 
> 	flex_cpy(dst_bui_fmt, src_bui_fmt);

How does flex_cpy() know how much memory was allocated for
dst_bui_fmt? Doesn't knowing this imply that we have to set the
count field in dst_bui_fmt appropriately before flex_cpy() is
called?

If this is the case, this flex_cpy() thing just looks like it's
moving the problem around, not actually solving any problem in this
code. If anything, it is worse, because it is coupling the size of
the copy to a structure internal initialisation value that may be
nowhere near the code that does the copy. That makes the code much
harder to validate by reading it.

Indeed, by the time we get to the memcpy() above, we've validated
length two ways, we allocated dst_bui_fmt to fit that length, and we
know that the src_bui_fmt length is, well, length, because that's
what the higher level container structure told us it's length was.
And with memcpy() being passed that length, it is *obviously
correct* to the reader.

Hence I don't see that this flex array copying stuff will make it
harder to make mistakes, but ISTM that it'll make them harder to spot
during review and audit...

> > [...]
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 51f66e982484..5367e404aa0f 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -590,7 +590,7 @@ xfs_bui_item_relog(
> >  	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
> >  
> >  	buip = xfs_bui_init(tp->t_mountp);
> > -	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
> > +	memcpy_array(buip->bui_format.bui_extents, extp, count, sizeof(*extp));
> >  	atomic_set(&buip->bui_next_extent, count);
> >  	xfs_trans_add_item(tp, &buip->bui_item);
> >  	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
> 
> Looking more closely, I don't understand why this is treated as a flex
> array when it's actually fixed size:
> 
> xfs_bui_init():
>         buip = kmem_cache_zalloc(xfs_bui_cache, GFP_KERNEL | __GFP_NOFAIL);
> 	...
>         buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
> 
> fs/xfs/xfs_bmap_item.h:#define  XFS_BUI_MAX_FAST_EXTENTS        1

We have a separation between on-disk format structure parsing
template that implements the BUI/BUD code (i.e. same implementation
as EFI, RUI, and CUI intents) and the runtime code that is currently
only using a single extent in the flex array.

The use of template based implementations means modifications are
simple (if repetitive) and we don't have to think about specific
intent implementations differently when reasoning about extent-based
intent defering and recovery. 

Further, the high level code that creates BUIs could change to use
multiple extents at any time. We don't want to have to rewrite the
entire log item formatting and parsing code every time we change the
number of extents we currently track in a given intent....

> > [...]
> > +/*
> > + * Copy an array from @src into the @dst buffer, allowing for @dst to be a
> > + * structure with a VLAs at the end.  gcc11 is smart enough for
> > + * __builtin_object_size to see through void * arguments to static inline
> > + * function but not to detect VLAs, which leads to kernel warnings.
> > + */
> > +static inline int memcpy_array(void *dst, void *src, size_t nmemb, size_t size)
> > +{
> > +	size_t		bytes;
> > +
> > +	if (unlikely(check_mul_overflow(nmemb, size, &bytes))) {
> > +		ASSERT(0);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	unsafe_memcpy(dst, src, bytes, VLA size detection broken on gcc11 );
> > +	return 0;
> > +}
> 
> This "unsafe_memcpy" isn't needed. FORTIFY won't warn on this copy:
> the destination is a flex array member, not a flex array struct
> (i.e. __builtin_object_size() here will report "-1", rather than a
> fixed size). And while the type bounds checking for overflow is nice,
> it should also be checking the allocated size. (i.e. how large is "dst"?
> this helper only knows how large src is.)

The caller knows how large dst is - it's based on the verified size
of the structure it is going to copy. Compile time checking the
copy doesn't oblivate the need to perform runtime checking needed to
to set up the copy correctly/safely...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
