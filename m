Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF76FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241980AbiDNJsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242247AbiDNJsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:13 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94473762B2
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6E34553455D
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00HZK2-OH
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00AWz9-N5
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/10 v2] xfs: LARP - clean up xfs_attr_set_iter state machine
Date:   Thu, 14 Apr 2022 19:44:18 +1000
Message-Id: <20220414094434.2508781-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6257ed05
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=VWgHvKGuAOUmhVC8unIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

Version 2 is here and working better. The first 11 patches are
largely the same as the first version, just we a couple of bugs
fixes which caused a couple patches to be reworked to fix conflicts.
These patches set up the xfs_attr_set_iter() state machine to be
more readable and maintainable. It largely jsut worked with LARP=0,
but failed on the first recovery when LARP was enabled.

I realised that recovery wasn't setting the initial state properly,
and then started digging into the recovery code. At this point, I
realised the recovery code didn't work correctly in all cases and
could often leave unremovable incomplete attrs sitting around. The
issues are larger documented ini patch 16 so I won't go over them
here, just read that patch.

However, to get, the whole replace operation for LARP=1 needed to
change. Luckily, that turned out to be pretty simple because it was
largely already broken down into component operations in the state
machine. hence I just needed to add new "remove" initial states to
the set_iter state machine, and that allowed the new algorithm to
function.

Then I realised that I'd just implemented the remove_iter algorithm
in the set_iter state machine, so I removed the remove_iter code and
it's states altogether and just pointed remove ops at the set-iter
remove initial states. The code now uses the XFS_DA_OP_RENAME flag
to determine if it should follow up an add or remove with a remove
or add, and it all largely jsut works. All runtime algorithms run
throught he same state machine just with different initial states
and state progressions.

And with patch 16, attr item log recovery uses that same state
machine, too. It has a few quirks that need to be handled, so I
added the XFS_DA_OP_RECOVERY flag to allow the right thing to be
done with the INCOMPLETE flag deep in the guts of the attr lookup
code. And so recovery with LARP=1 now seems to mostly work.

The current state is that larp=0 seems to pass attr group and
recoverloop group testing just fine. My current build is about 10
loops in without a failure. With larp=1, attr group passes jsut
fine, but I'm getting random recovery failures with recoveryloop
testing that aren't immediately obvious as being attribute intent
recvoery failures.  (e.g. things like unlinked inode recovery
finding inodes on the unlinked list that have nlink != 0). Hence
while it mostly works, I'm sure there are still some bugs lurking
there.

There's also a fair bit of cleanup needed of the last couple of
patches. There's some quirks in the state change code when
completing an op and determining whether we need to run the second
half of a replace op that need cleaning up, and the last patch needs
further splitting up and it changes stuff all over the place.

However, if you want to get an idea of what the code looks like,
see if it runs and breaks on your machines and maybe find some bugs
in it, help is welcome!

Cheers,

Dave.


