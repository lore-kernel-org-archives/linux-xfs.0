Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27719 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752868AbeFRF5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 01:57:15 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fUnA9-0003hd-7F
        for linux-xfs@vger.kernel.org; Mon, 18 Jun 2018 15:57:13 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fUnA9-0006F1-3o
        for linux-xfs@vger.kernel.org; Mon, 18 Jun 2018 15:57:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: symlink and inode writeback issues
Date: Mon, 18 Jun 2018 15:57:09 +1000
Message-Id: <20180618055711.23391-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

The first patch is the replacement fix for the symlink verification
problem I originally posted as "xfs: symlinks can be zero length
during log recovery" a few days ago. This caused the symlink data
fork verifier to fire during inode writeback, and in tracking that
down it became clear that zero length symlinks are not valid,
despite repeated comments in the code that "they can happen". This
new patch prevents zero length symlink inodes from ever getting to
disk, and prevents transient states in memory where the symlink data
fork is zero length.

The second patch is a fix for a problem discovered by the original
symlink verifier patch - when it fired in inode writeback it would
do a double flush lock release on the inode, triggering an assert.
nothing good can come from that, so I tracked down the dark, dusty
origins of the crappy error handling in the inode writeback code and
fixed it, too.

Comments, thoughts?

Cheers,

Dave.

