Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F2bjs6054150 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 21:37:45 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UWha9qrNmectP8kC for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 19:37:43 -0700 (PDT)
Date: Wed, 15 Aug 2012 12:37:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v6 PATCH 5/5] xfs: Add a new field to fs_quota_stat to get
	pquota information
Message-ID: <20120815023742.GU2877@dastard>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230305.20477.41556.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120720230305.20477.41556.sendpatchset@chandra-lucid.austin.ibm.com>
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

On Fri, Jul 20, 2012 at 06:03:05PM -0500, Chandra Seetharaman wrote:
> Use separate structure for filling the project quota information
> for the Q_XGETQSTAT quota command.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index f011cf3..482efc0 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -421,7 +421,6 @@ xfs_qm_scall_getqstat(
>  	tempuqip = tempgqip = temppqip = B_FALSE;
>  	memset(out, 0, sizeof(fs_quota_stat_t));
>  
> -	out->qs_version = FS_QSTAT_VERSION;
>  	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
>  		out->qs_uquota.qfs_ino = NULLFSINO;
>  		out->qs_gquota.qfs_ino = NULLFSINO;
> @@ -434,8 +433,6 @@ xfs_qm_scall_getqstat(
>  	out->qs_pad = 0;
>  	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
>  	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
> -	if (&out->qs_gquota != &out->qs_pquota)
> -		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
>  
>  	if (q) {
>  		uip = q->qi_uquotaip;
> @@ -452,11 +449,6 @@ xfs_qm_scall_getqstat(
>  					0, 0, &gip) == 0)
>  			tempgqip = B_TRUE;
>  	}
> -	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
> -		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
> -					0, 0, &pip) == 0)
> -			temppqip = B_TRUE;
> -	}
>  	if (uip) {
>  		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
>  		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
> @@ -469,11 +461,19 @@ xfs_qm_scall_getqstat(
>  		if (tempgqip)
>  			IRELE(gip);
>  	}
> -	if (pip) {
> -		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
> -		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
> -		if (temppqip)
> -			IRELE(pip);
> +	if (out->qs_version >= FS_QSTAT_VERSION_2) {
> +		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
> +		if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
> +			if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
> +						0, 0, &pip) == 0)
> +				temppqip = B_TRUE;
> +		}
> +		if (pip) {
> +			out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
> +			out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
> +			if (temppqip)
> +				IRELE(pip);
> +		}

Doesn't this mean that we'll never report project quota for
FS_QSTAT_VERSION structures and the old quota format? i.e. existing
tools with a new kernel won't return the project quota info in the
group quota fields?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
