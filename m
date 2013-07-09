Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A4977F55
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 13:02:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F07CB8F8068
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 11:02:11 -0700 (PDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
	[209.85.215.49]) by cuda.sgi.com with ESMTP id XkA76XO5KVPHPAJ7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Jul 2013 11:02:10 -0700 (PDT)
Received: by mail-la0-f49.google.com with SMTP id ea20so4920421lab.22
	for <xfs@oss.sgi.com>; Tue, 09 Jul 2013 11:02:09 -0700 (PDT)
Date: Tue, 9 Jul 2013 22:02:05 +0400
From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH] [MMOTM] xfs: fix dquot isolation hang
Message-ID: <20130709180203.GD9188@localhost.localdomain>
References: <1373265261-30314-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373265261-30314-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: glommer@openvz.org, linux-mm@kvack.org, mhocko@suze.cz, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com

Michal and Andrew, here is the patch

On Mon, Jul 08, 2013 at 04:34:21PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The new LRU list isolation code in xfs_qm_dquot_isolate() isn't
> completely up to date.  Firstly, it needs conversion to return enum
> lru_status values, not raw numbers. Secondly - most importantly - it
> fails to unlock the dquot and relock the LRU in the LRU_RETRY path.
> This leads to deadlocks in xfstests generic/232. Fix them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_qm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 46743cf..a10a720 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -659,7 +659,7 @@ xfs_qm_dquot_isolate(
>  		trace_xfs_dqreclaim_want(dqp);
>  		list_del_init(&dqp->q_lru);
>  		XFS_STATS_DEC(xs_qm_dquot_unused);
> -		return 0;
> +		return LRU_REMOVED;
>  	}
>  
>  	/*
> @@ -705,17 +705,19 @@ xfs_qm_dquot_isolate(
>  	XFS_STATS_DEC(xs_qm_dquot_unused);
>  	trace_xfs_dqreclaim_done(dqp);
>  	XFS_STATS_INC(xs_qm_dqreclaims);
> -	return 0;
> +	return LRU_REMOVED;
>  
>  out_miss_busy:
>  	trace_xfs_dqreclaim_busy(dqp);
>  	XFS_STATS_INC(xs_qm_dqreclaim_misses);
> -	return 2;
> +	return LRU_SKIP;
>  
>  out_unlock_dirty:
>  	trace_xfs_dqreclaim_busy(dqp);
>  	XFS_STATS_INC(xs_qm_dqreclaim_misses);
> -	return 3;
> +	xfs_dqunlock(dqp);
> +	spin_lock(lru_lock);
> +	return LRU_RETRY;
>  }
>  
>  static unsigned long
> -- 
> 1.8.3.2
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
