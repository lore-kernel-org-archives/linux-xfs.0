Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59460 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfAACIb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:08:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0125YXN168652
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pp1jqx3s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:08:30 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0128Tcb013430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:29 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0128Ser002563
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:29 GMT
Subject: [PATCH 0/8] xfs: inode scrubber fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:08:27 -0800
Message-ID: <154630850739.14372.14000129432637481206.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are fixes for some problems with the inode btree scrub code, namely
that the existing code does not handle the case where a single inode
cluster is mapped by multiple inobt records.

Patch 1 corrects a condition where we needed to clamp the number of
inodes checked for a given inobt record to the inode chunk size.

Patches 2-3 move the inobt record alignment checks to a separate
function and enhance the function to check that when we have more than
one inobt record per cluster we actually check that *all* of the
necessary records are present and in the correct order.  This patch
includes fixes for the finobt alignment false positives recently
reported by Chandan.

Patches 4-6 reorganize the inobt free data checks to deal with the
"multiple inobt records per icluster" situation.  In restructuring the
code to do so, we also rename variables and functions to be less
confusing about what they're there for.  We also fix the 'is the inode
free?' check to calculate dinode buffer offsets correctly in the
"multiple inobt records per icluster" situation.

Patch 7 aborts the xattr scrub loop if there are pending fatal signals.

Patch 8 checks that for any directory or attr fork there are no extent
maps that stretch beyond what a xfs_dablk_t can map.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.20.

Comments and questions are, as always, welcome.

--D
