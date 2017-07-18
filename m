Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751430AbdGRSXK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Jul 2017 14:23:10 -0400
Date: Tue, 18 Jul 2017 14:23:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: fix buffer check for primary sb in userspace
 libxfs
Message-ID: <20170718182308.GA3886@bfoster.bfoster>
References: <20170718141337.46255-1-bfoster@redhat.com>
 <20170718181041.GI4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718181041.GI4224@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 11:10:41AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 18, 2017 at 10:13:37AM -0400, Brian Foster wrote:
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > This patch is actually targeted at userspace. The previous change in commit
> > f3d7ebde ("xfs: fix superblock inprogress check") to use ->b_maps technically
> > breaks the logic in userspace in a similar way to the original problem because
> > userspace has no concept of uncached buffers.  ->b_maps is NULL in userspace
> > unless the buffer is truly discontiguous.
> > 
> > This would normally result in a segfault but this appears to be hidden
> > by gcc optimization as -O2 is enabled by default and the
> > check_inprogress param to xfs_mount_validate_sb() is unused in
> > userspace. Therefore, the segfault is only reproducible when
> > optimization is disabled (which is a useful configuration for
> > debugging).
> > 
> > There are obviously different ways to fix this. I'm floating this (untested)
> > rfc as a kernel patch (do we ever sync libxfs from xfsprogs -> kernel?) with
> > the objective of keeping the libxfs code the same between the kernel and
> > userspace. We could alternatively create a custom helper/macro with the
> > appropriate check in each place. Thoughts?
> 
> Eww, macros. :)
> 
> > Brian
> > 
> >  fs/xfs/libxfs/xfs_sb.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 9b5aae2..ec2fd03 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -583,6 +583,7 @@ xfs_sb_verify(
> >  {
> >  	struct xfs_mount *mp = bp->b_target->bt_mount;
> >  	struct xfs_sb	sb;
> > +	bool		primary_sb;
> >  
> >  	/*
> >  	 * Use call variant which doesn't convert quota flags from disk 
> > @@ -592,11 +593,14 @@ xfs_sb_verify(
> >  
> >  	/*
> >  	 * Only check the in progress field for the primary superblock as
> > -	 * mkfs.xfs doesn't clear it from secondary superblocks.
> > +	 * mkfs.xfs doesn't clear it from secondary superblocks. Note that
> > +	 * userspace libxfs does not have uncached buffers and so b_maps is not
> > +	 * used for the sb buffer.
> >  	 */
> > -	return xfs_mount_validate_sb(mp, &sb,
> > -				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
> > -				     check_version);
> 
> /me wonders if it'd be appropriate to:
> 
> ASSERT(bp->b_maps != NULL || bp->b_bn != XFS_BUF_DADDR_NULL);
> 
> here to confirm that uncached buffers are working the way we think
> they're supposed to.
> 

Sure, I think we can add something like that.

> Otherwise it looks ok.
> 

Thanks.

And after some discussion on irc with Darrick and Eric, the next version
will target xfsprogs/libxfs as that is where the fix is primarily needed
(with the expectation that this will eventually sync from xfsprogs ->
kernel).

Brian

> --D
> 
> > +	primary_sb = (bp->b_bn == XFS_BUF_DADDR_NULL &&
> > +		      bp->b_maps[0].bm_bn == XFS_SB_DADDR) ||
> > +		     bp->b_bn == XFS_SB_DADDR;
> > +	return xfs_mount_validate_sb(mp, &sb, primary_sb, check_version);
> >  }
> >  
> >  /*
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
