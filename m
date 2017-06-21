Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57054 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbdFUUkT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 16:40:19 -0400
Subject: Re: [PATCH 01/12] xfs_io: refactor numlen into a library function
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755895523.3625.10641288707827420905.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a0cf2a3a-66fd-1153-3629-4a0329e125eb@sandeen.net>
Date: Wed, 21 Jun 2017 15:40:18 -0500
MIME-Version: 1.0
In-Reply-To: <149755895523.3625.10641288707827420905.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/15/17 3:35 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the competing numlen implementations into a single library function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yay!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/input.h |    1 +
>  io/bmap.c       |   19 ++++---------------
>  io/fiemap.c     |   14 +-------------
>  libxcmd/input.c |   13 +++++++++++++
>  4 files changed, 19 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/include/input.h b/include/input.h
> index 221678e..82cd2f4 100644
> --- a/include/input.h
> +++ b/include/input.h
> @@ -28,6 +28,7 @@ extern char	**breakline(char *input, int *count);
>  extern void	doneline(char *input, char **vec);
>  extern char	*fetchline(void);
>  
> +extern size_t numlen(uint64_t val, size_t base);
>  extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
>  extern void	cvtstr(double value, char *str, size_t sz);
>  extern unsigned long cvttime(char *s);
> diff --git a/io/bmap.c b/io/bmap.c
> index 2333244..2e4ff7b 100644
> --- a/io/bmap.c
> +++ b/io/bmap.c
> @@ -18,6 +18,7 @@
>  
>  #include "platform_defs.h"
>  #include "command.h"
> +#include "input.h"
>  #include "init.h"
>  #include "io.h"
>  
> @@ -53,18 +54,6 @@ bmap_help(void)
>  "\n"));
>  }
>  
> -static int
> -numlen(
> -	off64_t	val)
> -{
> -	off64_t	tmp;
> -	int	len;
> -
> -	for (len = 0, tmp = val; tmp > 0; tmp = tmp/10)
> -		len++;
> -	return (len == 0 ? 1 : len);
> -}
> -
>  int
>  bmap_f(
>  	int			argc,
> @@ -323,7 +312,7 @@ bmap_f(
>  			if (map[i + 1].bmv_block == -1) {
>  				foff_w = max(foff_w, strlen(rbuf));
>  				tot_w = max(tot_w,
> -					numlen(map[i+1].bmv_length));
> +					numlen(map[i+1].bmv_length, 10));
>  			} else {
>  				snprintf(bbuf, sizeof(bbuf), "%lld..%lld",
>  					(long long) map[i + 1].bmv_block,
> @@ -344,10 +333,10 @@ bmap_f(
>  					aoff_w = 0;
>  				foff_w = max(foff_w, strlen(rbuf));
>  				tot_w = max(tot_w,
> -					numlen(map[i+1].bmv_length));
> +					numlen(map[i+1].bmv_length, 10));
>  			}
>  		}
> -		agno_w = is_rt ? 0 : max(MINAG_WIDTH, numlen(fsgeo.agcount));
> +		agno_w = is_rt ? 0 : max(MINAG_WIDTH, numlen(fsgeo.agcount, 10));
>  		printf("%4s: %-*s %-*s %*s %-*s %*s%s\n",
>  			_("EXT"),
>  			foff_w, _("FILE-OFFSET"),
> diff --git a/io/fiemap.c b/io/fiemap.c
> index bcbae49..75e8820 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -18,6 +18,7 @@
>  
>  #include "platform_defs.h"
>  #include "command.h"
> +#include "input.h"
>  #include <linux/fiemap.h>
>  #include "init.h"
>  #include "io.h"
> @@ -48,19 +49,6 @@ fiemap_help(void)
>  "\n"));
>  }
>  
> -static int
> -numlen(
> -	__u64	val,
> -	int	base)
> -{
> -	__u64	tmp;
> -	int	len;
> -
> -	for (len = 0, tmp = val; tmp > 0; tmp = tmp/base)
> -		len++;
> -	return (len == 0 ? 1 : len);
> -}
> -
>  static void
>  print_verbose(
>  	struct fiemap_extent	*extent,
> diff --git a/libxcmd/input.c b/libxcmd/input.c
> index 8aeb3b0..9437be3 100644
> --- a/libxcmd/input.c
> +++ b/libxcmd/input.c
> @@ -136,6 +136,19 @@ doneline(
>  	free(vec);
>  }
>  
> +size_t
> +numlen(
> +	uint64_t	val,
> +	size_t		base)
> +{
> +	uint64_t	tmp;
> +	size_t		len;
> +
> +	for (len = 0, tmp = val; tmp > 0; tmp = tmp / base)
> +		len++;
> +	return len == 0 ? 1 : len;
> +}
> +
>  #define EXABYTES(x)	((long long)(x) << 60)
>  #define PETABYTES(x)	((long long)(x) << 50)
>  #define TERABYTES(x)	((long long)(x) << 40)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
