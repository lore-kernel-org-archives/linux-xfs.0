Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527CCC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 04:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243444AbiDLE2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244464AbiDLE2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:28:07 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CB6832992
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:25:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3527053460A;
        Tue, 12 Apr 2022 14:25:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-00Gh2J-Rm; Tue, 12 Apr 2022 14:25:45 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-009NrF-Q9;
        Tue, 12 Apr 2022 14:25:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 00/10] xfs: LARP - clean up xfs_attr_set_iter state machine
Date:   Tue, 12 Apr 2022 14:25:33 +1000
Message-Id: <20220412042543.2234866-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6254ff4b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=-TPetH3yESX3ffJ-qN0A:9
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Allison,

This is first patchset for fixing up stuff in the LARP code. I've
based this on my current 5.19-compose branch here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-5.19-compose

The first patch in the series fixes the splat that occurs in
generic/642 in that merge from the empty, dirty transaction. I
haven't touched the xfs_attri_finish_one() code to remove the
XFS_TRANS_DIRTY there because that code is used for the remove path,
too, and I didn't want to perturb that before I was finished with
the set path.

The rest of the patchset is cleaning up the xfs_attr_set_iter()
state machine. THe use of XFS_DAS_UNINIT is gone - instead I set the
initial state according to the format of the attr fork. Then if we
convert from sf to leaf, or leaf to node, we bump the state to
LEAF_ADD or NODE_ADD and roll the transaction. The next time in it
will perform the appropriate attr addition.

I've then added extra states to handle remote value block allocation
and setting of the value for the leaf blocks. This makes the code
the same as setting the remote value for node blocks, and that then
leads to collapsing all the duplicate code paths.

To do that, I set up the leaf and node states as identical
numerically ascending sequences, allowing state changes to be done
by incrementing the state value from a specific initial condition,
but progressing down the correct sequence of states even though they
are executing the same code path. This initial condition (leaf or
node) is set directly by the LEAF/NODE_ADD states that have already
been separated and set up.

From there, it's really just cleanup - I separated the flipflags
operation into a separate state, so when larp is enabled it just
skips straight over it. I renamed the states to describe the
high level operation it is performing rather than the mechanics of
the modification it is making. Like the remote val block alloc, I
enabled it to skip over the remote attr states on remove if it isn't
a remote attr.

I factored the code a bit more, cleaning up the final leaf/node
states to look the same from the perspective of the state machine.

I then made sure that the state machine has a termination state -
XFS_DAS_DONE - so taht callers can determine whether the operation
is complete without requiring xfs_attr_set_iter() to return -EAGAIN
to tell the caller it needs to keep iterating. This allows removal
of most of the -EAGAIN returns and conditional logic in the
xfs_attr_set_iter() implementation and leaf functions. This means
that requirement of the deferop transaction rolling API (return
-EAGAIN) is contained entirely within xfs_attri_finish_one() instead
of bleeding through to xfs_attr_set_iter().

Overall, I find the state machine code much easier to read and
follow because it largely separates the implementation of individual
states from the execution of the state machine. The states are
smaller and easier to understate, too.

What I haven't done yet is update the big flowchart in xfs_attr.h.
Much of it is now stale and it doesn't match the new states or
progression through the states. I'm wondering if there's a better
way to document the state machine than a comment that will get
rapidly out of date, even though that comment was very helpful in
working out how to re-write the state machine cleanly....

I plan to make the same structural mods to xfs_attr_remove_iter(),
and then I can clean up xfs_attri_finish_one() and get rid of the
XFS_TRANS_DIRTY in that code.

The diffstat isn't too bad - it doesn't make the code smaller
overall because I split a lot of stuff out into smaller functions,
but it doesn't get bigger, either, and I think the result is much
more readable and maintainable.

 fs/xfs/libxfs/xfs_attr.c | 586 ++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr.h |  60 +++-
 fs/xfs/xfs_attr_item.c   |   2 +
 fs/xfs/xfs_trace.h       |  26 +-
 4 files changed, 345 insertions(+), 329 deletions(-)

The patchset passes fstests '-g attr' running in a loop when larp=0,
but I haven't tested it with larp=1 yet - I've done zero larp=1
testing so far so I don't even know whether it works in the base
5.19 compose yet. I'll look at that when I finish the state machine
updates....

Thoughts?

Cheers,

Dave.


