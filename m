Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65E3D7F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 315AC304032
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 11:19:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zqZYAFQ2n1QZftG8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 11:19:38 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 29656A4CD6
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 18:19:38 +0000 (UTC)
Date: Mon, 31 Aug 2015 14:19:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix error gotos in xfs_setattr_nonsize
Message-ID: <20150831181935.GC16371@bfoster.bfoster>
References: <55DF80BA.9020101@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55DF80BA.9020101@redhat.com>
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

On Thu, Aug 27, 2015 at 04:27:22PM -0500, Eric Sandeen wrote:
> As the code stands today, if xfs_trans_reserve() fails, we
> goto out_dqrele, which does not free the allocated transaction.
> 
> Fix up the goto targets to undo everything properly.
> 
> Addresses-Coverity-Id: 145571
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> Full disclosure: build tested only, as these are error paths
> which we don't easily fail...
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 766b23f..8294132 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -609,7 +609,7 @@ xfs_setattr_nonsize(
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
>  	if (error)
> -		goto out_dqrele;
> +		goto out_trans_cancel;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> @@ -640,7 +640,7 @@ xfs_setattr_nonsize(
>  						NULL, capable(CAP_FOWNER) ?
>  						XFS_QMOPT_FORCE_RES : 0);
>  			if (error)	/* out of quota */
> -				goto out_trans_cancel;
> +				goto out_unlock;
>  		}
>  	}
>  
> @@ -729,10 +729,10 @@ xfs_setattr_nonsize(
>  
>  	return 0;
>  
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -out_dqrele:
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
>  	return error;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
