Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43066 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdAYAWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 19:22:04 -0500
Date: Tue, 24 Jan 2017 16:21:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7 1/5] xfs_db: sanitize agcount on load
Message-ID: <20170125002157.GH9134@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
 <20170123213108.GD31202@birch.djwong.org>
 <6ad3798a-c3f5-fd8f-ab05-62c0f878290c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ad3798a-c3f5-fd8f-ab05-62c0f878290c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 04:52:59PM -0600, Eric Sandeen wrote:
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
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a08575a..ca5101e 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -817,6 +817,28 @@ libxfs_mount(
>  			return NULL;
>  	}
>  
> +	/*
> +	 * libxfs_initialize_perag will allocate a perag structure for each AG.
> +	 * If agcount is corrupted and insanely high, this will OOM the box.
> +	 * If the agount seems (arbitrarily) high, try to read what would be
> +	 * the last AG, and if that fails, just read the first one and let
> +	 * the user know what happened.
> +	 */
> +	if (sbp->sb_agcount > 10000) {

10,000 isn't all that high -- that's only 960K worth of perag structs.
Also,

<create 200gb /dev/mapper/moo>

# mkfs.xfs -f -b size=4096 -d agsize=4096b /dev/mapper/moo
meta-data=/dev/mapper/moo        isize=512    agcount=12800, agsize=4096 blks

Ok, admittedly I'm trolling here.  Maybe a better limit would be
1,000,000 AGs?  That's at least 2TB with the minimum AG size, and 100MB
of RAM.

(Really I'd say 10 million but I've been brainwashed by the people
fscking 16TB filesystems on embedded arm boxen with 256M of RAM...)

> +		error = xfs_read_agf(mp, NULL, sbp->sb_agcount - 1, 0, &bp);
> +		if (error) {

__read_buf sends back -EIO for any zero-byte pread, including reads past
the end of the device, which makes a media error looks the same as a
too-small device.  Also, if the AGF is present but garbage then we'll
get -EFSCORRUPTED here, right?

I think I like the idea of computing the AGF location and comparing to
the device size to guess that our geometry is crazy.

--D

> +			fprintf(stderr, _("%s: read of AG %d failed\n"),
> +						progname, sbp->sb_agcount);
> +			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
> +				return NULL;
> +			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
> +								progname);
> +			sbp->sb_agcount = 1;
> +		}
> +		if (bp)
> +			libxfs_putbuf(bp);
> +	}
> +
>  	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
>  	if (error) {
>  		fprintf(stderr, _("%s: perag init failed\n"),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
