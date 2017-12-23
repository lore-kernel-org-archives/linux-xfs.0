Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756913AbdLWArx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:47:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0lqGY002315
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:47:52 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2f1cvf003f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:47:52 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0gpXv002022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:42:51 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN0gpko031204
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:42:51 GMT
Subject: [PATCH v11 00/21] xfs: online scrub xref support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:42:50 -0800
Message-ID: <151398977028.18741.12031215574014508438.stgit@magnolia>
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
on-disk format changes.  The overview of the online scrub functionality
isn't any different than it was with the first kernel series, so I'll
dive into what's in this set.

The first five patches fix some minor problems that I discovered in the
process of triaging the ~9,400 test cases (nr_objs * nr_fields *
nr_fuzz_verbs) to see if xfs_scrub identifies the corruption correctly.
These patches are totally new.

The sixteen patches after that are largely unchanged from the v10 post
except for minor bug fixes and a new patch to record cross-referencing
problems that are mistakenly identified as corruptions in 4.15.

Today's submission is the third of four parts; it adds to the various
metadata scrubbers the ability to cross-reference other metadata.  If
a given record has a corresponding record somewhere else (e.g. each
inobt record has a corresponding rmapbt record for inodes) or lacks a
corresponding record elsewhere (e.g. each bmbt record does /not/ match
to any bnobt records) then we can be far more certain of the
filesystem's correctness.  We try to augment each scrubber with as many
cross-reference checks as we possibly can, though we are careful to
avoid deadlocks by taking locks in the wrong order.  In particular, we
cannot check rmap records against inode bmbts (we lock inode and then
AG); we must only check inode bmbt records against the rmap.  This means
that the userspace driver program must be careful not to claim that the
scrub is finished unless it has scanned everything.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.15-rc4.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
