Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29469 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVYC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:24:02 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LO1Fi009438
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LO1Zn007679
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:01 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v52LO1Co007439
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:01 GMT
Subject: [PATCH v7 00/13] xfs: preparing for online scrub support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:24:00 -0700
Message-ID: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the seventh revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.  Changes since v6 include refactoring the scrub
setup code, fixing a deadlock problem in the xattr scrubber, and
strengthening the cross-referencing checks.  I have been performing
weekly online scrubs of my XFS filesystems for several months now, with
surprisingly few problems.

Online scrub/repair support consists of four major pieces -- first, an
ioctl that maps physical extents to their owners (GETFSMAP; already in
4.12); second, various in-kernel metadata scrubbing ioctls to examine
metadata records and cross-reference them with other filesystem
metadata; third, an in-kernel mechanism for rebuilding damaged metadata
objects and btrees; and fourth, a userspace component to coordinate
scrubbing and repair operations.

This new utility, xfs_scrub, is separate from the existing offline
xfs_repair tool.  The program uses various XFS ioctls to iterate all XFS
metadata and asks the kernel to check the metadata and repair it if
necessary.

Per reviewer request, the v7 patch series has been broken into multiple
smaller series -- the first one makes all the libxfs changes necessary
to support scrub and the second series adds the scrub functionality.  A
similar split will be applied to the cross-referencing checks and the
repair functions the next time they are posted.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.12-rc3.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
