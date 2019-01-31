Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfAaXRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:17:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VNDx15084170
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:52 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2q8eyuumrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:52 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNHpNH017768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:51 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0VNHpUY003768
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:17:51 GMT
Subject: [PATCH 0/8] xfs: incore unlinked list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Jan 2019 15:17:50 -0800
Message-ID: <154897667054.26065.13164381203002725289.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This new patch series refactors the existing code that handles metadata
updates to the unlinked list when adding or removing inodes from that
list.  It then adds an in-core hashtable to record which inode's
next_unlinked field points to a given inode.  This enables us to remove
any inode from the on-disk unlinked structure without having to actually
walk the entire unlinked list, which reduces overhead substantially.

If you're going to start using this mess, you probably ought to just
pull from my git trees: kernel[1], xfsprogs[2], and xfstests[3].

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=incore-unlinked-list
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git
