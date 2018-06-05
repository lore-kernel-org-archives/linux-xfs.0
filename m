Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29352 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751049AbeFEGYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 02:24:31 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-00022P-P6
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-0001J9-M7
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 V2] xfs: more verifications!
Date: Tue,  5 Jun 2018 16:24:17 +1000
Message-Id: <20180605062423.4877-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

Updated version of this patchset. This version adds COW extent size
hint verification and moves the corruption error conversion to
ESTALE out of xfs_imap_to_bp() and up to xfs_nfs_get_inode() where
ESTALE should be returned.

And, oh, I just realised I forgot the overflow checks in the btree
record verification - I'll send an update for that in line.

Cheers,

Dave.

