Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbdATXdw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jan 2017 18:33:52 -0500
Subject: Re: [PATCH 1/5] xfs_db: sanitize geometry on load
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <86cd1f7f-f433-997b-8bbc-94e4c72a860f@redhat.com>
Date: Fri, 20 Jan 2017 17:33:50 -0600
MIME-Version: 1.0
In-Reply-To: <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/20/17 2:25 PM, Darrick J. Wong wrote:
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
> v4: Remove the suggested agcount value and make sure we can't exit
> the program with an exitcode of zero.

ok, but insane_agcount doesn't need to be global... 

> ---
>  db/init.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 74 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/db/init.c b/db/init.c
> index ec1e274..e60ac66 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -41,6 +41,7 @@ struct xfs_mount	*mp;
>  struct xlog		xlog;
>  libxfs_init_t		x;
>  xfs_agnumber_t		cur_agno = NULLAGNUMBER;
> +static bool		insane_agcount;

Not a fan of the global.  Can you make it local, and then
do something like this:

if (sanitize_agount(&xmount, sbp))
	insane_agount = true;

>  static void
>  usage(void)
> @@ -51,13 +52,80 @@ usage(void)
>  	exit(1);
>  }
>  
> +/* Try to load a superblock for the given agno, no verifiers. */
> +static bool
> +load_sb(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_sb		*sbp)

Now this is always called with agno == 0, so is there any point
to the arg?  Eh, I guess it's fine.

I can fix up the insane_agcount thing on the way in if you like.

-Eric

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
> +	unsigned int		blocklog;
> +	unsigned int		blocksize;
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
> +
> +	/* Assume 1 AG to avoid OOM. */
> +	fprintf(stderr,
> +_("%s: device %s AG count is insane.  Limiting reads to AG 0.\n"),
> +		progname, fsdevice);
> +	sbp->sb_agcount = 1;
> +	insane_agcount = true;



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
> @@ -124,20 +192,12 @@ init(
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
> @@ -148,6 +208,8 @@ init(
>  		}
>  	}
>  
> +	sanitize_geometry(&xmount, sbp);
> +
>  	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
>  			  LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> @@ -230,5 +292,7 @@ main(
>  		libxfs_device_close(x.logdev);
>  	if (x.rtdev)
>  		libxfs_device_close(x.rtdev);
> +	if (insane_agcount && exitcode == 0)
> +		exitcode = 1;
>  	return exitcode;
>  }
> 

