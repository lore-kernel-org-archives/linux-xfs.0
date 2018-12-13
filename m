Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbeLMXqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 18:46:54 -0500
Date: Thu, 13 Dec 2018 15:46:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't skip rtmount when there's a realtime device
Message-ID: <20181213234651.GE24487@magnolia>
References: <20181213012436.GB24487@magnolia>
 <d33a0150-e412-5089-5c60-333b3d9ae9a1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33a0150-e412-5089-5c60-333b3d9ae9a1@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 13, 2018 at 03:29:54PM -0600, Eric Sandeen wrote:
> 
> 
> On 12/12/18 7:24 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Don't ever skip the realtime bitmap / summary inode initialization if
> > there's a realtime device attached, because we'd rather fail the mount
> > if iget declines to retrieve a NULL inode pointer.  Right now, if
> > someone sets rbmino to NULLFSINO on a rt-capable filesystem, mounts it,
> > and writes a file to the rt device, we'll blow up.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_rtalloc.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index aefd63d46397..18ad31ded0bf 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -1206,7 +1206,8 @@ xfs_rtmount_inodes(
> >  	xfs_sb_t	*sbp;
> >  
> >  	sbp = &mp->m_sb;
> > -	if (sbp->sb_rbmino == NULLFSINO)
> > +	if (!xfs_sb_version_hasrealtime(&mp->m_sb) &&
> > +	    sbp->sb_rbmino == NULLFSINO)
> >  		return 0;
> >  	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
> >  	if (error)
> > 
> 
> Seems fine as far as it goes, but now we have this weird situation where for
> a filesystem without the realtime feature, we'll just skip this part and
> mount if sb_rbmino is NULL, but if sb_rsumino is NULL, we'll fail the iget
> and fail the mount.
> 
> So while there's noting really wrong with the fix, it seems like it could all
> be made a bit more consistent while you're here.  (classic move by me!) ;)

Hmm.  Well if there /aren't supposed/ to be any XFSes out there with
garbage/null realtime bitmap / summary inodes, then I'm happy to get rid
of the "if (sbp->sb_rbmino == NULLFSINO) return 0;" logic.  The current
logic is sorta weird, but I don't know if that was a deliberate design
decision or just a logic bug that needs to go away.

Though now that I see that we can indeed add a realtime section to a
filesystem that didn't previously have one, I guess I should go look at
the rtrmapbt growfs code a little more closely.

--D

> -Eric
