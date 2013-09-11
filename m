Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62B2A7F37
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 16:33:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 356388F8040
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 14:33:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vVGolvnznKSeZ9hw for <xfs@oss.sgi.com>;
	Wed, 11 Sep 2013 14:33:33 -0700 (PDT)
Message-ID: <5230E1AB.9000909@sandeen.net>
Date: Wed, 11 Sep 2013 16:33:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] xfs: = vs == typo in ASSERT()
References: <20130911211731.GA10527@elgon.mountain>
In-Reply-To: <20130911211731.GA10527@elgon.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On 9/11/13 4:17 PM, Dan Carpenter wrote:
> There is a '=' vs '==' typo so the ASSERT()s are always true.

And worse, it assigns to di_format on a debug kernel, eek,
although should be modifying it to the thing it's supposed
to be anyway.  ;)  It's a self-healing ASSERT!  :)

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> Introduced in 21b5c9784b ('xfs: swap extents operations for CRC
> filesystems')
> 
> diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
> index 531b020..bb8de8e 100644
> --- a/fs/xfs/xfs_bmap_btree.c
> +++ b/fs/xfs/xfs_bmap_btree.c
> @@ -957,9 +957,9 @@ xfs_bmbt_change_owner(
>  	ASSERT(tp || buffer_list);
>  	ASSERT(!(tp && buffer_list));
>  	if (whichfork == XFS_DATA_FORK)
> -		ASSERT(ip->i_d.di_format = XFS_DINODE_FMT_BTREE);
> +		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_BTREE);
>  	else
> -		ASSERT(ip->i_d.di_aformat = XFS_DINODE_FMT_BTREE);
> +		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE);
>  
>  	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
>  	if (!cur)
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
