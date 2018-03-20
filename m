Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32205 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751394AbeCTFA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 01:00:27 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1ey9Nm-0001tH-Ez
        for linux-xfs@vger.kernel.org; Tue, 20 Mar 2018 16:00:22 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1ey9Nm-0000JA-Do
        for linux-xfs@vger.kernel.org; Tue, 20 Mar 2018 16:00:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix mount vs shrinker race
Date: Tue, 20 Mar 2018 16:00:19 +1100
Message-Id: <20180320050021.982-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

These two patches exercise and fix a mount vs shrinker race that can
result in an oops. The first patch adds a delay after sufficient
superblock state has been set up to allow the VFS superblock
shrinker to run, but not enough XFS state for the shrinker to run
without crashing. The second patch fixes the problem.

Thoughts, comments?

Cheers,

Dave.
