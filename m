Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48887 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdDLGLK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 02:11:10 -0400
Date: Tue, 11 Apr 2017 23:11:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: allow write -d to dqblks
Message-ID: <20170412061103.GK8502@birch.djwong.org>
References: <20170411225334.GE8502@birch.djwong.org>
 <4e5eaa1f-b551-885b-6d1c-e90f985496be@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5eaa1f-b551-885b-6d1c-e90f985496be@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Apr 11, 2017 at 10:45:27PM -0500, Eric Sandeen wrote:
> Allow write -d to write bad data and recalculate CRC
> for dqblks.
> 
> Inspired-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/db/io.c b/db/io.c
> index 67ed5f9..9918a51 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -476,6 +476,17 @@ xfs_verify_recalc_inode_crc(
>  }
>  
>  void
> +xfs_verify_recalc_dquot_crc(
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
>  xfs_verify_recalc_crc(
>  	struct xfs_buf *bp)
>  {
> diff --git a/db/io.h b/db/io.h
> index 12d96c2..b415b82 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -65,6 +65,7 @@ extern void     ring_add(void);
>  extern void	set_iocur_type(const struct typ *t);
>  extern void	xfs_dummy_verify(struct xfs_buf *bp);
>  extern void	xfs_verify_recalc_inode_crc(struct xfs_buf *bp);
> +extern void	xfs_verify_recalc_dquot_crc(struct xfs_buf *bp);
>  extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
>  
>  /*
> diff --git a/db/write.c b/db/write.c
> index 70c9865..d24ea05 100644
> --- a/db/write.c
> +++ b/db/write.c
> @@ -139,7 +139,8 @@ write_f(
>  
>  	if (invalid_data &&
>  	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
> -	    !iocur_top->ino_buf) {
> +	    !iocur_top->ino_buf &&
> +	    !iocur_top->dquot_buf) {
>  		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
>  		return 0;
>  	}
> @@ -169,6 +170,9 @@ write_f(
>  	} else if (iocur_top->ino_buf) {
>  		local_ops.verify_write = xfs_verify_recalc_inode_crc;
>  		dbprintf(_("Allowing write of corrupted inode with good CRC\n"));
> +	} else if (iocur_top->dquot_buf) {
> +		local_ops.verify_write = xfs_verify_recalc_dquot_crc;
> +		dbprintf(_("Allowing write of corrupted dquot with good CRC\n"));
>  	} else { /* invalid data */
>  		local_ops.verify_write = xfs_verify_recalc_crc;
>  		dbprintf(_("Allowing write of corrupted data with good CRC\n"));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
