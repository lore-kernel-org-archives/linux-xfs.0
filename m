Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48700 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750856AbdAXWiD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 17:38:03 -0500
Subject: Re: [PATCH v6 1/5] xfs_db: sanitize geometry on load
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
 <20170123213108.GD31202@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f7c3219b-4e4b-4a8e-3f2f-79387376d0f6@sandeen.net>
Date: Tue, 24 Jan 2017 16:38:01 -0600
MIME-Version: 1.0
In-Reply-To: <20170123213108.GD31202@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/23/17 3:31 PM, Darrick J. Wong wrote:
> xfs_db doesn't check the filesystem geometry when it's mounting, which
> means that garbage agcount values can cause OOMs when we try to allocate
> all the per-AG incore metadata.  If we see geometry that looks
> suspicious, limit agcount to 1 so that we avoid OOM.  This should help
> with xfs/1301 fuzzing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: Only modify sb_ag{blocks,count} if they seem insane -- use local
> variables to avoid screwing up the rest of the metadata.
> v3: Suggest a possible agcount value, but always restrict to 1 AG.
> v4: Remove the suggested agcount value and make sure we can't exit
> the program with an exitcode of zero.
> v5: remove global variables and unnecessary parameters
> v6: remove dead code, fix comments
> ---
>  db/init.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 59 insertions(+), 12 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index ec1e274..6ebe6b7 100644
> --- a/db/init.c
> +++ b/db/init.c

...

> +/*
> + * If the agcount doesn't look sane, pretend agcount = 1 to avoid
> + * OOMing libxfs_initialize_perag.  Returns true if the geometry looked
> + * sane.
> + */
> +static bool
> +sanitize_agcount(
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*sbp)
> +{
> +	/* If the geometry looks ok, we're done. */
> +	if (sbp->sb_blocklog >= XFS_MIN_BLOCKSIZE_LOG &&
> +	    sbp->sb_blocklog <= XFS_MAX_BLOCKSIZE_LOG &&
> +	    sbp->sb_blocksize == (1 << sbp->sb_blocklog) &&
> +	    sbp->sb_dblocks * sbp->sb_blocksize <= x.dsize * x.dbsize &&
> +	    sbp->sb_dblocks <= XFS_MAX_DBLOCKS(sbp) &&
> +	    sbp->sb_dblocks >= XFS_MIN_DBLOCKS(sbp))
> +		return true;
> +
> +	/* Assume 1 AG to avoid OOM. */
> +	fprintf(stderr,
> +_("%s: device %s AG count is insane.  Limiting reads to AG 0.\n"),
> +		progname, fsdevice);
> +	sbp->sb_agcount = 1;
> +
> +	return false;

So now this claims insane AGs for a bad blocklog, etc.  :(

Let me send a patch which I think will work better.

-Eric
