Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24725 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbeIEMsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Sep 2018 08:48:43 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fxT2G-0003NA-1C
        for linux-xfs@vger.kernel.org; Wed, 05 Sep 2018 18:19:36 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fxT2G-0007GY-00
        for linux-xfs@vger.kernel.org; Wed, 05 Sep 2018 18:19:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFCRAP PATCH 0/4 v2] mkfs.xfs IO scalability
Date: Wed,  5 Sep 2018 18:19:28 +1000
Message-Id: <20180905081932.27478-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

More on getting mkfs to be usable to testing unrealistically large
filesystems. The first two patches of this series are unchanged from
yesterday - the second two are new and build on them.

The second two patches hack a delayed write buffer submission list
in the mkfs and libxfs. It's a bit nasty, because I've chosen to
ignore the fact that the libxfs has no concept of async IO or
background write and instead hacked around it. You can see the
result in passing a buffer list to xfs_trans_commit() to get it to
add buffers to the delwri list rather than write them synchronously.

Fast, loose and stupidly dangerous, all in one. Yeehaw!

Better yet, it doesn't even make any difference to
performance - it's just an enabling patch.

The last patch is the performance improvement - it hacks a grotty,
non-re-entrant AIO submission/completion ring to turn the single
threaded sync write batching into a single threaded concurrent IO
loop using AIO. This can drive really deep IO queues as long as it's
got enough queued IO to work with, so mkfs is hacked to only submit
IO every few hundred AGs it initialises.

This sustains queue depths of around 100 IOs and SSD utilisation at
around 80% using about half a CPU, and so the time to make an 8EB
filesystem drops to around 15 minutes.

This is most definitely not production code. This is a load of crap
hacked together in a few hours as a proof of concept. But it's a
successful proof of concept, so what we now need is someone who is
looking around for a substantial project to volunteer to rewrite the
libxfs buffer cache around an AIO submission/completion core and
implement all this in a "proper" fashion. If you're interested, let
me know...

Cheers,

Dave.
