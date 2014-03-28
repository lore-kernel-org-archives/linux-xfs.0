Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 189587F4E
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 07:09:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED7408F8066
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 05:09:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cE7W4SsbdKZIyIoQ for
	<xfs@oss.sgi.com>; Fri, 28 Mar 2014 05:09:27 -0700 (PDT)
Date: Fri, 28 Mar 2014 08:09:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [patch] xfs: extra semi-colon breaks a condition
Message-ID: <20140328120917.GA21961@bfoster.bfoster>
References: <20140328080313.GA25192@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Fri, Mar 28, 2014 at 11:03:13AM +0300, Dan Carpenter wrote:
> There were some extra semi-colons here which mean that we return true
> unintentionally.
> 
> Fixes: a49935f200e2 ('xfs: xfs_check_page_type buffer checks need help')
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

Nice catch.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
