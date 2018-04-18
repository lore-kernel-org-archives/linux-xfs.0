Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbeDRCja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:39:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2a2tR097383
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:29 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8jqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:29 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2dS7B007745
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:28 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2dS0H024966
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:28 GMT
Subject: [PATCH 00/11] xfs-4.18: online scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:39:27 -0700
Message-ID: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a series cleaning up some problems and bugs in the online scrub
code.  Most of the problems fixed here were uncovered through more
thorough testing of the online repair series, which will be posted
shortly.

First, we amend scrub to skip cross-referencing once the first error is
found; this patch hasn't changed since its posting during the 4.17 cycle.

The next five patches refactor the quota code to make it possible to
iterate all the dquots in the system with the quota inode's ILOCK held.
After this, we can drop all the weird code that attaches to the quota ip
in favor of using the well known mechanism that we use for all other
inodes.  This enables us to call the data fork scrubber on the quota
inodes; and the dquot iterator that we created earlier.

The next two patches fix some broken interaction between scrub and the
rest of xfs.

Following that are three fixes to the scrubbers themselves -- the first
checks that a btree block never contains fewer than minrecs records
unless it's the top block in a tree.  The second refactors the
transaction allocation helper; and the last one fixes a potential ABBA
deadlock in the parent scrubber.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.17-rc1.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
