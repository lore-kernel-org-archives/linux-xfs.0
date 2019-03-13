Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfCMQdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Mar 2019 12:33:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2DGIhDh067025
        for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2019 16:33:02 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2r44wuc584-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2019 16:33:01 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2DGWtV2016656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2019 16:32:55 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2DGWtWw012470
        for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2019 16:32:55 GMT
Date: Wed, 13 Mar 2019 09:32:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6ef50fe9afae
Message-ID: <20190313163243.GI4359@magnolia>
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

6ef50fe9afae xfs: clean up xfs_dir2_leaf_addname

New Commits:

Darrick J. Wong (3):
      [79622c7ce687] xfs: clean up xfs_dir2_leafn_add
      [f51fac689262] xfs: zero initialize highstale and lowstale in xfs_dir2_leaf_addname
      [6ef50fe9afae] xfs: clean up xfs_dir2_leaf_addname

Nathan Chancellor (1):
      [7be73fa1c1b0] xfs: Zero initialize highstale and lowstale in xfs_dir2_leafn_add


Code Diffstat:

 fs/xfs/libxfs/xfs_dir2_leaf.c | 37 +++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_dir2_node.c | 18 ++++++++----------
 2 files changed, 25 insertions(+), 30 deletions(-)
