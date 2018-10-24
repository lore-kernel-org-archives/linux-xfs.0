Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27343 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbeJYH1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Oct 2018 03:27:22 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gFS5W-0006J3-UO
        for linux-xfs@vger.kernel.org; Thu, 25 Oct 2018 09:57:18 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gFS5W-0005D0-Qz
        for linux-xfs@vger.kernel.org; Thu, 25 Oct 2018 09:57:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: speed up large directory modifications
Date: Thu, 25 Oct 2018 09:57:11 +1100
Message-Id: <20181024225716.19459-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

I've finally  had time to clean this series up properly and get it
tested. This makes growing large directories much faster by avoiding
unnecessray processing during free space searches. Befor making
those changes, I factored the code to make it much cleaner and more
obvious what the different bits of the algorithms are doing.
hopefully that makes the optimisations easier to understand as their
scope is now much clearer. Performance numbers are in the patches
that add the optimisations.

These have been in my test trees for the past month, so they seem
fairly solid at this point. These are for the next dev cycle, not
the one that is being merged right now, though.

Cheers,

Dave.
