Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3522FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 04:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01C264E70
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 04:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhBLEge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 23:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhBLEgc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 23:36:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C371C64E6B;
        Fri, 12 Feb 2021 04:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613104550;
        bh=XKK8YNu8jQfV5pZ9yvUD6sAn41h0ua4EAH0o+KXNJhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+mzJALMqbh9mnKPte9RwYXUtnPXec+igGh/9bhmZEkOXxsVt5ZbiSiPGXBii0WQi
         Nh3BygSWVUprkKLKQkvwy0nyN0/1/XyOf7hYtpHqB6VMnEeOF/JRYTzrgYQXn4S9jB
         8lmjDS5EoYd6lznRQpD8enWLFXXQaMYZU95HGJ6nobdhKqvbjSVzRVwpl6OegI31AO
         vUX5Kf3Z+e/AJt0/1mlQnpbqW+aipLHu8B1fX735U8do2LPYuOATsxrse0Rm2sKbTn
         6G5z9/Y1eZ6XEGV1xRg2nVeyIaBVlObYVWypvEeltz8eoA7xoen13VO/tsFcCa1Jbm
         P1gHDvgBSck+w==
Date:   Thu, 11 Feb 2021 20:35:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs_repair: allow setting the needsrepair flag
Message-ID: <20210212043550.GJ7193@magnolia>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
 <161308438691.3850286.3501696811159590596.stgit@magnolia>
 <2e135dfe-9be6-b5f9-7c06-a10e6e45e3da@sandeen.net>
 <20210212001731.GH7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212001731.GH7193@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 04:17:31PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 11, 2021 at 05:29:05PM -0600, Eric Sandeen wrote:
> > On 2/11/21 4:59 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
> > > program start and (presumably) clear it by the end of the run.  This
> > > code isn't terribly useful to users; it's mainly here so that fstests
> > > can exercise the functionality.  We don't document this flag in the
> > > manual pages at all because repair clears needsrepair at exit, which
> > > means the knobs only exist for fstests to exercise the functionality.
> > > 
> > > Note that we can't do any of these upgrades until we've at least done a
> > > preliminary scan of the primary super and the log.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > 
> > I'm still a little on the fence about the cmdline option for crashing
> > repair at a certain point from the POV that Brian kind of pointed out
> > that this doesn't exactly scale as we need more hooks.
> 
> (That's in the next patch.)
> 
> > but
> > 
> > ehhhh it's a test-only undocumented option and I guess we could change
> > it later if desired
> > 
> > we do have other debug options on the commandline already as well....
> 
> I don't mind moving the debugging hooks to be seekrit environment
> variables or something, but I don't think I've quite addressed some of
> Brian's comments from last time:
> 
> [paste in stuff Brian said]
> 
> > But is it worth maintaining test specific debug logic in an
> > application just to confirm that particular feature bit upgrades
> > actually set the bit?
> 
> I argue that yes, this is important enough to burn a debugging knob.
> The sequence that I think we should prevent through testing is the one
> where we've set the new feature on the primary super but we haven't
> finished generating whatever new metadata is needed to complete the
> upgrade, the system crashes, and on remount the verifiers explode.
> 
> Chances are pretty good that we'll get an angry bug report on the
> mailing list: "I upgraded my fs, the power went down, and the kernel
> sprayed corruption everywhere!"  If we get a customer escalation like
> this, I'd /much/ rather it be about not being able to mount right after
> the reboot than a latent corruption that grows unseen until somebody's
> filesystem loses data.
> 
> If a future patch to repair accidentally breaks the behavior where we
> set NEEDSREPAIR at the same time as we set the new feature and flush the
> super to disk, we cannot tell that there's been a regression in this
> safety mechanism just by looking at the output of an otherwise
> successful xfs_repair run...
> 
> > It seems sufficient to me to test that needsrepair functionality works
> > as expected and that individual feature upgrade works as well.
> 
> ...so in other words, we need some point to inject an error to make sure
> that the upgrade interlock is correct.
> 
> > Given the discussion on patch 7, perhaps it makes more sense to at
> > least defer this sort of injection mechanism until we have a scheme
> > for generic needsrepair usage worked out for xfs_repair?
> 
> I'm in the midst of prototyping what I said in the last thread --
> hooking the buffe cache so that repair can catch the first time we
> actually write anything to the filesystem, and using that to set
> NEEDSREPAIR.  I've not run it through full fstests yet, but AFAICT I can
> keep using the same tests and the same injection knobs I already wrote.

Ok, so, the buffer cache hook works now.

I split the needsrepair functionality tests into two parts -- one
corrupts a filesystem and runs repair with the error injection armed so
that repair sets NEEDSREPAIR and exits when we try to fix the damaged
metadata.  The second test exercises xfs_admin -O inobtcount=1 in
various scenarios with external devices, and then arms the error
injector to make sure that a partially completed upgrade has to go back
through repair.

I removed -c needsrepair because it's no longer necessary.

I replaced -o debug_needsrepair_force-abort with a magic environment
variable XFS_REPAIR_DEBUG_NEEDSREPAIR so that we don't clutter up the
CLI.

So that at least gets rid of the complaints about CLI clutter.

--D


> 
> > I am wondering if there's a way to make repair fail without requiring
> > additional code, but if not and we do require some sort of injection
> > mode, I suspect we might end up better served by something more
> > generic (i.e. capable of failures at random points) rather than
> > defining a command line option specifically for a particular fstest..
> 
> Probably yes, but ... uh I don't want this to drag on into building a
> generic error injection framework for userspace.
> 
> I would /really/ like to get inobtcount/bigtime tests into the kernel
> without a giant detour they have nearly zero test coverage from the
> wider community.
> 
> --D
> 
> > 
> > > ---
> > >  repair/globals.c    |    2 ++
> > >  repair/globals.h    |    2 ++
> > >  repair/phase2.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  repair/xfs_repair.c |    9 +++++++
> > >  4 files changed, 76 insertions(+)
> > > 
> > > 
> > > diff --git a/repair/globals.c b/repair/globals.c
> > > index 110d98b6..699a96ee 100644
> > > --- a/repair/globals.c
> > > +++ b/repair/globals.c
> > > @@ -49,6 +49,8 @@ int	rt_spec;		/* Realtime dev specified as option */
> > >  int	convert_lazy_count;	/* Convert lazy-count mode on/off */
> > >  int	lazy_count;		/* What to set if to if converting */
> > >  
> > > +bool	add_needsrepair;	/* forcibly set needsrepair while repairing */
> > > +
> > >  /* misc status variables */
> > >  
> > >  int	primary_sb_modified;
> > > diff --git a/repair/globals.h b/repair/globals.h
> > > index 1d397b35..043b3e8e 100644
> > > --- a/repair/globals.h
> > > +++ b/repair/globals.h
> > > @@ -90,6 +90,8 @@ extern int	rt_spec;		/* Realtime dev specified as option */
> > >  extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
> > >  extern int	lazy_count;		/* What to set if to if converting */
> > >  
> > > +extern bool	add_needsrepair;
> > > +
> > >  /* misc status variables */
> > >  
> > >  extern int		primary_sb_modified;
> > > diff --git a/repair/phase2.c b/repair/phase2.c
> > > index 952ac4a5..9a8d42e1 100644
> > > --- a/repair/phase2.c
> > > +++ b/repair/phase2.c
> > > @@ -131,6 +131,63 @@ zero_log(
> > >  		libxfs_max_lsn = log->l_last_sync_lsn;
> > >  }
> > >  
> > > +static bool
> > > +set_needsrepair(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> > > +		printf(
> > > +	_("needsrepair flag only supported on V5 filesystems.\n"));
> > > +		exit(0);
> > > +	}
> > > +
> > > +	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > > +		printf(_("Filesystem already marked as needing repair.\n"));
> > > +		exit(0);
> > > +	}
> > > +
> > > +	printf(_("Marking filesystem in need of repair.\n"));
> > > +	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > +	return true;
> > > +}
> > > +
> > > +/* Perform the user's requested upgrades on filesystem. */
> > > +static void
> > > +upgrade_filesystem(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	struct xfs_buf		*bp;
> > > +	bool			dirty = false;
> > > +	int			error;
> > > +
> > > +	if (add_needsrepair)
> > > +		dirty |= set_needsrepair(mp);
> > > +
> > > +        if (no_modify || !dirty)
> > > +                return;
> > > +
> > > +        bp = libxfs_getsb(mp);
> > > +        if (!bp || bp->b_error) {
> > > +                do_error(
> > > +	_("couldn't get superblock for feature upgrade, err=%d\n"),
> > > +                                bp ? bp->b_error : ENOMEM);
> > > +        } else {
> > > +                libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > > +
> > > +                /*
> > > +		 * Write the primary super to disk immediately so that
> > > +		 * needsrepair will be set if repair doesn't complete.
> > > +		 */
> > > +                error = -libxfs_bwrite(bp);
> > > +                if (error)
> > > +                        do_error(
> > > +	_("filesystem feature upgrade failed, err=%d\n"),
> > > +                                        error);
> > > +        }
> > > +        if (bp)
> > > +                libxfs_buf_relse(bp);
> > > +}
> > > +
> > >  /*
> > >   * ok, at this point, the fs is mounted but the root inode may be
> > >   * trashed and the ag headers haven't been checked.  So we have
> > > @@ -235,4 +292,10 @@ phase2(
> > >  				do_warn(_("would correct\n"));
> > >  		}
> > >  	}
> > > +
> > > +	/*
> > > +	 * Upgrade the filesystem now that we've done a preliminary check of
> > > +	 * the superblocks, the AGs, the log, and the metadata inodes.
> > > +	 */
> > > +	upgrade_filesystem(mp);
> > >  }
> > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > index 90d1a95a..a613505f 100644
> > > --- a/repair/xfs_repair.c
> > > +++ b/repair/xfs_repair.c
> > > @@ -65,11 +65,13 @@ static char *o_opts[] = {
> > >   */
> > >  enum c_opt_nums {
> > >  	CONVERT_LAZY_COUNT = 0,
> > > +	CONVERT_NEEDSREPAIR,
> > >  	C_MAX_OPTS,
> > >  };
> > >  
> > >  static char *c_opts[] = {
> > >  	[CONVERT_LAZY_COUNT]	= "lazycount",
> > > +	[CONVERT_NEEDSREPAIR]	= "needsrepair",
> > >  	[C_MAX_OPTS]		= NULL,
> > >  };
> > >  
> > > @@ -302,6 +304,13 @@ process_args(int argc, char **argv)
> > >  					lazy_count = (int)strtol(val, NULL, 0);
> > >  					convert_lazy_count = 1;
> > >  					break;
> > > +				case CONVERT_NEEDSREPAIR:
> > > +					if (!val)
> > > +						do_abort(
> > > +		_("-c needsrepair requires a parameter\n"));
> > > +					if (strtol(val, NULL, 0) == 1)
> > > +						add_needsrepair = true;
> > > +					break;
> > >  				default:
> > >  					unknown('c', val);
> > >  					break;
> > > 
