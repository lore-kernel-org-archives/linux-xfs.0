Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfGAQHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 12:07:00 -0400
Date: Mon, 1 Jul 2019 09:06:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: iomap-for-next updated to 36a7347de097
Message-ID: <20190701160656.GM1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Hi folks,

The iomap-for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-fsdevel@vger.kernel.org so they can be picked up
in the next update.

The new head of the iomap-for-next branch is commit:

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
