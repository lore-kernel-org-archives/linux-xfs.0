Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D4267F52
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 09:07:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1E5BAC003
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 07:07:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bSuLbACb8okuGJUq for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 07:07:42 -0800 (PST)
Message-ID: <52EBBC3D.5030507@sandeen.net>
Date: Fri, 31 Jan 2014 09:07:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: improve xfs_bitmap_empty()
References: <52EBAF91.10608@oracle.com>
In-Reply-To: <52EBAF91.10608@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/31/14, 8:13 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> There is no need to travel through the whole bitmap items to verify
> if the bitmap array is empty or not, instead, just return 0 directly
> if an item is detected in bitmap array.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Makes sense (and the long loop was my fault, I guess, but it's 
better than it was, see commit 24ad33f!)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I wonder if something like:

return (find_first_set(map, size) == size);

would be faster (or if it'd be worth it)...?
Probably not.  :)

> ---
>  fs/xfs/xfs_bit.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bit.c b/fs/xfs/xfs_bit.c
> index 0e8885a..ae0acc2 100644
> --- a/fs/xfs/xfs_bit.c
> +++ b/fs/xfs/xfs_bit.c
> @@ -32,13 +32,13 @@ int
>  xfs_bitmap_empty(uint *map, uint size)
>  {
>  	uint i;
> -	uint ret = 0;
>  
>  	for (i = 0; i < size; i++) {
> -		ret |= map[i];
> +		if (map[i])
> +			return 0;
>  	}
>  
> -	return (ret == 0);
> +	return 1;
>  }
>  
>  /*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
