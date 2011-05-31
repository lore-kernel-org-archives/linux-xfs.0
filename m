Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [TRIVIAL PATCH next 13/15] fs: Convert vmalloc/memset to vzalloc
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4561db676a209fff984a75ade2f552ddbfabb95b.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
	<4561db676a209fff984a75ade2f552ddbfabb95b.1306603968.git.joe@perches.com>
Date: Tue, 31 May 2011 13:20:39 -0500
Message-ID: <1306866039.2865.26.camel@doink>
MIME-Version: 1.0
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
Cc: codalist@TELEMANN.coda.cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, Jiri Kosina <trivial@kernel.org>, coda@cs.cmu.edu, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Sat, 2011-05-28 at 10:36 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/coda/coda_linux.h    |    5 ++---
>  fs/reiserfs/journal.c   |    9 +++------
>  fs/reiserfs/resize.c    |    4 +---
>  fs/xfs/linux-2.6/kmem.h |    7 +------
>  4 files changed, 7 insertions(+), 18 deletions(-)
> 

Acked-by: Alex Elder <aelder@sgi.com>

. . .

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



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
