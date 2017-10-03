Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41229 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdJCUkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:40:52 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KepYe001309
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:40:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v93KepS4032244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:40:51 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v93Keo1W003572
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:40:51 GMT
Subject: [PATCH v11 00/25] xfs: online scrub support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:40:49 -0700
Message-ID: <150706324963.19351.17715069858921948692.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the eleventh revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.  Changes since v10 include voluntarily aborting
scrub if the kernel hits OOM, avoiding deadlocks with inodes that are
being reclaimed, and rebasing to 4.14-rc3.  I have been performing daily
online scrubs of my XFS filesystems for several months now, with
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

While I understand that reviewer bandwidth is limited, I would like to
get this series prepped for 4.15, if possible.  I have isolated the
scrub code such that it can be compiled out entirely, in the hopes that
we can stabilize the code while not exposing regular users to riskier
code.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.14-rc3.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
