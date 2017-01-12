Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38508 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdALXU2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 18:20:28 -0500
Subject: Re: [PATCH v2 4/5] xfs_db: sanitize geometry on load
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
 <20170112204142.GA14038@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1ea9b931-28c9-de1c-f7ff-874053d4ac35@sandeen.net>
Date: Thu, 12 Jan 2017 17:20:26 -0600
MIME-Version: 1.0
In-Reply-To: <20170112204142.GA14038@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On 1/12/17 2:41 PM, Darrick J. Wong wrote:
> xfs_db doesn't check the filesystem geometry when it's mounting, which
> means that garbage agcount values can cause OOMs when we try to allocate
> all the per-AG incore metadata.  If we see geometry that looks
> suspicious, try to derive the actual AG geometry to avoid crashing the
> system.  This should help with xfs/1301 fuzzing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: Only modify sb_ag{blocks,count} if they seem insane -- use local
> variables to avoid screwing up the rest of the metadata.

Ok, I like this a bit better.  More comments, though.  Sorry, will
try to do a better full review in future to avoid the iteration :(
Below ...

> ---
>  db/init.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 87 insertions(+), 10 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index ec1e274..db133d7 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -51,13 +51,96 @@ usage(void)
>  	exit(1);
>  }
>  
> +/* Try to load an AG's superblock, no verifiers. */

/* ... for the given agno ... */

> +static bool
> +load_sb(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_sb		*sbp)
> +{
> +	struct xfs_buf		*bp;
> +
> +	bp = libxfs_readbuf(mp->m_ddev_targp,
> +			    XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> +			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
> +
> +	if (!bp || bp->b_error)
> +		return false;
> +
> +	/* copy SB from buffer to in-core, converting architecture as we go */
> +	libxfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
> +	libxfs_putbuf(bp);
> +	libxfs_purgebuf(bp);
> +
> +	return true;
> +}
> +
> +/* If the geometry doesn't look sane, try to figure out the real geometry. */
> +static void
> +sanitize_geometry(
Probably now:

+/*
+ * If the agcount doesn't look sane, try to figure out the real agcount.
+ * A wildly too-large agcount may OOM in libxfs_initialize_perag
+ */
+static void
+sanitize_agcount(

> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*sbp)
> +{
> +	struct xfs_sb		sb;
> +	unsigned int		blocklog;
> +	unsigned int		blocksize;
> +	unsigned int		agblocks;
> +	unsigned long long	dblocks;
> +
> +	/* If the geometry looks ok, we're done. */
> +	if (sbp->sb_blocklog >= XFS_MIN_BLOCKSIZE_LOG &&
> +	    sbp->sb_blocklog <= XFS_MAX_BLOCKSIZE_LOG &&
> +	    sbp->sb_blocksize == (1 << sbp->sb_blocklog) &&
> +	    sbp->sb_dblocks * sbp->sb_blocksize <= x.dsize * x.dbsize &&
> +	    sbp->sb_dblocks <= XFS_MAX_DBLOCKS(sbp) &&
> +	    sbp->sb_dblocks >= XFS_MIN_DBLOCKS(sbp))
> +		return;
> +
> +	/* Check blocklog and blocksize */
> +	blocklog = sbp->sb_blocklog;
> +	blocksize = sbp->sb_blocksize;
> +	if (blocklog < XFS_MIN_BLOCKSIZE_LOG ||
> +	    blocklog > XFS_MAX_BLOCKSIZE_LOG)
> +		blocklog = libxfs_log2_roundup(blocksize);
> +	if (blocksize != (1 << blocklog))
> +		blocksize = (1 << blocksize);
> +
> +	/* Clamp dblocks to the size of the device. */
> +	dblocks = sbp->sb_dblocks;
> +	if (dblocks > x.dsize * x.dbsize / blocksize)
> +		dblocks = x.dsize * x.dbsize / blocksize;

ok now in theory blocksize & dblocks are as good a guess as we can
get...

> +
> +	/* See if agblocks helps us find a superblock. */
> +	mp->m_blkbb_log = blocklog - BBSHIFT;
> +	if (sbp->sb_agblocks > 0 && sbp->sb_agblocks <= MAXEXTNUM &&
> +	    load_sb(mp, 1, &sb) && sb.sb_magicnum == XFS_SB_MAGIC) {

load_sb translates the one we found into &sb....

> +		sbp->sb_agcount = dblocks / sbp->sb_agblocks;

wouldn't it make more sense to just assign from sb->sb_agcount?
But who's to say the 2nd one isn't corrupt in the same way?
Grump.

> +		goto out;
> +	}
> +
> +	/* See if agcount helps us find a superblock. */

Wait I thought agcount problems is why we're here in
the first place.  What's this for?

> +	agblocks = sbp->sb_agblocks;
> +	sbp->sb_agblocks = dblocks / sbp->sb_agcount;
> +	if (sbp->sb_agblocks > 0 && sbp->sb_agblocks <= MAXEXTNUM &&
> +	    load_sb(mp, 1, &sb) && sb.sb_magicnum == XFS_SB_MAGIC) {
> +		goto out;
> +	}
> +
> +	/* Both are nuts, assume 1 AG. */
> +	sbp->sb_agblocks = agblocks;
> +	sbp->sb_agcount = 1;

I'd almost rather just jump here and let the admin sort it out...

But let me play with this a little mmkay?

-Eric

> +out:
> +	fprintf(stderr,
> +		_("%s: device %s AG count is insane.  Limiting reads to the first %u AGs.\n"),
> +		progname, fsdevice, sbp->sb_agcount);
> +}
> +
>  void
>  init(
>  	int		argc,
>  	char		**argv)
>  {
>  	struct xfs_sb	*sbp;
> -	struct xfs_buf	*bp;
>  	int		c;
>  
>  	setlocale(LC_ALL, "");
> @@ -124,20 +207,12 @@ init(
>  	 */
>  	memset(&xmount, 0, sizeof(struct xfs_mount));
>  	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
> -	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
> -			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
> -
> -	if (!bp || bp->b_error) {
> +	if (!load_sb(&xmount, 0, &xmount.m_sb)) {
>  		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
>  			"bytes)\n"), progname, fsdevice);
>  		exit(1);
>  	}
>  
> -	/* copy SB from buffer to in-core, converting architecture as we go */
> -	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
> -	libxfs_putbuf(bp);
> -	libxfs_purgebuf(bp);
> -
>  	sbp = &xmount.m_sb;
>  	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
>  		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
> @@ -148,6 +223,8 @@ init(
>  		}
>  	}
>  
> +	sanitize_geometry(&xmount, sbp);
> +
>  	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
>  			  LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
