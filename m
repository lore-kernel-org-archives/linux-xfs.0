Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689E9C3A589
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 23:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F379206C1
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 23:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387638AbfHOXLM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 19:11:12 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42521 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387636AbfHOXLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 19:11:12 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E2C65361549;
        Fri, 16 Aug 2019 09:11:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hyOsb-0007D2-9n; Fri, 16 Aug 2019 09:10:01 +1000
Date:   Fri, 16 Aug 2019 09:10:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190815231001.GT6129@dread.disaster.area>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190813133614.GD37069@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813133614.GD37069@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=CEwfdLhW7z1ea22tQaQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 09:36:14AM -0400, Brian Foster wrote:
> On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
> > When performing rename operation with RENAME_WHITEOUT flag, we will
> > hold AGF lock to allocate or free extents in manipulating the dirents
> > firstly, and then doing the xfs_iunlink_remove() call last to hold
> > AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> > 
> 
> IIUC, the whiteout use case is that we're renaming a file, but the
> source dentry must be replaced with a magic whiteout inode rather than
> be removed. Therefore, xfs_rename() allocates the whiteout inode as a
> tmpfile first in a separate transaction, updates the target dentry with
> the source inode, replaces the source dentry to point to the whiteout
> inode and finally removes the whiteout inode from the unlinked list
> (since it is a tmpfile). This leads to the problem described below
> because the rename transaction ends up doing directory block allocs
> (locking the AGF) followed by the unlinked list remove (locking the
> AGI).
> 
> My understanding from reading the code is that this is primarly to
> cleanly handle error scenarios. If anything fails after we've allocated
> the whiteout tmpfile, it's simply left on the unlinked list and so the
> filesystem remains in a consistent/recoverable state. Given that, the
> solution here seems like overkill to me. For one, I thought background
> unlinked list removal was already on our roadmap (Darrick might have
> been looking at that and may already have a prototype as well). Also,
> unlinked list removal occurs at log recovery time already. That's
> somewhat of an existing purpose of the list, which makes a deferred
> unlinked list removal operation superfluous in more traditional cases
> where unlinked list removal doesn't require consistency with a directory
> operation.
> 
> Functional discussion aside.. from a complexity standpoint I'm wondering
> if we could do something much more simple like acquire the AGI lock for
> a whiteout inode earlier in xfs_rename(). For example, suppose we did
> something like:
> 
> 	/*
> 	 * Acquire the whiteout agi to preserve locking order in anticipation of
> 	 * unlinked list removal.
> 	 */
> 	if (wip)
> 		xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, wip->i_ino), &agibp);
> 
> ... after we allocate the transaction but before we do any directory ops
> that can result in block allocations. Would that prevent the problem
> you've observed?

I'd prefer that we just do things in an order that doesn't invert
the locking. For a whiteout, we only allocate blocks when modifying
the target directory, and we do a check to see if that will succeed
before actually doing the directory modification. That means the
directory modification will only fail due to an IO error or
corruption, both of which have a high probability of causing the
filesystem to be shut down. Any error after the directory mod will
cause a shutdown because the transaction is dirty.

Further, the operation that will lock the AGF is the target
directory modification if blocks need to be allocated, and the whole
point of the "check before execution" is to abort if ENOSPC would
occur as a result of trying to allocate blocks and we don't have a
space reservation for for those blocks because we are very, very
close to ENOSPC already.

If we fail the xfs_iunlink_remove() operation, we're shutting down
the filesystem. If we fail the xfs_dir_createname(target) call, we
are most likely going to be shutting down the filesystem. So the
premise that locating xfs_iunlink_remove() at the end to make error
handling easy is not really true - transaction cancel will clean
both of them up and shut the filesystem down.

Hence I think the right thing to do is to move the
xfs_iunlink_remove() call to between xfs_dir_canenter() and
xfs_dir_createname(). This means ENOSPC will abort with a clean
transaction and all is good, otherwise a failure is most likely
going to shut down the filesystem and it doesn't matter if we do
xfs_iunlink_remove() or xfs_dir_createname() first.

And by doing xfs_iunlink_remove() first, we remove the AGI/AGF
lock inversion problem....

I think this holds together, but I might have missed something in
the tangle of different rename operation cases. So it's worth
checking, but it looks to me like a better solution than having
a bare AGI lock in the middle of the function to work around error
handling logic we didn't clearly enough about at the time (hindsight
and all that jazz)....

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
