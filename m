Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37848 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbfDQBjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:39:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1cSnV097296
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:45 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rusnewxjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1c9b5048771
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2rv2tv31vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3H1dhRi006910
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:39:43 GMT
Subject: [PATCH 0/2] xfs: prevent overflow of delalloc block counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Apr 2019 18:39:42 -0700
Message-ID: <155546518260.176148.16583864799178682873.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series corrects an integer overflow problem in the inode
i_delayed_blks counter that tracks the number of blocks assigned to the
in-core inode but not reflected in the on-disk metadata.

The first patch widens the in-core dquot to handle block reservations
counts that are 64 bits in size.  This is a requirement for the second
patch, which widens i_delayed_blks to 64 bits.

This rework is required to handle large amounts of COW staging blocks.
Right now the only way to trigger it is to set the maximum cow extent
size hint, reflink a very large (> 16T on a 4k block fs) sparse file,
and then touch enough blocks to cause the cow reservations to exceed
2^32 blocks.

This happens because i_delayed_blks tracks both actual delalloc
reservations in data and cow forks as well as allocated but not yet
remapped real extents in the cow fork.  The overflow will become more
practical when the atomic writes patch lands, whenever that is.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=widen-idelayed

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=widen-idelayed

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=widen-idelayed
