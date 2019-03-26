Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732121AbfCZR4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 13:56:36 -0400
Date: Tue, 26 Mar 2019 10:56:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/36] mkfs: validate extent size hint parameters
Message-ID: <20190326175631.GX1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259754740.31886.13886644609473939892.stgit@magnolia>
 <b440242a-5a9c-9772-0fc1-6becf6641221@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b440242a-5a9c-9772-0fc1-6becf6641221@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 26, 2019 at 11:59:22AM -0500, Eric Sandeen wrote:
> On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Validate extent and cow extent size hints that are passed to mkfs so
> > that we avoid formatting a filesystem that will never mount.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 64 insertions(+)
> > 
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index d1387ddf..9e1c6ec5 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2202,6 +2202,66 @@ validate_rtextsize(
> >  	ASSERT(cfg->rtextblocks);
> >  }
> >  
> > +/* Validate the incoming extsize hint as if we were a file. */
> 
> I wonder why "as a file" when hints go on directories, right?

The hint is applied to the root directory with the intention of
spreading it to newly created files, so that's why I thought we should
simulate the extsize check with a file to make sure we're not formatting
a broken filesystem.

The current extsize validator code works the same between regular files
with extsize set and directories with extszinherit set, so you're right
in wondering why not simulate a directory check instead of pretending to
be a file?

My immediate answer to that is ... I had to make an arbitrary choice, so
I picked one and went with it.  A more forward-thinking answer is that
if we ever change libxfs to validate extent size hints different (or not
at all) for directories then it'd be nice to avoid leaving that logic
bomb.  Though mkfs is tightly coupled to libxfs so perhaps that's not
worth worrying about.

So, yes we could simulate the directory extsize check and then move on
to the rt file extsize if the fs is being formatted with a rt volume.
I'll change it & resubmit.

> > +static void
> > +validate_extsize_hint(
> > +	struct xfs_mount	*mp,
> > +	struct cli_params	*cli)
> > +{
> > +	xfs_failaddr_t		fa;
> > +	bool			rt;
> > +	uint16_t		flags = 0;
> > +
> > +	rt = (cli->fsx.fsx_xflags & XFS_DIFLAG_RTINHERIT);
> > +
> > +	if (cli->fsx.fsx_xflags & XFS_DIFLAG_EXTSZINHERIT)
> > +		flags |= XFS_DIFLAG_EXTSIZE;
> 
> i.e. that feels like a weird switch from dir inherit flag to file extsize
> flag, and I'm not sure why it's done here.
> 
> since the mkfs option essentially sets the inherit flag on the root inode,
> (right?) I'd kind of expected this to be:
> 
> +	if (cli->fsx.fsx_xflags & XFS_DIFLAG_EXTSZINHERIT)
> +		flags |= XFS_DIFLAG_EXTSZINHERIT;
> 
> (also surely fsx_xflags should contain XFLAGs? but that's another patch)
> 
> > +
> > +	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
> > +			flags);
> 
> and then:
> 
> +	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFDIR,
> +			flags);
> 
> doesn't really matter to the validator, but conceptually this seems like a
> root dir flag, not a "pretend it's a file!" flag, and seems more consistent.
> 
> > +	if (rt && fa == NULL)
> > +		fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize,
> > +				S_IFREG, flags | XFS_DIFLAG_REALTIME);
> 
> here too...?

This bit here checks that the extent size hint is appropriate for a
realtime file.  There's no other way to do this than to pretend to be a
file because there are no rt directories.

> We talked about this a little on irc but maybe you can remind me why you
> switch to "it's a file!"
> 
> > +	if (fa == NULL)
> > +		return;
> > +
> 
> I wonder if there should be a comment here about keeping these calculations in
> sync with xfs_inode_validate_extsize()?

Yeah.  It's too bad we can't just throw an exception containing a nice
human readable description of the exact thing we got mad about.

> > +	if (rt && mp->m_sb.sb_rextsize > 1)
> > +		fprintf(stderr,
> > +	_("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
> > +				(long long)cli->fsx.fsx_extsize,
> > +				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
> > +				mp->m_sb.sb_rextsize);
> > +	else
> > +		fprintf(stderr,
> > +	_("illegal extent size hint %lld, must be less than %u.\n"),
> > +				(long long)cli->fsx.fsx_extsize,
> > +				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
> > +	usage();
> > +}
> > +
> > +/* Validate the incoming CoW extsize hint as if we were a file. */
> > +static void
> > +validate_cowextsize_hint(
> > +	struct xfs_mount	*mp,
> > +	struct cli_params	*cli)
> > +{
> > +	xfs_failaddr_t		fa;
> > +	uint64_t		flags2 = 0;
> > +
> > +	if (cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE)
> > +		flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> 
> (here the flag is the same for dir or file, but same basic question)

Same answers as above.

--D

> > +	fa = libxfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
> > +			S_IFREG, 0, flags2);
> > +	if (fa == NULL)
> > +		return;
> > +
> > +	fprintf(stderr,
> > +_("illegal CoW extent size hint %lld, must be less than %u.\n"),
> > +			(long long)cli->fsx.fsx_cowextsize,
> > +			min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
> > +	usage();
> > +}
> > +
> >  /*
> >   * Validate the configured stripe geometry, or is none is specified, pull
> >   * the configuration from the underlying device.
> > @@ -3945,6 +4005,10 @@ main(
> >  
> >  	finish_superblock_setup(&cfg, mp, sbp);
> >  
> > +	/* Validate the extent size hints now that @mp is fully set up. */
> > +	validate_extsize_hint(mp, &cli);
> > +	validate_cowextsize_hint(mp, &cli);
> > +
> >  	/* Print the intended geometry of the fs. */
> >  	if (!quiet || dry_run) {
> >  		struct xfs_fsop_geom	geo;
> > 
> 
> 
