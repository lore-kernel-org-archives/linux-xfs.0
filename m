Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A72C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Oct 2022 03:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJTDFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Oct 2022 23:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJTDFo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Oct 2022 23:05:44 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8582E692
        for <linux-xfs@vger.kernel.org>; Wed, 19 Oct 2022 20:05:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m6so19084978pfb.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Oct 2022 20:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wEl73zYiyCZRYeY8GRbvNLUlF2BoygoZ6siYepxupO4=;
        b=KyPf4YSo2fdSCuwLXXoELT8f8hoq/6mHp/coYbuC98NMxNmwuU9b15osetPysrUspu
         sktHt+jFnzxGv3Xgd5NQgO3spfYDiFNFhHR9qAM0AQV2LW+uS38wzheH/mBRNqEJFy6C
         1//1803iUOgFMx34XOUfk8WHzV95V4D4CU3h0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEl73zYiyCZRYeY8GRbvNLUlF2BoygoZ6siYepxupO4=;
        b=gWJhdEQPSuQamXvOpoilrW6j6Rm6KM4/Tb3JQgJJPn2llA4jd/pucPGo3uxfO5o32y
         lkn9Y3l5WaadsyIWnctBEStorZVVrhD9zAIlpBFC68VTc0XoKsyd/8r9LYIGgFfkLOFr
         Fkr+rjSe7gjTecnqFYi8lNgrjzU+5BCcAf/44qiHwZMxjsWyO3KeT8Sl5y6AhvOKI1I9
         8GwRV24hYPuVJN6oF8OSnOwUe5Xvc2QgkJ5TY4AgR2emsQslqVel6/G9JRNW853zlCc6
         YGkL+NElmU4qAGopQbJE8v2QaxBaDUxc/3Ztl16utPCjQRJ5EemSvmFEpX5NFvoTFayL
         MVqw==
X-Gm-Message-State: ACrzQf2gHM+vTiuafR3/AACCgTG0flMJhSXgbDUzFZVGxECf1e4boKwg
        Kw+ZebtDwePJ68iO9M0a9Pa2Red2lfy7AQ==
X-Google-Smtp-Source: AMsMyM6uy8Kmc6qC8QV/oF1BPpkrAO9MeeKAf0ZcO9TExbpShBsd4Rzn8zwt5IS5jogmvOcpAp6iJw==
X-Received: by 2002:a05:6a00:1707:b0:566:15a1:8b07 with SMTP id h7-20020a056a00170700b0056615a18b07mr11661937pfc.34.1666235140900;
        Wed, 19 Oct 2022 20:05:40 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z20-20020a17090a8b9400b001fdcb792181sm611435pjn.43.2022.10.19.20.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 20:05:40 -0700 (PDT)
Date:   Wed, 19 Oct 2022 20:05:38 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: fix FORTIFY_SOURCE complaints about log item
 memcpy
Message-ID: <202210191948.FF93D98E0B@keescook>
References: <Y1CQe9FWctRg3OZI@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1CQe9FWctRg3OZI@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 19, 2022 at 05:04:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> memcpy.  Unfortunately, it doesn't handle VLAs correctly:

Nit-pick on terminology: these are "flexible array structures" (structures
that end with a "flexible array member"); VLAs are a different (removed
from the kernel) beast.

> memcpy: detected field-spanning write (size 48) of single field "dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)

Step right up; XFS is next to trip[1] this check. Let's get this fixed...

> We know the memcpy going
> on here is correct because I've run all the log recovery tests with
> KASAN turned on, and it does not detect actual memory misuse.

Yup, this is a false positive.

> My first attempt to work around this problem was to cast the arguments
> [...]
> My second attempt changed the cast to a (void *), with the same results
> [...]
> My third attempt was to pass the void pointers directly into
> [...]
> My fourth attempt collapsed the _copy_format function into the callers
> [...]

The point here is to use a better API, which is fallible and has the
ability to perform the bounds checking itself. I had proposed an initial
version of this idea here[2].

[1] https://lore.kernel.org/all/?q=%22field-spanning+write%22
[2] https://lore.kernel.org/llvm/20220504014440.3697851-3-keescook@chromium.org/

> "These cases end up appearing to the compiler to be sized as if the
> flexible array had 0 elements. :( For more details see:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101832
> https://godbolt.org/z/vW6x8vh4P ".
> 
> I don't /quite/ think that turning off CONFIG_FORTIFY_SOURCE is the
> right solution here, but in the meantime this is causing a lot of fstest
> failures, and I really need to get back to fixing user reported data
> corruption problems instead of dealing with gcc stupidity. :(

I think XFS could be a great first candidate for using something close
to the proposed flex_cpy() API. What do you think of replacing the
memcpy() calls with something like this instead:

-	if (buf->i_len == len) {
-		memcpy(dst_bui_fmt, src_bui_fmt, len);
-		return 0;
-	}
+	if (buf->i_len == len &&
+	    flex_cpy(dst_bui_fmt, src_bui_fmt,
+		     bui_nextents, bui_extents) == 0)
		return 0;
	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
	return -EFSCORRUPTED;

To avoid passing in the element count and element array fields, the
alias macros could be used:

struct xfs_bui_log_format {
	uint16_t		bui_type;	/* bui log item type */
	uint16_t		bui_size;	/* size of this item */
	/* # extents to free */
	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(uint32_t, bui_nextents);
	uint64_t		bui_id;		/* bui identifier */
	/* array of extents to bmap */
	DECLARE_FLEX_ARRAY_ELEMENTS(struct xfs_map_extent, bui_extents);
};

What do you think about these options? In the meantime, unsafe_memcpy()
should be fine for v6.1.

BTW, this FORTIFY_SOURCE change was present in linux-next for the entire
prior development cycle. Are the xfstests not run on -next kernels?

-Kees

-- 
Kees Cook
