Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EDDC38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 20:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiJZUdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiJZUdv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 16:33:51 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5C17E804
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:33:49 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g62so12606974pfb.10
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E0kxEl2S2a68MlFLjbJ42CBU2Unm12GzaCEH0lHQWuY=;
        b=obeJhxI+ENacAUlLPp+v61BhonjTS9sjU5Bul5it9+TdjHX1b4Op8qbkgN5uiAd9Gn
         Rd++IsKXJUdHvO+QOHUTGWHEmxI4CX4zFjED0OsH9PsV0jOV3C/F27o4oDQHKnHqCHbR
         ik1V1MssxtQ/uj/MararQ0+xsoC+XV6V9lfSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E0kxEl2S2a68MlFLjbJ42CBU2Unm12GzaCEH0lHQWuY=;
        b=AmEzQ2wrwRSYGXG0hVL/srQG2w+bdplGL8AFFDKUUgS2lsiLB9FzaAsNdUeS916lQm
         xjgce/OTP2h8ao1mzk76dEe3O78HsCqTQrXU7QnpNdGhRxA8z4pEYEYBml6jBNtziIwj
         ilkasJyctyGRiV/YDOktRNc3iJmNe/lKrF3g3No8KHeduBy66g37GkywttSrEPN1uEn3
         wiC/v7xf/GQuxRIsVtO1Z6XAVsQskkt8aVFyT+vTVKn/ut32vBlYDDi3P5ZL/hGWH+0d
         tKvsHCaKgOq8u2Ha7f/T+fEqqEExLbX5VAnYb5L2RltbHD26ErXCNl3r8MDAMGXj80Ga
         j9fw==
X-Gm-Message-State: ACrzQf2tTHqdlaZvaxqi/V8kfq0cEEVQ5KdkXh1mEGcQiZizPTSuIvYH
        zThpeglXWLx7AO7Z6nz/+rJbiw==
X-Google-Smtp-Source: AMsMyM4LL5FU6eakv/Sxfgq+61DepYp6/wpZrXWfv9mn6/p1V/LnMHUZp0tBb0NQskKtGvdKrQEfXA==
X-Received: by 2002:a05:6a00:2307:b0:565:9079:b165 with SMTP id h7-20020a056a00230700b005659079b165mr46196368pfh.53.1666816429195;
        Wed, 26 Oct 2022 13:33:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s27-20020aa78bdb000000b0056bc30e618dsm3377335pfd.38.2022.10.26.13.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 13:33:48 -0700 (PDT)
Date:   Wed, 26 Oct 2022 13:33:47 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Keith Packard <keithp@keithp.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Zorro Lang <zlang@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Introduce flexible array struct helpers
Message-ID: <202210260904.41D0BE00A@keescook>
References: <20221024171848.never.522-kees@kernel.org>
 <20221024172058.534477-1-keescook@chromium.org>
 <87k04pf4tk.fsf@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k04pf4tk.fsf@keithp.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 11:35:03AM -0700, Keith Packard wrote:
> Kees Cook <keescook@chromium.org> writes:
> 
> > + * struct flex_array_struct_example {
> > + *	...			 // arbitrary members
> > + *	bounded_flex_array(
> > + *		u16, part_count, // count of elements stored in "parts" below.
> > + *		u32, parts	 // flexible array with elements of type u32.
> > + *	);
> > + * );
> 
> > + * struct flex_array_struct_example {
> > + *	...		// position-sensitive members
> > + *	// count of elements stored in "parts" below.
> > + *	DECLARE_FAS_COUNT(u16, part_count);
> > + *	..		// position-sensitive members
> > + *	// flexible array with elements of type u32.
> > + *	DECLARE_FAS_ARRAY(u32, parts);
> > + * };
> 
> I'm sure there's a good reason, but these two macros appear to be doing
> similar things and yet have very different naming conventions. Maybe:
> 
>         FAS_DECLARE_COUNT(type, name)
>         FAS_DECLARE_ARRAY(type, name)
>         FAS_DECLARE(size_type, size_name, array_type, array_name)

Well, the custom has been for individual things, call it "DECLARE_*",
and for groups, we went with lower-case macros (e.g. struct_group()).

> 
> > +/* For use with flexible array structure helpers, in <linux/flex_array.h> */
> > +#define __DECLARE_FAS_COUNT(TYPE, NAME)					\
> > +	union {								\
> > +		TYPE __flex_array_elements_count;			\
> > +		TYPE NAME;						\
> > +	}
> 
> How often could that second "public" member be 'const'? That would catch
> places which accidentally assign to this field.
> 
> For code which does want to write to this field, is it mostly trimming
> data from the end, or does it actually smash in arbitrary values? For
> the former case, would it be helpful to have a test to make sure the
> assigned size isn't larger than the real size (yeah, that would probably
> take an extra field holding the real size), or larger than the current size?

I don't think this'll work within arbitrary struct declarations, but it
would be nice. :)

-- 
Kees Cook
