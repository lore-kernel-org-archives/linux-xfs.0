Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbeKOQKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 11:10:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAF63lbX113262
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:24 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nr7cs7hc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:24 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAF64N6Y011880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:23 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAF64M91023431
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:22 GMT
Subject: [PATCH v2 0/9] xfs-5.0: inode btree scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Nov 2018 22:04:21 -0800
Message-ID: <154226186169.13280.4536602352984659736.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series fixes some problems with the inode btree scrub code, namely
that the existing code does not handle the case where a single inode
cluster is mapped by multiple inobt records.  The series cleans up the
rather confusing variable names and depends on "miscellaneous cleanups"
series from a few days ago.

Patch 1 teaches the inode record block counting code to handle the case
where there's more than one inobt record per inode cluster.  We do this
by counting inodes and converting to blocks only at the end.

Patch 2 corrects a condition where we needed to clamp the number of
inodes checked for a given inobt record to the inode chunk size.

Patches 3-4 move the inobt record alignment checks to a separate
function and enhance the function to check that when we have more than
one inobt record per cluster we actually check that *all* of the
necessary records are present and in the correct order.

Patches 5-7 reorganize the inobt free data checks to deal with the
"multiple inobt records per icluster" situation.  In restructuring the
code to do so, we also rename variables and functions to be less
confusing about what they're there for.  We also fix the 'is the inode
free?' check to calculate dinode buffer offsets correctly in the
"multiple inobt records per icluster" situation.

Patch 8 aborts the xattr scrub loop if there are pending fatal signals.

Patch 9 checks that for any directory or attr fork there are no extent
maps that stretch beyond what a xfs_dablk_t can map.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.20-rc2.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
