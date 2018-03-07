Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41716 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750989AbeCGJK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 04:10:26 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1etV5b-0000q4-6C
        for linux-xfs@vger.kernel.org; Wed, 07 Mar 2018 20:10:23 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1etV5b-0001eP-2Q
        for linux-xfs@vger.kernel.org; Wed, 07 Mar 2018 20:10:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix transaction joining problems.
Date: Wed,  7 Mar 2018 20:10:18 +1100
Message-Id: <20180307091020.6186-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

I found these when tracking down a hang in some new code I wrote
this afternoon. Joining a log item mulitple times to the same
transaction violates the relationship assumptions between
transactions and log items. It broke the code I wrote this afternoon
so subtly it took me several hours to track this down....

I don't know of any issues that can be attributed to these bugs, but
it's incorrect behaviour that needs fixing.

Cheers,

Dave.

