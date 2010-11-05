Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [PATCH 41/49] fs/xfs: Use vzalloc
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <10acc19712bf3d1e0ea68e7c16e1723922541249.1288925425.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	<10acc19712bf3d1e0ea68e7c16e1723922541249.1288925425.git.joe@perches.com>
Date: Fri, 05 Nov 2010 12:09:45 -0500
Message-ID: <1288976985.2295.25.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Joe Perches <joe@perches.com>
Cc: xfs-masters@oss.sgi.com, Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2010-11-04 at 20:08 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/xfs/linux-2.6/kmem.h |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
> index f7c8f7a..292eff1 100644
> --- a/fs/xfs/linux-2.6/kmem.h
> +++ b/fs/xfs/linux-2.6/kmem.h
> @@ -61,12 +61,7 @@ extern void  kmem_free(const void *);
>  
>  static inline void *kmem_zalloc_large(size_t size)
>  {
> -	void *ptr;
> -
> -	ptr = vmalloc(size);
> -	if (ptr)
> -		memset(ptr, 0, size);
> -	return ptr;
> +	return vzalloc(size);
>  }
>  static inline void kmem_free_large(void *ptr)
>  {

Looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
