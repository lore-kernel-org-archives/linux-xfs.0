Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39664 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbeEAQNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 12:13:47 -0400
Date: Tue, 1 May 2018 09:13:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] xfs: remove unused flags arg from xfs_dquot_verify
Message-ID: <20180501161327.GE4127@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <51e940bc-9bcd-0fe6-ac90-003eae7e24f0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51e940bc-9bcd-0fe6-ac90-003eae7e24f0@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 01:49:09PM -0500, Eric Sandeen wrote:
> Long ago the flags argument was used to determine whether
> to issue warnings about corruptions, but that's done elsewhere
> now and the flag is unused here, so remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  | 5 ++---
>  fs/xfs/libxfs/xfs_quota_defs.h | 3 +--
>  fs/xfs/xfs_dquot.c             | 2 +-
>  fs/xfs/xfs_log_recover.c       | 4 ++--
>  fs/xfs/xfs_qm.c                | 2 +-
>  5 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 8b7a6c3..a926058 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -47,8 +47,7 @@
>  	struct xfs_mount *mp,
>  	xfs_disk_dquot_t *ddq,
>  	xfs_dqid_t	 id,
> -	uint		 type,	  /* used only when IO_dorepair is true */
> -	uint		 flags)
> +	uint		 type)	  /* used only when IO_dorepair is true */
>  {
>  	/*
>  	 * We can encounter an uninitialized dquot buffer for 2 reasons:
> @@ -200,7 +199,7 @@
>  		if (i == 0)
>  			id = be32_to_cpu(ddq->d_id);
>  
> -		fa = xfs_dquot_verify(mp, ddq, id + i, 0, 0);
> +		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
>  		if (fa)
>  			return fa;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index bb1b13a..8433656 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -152,8 +152,7 @@
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
>  extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
> -		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type,
> -		uint flags);
> +		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>  extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
>  		xfs_dqid_t id, uint type);
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 43572f8..7e203f9 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1003,7 +1003,7 @@
>  	/*
>  	 * A simple sanity check in case we got a corrupted dquot..
>  	 */
> -	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0, 0);
> +	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
>  				be32_to_cpu(ddqp->d_id), fa);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 00240c9..3b35feb 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2702,7 +2702,7 @@ struct xfs_buf_cancel {
>  				goto next;
>  			}
>  			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
> -					       -1, 0, 0);
> +					       -1, 0);
>  			if (fa) {
>  				xfs_alert(mp,
>  	"dquot corrupt at %pS trying to replay into block 0x%llx",
> @@ -3353,7 +3353,7 @@ struct xfs_buf_cancel {
>  	 */
>  	dq_f = item->ri_buf[0].i_addr;
>  	ASSERT(dq_f);
> -	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0, 0);
> +	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
>  				dq_f->qlf_id, fa);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 5b848f4..64c22c32 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -867,7 +867,7 @@ struct xfs_qm_isolate {
>  		 * find uninitialised dquot blks. See comment in
>  		 * xfs_dquot_verify.
>  		 */
> -		fa = xfs_dquot_verify(mp, ddq, id + j, type, 0);
> +		fa = xfs_dquot_verify(mp, ddq, id + j, type);
>  		if (fa)
>  			xfs_dquot_repair(mp, ddq, id + j, type);
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
