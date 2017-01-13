Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbdAMNfo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 08:35:44 -0500
Date: Fri, 13 Jan 2017 08:35:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 4/5] xfs_db: sanitize geometry on load
Message-ID: <20170113133542.GB22013@bfoster.bfoster>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
 <20170113003201.GC14038@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113003201.GC14038@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 12, 2017 at 04:32:01PM -0800, Darrick J. Wong wrote:
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
> v3: Suggest a possible agcount value, but always restrict to 1 AG.
> ---
>  db/init.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 85 insertions(+), 10 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index ec1e274..43a9409 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -51,13 +51,94 @@ usage(void)
>  	exit(1);
>  }
>  
> +/* Try to load a superblock for the given agno, no verifiers. */
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
> +/*
> + * If the agcount doesn't look sane, suggest a real agcount to the user,
> + * and pretend agcount = 1 to avoid OOMing libxfs_initialize_perag.
> + */
> +static void
> +sanitize_geometry(
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

Same questions as before with regard to the above hunk.

> +	/* Clamp dblocks to the size of the device. */
> +	dblocks = sbp->sb_dblocks;
> +	if (dblocks > x.dsize * x.dbsize / blocksize)
> +		dblocks = x.dsize * x.dbsize / blocksize;
> +
> +	/*
> +	 * See if agblocks helps us find a superblock.
> +	 * blkbb_log is later (re)set by libxfs_mount.
> +	 */
> +	mp->m_blkbb_log = blocklog - BBSHIFT;
> +	if (sbp->sb_agblocks > 0 && sbp->sb_agblocks <= MAXEXTNUM &&
> +	    load_sb(mp, 1, &sb) && sb.sb_magicnum == XFS_SB_MAGIC) {

If agblocks is bogus, this can effectively point anywhere in the fs,
correct? If so, I wonder how robust this magic number check is... for
example, what prevents us from pointing at a file data block with a
valid XFS superblock? IOW, perhaps we'd also need to validate sb_uuid.

> +		fprintf(stderr,
> +_("%s: device %s AG count is insane, but could be %u.  Limiting reads to AG 0.\n"),
> +			progname, fsdevice, dblocks / sbp->sb_agblocks);
> +	} else {
> +		fprintf(stderr,
> +_("%s: device %s AG count is insane.  Limiting reads to AG 0.\n"),
> +			progname, fsdevice);
> +	}

For reasons like the above, I think xfs_db shouldn't be in the business
of repair like validation (xfs_check notwithstanding). That said,
dropping into a fixed single AG mode seems less risky than trying to
surmise a valid geometry. I'd get rid of the "this might be your
agcount" messaging entirely though and just replace it with something
that explicitly states the filesystem is corrupted, the runtime geometry
is invalid and that the user should probably run xfs_repair before doing
anything.

I still like the idea of the single AG mode thing as a command line flag
rather than default behavior because it requires user acknowledgement,
but this is a debug tool after all, so I'll defer to Eric on that. I do
think that if we create this kind of invalid runtime mode, this should
be split into two patches. First, a bugfix patch for the core OOM
problem (i.e., detect a wacky superblock and exit). Second, replace the
exit with the single AG runtime mode thing.

Brian

> +
> +	/* Assume 1 AG to avoid OOM. */
> +	sbp->sb_agcount = 1;
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
> @@ -124,20 +205,12 @@ init(
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
> @@ -148,6 +221,8 @@ init(
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
