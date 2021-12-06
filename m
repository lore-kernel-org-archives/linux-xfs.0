Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9F4C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 14:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244424AbhLFOjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 09:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242092AbhLFOjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 09:39:46 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37067C061746
        for <linux-xfs@vger.kernel.org>; Mon,  6 Dec 2021 06:36:18 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1muF6F-00060m-5b; Mon, 06 Dec 2021 14:36:15 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1000974: [PATCH xfsprogs-5.14.2 URGENT] libxfs: hide the drainbamaged fallthrough macro from xfslibs
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 1000974@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1000974
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Keywords: 
References: <20211205174951.GQ8467@magnolia> <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1000974-submit@bugs.debian.org id=B1000974.163880136122913
          (code B ref 1000974); Mon, 06 Dec 2021 14:36:14 +0000
Received: (at 1000974) by bugs.debian.org; 6 Dec 2021 14:36:01 +0000
Received: from sandeen.net ([63.231.237.45]:51752)
        by buxtehude.debian.org with esmtp (Exim 4.92)
        (envelope-from <sandeen@sandeen.net>)
        id 1muF60-0005xO-VR
        for 1000974@bugs.debian.org; Mon, 06 Dec 2021 14:36:01 +0000
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
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20211205174951.GQ8467@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: delayed 578 seconds by postgrey-1.36 at buxtehude; Mon, 06 Dec 2021 14:36:00 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20211206142619.QX4gqefuTXSKCfu7vnJMWOnFkBZa6vbExEUGRSs-Wfc@z>


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
