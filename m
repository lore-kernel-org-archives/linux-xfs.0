Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47302 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751957AbdAJUwC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 15:52:02 -0500
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
References: <20170110194249.GK14038@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <73a62730-59a9-cad4-ca33-f054e544459b@sandeen.net>
Date: Tue, 10 Jan 2017 14:52:00 -0600
MIME-Version: 1.0
In-Reply-To: <20170110194249.GK14038@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>


On 1/10/17 1:42 PM, Darrick J. Wong wrote:
> xfs_db doesn't check the filesystem geometry when it's mounting, which
> means that garbage agcount values can cause OOMs when we try to allocate
> all the per-AG incore metadata.  If we see geometry that looks
> suspicious, try to derive the actual AG geometry to avoid crashing the
> system.  This should help with xfs/1301 fuzzing.
> 
> Also fix up xfs_repair to use the min/max dblocks macros.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/init.c   |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  repair/sb.c |    7 +----

The repair change is an unrelated no-op cleanup, yes?  Worth doing,
but in a second patch.

Ok, so now we do a whole bunch of tests and behind-your-back
fixups, but regardless of the problem we always issue the same
warning:

xfs_db: device fsfile AG geometry is insane.  Using agcount=XX

... even if agcount wasn't the problem:

xfs_db> write -c blocksize 32768
Allowing write of corrupted data and bad CRC
blocksize = 32768
xfs_db> quit
[sandeen@sandeen xfsprogs]$ db/xfs_db -x fsfile 
xfs_db: device fsfile AG geometry is insane.  Using agcount=4.

That's confusing.

The whole point of xfs_db is to debug what is /on disk/ - 
the above doesn't make it clear that it's not changed the on-disk
value.  And it doesn't make it clear what was wrong, or what got changed.

But backing up - the /problem/ here is the OOM, right?  That happens
for a very large agcount.  We shouldn't be doing any more than that;
I don't really agree that your sanitize function should be fixing up
stuff behind the user's back.  If it's broken, it's broken; let the
xfs_db wielding expert sort that out as long as xfs_db an be used to
do so.

But if the OOM means xfs_db can't start, then yeah, that's a problem.

What about sanitizing only the agcount, and saying something like:

xfs_db: device fsfile AG count is insane.  Initializing only first $X

(where $X is based on your heuristics)

-Eric

>  2 files changed, 83 insertions(+), 15 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index ec1e274..7e66d14 100644
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
> +		_("%s: device %s AG geometry is insane.  Using agcount=%u.\n"),
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
> diff --git a/repair/sb.c b/repair/sb.c
> index 1b352e8..e108613 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -398,11 +398,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
>  	/* sanity check ag count, size fields against data size field */
>  
>  	if (sb->sb_dblocks == 0 ||
> -		sb->sb_dblocks >
> -			((__uint64_t)sb->sb_agcount * sb->sb_agblocks) ||
> -		sb->sb_dblocks <
> -			((__uint64_t)(sb->sb_agcount - 1) * sb->sb_agblocks
> -			+ XFS_MIN_AG_BLOCKS))
> +		sb->sb_dblocks > XFS_MAX_DBLOCKS(sb) ||
> +		sb->sb_dblocks < XFS_MIN_DBLOCKS(sb))
>  		return(XR_BAD_FS_SIZE_DATA);
>  
>  	if (sb->sb_agblklog != (__uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
