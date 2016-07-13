Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BAFE7CA4
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 13:28:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37EB230404E
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 11:28:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hussdSlfKKzQBbxI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 11:28:16 -0700 (PDT)
Date: Wed, 13 Jul 2016 14:28:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 039/119] xfs: add rmap btree insert and delete helpers
Message-ID: <20160713182813.GB34396@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612652222.12839.8353722216601177344.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612652222.12839.8353722216601177344.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Thu, Jun 16, 2016 at 06:22:02PM -0700, Darrick J. Wong wrote:
> Add a couple of helper functions to encapsulate rmap btree insert and
> delete operations.  Add tracepoints to the update function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/libxfs/xfs_rmap.c       |   78 +++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_rmap_btree.h |    3 ++
>  2 files changed, 80 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 53ba14e..f92eaa1 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -92,13 +92,89 @@ xfs_rmap_update(
...
> +STATIC int
> +xfs_rmapbt_delete(

This throws an unused warning that persists to the end of the rmap
patches..?

Brian

> +	struct xfs_btree_cur	*rcur,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len,
> +	uint64_t		owner,
> +	uint64_t		offset,
> +	unsigned int		flags)
> +{
> +	int			i;
> +	int			error;
> +
> +	trace_xfs_rmapbt_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
> +			len, owner, offset, flags);
> +
> +	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
> +	if (error)
> +		goto done;
> +	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
> +
> +	error = xfs_btree_delete(rcur, &i);
> +	if (error)
> +		goto done;
> +	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
> +done:
> +	if (error)
> +		trace_xfs_rmapbt_delete_error(rcur->bc_mp,
> +				rcur->bc_private.a.agno, error, _RET_IP_);
> +	return error;
>  }
>  
>  static int
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 9d92da5..6674340 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -64,6 +64,9 @@ int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
>  int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
>  		xfs_extlen_t len, uint64_t owner, uint64_t offset,
>  		unsigned int flags, int *stat);
> +int xfs_rmapbt_insert(struct xfs_btree_cur *rcur, xfs_agblock_t agbno,
> +		xfs_extlen_t len, uint64_t owner, uint64_t offset,
> +		unsigned int flags);
>  int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
>  		int *stat);
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
