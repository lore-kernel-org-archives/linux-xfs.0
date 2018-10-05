Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:25268
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbeJEIUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 04:20:01 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g8EqA-0002u7-EA
        for linux-xfs@vger.kernel.org; Fri, 05 Oct 2018 11:23:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1g8EqA-0000OT-Ad
        for linux-xfs@vger.kernel.org; Fri, 05 Oct 2018 11:23:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix another couple of reflink data corruptions
Date: Fri,  5 Oct 2018 11:23:34 +1000
Message-Id: <20181005012336.1418-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

These are the fixes needed to avoid having dedupe and reflink expose
stale data due to sharing unitialised post EOF data from the source
file inside the destination file's EOF.

Cheers,

Dave.
