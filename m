Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60156 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751076AbdHRXOm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Aug 2017 19:14:42 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 08A1760FC5A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2017 18:13:26 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsdump: v3.1.7 released
Message-ID: <19bc1557-5d96-8091-a7d1-8f7a60b121b6@sandeen.net>
Date: Fri, 18 Aug 2017 18:14:40 -0500
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

has just been updated, and tagged with the v3.1.7 release.

Not a ton of change in this one but needed to at least get
the 32-bit build fix out.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

9fdb6df xfsdump: Release v3.1.7

New Commits:

Eric Sandeen (4):
      [25195eb] xfsdump: handle bind mount targets
      [71860dc] fix build on 32-bit platforms
      [acd0dda] xfsdump: Release v3.1.7-rc1
      [9fdb6df] xfsdump: Release v3.1.7

Eryu Guan (1):
      [5903b44] xfsdump: fix race condition between lseek() and read()/write()

Paulo Cezar A Junior (1):
      [7f42274] xfsdump: Fix memory leak


Code Diffstat:

 VERSION              |  2 +-
 common/inventory.c   |  4 ++--
 common/main.c        | 26 +++++++++++++++++++-------
 configure.ac         |  4 +++-
 debian/changelog     |  6 ++++++
 doc/CHANGES          |  9 +++++++++
 dump/content.c       | 21 +++++++++++++++++++--
 inventory/inv_api.c  |  5 ++---
 inventory/inv_core.c | 29 ++++++-----------------------
 inventory/inv_idx.c  |  4 ++--
 inventory/inv_priv.h | 21 ++++++---------------
 inventory/testmain.c | 34 +++++++++++++++++++++++-----------
 12 files changed, 98 insertions(+), 67 deletions(-)
