Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04B717F37
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 09:38:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E85C7304062
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 07:38:40 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id n38665bsoDxuej1E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Sep 2013 07:38:37 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r8KEcZ5C010524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 14:38:36 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8KEcY6C010661
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 14:38:35 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8KEcYxU017042 for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 14:38:34 GMT
Message-ID: <523C5E17.1020408@oracle.com>
Date: Fri, 20 Sep 2013 22:39:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: improve xfs_iext_destroy() by freeing extent
	indirection array directly
References: <523C4BD0.7040309@oracle.com>
In-Reply-To: <523C4BD0.7040309@oracle.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 09/20/2013 09:21 PM, Jeff Liu wrote:

> From: Jie Liu <jeff.liu@oracle.com>
> 
> To free the incore file extents stores at the indirection array, we
> call the common routine xfs_iext_irec_remove() to remove a record
> from the array one at a time in reverse order, which will resize an
> extent indirection array repeatedly according to the array size.
> 
> This is not often the case to make a file with thousands extent records
> stores at an indirection array, but above operation is inefficient and
> could result in memory fragments.
> 
> This patch refine xfs_iext_destroy() by freeing the extent records from
> the indirection array directly in this case.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_inode_fork.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> index 02f1083..ba70f98 100644
> --- a/fs/xfs/xfs_inode_fork.c
> +++ b/fs/xfs/xfs_inode_fork.c
> @@ -1525,9 +1525,12 @@ xfs_iext_destroy(
>  		int	nlists;
>  
>  		nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
> -		for (erp_idx = nlists - 1; erp_idx >= 0 ; erp_idx--) {
> -			xfs_iext_irec_remove(ifp, erp_idx);
> +		for (erp_idex = 0; erp_idx < nlists; erp_idx++) {

Sorry, here is a typo, s/erp_idex/erp_idx/, will resend it.

> +			xfs_ext_irec_t	*erp = &ifp->if_u1.if_ext_irec[erp_idx];
> +			if (erp->er_extbuf)
> +				kmem_free(erp->er_extbuf);
>  		}
> +		kmem_free(ifp->if_u1.if_ext_irec);
>  		ifp->if_flags &= ~XFS_IFEXTIREC;
>  	} else if (ifp->if_real_bytes) {
>  		kmem_free(ifp->if_u1.if_extents);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
