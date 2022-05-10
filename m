Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAF1C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 18:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245668AbiEJSwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 14:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349088AbiEJSwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 14:52:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5944F9FF
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 11:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED43B81F95
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB53EC385C2;
        Tue, 10 May 2022 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652208719;
        bh=jbS4dPXOSDWInATYTilPcGMX6m86BbDVaV97UVq9gKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hwh/JXvfSDvuu647CFmsLER47U2EkGOlTw1nPVW9gQb/il+A3sLFScyXaoFl4oBmK
         wGRADlwKR/SvTBWuc6IZ9/jbitjfBg3u8/SVUzG05i7/gOjZ48d2D2I/++0RW7XTgP
         ipvT/hPwog7aAaHYf5qgtWDE1iIeSaiLzL7pU9W7GOzZ0s/CpirGgbadJNHwK0X5xQ
         n60YOLcPbVwY8aiLd1/V0j32hk99wmNMkQ2S1vHNk9FXJ45FLXmupeXVB+IxfZKVCf
         5VwKx2dCTYiWvXKXxihZ5hti6wf1riiUoYjZMEqzbxFU/z8Ss3LIXDB1GJH6f6QaIy
         x3aIx1kT6Qkwg==
Date:   Tue, 10 May 2022 11:51:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] io/mmap.c: fix musl build on mips64
Message-ID: <20220510185159.GA27195@magnolia>
References: <20220508193029.1277260-1-fontaine.fabrice@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508193029.1277260-1-fontaine.fabrice@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 08, 2022 at 09:30:29PM +0200, Fabrice Fontaine wrote:
> musl undefines MAP_SYNC on some architectures such as mips64 since
> version 1.1.20 and
> https://github.com/ifduyue/musl/commit/9b57db3f958d9adc3b1c7371b5c6723aaee448b7
> resulting in the following build failure:
> 
> mmap.c: In function 'mmap_f':
> mmap.c:196:33: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
>   196 |                         flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>       |                                 ^~~~~~~~
>       |                                 MS_SYNC
> 
> This build failure is raised because header includes have been tangled
> up:
> 
> input.h -> libfrog/projects.h -> xfs.h -> linux.h.
> 
> As a result, linux.h will be included before sys/mman.h and the
> following piece of code from linux.h will be "overriden" on platforms
> without MAP_SYNC:
> 
>  #ifndef HAVE_MAP_SYNC
>  #define MAP_SYNC 0
>  #define MAP_SHARED_VALIDATE 0
>  #else
>  #include <asm-generic/mman.h>
>  #include <asm-generic/mman-common.h>
>  #endif /* HAVE_MAP_SYNC */
> 
> To fix this build failure, include <sys/mman.h> before the other
> includes.
> 
> A more long-term solution would be to untangle the headers.
> 
> Fixes:
>  - http://autobuild.buildroot.org/results/3296194907baf7d3fe039f59bcbf595aa8107a28
> 
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Changes v1 -> v2 (after review of Dave Chinner):
>  - Update commit message
> 
>  io/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/mmap.c b/io/mmap.c
> index 8c048a0a..b8609295 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -4,9 +4,9 @@
>   * All Rights Reserved.
>   */
>  
> +#include <sys/mman.h>
>  #include "command.h"
>  #include "input.h"
> -#include <sys/mman.h>
>  #include <signal.h>
>  #include "init.h"
>  #include "io.h"
> -- 
> 2.35.1
> 
