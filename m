Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48469 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937024AbeFSClh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 22:41:37 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fV6aI-0004va-El
        for linux-xfs@vger.kernel.org; Tue, 19 Jun 2018 12:41:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fV6aI-0005wF-CQ
        for linux-xfs@vger.kernel.org; Tue, 19 Jun 2018 12:41:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: handle inode extent count mismatch
Date: Tue, 19 Jun 2018 12:41:26 +1000
Message-Id: <20180619024128.22669-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

Wen Xu provided an image that caused a crash allocating an extent.
The AGFL was corrupt, as was the inode data fork extent count. The
combination of the two corruptions could lead to a delalloc extent
being allocated on write, and then when allocation fails because the
AGFL was corrupt, it would try to punch out the delalloc extent
which would then try to convert the format of the extent list in the
inode data fork without a transaction. This would crash.

The following two patches address this - the first makes
xfs_bunmapi() return EFSCORRUPTED if it tries to change the inode
fork format without a transaction context and avoids the crash. THe
second makes the inode verifier detect this specific inode fork
corruption and prevents any attempt to access it with EFSCORRUPTED.

Comments?

Cheers,

Dave.

