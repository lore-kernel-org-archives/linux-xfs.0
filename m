Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57634 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752847AbdGMUUn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jul 2017 16:20:43 -0400
Received: from [10.0.0.114] (provider [10.0.0.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8902D611EE6
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2017 15:20:22 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsdump: updated to acd0dda (3.1.7-rc1)
Message-ID: <5bb50354-9dea-9d2d-3995-7cf11560d341@sandeen.net>
Date: Thu, 13 Jul 2017 15:20:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated and tagged with v3.1.7-rc1

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

acd0dda xfsdump: Release v3.1.7-rc1

New Commits:

Eric Sandeen (3):
      [25195eb] xfsdump: handle bind mount targets
      [71860dc] fix build on 32-bit platforms
      [acd0dda] xfsdump: Release v3.1.7-rc1

Eryu Guan (1):
      [5903b44] xfsdump: fix race condition between lseek() and read()/write()

Paulo Cezar A Junior (1):
      [7f42274] xfsdump: Fix memory leak


Code Diffstat:

 VERSION              |  2 +-
 common/inventory.c   |  4 ++--
 common/main.c        | 26 +++++++++++++++++++-------
 configure.ac         |  4 +++-
 doc/CHANGES          |  5 +++++
 dump/content.c       | 21 +++++++++++++++++++--
 inventory/inv_api.c  |  5 ++---
 inventory/inv_core.c | 29 ++++++-----------------------
 inventory/inv_idx.c  |  4 ++--
 inventory/inv_priv.h | 21 ++++++---------------
 inventory/testmain.c | 34 +++++++++++++++++++++++-----------
 11 files changed, 88 insertions(+), 67 deletions(-)

