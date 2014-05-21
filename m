Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 91C8C7F3F
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 07:44:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AEFCAC00A
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 05:44:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lUpW93qiG1KzgVa9 for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 05:44:10 -0700 (PDT)
Message-ID: <537C9F98.8020306@sandeen.net>
Date: Wed, 21 May 2014 07:44:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] [XFS] indent an if statement
References: <20140521122746.GD23396@mwanda>
In-Reply-To: <20140521122746.GD23396@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On 5/21/14, 7:27 AM, Dan Carpenter wrote:
> The "n += 32;" goes with the if statement on the line before so it
> should be indented.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Easy one ;)

Wow, it's been this way ever since 79071eb0 in 2008.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> diff --git a/fs/xfs/xfs_bit.h b/fs/xfs/xfs_bit.h
> index f1e3c90..f685942 100644
> --- a/fs/xfs/xfs_bit.h
> +++ b/fs/xfs/xfs_bit.h
> @@ -67,7 +67,7 @@ static inline int xfs_lowbit64(__uint64_t v)
>  	} else {	/* upper bits */
>  		w = (__uint32_t)(v >> 32);
>  		if (w && (n = ffs(w)))
> -		n += 32;
> +			n += 32;
>  	}
>  	return n - 1;
>  }
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
