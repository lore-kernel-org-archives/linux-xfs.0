Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39254 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752311AbeEUP4J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 May 2018 11:56:09 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2E2C84507C2
        for <linux-xfs@vger.kernel.org>; Mon, 21 May 2018 10:55:58 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 8552f8e
Message-ID: <290b44a7-f3e4-5580-225c-d84533556330@sandeen.net>
Date: Mon, 21 May 2018 10:56:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

The new head of the master branch is commit:

8552f8e Merge branch 'guilt/libxfs-4.17-sync' into for-next

This just brings in the last few 4.17 libxfs bits.  Hoping to get proper
xfsprogs updates done in coming days, still digging out of other work.

New Commits:

Darrick J. Wong (1):
       [dee7606] xfs: don't fail when converting shortform attr to long form duri

Eric Sandeen (3):
       [3060f26] xfs: enhance dinode verifier
       [7c4d311] xfs: set format back to extents if xfs_bmap_extents_to_btree
       [8552f8e] Merge branch 'guilt/libxfs-4.17-sync' into for-next


Code Diffstat:

  libxfs/xfs_attr.c      |  9 ++++++++-
  libxfs/xfs_bmap.c      |  4 ++++
  libxfs/xfs_inode_buf.c | 21 +++++++++++++++++++++
  3 files changed, 33 insertions(+), 1 deletion(-)

