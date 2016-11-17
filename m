Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34021 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752338AbcKQX5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 18:57:03 -0500
Received: from disappointment.disaster.area ([192.168.1.110] helo=disappointment)
        by dastard with esmtp (Exim 4.80)
        (envelope-from <dave@fromorbit.com>)
        id 1c7WWq-0008NO-Od
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:40 +1100
Received: from dave by disappointment with local (Exim 4.87)
        (envelope-from <dave@disappointment.disaster>)
        id 1c7WWr-00020C-L7
        for linux-xfs@vger.kernel.org; Fri, 18 Nov 2016 10:55:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: fix rmapbt ENOSPC hangs
Date: Fri, 18 Nov 2016 10:55:31 +1100
Message-Id: <1479426935-7112-1-git-send-email-david@fromorbit.com>
In-Reply-To: <20161117213224.GD28177@dastard>
References: <20161117213224.GD28177@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Darrick,

This is the patchset I write to address the rmapbt enospc issue
that generic/224 was tripping across. I replaced the first patch
with yours as it's cleaner, and forward ported the other patches.

I stopped working on this because the reflink merge fixed the
problems I was seeing. maybe that was because I stopped testing
rmapbt=1 by itself, though, so the problem never really got fixed.

I'm running it through an auto test run right now, but I thought
I'd post it now so you can comment on the next three patches in the
series. Also to see if it passes the enospc tests on your setups...

Cheers,

Dave.

