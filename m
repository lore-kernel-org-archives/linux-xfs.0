Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36938 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751754AbdFNUwP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jun 2017 16:52:15 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E28A87B9656
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2017 15:51:53 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to f9a6d64
Message-ID: <9c4f8412-c9af-4744-c3d4-e6a84017850d@sandeen.net>
Date: Wed, 14 Jun 2017 15:52:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

*** this is just a libxfs update ***

I'm working on the patch backlog next. So hold tight, but if you
don't see your patch in the next update:

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

f9a6d64 xfs: fix unaligned access in xfs_btree_visit_blocks

New Commits:

Brian Foster (1):
      [ad1c97f] xfs: fix indlen accounting error on partial delalloc conversion

Darrick J. Wong (2):
      [07f98c3] xfs: fix warnings about unused stack variables
      [d4e8eb2] xfs: avoid mount-time deadlock in CoW extent recovery

Eric Sandeen (1):
      [f9a6d64] xfs: fix unaligned access in xfs_btree_visit_blocks


Code Diffstat:

 include/xfs_trans.h      |  1 +
 libxfs/libxfs_api_defs.h |  1 +
 libxfs/trans.c           | 22 ++++++++++++++++++++++
 libxfs/xfs_bmap.c        |  9 ++++-----
 libxfs/xfs_btree.c       |  2 +-
 libxfs/xfs_refcount.c    | 43 +++++++++++++++++++++++++++++++------------
 6 files changed, 60 insertions(+), 18 deletions(-)
