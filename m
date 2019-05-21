Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35596 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbfEUPhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 11:37:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LFYFGr132480
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:44 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2sj7jdpgbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LFbeH6116084
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2sks1jh64u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LFbgYj031610
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 15:37:42 GMT
Date: Tue, 21 May 2019 08:37:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5cd213b0fec6
Message-ID: <20190521153741.GA5141@magnolia>
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

5cd213b0fec6 xfs: don't reserve per-AG space for an internal log

New Commits:

Darrick J. Wong (1):
      [5cd213b0fec6] xfs: don't reserve per-AG space for an internal log


Code Diffstat:

 fs/xfs/libxfs/xfs_ialloc_btree.c   | 9 +++++++++
 fs/xfs/libxfs/xfs_refcount_btree.c | 9 +++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c     | 9 +++++++++
 3 files changed, 27 insertions(+)
