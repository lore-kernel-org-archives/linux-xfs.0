Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36486 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388109AbeGWX7Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 19:59:16 -0400
Subject: Re: [PATCH 7/7] libxfs: remove crc32 functions
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728634020.22515.16684194597988861920.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <29c32d83-dfe8-8780-1808-f2c019a78fc5@sandeen.net>
Date: Mon, 23 Jul 2018 15:55:46 -0700
MIME-Version: 1.0
In-Reply-To: <152728634020.22515.16684194597988861920.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 5/25/18 3:12 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> XFS uses crc32c, not crc32.  Remove the unnecessary crc32 code, which
> decreases binary size by the 8K crc32 table.

Getting back to this ...

The files have diverged a bit since the initial lift from the kernel.
Commenting out to keep things diffable is a bit pointless now, due
to that divergence (for example, the crc32test stuff has been moved
out to its own file, a big swath of code.)

So, I think we should make a decision about whether we want to try
to keep this in sync with the kernel, or just let it drift.

If the former, I'd go with an #if 0 but only after syncing things
up again.

If the latter, just nuke the unused code, if we ever need the crc32c
variants we can re-lift them from the kernel.  I'd still take a brief
look at whether there's anything that needs to be synced in an ad-hoc
fashion.

I guess right now I'm feeling inclined to go with the former, and
even add the crc32 file(s) to the libxfs-diff and/or libxfs-apply
scripts, if we plan to keep them more in sync.

I'd accept either plan, really - but there's no reason to comment
out or #ifdef code to keep it around if it doesn't even necessarily
match kernelspace anymore.

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/libxfs.h        |    3 ---
>  libxfs/crc32.c          |   16 ++++++++++------
>  libxfs/gen_crc32table.c |    8 +++++++-
>  libxfs/libxfs_priv.h    |    3 ---
>  4 files changed, 17 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index fbaae089..109866de 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -43,10 +43,7 @@
>  
>  
>  /* CRC stuff, buffer API dependent on it */
> -extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
>  extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
> -
> -#define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
>  #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
>  
>  #include "xfs_cksum.h"
> diff --git a/libxfs/crc32.c b/libxfs/crc32.c
> index 783d62e9..8fe5c42c 100644
> --- a/libxfs/crc32.c
> +++ b/libxfs/crc32.c
> @@ -176,20 +176,26 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
>  }
>  
>  #if CRC_LE_BITS == 1
> +/*
> + * not used by xfs.
>  u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
>  {
>  	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
>  }
> + */

...
