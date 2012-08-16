Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GKOjCv185369 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 15:24:45 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WRAXxex7HCjpp6cK for
	<xfs@oss.sgi.com>; Thu, 16 Aug 2012 13:24:43 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7GKOhAn009023
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 16:24:43 -0400
Message-ID: <502D56B9.9080606@redhat.com>
Date: Thu, 16 Aug 2012 16:23:21 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Make inode64 a remountable option
References: <1345142110-6412-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1345142110-6412-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 08/16/2012 02:35 PM, Carlos Maiolino wrote:
> Actually, there is no reason about why a user must umount and mount a XFS
> filesystem to enable 'inode64' option. So, this patch makes this a remountable
> option.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

I just gave it a whirl. It works and the code looks sane to me, so:

Reviewed-by: Brian Foster <bfoster@redhat.com>

I do have a question though... do we care about the remount from inode64
to non-inode64 case?

Brian

> ---
>  fs/xfs/xfs_super.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bdaf4cb..4dad567 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -120,12 +120,13 @@ mempool_t *xfs_ioend_pool;
>   * in the future, too.
>   */
>  enum {
> -	Opt_barrier, Opt_nobarrier, Opt_err
> +	Opt_barrier, Opt_nobarrier, Opt_inode64, Opt_err
>  };
>  
>  static const match_table_t tokens = {
>  	{Opt_barrier, "barrier"},
>  	{Opt_nobarrier, "nobarrier"},
> +	{Opt_inode64, "inode64"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -1038,11 +1039,15 @@ xfs_fs_remount(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
>  	substring_t		args[MAX_OPT_ARGS];
> +	xfs_sb_t		*sbp = &(mp->m_sb);
> +	xfs_perag_t		*pag;
>  	char			*p;
>  	int			error;
>  
>  	while ((p = strsep(&options, ",")) != NULL) {
>  		int token;
> +		int agcount = sbp->sb_agcount;
> +		int index = 0;
>  
>  		if (!*p)
>  			continue;
> @@ -1055,6 +1060,17 @@ xfs_fs_remount(
>  		case Opt_nobarrier:
>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
>  			break;
> +		case Opt_inode64:
> +
> +			for (index = 0; index < agcount; index++) {
> +				pag = xfs_perag_get(mp, index);
> +				pag->pagi_inodeok = 1;
> +				xfs_perag_put(pag);
> +			}
> +			mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> +			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +			mp->m_maxagi = index;
> +			break;
>  		default:
>  			/*
>  			 * Logically we would return an error here to prevent
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
