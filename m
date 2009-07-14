Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [PATCH 1/2] fs/xfs: Drop unnecessary NULL test
References: <Pine.LNX.4.64.0907131209250.6808@ask.diku.dk>
From: Olaf Weber <olaf@sgi.com>
Date: Tue, 14 Jul 2009 12:34:43 +0200
Message-ID: <bzy7hybzh6k.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
To: Julia Lawall <julia@diku.dk>
Cc: xfs-masters@oss.sgi.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Julia Lawall writes:

> From: Julia Lawall <julia@diku.dk>
> The result of container_of should not be NULL.  In particular, in this case
> the argument to the enclosing function has passed though INIT_DELAYED_WORK,
> which dereferences it, implying that its container cannot be NULL.

Given the defn of container_of() it seems clear that neither its input
pointer nor its result should ever be NULL.

In this particular case, there is a check for NULL and early exit in
xfs_mru_cache_create(), the function that does the INIT_DELAYED_WORK().

Olaf

> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

> // <smpl>
> @@
> expression x,e;
> @@
> x = container_of(...)
> ... when != x = e
> * x == NULL
> // </smpl>

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-By: Olaf Weber <olaf@sgi.com>

> ---
>  fs/xfs/xfs_mru_cache.c              |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index 4b0613d..0651ce7 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -280,8 +280,8 @@ _xfs_mru_cache_reap(
>  	xfs_mru_cache_t		*mru = container_of(work, xfs_mru_cache_t, work.work);
>  	unsigned long		now, next;
 
> -	ASSERT(mru && mru->lists);
> -	if (!mru || !mru->lists)
> +	ASSERT(mru->lists);
> +	if (!mru->lists)
>  		return;
 
>  	spin_lock(&mru->lock);

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
