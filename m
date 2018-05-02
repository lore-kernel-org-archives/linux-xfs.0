Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50552 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750939AbeEBR7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 13:59:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w42HtwCQ097137
        for <linux-xfs@vger.kernel.org>; Wed, 2 May 2018 17:59:54 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hmgxfxbj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 02 May 2018 17:59:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w42Hxrqi011461
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 2 May 2018 17:59:53 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w42Hxr1q019140
        for <linux-xfs@vger.kernel.org>; Wed, 2 May 2018 17:59:53 GMT
Date: Wed, 2 May 2018 10:59:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 0ed86afac106
Message-ID: <20180502175952.GY4127@magnolia>
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
picked up in the next update.  I'll have 4.18 stuff posted in a few
days.

The new head of the for-next branch is commit:

021ba8e98fe5 xfs: cap the length of deduplication requests

New Commits:

Darrick J. Wong (1):
      [021ba8e98fe5] xfs: cap the length of deduplication requests


Code Diffstat:

 fs/xfs/xfs_file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)
