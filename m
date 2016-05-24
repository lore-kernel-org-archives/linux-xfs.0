Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6AF1A7CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 20:30:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B2E1304032
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 18:30:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id G4lEQ57ya7SAmVEJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 18:30:18 -0700 (PDT)
Date: Mon, 23 May 2016 18:30:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH,reflink] xfs: use GPF_NOFS in xfs_refcountbt_init_cursor
Message-ID: <20160524013009.GB32417@birch.djwong.org>
References: <1464016077-26513-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464016077-26513-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, May 23, 2016 at 05:07:57PM +0200, Christoph Hellwig wrote:
> As it can be called under the ilock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 770aee5..3391cbd 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -339,7 +339,7 @@ xfs_refcountbt_init_cursor(
>  
>  	ASSERT(agno != NULLAGNUMBER);
>  	ASSERT(agno < mp->m_sb.sb_agcount);
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
> +	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);

Looks reasonable, though I suspect the rmapbt cursor needs the same
treatment, since it too can be called that way, I think.

/me has been wondering if all of those cursor allocations ought to be
KM_NOFS, though I haven't had time to investigate that.

--D

>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> -- 
> 2.1.4
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
