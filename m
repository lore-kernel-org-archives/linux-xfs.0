Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDC3C67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJXXS3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiJXXSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:18:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2C015B123;
        Mon, 24 Oct 2022 14:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40F9B615C4;
        Mon, 24 Oct 2022 21:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B6FC433D7;
        Mon, 24 Oct 2022 21:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647494;
        bh=uHa5U08f1LHZvhPtJrNezxQpZXhzvlx3HDfATrAE/BU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNZBkykuqYeYfX6xBXTTeX6rY1yOibfkJvc9hynTDpnZyS+37d+UOAMsQpYIDweON
         IS6Jfx0wzxizq7WwTOPjoN4Y6U6So7LuQ1zn9gQ4wn/vPERy/NDKsNyBMRDbdqsLYf
         faBuOkjNkvRDj/tIMATW2eey2d6cJ/a84V52yRlD+k0LSvkLvhIuudhALxmXNZ5jKB
         cCXdhEs++1DTkgB/adP3tnu1qR/W/TGSE1nrKw8pdT7NwOMstzXMUBAB1ZE4+wtIMy
         RfgFCM1E45C9OB76fy1K/KTRn0zzm2/PViR54prAh+gNvDISsNOi/+vr78WHZVKziP
         TuYdYE5lXFcZw==
Date:   Mon, 24 Oct 2022 14:38:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kees Cook <keescook@chromium.org>, h@magnolia
Cc:     xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: fix FORTIFY_SOURCE complaints about log item
 memcpy
Message-ID: <Y1cFxnea750izJd7@magnolia>
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

<nod>

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

Yeah, after a few more iterations of this patchset I realized that
*most* of the _relog functions are fine, it's only the one for EFI items
that trips over the not-flex array[1] definition.  I decided that the
proper fix for that was simply to fix the field definition to follow the
modern form for flex arrays.

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

<nod> I realized that these helpers introducing unsafe memcpy weren't
needed.  Later on after chatting with dchinner a bit I came to the
conclusion that we might as well convert most of the _copy_format
functions to memcpy the structure head and flex array separately since
that function is converting an ondisk log item into its in-memory
representation, and some day we'll make those struct fields endian safe.
They aren't now, and that's one of the (many) gaping holes that need
fixing.

I sent my candidate fixes series to the list just now.

--D

> 
> -Kees
> 
> -- 
> Kees Cook
