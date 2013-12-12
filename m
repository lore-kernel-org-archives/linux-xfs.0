Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0AA997F37
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:10:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ED72F304048
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:09:56 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dGFkYNyEqxeJjlUn for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:09:55 -0800 (PST)
Date: Fri, 13 Dec 2013 09:09:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/8] xfs: get rid of XFS_IALLOC_BLOCKS macros
Message-ID: <20131212220953.GF10988@dastard>
References: <52A967E9.7070508@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A967E9.7070508@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Dec 12, 2013 at 03:38:17PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Get rid of XFS_IALLOC_BLOCKS() marcos, use mp->m_ialloc_blks directly.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
....
> @@ -1228,9 +1228,9 @@ xfs_difree(
>  			goto error0;
>  		}
>  
> -		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
> -				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
> -				XFS_IALLOC_BLOCKS(mp), flist, mp);
> +		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
> +				  XFS_INO_TO_AGBNO(mp, rec.ir_startino)),
> +				  mp->m_ialloc_blks, flist, mp);
>  	} else {
>  		*delete = 0;
>  

git-am fails to apply this hunk, but I'm not sure why. I updated it
manually, the resulting patch looks identical.

Other than that, it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
