Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfDKNJ7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Apr 2019 09:09:59 -0400
Date: Thu, 11 Apr 2019 09:09:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/8] xfs: report AG health via AG geometry ioctl
Message-ID: <20190411130957.GG2888@bfoster>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
 <155494717070.1090518.15401214807663806671.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155494717070.1090518.15401214807663806671.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 10, 2019 at 06:46:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the AG geometry info ioctl to report health status too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h     |   14 +++++++++++++-
>  fs/xfs/libxfs/xfs_health.h |    2 ++
>  fs/xfs/xfs_health.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c         |    2 ++
>  4 files changed, 60 insertions(+), 1 deletion(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index eb8dbc3a952a..0315b95a8d84 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -321,3 +321,46 @@ xfs_fsop_geom_health(
...
> +/* Fill out ag geometry health info. */
> +void
> +xfs_ag_geom_health(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_ag_geometry	*ageo)
> +{
> +	struct xfs_perag	*pag;
> +	const struct ioctl_sick_map *m;
> +	unsigned int		sick;
> +	unsigned int		checked;
> +
> +	ASSERT(agno < mp->m_sb.sb_agcount);
> +
> +	ageo->ag_sick = 0;
> +	ageo->ag_checked = 0;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	xfs_ag_measure_sickness(pag, &sick, &checked);
> +	for (m = ag_map; m->sick_mask; m++) {
> +		if (checked & m->sick_mask)
> +			ageo->ag_checked |= m->ioctl_mask;
> +		if (sick & m->sick_mask)
> +			ageo->ag_sick |= m->ioctl_mask;
> +	}

FWIW this is pretty much what I was asking for in the mapping helper in
the previous patch. I didn't realize this was going to be reused for
another ioctl/struct, however, so disregard my previous comment about
renaming ->ioctl_mask. ;)

> +
> +	xfs_perag_put(pag);
> +}
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3e3ee197bd0f..c47f4201452c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -822,6 +822,8 @@ xfs_ioc_ag_geometry(
>  	if (error)
>  		return error;
>  
> +	xfs_ag_geom_health(mp, ageo.ag_number, &ageo);
> +

Any reason not to push this down into the get_geom() helper since it's
part of the initial version of the ag geometry structure and we already
have the xfs_perag there?

Brian

>  	if (copy_to_user(arg, &ageo, sizeof(ageo)))
>  		return -EFAULT;
>  	return 0;
> 
