Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9140CC3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 14:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6079E2133F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 14:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfHPOaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:30:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727245AbfHPOaw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Aug 2019 10:30:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA8D3C009DCC;
        Fri, 16 Aug 2019 14:30:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C685C44F88;
        Fri, 16 Aug 2019 14:30:50 +0000 (UTC)
Date:   Fri, 16 Aug 2019 10:30:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190816143048.GA54929@bfoster>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190813133614.GD37069@bfoster>
 <20190815231001.GT6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815231001.GT6129@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 16 Aug 2019 14:30:51 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 09:10:01AM +1000, Dave Chinner wrote:
> On Tue, Aug 13, 2019 at 09:36:14AM -0400, Brian Foster wrote:
> > On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
> > > When performing rename operation with RENAME_WHITEOUT flag, we will
> > > hold AGF lock to allocate or free extents in manipulating the dirents
> > > firstly, and then doing the xfs_iunlink_remove() call last to hold
> > > AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> > > 
> > 
> > IIUC, the whiteout use case is that we're renaming a file, but the
> > source dentry must be replaced with a magic whiteout inode rather than
> > be removed. Therefore, xfs_rename() allocates the whiteout inode as a
> > tmpfile first in a separate transaction, updates the target dentry with
> > the source inode, replaces the source dentry to point to the whiteout
> > inode and finally removes the whiteout inode from the unlinked list
> > (since it is a tmpfile). This leads to the problem described below
> > because the rename transaction ends up doing directory block allocs
> > (locking the AGF) followed by the unlinked list remove (locking the
> > AGI).
> > 
> > My understanding from reading the code is that this is primarly to
> > cleanly handle error scenarios. If anything fails after we've allocated
> > the whiteout tmpfile, it's simply left on the unlinked list and so the
> > filesystem remains in a consistent/recoverable state. Given that, the
> > solution here seems like overkill to me. For one, I thought background
> > unlinked list removal was already on our roadmap (Darrick might have
> > been looking at that and may already have a prototype as well). Also,
> > unlinked list removal occurs at log recovery time already. That's
> > somewhat of an existing purpose of the list, which makes a deferred
> > unlinked list removal operation superfluous in more traditional cases
> > where unlinked list removal doesn't require consistency with a directory
> > operation.
> > 
> > Functional discussion aside.. from a complexity standpoint I'm wondering
> > if we could do something much more simple like acquire the AGI lock for
> > a whiteout inode earlier in xfs_rename(). For example, suppose we did
> > something like:
> > 
> > 	/*
> > 	 * Acquire the whiteout agi to preserve locking order in anticipation of
> > 	 * unlinked list removal.
> > 	 */
> > 	if (wip)
> > 		xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, wip->i_ino), &agibp);
> > 
> > ... after we allocate the transaction but before we do any directory ops
> > that can result in block allocations. Would that prevent the problem
> > you've observed?
> 
> I'd prefer that we just do things in an order that doesn't invert
> the locking. For a whiteout, we only allocate blocks when modifying
> the target directory, and we do a check to see if that will succeed
> before actually doing the directory modification. That means the
> directory modification will only fail due to an IO error or
> corruption, both of which have a high probability of causing the
> filesystem to be shut down. Any error after the directory mod will
> cause a shutdown because the transaction is dirty.
> 
> Further, the operation that will lock the AGF is the target
> directory modification if blocks need to be allocated, and the whole
> point of the "check before execution" is to abort if ENOSPC would
> occur as a result of trying to allocate blocks and we don't have a
> space reservation for for those blocks because we are very, very
> close to ENOSPC already.
> 
> If we fail the xfs_iunlink_remove() operation, we're shutting down
> the filesystem. If we fail the xfs_dir_createname(target) call, we
> are most likely going to be shutting down the filesystem. So the
> premise that locating xfs_iunlink_remove() at the end to make error
> handling easy is not really true - transaction cancel will clean
> both of them up and shut the filesystem down.
> 

Yeah, though I guess it depends on whether it's considered correct to
leave out the error handling. In this case, it sounds like you'd prefer
to do that since we can infer the transaction is dirty and so the
filesystem is shutting down anyways. That sounds reasonable to me given
the quirky circumstances of this particular operation, provided we don't
leave anything around in too bogus of a state to cause problems even
with a shut down fs (which I don't think would be the case, but it
should be tested).

> Hence I think the right thing to do is to move the
> xfs_iunlink_remove() call to between xfs_dir_canenter() and
> xfs_dir_createname(). This means ENOSPC will abort with a clean
> transaction and all is good, otherwise a failure is most likely
> going to shut down the filesystem and it doesn't matter if we do
> xfs_iunlink_remove() or xfs_dir_createname() first.
> 

Note that the canenter() call is currently only used in the target_ip ==
NULL case (and only if we couldn't get a block res). Perhaps we don't
care about the AGF lock in the other case, but we still need to fix up
the whiteout tmpfile for both. For the target_ip != NULL case, we'd want
to make sure we handle things like the -EEXIST error check in there
right now before we dirty the transaction with a whiteout inode tweak so
an invalid request from userspace doesn't shutdown the fs.

Those nits aside, I think the iunlink_remove()/bumplink() combination is
going to always dirty the transaction and so guarantee a cancel after
that point shuts down the fs.

> And by doing xfs_iunlink_remove() first, we remove the AGI/AGF
> lock inversion problem....
> 
> I think this holds together, but I might have missed something in
> the tangle of different rename operation cases. So it's worth
> checking, but it looks to me like a better solution than having
> a bare AGI lock in the middle of the function to work around error
> handling logic we didn't clearly enough about at the time (hindsight
> and all that jazz)....
> 
> Thoughts?
> 

If we explicitly ignore error handling as such because shutdown cleans
up the mess, then I'd just like to make sure we have some combination of
asserts and/or comments to verify that remains the case for future
changes. Otherwise somebody could insert a transaction roll or something
a couple years down the line and introduce a corruption vector that none
of us remember. With that angle covered, the approach sounds reasonable
to me.

I have no terribly strong preference between the three alternative
options discussed so far. Refactoring the dir code would be a bit more
work in the way of fixing a bug, which is fine, but if we want/need a
backportable fix it might be better to consider that a follow up fix up
after taking one of the other two approaches to address the lock order
issue.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
