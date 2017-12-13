Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42853 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdLMX41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:56:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNlIX7099983
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:56:27 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2eue5b017n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:56:27 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNuPUh030285
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:56:26 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBDNuPXp007848
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:56:25 GMT
Subject: [PATCH v10.1 00/15] xfs: online scrub xref support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:56:22 -0800
Message-ID: <151320938254.30154.1046660005648421683.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the tenth revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.  The overview of the online scrub functionality
isn't any different than it was with the first kernel series, so I'll
dive into what's in this set.

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
4.15-rc3.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
