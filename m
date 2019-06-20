Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFTQvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:35 -0400
Subject: [PATCH v3 00/12] xfsprogs-5.1: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 09:49:29 -0700
Message-ID: <156104936953.1172531.2121427277342917243.stgit@magnolia>
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

The first two patches fix some problems in the number conversion code.

Patches 3-5 introduce a new structure for managing xfs runtime context.
For now this simply associates a file descriptor with reported xfs geometry
(and some computed values) that enable us to refactor per-ag calculations
out of xfs_scrub.  Later we'll use for things like graceful degradation
when xfsprogs supports bulkstat v5 but the kernel doesn't, and also doing
per-ag scanning operations.

Patches 6-8 refactor all utilities to use common libfrog functions to
retrieve the filesystem geometry, bulkstat, and inumbers.  The helpers
will make it easier for newer userspace to fall back to older versions
of ioctls.

Patch 9 strengthens mkfs's log alignment checking code.

Patch 10 fixes xfs_io repair command error reporting.

Patch 11 fixes libxfs-diff to handle files that are in libxfs/ in xfsprogs
but still in fs/xfs/ in the kernel.

Patch 12 adds a new "btheight" command to xfs_db so that we can calculate
the size of each level of a theoretical btree.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.1-fixes
