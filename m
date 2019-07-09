Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfGIPez (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jul 2019 11:34:55 -0400
Date: Tue, 9 Jul 2019 08:34:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] iomap: new code for 5.3, part 1
Message-ID: <20190709153454.GQ1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, sandeen@sandeen.net, hch@lst.de, agruenba@redhat.com, rpeterso@redhat.com, cluster-devel@redhat.com

Hi Linus,

Here's the first part of the iomap merge for 5.3.  There are a few fixes
for gfs2 but otherwise it's pretty quiet so far. The branch merges
cleanly against this morning's HEAD and survived an overnight run of
xfstests.  The merge was completely straightforward, so please let me
know if you run into anything weird.

For the second part of the merge window I would like to break up iomap.c
into smaller files grouped by functional area so that it'll be easier in
the long run to keep the pieces separate and to review incoming patches.
There won't be any functional changes, as the file can still be split
very cleanly.

I prefer to get this done quickly before 5.3-rc1 because I anticipate
that there will be rather more iomap development work coming for 5.4, so
my plan is to rebase my splitting series after the mm and block merges
land and come back in a week or so having let it soak in for-next for
several days.  Let me know if you'd pefer a different timeline.

--D

The following changes since commit d1fdb6d8f6a4109a4263176c84b899076a5f8008:

  Linux 5.2-rc4 (2019-06-08 20:24:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.3-merge-1

for you to fetch changes up to 36a7347de097edf9c4d7203d09fa223c86479674:

  iomap: fix page_done callback for short writes (2019-06-27 17:28:41 -0700)

----------------------------------------------------------------
New for 5.3:
- Only mark inode dirty at the end of writing to a file (instead of once
  for every page written).
- Fix for an accounting error in the page_done callback.

----------------------------------------------------------------
Andreas Gruenbacher (2):
      iomap: don't mark the inode dirty in iomap_write_end
      iomap: fix page_done callback for short writes

Christoph Hellwig (1):
      fs: fold __generic_write_end back into generic_write_end

 fs/buffer.c           | 62 ++++++++++++++++++++++++---------------------------
 fs/gfs2/bmap.c        |  2 ++
 fs/internal.h         |  2 --
 fs/iomap.c            | 17 ++++++++++++--
 include/linux/iomap.h |  1 +
 5 files changed, 47 insertions(+), 37 deletions(-)
