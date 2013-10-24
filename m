Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E2CC7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 13:39:26 -0500 (CDT)
Date: Thu, 24 Oct 2013 13:39:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/19] xfs: vectorise directory data operations
Message-ID: <20131024183909.GV1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-14-git-send-email-david@fromorbit.com>
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

On Tue, Oct 15, 2013 at 09:17:59AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Following from the initial patches to vectorise the shortform
> directory encode/decode operations, convert half the data block
> operations to use the vector. The rest will be done in a second
> patch.
> 
> This further reduces the size of the built binary:
> 
>    text    data     bss     dec     hex filename
>  794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
>  792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
>  792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
>  789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Generally looks pretty good, I have a question below...

>  const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> @@ -223,6 +415,18 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.sf_put_ino = xfs_dir3_sfe_put_ino,
>  	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
>  	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
> +
> +	.data_entsize = xfs_dir3_data_entsize,
> +	.data_get_ftype = xfs_dir3_data_get_ftype,
> +	.data_put_ftype = xfs_dir3_data_put_ftype,
> +	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
> +
> +	.data_dot_offset = xfs_dir2_data_dot_offset,
> +	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
> +	.data_first_offset = xfs_dir2_data_first_offset,
> +	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
> +	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
> +	.data_first_entry_p = xfs_dir2_data_first_entry_p,
>  };

I think there may be a problem here.  Although the dirv2 functions for
., .., and first entry offset account for the v2 header size, they
appear not to be accounting for the modified entry size due to the file
type field.  Am I missing something?

> @@ -1158,32 +1159,32 @@ xfs_dir2_sf_to_block(
>  	/*
>  	 * Create entry for .
>  	 */
> -	dep = xfs_dir3_data_dot_entry_p(mp, hdr);
> +	dep = dp->d_ops->data_dot_entry_p(hdr);
>  	dep->inumber = cpu_to_be64(dp->i_ino);
>  	dep->namelen = 1;
>  	dep->name[0] = '.';
> -	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
> -	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
> +	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
> +	tagp = dp->d_ops->data_entry_tag_p(dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> -	xfs_dir2_data_log_entry(tp, bp, dep);
> +	xfs_dir2_data_log_entry(tp, dp, bp, dep);
>  	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
>  	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
>  				(char *)dep - (char *)hdr));
>  	/*
>  	 * Create entry for ..
>  	 */
> -	dep = xfs_dir3_data_dotdot_entry_p(mp, hdr);
> +	dep = dp->d_ops->data_dotdot_entry_p(hdr);
>  	dep->inumber = cpu_to_be64(dp->d_ops->sf_get_parent_ino(sfp));
>  	dep->namelen = 2;
>  	dep->name[0] = dep->name[1] = '.';
> -	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
> -	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
> +	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
> +	tagp =dp->d_ops-> data_entry_tag_p(dep);

	tagp = dp->d_ops->data_entry_tag_p(dep);

> diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
> index ccfeb4d..571e173 100644
> --- a/fs/xfs/xfs_dir2_data.c
> +++ b/fs/xfs/xfs_dir2_data.c
> @@ -62,12 +62,26 @@ __xfs_dir3_data_check(
>  	char			*p;		/* current data position */
>  	int			stale;		/* count of stale leaves */
>  	struct xfs_name		name;
> +	const struct xfs_dir_ops *ops;
>  
>  	mp = bp->b_target->bt_mount;
>  	hdr = bp->b_addr;
>  	bf = xfs_dir3_data_bestfree_p(hdr);
>  	p = (char *)xfs_dir3_data_entry_p(hdr);
>  
> +	/*
> +	 * we can be passed a null dp here froma verifier, so manually configure

					   from a 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
