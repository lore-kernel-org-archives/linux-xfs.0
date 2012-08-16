Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GMeXhT197853 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 17:40:34 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jXmvnrtuiSHr50fS for <xfs@oss.sgi.com>;
	Thu, 16 Aug 2012 15:40:32 -0700 (PDT)
Date: Fri, 17 Aug 2012 08:40:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Make inode64 a remountable option
Message-ID: <20120816224030.GX2877@dastard>
References: <1345142110-6412-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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

On Thu, Aug 16, 2012 at 03:35:10PM -0300, Carlos Maiolino wrote:
> Actually, there is no reason about why a user must umount and mount a XFS
> filesystem to enable 'inode64' option. So, this patch makes this a remountable
> option.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
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

No need for the xfs_sb_t declaration at all, and pag can be scoped
inside the inner loop. Also, we don't use the typedef versions
anymore...

>  	char			*p;
>  	int			error;
>  
>  	while ((p = strsep(&options, ",")) != NULL) {
>  		int token;
> +		int agcount = sbp->sb_agcount;
> +		int index = 0;

Similarly, there is no need for the agcount variable, and the first
loop indice is normally named "i".

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

This doesn't clear the pagf_metadata flag that is also set when
inode32 is active to reserve the inode AGs for metadata allocations
only. So the loop needs to look something like:

			for (i = 0; i < mp->m_sb.sb_agcount; i++) {
				struct xfs_perag *pag;

				pag = xfs_perag_get(mp, i);
				pag->pagi_inodeok = 1;
				pag->pagf_metadata = 0;
				xfs_perag_put(pag);
			}

> +			mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> +			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;

The usual way of clearing multiple flags is like so:

			mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
					 XFS_MOUNT_SMALL_INUMS);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
