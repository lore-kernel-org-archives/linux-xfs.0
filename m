Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728540AbeHMReR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Aug 2018 13:34:17 -0400
Date: Mon, 13 Aug 2018 07:51:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.19 merge, part 1
Message-ID: <20180813145140.GD11750@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, agruenba@redhat.com, Christoph Hellwig <hch@infradead.org>

Hi Linus,

This is the first part of the XFS changes for 4.19.  Christoph and
Andreas coordinated some refactoring work on the iomap code in
preparation for removing buffer heads from XFS and porting gfs2 to
iomap.  I'm sending this small pull request ahead of the main XFS merge
to avoid holding up gfs2 unnecessarily.

--D

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git iomap-4.19-merge

for you to fetch changes up to 806a1477b10a153cd01ee7ccba8ca2492df3e0b2:

  iomap: add inline data support to iomap_readpage_actor (2018-07-03 09:07:47 -0700)

----------------------------------------------------------------
Andreas Gruenbacher (6):
      iomap: mark newly allocated buffer heads as new
      iomap: complete partial direct I/O writes synchronously
      iomap: generic inline data handling
      iomap: add private pointer to struct iomap
      iomap: support direct I/O to inline data
      iomap: add inline data support to iomap_readpage_actor

Christoph Hellwig (5):
      fs: factor out a __generic_write_end helper
      iomap: add a page_done callback
      iomap: add an iomap-based readpage and readpages implementation
      iomap: add initial support for writes without buffer heads
      iomap: refactor iomap_dio_actor

 fs/buffer.c           |  76 ++++----
 fs/internal.h         |   2 +
 fs/iomap.c            | 532 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_iomap.c    |   6 +-
 include/linux/iomap.h |  16 ++
 5 files changed, 536 insertions(+), 96 deletions(-)
