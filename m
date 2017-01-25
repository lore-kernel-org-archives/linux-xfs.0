Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31665 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdAYEs2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 23:48:28 -0500
Date: Tue, 24 Jan 2017 20:48:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v8 1/5] xfs_db: sanitize agcount on load
Message-ID: <20170125044819.GI9134@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
 <20170123213108.GD31202@birch.djwong.org>
 <6ad3798a-c3f5-fd8f-ab05-62c0f878290c@sandeen.net>
 <17bbf8d4-39f7-a542-6c9d-3cd96e865ddf@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17bbf8d4-39f7-a542-6c9d-3cd96e865ddf@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 09:09:01PM -0600, Eric Sandeen wrote:
> Before we get into libxfs_initialize_perag and try to blindly
> allocate a perag struct for every (possibly corrupted number of)
> AGs, see if we can read the last one.  If not, assume it's corrupt,
> and load only the first AG.
> 
> Do this only for an arbitrarily high-ish agcount, so that normal-ish
> geometry on a possibly truncated file or device will still do
> its best to make all readable AGs available.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Huh, what happened to v1-6? :)

> v7: blow it all up
> v8: use bare libxfs_readbuf so verifiers don't matter,
>     "ours goes to 1 million!"
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a08575a..a14aa17 100644
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
> +			fprintf(stderr, _("%s: read of AG %d failed\n"),
> +						progname, sbp->sb_agcount);

AG counts are unsigned.

# xfs_db -x -c 'sb 0' -c 'fuzz -d agcount random' /dev/sdf
Allowing fuzz of corrupted data with good CRC
agcount = 3298133433
# xfs_db /dev/sdf
xfs_db: error - read only 0 of 512 bytes
xfs_db: read of AG -996833863 failed
xfs_db: limiting reads to AG 0

Assuming it passes testing, fix the two things, slap on a:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

and let's call it done.

--D

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
