Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12843 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751119AbeBAGmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 01:42:07 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eh8ZQ-0005Cm-Vc
        for linux-xfs@vger.kernel.org; Thu, 01 Feb 2018 17:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90)
        (envelope-from <david@fromorbit.com>)
        id 1eh8ZQ-00024H-TC
        for linux-xfs@vger.kernel.org; Thu, 01 Feb 2018 17:42:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] xfs: refactor and tablise growfs
Date: Thu,  1 Feb 2018 17:41:55 +1100
Message-Id: <20180201064202.7174-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This is a series I posted months ago with the first thinspace
filesystem support. There was no comments on any of these patches
because all the heat and light got focussed on the growfs API.
I'm posting this separately to avoid that problem again....

Anyway, the core of this change is to make the growfs code much
simpler to extend. Most of the code that does structure
initialisation is cookie-cutter code and it's whacked into one great
big function. This patch set splits it up into separate functions
and uses common helper functions where possible. The different
structures and their initialisation definitions are now held in a
table, so when we add new stuctures or modify existing structures
it's a simple and isolate change.

The reworked initialisation code is suitable for moving to libxfs
and converting mkfs.xfs to use it for the initial formatting of
the filesystem. This will take more work to acheive, so this
patch set stops short of moving the code to libxfs.

The other changes to the growfs code in this patchset also isolate
separate parts of the growfs functionality, such as updating the
secondary superblocks and changing imaxpct. This makes adding
thinspace functionality to growfs much easier.

Finally, there are optimisations to make a large AG count growfs
much faster. Instead of initialising and writing headers one at a
time synchronously, they are added to a delwri buffer list and
written in bulk and asynchronously. This means AG headers get merged
by the block layer and it can reduce the IO wait time by an order of
magnitude or more.

There are also mods to the secondary superblock update algorithm
which make it more resilient in the face of writeback failures. We
use a two pass update now - the main growfs loop now initialised
secondary superblocks with sb_inprogess = 1 to indicate it is not
in a valid state before we make any modifications, then after teh
transactional grow we do a second pass to set sb_inprogess = 0 and
mark them valid.

This means that if we fail to write any secondary superblock, repair
is not going to get confused by partial grow state. If we crash
during the initial write, nothing has changed in the primary
superblock. If we crash after the primary sb grow, then we'll know
exactly what secondary superblocks did not get updated because
they'll be the ones with sb_inprogress = 1 in them. Hence the
recovery process becomes much easier as the parts of the fs that
need updating are obvious....

Cheers,

Dave.

