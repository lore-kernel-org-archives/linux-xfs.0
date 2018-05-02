Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:28489 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750897AbeEBICE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 04:02:04 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fDmi8-0002Wb-0B
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 18:02:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fDmi7-0003Al-TC
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 18:01:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10] xfs: log item and transaction cleanups
Date: Wed,  2 May 2018 18:01:47 +1000
Message-Id: <20180502080157.11386-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This started out as one patch to get rid of log item descriptors,
then turned into an onion peeling exercise as it uncovered other
problems.

The series converts the log item flags to atomic ops so
they can be updated in different locking contexts safely -
XFS_LI_FAILED introduced a requirement for changing and checking
under the AIL lock, and we don't do that in many places.

This gets worse with the last patch in the series where I get rid of
log item descriptors, which moves the XFS_LI_LOGGED flag out of the
descriptor and into the log item itself, meaning the li_flags field
either needs ti's own lock or is updated atomically. I chose the
latter because we've got enough locks already and the available
atomic operations cover all the atomic logic checks we need.

In doing this, I kept hitting assert failures with the AIL lock
held, leading to unrecoverable hangs and a patch to avoid that.
I found inodes multiply joined to single transactions, so there's
patches to fix that. I needed high level transaction tracing to work
out where stuff was going wrong, so there's a patch for that. I
added some more assert checks to log items to catch wacky cases that
occurred but weren't caught while debugging the code.

So, really, the first and last patches in the series were the only
ones I intended to write - the rest were a result of pre-existing
bugs I found and the code I needed to track them down....

Cheers,

Dave.

