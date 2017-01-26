Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27670 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdAZB1k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 20:27:40 -0500
Date: Wed, 25 Jan 2017 17:27:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v10 1/5] xfs_db: sanitize agcount on load
Message-ID: <20170126012732.GQ9134@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
 <20170123213108.GD31202@birch.djwong.org>
 <6ad3798a-c3f5-fd8f-ab05-62c0f878290c@sandeen.net>
 <17bbf8d4-39f7-a542-6c9d-3cd96e865ddf@sandeen.net>
 <886473a5-c0ff-a5b7-38bc-13d4d5d13c3c@sandeen.net>
 <e8855324-a91e-60c0-26c2-40b437b78696@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8855324-a91e-60c0-26c2-40b437b78696@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jan 25, 2017 at 07:17:56PM -0600, Eric Sandeen wrote:
> Before we get into libxfs_initialize_perag and try to blindly
> allocate a perag struct for every (possibly corrupted number of)
> AGs, see if we can read the last one.  If not, assume it's corrupt,
> and load only the first AG.
> 
> Do this only for an arbitrarily high-ish agcount, so that normal-ish
> geometry on a possibly truncated file or device will still do
> its best to make all readable AGs available.
> 
> Set xfs_db's exitcode to 1 if this happens.
> 
> Also teach metadump to detect this and exit appropriately if
> truncated, as it resets exitcode to 0 for its own purposes internally.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> v1->v6: Tale of woe.
> v7: blow it all up
> v8: use bare libxfs_readbuf so verifiers don't matter,
>     "ours goes to 1 million!"
> v9: Fix printf format, exit metadump with error if things look wonky.
> v10: set exitcode to 1 in init().
> 
> diff --git a/db/init.c b/db/init.c
> index ec1e274..59fc3e0 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -58,6 +58,7 @@ init(
>  {
>  	struct xfs_sb	*sbp;
>  	struct xfs_buf	*bp;
> +	unsigned int	agcount;
>  	int		c;
>  
>  	setlocale(LC_ALL, "");
> @@ -148,6 +149,7 @@ init(
>  		}
>  	}
>  
> +	agcount = sbp->sb_agcount;
>  	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
>  			  LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> @@ -159,6 +161,10 @@ init(
>  	mp->m_log = &xlog;
>  	blkbb = 1 << mp->m_blkbb_log;
>  
> +	/* Did we limit a broken agcount in libxfs_mount? */
> +	if (sbp->sb_agcount != agcount)
> +		exitcode = 1;
> +
>  	/*
>  	 * xfs_check needs corrected incore superblock values
>  	 */
> diff --git a/db/metadump.c b/db/metadump.c
> index 1ba6b38..38519f1 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2760,6 +2760,16 @@ metadump_f(
>  		return 0;
>  	}
>  
> +	/*
> +	 * on load, we sanity-checked agcount and possibly set to 1
> +	 * if it was corrupted and large.
> +	 */
> +	if (mp->m_sb.sb_agcount == 1 &&
> +	    XFS_MAX_DBLOCKS(&mp->m_sb) < mp->m_sb.sb_dblocks) {
> +		print_warning("truncated agcount, giving up");
> +		return 0;
> +	}
> +
>  	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
>  		switch (c) {
>  			case 'a':
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a08575a..85e0d15 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -817,6 +817,29 @@ libxfs_mount(
>  			return NULL;
>  	}
>  
> +	/*
> +	 * libxfs_initialize_perag will allocate a perag structure for each ag.
> +	 * If agcount is corrupted and insanely high, this will OOM the box.
> +	 * If the agount seems (arbitrarily) high, try to read what would be
> +	 * the last AG, and if that fails for a relatively high agcount, just
> +	 * read the first one and let the user know to check the geometry.
> +	 */
> +	if (sbp->sb_agcount > 1000000) {
> +		bp = libxfs_readbuf(mp->m_dev,
> +				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
> +				!(flags & LIBXFS_MOUNT_DEBUGGER), NULL);
> +		if (bp->b_error) {
> +			fprintf(stderr, _("%s: read of AG %u failed\n"),
> +						progname, sbp->sb_agcount);
> +			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
> +				return NULL;
> +			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
> +								progname);
> +			sbp->sb_agcount = 1;
> +		}
> +		libxfs_putbuf(bp);
> +	}
> +
>  	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
>  	if (error) {
>  		fprintf(stderr, _("%s: perag init failed\n"),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
