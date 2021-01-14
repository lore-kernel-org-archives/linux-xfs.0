Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBC5C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 09:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABB423A21
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 09:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbhANJkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 04:40:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728328AbhANJkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 04:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610617125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4SVqaCuHuu2ntcJXE44AId6NY8J3Mg5ZNYgIkXD6J/k=;
        b=KdwtdFfE00U4hGN/LBFaYJKe4aL8Q71Mv/oLYE+1MNJvLu+RnP9TnEZKaJRyt+YUHUECdY
        RYr+kv2XuWNDmaVPVoUdK89aR8zEJ4bZ72UMyC+BgIHMXJN6S9tlBsxzkIwfbvS2qmn1v6
        uEFcStG2ZXdXvCbQKUPaGyLq9koPjdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-xyCXEVlyMbSiU90S7KZLXA-1; Thu, 14 Jan 2021 04:38:43 -0500
X-MC-Unique: xyCXEVlyMbSiU90S7KZLXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09826107ACF7;
        Thu, 14 Jan 2021 09:38:42 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41CF9272A4;
        Thu, 14 Jan 2021 09:38:41 +0000 (UTC)
Date:   Thu, 14 Jan 2021 04:38:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_db: support the needsrepair feature flag in the
 version command
Message-ID: <20210114093839.GA1333929@bfoster>
References: <161017367756.1141483.3709627869982359451.stgit@magnolia>
 <161017369046.1141483.16610223576448257468.stgit@magnolia>
 <20210113172331.GB1284163@bfoster>
 <20210114010124.GU1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114010124.GU1164246@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 05:01:24PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 13, 2021 at 12:23:31PM -0500, Brian Foster wrote:
> > On Fri, Jan 08, 2021 at 10:28:10PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Teach the xfs_db version command about the 'needsrepair' flag, which can
> > > be used to force the system administrator to repair the filesystem with
> > > xfs_repair.
> > > 
> > 
> > Remind me of the use case for this particular flag..?
> 
> Eric wanted us to have a means to force users to run xfs_repair after an
> upgrade, on the off chance that xfs_admin fails to do so, or someone
> run xfs_db directly, etc.
> 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  db/check.c           |    5 ++
> > >  db/sb.c              |  158 ++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  db/xfs_admin.sh      |    6 ++
> > >  man/man8/xfs_admin.8 |   15 +++++
> > >  man/man8/xfs_db.8    |    5 ++
> > >  5 files changed, 181 insertions(+), 8 deletions(-)
> > > 
> > > 
> > > diff --git a/db/check.c b/db/check.c
> > > index 33736e33..485e855e 100644
> > > --- a/db/check.c
> > > +++ b/db/check.c
> > > @@ -3970,6 +3970,11 @@ scan_ag(
> > >  			dbprintf(_("mkfs not completed successfully\n"));
> > >  		error++;
> > >  	}
> > > +	if (xfs_sb_version_needsrepair(sb)) {
> > > +		if (!sflag)
> > > +			dbprintf(_("filesystem needs xfs_repair\n"));
> > > +		error++;
> > > +	}
> > 
> > I wonder a bit how much we want to cripple more developer oriented
> > commands vs obvious admin operations. label/uuid make sense, but what's
> > the motivation for check?
> 
> Cripple how?  xfs_check runs fine, albeit now it'll warn you that the fs
> is flagged needsrepair and it won't return 0.
> 

I was thinking this would bail out of check as the similar hunks below
do, but sounds like that's not the case. Disregard..

> > >  	set_dbmap(agno, XFS_SB_BLOCK(mp), 1, DBM_SB, agno, XFS_SB_BLOCK(mp));
> > >  	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) == agno)
> > >  		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
> > > diff --git a/db/sb.c b/db/sb.c
> > > index d09f653d..93e4c405 100644
> > > --- a/db/sb.c
> > > +++ b/db/sb.c
> > > @@ -379,6 +379,11 @@ uuid_f(
> > >  				progname);
> > >  			return 0;
> > >  		}
> > > +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > > +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> > > +				progname);
> > > +			return 0;
> > > +		}
> > >  
> > >  		if (!strcasecmp(argv[1], "generate")) {
> > >  			platform_uuid_generate(&uu);
> > > @@ -501,6 +506,7 @@ do_label(xfs_agnumber_t agno, char *label)
> > >  		memcpy(&lbl[0], &tsb.sb_fname, sizeof(tsb.sb_fname));
> > >  		return &lbl[0];
> > >  	}
> > > +
> > >  	/* set label */
> > >  	if ((len = strlen(label)) > sizeof(tsb.sb_fname)) {
> > >  		if (agno == 0)
> > > @@ -543,6 +549,12 @@ label_f(
> > >  			return 0;
> > >  		}
> > >  
> > > +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > > +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> > > +				progname);
> > > +			return 0;
> > > +		}
> > > +
> > >  		dbprintf(_("writing all SBs\n"));
> > >  		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
> > >  			if ((p = do_label(ag, argv[1])) == NULL) {
> > > @@ -584,6 +596,7 @@ version_help(void)
> > >  " 'version attr1'    - enable v1 inline extended attributes\n"
> > >  " 'version attr2'    - enable v2 inline extended attributes\n"
> > >  " 'version log2'     - enable v2 log format\n"
> > > +" 'version needsrepair' - flag filesystem as requiring repair\n"
> > >  "\n"
> > >  "The version function prints currently enabled features for a filesystem\n"
> > >  "according to the version field of its primary superblock.\n"
> > > @@ -620,6 +633,117 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
> > >  	return 1;
> > >  }
> > >  
> > > +struct v5feat {
> > > +	uint32_t		compat;
> > > +	uint32_t		ro_compat;
> > > +	uint32_t		incompat;
> > > +	uint32_t		log_incompat;
> > > +};
> > > +
> > > +static void
> > > +get_v5_features(
> > > +	struct xfs_mount	*mp,
> > > +	struct v5feat		*feat)
> > > +{
> > > +	feat->compat = mp->m_sb.sb_features_compat;
> > > +	feat->ro_compat = mp->m_sb.sb_features_ro_compat;
> > > +	feat->incompat = mp->m_sb.sb_features_incompat;
> > > +	feat->log_incompat = mp->m_sb.sb_features_log_incompat;
> > > +}
> > > +
> > > +static bool
> > > +set_v5_features(
> > > +	struct xfs_mount	*mp,
> > > +	const struct v5feat	*upgrade)
> > > +{
> > > +	struct xfs_sb		tsb;
> > > +	struct v5feat		old;
> > > +	xfs_agnumber_t		agno = 0;
> > > +	xfs_agnumber_t		revert_agno = 0;
> > > +
> > > +	if (upgrade->compat == mp->m_sb.sb_features_compat &&
> > > +	    upgrade->ro_compat == mp->m_sb.sb_features_ro_compat &&
> > > +	    upgrade->incompat == mp->m_sb.sb_features_incompat &&
> > > +	    upgrade->log_incompat == mp->m_sb.sb_features_log_incompat)
> > > +		return true;
> > > +
> > > +	/* Upgrade primary superblock. */
> > > +	if (!get_sb(agno, &tsb))
> > > +		goto fail;
> > > +
> > > +	dbprintf(_("Upgrading V5 filesystem\n"));
> > > +
> > > +	/* Save old values */
> > > +	old.compat = tsb.sb_features_compat;
> > > +	old.ro_compat = tsb.sb_features_ro_compat;
> > > +	old.incompat = tsb.sb_features_incompat;
> > > +	old.log_incompat = tsb.sb_features_log_incompat;
> > > +
> > 
> > This could reuse get_v5_features() if it accepted an xfs_sb, no?
> 
> Yes, fixed.
> 
> > > +	/* Update feature flags and force user to run repair before mounting. */
> > > +	tsb.sb_features_compat |= upgrade->compat;
> > > +	tsb.sb_features_ro_compat |= upgrade->ro_compat;
> > > +	tsb.sb_features_incompat |= upgrade->incompat;
> > > +	tsb.sb_features_log_incompat |= upgrade->log_incompat;
> > > +	tsb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > 
> > Isn't this set in upgrade->incompat already? Looking ahead in the
> > series, I see more feature bit update patches, so perhaps this is
> > intentional... If so, should it be unconditional for all feature bit
> > updates? (A comment around this would be nice.)
> 
> It's only set for 'version needsrepair'.  The other feature upgraders
> will add their own feature bit, but they're not expected to set
> needsrepair on their own.  Setting it here is how we make it
> unconditional.
> 

Ok. A more explicit comment (i.e. "set needsrepair for all feature bit
changes") couldn't hurt, just because it might look funny to somebody
looking at the needsrepair caller.

> > Also, it looks like we could just do assignments instead of OR'ing so
> > this could support clearing a flag. I suppose that would stamp over
> > different secondary superblock values, but does that really matter?
> 
> I don't think we can generally support /removing/ features, since you'd
> have to scan the entire fs to see if anything is using them.  The
> exception to that might be rmap since the rmapbt isn't referenced from
> other parts of the ondisk structure... but then we don't support
> upgrading to rmap yet.
> 
> I'll change it to assignments though, since there's no reason not to.
> 
> > Another small v5feat -> sb set helper to reduce the repetition through
> > the rest of the function would also be nice.
> 
> Ok.
> 
> > > +	libxfs_sb_to_disk(iocur_top->data, &tsb);
> > > +
> > > +	/* Write new primary superblock */
> > > +	write_cur();
> > > +	if (!iocur_top->bp || iocur_top->bp->b_error)
> > > +		goto fail;
> > > +
> > > +	/* Update the secondary superblocks, or revert. */
> > > +	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> > > +		if (!get_sb(agno, &tsb)) {
> > > +			agno--;
> > > +			goto revert;
> > > +		}
> > > +
> > > +		/* Set features on secondary suepr. */
> > > +		tsb.sb_features_compat |= upgrade->compat;
> > > +		tsb.sb_features_ro_compat |= upgrade->ro_compat;
> > > +		tsb.sb_features_incompat |= upgrade->incompat;
> > > +		tsb.sb_features_log_incompat |= upgrade->log_incompat;
> > > +		libxfs_sb_to_disk(iocur_top->data, &tsb);
> > > +		write_cur();
> > > +
> > > +		/* Write or abort. */
> > > +		if (!iocur_top->bp || iocur_top->bp->b_error)
> > > +			goto revert;
> > > +	}
> > > +
> > > +	/* All superblocks updated, update the incore values. */
> > > +	mp->m_sb.sb_features_compat |= upgrade->compat;
> > > +	mp->m_sb.sb_features_ro_compat |= upgrade->ro_compat;
> > > +	mp->m_sb.sb_features_incompat |= upgrade->incompat;
> > > +	mp->m_sb.sb_features_log_incompat |= upgrade->log_incompat;
> > > +
> > > +	dbprintf(_("Upgraded V5 filesystem.  Please run xfs_repair.\n"));
> > > +	return true;
> > > +
> > > +revert:
> > > +	/*
> > > +	 * Try to revert feature flag changes, and don't worry if we fail.
> > > +	 * We're probably in a mess anyhow, and the admin will have to run
> > > +	 * repair anyways.
> > > +	 */
> > > +	for (revert_agno = 0; revert_agno <= agno; revert_agno++) {
> > > +		if (!get_sb(revert_agno, &tsb))
> > > +			continue;
> > > +
> > > +		tsb.sb_features_compat = old.compat;
> > > +		tsb.sb_features_ro_compat = old.ro_compat;
> > > +		tsb.sb_features_incompat = old.incompat;
> > > +		tsb.sb_features_log_incompat = old.log_incompat;
> > > +		libxfs_sb_to_disk(iocur_top->data, &tsb);
> > > +		write_cur();
> > > +	}
> > > +fail:
> > > +	dbprintf(
> > > +_("Failed to upgrade V5 filesystem at AG %d, please run xfs_repair.\n"), agno);
> > > +	return false;
> > > +}
> > > +
> > >  static char *
> > >  version_string(
> > >  	xfs_sb_t	*sbp)
> > > @@ -691,15 +815,12 @@ version_string(
> > >  		strcat(s, ",INOBTCNT");
> > >  	if (xfs_sb_version_hasbigtime(sbp))
> > >  		strcat(s, ",BIGTIME");
> > > +	if (xfs_sb_version_needsrepair(sbp))
> > > +		strcat(s, ",NEEDSREPAIR");
> > >  	return s;
> > >  }
> > >  
> > > -/*
> > > - * XXX: this only supports reading and writing to version 4 superblock fields.
> > > - * V5 superblocks always define certain V4 feature bits - they are blocked from
> > > - * being changed if a V5 sb is detected, but otherwise v5 superblock features
> > > - * are not handled here.
> > > - */
> > > +/* Upgrade a superblock to support a feature. */
> > >  static int
> > >  version_f(
> > >  	int		argc,
> > > @@ -710,6 +831,9 @@ version_f(
> > >  	xfs_agnumber_t	ag;
> > >  
> > >  	if (argc == 2) {	/* WRITE VERSION */
> > > +		struct v5feat	v5features;
> > > +
> > > +		get_v5_features(mp, &v5features);
> > >  
> > >  		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
> > >  			dbprintf(_("%s: not in expert mode, writing disabled\n"),
> > > @@ -717,8 +841,23 @@ version_f(
> > >  			return 0;
> > >  		}
> > >  
> > > +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > > +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> > > +				progname);
> > > +			return 0;
> > > +		}
> > > +
> > 
> > Similar to the above question, I wonder whether we should allow clearing
> > the flag. Eh, I suppose rewriting the superblock via db should still
> > work, right?
> 
> Hrm.  The difficulty with letting xfs_db clear the needsrepair flag via
> version_f is that xfs_admin passes its -O argument directly to xfs_db,
> which means that people will gain the ability to do things like:
> 
> xfs_admin -O inobtcount /dev/sda1
> xfs_admin -O ^needsrepair /dev/sda1
> mount /dev/sda1 /mnt
> <missing metadata counters, kaboom>
> 

In general, I don't think we have a responsibility to protect users by
not providing developer tool functionality that can be potentially
misused. IMO, the needsrepair state helps protects users in weird
failure scenarios and whatnot who might not have the fs expertise to
realize the intermediate state of the fs, the independent stages of how
a particular upgrade sequence works (i.e., feature bit change + repair),
etc. Users who choose to explicitly bypass that state kind of earn the
result.. ;)

That said, it's probably not worth providing a special version interface
when db can already tweak individual superblock fields fairly elegantly,
so as long as that still works I'm good..

> > >  		/* Logic here derived from the IRIX xfs_chver(1M) script. */
> > > -		if (!strcasecmp(argv[1], "extflg")) {
> > > +		if (!strcasecmp(argv[1], "needsrepair")) {
> > > +			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> > > +				dbprintf(
> > > +		_("needsrepair flag cannot be enabled on pre-V5 filesystems\n"));
> > > +				exitcode = 1;
> > > +				return 1;
> > > +			}
> > > +
> > > +			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > +		} else if (!strcasecmp(argv[1], "extflg")) {
> > >  			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
> > >  			case XFS_SB_VERSION_1:
> > >  				version = 0x0004 | XFS_SB_VERSION_EXTFLGBIT;
> > > @@ -809,6 +948,11 @@ version_f(
> > >  			mp->m_sb.sb_versionnum = version;
> > >  			mp->m_sb.sb_features2 = features;
> > >  		}
> > > +
> > > +		if (!set_v5_features(mp, &v5features)) {
> > > +			exitcode = 1;
> > > +			return 1;
> > > +		}
> > >  	}
> > >  
> > >  	if (argc == 3) {	/* VERSIONNUM + FEATURES2 */
> > > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > > index bd325da2..41a14d45 100755
> > > --- a/db/xfs_admin.sh
> > > +++ b/db/xfs_admin.sh
> > > @@ -9,7 +9,7 @@ DB_OPTS=""
> > >  REPAIR_OPTS=""
> > >  USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
> > >  
> > 
> > Update with the new -O flag..?
> 
> D'oh, fixed, thanks.
> 
> > > -while getopts "efjlpuc:L:U:V" c
> > > +while getopts "efjlpuc:L:O:U:V" c
> > >  do
> > >  	case $c in
> > >  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> > > @@ -19,6 +19,9 @@ do
> > >  	l)	DB_OPTS=$DB_OPTS" -r -c label";;
> > >  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
> > >  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> > > +	O)	DB_OPTS=$DB_OPTS" -c 'version "$OPTARG"'";
> > > +		# Force repair to run by adding a single space to REPAIR_OPTS
> > > +		REPAIR_OPTS="$REPAIR_OPTS ";;
> > 
> > Is a full/destructive repair technically required for a post-feature bit
> > change? IOW, is metadata reconstruction required or are we just checking
> > the fs is consistent? I ask because otherwise a destructive repair would
> > do things like reconstruct btrees and whatnot, which might be overkill,
> > take too long for a user, OOM, etc. Obviously we need to clear
> > NEEDSREPAIR, but I wonder if there's room for a special repair mode that
> > might elide some of the other changes if the filesystem is actually
> > coherent.  For example, a "verify" mode where nomodify == true except
> > for clearing NEEDSREPAIR if the fs is coherent (otherwise a normal run
> > is required).
> 
> Well... for the features that one /could/ add trivially, this is what
> repair needs to do:
> 
> inobtcount: count inobt/finobt blocks and store them in AGI
> bigtime: nothing
> reflink: initialize empty refcount btree
> finobt: build free inode btree from existing inode btree
> rmapbt: build rmap btree by scanning fs
> 
> So depending on the feature you might not necessarily need the full
> repair run.  That said, past me has worked on tune2fs, which at this
> point has accumulated nearly enough fs scanning code to compete with
> e2fsck.  I don't want to go there. :)
> 

Ack. Ok, so I suppose a more granular repair might still be an
interesting concept on its own if feature management becomes more of a
thing in the future, but certainly there's no major reason to require
that right now.

> > >  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> > >  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
> > >  	V)	xfs_db -p xfs_admin -V
> > > @@ -48,6 +51,7 @@ case $# in
> > >  		fi
> > >  		if [ -n "$REPAIR_OPTS" ]
> > >  		then
> > > +			echo "Running xfs_repair to ensure filesystem consistency."
> > 
> > Is this necessary or a debug leftover?
> 
> I'd intended it as a warning for when you run xfs_admin -O inobtcount
> and the repair that follows starts complaining about the zeroed inode
> btree counter fields in the AGI.  I think I'll reword this, at the very
> least.
> 

Ok.

Brian

> Thanks for taking a look at these patches!
> 
> --D
> 
> > Brian
> > 
> > >  			# Hide normal repair output which is sent to stderr
> > >  			# assuming the filesystem is fine when a user is
> > >  			# running xfs_admin.
> > > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > > index 8afc873f..b423981d 100644
> > > --- a/man/man8/xfs_admin.8
> > > +++ b/man/man8/xfs_admin.8
> > > @@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
> > >  [
> > >  .B \-eflpu
> > >  ] [
> > > +.BI \-O " feature"
> > > +] [
> > >  .BR "\-c 0" | 1
> > >  ] [
> > >  .B \-L
> > > @@ -103,6 +105,19 @@ The filesystem label can be cleared using the special "\c
> > >  " value for
> > >  .IR label .
> > >  .TP
> > > +.BI \-O " feature"
> > > +Add a new feature to the filesystem.
> > > +Only one feature can be specified at a time.
> > > +Features are as follows:
> > > +.RS 0.7i
> > > +.TP
> > > +.B needsrepair
> > > +If this is a V5 filesystem, flag the filesystem as needing repairs.
> > > +Until
> > > +.BR xfs_repair (8)
> > > +is run, the filesystem will not be mountable.
> > > +.RE
> > > +.TP
> > >  .BI \-U " uuid"
> > >  Set the UUID of the filesystem to
> > >  .IR uuid .
> > > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > > index 58727495..7331cf19 100644
> > > --- a/man/man8/xfs_db.8
> > > +++ b/man/man8/xfs_db.8
> > > @@ -971,6 +971,11 @@ may toggle between
> > >  and
> > >  .B attr2
> > >  at will (older kernels may not support the newer version).
> > > +The filesystem can be flagged as requiring a run through
> > > +.BR xfs_repair (8)
> > > +if the
> > > +.B needsrepair
> > > +option is specified and the filesystem is formatted with the V5 format.
> > >  .IP
> > >  If no argument is given, the current version and feature bits are printed.
> > >  With one argument, this command will write the updated version number
> > > 
> > 
> 

