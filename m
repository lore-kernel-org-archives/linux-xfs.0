Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBA307F50
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 08:39:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94366AC005
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 06:39:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mLaF8FKYg9TRnnrV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 06:39:20 -0800 (PST)
Date: Thu, 8 Jan 2015 09:39:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix implicit bool to int conversion
Message-ID: <20150108143913.GD33789@bfoster.bfoster>
References: <1420721391-22717-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420721391-22717-1-git-send-email-der.herr@hofr.at>
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
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jan 08, 2015 at 01:49:51PM +0100, Nicholas Mc Guire wrote:
> try_wait_for_completion returns bool so the wrapper function
> xfs_dqflock_nowait should probably also return bool and not int. 
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---

Indeed...

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> patch was only compile tested x86_64_defconfig + CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> 
> patch is against linux-next 3.19.0-rc3 -next-20150107
> 
>  fs/xfs/xfs_dquot.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index c24c67e..2f536f3 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -86,7 +86,7 @@ static inline void xfs_dqflock(xfs_dquot_t *dqp)
>  	wait_for_completion(&dqp->q_flush);
>  }
>  
> -static inline int xfs_dqflock_nowait(xfs_dquot_t *dqp)
> +static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
>  {
>  	return try_wait_for_completion(&dqp->q_flush);
>  }
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
