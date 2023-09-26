Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F28AE7E642
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Sep 2023 14:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbjIZOlK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbjIZOlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 10:41:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CA1E6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 07:41:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C63C433C8;
        Tue, 26 Sep 2023 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695739263;
        bh=J9dCyXNEmKgoVXWsrtvNpovfVdrqv5Kf+kCXTC5N+Ik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=swZHsqqLON334Q7/+EPGazJUd3v3FmroP0aMUY5AcRG9MgfgkBCw8iSB3uUcmkgYL
         BEVSzNCKoOnDsfFxdNUqHlq3EO8Iu7N3KguyvX2nZF0XnS2g2eGshTAa9Dh+nZqZGC
         zF52CLxJk6+k9MfCJrSYgE3WKiL26yVoZDPjPmiQFtouoRbouX73Hc3p14R3bRFOzK
         Arg2M4lc/FEQuuyYeOh+hF+omhRdyYgSXlTBJz9cr+lgXKyy+v5Xkavdfh8d9j9Mc8
         OKbpOHZ64VpMkElVgKv8eR150Z4aEFDBe1L0402brOujdtv/6BgEWjqbpQ2jo2Hxpe
         tK35qvrwugkNA==
Date:   Tue, 26 Sep 2023 07:41:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Krzesimir Nowak <qdlacz@gmail.com>,
        Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Krzesimir Nowak <knowak@microsoft.com>
Subject: Re: [PATCH 1/1] libfrog: Fix cross-compilation issue with randbytes
Message-ID: <20230926144100.GD11439@frogsfrogsfrogs>
References: <20230926071432.51866-1-knowak@microsoft.com>
 <20230926071432.51866-2-knowak@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926071432.51866-2-knowak@microsoft.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 09:14:32AM +0200, Krzesimir Nowak wrote:
> randbytes.c was mostly split off from crc32.c and, like crc32.c, is
> used for selftests, which are run on the build host. As such it should
> not include platform_defs.h which in turn includes urcu.h from
> userspace-rcu library, because the build host might not have the
> library installed.

Why not get rid of the build host crc32c selftest?  It's not that useful
for cross-compiling and nowadays mkfs.xfs and xfs_repair have their own
builtin selftests.  Anyone messing with xfsprogs should be running
fstests (in addition to the maintainers) so I don't really see the point
of running crc32cselftest on the *build* host.

(Carlos: any thoughts on this?)

--D

> Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>
> ---
>  libfrog/randbytes.c | 1 -
>  libfrog/randbytes.h | 2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/libfrog/randbytes.c b/libfrog/randbytes.c
> index f22da0d3..2023b601 100644
> --- a/libfrog/randbytes.c
> +++ b/libfrog/randbytes.c
> @@ -6,7 +6,6 @@
>   *
>   * This is the buffer of random bytes used for self tests.
>   */
> -#include "platform_defs.h"
>  #include "libfrog/randbytes.h"
>  
>  /* 4096 random bytes */
> diff --git a/libfrog/randbytes.h b/libfrog/randbytes.h
> index 00fd7c4c..fddea9c7 100644
> --- a/libfrog/randbytes.h
> +++ b/libfrog/randbytes.h
> @@ -6,6 +6,8 @@
>  #ifndef __LIBFROG_RANDBYTES_H__
>  #define __LIBFROG_RANDBYTES_H__
>  
> +#include <stdint.h>
> +
>  extern uint8_t randbytes_test_buf[];
>  
>  #endif /* __LIBFROG_RANDBYTES_H__ */
> -- 
> 2.25.1
> 
