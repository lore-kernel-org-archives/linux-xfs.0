Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:29801 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750805AbeEKCKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 22:10:03 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fGxVB-0006xh-IN
        for linux-xfs@vger.kernel.org; Fri, 11 May 2018 12:09:45 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fGxVB-0002gI-FH
        for linux-xfs@vger.kernel.org; Fri, 11 May 2018 12:09:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: handle mount failures more cleanly
Date: Fri, 11 May 2018 12:09:41 +1000
Message-Id: <20180511020943.10132-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This is the XFS side of the "fs: don't scan the inode cache before
SB_BORN is set" changes to handle mount failures more cleanly. This
addresses teh use-after-free problems that can occur when
xfs_fs_fill_super() fails, frees the xfs_mount structure but
then leaves the VFS superblock pointing to it.

Th efirst patch is the mount delay sysfs option I've been using to
test this. I'll post the fstest that uses it in a minute.

Cheers,

Dave.

