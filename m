Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04186C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 21:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDC91207DD
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 21:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLCVVl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 16:21:41 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37856 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727524AbfLCVVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 16:21:41 -0500
Received: from dread.disaster.area (pa49-179-150-192.pa.nsw.optusnet.com.au [49.179.150.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9D35543FC99;
        Wed,  4 Dec 2019 08:21:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1icFc0-00060g-W3; Wed, 04 Dec 2019 08:21:37 +1100
Date:   Wed, 4 Dec 2019 08:21:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>
Subject: Re: [RFC PATCH] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191203212136.GK2695@dread.disaster.area>
References: <20191202173538.GD7335@magnolia>
 <20191202212140.GG2695@dread.disaster.area>
 <20191203023041.GH7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203023041.GH7335@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ZXpxJgW8/q3NVgupyyvOCQ==:117 a=ZXpxJgW8/q3NVgupyyvOCQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=7-415B0cAAAA:8 a=pf7mkpEr5fwtDdawSyUA:9 a=bGJBnnoWv6JkgLqm:21
        a=HM7_oB8MIRHZ6763:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 06:30:41PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 03, 2019 at 08:21:40AM +1100, Dave Chinner wrote:
> > On Mon, Dec 02, 2019 at 09:35:38AM -0800, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> > > index 323592d563d5..9d9fe7b488b8 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc.h
> > > +++ b/fs/xfs/libxfs/xfs_ialloc.h
> > > @@ -152,5 +152,7 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
> > >  
> > >  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
> > >  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
> > > +void xfs_ialloc_find_prealloc(struct xfs_mount *mp, xfs_agino_t *first_agino,
> > > +		xfs_agino_t *last_agino);
> > >  
> > >  #endif	/* __XFS_IALLOC_H__ */
> > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > index 7b35d62ede9f..d830a9e13817 100644
> > > --- a/fs/xfs/xfs_ioctl.c
> > > +++ b/fs/xfs/xfs_ioctl.c
> > > @@ -891,6 +891,9 @@ xfs_ioc_fsgeometry(
> > >  
> > >  	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
> > >  
> > > +	fsgeo.sunit = mp->m_sb.sb_unit;
> > > +	fsgeo.swidth = mp->m_sb.sb_width;
> > 
> > Why?
> 
> This was in keeping with Alex' suggestion to use the sunit values incore
> even if we don't update the superblock.

Not sure about that. If we are getting the geometry for the purposes
of working out where something is on disk (e.g. the root inode :),
then we need what is in the superblock, not what is in memory...

> > > +		if (sbp->sb_unit == mp->m_dalign &&
> > > +		    sbp->sb_width == mp->m_swidth)
> > > +			return 0;
> > > +
> > > +		old_su = sbp->sb_unit;
> > > +		old_sw = sbp->sb_width;
> > > +		sbp->sb_unit = mp->m_dalign;
> > > +		sbp->sb_width = mp->m_swidth;
> > > +		xfs_ialloc_find_prealloc(mp, &first, &last);
> > 
> > We just chuck last away? why calculate it then?
> 
> Hmmm.  Repair uses it to silence the "inode chunk claims used block"
> error if an inobt record points to something owned by XR_E_INUSE_FS* if
> the inode points to something in that first chunk.  Not sure /why/ it
> does that; it seems to have done that since the creation of the git
> repo.

Hysterical raisins that have long since decomposed, I'm guessing....

> Frankly, I'm not convinced that's the right behavior; the root inode
> chunk should never collide with something else, period.

*nod*

I suspect the way repair uses the last_prealloc_ino can go away,
especially as the inode number calculated is not correct in the
first place...

> > And why not just
> > pass mp->m_dalign/mp->m_swidth into the function rather than setting
> > them in the sb and then having to undo the change? i.e.
> > 
> > 		rootino = xfs_ialloc_calc_rootino(mp, mp->m_dalign, mp->m_swidth);
> 
> <shrug> The whole point was to create a function that computes where the
> first allocated inode chunk should be from an existing mountpoint and
> superblock, maybe the caller should make a copy, update the parameters,
> and then pass the copy into this function?

That's a whole lot of cruft that we can avoid just by passing in
our specific stripe alignment.

What we need to kow is whether a specific stripe geometry will
result in the root inode location changing, and so I'm of the
opinion we should just write a function that calculates the location
based on the supplied geometry and the caller can do whatever checks
it needs to with the inode number returned.

That provides what both repair and the kernel mount validation
requires...

> > Should this also return EINVAL, as per above when the DALIGN sb
> > feature bit is not set?
> 
> I dunno.  We've never rejected these mount options before, which makes
> me a little hesitant to break everybody's scripts, even if it /is/
> improper behavior that leads to repair failure.  We /do/ have the option
> that Alex suggested of modifying the incore values to change the
> allocator behavior without committing them to the superblock, which is
> what this patch does.
> 
> OTOH the manual pages say that you're not supposed to do this, which
> might be a strong enough reason to start banning it.
> 
> Thoughts?

On second thoughts, knowing that many users have put sunit/swidth in
their fstab, we probably shouldn't make it return an error as that
may make their systems unbootable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
