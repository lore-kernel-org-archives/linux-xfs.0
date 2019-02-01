Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37774 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfBAQ4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 11:56:34 -0500
Date: Fri, 1 Feb 2019 08:56:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] iomap: more fixes for v5.0
Message-ID: <20190201165616.GG5761@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Here are a couple of iomap fixes to eliminate some memory corruption
and hang problems that were reported.

--D

The following changes since commit 1c7fc5cbc33980acd13d668f1c8f0313d6ae9fd8:

  Linux 5.0-rc2 (2019-01-14 10:41:12 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.0-fixes-1

for you to fetch changes up to 4ea899ead2786a30aaa8181fefa81a3df4ad28f6:

  iomap: fix a use after free in iomap_dio_rw (2019-01-27 08:47:42 -0800)

----------------------------------------------------------------
Changes since last update:
- fix page migration when using iomap for pagecache management
- fix a use-after-free bug in the directio code

----------------------------------------------------------------
Christoph Hellwig (1):
      iomap: fix a use after free in iomap_dio_rw

Piotr Jaroszynski (1):
      iomap: get/put the page in iomap_page_create/release()

 fs/iomap.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)
