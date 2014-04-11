Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99E8C29DF7
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:03:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F635304066
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:03:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ng9p0Av80xo1WsVU for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:03:33 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3BJ3X7s027870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 15:03:33 -0400
Date: Fri, 11 Apr 2014 15:03:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/14] xfsprogs: free resources in
	libxfs_alloc_file_space error paths
Message-ID: <20140411190330.GC16717@laptop.bfoster>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
	<1396999504-13769-9-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1396999504-13769-9-git-send-email-sandeen@redhat.com>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 08, 2014 at 06:24:58PM -0500, Eric Sandeen wrote:
> The bmap freelist & transaction pointer weren't
> being freed in libxfs_alloc_file_space error paths;
> more or less copy the error handling that exists
> in kernelspace to resolve this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  libxfs/util.c |   20 +++++++++++++++++---
>  1 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 1b05540..f1aa4c6 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -582,8 +582,17 @@ libxfs_alloc_file_space(
>  		resblks = (uint)XFS_DIOSTRAT_SPACE_RES(mp, datablocks);
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
>  					  resblks, 0);
> -		if (error)
> +		/*
> +		 * Check for running out of space
> +		 */
> +		if (error) {
> +			/*
> +			 * Free the transaction structure.
> +			 */
> +			ASSERT(error == ENOSPC); /* XXX ERS? */

XXX ?

> +			xfs_trans_cancel(tp, 0);
>  			break;
> +		}
>  		xfs_trans_ijoin(tp, ip, 0);
>  		xfs_trans_ihold(tp, ip);
>  
> @@ -593,12 +602,12 @@ libxfs_alloc_file_space(
>  				&reccount, &free_list);
>  
>  		if (error)
> -			break;
> +			goto error0;
>  
>  		/* complete the transaction */
>  		error = xfs_bmap_finish(&tp, &free_list, &committed);
>  		if (error)
> -			break;
> +			goto error0;
>  
>  		error = xfs_trans_commit(tp, 0);
>  		if (error)
> @@ -612,6 +621,11 @@ libxfs_alloc_file_space(
>  		allocatesize_fsb -= allocated_fsb;
>  	}
>  	return error;
> +
> +error0:	/* Cancel bmap, unlock inode, cancel trans */

Nit, but since it appears we don't lock the inode, the comment is wrong.

Brian

> +	xfs_bmap_cancel(&free_list);
> +	xfs_trans_cancel(tp, 0);
> +	return error;
>  }
>  
>  unsigned int
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
