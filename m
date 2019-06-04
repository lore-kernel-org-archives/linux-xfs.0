Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfFDP1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 11:27:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54FOPLw130975
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 15:27:30 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugstdu0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 15:27:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54FQjCw182604
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 15:27:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2swngkdp59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 15:27:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54FRTLe032316
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 15:27:29 GMT
Date: Tue, 4 Jun 2019 08:27:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 025197ebb08a
Message-ID: <20190604152728.GA1200817@magnolia>
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
the next update.  FWIW these are only bugfixes for 5.2.

The new head of the for-next branch is commit:

025197ebb08a xfs: inode btree scrubber should calculate im_boffset correctly

New Commits:

Darrick J. Wong (2):
      [d31d718528dd] xfs: fix broken log reservation debugging
      [025197ebb08a] xfs: inode btree scrubber should calculate im_boffset correctly


Code Diffstat:

 fs/xfs/scrub/ialloc.c |  3 ++-
 fs/xfs/xfs_log.c      | 11 +++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)
