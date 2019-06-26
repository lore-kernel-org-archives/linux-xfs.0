Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfFZQih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 12:38:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QGYxf9014718
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t9cyqkd1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QGcBpP026169
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f4jgn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QGcZa6006793
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:35 GMT
Date: Wed, 26 Jun 2019 09:38:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to c0546224d7e9
Message-ID: <20190626163834.GG5171@magnolia>
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

c0546224d7e9 xfs: implement cgroup aware writeback

New Commits:

Christoph Hellwig (2):
      [7f72216dc9a3] xfs: simplify xfs_chain_bio
      [c0546224d7e9] xfs: implement cgroup aware writeback

Darrick J. Wong (2):
      [8069dcc20df1] xfs: refactor free space btree record initialization
      [eef36088357e] xfs: account for log space when formatting new AGs


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c | 94 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_aops.c      | 37 ++++++++++----------
 fs/xfs/xfs_super.c     |  2 ++
 3 files changed, 104 insertions(+), 29 deletions(-)
