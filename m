Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47198 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750720AbdALOew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:34:52 -0500
Subject: Re: [PATCH 4/5] xfs_db: sanitize geometry on load
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <81d0d5a9-6a8c-376a-133e-68dc589ec08c@sandeen.net>
Date: Thu, 12 Jan 2017 08:34:50 -0600
MIME-Version: 1.0
In-Reply-To: <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/11/17 9:06 PM, Darrick J. Wong wrote:
> xfs_db doesn't check the filesystem geometry when it's mounting, which
> means that garbage agcount values can cause OOMs when we try to allocate
> all the per-AG incore metadata.  If we see geometry that looks
> suspicious, try to derive the actual AG geometry to avoid crashing the
> system.  This should help with xfs/1301 fuzzing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/init.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 81 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/db/init.c b/db/init.c
> index ec1e274..a394728 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -51,13 +51,90 @@ usage(void)
>  	exit(1);
>  }
>  
> +/* Try to load an AG's superblock, no verifiers. */
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
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*sbp)
> +{
> +	struct xfs_sb		sb;
> +	xfs_agblock_t		agblocks;
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
> +	if (sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG ||
> +	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG)
> +		sbp->sb_blocklog = libxfs_log2_roundup(sbp->sb_blocksize);
> +	if (sbp->sb_blocksize != (1 << sbp->sb_blocklog))
> +		sbp->sb_blocksize = (1 << sbp->sb_blocksize);

I'm really uneasy with having xfs_db ignore on-disk values and go
forward after deciding that it "knows better" and modifying what it
read from disk for fundamental geometry values.

For agcount, I get it - if we can't even /load/ the FS because we OOM,
then this debugging tool is of no use.  Partial initialization with a lower
agcount, if clearly stated to the user, seems reasonable.

But modifying the primary geometry in other ways, such as changing the
blocksize or blocklog or dblocks ... I'm just not comfortable with doing
that here in service to avoiding that OOM, which is related /only/ to
agcount.

Many other db functions use these values; modifying the behavior of
a low-level debugger by silently "knowing better" than what's on disk
based on educated guesses does not sit well with me.

I suppose other alternatives might be things like:

Add an option to read a backup super, instead of the primary
Add an option to limit the agcount regardless of what's on disk

I guess both of those have the downside of only knowing this should
be done /after/ you've OOMed the box on the first try...

I suppose the other option is to make an educated guess about insane
agcount, but without modifying any other superblock buffer values.

And hell at that point maybe just default to 1 ag, to give the admin
a chance to fix it, and restart xfs_db.  "Insane AG count.  Limiting
to 1 AG, please fix and restart xfs_db."

Last thought - how does this "fix it up" heuristic affect xfs_check?

-Eric

> +
> +	/* Clamp dblocks to the size of the device. */
> +	if (sbp->sb_dblocks > x.dsize * x.dbsize / sbp->sb_blocksize)
> +		sbp->sb_dblocks = x.dsize * x.dbsize / sbp->sb_blocksize;
> +
> +	/* See if agblocks helps us find a superblock. */
> +	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
> +	if (load_sb(mp, 1, &sb) && sb.sb_magicnum == XFS_SB_MAGIC) {
> +		sbp->sb_agcount = sbp->sb_dblocks / sbp->sb_agblocks;
> +		goto out;
> +	}
> +
> +	/* See if agcount helps us find a superblock. */
> +	agblocks = sbp->sb_agblocks;
> +	sbp->sb_agblocks = sbp->sb_dblocks / sbp->sb_agcount;
> +	if (sbp->sb_agblocks != 0 &&
> +	    load_sb(mp, 1, &sb) &&
> +	    sb.sb_magicnum == XFS_SB_MAGIC) {
> +		goto out;
> +	}



> +
> +	/* Both are nuts, assume 1 AG. */
> +	sbp->sb_agblocks = agblocks;
> +	sbp->sb_agcount = 1;
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
> @@ -124,20 +201,12 @@ init(
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
> @@ -148,6 +217,8 @@ init(
>  		}
>  	}
>  
> +	sanitize_geometry(&xmount, sbp);
> +
>  	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
>  			  LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
