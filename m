Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1F2CDB483
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 21:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbjJKVlJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 17:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbjJKVlI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 17:41:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B68D9E
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 14:41:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED21C433CB;
        Wed, 11 Oct 2023 21:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697060466;
        bh=5BBqupNfqqIah1gt9fuBYJBOB+uI9sdlGO9WITyMMsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=up3epMrQashX1wbh0+KquqGhPZ0lIYMT0QSk79bI+Y1QYcDK5Jrgr7jSOIvNlEA9l
         Xr01xKnF3D6j3SftnXYz9ehdFOotxyc7DN7sQNAiu2e1S6k93+TDKH2xHZd4XqswCx
         wH+gu10pA+dKqs/c3a9+QDk48YokdkaQyDGOvM9s/Bu/vL97CSkurUyp/RQ5d4clp0
         YqJhx6A7IlUtG6T030lbZbWfYehTVi/Znp5Q35BjvBWvffnN7ii5KSpofE6i4V7lvf
         4mFdDceVVXzgXgZ8diP5sxA3jcbemrPDv3agVZA9FXcFS1oDn4/WPwCPz3Hn1Ee79g
         OYpnQnUYZ3o5w==
Date:   Wed, 11 Oct 2023 14:41:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, cheng.lin130@zte.com.cn,
        linux-xfs@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: pin inodes that would otherwise overflow link count
Message-ID: <20231011214105.GA21298@frogsfrogsfrogs>
References: <20231011203350.GY21298@frogsfrogsfrogs>
 <ZScOxEP5V/fQNDW8@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZScOxEP5V/fQNDW8@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:08:20AM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2023 at 01:33:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The VFS inc_nlink function does not explicitly check for integer
> > overflows in the i_nlink field.  Instead, it checks the link count
> > against s_max_links in the vfs_{link,create,rename} functions.  XFS
> > sets the maximum link count to 2.1 billion, so integer overflows should
> > not be a problem.
> > 
> > However.  It's possible that online repair could find that a file has
> > more than four billion links, particularly if the link count got
> 
> I don't think we should be attempting to fix that online - if we've
> really found an inode with 4 billion links then something else has
> gone wrong during repair because we shouldn't get there in the first
> place.

I don't agree -- if online repair really does find 3 billion dirents
pointing to a (very) hardlinked file, then it should set the link count
to 3 billion.  The VFS will not let userspace add more hardlinks, but it
will let userspace remove hardlinks.

> IOWs, we should be preventing a link count overflow at the time 
> that the link count is being added and returning -EMLINK errors to
> that operation. This prevents overflow, and so if repair does find
> more than 2.1 billion links to the inode, there's clearly something
> else very wrong (either in repair or a bug in the filesystem that
> has leaked many, many link counts).
> 
> huh.
> 
> We set sb->s_max_links = XFS_MAXLINKS, but nowhere does the VFS
> enforce that, nor does any XFS code. The lack of checking or
> enforcement of filesystem max link count anywhere is ... not ideal.

[Which the VFS does, so I'll set aside the last 2 paragraphs.]

> Regardless, I don't think fixing nlink overflow cases should be done
> online. A couple of billion links to a single inode takes a
> *long* time to create and even longer to validate (and take a -lot-
> of memory).

xfs_repair will burn a lot of memory and time doing that; xfs_scrub will
take just as much time but only O(icount) memory.

> Hence I think we should just punt "more than 2.1
> billion links" to the offline repair, because online repair can't do
> anything to actually find whatever caused the overflow in the
> first place, nor can it actually fix it - it should never have
> happened in the first place....

I don't think deleting dirents to reduce link count is a good idea,
since the repair tool will have no idea which directory links are more
deletable than others.

If repair finds XFS_MAXLINKS < nr_dirents < -1U, then I think we should
reset the link count and let userspace decide if they're going to unlink
the file to reduce the link count.  That's already what xfs_repair does,
and xfs_scrub follows that behavior.

For nr_dirents > -1U, online repair just skips the file and reports that
repairs didn't succeed.  xfs_repair overflows the u32 and won't notice
that it's now set the link count to something suspiciously low.

For nr_dirents <= XFS_MAXLINKS, both repair tools reset the link count,
end of story.

(This patch comes at the end of online nlink repair, so a lot of this
nuance would be a lot easier to spot.  I was originally going to leave
this patch until we got to that part of online repair, but then this
other thing came in and I felt it important to get it on the list, even
at a price of incohesion.  Oh well.)

> > corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
> > not large enough to store a value larger than 2^32, so we ought to
> > define a magic pin value of ~0U which means that the inode never gets
> > deleted.  This will prevent a UAF error if the repair finds this
> > situation and users begin deleting links to the file.
> 
> I think that's fine as a defence against implementation bugs, but I
> don't think that it really makes any real difference to the "repair
> might find an overflow" case...

Fair enough.

--D

> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |    6 ++++++
> >  fs/xfs/scrub/nlinks.c      |    8 ++++----
> >  fs/xfs/scrub/repair.c      |   12 ++++++------
> >  fs/xfs/xfs_inode.c         |   28 +++++++++++++++++++++++-----
> >  4 files changed, 39 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 6409dd22530f2..320522b887bb3 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -896,6 +896,12 @@ static inline uint xfs_dinode_size(int version)
> >   */
> >  #define	XFS_MAXLINK		((1U << 31) - 1U)
> >  
> > +/*
> > + * Any file that hits the maximum ondisk link count should be pinned to avoid
> > + * a use-after-free situation.
> > + */
> > +#define XFS_NLINK_PINNED	(~0U)
> > +
> >  /*
> >   * Values for di_format
> >   *
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 4db2c2a6538d6..30604e11182c4 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -910,15 +910,25 @@ xfs_init_new_inode(
> >   */
> >  static int			/* error */
> >  xfs_droplink(
> > -	xfs_trans_t *tp,
> > -	xfs_inode_t *ip)
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip)
> >  {
> > +	struct inode		*inode = VFS_I(ip);
> > +
> >  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> >  
> > -	drop_nlink(VFS_I(ip));
> > +	if (inode->i_nlink == 0) {
> > +		xfs_info_ratelimited(tp->t_mountp,
> > + "Inode 0x%llx link count dropped below zero.  Pinning link count.",
> > +				ip->i_ino);
> > +		set_nlink(inode, XFS_NLINK_PINNED);
> > +	}
> > +	if (inode->i_nlink != XFS_NLINK_PINNED)
> > +		drop_nlink(inode);
> > +
> >  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
> I think the di_nlink field now needs to be checked by verifiers to
> ensure the value is in the range of:
> 
> 	(0 <= di_nlink <= XFS_MAXLINKS || di_nlink == XFS_NLINK_PINNED)
> 
> And we need to ensure that in xfs_bumplink() - or earlier (top avoid
> dirty xaction cancle shutdowns) - that adding a count to di_nlink is
> not going to exceed XFS_MAXLINKS....

I think the VFS needs to check that unlinking a nondirectory won't
underflow its link count, and that rmdiring an (empty) subdirectory
won't underflow the link counts of the parent or child.

Cheng Lin, would you please fix all the filesystems at once instead of
just XFS?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
