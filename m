Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfBDSdi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 13:33:38 -0500
Date: Mon, 4 Feb 2019 10:33:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-5.0-fixes updated to add46b3b0212
Message-ID: <20190204183328.GY5761@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>

Hi folks,

The xfs-5.0-fixes branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the xfs-5.0-fixes branch is commit:

add46b3b0212 xfs: set buffer ops when repair probes for btree type

New Commits:

Brian Foster (2):
      [aa6ee4ab6929] xfs: eof trim writeback mapping as soon as it is cached
      [465fa17f4a30] xfs: end sync buffer I/O properly on shutdown error

Darrick J. Wong (1):
      [add46b3b0212] xfs: set buffer ops when repair probes for btree type


Code Diffstat:

 fs/xfs/scrub/repair.c | 11 ++++++++---
 fs/xfs/xfs_aops.c     |  2 ++
 fs/xfs/xfs_buf.c      | 19 +++++++++++++++++--
 3 files changed, 27 insertions(+), 5 deletions(-)
