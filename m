Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 694C97F60
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 15:04:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 064F7AC001
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 13:04:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IthPHPt50t0UJXVc for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 13:04:08 -0800 (PST)
Date: Fri, 15 Nov 2013 08:04:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: Fix stray semicolon in libxfs/rdwr.c
Message-ID: <20131114210406.GQ6188@dastard>
References: <5285386A.8020800@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5285386A.8020800@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 14, 2013 at 02:54:02PM -0600, Eric Sandeen wrote:
> The commit:
> 
> 800db1c1 libxfs: refactor libxfs_buf_read_map for xfs_db
> 
> introduced a stray semicolon during the refactoring.  Luckily it
> only breaks the error case.
> 
> (Caught by Coverity, CID 1128894)

My fault, but really, this is something that gcc should warn about
because it's almost always a bug....

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 0aa2eba..0219a08 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -754,7 +754,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp,
>  		offset += len;
>  	}
>  
> -	if (!error);
> +	if (!error)
>  		bp->b_flags |= LIBXFS_B_UPTODATE;
>  #ifdef IO_DEBUG
>  	printf("%lx: %s: read %u bytes, error %d, blkno=0x%llx(0x%llx), %p\n",

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
