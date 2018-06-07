Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:3932 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752967AbeFGFXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 01:23:49 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQnMd-0004sW-2X
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:21:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQnMc-0001fG-VP
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:21:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix a couple of potential deadlocks
Date: Thu,  7 Jun 2018 15:21:30 +1000
Message-Id: <20180607052132.6207-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

These are a couple of small fixes for lockdep enabled kernels. The
first changes the initialisation of the i_rwsem lockdep state
in the XFS code instead of in unlock_new_inode() to avoid lockdep
re-initialising the lock state after it can be found in the cache
and may have other processes waiting on the lock.

The second is adding the correct memory allocation context to
xfs_reflink_convert_cow() as it gets called in the IO path where we
hold pages locked for IO and so we can't recurse back into memory
reclaim.

Cheers,

Dave.

