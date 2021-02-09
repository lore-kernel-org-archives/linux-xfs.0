Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD50CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90DAC64E3F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhBISUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 13:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233214AbhBISSi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 13:18:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 518AE64E3F;
        Tue,  9 Feb 2021 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612894659;
        bh=0fnqd3rGcBFr/ipr8xqKJAXANXGwidNqaPPuxjuEkZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=irqtHppp3OMgjq4gLq9DOIH8j9QRj6qjOimE0iFzvKTpw1B1X2Xn67A83SkT8NONg
         4mJOo62wFjsF36J4uXU1ewwPXImjaAINKWuG2qac/wKrLyC9LjVe6uvA7QZQxehDHy
         Oh4Koq4k5KnDZxdPJnoeN/E0FVuq0T1B6dTNzucP7ipuIH5jn6zjDpccnQ607NTyf8
         U3UkfD4f3AHx5SNYCxWEbkaJNbjz6MeiuNFY1MaF+IZJW4RKfOQ187o2ciOSgcBBqK
         dUN7boJ/ZYYfG/AucZnYuJTeS0eGjvTyS4VoLVVb/yz2E2+pzPFswOX77XgnSuDla8
         IV3HFdh/ua0hw==
Date:   Tue, 9 Feb 2021 10:17:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs_repair: add a testing hook for NEEDSREPAIR
Message-ID: <20210209181738.GU7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284385516.3057868.355176047687079022.stgit@magnolia>
 <20210209172131.GG14273@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209172131.GG14273@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 12:21:31PM -0500, Brian Foster wrote:
> On Mon, Feb 08, 2021 at 08:10:55PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Simulate a crash when anyone calls force_needsrepair.  This is a debug
> > knob so that we can test that the kernel won't mount after setting
> > needsrepair and that a re-run of xfs_repair will clear the flag.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Can't we just use db to manually set the bit on the superblock?

No, because the fstest uses this debug knob to simulate the following:

1) sysadmin issues 'xfs_admin -O inobtcount /dev/sda1'
2) xfs_repair flips on INOBTCOUNT and NEEDSREPAIR
3) system goes down and repair never completes
4) verify that we can't mount
5) verify that repair clears NEEDSREPAIR and gives us a clean fs
6) verify that mount works again

and the other scenario is:

1) fuzz a directory entry in such a way that repair will decide to
   blow out the dirent and rebuild the directory later
2) sysadmin issues 'xfs_repair /dev/sda1'
2) xfs_repair flips on NEEDSREPAIR at the same time it corrupts the
   dirent to trigger the rebuild later
3) system goes down and repair never completes
4) verify that we can't mount
5) verify that repair clears NEEDSREPAIR and gives us a clean fs
6) verify that mount works again

Both cases reflect what I think are the most likely failure scenarios,
hence the knob needs to be in xfs_repair to prevent it from running to
completion.

(And yes, I've been recently very bad at sending fstests out for review
the past few months; I will get that done by this afternoon.)

--D

> Brian
> 
> >  repair/globals.c    |    1 +
> >  repair/globals.h    |    2 ++
> >  repair/phase1.c     |    5 +++++
> >  repair/xfs_repair.c |    7 +++++++
> >  4 files changed, 15 insertions(+)
> > 
> > 
> > diff --git a/repair/globals.c b/repair/globals.c
> > index 699a96ee..b0e23864 100644
> > --- a/repair/globals.c
> > +++ b/repair/globals.c
> > @@ -40,6 +40,7 @@ int	dangerously;		/* live dangerously ... fix ro mount */
> >  int	isa_file;
> >  int	zap_log;
> >  int	dumpcore;		/* abort, not exit on fatal errs */
> > +bool	abort_after_force_needsrepair;
> >  int	force_geo;		/* can set geo on low confidence info */
> >  int	assume_xfs;		/* assume we have an xfs fs */
> >  char	*log_name;		/* Name of log device */
> > diff --git a/repair/globals.h b/repair/globals.h
> > index 043b3e8e..9fa73b2c 100644
> > --- a/repair/globals.h
> > +++ b/repair/globals.h
> > @@ -82,6 +82,8 @@ extern int	isa_file;
> >  extern int	zap_log;
> >  extern int	dumpcore;		/* abort, not exit on fatal errs */
> >  extern int	force_geo;		/* can set geo on low confidence info */
> > +/* Abort after forcing NEEDSREPAIR to test its functionality */
> > +extern bool	abort_after_force_needsrepair;
> >  extern int	assume_xfs;		/* assume we have an xfs fs */
> >  extern char	*log_name;		/* Name of log device */
> >  extern int	log_spec;		/* Log dev specified as option */
> > diff --git a/repair/phase1.c b/repair/phase1.c
> > index b26d25f8..57f72cd0 100644
> > --- a/repair/phase1.c
> > +++ b/repair/phase1.c
> > @@ -170,5 +170,10 @@ _("Cannot disable lazy-counters on V5 fs\n"));
> >  	 */
> >  	sb_ifree = sb_icount = sb_fdblocks = sb_frextents = 0;
> >  
> > +	/* Simulate a crash after setting needsrepair. */
> > +	if (primary_sb_modified && add_needsrepair &&
> > +	    abort_after_force_needsrepair)
> > +		exit(55);
> > +
> >  	free(sb);
> >  }
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index ee377e8a..ae7106a6 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -44,6 +44,7 @@ enum o_opt_nums {
> >  	BLOAD_LEAF_SLACK,
> >  	BLOAD_NODE_SLACK,
> >  	NOQUOTA,
> > +	FORCE_NEEDSREPAIR_ABORT,
> >  	O_MAX_OPTS,
> >  };
> >  
> > @@ -57,6 +58,7 @@ static char *o_opts[] = {
> >  	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
> >  	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
> >  	[NOQUOTA]		= "noquota",
> > +	[FORCE_NEEDSREPAIR_ABORT] = "debug_force_needsrepair_abort",
> >  	[O_MAX_OPTS]		= NULL,
> >  };
> >  
> > @@ -282,6 +284,9 @@ process_args(int argc, char **argv)
> >  		_("-o debug_bload_node_slack requires a parameter\n"));
> >  					bload_node_slack = (int)strtol(val, NULL, 0);
> >  					break;
> > +				case FORCE_NEEDSREPAIR_ABORT:
> > +					abort_after_force_needsrepair = true;
> > +					break;
> >  				case NOQUOTA:
> >  					quotacheck_skip();
> >  					break;
> > @@ -795,6 +800,8 @@ force_needsrepair(
> >  		error = -libxfs_bwrite(bp);
> >  		if (error)
> >  			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> > +		if (abort_after_force_needsrepair)
> > +			exit(55);
> >  	}
> >  	if (bp)
> >  		libxfs_buf_relse(bp);
> > 
> 
