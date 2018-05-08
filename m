Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:29054 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753692AbeEHDmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 23:42:08 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVs-0002Ke-V8
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVs-0002hf-T7
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9 v2] xfs: log item and transaction cleanups
Date: Tue,  8 May 2018 13:41:53 +1000
Message-Id: <20180508034202.10136-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This is an updated version of the patchset that emerged from trying
to remove the log item descriptors. First version was here:

https://marc.info/?l=linux-xfs&m=152524812914200&w=2

This version addresses the initial review comments.

Version 2:
- rebased on current for-next tree
- get rid of XFS_LI_TRANS (was patch 2)
- rework AIL assert failure patch with Brian's suggestions
- reworked removal of log item descriptor patch to add checks that
  XFS_LI_TRANS was providing.

Cheers,

Dave.

