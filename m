Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeH3WfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 18:35:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7UISvK9180492
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:31:38 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2m2y2pxea2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:31:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIVbDp013380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:31:37 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIVbNp020051
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:31:37 GMT
Subject: [RFC PATCH v9.1 00/18] xfs: add realtime reverse-mapping support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Aug 2018 11:31:36 -0700
Message-ID: <153565389576.32612.11057291402738397706.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the ninth revision of a patchset that adds to XFS kernel support
for reverse mapping for the realtime device.  The patches haven't
changed significantly since the previous posting in August 2017.  This
time around I've forward ported this to 4.19-rc1.

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
kernel patches in the git trees should apply to 4.19-rc1; xfsprogs
patches to for-next; and xfstest to master.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-wtf
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-wtf
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-wtf
