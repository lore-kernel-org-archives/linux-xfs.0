Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B76377F5A
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 00:20:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98D988F804B
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:20:16 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	r92O3nWPZe3kB9A8 for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 22:20:12 -0800 (PST)
Date: Thu, 3 Dec 2015 17:19:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfsprogs: xfs_repair: fix possible null
	dereference in build_ino_tree
Message-ID: <20151203061943.GX26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-9-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449055167-19936-9-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 04:49:24PM +0530, Vivek Trivedi wrote:
> Fix possible null dereference in build_ino_tree if ino_rec is NULL.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  repair/phase5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 109e37b..5d95e22 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -1235,7 +1235,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		if (lptr->modulo > 0)
>  			lptr->modulo--;
>  
> -		if (lptr->num_recs_pb > 0)
> +		if (lptr->num_recs_pb > 0 && ino_rec)
>  			prop_ino_cursor(mp, agno, btree_curs,
>  					ino_rec->ino_startnum, 0);
>  

Another "can't happen" case. The only time that ino_rec can be zero
is if there are no inodes in the AG, and in that case
init_ino_cursor() initialises lptr->num_recs_pb = 0.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
