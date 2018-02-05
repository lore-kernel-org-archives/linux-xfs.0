Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750949AbeBEUlT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 15:41:19 -0500
Date: Mon, 5 Feb 2018 12:41:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.16
Message-ID: <20180205204118.GI4849@magnolia>
References: <20180131181311.GC4860@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131181311.GC4860@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

As promised, here's a (much smaller) second pull request for the second
week of the merge cycle.  This time around we have a couple patches
shutting off unsupported fs configurations, and a couple of cleanups.

Last, we turn off EXPERIMENTAL for the reverse mapping btree, since
the primary downstream user of that information (online fsck) is now
upstream and I haven't seen any major failures in a few kernel
releases.

Let me know if you encounter any merge problems; I checked against this
morning's master and didn't see any.

--D

The following changes since commit 1e369b0e199bbfbab5218e1c1443d839700d8884:

  xfs: remove experimental tag for reflinks (2018-01-29 07:27:24 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.16-merge-5

for you to fetch changes up to 76883f7988e6d06a97232e979bc7aaa7846a134b:

  xfs: remove experimental tag for reverse mapping (2018-02-01 21:07:26 -0800)

----------------------------------------------------------------
Changes since last update:
 - Print scrub build status in the xfs build info.
 - Explicitly call out the remaining two scenarios where we don't
   support
   reflink and never have.
 - Remove EXPERIMENTAL tag from reverse mapping btree!

----------------------------------------------------------------
Darrick J. Wong (4):
      xfs: fix u32 type usage in sb validation function
      xfs: don't allow DAX on reflink filesystems
      xfs: don't allow reflink + realtime filesystems
      xfs: remove experimental tag for reverse mapping

Eric Sandeen (1):
      xfs: add scrub to XFS_BUILD_OPTIONS

 fs/xfs/libxfs/xfs_sb.c |  4 ++--
 fs/xfs/xfs_super.c     | 24 +++++++++++++++---------
 fs/xfs/xfs_super.h     |  7 +++++++
 3 files changed, 24 insertions(+), 11 deletions(-)
