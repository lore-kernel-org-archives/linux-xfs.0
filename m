Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728745AbeIQVwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 17:52:22 -0400
Date: Mon, 17 Sep 2018 09:24:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: warn properly about reflink flag with and
 without -n
Message-ID: <20180917162409.GB4607@magnolia>
References: <700e2326-fd4c-224e-bf9c-cb77756e4a55@redhat.com>
 <ca3a9129-bda6-51ff-51cf-2dbe3506444f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca3a9129-bda6-51ff-51cf-2dbe3506444f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 12, 2018 at 05:05:40PM -0500, Eric Sandeen wrote:
> On 9/12/18 2:26 PM, Eric Sandeen wrote:
> > The decision to emit a warning in fix_inode_reflink_flag seems broken; in
> > no-modify mode we'll do_warn that we're setting it (even though we don't),
> > and we'll be silent if it needs to be cleared.
> > 
> > Fix this so it's the standard "would" in no-modify, and "will" in regular
> > mode.  This also ensures that we return the proper status if flags are
> > found to be incorrect in -n or -e mode.
> 
> Oh, oops - I guess this might have been intentional, if "clear reflink flag
> on non-reflinked file" is more of a preening operation?

Correct.

> So in -n mode nothing happens, but we preen/clear it in full mode?

Correct.

> (but in that case do_warn in the full run still triggers a non-zero
> exit code with -e ... bleah)

I think you're correct that it's not necessary to trigger a nonzero exit
code for a successful preening operation.

> (also: this makes refusing to map & boot from "reflinked" files that may

The purpose of the reflink iflag is a hint to the fs that it needs to
check the refcount data when performing writes.  IOWs, we use it to
avoid a performance hit when writing to files that have never been
shared (at least not since creation/the last xfs_{repair,scrub} run/the
last zero-to-eof FUNSHARE call) on a filesystem that supports reflink.

> not even /be/ reflinked at all even /more/ awesomely random, doesn't it!)

"not even be reflinked at all any more..." :)

--D

> -Eric
> 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/repair/rmap.c b/repair/rmap.c
> > index bffb5b61..7ef2d0fd 100644
> > --- a/repair/rmap.c
> > +++ b/repair/rmap.c
> > @@ -1142,16 +1142,27 @@ fix_inode_reflink_flag(
> >  	struct xfs_dinode	*dino;
> >  	struct xfs_buf		*buf;
> >  
> > +	if (no_modify) {
> > +		if (set)
> > +			do_warn(
> > +_("would set reflink flag on inode %"PRIu64"\n"),
> > +				XFS_AGINO_TO_INO(mp, agno, agino));
> > +		else
> > +			do_warn(
> > +_("would clear reflink flag on inode %"PRIu64"\n"),
> > +				XFS_AGINO_TO_INO(mp, agno, agino));
> > +		return 0;
> > +	}
> > +
> > +	/* Modify mode */
> >  	if (set)
> >  		do_warn(
> >  _("setting reflink flag on inode %"PRIu64"\n"),
> >  			XFS_AGINO_TO_INO(mp, agno, agino));
> > -	else if (!no_modify) /* && !set */
> > +	else
> >  		do_warn(
> >  _("clearing reflink flag on inode %"PRIu64"\n"),
> >  			XFS_AGINO_TO_INO(mp, agno, agino));
> > -	if (no_modify)
> > -		return 0;
> >  
> >  	buf = get_agino_buf(mp, agno, agino, &dino);
> >  	if (!buf)
> > 
