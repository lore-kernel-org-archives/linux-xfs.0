Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49734 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdIJQaB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 10 Sep 2017 12:30:01 -0400
Subject: Re: [PATCH 1/5] Include fcntl.h for O_EXCL
References: <20170910003035.14285-1-raj.khem@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4f90efff-6e15-7641-1dfc-974380b7ba56@sandeen.net>
Date: Sun, 10 Sep 2017 11:30:00 -0500
MIME-Version: 1.0
In-Reply-To: <20170910003035.14285-1-raj.khem@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>, linux-xfs@vger.kernel.org

Hm, in looking over these, I see that Felix Janda
already sent patches to fix all this back in Jan 2016;
[PATCH 0/6] xfsdump: Compile with musl libc

That was around the time of a maintainer handoff, and
it looks like they go lost.  Since Felix did the original
work, and those patches are already reviewed, I
think I'll pick them up to solve your issues.  Thanks for the
reminder though; unfortunately I /just/ released a new xfsdump
version, but this is probably reason enough to do a fresh release
so you (and Felix) can stop carrying patches.

In Felix's patches as well as in yours, the changelogs could
be improved a bit to say /why/ the changes are being made,
i.e. to support musl, which is more pedantic.  I'll add that
info on commit.

Thanks,
-Eric

On 9/9/17 7:30 PM, Khem Raj wrote:
> Fix
> error: 'O_CREAT' undeclared (first use in this function)
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  invutil/invidx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/invutil/invidx.c b/invutil/invidx.c
> index 67efdf7..325a9a1 100644
> --- a/invutil/invidx.c
> +++ b/invutil/invidx.c
> @@ -27,6 +27,7 @@
>  #include <sys/stat.h>
>  #include <string.h>
>  #include <uuid/uuid.h>
> +#include <fcntl.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> 
