Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2ACEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 21:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5C264F61
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 21:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhBBVJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 16:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhBBVJ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 16:09:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B480C64DC4;
        Tue,  2 Feb 2021 21:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612300155;
        bh=IOpNarhEQ9i0UclR/1m8MFnF0+yMz23I6kj6bynPj68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G/CQYQIURMpOW/MsCURzHd9OeIDNNqoPU2OiKJqmlMeklOeSk2D6UsmbjKwCqeLkd
         3AuGpSx/CGqT4aNoc7rpaE2wNXdcyTUpP/fESlFeKmJsynmB/uiqBwJHTQ7r7wMiBg
         08adeElb6FStJs2Yj6PlSazyJpy8LXC/++g0/gGzi9r1oiA8tZR3XEitw8KkC3axtH
         H+O2mYHCRYgwqkCOl+CFCZpMZJ5Ly1RfsZkgam0eH1XBwpWWlSRUFfj3BlC0tkLPV3
         1mhcdoh0NM5uui1RHUAiJRovi5L6DOxjYewzfsdm8/kHhJxNOUSaZt44V9s6FbHx+A
         VOscbQm2EqQxw==
Date:   Tue, 2 Feb 2021 13:09:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: support the needsrepair feature flag in the
 version command
Message-ID: <20210202210915.GV7193@magnolia>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076028723.3386490.10074737936252642930.stgit@magnolia>
 <20210119143714.GA1646807@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119143714.GA1646807@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 09:37:14AM -0500, Brian Foster wrote:
> On Fri, Jan 15, 2021 at 05:24:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Teach the xfs_db version command about the 'needsrepair' flag, which can
> > be used to force the system administrator to repair the filesystem with
> > xfs_repair.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  db/check.c           |    5 ++
> >  db/sb.c              |  153 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >  db/xfs_admin.sh      |   10 ++-
> >  man/man8/xfs_admin.8 |   15 +++++
> >  man/man8/xfs_db.8    |    5 ++
> >  5 files changed, 178 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/db/check.c b/db/check.c
> > index 33736e33..485e855e 100644
> > --- a/db/check.c
> > +++ b/db/check.c
> > @@ -3970,6 +3970,11 @@ scan_ag(
> >  			dbprintf(_("mkfs not completed successfully\n"));
> >  		error++;
> >  	}
> > +	if (xfs_sb_version_needsrepair(sb)) {
> > +		if (!sflag)
> > +			dbprintf(_("filesystem needs xfs_repair\n"));
> > +		error++;
> > +	}
> >  	set_dbmap(agno, XFS_SB_BLOCK(mp), 1, DBM_SB, agno, XFS_SB_BLOCK(mp));
> >  	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) == agno)
> >  		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
> > diff --git a/db/sb.c b/db/sb.c
> > index d09f653d..fcc2a0ed 100644
> > --- a/db/sb.c
> > +++ b/db/sb.c
> ...
> > @@ -620,6 +633,112 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
> >  	return 1;
> >  }
> >  
> ...
> > +static bool
> > +upgrade_v5_features(
> > +	struct xfs_mount	*mp,
> > +	const struct v5feat	*upgrade)
> > +{
> > +	struct xfs_sb		tsb;
> > +	struct v5feat		old;
> > +	xfs_agnumber_t		agno = 0;
> > +	xfs_agnumber_t		revert_agno = 0;
> > +
> > +	if (upgrade->compat == mp->m_sb.sb_features_compat &&
> > +	    upgrade->ro_compat == mp->m_sb.sb_features_ro_compat &&
> > +	    upgrade->incompat == mp->m_sb.sb_features_incompat &&
> > +	    upgrade->log_incompat == mp->m_sb.sb_features_log_incompat)
> > +		return true;
> > +
> > +	/* Upgrade primary superblock. */
> > +	if (!get_sb(agno, &tsb))
> > +		goto fail;
> > +
> > +	dbprintf(_("Upgrading V5 filesystem\n"));
> > +
> > +	/* Save the old primary super features in case we revert. */
> > +	get_v5_features(&old, &tsb);
> > +
> > +	/* Update features and force user to run repair before mounting. */
> > +	set_v5_features(&tsb, upgrade);
> > +	tsb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +
> 
> So we explicitly update the primary sb with NEEDSREPAIR...
> 
> > +	/* Write new primary superblock */
> > +	libxfs_sb_to_disk(iocur_top->data, &tsb);
> > +	write_cur();
> > +	if (!iocur_top->bp || iocur_top->bp->b_error)
> > +		goto fail;
> > +
> > +	/* Update the secondary superblocks, or revert. */
> > +	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> > +		if (!get_sb(agno, &tsb)) {
> > +			agno--;
> > +			goto revert;
> > +		}
> > +
> > +		/* Set features and write secondary super. */
> > +		set_v5_features(&tsb, upgrade);
> > +		libxfs_sb_to_disk(iocur_top->data, &tsb);
> > +		write_cur();
> 
> ... but only set NEEDSREPAIR on secondaries if it was set in upgrade by
> the caller?

I didn't think it was necessary to set needsrepair on the secondaries
since xfs_repair is the only program that reads them.  However, I don't
mind doing that for consistency sake.

> > +
> > +		/* Write or abort. */
> > +		if (!iocur_top->bp || iocur_top->bp->b_error)
> > +			goto revert;
> > +	}
> > +
> > +	/* All superblocks updated, update the incore values. */
> > +	set_v5_features(&mp->m_sb, upgrade);
> 
> This also looks like it has the same behavior. I.e., on a 'version
> bigtime' upgrade wouldn't have NEEDSREPAIR set.

Oops.  Good catch, will fix.

> > +	dbprintf(_("Upgraded V5 filesystem.  Please run xfs_repair.\n"));
> > +	return true;
> > +
> > +revert:
> > +	/*
> > +	 * Try to revert feature flag changes, and don't worry if we fail.
> > +	 * We're probably in a mess anyhow, and the admin will have to run
> > +	 * repair anyways.
> > +	 */
> > +	for (revert_agno = 0; revert_agno <= agno; revert_agno++) {
> > +		if (!get_sb(revert_agno, &tsb))
> > +			continue;
> > +
> > +		set_v5_features(&tsb, &old);
> > +		libxfs_sb_to_disk(iocur_top->data, &tsb);
> > +		write_cur();
> > +	}
> > +fail:
> > +	dbprintf(
> > +_("Failed to upgrade V5 filesystem at AG %d, please run xfs_repair.\n"), agno);
> > +	return false;
> > +}
> > +
> >  static char *
> >  version_string(
> >  	xfs_sb_t	*sbp)
> ...
> > @@ -717,8 +836,23 @@ version_f(
> >  			return 0;
> >  		}
> >  
> > +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> > +				progname);
> > +			return 0;
> > +		}
> > +
> >  		/* Logic here derived from the IRIX xfs_chver(1M) script. */
> > -		if (!strcasecmp(argv[1], "extflg")) {
> > +		if (!strcasecmp(argv[1], "needsrepair")) {
> > +			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> > +				dbprintf(
> > +		_("needsrepair flag cannot be enabled on pre-V5 filesystems\n"));
> > +				exitcode = 2;
> > +				return 1;
> 
> Hmm.. I see that exitcode 1 means error && xfs_repair while exitcode 2
> means error && !xfs_repair, but I'm still not sure I follow the high
> level error semantics, particularly if we happen to fail updating
> secondary supers. I wonder if it would be more straightforward to have
> xfs_db only return an error when an update attempt occurs and fails and
> then let xfs_admin run xfs_repair if status == 0 && NEEDSREPAIR is set.

Hm.  I'd be even more tempted to make it run if xfs_db just failed.

> I suppose the various other ".. bit already set" or "v5 super required"
> conditions don't really need to be errors and thus repair would only run
> in those cases if NEEDSREPAIR was still set on the fs. Otherwise if
> xfs_db fails we dump an error message and encourage the user to run
> xfs_repair themselves.

Yeah, that does seem more reasonable.  I'll change xfs_admin to force a
run through repair if the NEEDSREPAIR feature is set or if the xfs_db
command failed, since that probably means something's wrong with the fs.

> There are still corner cases I guess, but that does _seem_ a bit more
> elegant to me. Otherwise I suppose a comment somewhere that explains
> when/why to use which error code would be helpful.

<nod> I'll put them in.

--D

> Brian
> 
> > +			}
> > +
> > +			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +		} else if (!strcasecmp(argv[1], "extflg")) {
> >  			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
> >  			case XFS_SB_VERSION_1:
> >  				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
> > @@ -809,6 +943,11 @@ version_f(
> >  			mp->m_sb.sb_versionnum = version;
> >  			mp->m_sb.sb_features2 = features;
> >  		}
> > +
> > +		if (!upgrade_v5_features(mp, &v5features)) {
> > +			exitcode = 1;
> > +			return 1;
> > +		}
> >  	}
> >  
> >  	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
> > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > index bd325da2..0e79bbf9 100755
> > --- a/db/xfs_admin.sh
> > +++ b/db/xfs_admin.sh
> > @@ -7,9 +7,9 @@
> >  status=0
> >  DB_OPTS=""
> >  REPAIR_OPTS=""
> > -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
> > +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] [-O v5_feature] device [logdev]"
> >  
> > -while getopts "efjlpuc:L:U:V" c
> > +while getopts "efjlpuc:L:O:U:V" c
> >  do
> >  	case $c in
> >  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> > @@ -19,6 +19,9 @@ do
> >  	l)	DB_OPTS=$DB_OPTS" -r -c label";;
> >  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
> >  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> > +	O)	DB_OPTS=$DB_OPTS" -c 'version "$OPTARG"'";
> > +		# Force repair to run by adding a single space to REPAIR_OPTS
> > +		REPAIR_OPTS="$REPAIR_OPTS ";;
> >  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> >  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
> >  	V)	xfs_db -p xfs_admin -V
> > @@ -34,6 +37,7 @@ set -- extra $@
> >  shift $OPTIND
> >  case $# in
> >  	1|2)
> > +		status=0
> >  		# Pick up the log device, if present
> >  		if [ -n "$2" ]; then
> >  			DB_OPTS=$DB_OPTS" -l '$2'"
> > @@ -46,7 +50,7 @@ case $# in
> >  			eval xfs_db -x -p xfs_admin $DB_OPTS $1
> >  			status=$?
> >  		fi
> > -		if [ -n "$REPAIR_OPTS" ]
> > +		if [ -n "$REPAIR_OPTS" ] && [ $status -ne 2 ]
> >  		then
> >  			# Hide normal repair output which is sent to stderr
> >  			# assuming the filesystem is fine when a user is
> > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > index 8afc873f..b423981d 100644
> > --- a/man/man8/xfs_admin.8
> > +++ b/man/man8/xfs_admin.8
> > @@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
> >  [
> >  .B \-eflpu
> >  ] [
> > +.BI \-O " feature"
> > +] [
> >  .BR "\-c 0" | 1
> >  ] [
> >  .B \-L
> > @@ -103,6 +105,19 @@ The filesystem label can be cleared using the special "\c
> >  " value for
> >  .IR label .
> >  .TP
> > +.BI \-O " feature"
> > +Add a new feature to the filesystem.
> > +Only one feature can be specified at a time.
> > +Features are as follows:
> > +.RS 0.7i
> > +.TP
> > +.B needsrepair
> > +If this is a V5 filesystem, flag the filesystem as needing repairs.
> > +Until
> > +.BR xfs_repair (8)
> > +is run, the filesystem will not be mountable.
> > +.RE
> > +.TP
> >  .BI \-U " uuid"
> >  Set the UUID of the filesystem to
> >  .IR uuid .
> > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > index 58727495..7331cf19 100644
> > --- a/man/man8/xfs_db.8
> > +++ b/man/man8/xfs_db.8
> > @@ -971,6 +971,11 @@ may toggle between
> >  and
> >  .B attr2
> >  at will (older kernels may not support the newer version).
> > +The filesystem can be flagged as requiring a run through
> > +.BR xfs_repair (8)
> > +if the
> > +.B needsrepair
> > +option is specified and the filesystem is formatted with the V5 format.
> >  .IP
> >  If no argument is given, the current version and feature bits are printed.
> >  With one argument, this command will write the updated version number
> > 
> 
