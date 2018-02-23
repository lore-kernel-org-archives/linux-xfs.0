Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWCEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:04:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N22UXw151111
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:04:44 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ga9bpg2cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:04:44 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N1xhGt009223
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:43 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1N1xh0q029962
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:43 GMT
Subject: [PATCH 0/5] xfs: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 17:59:42 -0800
Message-ID: <151935118240.21654.10146641674018880885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series fixes miscellaneous problems in XFS.  The first two fix some
crashes and locking problems that happen when we're fed fs images with
corrupt directories or AGFs.

The third patch speeds up inode reclaim by avoiding an unnecessary
transaction allocation when there's nothing in the CoW fork.

The final two patches fix the AGFL wrapping problems we've seen with the
v5 disk format once and for all.  At mount time we fix any AGFL wrapping
problems that an old kernel might have left for us, and at unmount or
freeze or remount-ro time we ensure that the AGFLs we leave behind for
other filesystems to mount do not wrap around the end of the block.
This should fix all the intermittent agf verifier failures people see.
Note that the mitigation is switched off for rmap or reflink filesystems
on the assumption that any kernel that supports those features also has
the 4.5 agfl padding patch applied.

These patches are all against 4.16-rc2, though aside from the first two
I intend them all for 4.17.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
