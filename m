Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79C617F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:15:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54AF48F80D7
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:15:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	k6NEXzSn7SEYn00f for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:15:10 -0700 (PDT)
Date: Fri, 17 May 2013 15:14:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 5/5] xfs: Use new qs_pquota field in fs_quota_stat for
	Q_XGETQSTAT
Message-ID: <20130517051441.GQ24635@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-6-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368220889-25188-6-git-send-email-sekharan@us.ibm.com>
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

On Fri, May 10, 2013 at 04:21:29PM -0500, Chandra Seetharaman wrote:
> For the Q_XGETQSTAT quota command, if the new version of fs_quota_stat
> data structure is used, fill the project quota information.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c |   39 +++++++++++++++++++++++++--------------
>  1 files changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index c27b0e4..7c5876b 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -420,20 +420,14 @@ xfs_qm_scall_getqstat(
>  	bool                    tempgqip = false;
>  	bool                    temppqip = false;
>  
> -	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
> -		out->qs_uquota.qfs_ino = NULLFSINO;
> -		out->qs_gquota.qfs_ino = NULLFSINO;
> -		out->qs_pquota.qfs_ino = NULLFSINO;
> +	out->qs_uquota.qfs_ino = NULLFSINO;
> +	out->qs_gquota.qfs_ino = NULLFSINO;
> +	out->qs_pquota.qfs_ino = NULLFSINO;
> +
> +	if (!xfs_sb_version_hasquota(&mp->m_sb))
>  		return (0);
> -	}
>  	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
> -							(XFS_ALL_QUOTA_ACCT|
> -							 XFS_ALL_QUOTA_ENFD));
> -	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
> -	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
> -	if (&out->qs_gquota != &out->qs_pquota)
> -		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
> -
> +				(XFS_ALL_QUOTA_ACCT| XFS_ALL_QUOTA_ENFD));
>  	if (q) {
>  		uip = q->qi_uquotaip;
>  		gip = q->qi_gquotaip;
> @@ -454,21 +448,38 @@ xfs_qm_scall_getqstat(
>  					0, 0, &pip) == 0)
>  			temppqip = true;
>  	}
> +
>  	if (uip) {
> +		out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
>  		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
>  		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
>  		if (tempuqip)
>  			IRELE(uip);
>  	}
>  	if (gip) {
> +		out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
>  		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
>  		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
>  		if (tempgqip)
>  			IRELE(gip);
>  	}
>  	if (pip) {
> -		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
> -		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
> +		if (out->qs_version >= FS_QSTAT_VERSION_2) {
> +			out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
> +			out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
> +			out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
> +		} else {
> +			/*
> +			 * In FS_QSTAT_VERSION version, there is no
> +			 * qs_pquota, and there is no combined support
> +			 * for gquota/pquota. qs_gquota is shared for
> +			 * providing the pquota/gquota information to
> +			 * the user space.
> +			 */

Move that comment to the head of the function. i.e.:

/*
 * We support two different versions of the fs_quota_stat structure
 * here. If the version is FS_QSTAT_VERSION, then there is no
 * separate project quota fields, and so we write project quota
 * information into the group quota fields. With FS_QSTAT_VERSION_2,
 * there is a separate project quota field so we can use that
 * instead to pass both group and project quota back to user space
 * in the one call.
 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
