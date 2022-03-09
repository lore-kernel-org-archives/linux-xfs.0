Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DE2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 23:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbiCIX2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiCIX2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 18:28:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D9D47392
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 15:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E643BB82443
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 23:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8297FC340E8;
        Wed,  9 Mar 2022 23:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646868461;
        bh=gNiDRR7QgUrl7wJ0hORRvzRZVb5FWGLuKYc76P+xVPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YMhRia1gPZ/w7rWy+0Nbpsa1k/RtYZLoONUUcqTL8ZKLZrSyoRP0yeOQ9t2hYpPVM
         3LAUHSCflbkRa3svSULlKDViufpAf2nT8JqcOZECgUuNby+ABUeE04L42ioblpRgIA
         FZ0m18kFbWfvJxLMGRYUUgsNsiabjWpUJFraz36yNhG8u367tUodJfiQrYMUECy9ML
         8wrBRG/o3M0k6kog9/Qy+poKluPxo1yfa2ZoT6S1eXYs2smMIElKgepSYIbhsf0lBp
         K3yKWrO20pdlENBcRnD9ehRMsuP7Amt+ubTiVg7AAI6nbph7TgNkLBq2+J8YGrb5Ck
         CQVUn//tv4OdA==
Date:   Wed, 9 Mar 2022 15:27:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: constify xfs_name_dotdot
Message-ID: <20220309232740.GD8224@magnolia>
References: <164685375609.496011.2754821878646256374.stgit@magnolia>
 <164685376731.496011.1567771444928519597.stgit@magnolia>
 <20220309223245.GK661808@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309223245.GK661808@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 09:32:45AM +1100, Dave Chinner wrote:
> On Wed, Mar 09, 2022 at 11:22:47AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The symbol xfs_name_dotdot is a global variable that the xfs codebase
> > uses here and there to look up directory dotdot entries.  Currently it's
> > a non-const variable, which means that it's a mutable global variable.
> > So far nobody's abused this to cause problems, but let's use the
> > compiler to enforce that.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_dir2.c |    6 +++++-
> >  fs/xfs/libxfs/xfs_dir2.h |    2 +-
> >  fs/xfs/scrub/parent.c    |    6 ++++--
> >  fs/xfs/xfs_export.c      |    3 ++-
> >  4 files changed, 12 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> > index a77d931d65a3..cf9fa07e62d5 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.c
> > +++ b/fs/xfs/libxfs/xfs_dir2.c
> > @@ -19,7 +19,11 @@
> >  #include "xfs_error.h"
> >  #include "xfs_trace.h"
> >  
> > -struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
> > +const struct xfs_name xfs_name_dotdot = {
> > +	.name	= (unsigned char *)"..",
> > +	.len	= 2,
> > +	.type	= XFS_DIR3_FT_DIR,
> > +};
> 
> *nod*
> 
> > diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> > index ab182a5cd0c0..e9549d998cdc 100644
> > --- a/fs/xfs/scrub/parent.c
> > +++ b/fs/xfs/scrub/parent.c
> > @@ -131,6 +131,7 @@ xchk_parent_validate(
> >  	xfs_ino_t		dnum,
> >  	bool			*try_again)
> >  {
> > +	struct xfs_name		dotdot = xfs_name_dotdot;
> >  	struct xfs_mount	*mp = sc->mp;
> >  	struct xfs_inode	*dp = NULL;
> >  	xfs_nlink_t		expected_nlink;
> > @@ -230,7 +231,7 @@ xchk_parent_validate(
> >  	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
> >  
> >  	/* Look up '..' to see if the inode changed. */
> > -	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
> > +	error = xfs_dir_lookup(sc->tp, sc->ip, &dotdot, &dnum, NULL);
> >  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
> >  		goto out_rele;
> >  
> 
> Why can't xfs_dir_lookup() be defined as a const xname for the input
> name? All it does is extract the contents into the da_args fields,
> and pass it to xfs_dir_hashname() which you converted to const in
> the previous patch.

The metadata directory patchset changes xfs_dir_lookup to return the
ftype in the dirent so that it can bail early if the dirent doesn't
point to the filetype that we want.

I wouldn't be /that/ sad to remove that bit of functionality in favor of
constifying the name parameter to xfs_dir_lookup.

Thinking about this more, I think the metadir code could implement its
own lookup dispatch function that /does/ return the dirent ftype, since
the sf/block/node/leaf functions all live in libxfs anyway.

> Or does the compiler then complain at all the other callsites that
> you're passing non-const stuff to const function parameters? i.e. am
> I just pulling on another dangling end of the ball of string at this
> point?

Nope, just djwong-dev blindness. :(

> > @@ -263,6 +264,7 @@ int
> >  xchk_parent(
> >  	struct xfs_scrub	*sc)
> >  {
> > +	struct xfs_name		dotdot = xfs_name_dotdot;
> >  	struct xfs_mount	*mp = sc->mp;
> >  	xfs_ino_t		dnum;
> >  	bool			try_again;
> > @@ -293,7 +295,7 @@ xchk_parent(
> >  	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
> >  
> >  	/* Look up '..' */
> > -	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
> > +	error = xfs_dir_lookup(sc->tp, sc->ip, &dotdot, &dnum, NULL);
> >  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
> >  		goto out;
> >  	if (!xfs_verify_dir_ino(mp, dnum)) {
> > diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> > index 1064c2342876..8939119191f4 100644
> > --- a/fs/xfs/xfs_export.c
> > +++ b/fs/xfs/xfs_export.c
> > @@ -206,10 +206,11 @@ STATIC struct dentry *
> >  xfs_fs_get_parent(
> >  	struct dentry		*child)
> >  {
> > +	struct xfs_name		dotdot = xfs_name_dotdot;
> >  	int			error;
> >  	struct xfs_inode	*cip;
> >  
> > -	error = xfs_lookup(XFS_I(d_inode(child)), &xfs_name_dotdot, &cip, NULL);
> > +	error = xfs_lookup(XFS_I(d_inode(child)), &dotdot, &cip, NULL);
> >  	if (unlikely(error))
> >  		return ERR_PTR(error);
> 
> This only calls xfs_dir_lookup() with name, so if xfs_dir_lookup()
> can have a const name, so can xfs_lookup()....

Yep.  I'll fix that in the next version.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
