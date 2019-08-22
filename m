Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750BEC3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 06:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9482339F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 06:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfHVGH6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 02:07:58 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:32933 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbfHVGH6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 02:07:58 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 043803618A2;
        Thu, 22 Aug 2019 16:07:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0gFE-0006WY-EM; Thu, 22 Aug 2019 16:06:48 +1000
Date:   Thu, 22 Aug 2019 16:06:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v4] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190822060648.GX1119@dread.disaster.area>
References: <72adde91-556c-8af3-e217-5a658697972e@gmail.com>
 <20190822050143.GV1119@dread.disaster.area>
 <3d6e190f-f88e-ef75-8dc1-9b0958706e38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d6e190f-f88e-ef75-8dc1-9b0958706e38@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=nMmpL3sVLDqE7LTIv2oA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 01:45:48PM +0800, kaixuxia wrote:
> On 2019/8/22 13:01, Dave Chinner wrote:
> > On Thu, Aug 22, 2019 at 12:33:23PM +0800, kaixuxia wrote:
> > 
> >> @@ -3419,25 +3431,15 @@ struct xfs_iunlink {
> >>  
> >>  	/*
> >>  	 * For whiteouts, we need to bump the link count on the whiteout inode.
> > 
> > Shouldn't this line be removed as well?
> 
> Because the xfs_bumplink() call below will do this.

Oh, yeah, I just assumed that from the "we have a real link" part of
the new comment :P

> >> -	 * This means that failures all the way up to this point leave the inode
> >> -	 * on the unlinked list and so cleanup is a simple matter of dropping
> >> -	 * the remaining reference to it. If we fail here after bumping the link
> >> -	 * count, we're shutting down the filesystem so we'll never see the
> >> -	 * intermediate state on disk.
> >> +	 * The whiteout inode has been removed from the unlinked list and log
> >> +	 * recovery will clean up the mess for the failures up to this point.
> >> +	 * After this point we have a real link, clear the tmpfile state flag
> >> +	 * from the inode so it doesn't accidentally get misused in future.
> >>  	 */
> >>  	if (wip) {
> >>  		ASSERT(VFS_I(wip)->i_nlink == 0);
> >>  		xfs_bumplink(tp, wip);
> >> -		error = xfs_iunlink_remove(tp, wip);
> >> -		if (error)
> >> -			goto out_trans_cancel;
> >>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> >> -
> >> -		/*
> >> -		 * Now we have a real link, clear the "I'm a tmpfile" state
> >> -		 * flag from the inode so it doesn't accidentally get misused in
> >> -		 * future.
> >> -		 */
> >>  		VFS_I(wip)->i_state &= ~I_LINKABLE;
> >>  	}
> > 
> > Why not move all this up into the same branch that removes the
> > whiteout from the unlinked list? Why separate this logic as none of
> > what is left here could cause a failure even if it is run earlier?
> 
> Yep, it could not cause a failure if we move all this into the same
> branch that xfs_iunlink_remove() call. We move the xfs_iunlink_remove()
> first to preserve correct AGI/AGF locking order, and maybe it is better
> we bump the link count after using the whiteout inode really, such as
> xfs_dir_replace(...,wip,...) ...

It makes no difference where we bump the link count as long as we do
it after the xfs_iunlink_remove() call. At that point, any failure
will result in a shutdown and so it doesn't matter that we've
already bumped the link count because the shutdown with prevent
it from reaching the disk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
