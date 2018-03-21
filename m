Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:19657 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751040AbeCUHwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 03:52:54 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eyYYF-0003W1-7p
        for linux-xfs@vger.kernel.org; Wed, 21 Mar 2018 18:52:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1eyYYF-00021K-45
        for linux-xfs@vger.kernel.org; Wed, 21 Mar 2018 18:52:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fixes for inode allocation issues
Date: Wed, 21 Mar 2018 18:52:46 +1100
Message-Id: <20180321075248.7677-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

The first patch in this series catches an on disk corruption that
can cause an oops on v4 and v5 w/ ikeep filesystems during inode
allocation. It turns the oops into an EFSCORRUPTED error return, and
the higher level code handles it from there.

The second patch is a cleanup I noticed while looking for the bug
fixed in the first patch.

Cheers,

Dave.
