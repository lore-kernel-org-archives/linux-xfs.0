Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55946 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbeLRUfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:35:48 -0500
Subject: [PATCH 0/5] fstests: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:35:43 -0800
Message-ID: <154516534392.31115.7010578395334646479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Here are some fixes for various fstests failures.

Patch 1 fixes a weird porting problem in xfs/111 when it was converted
to use xfs_fsr.

Patch 2 fixes xfs/123 to eliminate a corruption error in the golden
output on 1k v5 filesystems.

Patch 3 is a revised version of a previous patch that works around the
fact that mounting xfs with quotas requires a writable block device even
for a ro mount, which leads to a slightly different error message from
the mount call.

Patch 4 adds a new test to look for forgotten TRACE_DEFINE_ENUM wrappers
for xfs enums that are used as part of __print_symbolic() calls in the
trace points.

Patch 5 is the same old patch that filters v5 mount options out of
MOUNT_OPTIONS when the test formats a v4 filesystem, rather than letting
the test fail due to bad mount options.

--D
