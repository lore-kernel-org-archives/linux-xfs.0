Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfDCOaJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:30:09 -0400
Date: Wed, 3 Apr 2019 10:30:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/10] xfs: report AG health via AG geometry ioctl
Message-ID: <20190403143002.GA25805@bfoster>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413865266.4966.1015973371094452528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155413865266.4966.1015973371094452528.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 01, 2019 at 10:10:52AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the AG geometry info ioctl to report health status too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h     |   12 +++++++++++-
>  fs/xfs/libxfs/xfs_health.h |    2 ++
>  fs/xfs/xfs_health.c        |   40 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c         |    2 ++
>  4 files changed, 55 insertions(+), 1 deletion(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 151c98693bef..5ca471bd41ad 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -276,3 +276,43 @@ xfs_fsop_geom_health(
>  	if (sick & XFS_HEALTH_RT_SUMMARY)
>  		geo->health |= XFS_FSOP_GEOM_HEALTH_RT_SUMMARY;
>  }
> +
> +/* Fill out ag geometry health info. */
> +void
> +xfs_ag_geom_health(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_ag_geometry	*ageo)
> +{
> +	struct xfs_perag	*pag;
> +	unsigned int		sick;
> +
> +	if (agno >= mp->m_sb.sb_agcount)
> +		return;

The call to xfs_ag_get_geometry() would have already returned an error
in the ioctl path for the above scenario. It might still make sense to
check here, but perhaps we could let this function also return an int
and return an error for consistency?

> +
> +	ageo->ag_health = 0;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	sick = xfs_ag_measure_sickness(pag);
> +	if (sick & XFS_HEALTH_AG_SB)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_SB;

I'm starting to wonder whether "health" is the best term to use for the
interface bits just because it reads a little weird to measure
"sickness" and then apply all the sick state to something called
"health." I don't have a better suggestion off the top of my head,
though. Just something to think about a bit more from an API
standpoint..

Brian

> +	if (sick & XFS_HEALTH_AG_AGF)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGF;
> +	if (sick & XFS_HEALTH_AG_AGFL)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGFL;
> +	if (sick & XFS_HEALTH_AG_AGI)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGI;
> +	if (sick & XFS_HEALTH_AG_BNOBT)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_BNOBT;
> +	if (sick & XFS_HEALTH_AG_CNTBT)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_CNTBT;
> +	if (sick & XFS_HEALTH_AG_INOBT)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_INOBT;
> +	if (sick & XFS_HEALTH_AG_FINOBT)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_FINOBT;
> +	if (sick & XFS_HEALTH_AG_RMAPBT)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_RMAPBT;
> +	if (sick & XFS_HEALTH_AG_REFCNTBT)
> +		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_REFCNTBT;
> +	xfs_perag_put(pag);
> +}
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f9bf11b6a055..f1fc5e53cfc1 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -853,6 +853,8 @@ xfs_ioc_ag_geometry(
>  	if (error)
>  		return error;
>  
> +	xfs_ag_geom_health(mp, ageo.ag_number, &ageo);
> +
>  	if (copy_to_user(arg, &ageo, sizeof(ageo)))
>  		return -EFAULT;
>  	return 0;
> 
