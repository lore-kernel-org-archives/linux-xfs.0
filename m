Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbeBWCAa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:00:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N1vHtm067078
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:30 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2ga9bpg215-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:30 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1N20T3k009326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:29 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1N20TFK015334
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:00:29 GMT
Subject: [PATCH 0/8] xfs: online scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:00:28 -0800
Message-ID: <151935122813.21842.14996049216693190946.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series refactors various libxfs and scrub code in preparation for
landing the online repair feature.

The first three patches continue the refactoring of libxfs validator
functions that was started in 4.16.  This time we strengthen the extent
record checks to include out of bounds tests, which scrub/repair will
need to check ifork contents.  Patches 2-3 refactor the inode corruption
logging so that we can capture both the exact code check that triggered
the warning as well as dump the relevant metadata buffer for offline
analysis.

Patch 4 enhances the block mapping scrubber to take a third pass over
the mapping data to make sure that every rmap also has a corresponding
bmap.  This is only done for btree format forks because the complexity
involved in using a btree vastly increases the chances for problems.

Patch 5 removes the raw inode record checking that was introduced in the
original online scrub patches.  Not only was it causing some problems
with the way it was handling the inode cluster buffer, it's also
unnecessary -- the inode repair code knows how to fix (nearly) every
corruption that the iget paths look for, so we should move on to repair
asap.

Patch 6 cleans up helper function parameters that were made unnecessary
by the previous patch.

Patch 7 reclassifies inode cluster buffer read problems in the inode
btree scrubber as a cross referencing error instead of a straight
corruption.

Patch 8 moves the extent size hint validators into libxfs so that scrub
and repair can share the code.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.16-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
