Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4579D7F37
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:18:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4D10AC005
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:18:30 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	x65O0JFYqxVkzu73 for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:18:28 -0800 (PST)
Date: Fri, 13 Dec 2013 09:18:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/8] xfs: use xfs_icluster_size_fsb in xfs_bulkstat
Message-ID: <20131212221826.GH10988@dastard>
References: <52A96800.5080706@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A96800.5080706@oracle.com>
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

On Thu, Dec 12, 2013 at 03:38:40PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Use xfs_icluster_size_fsb() in xfs_bulkstat(), make the related
> variables more meaningful and remove an unused variable nimask
> from it.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

At some point we need to factor this code a bit to get rid of the
levels of indenting it has.....

> @@ -390,12 +386,12 @@ xfs_bulkstat(
>  				agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
>  				for (chunkidx = 0;
>  				     chunkidx < XFS_INODES_PER_CHUNK;
> -				     chunkidx += nicluster,
> -				     agbno += nbcluster) {
> -					if (xfs_inobt_maskn(chunkidx, nicluster)
> -							& ~r.ir_free)
> +				     chunkidx += inodes_per_cluster,
> +				     agbno += blks_per_cluster) {
> +					if (xfs_inobt_maskn(chunkidx,
> +					    inodes_per_cluster) & ~r.ir_free)
>  						xfs_btree_reada_bufs(mp, agno,
> -							agbno, nbcluster,
> +							agbno, blks_per_cluster,
>  							&xfs_inode_buf_ops);
>  				}
>  				blk_finish_plug(&plug);

e.g. this readahead loop could be factored into

static void
xfs_ichunk_ra(
	*mp, *rec, inodes_per_cluster, blks_per_cluster)
{
	blk_start_plug(&plug);
	agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
	     chunkidx += inodes_per_cluster, agbno += blks_per_cluster) {
		if (xfs_inobt_maskn(chunkidx, inodes_per_cluster) & ~r.ir_free)
			xfs_btree_reada_bufs(mp, agno, agbno, blks_per_cluster,
					     &xfs_inode_buf_ops);
	}
	blk_finish_plug(&plug);
}

Doing this to all the separate parts of the bulkstat code would make
it an awful lot easier to read and modify in future....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
