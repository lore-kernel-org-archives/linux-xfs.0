Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754012AbeFUScd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:32:33 -0400
Subject: [PATCH 0/4] fstests: fixes and new tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:32:29 -0700
Message-ID: <152960594943.26479.1457883867468749220.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

The first patch fixes xfs/365 to fuzz the AG1 inobt since as of 4.18 XFS
requires an intact AG0 inobt even to mount.

The second patch provides a regression test for "xfs: fix fdblocks
accounting w/ RMAPBT per-AG reservation".

The third patch provides a regression test for a condition where mmap
read of a file's EOF page shows nonzero bytes after EOF if the
previous operation was a zero_range all the way to EOF.  This bug only
seems to manifest on XFS, but it uses generic APIs and so is a generic
test.  The patch concerned here is "xfs: ensure post-EOF zeroing happens
after zeroing part of a file".

The fourth patch adds a variant to the xfs fuzz tests where we fuzz the
metadata fields and immediately try to write to the filesystem.

--D
