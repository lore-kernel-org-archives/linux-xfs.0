Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FBDC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 14:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344263AbhLFO3x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 09:29:53 -0500
Received: from sandeen.net ([63.231.237.45]:33190 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344279AbhLFO3u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Dec 2021 09:29:50 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0CAE3328A15;
        Mon,  6 Dec 2021 08:26:13 -0600 (CST)
Message-ID: <c7633bca-3cf2-f263-0ab8-0edaca7e9703@sandeen.net>
Date:   Mon, 6 Dec 2021 08:26:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     Thomas Goirand <zigo@debian.org>, 1000974@bugs.debian.org,
        Giovanni Mascellani <gio@debian.org>,
        xfslibs-dev@packages.debian.org, xfs <linux-xfs@vger.kernel.org>,
        gustavoars@kernel.org, keescook@chromium.org
References: <20211205174951.GQ8467@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH xfsprogs-5.14.2 URGENT] libxfs: hide the drainbamaged
 fallthrough macro from xfslibs
In-Reply-To: <20211205174951.GQ8467@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 12/5/21 11:49 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in mid-2021, Kees and Gustavo rammed into the kernel a bunch of
> static checker "improvements" that redefined '/* fallthrough */'
> comments for switch statements as a macro that virtualizes either that
> same comment, a do-while loop, or a compiler __attribute__.  This was
> necessary to work around the poor decision-making of the clang, gcc, and
> C language standard authors, who collectively came up with four mutually
> incompatible ways to document a lack of branching in a code flow.
> 
> Having received ZERO HELP porting this to userspace, Eric and I
> foolishly dumped that crap into linux.h, which was a poor decision
> because we keep forgetting that linux.h is exported as a userspace
> header.  This has now caused downstream regressions in Debian[1] and
> will probably cause more problems in the other distros.
> 
> Move it to platform_defs.h since that's not shipped publicly and leave a
> warning to anyone else who dare modify linux.h.
> 
> [1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1000974
> 
> Fixes: df9c7d8d ("xfs: Fix fall-through warnings for Clang")
> Cc: 1000974@bugs.debian.org, gustavoars@kernel.org, keescook@chromium.org
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Thanks Darrick, I'll get a 5.14.2 pushed out today. Not sure if it was you
or I who stuffed it into this header originally, but apologies for not
thinking that through before merging it in any case.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

> ---
>   include/linux.h            |   20 ++------------------
>   include/platform_defs.h.in |   21 +++++++++++++++++++++
>   2 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 24650228..054117aa 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -360,24 +360,8 @@ fsmap_advance(
>   #endif /* HAVE_MAP_SYNC */
>   
>   /*
> - * Add the pseudo keyword 'fallthrough' so case statement blocks
> - * must end with any of these keywords:
> - *   break;
> - *   fallthrough;
> - *   continue;
> - *   goto <label>;
> - *   return [expression];
> - *
> - *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
> + * Reminder: anything added to this file will be compiled into downstream
> + * userspace projects!
>    */
> -#if defined __has_attribute
> -#  if __has_attribute(__fallthrough__)
> -#    define fallthrough                    __attribute__((__fallthrough__))
> -#  else
> -#    define fallthrough                    do {} while (0)  /* fallthrough */
> -#  endif
> -#else
> -#    define fallthrough                    do {} while (0)  /* fallthrough */
> -#endif
>   
>   #endif	/* __XFS_LINUX_H__ */
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> index 7c6b3ada..6e6f26ef 100644
> --- a/include/platform_defs.h.in
> +++ b/include/platform_defs.h.in
> @@ -113,4 +113,25 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
>   		sizeof(*(p)->member) + __must_be_array((p)->member),	\
>   		sizeof(*(p)))
>   
> +/*
> + * Add the pseudo keyword 'fallthrough' so case statement blocks
> + * must end with any of these keywords:
> + *   break;
> + *   fallthrough;
> + *   continue;
> + *   goto <label>;
> + *   return [expression];
> + *
> + *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
> + */
> +#if defined __has_attribute
> +#  if __has_attribute(__fallthrough__)
> +#    define fallthrough                    __attribute__((__fallthrough__))
> +#  else
> +#    define fallthrough                    do {} while (0)  /* fallthrough */
> +#  endif
> +#else
> +#    define fallthrough                    do {} while (0)  /* fallthrough */
> +#endif
> +
>   #endif	/* __XFS_PLATFORM_DEFS_H__ */
> 
