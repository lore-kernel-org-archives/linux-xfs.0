Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40798 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdHCQ6v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 12:58:51 -0400
Date: Thu, 3 Aug 2017 09:58:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/7] xfs_db: use TYP_F_CRC_FUNC for inodes & dquots
Message-ID: <20170803165843.GT4477@magnolia>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153525206.26081.8927560161890396433.stgit@magnolia>
 <ddf6bf02-e210-e299-6966-b7d926da4d2e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddf6bf02-e210-e299-6966-b7d926da4d2e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Aug 03, 2017 at 11:47:24AM -0500, Eric Sandeen wrote:
> Now that typ_t has a ->set_crc method, use it for inodes & dquots
> as well, rather than recognizing them as special types and calling
> their crc functions directly by name.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/db/dquot.c b/db/dquot.c
> index 061eca5..4e35df4 100644
> --- a/db/dquot.c
> +++ b/db/dquot.c
> @@ -171,6 +171,17 @@ dquot_f(
>  }
>  
>  void
> +xfs_dquot_set_crc(
> +	struct xfs_buf *bp)
> +{
> +	ASSERT((iocur_top->dquot_buf));
> +	ASSERT(iocur_top->bp == bp);
> +
> +	xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
> +			 XFS_DQUOT_CRC_OFF);
> +}
> +
> +void
>  dquot_init(void)
>  {
>  	add_command(&dquot_cmd);
> diff --git a/db/dquot.h b/db/dquot.h
> index 83a5118..12a7244 100644
> --- a/db/dquot.h
> +++ b/db/dquot.h
> @@ -20,4 +20,5 @@ extern const struct field	disk_dquot_flds[];
>  extern const struct field	dqblk_flds[];
>  extern const struct field	dqblk_hfld[];
>  
> +extern void	xfs_dquot_set_crc(struct xfs_buf *);
>  extern void	dquot_init(void);
> diff --git a/db/fuzz.c b/db/fuzz.c
> index e1c2045..a9b1577 100644
> --- a/db/fuzz.c
> +++ b/db/fuzz.c
> @@ -125,8 +125,7 @@ fuzz_f(
>  		return 0;
>  	}
>  
> -	if (invalid_data && iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
> -			!iocur_top->ino_buf && !iocur_top->dquot_buf) {
> +	if (invalid_data && iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF) {
>  		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
>  		return 0;
>  	}
> @@ -153,12 +152,6 @@ fuzz_f(
>  	if (corrupt) {
>  		local_ops.verify_write = xfs_dummy_verify;
>  		dbprintf(_("Allowing fuzz of corrupted data and bad CRC\n"));
> -	} else if (iocur_top->ino_buf) {
> -		local_ops.verify_write = xfs_verify_recalc_inode_crc;
> -		dbprintf(_("Allowing fuzz of corrupted inode with good CRC\n"));
> -	} else if (iocur_top->dquot_buf) {
> -		local_ops.verify_write = xfs_verify_recalc_dquot_crc;
> -		dbprintf(_("Allowing fuzz of corrupted dquot with good CRC\n"));
>  	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
>  		local_ops.verify_write = iocur_top->typ->set_crc;
>  		dbprintf(_("Allowing fuzz of corrupted data with good CRC\n"));
> diff --git a/db/inode.c b/db/inode.c
> index 6cc47d6..6f971c6 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -711,3 +711,14 @@ _("Metadata CRC error detected for ino %lld\n"),
>  	/* track updated info in ring */
>  	ring_add();
>  }
> +
> +void
> +xfs_inode_set_crc(
> +	struct xfs_buf *bp)
> +{
> +	ASSERT(iocur_top->ino_buf);
> +	ASSERT(iocur_top->bp == bp);
> +
> +	libxfs_dinode_calc_crc(mp, iocur_top->data);
> +	iocur_top->ino_crc_ok = 1;
> +}
> diff --git a/db/inode.h b/db/inode.h
> index 1624f1d..d79b0a4 100644
> --- a/db/inode.h
> +++ b/db/inode.h
> @@ -33,4 +33,5 @@ extern void	inode_init(void);
>  extern typnm_t	inode_next_type(void);
>  extern int	inode_size(void *obj, int startoff, int idx);
>  extern int	inode_u_size(void *obj, int startoff, int idx);
> +extern void	xfs_inode_set_crc(struct xfs_buf *);
>  extern void	set_cur_inode(xfs_ino_t ino);
> diff --git a/db/io.c b/db/io.c
> index fd9b9f4..9787dea 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -466,28 +466,6 @@ xfs_dummy_verify(
>  }
>  
>  void
> -xfs_verify_recalc_inode_crc(
> -	struct xfs_buf *bp)
> -{
> -	ASSERT(iocur_top->ino_buf);
> -	ASSERT(iocur_top->bp == bp);
> -
> -	libxfs_dinode_calc_crc(mp, iocur_top->data);
> -	iocur_top->ino_crc_ok = 1;
> -}
> -
> -void
> -xfs_verify_recalc_dquot_crc(
> -	struct xfs_buf *bp)
> -{
> -	ASSERT((iocur_top->dquot_buf));
> -	ASSERT(iocur_top->bp == bp);
> -
> -	xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
> -			 XFS_DQUOT_CRC_OFF);
> -}
> -
> -void
>  xfs_verify_recalc_crc(
>  	struct xfs_buf *bp)
>  {
> diff --git a/db/io.h b/db/io.h
> index df0fdd7..374dd84 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -64,8 +64,6 @@ extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
>  extern void     ring_add(void);
>  extern void	set_iocur_type(const struct typ *type);
>  extern void	xfs_dummy_verify(struct xfs_buf *bp);
> -extern void	xfs_verify_recalc_inode_crc(struct xfs_buf *bp);
> -extern void	xfs_verify_recalc_dquot_crc(struct xfs_buf *bp);
>  extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
>  
>  /*
> diff --git a/db/type.c b/db/type.c
> index 740adc0..00f580a 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -105,12 +105,12 @@ static const typ_t	__typtab_crc[] = {
>  	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
>  		&xfs_dir3_db_buf_ops, TYP_F_CRC_FUNC, xfs_dir3_set_crc },
>  	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
> -		&xfs_dquot_buf_ops, TYP_F_NO_CRC_OFF },
> +		&xfs_dquot_buf_ops, TYP_F_CRC_FUNC, xfs_dquot_set_crc },
>  	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld,
>  		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
>  	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
> -		&xfs_inode_buf_ops, TYP_F_NO_CRC_OFF },
> +		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> @@ -149,12 +149,12 @@ static const typ_t	__typtab_spcrc[] = {
>  	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
>  		&xfs_dir3_db_buf_ops, TYP_F_CRC_FUNC, xfs_dir3_set_crc },
>  	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
> -		&xfs_dquot_buf_ops, TYP_F_NO_CRC_OFF },
> +		&xfs_dquot_buf_ops, TYP_F_CRC_FUNC, xfs_dquot_set_crc },
>  	{ TYP_INOBT, "inobt", handle_struct, inobt_spcrc_hfld,
>  		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
>  	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
> -		&xfs_inode_buf_ops, TYP_F_NO_CRC_OFF },
> +		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>  	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
> diff --git a/db/write.c b/db/write.c
> index 266bde4..8f8a6f7 100644
> --- a/db/write.c
> +++ b/db/write.c
> @@ -167,12 +167,6 @@ write_f(
>  	if (corrupt) {
>  		local_ops.verify_write = xfs_dummy_verify;
>  		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
> -	} else if (iocur_top->ino_buf) {
> -		local_ops.verify_write = xfs_verify_recalc_inode_crc;
> -		dbprintf(_("Allowing write of corrupted inode with good CRC\n"));
> -	} else if (iocur_top->dquot_buf) {
> -		local_ops.verify_write = xfs_verify_recalc_dquot_crc;
> -		dbprintf(_("Allowing write of corrupted dquot with good CRC\n"));
>  	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
>  		local_ops.verify_write = iocur_top->typ->set_crc;
>  		dbprintf(_("Allowing write of corrupted data with good CRC\n"));
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
