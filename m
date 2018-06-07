Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11803 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752565AbeFGF14 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 01:27:56 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQnSj-0004tM-Pi
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:27:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQnSj-0001qF-Ng
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:27:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: minor cleanups
Date: Thu,  7 Jun 2018 15:27:48 +1000
Message-Id: <20180607052751.6541-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

These patches are minor cleanups that do not change the behaviour
of the code. The first two replace abstractions
that have outlived their usefulness with linux kernel native
primitives. It's been tested on both 32 and 64 bit platforms.

The last patch moves all the new(-ish) type verifiers to a common
file in libxfs - this means they are easy to find and we have a
central place for adding future type verifiers.

Cheers,

Dave.

