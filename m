Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfAHUcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:32:39 -0500
Subject: [PATCH v2 0/7] xfs: inode scrubber fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:32:35 -0800
Message-ID: <154697955494.2494.5221420762912855354.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

Hi all,

This is a resend of the inode scrubber fix series from late last year.
Most of it's been reviewed (patches 1, 3, 4, 5) but there have been
some review comments about unclear code in three of the patches, so I'm
resending the whole series, looking for review of patches 2, 6, and 7.

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

Patch 7 consolidates the on-disk inode pointer calculation logic into
xchk_iallocbt_check_cluster.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
5.0-rc1.

Comments and questions are, as always, welcome.

--D
