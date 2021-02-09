Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB338C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A47C264E31
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhBISYQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 13:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233308AbhBISV4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 13:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD3CE64EC8;
        Tue,  9 Feb 2021 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612894201;
        bh=TBFMhu13t7ubOIbrMsnWDvixdoVYp0esbt1RtnOBwUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSN9s7Cni9yKR732Xm/vZK+XLcIxfE6V4ZWewcr5qaKKDEidVNS7rmUHsMv3ImoBI
         uXSqpBZILHGLgkG1zeqsT5t8hlehfKT8qqB+Y7CsBqM3stzDiZYybBH5Vsl+QeVr5R
         eUygpw9fjf9wqU8dEroZXN7q50vAu9hpe8rPxzMRDFnujdpHAL903MbQf6PdX3kovO
         /gM5sHwVEANjJv4OfGdz3IFm5lPm2mdRD98tD2jeW48/9WsLqkzQFab0rNZFf76R33
         MZA5MWIlEABJ6gi2U+BdFmDX1kEfLYq33Z5rHVJlzm/7xmvAjA0q6zj/u96s3YczQ6
         IhR5Q1zZwkqjQ==
Date:   Tue, 9 Feb 2021 10:10:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
Message-ID: <20210209181001.GT7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384955.3057868.8076509276356847362.stgit@magnolia>
 <20210209172121.GF14273@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209172121.GF14273@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 12:21:21PM -0500, Brian Foster wrote:
> On Mon, Feb 08, 2021 at 08:10:49PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
> > program start and (presumably) clear it by the end of the run.  This
> > code isn't terribly useful to users; it's mainly here so that fstests
> > can exercise the functionality.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  repair/globals.c    |    2 ++
> >  repair/globals.h    |    2 ++
> >  repair/phase1.c     |   23 +++++++++++++++++++++++
> >  repair/xfs_repair.c |    9 +++++++++
> >  4 files changed, 36 insertions(+)
> > 
> > 
> ...
> > diff --git a/repair/phase1.c b/repair/phase1.c
> > index 00b98584..b26d25f8 100644
> > --- a/repair/phase1.c
> > +++ b/repair/phase1.c
> > @@ -30,6 +30,26 @@ alloc_ag_buf(int size)
> >  	return(bp);
> >  }
> >  
> > +static void
> > +set_needsrepair(
> > +	struct xfs_sb	*sb)
> > +{
> > +	if (!xfs_sb_version_hascrc(sb)) {
> > +		printf(
> > +	_("needsrepair flag only supported on V5 filesystems.\n"));
> > +		exit(0);
> > +	}
> > +
> > +	if (xfs_sb_version_needsrepair(sb)) {
> > +		printf(_("Filesystem already marked as needing repair.\n"));
> > +		return;
> > +	}
> 
> Any reason this doesn't exit the repair like the lazy counter logic
> does? Otherwise seems fine:

No particular reason.  Will fix for consistency's sake.

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +
> > +	printf(_("Marking filesystem in need of repair.\n"));
> > +	primary_sb_modified = 1;
> > +	sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +}
> > +
> >  /*
> >   * this has got to be big enough to hold 4 sectors
> >   */
> > @@ -126,6 +146,9 @@ _("Cannot disable lazy-counters on V5 fs\n"));
> >  		}
> >  	}
> >  
> > +	if (add_needsrepair)
> > +		set_needsrepair(sb);
> > +
> >  	/* shared_vn should be zero */
> >  	if (sb->sb_shared_vn) {
> >  		do_warn(_("resetting shared_vn to zero\n"));
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 9dc73854..ee377e8a 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -65,11 +65,13 @@ static char *o_opts[] = {
> >   */
> >  enum c_opt_nums {
> >  	CONVERT_LAZY_COUNT = 0,
> > +	CONVERT_NEEDSREPAIR,
> >  	C_MAX_OPTS,
> >  };
> >  
> >  static char *c_opts[] = {
> >  	[CONVERT_LAZY_COUNT]	= "lazycount",
> > +	[CONVERT_NEEDSREPAIR]	= "needsrepair",
> >  	[C_MAX_OPTS]		= NULL,
> >  };
> >  
> > @@ -302,6 +304,13 @@ process_args(int argc, char **argv)
> >  					lazy_count = (int)strtol(val, NULL, 0);
> >  					convert_lazy_count = 1;
> >  					break;
> > +				case CONVERT_NEEDSREPAIR:
> > +					if (!val)
> > +						do_abort(
> > +		_("-c needsrepair requires a parameter\n"));
> > +					if (strtol(val, NULL, 0) == 1)
> > +						add_needsrepair = true;
> > +					break;
> >  				default:
> >  					unknown('c', val);
> >  					break;
> > 
> 
