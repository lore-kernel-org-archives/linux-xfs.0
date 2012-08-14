Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7EMkomU024450 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 17:46:50 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	inw7900tnhFosJ7H for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 15:46:48 -0700 (PDT)
Date: Wed, 15 Aug 2012 08:46:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v6 PATCH 1/5] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Message-ID: <20120814224645.GQ2877@dastard>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230208.20477.49663.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120720230208.20477.49663.sendpatchset@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 20, 2012 at 06:02:08PM -0500, Chandra Seetharaman wrote:
> Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA nd
> PQUOTA respectively.
> 
> No changes are made to the on-disk version of the superblock yet. On-disk
> copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> 
> Read and write of the superblock does the conversion from *OQUOTA*
> to *[PG]QUOTA*.

Couple of minor style things....

> @@ -622,6 +636,7 @@ xfs_sb_to_disk(
>  	xfs_sb_field_t	f;
>  	int		first;
>  	int		size;
> +	 __uint16_t	tmp16;

tmp16 is a bad name for a temporary variable. Move it to the scope
that uses it, and name it for it's purpose. i.e:


>  
>  	ASSERT(fields);
>  	if (!fields)
> @@ -636,6 +651,26 @@ xfs_sb_to_disk(
>  
>  		if (size == 1 || xfs_sb_info[f].type == 1) {
>  			memcpy(to_ptr + first, from_ptr + first, size);
> +		} else if (f == XFS_SBS_QFLAGS) {

			__uint16_t	qflags;

> +			/*
> +			 * The in-core version of sb_qflags do not have
> +			 * XFS_OQUOTA_* flags, whereas the on-disk version
> +			 * does.  Save the in-core sb_qflags temporarily,
> +			 * removing the new XFS_{PG}QUOTA_* flags and re-apply
> +			 * the old on-disk flags.
> +			 */
> +			tmp16 = from->sb_qflags &

			qflags = from->sb_qflags & ....

> +					~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> +
> +			if (from->sb_qflags &
> +					(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> +				tmp16 |= XFS_OQUOTA_ENFD;
> +			if (from->sb_qflags &
> +					(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> +				tmp16 |= XFS_OQUOTA_CHKD;
> +
> +			*(__be16 *)(to_ptr + first) = cpu_to_be16(tmp16);
>  		} else {
>  			switch (size) {
>  			case 2:

....

> @@ -339,9 +339,11 @@ xfs_qm_scall_quotaon(
>  	    ||
>  	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
>  	    (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
> -	    (flags & XFS_GQUOTA_ACCT) == 0 &&
> +	    (flags & XFS_PQUOTA_ENFD))
> +	    ||
> +	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
>  	    (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
> -	    (flags & XFS_OQUOTA_ENFD))) {
> +	    (flags & XFS_GQUOTA_ENFD))) {

Can you fix the flat indenting here at the same time so that the
logic is obvious at a glance and consistent with the rest of the XFS
code? i.e.

	if (((flags & XFS_UQUOTA_ACCT) == 0 &&
	     (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
	     (flags & XFS_UQUOTA_ENFD)) ||
	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
	     (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
	     (flags & XFS_PQUOTA_ENFD)) ||
	    (flags & XFS_GQUOTA_ACCT) == 0 &&
	     (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
	     (flags & XFS_GQUOTA_ENFD))) {

>  		xfs_debug(mp,
>  			"%s: Can't enforce without acct, flags=%x sbflags=%x\n",
>  			__func__, flags, mp->m_sb.sb_qflags);
> @@ -771,8 +773,10 @@ xfs_qm_scall_getquota(
>  	 * so return zeroes in that case.
>  	 */
>  	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && dqp->q_core.d_flags == XFS_DQ_USER) ||
> -	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
> -			(dqp->q_core.d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
> +	    (!XFS_IS_PQUOTA_ENFORCED(mp)
> +			&& dqp->q_core.d_flags == XFS_DQ_PROJ) ||
> +	    (!XFS_IS_GQUOTA_ENFORCED(mp)
> +			&& dqp->q_core.d_flags == XFS_DQ_GROUP)) {

Same here:

	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
	     dqp->q_core.d_flags == XFS_DQ_USER) ||
	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
	     dqp->q_core.d_flags == XFS_DQ_PROJ) ||
	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
	     dqp->q_core.d_flags == XFS_DQ_GROUP)) {

Otherwise it looks good. Fix the above and you can add a

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
