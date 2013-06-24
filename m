Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 779C67F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 00:59:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55C49304043
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 22:59:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	g5ynqKPjHgdZwasj for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 22:59:25 -0700 (PDT)
Date: Mon, 24 Jun 2013 15:59:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 2/6] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Message-ID: <20130624055921.GM29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-3-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372042107-27332-3-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Sun, Jun 23, 2013 at 09:48:23PM -0500, Chandra Seetharaman wrote:
> Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA and
> PQUOTA respectively.
> 
> On-disk copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> 
> Read and write of the superblock does the conversion from *OQUOTA*
> to *[PG]QUOTA*.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_mount.c       |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_qm.c          |    9 ++++++---
>  fs/xfs/xfs_qm_syscalls.c |   39 +++++++++++++++++++++------------------
>  fs/xfs/xfs_quota.h       |   42 ++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_quotaops.c    |    6 ++++--
>  fs/xfs/xfs_super.c       |   16 ++++++++--------
>  fs/xfs/xfs_trans_dquot.c |    4 ++--
>  7 files changed, 115 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 6a19434..e2e14cb 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -336,6 +336,14 @@ xfs_mount_validate_sb(
>  		return XFS_ERROR(EWRONGFS);
>  	}
>  
> +	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> +			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> +		xfs_notice(mp,
> +"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
> +		return XFS_ERROR(EFSCORRUPTED);
> +	}
> +
>  	/*
>  	 * Version 5 superblock feature mask validation. Reject combinations the
>  	 * kernel cannot support up front before checking anything else. For
> @@ -622,6 +630,35 @@ xfs_sb_from_disk(
>  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
>  }
>  
> +static inline void
> +xfs_handle_quota_to_disk(
> +	xfs_dsb_t	*to,
> +	xfs_sb_t	*from,
> +	__int64_t	*fields)

An "XFS handle" has meaning in the namespace (i.e. an XFS filehandle
as used in xfs_ioctl.c and defined in xfs_fs.h, so this is not a
good name.

Realistically, xfs_sb_qflags_to_disk() is more appropriate for it's
function....

> @@ -643,6 +680,7 @@ xfs_sb_to_disk(
>  	if (!fields)
>  		return;
>  
> +	xfs_handle_quota_to_disk(to, from, &fields);
>  	while (fields) {
>  		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
>  		first = xfs_sb_info[f].offset;
> @@ -835,6 +873,14 @@ reread:
>  	 */
>  	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
>  
> +	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
> +		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> +	if (sbp->sb_qflags & XFS_OQUOTA_CHKD)
> +		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> +	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);

and that as xfs_sb_qflags_from_disk()....

> +
>  	/*
>  	 * We must be able to do sector-sized and sector-aligned IO.
>  	 */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index f5f9925..de7ecbd 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -299,8 +299,10 @@ xfs_qm_mount_quotas(
>  	 */
>  	if (!XFS_IS_UQUOTA_ON(mp))
>  		mp->m_qflags &= ~XFS_UQUOTA_CHKD;
> -	if (!(XFS_IS_GQUOTA_ON(mp) || XFS_IS_PQUOTA_ON(mp)))
> -		mp->m_qflags &= ~XFS_OQUOTA_CHKD;
> +	if (!XFS_IS_GQUOTA_ON(mp))
> +		mp->m_qflags &= ~XFS_GQUOTA_CHKD;
> +	if (!XFS_IS_PQUOTA_ON(mp))
> +		mp->m_qflags &= ~XFS_PQUOTA_CHKD;

Order is user, group, project in the processing....

> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index b03b2ab..5e51227 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -117,11 +117,11 @@ xfs_qm_scall_quotaoff(
>  	}
>  	if (flags & XFS_GQUOTA_ACCT) {
>  		dqtype |= XFS_QMOPT_GQUOTA;
> -		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
> +		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
>  		inactivate_flags |= XFS_GQUOTA_ACTIVE;
>  	} else if (flags & XFS_PQUOTA_ACCT) {
>  		dqtype |= XFS_QMOPT_PQUOTA;
> -		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
> +		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
>  		inactivate_flags |= XFS_PQUOTA_ACTIVE;
>  	}

Again, u/g/p order...

>  
> @@ -335,14 +335,14 @@ xfs_qm_scall_quotaon(
>  	 * quota acct on ondisk without m_qflags' knowing.
>  	 */
>  	if (((flags & XFS_UQUOTA_ACCT) == 0 &&
> -	    (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
> -	    (flags & XFS_UQUOTA_ENFD))
> -	    ||
> +	     (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
> +	     (flags & XFS_UQUOTA_ENFD)) ||
>  	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
> -	    (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
> -	    (flags & XFS_GQUOTA_ACCT) == 0 &&
> -	    (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
> -	    (flags & XFS_OQUOTA_ENFD))) {
> +	     (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
> +	     (flags & XFS_PQUOTA_ENFD)) ||
> +	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
> +	     (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
> +	     (flags & XFS_GQUOTA_ENFD))) {
>  		xfs_debug(mp,
>  			"%s: Can't enforce without acct, flags=%x sbflags=%x\n",
>  			__func__, flags, mp->m_sb.sb_qflags);

And now u/p/g order. That's a little confusing - let's try to keep
the ordering the same throughout the code...

> @@ -776,9 +776,12 @@ xfs_qm_scall_getquota(
>  	 * gets turned off. No need to confuse the user level code,
>  	 * so return zeroes in that case.
>  	 */
> -	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && dqp->q_core.d_flags == XFS_DQ_USER) ||
> -	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
> -			(dqp->q_core.d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
> +	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
> +	     dqp->q_core.d_flags == XFS_DQ_USER) ||
> +	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
> +	     dqp->q_core.d_flags == XFS_DQ_PROJ) ||
> +	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
> +	     dqp->q_core.d_flags == XFS_DQ_GROUP)) {
>  		dst->d_btimer = 0;
>  		dst->d_itimer = 0;
>  		dst->d_rtbtimer = 0;

Same here - it's u/p/g order rather than u/g/p. Can you fix up all
the other cases so they are all in the same u/g/p order?

> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index c38068f..0596860 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -161,28 +161,43 @@ typedef struct xfs_qoff_logformat {
>  #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
>  
>  /*
> + * Start differentiating group quota and project quota using
> + * distinct flags, instead of using the combined OQUOTA flags.
> + *
> + * Conversion to and from the combined OQUOTA flag (if necessary)
> + * is done only in xfs_readsb() and xfs_sb_to_disk()

Try to describe the meaning of the flags, not the process you are
using to change the code. Hence I think, only the second paragraph
is needed here.  Also, based on my comments above, conversion is
done in xfs_sb_qflags_to_disk() and xfs_sb_qflags_from_disk()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
