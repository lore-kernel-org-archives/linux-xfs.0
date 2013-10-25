Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F397A7F51
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 16:51:17 -0500 (CDT)
Date: Fri, 25 Oct 2013 16:51:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 18/19] xfs: vectorise directory leaf operations
Message-ID: <20131025215114.GB1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-19-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Oct 15, 2013 at 09:18:04AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Next step in the vectorisation process is the directory free block
> encode/decode operations. There are relatively few of these, though
> there are quite a numberof calls to them.
> 
> Binary sizes:
> 
>    text    data     bss     dec     hex filename
>  794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
>  792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
>  792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
>  789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
>  789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
>  789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
>  789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
>  791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
>  791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_da_format.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_da_format.h | 39 ---------------------
>  fs/xfs/xfs_dir2.h      |  5 +++
>  fs/xfs/xfs_dir2_leaf.c |  2 +-
>  fs/xfs/xfs_dir2_node.c | 61 +++++++++++++++++----------------
>  5 files changed, 129 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
> index d81cff7..a76b044e 100644
> --- a/fs/xfs/xfs_da_format.c
> +++ b/fs/xfs/xfs_da_format.c
> @@ -629,6 +629,80 @@ xfs_da3_node_hdr_to_disk(
>  /*
>   * Directory free space block operations
>   */
> +static int
> +xfs_dir2_free_hdr_size(void)
> +{
> +	return sizeof(struct xfs_dir2_free_hdr);
> +}
> +
> +static int
> +xfs_dir2_free_max_bests(struct xfs_mount *mp)
> +{
> +	return (mp->m_dirblksize - xfs_dir2_free_hdr_size()) /
> +		sizeof(xfs_dir2_data_off_t);
> +}
> +
> +static __be16 *
> +xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
> +{
> +	return (__be16 *)((char *)free + xfs_dir2_free_hdr_size());
> +}
> +
> +/*
> + * Convert data space db to the corresponding free db.
> + */
> +static xfs_dir2_db_t
> +xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
> +{
> +	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir2_free_max_bests(mp);
> +}
> +
> +/*
> + * Convert data space db to the corresponding index in a free db.
> + */
> +static int
> +xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
> +{
> +	return db % xfs_dir2_free_max_bests(mp);
> +}
> +
> +static int
> +xfs_dir3_free_hdr_size(void)
> +{
> +	return sizeof(struct xfs_dir3_free_hdr);
> +}
> +
> +static int
> +xfs_dir3_free_max_bests(struct xfs_mount *mp)
> +{
> +	return (mp->m_dirblksize - xfs_dir3_free_hdr_size()) /
> +		sizeof(xfs_dir2_data_off_t);
> +}
> +
> +static __be16 *
> +xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
> +{
> +	return (__be16 *)((char *)free + xfs_dir3_free_hdr_size());
> +}
> +
> +/*
> + * Convert data space db to the corresponding free db.
> + */
> +static xfs_dir2_db_t
> +xfs_dir3_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
> +{
> +	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir3_free_max_bests(mp);
> +}
> +
> +/*
> + * Convert data space db to the corresponding index in a free db.
> + */
> +static int
> +xfs_dir3_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
> +{
> +	return db % xfs_dir3_free_max_bests(mp);
> +}
> +
>  static void
>  xfs_dir2_free_hdr_from_disk(
>  	struct xfs_dir3_icfree_hdr	*to,
> @@ -721,6 +795,14 @@ const struct xfs_dir_ops xfs_dir2_ops = {
>  	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
>  	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
> +
> +	.free_hdr_size = xfs_dir2_free_hdr_size,
> +	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
> +	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
> +	.free_max_bests = xfs_dir2_free_max_bests,
> +	.free_bests_p = xfs_dir2_free_bests_p,
> +	.db_to_fdb = xfs_dir2_db_to_fdb,
> +	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
>  
>  const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> @@ -761,8 +843,13 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,
>  
> +	.free_hdr_size = xfs_dir2_free_hdr_size,
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
> +	.free_max_bests = xfs_dir2_free_max_bests,
> +	.free_bests_p = xfs_dir2_free_bests_p,
> +	.db_to_fdb = xfs_dir2_db_to_fdb,
> +	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
>  
>  const struct xfs_dir_ops xfs_dir3_ops = {
> @@ -803,8 +890,13 @@ const struct xfs_dir_ops xfs_dir3_ops = {
>  	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
>  	.node_tree_p = xfs_da3_node_tree_p,
>  
> +	.free_hdr_size = xfs_dir3_free_hdr_size,
>  	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
> +	.free_max_bests = xfs_dir2_free_max_bests,
			  ^^^^^^^^^^^^^^^^^^^^^^^

Looks like here is where the dir2_free_max_bests issue crept in.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
