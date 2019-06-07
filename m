Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbfFGTaU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:30:20 -0400
Subject: [PATCH v2 0/6] xfsprogs-5.1: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Jun 2019 12:28:15 -0700
Message-ID: <155993569512.2343365.15510991248022865602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Latest respin of patches fixing various problems in xfsprogs.

Patches 1-3 refactor all utilities to use common libfrog functions to
retrieve the filesystem geometry, bulkstat, and inumbers.  The helpers
will make it easier for newer userspace to fall back to older versions
of ioctls.

Patch 4 strengthens mkfs's log alignment checking code.

Patch 5 fixes xfs_io repair command error reporting.

Patch 6 fixes libxfs-diff to handle files that are in libxfs/ in xfsprogs
but still in fs/xfs/ in the kernel.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.1-fixes
