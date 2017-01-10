Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43174 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754260AbdAJAIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 19:08:07 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0A0862w001314
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 00:08:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v0A086OU013724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 00:08:06 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v0A083R1025967
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 00:08:04 GMT
Date: Mon, 9 Jan 2017 16:08:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.10-misc-fixes-7 updated to 84a4620c
Message-ID: <20170110000802.GF14038@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfs-4.10-misc-fixes-7 branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.  I'll get this into -next to clean up the
mess there.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the xfs-4.10-misc-fixes-7 branch is commit:

84a4620c xfs: don't print warnings when xfs_log_force fails

New Commits:

Christoph Hellwig (5):
      [5149fd3] xfs: bump up reserved blocks in xfs_alloc_set_aside
      [255c516] xfs: fix bogus minleft manipulations
      [54fee13] xfs: adjust allocation length in xfs_alloc_space_available
      [12ef830] xfs: don't rely on ->total in xfs_alloc_space_available
      [84a4620c] xfs: don't print warnings when xfs_log_force fails


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c      | 115 ++++++++++-------------------------------
 fs/xfs/libxfs/xfs_alloc.h      |   2 +-
 fs/xfs/libxfs/xfs_bmap.c       |   3 --
 fs/xfs/libxfs/xfs_bmap_btree.c |   3 +-
 fs/xfs/xfs_log.c               |  12 +----
 5 files changed, 32 insertions(+), 103 deletions(-)
