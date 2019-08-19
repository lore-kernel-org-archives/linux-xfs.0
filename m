Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F22C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 22:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC6F3214DA
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 22:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfHSWNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 18:13:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60899 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728136AbfHSWNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 18:13:18 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4754F362403;
        Tue, 20 Aug 2019 08:13:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzpse-0000TD-Pg; Tue, 20 Aug 2019 08:12:00 +1000
Date:   Tue, 20 Aug 2019 08:12:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190819221200.GN7777@dread.disaster.area>
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819151335.GB2875@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=GvQkQWPkAAAA:8 a=7-415B0cAAAA:8 a=-T8trkfYl0IoraWLOdQA:9
        a=cnWfvRXVZBWv-LEO:21 a=pYvbPafPTobBl9iG:21 a=CjuIK1q_8ugA:10
        a=IZKFYfNWVLfQsFoIDbx0:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 11:13:35AM -0400, Brian Foster wrote:
> On Mon, Aug 19, 2019 at 09:06:39PM +0800, kaixuxia wrote:
> > When performing rename operation with RENAME_WHITEOUT flag, we will
> > hold AGF lock to allocate or free extents in manipulating the dirents
> > firstly, and then doing the xfs_iunlink_remove() call last to hold
> > AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> > 
> > The big problem here is that we have an ordering constraint on AGF
> > and AGI locking - inode allocation locks the AGI, then can allocate
> > a new extent for new inodes, locking the AGF after the AGI. Hence
> > the ordering that is imposed by other parts of the code is AGI before
> > AGF. So we get the ABBA agi&agf deadlock here.
> > 
> ...
> > 
> > In this patch we move the xfs_iunlink_remove() call to between
> > xfs_dir_canenter() and xfs_dir_createname(). By doing xfs_iunlink
> > _remove() firstly, we remove the AGI/AGF lock inversion problem.
> > 
> > Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> > ---
> >  fs/xfs/xfs_inode.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 6467d5e..48691f2 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3294,6 +3294,18 @@ struct xfs_iunlink {
> >  			if (error)
> >  				goto out_trans_cancel;
> >  		}
> > +
> > +		/*
> > +		 * Handle the whiteout inode and acquire the AGI lock, so
> > +		 * fix the AGI/AGF lock inversion problem.
> > +		 */
> 
> The comment could be a little more specific. For example:
> 
> "Directory entry creation may acquire the AGF. Remove the whiteout from
> the unlinked list first to preserve correct AGI/AGF locking order."
> 
> > +		if (wip) {
> > +			ASSERT(VFS_I(wip)->i_nlink == 0);
> > +			error = xfs_iunlink_remove(tp, wip);
> > +			if (error)
> > +				goto out_trans_cancel;
> > +		}
> > +
> >  		/*
> >  		 * If target does not exist and the rename crosses
> >  		 * directories, adjust the target directory link count
> > @@ -3428,9 +3440,11 @@ struct xfs_iunlink {
> >  	if (wip) {
> >  		ASSERT(VFS_I(wip)->i_nlink == 0);
> >  		xfs_bumplink(tp, wip);
> > -		error = xfs_iunlink_remove(tp, wip);
> > -		if (error)
> > -			goto out_trans_cancel;
> > +		if (target_ip != NULL) {
> > +			error = xfs_iunlink_remove(tp, wip);
> > +			if (error)
> > +				goto out_trans_cancel;
> > +		}
> 
> The comment above this hunk needs to be updated. I'm also not a big fan
> of this factoring of doing the removal in the if branch above and then
> encoding the else logic down here. It might be cleaner and more
> consistent to have a call in each branch of the if/else above.
> 
> FWIW, I'm also curious if this could be cleaned up further by pulling
> the -ENOSPC/-EEXIST checks out of the earlier branch, following that
> with the whiteout removal, and then doing the dir_create/replace. For
> example, something like:
> 
> 	/* error checks before we dirty the transaction */
> 	if (!target_ip && !spaceres) {
> 		error = xfs_dir_canenter();
> 		...
> 	} else if (S_ISDIR() && !(empty || nlink > 2))
> 		error = -EEXIST;
> 		...
> 	}
> 
> 	if (wip) {
> 		...
> 		xfs_iunlink_remove();
> 	}
> 
> 	if (!target_ip) {
> 		xfs_dir_create();
> 		...
> 	} else {
> 		xfs_dir_replace();
> 		...
> 	}
> 
> ... but that may not be any cleaner..? It could also be done as a
> followup cleanup patch as well.

Makes sense, but the more I look at this, the more I think we should
get rid of on-disk whiteout inodes altogether and finally make use
of XFS_DIR3_FT_WHT in the dirent file type.

The whiteout inode is a nasty VFS level hack to support whiteouts on
filesystems that have no way of storing whiteouts natively. i.e. a
whiteout inode is a chardev with a mode of 0 and a device number of
0. We only need to present that magic indoe to userspace, we don't
need to actually store it on disk.  IOWs, we could get rid of this
whole problem with XFS_DIR3_FT_WHT.

XFS_DIR3_FT_WHT means we no longer need to allocate a tmpfile for
the whiteout, we don't have xfs_iunlink_remove calls in rename, and
all we have to do is a xfs_dir_replace() call to zero out the inode
number and change the ftype in the dirent.

It will need changes to the xfs_lookup code to instantiate the
special chardev inode in memory when a whiteout is found, and
probably checks to ensure we never dirty such an inode. Giving it an
invalid inode number will be sufficient to prevent it from being
written to disk.

It's a bit more work, but I think killing on-disk whiteout inode is
the eventual solution we want here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
