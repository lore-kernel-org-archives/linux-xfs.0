Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58388 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750926AbeEBFvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 01:51:51 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fDkg6-0002O3-84
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 15:51:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fDkg6-0007Wt-6l
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 15:51:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: clean up xfs_file_iomap_begin()
Date: Wed,  2 May 2018 15:51:42 +1000
Message-Id: <20180502055144.28851-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

These patches follow up on recent changes to the locking and
non-blocking behaviour of xfs_file_iomap_begin() to make it easier
to follow and understand. The code is a bit of a tangle right now,
and these two patches pull all of the locking and NOWAIT decisions
into a single function and out of all the mapping code.

There are no functional changes here, just a code re-org.

Cheers,

Dave.

