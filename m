Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:31:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA640DR4024520
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:08 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nh33ttues-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:08 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA6487V4011706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:07 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA6487AX026880
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:07 GMT
Subject: [PATCH 0/8] xfs-5.0: inode btree scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:06 -0800
Message-ID: <154147728649.32496.4515247239602322709.stgit@magnolia>
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
cluster is mapped by multiple inobt records.  The series also cleans up
the rather confusing variable names.

Patch 1 teaches the inode record block counting code to handle the case
where there's more than one inobt record per inode cluster.  We do this
by counting inodes and converting to blocks only at the end.

Patch 2 starts moving the inode geometry stuff to the xchk_iallocbt
context so that we only calculate those things once.

Patches 3-4 move the inobt record alignment checks to a separate
function and enhance the function to check that when we have more than
one inobt record per cluster we actually check that *all* of the
necessary records are present and in the correct order.

Patches 5-7 reorganize the inobt free data checks to deal with the
"multiple inobt records per icluster" situation.  In restructuring the
code to do so, we also rename variables and functions to be less
confusing about what they're there for.

Patch 8 fixes the 'is the inode free?' check to calculate dinode buffer
offsets correctly in the "multiple inobt records per icluster"
situation.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.20-rc1.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
