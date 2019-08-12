Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLT5l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:57:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJE9K9126044
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:57:39 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvp1vcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:57:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJCch8137781
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:55:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u9k1vkq92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:55:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJtctx021221
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:55:38 GMT
Date: Mon, 12 Aug 2019 12:55:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8612de3f7ba6
Message-ID: <20190812195537.GL7138@magnolia>
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

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

8612de3f7ba6 xfs: don't crash on null attr fork xfs_bmapi_read

New Commits:

Darrick J. Wong (2):
      [858b44dc62a1] xfs: remove more ondisk directory corruption asserts
      [8612de3f7ba6] xfs: don't crash on null attr fork xfs_bmapi_read

Tetsuo Handa (1):
      [294fc7a4c8ec] fs: xfs: xfs_log: Don't use KM_MAYFAIL at xfs_log_reserve().


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c      | 29 +++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_da_btree.c  | 19 ++++++++++++-------
 fs/xfs/libxfs/xfs_dir2_node.c |  3 ++-
 fs/xfs/xfs_log.c              |  5 +----
 4 files changed, 36 insertions(+), 20 deletions(-)
