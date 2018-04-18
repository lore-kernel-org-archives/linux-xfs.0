Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64910 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751878AbeDRAVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 20:21:18 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1f8aqY-00008p-UK
        for linux-xfs@vger.kernel.org; Wed, 18 Apr 2018 10:21:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1f8aqY-00034L-TB
        for linux-xfs@vger.kernel.org; Wed, 18 Apr 2018 10:21:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: optimise XBF_TRYLOCK buffer lookups
Date: Wed, 18 Apr 2018 10:21:09 +1000
Message-Id: <20180418002111.11637-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This is a cleaned up version of my original patch to avoid
unnecessary buffer lookups on locked buffers when XBF_TRYLOCK is
set. That patch can be found here:

https://marc.info/?l=linux-xfs&m=151994388115521&w=2

Version 2:
- split out changes to xfs_incore interface to make _xfs_buf_find
  static and not externally visible
- fixed indenting issues in error handling switch statement

Cheers,

Dave.
