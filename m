Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41946 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbfC0Qza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Mar 2019 12:55:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2RGn2Y0009849
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2019 16:55:29 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2re6g11udc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2019 16:55:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2RGtSNk012180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2019 16:55:28 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2RGtSAu011817
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2019 16:55:28 GMT
Date: Wed, 27 Mar 2019 09:55:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 2032a8a27b5c
Message-ID: <20190327165527.GC1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

2032a8a27b5c xfs: serialize unaligned dio writes against all other dio writes

New Commits:

Brian Foster (2):
      [6958d11f77d4] xfs: don't trip over uninitialized buffer on extent read of corrupted inode
      [2032a8a27b5c] xfs: serialize unaligned dio writes against all other dio writes

Darrick J. Wong (4):
      [228de124f290] xfs: dabtree scrub needs to range-check level
      [a72e9d8d69e7] xfs: fix btree scrub checking with regards to root-in-inode
      [4b0bce30f39b] xfs: always init bma in xfs_bmapi_write
      [ed79dac98c5e] xfs: prohibit fstrim in norecovery mode


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c | 15 +++++++++------
 fs/xfs/scrub/btree.c     | 11 ++++++++++-
 fs/xfs/scrub/dabtree.c   |  5 +++++
 fs/xfs/xfs_discard.c     |  8 ++++++++
 fs/xfs/xfs_file.c        | 27 +++++++++++++++++----------
 5 files changed, 49 insertions(+), 17 deletions(-)
