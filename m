Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNMFoEn010439 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 16:15:50 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 6/6] XFS: Reference count per-ag structures
Date: Wed, 23 Dec 2009 16:12:56 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A68D3@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1260857477-2368-7-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> Reference count the per-ag structures to ensure that we keep get/put
> pairs balanced. Assert that the reference counts are zero at unmount
> time to catch leaks. In future, reference counts will enable us to
> safely remove perag structures by allowing us to detect when they
> are no longer in use.

Looks good.  Two comments below; I'll fix up if you want.

> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
. . .
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 73d61d4..1d00f7f 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -215,6 +215,7 @@ xfs_free_perag(
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		spin_lock(&mp->m_perag_lock);
>  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> +		ASSERT(atomic_read(&pag->pag_ref) == 0);
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);

This ASSERT(pag) should be moved up before ASSERT(atomic_read(&pag->pag_ref == 0)

>  		kmem_free(pag->pagb_list);
. . .
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index cfa7a5d..16b2212 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
. . .
> @@ -393,6 +393,12 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
> 
>  	spin_lock(&mp->m_perag_lock);
>  	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> +	if (pag) {
> +		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> +		/* catch leaks in the positive direction during testing */
> +		ASSERT(atomic_read(&pag->pag_ref) < 1000);

This is good; what makes 1000 a reasonable number (why not
100 or 10000?)

> +		atomic_inc(&pag->pag_ref);
> +	}
>  	spin_unlock(&mp->m_perag_lock);
>  	return pag;
>  }
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
