Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933907AbeE2VOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 17:14:52 -0400
Date: Tue, 29 May 2018 14:14:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: fix libxfs api violations in quota repair
 code
Message-ID: <20180529211436.GI30110@magnolia>
References: <6aeb5192-00b5-175d-fa3d-7864a2ba2d27@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aeb5192-00b5-175d-fa3d-7864a2ba2d27@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 29, 2018 at 03:40:14PM -0500, Eric Sandeen wrote:
> My "repair quotas" patch forgot about our libxfs API tricks,
> fix that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, with a suggestion for another patch...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 56f9f8c..63bf27e 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -126,6 +126,10 @@
>  #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
>  #define xfs_sb_to_disk			libxfs_sb_to_disk
> +#define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
> +#define xfs_dquot_verify		libxfs_dquot_verify
> +#define xfs_dquot_repair		libxfs_dquot_repair
> +
>  #define xfs_symlink_blocks		libxfs_symlink_blocks
>  #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
> diff --git a/repair/dinode.c b/repair/dinode.c
> index e8edcd4..49d5d05 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1345,7 +1345,7 @@ process_quota_inode(
>  	}
>  	dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
> -	dqperchunk = xfs_calc_dquots_per_chunk(dqchunklen);
> +	dqperchunk = libxfs_calc_dquots_per_chunk(dqchunklen);
>  	dqid = 0;
>  	qbno = NULLFILEOFF;
> @@ -1367,12 +1367,12 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
>  		dqb = bp->b_addr;
>  		for (i = 0; i < dqperchunk; i++, dqid++, dqb++) {
> -			xfs_failaddr_t	fa;
>  			int		bad_dqb = 0;
>  			/* We only print the first problem we find */
>  			if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -				if (!xfs_verify_cksum((char *)dqb, sizeof(*dqb),
> +				if (!libxfs_verify_cksum((char *)dqb,
> +							sizeof(*dqb),
>  							XFS_DQUOT_CRC_OFF)) {
>  					do_warn(_("%s: bad CRC for id %u. "),
>  							quota_string, dqid);
> @@ -1388,8 +1388,8 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
>  					goto bad;
>  				}
>  			}
> -			fa = xfs_dquot_verify(mp, &dqb->dd_diskdq, dqid, quota_type, 0);
> -			if (fa) {
> +			if (libxfs_dquot_verify(mp, &dqb->dd_diskdq, dqid,
> +						quota_type, 0) != NULL) {
>  				do_warn(_("%s: Corrupt quota for id %u. "),
>  						quota_string, dqid);
>  				bad_dqb = 1;
> @@ -1401,7 +1401,8 @@ bad:
>  					do_warn(_("Would correct.\n"));
>  				else {
>  					do_warn(_("Corrected.\n"));
> -					xfs_dquot_repair(mp, &dqb->dd_diskdq, dqid, quota_type);
> +					libxfs_dquot_repair(mp, &dqb->dd_diskdq,
> +							    dqid, quota_type);

Repair ought to check that return value, right?

--D

>  					writebuf = 1;
>  				}
>  			}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
