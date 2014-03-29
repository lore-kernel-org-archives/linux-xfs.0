Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 689357F3F
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 20:56:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3094D8F8074
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 18:56:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id H23UyamW7S8leGoK for <xfs@oss.sgi.com>;
	Fri, 28 Mar 2014 18:56:05 -0700 (PDT)
Message-ID: <53362834.7090900@sandeen.net>
Date: Fri, 28 Mar 2014 20:56:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] xfs: extra semi-colon breaks a condition
References: <20140328080313.GA25192@mwanda>
In-Reply-To: <20140328080313.GA25192@mwanda>
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

On 3/28/14, 3:03 AM, Dan Carpenter wrote:
> There were some extra semi-colons here which mean that we return true
> unintentionally.
> 
> Fixes: a49935f200e2 ('xfs: xfs_check_page_type buffer checks need help')

that's terrifying.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 98016b3..75df77d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -659,10 +659,10 @@ xfs_check_page_type(
>  			if (type == XFS_IO_UNWRITTEN)
>  				return true;
>  		} else if (buffer_delay(bh)) {
> -			if (type == XFS_IO_DELALLOC);
> +			if (type == XFS_IO_DELALLOC)
>  				return true;
>  		} else if (buffer_dirty(bh) && buffer_mapped(bh)) {
> -			if (type == XFS_IO_OVERWRITE);
> +			if (type == XFS_IO_OVERWRITE)
>  				return true;
>  		}
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
