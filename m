Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750823AbdALPJt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 10:09:49 -0500
Date: Thu, 12 Jan 2017 10:09:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs_db: sanitize geometry on load
Message-ID: <20170112150948.GE14085@bfoster.bfoster>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419041340.32674.2646685552269275817.stgit@birch.djwong.org>
 <81d0d5a9-6a8c-376a-133e-68dc589ec08c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81d0d5a9-6a8c-376a-133e-68dc589ec08c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 12, 2017 at 08:34:50AM -0600, Eric Sandeen wrote:
> On 1/11/17 9:06 PM, Darrick J. Wong wrote:
> > xfs_db doesn't check the filesystem geometry when it's mounting, which
> > means that garbage agcount values can cause OOMs when we try to allocate
> > all the per-AG incore metadata.  If we see geometry that looks
> > suspicious, try to derive the actual AG geometry to avoid crashing the
> > system.  This should help with xfs/1301 fuzzing.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/init.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 81 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/db/init.c b/db/init.c
> > index ec1e274..a394728 100644
> > --- a/db/init.c
> > +++ b/db/init.c
> > @@ -51,13 +51,90 @@ usage(void)
> >  	exit(1);
> >  }
> >  
> > +/* Try to load an AG's superblock, no verifiers. */
> > +static bool
> > +load_sb(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	struct xfs_sb		*sbp)
> > +{
> > +	struct xfs_buf		*bp;
> > +
> > +	bp = libxfs_readbuf(mp->m_ddev_targp,
> > +			    XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> > +			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
> > +
> > +	if (!bp || bp->b_error)
> > +		return false;
> > +
> > +	/* copy SB from buffer to in-core, converting architecture as we go */
> > +	libxfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
> > +	libxfs_putbuf(bp);
> > +	libxfs_purgebuf(bp);
> > +
> > +	return true;
> > +}
> > +
> > +/* If the geometry doesn't look sane, try to figure out the real geometry. */
> > +static void
> > +sanitize_geometry(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_sb		*sbp)
> > +{
> > +	struct xfs_sb		sb;
> > +	xfs_agblock_t		agblocks;
> > +
> > +	/* If the geometry looks ok, we're done. */
> > +	if (sbp->sb_blocklog >= XFS_MIN_BLOCKSIZE_LOG &&
> > +	    sbp->sb_blocklog <= XFS_MAX_BLOCKSIZE_LOG &&
> > +	    sbp->sb_blocksize == (1 << sbp->sb_blocklog) &&
> > +	    sbp->sb_dblocks * sbp->sb_blocksize <= x.dsize * x.dbsize &&
> > +	    sbp->sb_dblocks <= XFS_MAX_DBLOCKS(sbp) &&
> > +	    sbp->sb_dblocks >= XFS_MIN_DBLOCKS(sbp))
> > +		return;
> > +
> > +	/* Check blocklog and blocksize */
> > +	if (sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG ||
> > +	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG)
> > +		sbp->sb_blocklog = libxfs_log2_roundup(sbp->sb_blocksize);

What if blocksize is bogus?

> > +	if (sbp->sb_blocksize != (1 << sbp->sb_blocklog))
> > +		sbp->sb_blocksize = (1 << sbp->sb_blocksize);
> 

Do you mean (1 << sbp->sb_blocklog) here?

> I'm really uneasy with having xfs_db ignore on-disk values and go
> forward after deciding that it "knows better" and modifying what it
> read from disk for fundamental geometry values.
> 

I agree in principle. If I'm using xfs_db, I'd want it to navigate
primarily based on what's on disk. If what is on disk means the
application cannot sanely/safely initialize all of its data structures
and thus limits navigation ability, then so be it.

I guess I'm not clear on if/why we'd need xfs_db to stumble along in a
case where the superblock is hosed enough to cause this kind of problem.
Why wouldn't we just tell the user to run xfs_repair and exit, for
example?

> For agcount, I get it - if we can't even /load/ the FS because we OOM,
> then this debugging tool is of no use.  Partial initialization with a lower
> agcount, if clearly stated to the user, seems reasonable.
> 
> But modifying the primary geometry in other ways, such as changing the
> blocksize or blocklog or dblocks ... I'm just not comfortable with doing
> that here in service to avoiding that OOM, which is related /only/ to
> agcount.
> 
> Many other db functions use these values; modifying the behavior of
> a low-level debugger by silently "knowing better" than what's on disk
> based on educated guesses does not sit well with me.
> 
> I suppose other alternatives might be things like:
> 
> Add an option to read a backup super, instead of the primary
> Add an option to limit the agcount regardless of what's on disk
> 
> I guess both of those have the downside of only knowing this should
> be done /after/ you've OOMed the box on the first try...
> 

These seem like reasonable options if we can detect the off the rails
superblock and exit. Then the user can try more aggressive options as
appropriate. The first seems like a reasonable option. The second seems
like it requires a bit more detail about the supposed corruption and
might not be as generically useful.

Other options might be to scan for a valid superblock a la xfs_repair or
just not initialize format data structures such that we enter a crippled
mode where only raw block access is supported. Either of those might
still not be worth the extra effort beyond just exiting though..? I'm
guessing most of the code probably assumes/expects that things are
initialized one way or another, valid or otherwise..

Brian

> I suppose the other option is to make an educated guess about insane
> agcount, but without modifying any other superblock buffer values.
> 
> And hell at that point maybe just default to 1 ag, to give the admin
> a chance to fix it, and restart xfs_db.  "Insane AG count.  Limiting
> to 1 AG, please fix and restart xfs_db."
> 
> Last thought - how does this "fix it up" heuristic affect xfs_check?
> 
> -Eric
> 
> > +
> > +	/* Clamp dblocks to the size of the device. */
> > +	if (sbp->sb_dblocks > x.dsize * x.dbsize / sbp->sb_blocksize)
> > +		sbp->sb_dblocks = x.dsize * x.dbsize / sbp->sb_blocksize;
> > +
> > +	/* See if agblocks helps us find a superblock. */
> > +	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
> > +	if (load_sb(mp, 1, &sb) && sb.sb_magicnum == XFS_SB_MAGIC) {
> > +		sbp->sb_agcount = sbp->sb_dblocks / sbp->sb_agblocks;
> > +		goto out;
> > +	}
> > +
> > +	/* See if agcount helps us find a superblock. */
> > +	agblocks = sbp->sb_agblocks;
> > +	sbp->sb_agblocks = sbp->sb_dblocks / sbp->sb_agcount;
> > +	if (sbp->sb_agblocks != 0 &&
> > +	    load_sb(mp, 1, &sb) &&
> > +	    sb.sb_magicnum == XFS_SB_MAGIC) {
> > +		goto out;
> > +	}
> 
> 
> 
> > +
> > +	/* Both are nuts, assume 1 AG. */
> > +	sbp->sb_agblocks = agblocks;
> > +	sbp->sb_agcount = 1;
> > +out:
> > +	fprintf(stderr,
> > +		_("%s: device %s AG count is insane.  Limiting reads to the first %u AGs.\n"),
> > +		progname, fsdevice, sbp->sb_agcount);
> > +}
> > +
> >  void
> >  init(
> >  	int		argc,
> >  	char		**argv)
> >  {
> >  	struct xfs_sb	*sbp;
> > -	struct xfs_buf	*bp;
> >  	int		c;
> >  
> >  	setlocale(LC_ALL, "");
> > @@ -124,20 +201,12 @@ init(
> >  	 */
> >  	memset(&xmount, 0, sizeof(struct xfs_mount));
> >  	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
> > -	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
> > -			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
> > -
> > -	if (!bp || bp->b_error) {
> > +	if (!load_sb(&xmount, 0, &xmount.m_sb)) {
> >  		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
> >  			"bytes)\n"), progname, fsdevice);
> >  		exit(1);
> >  	}
> >  
> > -	/* copy SB from buffer to in-core, converting architecture as we go */
> > -	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
> > -	libxfs_putbuf(bp);
> > -	libxfs_purgebuf(bp);
> > -
> >  	sbp = &xmount.m_sb;
> >  	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
> >  		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
> > @@ -148,6 +217,8 @@ init(
> >  		}
> >  	}
> >  
> > +	sanitize_geometry(&xmount, sbp);
> > +
> >  	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
> >  			  LIBXFS_MOUNT_DEBUGGER);
> >  	if (!mp) {
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
