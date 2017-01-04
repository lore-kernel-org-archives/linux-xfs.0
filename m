Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33593 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752146AbdADFrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 00:47:24 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v045lNJK015310
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 4 Jan 2017 05:47:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v045lNp2006226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 4 Jan 2017 05:47:23 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v045lMbw027863
        for <linux-xfs@vger.kernel.org>; Wed, 4 Jan 2017 05:47:23 GMT
Date: Tue, 3 Jan 2017 21:47:21 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.10-misc-fixes-5 updated to ff97f23
Message-ID: <20170104054721.GC14031@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfs-4.10-misc-fixes-5 branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

I intend to send these four bugfixes to Linus later this week, but
thought I'd run it by the list first to see if anyone spots anything
obviously broken.

The new head of the xfs-4.10-misc-fixes-5 branch is commit:

ff97f23 xfs: fix max_retries _show and _store functions

New Commits:

Carlos Maiolino (1):
      [ff97f23] xfs: fix max_retries _show and _store functions

Christoph Hellwig (1):
      [a1b7a4d] xfs: fix crash and data corruption due to removal of busy COW extents

Darrick J. Wong (3):
      [7a21272] xfs: fix double-cleanup when CUI recovery fails
      [20e73b0] xfs: use the actual AG length when reserving blocks
      [721a0ed] xfs: update MAINTAINERS


Code Diffstat:

 MAINTAINERS                        |  4 ++--
 fs/xfs/libxfs/xfs_ag_resv.c        |  3 +++
 fs/xfs/libxfs/xfs_refcount_btree.c |  9 ++++++---
 fs/xfs/libxfs/xfs_refcount_btree.h |  3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     | 14 +++++++-------
 fs/xfs/libxfs/xfs_rmap_btree.h     |  3 ++-
 fs/xfs/xfs_fsops.c                 | 14 ++++++++++++++
 fs/xfs/xfs_icache.c                |  3 ++-
 fs/xfs/xfs_refcount_item.c         |  3 ++-
 fs/xfs/xfs_sysfs.c                 |  4 ++--
 10 files changed, 42 insertions(+), 18 deletions(-)
