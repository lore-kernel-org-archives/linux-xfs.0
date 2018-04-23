Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54905 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932076AbeDWR0c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:26:32 -0400
Date: Mon, 23 Apr 2018 19:27:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/13] xfs: refactor incore dquot initialization
        functions
Message-ID: <20180423172755.GG834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440959784.29601.7345409188558922914.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440959784.29601.7345409188558922914.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:06:37AM -0700, Darrick J. Wong wrote:
> -/*
> - * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
> - * and release the buffer immediately.
> - *
> - * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
> - */
> -int
> -xfs_qm_dqread(
> +/* Allocate and initialize everything we need for an incore dquot. */
> +STATIC struct xfs_dquot *
> +xfs_qm_dqinit_once(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> -	uint			flags,
> -	struct xfs_dquot	**O_dqpp)
> +	uint			type)
>  {
>  	struct xfs_dquot	*dqp;
> -	struct xfs_disk_dquot	*ddqp;
> -	struct xfs_buf		*bp;
> -	struct xfs_trans	*tp = NULL;
> -	int			error;
>  
>  	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);

Shouldn't this be called something like xfs_dquot_alloc given that
it allocates the xfs_dquot structure?

> +/* Copy the in-core quota fields in from the on-disk buffer. */
> +STATIC void
> +xfs_qm_dqinit_from_buf(
> +	struct xfs_dquot	*dqp,
> +	struct xfs_disk_dquot	*ddqp)
> +{

xfs_dquot_from_disk?

Also didn't we stop using STATIC for new code a while ago?

> +	/* copy everything from disk dquot to the incore dquot */
> +	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));

	memcpy(&dqp->q_core, ddqp, sizeof(dqp->q_core));

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
