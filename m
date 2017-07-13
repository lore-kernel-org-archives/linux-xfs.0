Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51010 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752525AbdGMS62 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jul 2017 14:58:28 -0400
Received: from [10.0.0.114] (provider [10.0.0.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9128B611EE6
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2017 13:58:07 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to b5fcdc0
Message-ID: <5087baa5-a5b9-7203-b124-b98a114692eb@sandeen.net>
Date: Thu, 13 Jul 2017 13:58:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

b5fcdc0 xfsprogs: Release v4.12.0-rc2

New Commits:

Darrick J. Wong (2):
      [fc22d6a] mkfs: set agblklog when we're verifying minimum log size
      [2a3145a] mkfs: set inode alignment and cluster size for minimum log size estimation

Eric Sandeen (1):
      [b5fcdc0] xfsprogs: Release v4.12.0-rc2


Code Diffstat:

 VERSION                 |  2 +-
 configure.ac            |  2 +-
 doc/CHANGES             |  3 +++
 include/xfs_multidisk.h |  2 +-
 libxfs/init.c           |  7 +++++++
 mkfs/maxtrres.c         | 11 ++++++++++-
 mkfs/xfs_mkfs.c         |  3 ++-
 7 files changed, 25 insertions(+), 5 deletions(-)
