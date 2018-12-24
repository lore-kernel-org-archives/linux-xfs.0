Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47460 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbeLXAmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 19:42:12 -0500
Date: Sun, 23 Dec 2018 16:42:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] iomap: updates for v4.21
Message-ID: <20181224004204.GL27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Linus,

Here's a fix for a memory overflow bug in the iomap code for 4.21-rc1.
It has undergone the usual testing regimen and merges cleanly with 4.20
final.  Let me know if you encounter any problems with the merge.

--D

The following changes since commit 7566ec393f4161572ba6f11ad5171fd5d59b0fbd:

  Linux 4.20-rc7 (2018-12-16 15:46:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-4.21-merge-2

for you to fetch changes up to 3cc31fa65d85610574c0f6a474e89f4c419923d5:

  iomap: don't search past page end in iomap_is_partially_uptodate (2018-12-21 08:42:50 -0800)

----------------------------------------------------------------
Updates for 4.21:
- Fix a memory overflow bug for blocksize < pagesize

----------------------------------------------------------------
Eric Sandeen (1):
      iomap: don't search past page end in iomap_is_partially_uptodate

 fs/iomap.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)
