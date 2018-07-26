Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731327AbeGZTkn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jul 2018 15:40:43 -0400
Date: Thu, 26 Jul 2018 11:22:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.18 fixes, part 2
Message-ID: <20180726182243.GG30972@magnolia>
References: <20180627182421.GE5711@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180627182421.GE5711@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are a couple of late patches for 4.18 to fix a coding bug
introduced in -rc1 and a fix for incorrect metadata verification of
on-disk data.

This series has been run through a full xfstests run over the weekend
and through a quick xfstests run against this morning's master, with no
major failures reported.

--D

The following changes since commit d8cb5e42378918e00eda58792f3ab86dd1e7d214:

  xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation (2018-06-24 12:00:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.18-fixes-4

for you to fetch changes up to d4a34e16555708bab5b67e679a95f055d8ef9882:

  xfs: properly handle free inodes in extent hint validators (2018-07-24 11:34:52 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix some uninitialized variable errors
- Fix an incorrect check in metadata verifiers

----------------------------------------------------------------
Carlos Maiolino (1):
      xfs: Initialize variables in xfs_alloc_get_rec before using them

Eric Sandeen (1):
      xfs: properly handle free inodes in extent hint validators

 fs/xfs/libxfs/xfs_alloc.c     | 5 +++--
 fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)
