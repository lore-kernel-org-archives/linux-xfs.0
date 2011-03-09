Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p29HVP07050382 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 11:31:30 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D756D1EB9AC2
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 09:34:04 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with SMTP id o7CYJOFTpIEv9uox for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 09:34:04 -0800 (PST)
Message-ID: <4D77BA0C.6080604@sandeen.net>
Date: Wed, 09 Mar 2011 11:34:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix a few build warnings
References: <201103041937.p24JbVtP004804@stout.americas.sgi.com>
In-Reply-To: <201103041937.p24JbVtP004804@stout.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On 3/4/11 1:37 PM, Alex Elder wrote:
> This patch fixes a few build warnings.  I have built the code using
> i386, x86_64, and ia64 architectures and each has ends up with
> complaints of one sort or anther.  This gets rid of all of them
> *except* those reported by files under the "ltp" (Linux Test
> Project) sub-tree.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  lib/tlibio.c                         |    2 +-
>  src/aio-dio-regress/aiodio_sparse2.c |    3 ++-
>  src/pwrite_mmap_blocked.c            |    3 ++-
>  src/unwritten_sync.c                 |    4 +++-
>  src/xfsctl.c                         |    2 ++
>  5 files changed, 10 insertions(+), 4 deletions(-)
> 
> Index: b/lib/tlibio.c
> ===================================================================
> --- a/lib/tlibio.c
> +++ b/lib/tlibio.c
> @@ -453,7 +453,7 @@ int
>  lio_random_methods(long curr_mask)
>  {
>      int mask=0;
> -    long random_bit();
> +    long random_bit(long);
>  
>      /* remove random select, io type, and wait method bits from curr_mask */
>      mask = curr_mask & (~(LIO_IO_TYPES | LIO_WAIT_TYPES | LIO_RANDOM));
> Index: b/src/aio-dio-regress/aiodio_sparse2.c
> ===================================================================
> --- a/src/aio-dio-regress/aiodio_sparse2.c
> +++ b/src/aio-dio-regress/aiodio_sparse2.c
> @@ -227,7 +227,8 @@ void aiodio_sparse(char *filename, int a
>  		unsigned char *badbuf;
>  
>  		if (debug)
> -			fprintf(stderr, "seek to %ld and read %d\n", offset, writesize);
> +			fprintf(stderr, "seek to %lld and read %d\n",
> +				(long long) offset, writesize);
>  		lseek(fd, offset, SEEK_SET);
>  		if (read(fd, bufptr, writesize) < writesize) {
>  			fprintf(stderr, "short read() at offset %lld\n",
> Index: b/src/pwrite_mmap_blocked.c
> ===================================================================
> --- a/src/pwrite_mmap_blocked.c
> +++ b/src/pwrite_mmap_blocked.c
> @@ -59,7 +59,8 @@ int main(int argc, char *argv[])
>  		perror("mmap");
>  		exit(1);
>  	}
> -	printf("pwrite %Ld bytes from %Ld to %Ld\n", amount, from, to);
> +	printf("pwrite %Ld bytes from %Ld to %Ld\n",
> +		(long long) amount, (long long) from, (long long) to);
>  
>  	ret = pwrite(fd, (char *)mapped_mem + from, amount, to);
>  	if (ret != amount) {
> Index: b/src/unwritten_sync.c
> ===================================================================
> --- a/src/unwritten_sync.c
> +++ b/src/unwritten_sync.c
> @@ -136,7 +136,9 @@ again:
>  		}
>  		if (bmapx[x].bmv_oflags & 1) {
>  			fprintf(stderr, "FOUND ONE %lld %lld %x\n",
> -				bmapx[x].bmv_offset, bmapx[x].bmv_length,bmapx[x].bmv_oflags);
> +				(long long) bmapx[x].bmv_offset,
> +				(long long) bmapx[x].bmv_length,
> +				bmapx[x].bmv_oflags);
>  			foundone = 1;
>  			foundany = 1;
>  		}
> Index: b/src/xfsctl.c
> ===================================================================
> --- a/src/xfsctl.c
> +++ b/src/xfsctl.c
> @@ -16,6 +16,8 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +#include <sys/stat.h>
> +
>  #include <xfs/xfs.h>
>  #include <xfs/jdm.h>
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
