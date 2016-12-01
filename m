Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16654 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754014AbcLAKa6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 05:30:58 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cCOdi-0006fm-Vt
        for linux-xfs@vger.kernel.org; Thu, 01 Dec 2016 21:30:55 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cCOdi-0000CW-UQ
        for linux-xfs@vger.kernel.org; Thu, 01 Dec 2016 21:30:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: miscellaneous improvements for 4.10
Date: Thu,  1 Dec 2016 21:30:49 +1100
Message-Id: <20161201103052.28453-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

Some things that need review, hoepfully in time for the 4.10 cycle.
I've been running all these in my test kernels for some time now,
and they all seem stable and perform as expected. The btree stats
patch substantially reduces the icache footprint of the core btree
code. The rhashtable patch (many thanks to Lucas for writing the
original patch!) gets rid of most of the _xfs_buf_find() lookup
overhead. The CRC update optimisation patch (thanks to the
diagnosis, analysis and prototyping work done by Nick Piggin)
removes CRCs almost entirely from my kernel profiles on metadata
intensive workloads.

Comments, flames and thoughts welcome.

-Dave.

