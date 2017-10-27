Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750851AbdJ0NsL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 09:48:11 -0400
Subject: Re: [PATCH 10/10] misc: fix ubsan warnings
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905615569.28563.17233201567221670601.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <046b0083-1065-c5cf-28ed-765e316383c9@sandeen.net>
Date: Fri, 27 Oct 2017 08:48:07 -0500
MIME-Version: 1.0
In-Reply-To: <150905615569.28563.17233201567221670601.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 10/26/17 5:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix all the things ubsan warned about.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/bitops.h   |    8 ++++----
>  include/command.h  |    2 +-
>  include/xfs_arch.h |    2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/include/bitops.h b/include/bitops.h
> index 44599a7..53a5aa0 100644
> --- a/include/bitops.h
> +++ b/include/bitops.h
> @@ -13,19 +13,19 @@ static inline int fls(int x)
>  	if (!x)
>  		return 0;
>  	if (!(x & 0xffff0000u)) {
> -		x <<= 16;
> +		x = (x & 0xFFFFU) << 16;

xfsprogs almost exclusively uses lowercase hex - as it does in the line
above your new code.  ;)  I can change it on the way in unless you object.

>  		r -= 16;
>  	}
>  	if (!(x & 0xff000000u)) {
> -		x <<= 8;
> +		x = (x & 0xFFFFFFU) << 8;
>  		r -= 8;
>  	}
>  	if (!(x & 0xf0000000u)) {
> -		x <<= 4;
> +		x = (x & 0xFFFFFFFU) << 4;
>  		r -= 4;
>  	}
>  	if (!(x & 0xc0000000u)) {
> -		x <<= 2;
> +		x = (x & 0x3FFFFFFFU) << 2;
>  		r -= 2;
>  	}
>  	if (!(x & 0x80000000u)) {
> diff --git a/include/command.h b/include/command.h
> index fb3f5c7..59eab96 100644
> --- a/include/command.h
> +++ b/include/command.h
> @@ -25,7 +25,7 @@
>   * not iterate the command args function callout and so can be used
>   * for functions like "help" that should only ever be run once.
>   */
> -#define CMD_FLAG_ONESHOT	(1<<31)
> +#define CMD_FLAG_ONESHOT	(1U<<31)
>  #define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
>  #define CMD_FLAG_LIBRARY	(1<<29)	/* command provided by libxcmd */

What complained about this?  cmd flags is a signed int, right, so why is
this a problem?  (And why are we only using the top 3 bits?  And let's just do 1U
on every flag if it's really needed, but why is it needed?  I must be missing
something.)

> diff --git a/include/xfs_arch.h b/include/xfs_arch.h
> index 186cadb..34fcd4d 100644
> --- a/include/xfs_arch.h
> +++ b/include/xfs_arch.h
> @@ -253,7 +253,7 @@ static inline uint16_t get_unaligned_be16(void *p)
>  static inline uint32_t get_unaligned_be32(void *p)
>  {
>  	uint8_t *__p = p;
> -        return __p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
> +        return (uint32_t)__p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
>  }
>  
>  static inline uint64_t get_unaligned_be64(void *p)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
