Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfGDO7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jul 2019 10:59:50 -0400
Date: Thu, 4 Jul 2019 07:59:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE RESEND] xfs-linux: iomap-5.3-merge updated to 36a7347de097
Message-ID: <20190704145907.GG1654093@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@lst.de>

Hi folks,

The iomap-5.3-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This is pretty much it for the 5.3 merge window; I'm
resending this message because the previous one may have been eaten by
filters.

The new head of the iomap-5.3-merge branch is commit:

36a7347de097 iomap: fix page_done callback for short writes

New Commits:

Andreas Gruenbacher (2):
      [8d3e72a180b4] iomap: don't mark the inode dirty in iomap_write_end
      [36a7347de097] iomap: fix page_done callback for short writes

Christoph Hellwig (1):
      [8af54f291e5c] fs: fold __generic_write_end back into generic_write_end


Code Diffstat:

 fs/buffer.c           | 62 ++++++++++++++++++++++++---------------------------
 fs/gfs2/bmap.c        |  2 ++
 fs/internal.h         |  2 --
 fs/iomap.c            | 17 ++++++++++++--
 include/linux/iomap.h |  1 +
 5 files changed, 47 insertions(+), 37 deletions(-)
