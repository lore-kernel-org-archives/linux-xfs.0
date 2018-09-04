Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:65144 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbeIDMxG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 08:53:06 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fx6hn-0001wx-Uq
        for linux-xfs@vger.kernel.org; Tue, 04 Sep 2018 18:28:59 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fx6hn-0000jZ-RO
        for linux-xfs@vger.kernel.org; Tue, 04 Sep 2018 18:28:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/2] mkfs: large fs IO scalability improvements
Date: Tue,  4 Sep 2018 18:28:55 +1000
Message-Id: <20180904082857.2180-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

These are the patches that fell out of looking at why making an 8EB
filesystem was taking so long on one of my faster VMs. Sure, it's
millions of IOs, but there was 3x as much IO as there should have
been, and a large amount of it was unexpected, inefficient RMW
cycles cycles during free list initialisation.

Details in the patches, I don't think there's anything controversial
in them. Let me know what you think.

Cheers,

Dave.
