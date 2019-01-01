Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40384 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfAACYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:24:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012ONIl179100
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:23 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pp1jqx46g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:24:22 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012OGtK015806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:16 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012OGsm004787
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:16 GMT
Subject: [PATCH v10 00/20] xfs: add realtime reverse-mapping support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:24:15 -0800
Message-ID: <154630945466.8108.16578904812191021263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the tenth revision of a patchset that adds to XFS kernel support
for reverse mapping for the realtime device.  This time around I've
fixed some of the bitrot that I've noticed over the past few months, and
most notably have converted rtrmapbt to use the metadata inode directory
feature instead of burning more space in the superblock.

At the beginning of the set are patches to implement storing B+tree
leaves in an inode root, since the realtime rmapbt is rooted in an
inode, unlike the regular rmapbt which is rooted in an AG block.
Prior to this, the only btree that could be rooted in the inode fork
was the block mapping btree; if all the extent records fit in the
inode, format would be switched from 'btree' to 'extents'.

The next few patches widen the reverse mapping routines to fit the
64-bit numbers required to store information about the realtime
device and establish a new b+tree type (rtrmapbt) for the realtime
variant of the rmapbt.  After that are a few patches to handle rooting
the rtrmapbt in a specific inode that's referenced by the superblock.

Finally, there are patches to implement GETFSMAP with the rtrmapbt and
scrub functionality for the rtrmapbt and rtbitmap; and then wire up the
online scrub functionality.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3].  The
kernel patches in the git trees should apply to 4.20; xfsprogs
patches to for-next; and xfstest to master.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-wtf
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-wtf
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-wtf
