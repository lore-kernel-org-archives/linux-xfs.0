Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbfBFQyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 11:54:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x16Gs7TK146866
        for <linux-xfs@vger.kernel.org>; Wed, 6 Feb 2019 16:54:40 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2qd9arj71u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 06 Feb 2019 16:54:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x16GsdPd001106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 6 Feb 2019 16:54:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x16GsdNd030093
        for <linux-xfs@vger.kernel.org>; Wed, 6 Feb 2019 16:54:39 GMT
Subject: [PATCH v3 0/9] xfs: incore unlinked list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 06 Feb 2019 08:54:37 -0800
Message-ID: <154947207759.22369.11575570374120223292.stgit@magnolia>
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

Since v2 this series has been reworked so that the iunlink code is more
robust in the face of backref cache failures (since we can always fall
back to the old bucket walking code), removal of the unlinked inode
counts, standardization of the helper function parameter types, and
fixing other review comments.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=incore-unlinked-list

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=incore-unlinked-list

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=incore-unlinked-list
