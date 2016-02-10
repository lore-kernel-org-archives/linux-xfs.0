Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A56C29DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 19:39:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE67D8F804C
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 17:38:59 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wuMLWfvHLSlwahwT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 17:38:53 -0800 (PST)
Date: Tue, 9 Feb 2016 17:38:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: handle AGs without reservation in
	xfs_refcountbt_free_reserve_pool
Message-ID: <20160210013849.GB23904@birch.djwong.org>
References: <1455035539-24535-1-git-send-email-hch@lst.de>
	<1455035539-24535-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455035539-24535-2-git-send-email-hch@lst.de>
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

On Tue, Feb 09, 2016 at 05:32:19PM +0100, Christoph Hellwig wrote:
> See http://www.infradead.org/rpr.html
> 
> Without this xfstests starts crashing and burning in generic/003.

Good catch, thanks.  Will apply.

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_refcount_btree.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 31e1b2d..f78041c 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -539,6 +539,10 @@ xfs_refcountbt_free_reserve_pool(
>  	pool_len = 0;
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		pag = xfs_perag_get(mp, agno);
> +		if (!pag->pagf_refcountbt_resv) {
> +			xfs_perag_put(pag);
> +			continue;
> +		}
>  		i = xfs_ag_resv_blocks(pag->pagf_refcountbt_resv);
>  		if (pool_len < i)
>  			pool_len = i;
> -- 
> 2.1.4
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
