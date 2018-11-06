Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387685AbeKGBuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 20:50:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA6GJY6e190259
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 16:24:15 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2nh4aqp6qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 16:24:15 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA6GOEtm031735
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 16:24:14 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA6GOEG9018406
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 16:24:14 GMT
Date: Tue, 6 Nov 2018 08:24:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 837514f7a4ca
Message-ID: <20181106162413.GV4135@magnolia>
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
the next update.  As of this message, I am taking the reins back from
Dave.

The new head of the for-next branch is commit:

837514f7a4ca xfs: fix overflow in xfs_attr3_leaf_verify

New Commits:

Christophe JAILLET (1):
      [132bf6723749] xfs: Fix error code in 'xfs_ioc_getbmap()'

Darrick J. Wong (1):
      [bdec055bb9f2] xfs: print buffer offsets when dumping corrupt buffers

Dave Chinner (1):
      [837514f7a4ca] xfs: fix overflow in xfs_attr3_leaf_verify


Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++--
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_message.c          |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)
