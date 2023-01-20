Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033F9C25B4E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Jan 2023 14:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjATOST (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Jan 2023 09:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjATOSR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2023 09:18:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECF935B9
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 06:17:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A400B827E6
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 14:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5743DC433D2;
        Fri, 20 Jan 2023 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674224193;
        bh=8q9w7o9XU3uanTV08jBeMypXyN6tJNaSdbC1YCy52oE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XySKrANWbOMFeslYLBVQ+e4pDEwBPakvn13dYehn75Fm1SDLJdOnvpMmK4REkw2Un
         nx5Ugf/jFi9LZZHq4Ig8XlH3ClzQrGWS6ZMYRyPvPnSziq3RdIOeGfATTP6iNN8qxE
         IT4xJ722FljRS9U+SBIY/dnsH0s2SMo2UTwRw5Jzg+iorNSKx6vqUzp89849ggAomV
         +DiC4xMsMPkT3Qkc6Kgxtv661cDsbrEP+LFmXTwAdq8Cpw6TJ5bYMgX0aOC/K3H0Ff
         FM+Qav1Qh4i55mnKsL0bW6B70vjMU16GTHhrhZGkyM2fgU9bpCmyVLp9gHbe9etmjc
         kEIoXPl/cePEA==
Date:   Fri, 20 Jan 2023 15:16:28 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] progs: just use libtoolize
Message-ID: <20230120141628.ykbmgorafkigmsiw@andromeda>
References: <20230119233906.2055062-1-david@fromorbit.com>
 <lT1v7jcVQ8SFZ7wMkXACy6fDEPyvlw802lb9M280mFy5g-cdg8BfgquznfWR1gxDzkz61aLxtQcm1Q-J9Ibn3Q==@protonmail.internalid>
 <20230119233906.2055062-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119233906.2055062-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 20, 2023 at 10:39:06AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We no longer support xfsprogs on random platforms other than Linux,
> so drop the complexity in detecting the libtoolize binary on MacOS
> from the main makefile.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  Makefile | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c8455a9e665f..c12df98dbef3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -73,14 +73,6 @@ ifneq ("$(XGETTEXT)","")
>  TOOL_SUBDIRS += po
>  endif
> 
> -# If we are on OS X, use glibtoolize from MacPorts, as OS X doesn't have
> -# libtoolize binary itself.
> -LIBTOOLIZE_TEST=$(shell libtoolize --version >/dev/null 2>&1 && echo found)
> -LIBTOOLIZE_BIN=libtoolize
> -ifneq ("$(LIBTOOLIZE_TEST)","found")
> -LIBTOOLIZE_BIN=glibtoolize
> -endif
> -
>  # include is listed last so it is processed last in clean rules.
>  SUBDIRS = $(LIBFROG_SUBDIR) $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
> 
> @@ -116,7 +108,7 @@ clean:	# if configure hasn't run, nothing to clean
>  endif
> 
>  configure: configure.ac
> -	$(LIBTOOLIZE_BIN) -c -i -f
> +	libtoolize -c -i -f
>  	cp include/install-sh .
>  	aclocal -I m4
>  	autoconf
> --
> 2.39.0
> 

-- 
Carlos Maiolino
