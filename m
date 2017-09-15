Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56908 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdIOTlT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Sep 2017 15:41:19 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 73A3A60F7B4
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2017 14:39:21 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 211bdc7 (4.13.0-rc1)
Message-ID: <987c5027-9f51-5054-95da-8e60e59f3ebf@sandeen.net>
Date: Fri, 15 Sep 2017 14:41:18 -0500
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

Still only on the rebase-able for-next branch for now, because I'm timid,
this is destined to be the 4.13.0 release, unless I've missed something.
If you have an obvious, trivial, or important patch that should make
the 4.13 release, now is the time to speak up!

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

211bdc7 xfsprogs: Release v4.13.0-rc1

New Commits:

Darrick J. Wong (5):
      [2fc6b16] xfs_io: clarify the fsmap documentation
      [5d52e7a] xfs_repair: take the ag_lock before recording rmap for a bmbt record
      [9587a34] misc: fix more stupid compiler warnings
      [789eb52] libxfs: remove getcwd/chdir dance from initialization
      [99a13e2] mkfs: add documentation for forgotten mkfs flags

Donald Douwsma (1):
      [9a106b5] mkfs.xfs: Don't stagger AG for a single disk

Eric Sandeen (3):
      [fa9f6f1] xfs_bmap: fix -n documentation in manpage
      [459cadd] Merge branch 'libxfs-4.13-sync' into for-next
      [211bdc7] xfsprogs: Release v4.13.0-rc1

Masatake YAMATO (1):
      [67ea25f] xfs_repair: don't use do_warn for normal log message

Nikolay Borisov (6):
      [3d12c08] fiemap: Remove blocksize variable
      [05ef291] fiemap: Make max_extents a global var
      [cb404e2] fiemap: Eliminate num_extents
      [997bfca] fiemap: De-obfuscate last_logical and cur_extent manipulation
      [abd0c76] fiemap: Factor out common code used for printing holes
      [e7eaace] fiemap: Fix semantics of max_extents (-n arguments)

Omar Sandoval (1):
      [ef54efb] xfs: fix inobt inode allocation search optimization


Code Diffstat:

 VERSION              |   4 ++--
 configure.ac         |   2 +-
 db/check.c           |   2 --
 doc/CHANGES          |  15 ++++++++++++
 io/fiemap.c          | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------
 io/fsmap.c           |   2 ++
 libxfs/init.c        |  16 -------------
 libxfs/libxfs_priv.h |   4 ++--
 libxfs/xfs_bmap.c    |   2 +-
 libxfs/xfs_ialloc.c  |   2 +-
 man/man8/mkfs.xfs.8  |  22 +++++++++++++++++
 man/man8/xfs_bmap.8  |   5 ++--
 man/man8/xfs_io.8    |   7 ++++--
 mkfs/xfs_mkfs.c      |   4 +++-
 repair/phase2.c      |   2 +-
 repair/phase6.c      |   4 ----
 repair/scan.c        |   3 +++
 17 files changed, 146 insertions(+), 124 deletions(-)
