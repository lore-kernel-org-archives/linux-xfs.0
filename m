Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42905 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752078AbcK3Wyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 17:54:50 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cCDm1-0005Xm-Uw
        for linux-xfs@vger.kernel.org; Thu, 01 Dec 2016 09:54:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cCDm1-0004Au-Ta
        for linux-xfs@vger.kernel.org; Thu, 01 Dec 2016 09:54:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/2] xfs: deprecate barrier/nobarrier
Date: Thu,  1 Dec 2016 09:54:42 +1100
Message-Id: <20161130225444.15869-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

In response to the recent conversation here:

https://www.spinics.net/lists/linux-xfs/msg02501.html

I've come to the conclusion that barrier/nobarrier mount options no
longer make sense to maintain. There is no performance penalty for
the vast majority of users to enabling barriersand it's been the
default behaviour for a long time. And given the misunderstanding
that users have over what barriers are and when it is safe to turn
them off, it seems to me like the best solution is to simply
remove the option altogther.

Comments, thoughts, flames all welcome.

-Dave.

