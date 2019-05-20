Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfETXQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:16:47 -0400
Subject: [PATCH 00/12] xfsprogs-5.1: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 16:16:41 -0700
Message-ID: <155839420081.68606.4573219764134939943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Fix various problems in the xfsprogs-specific parts of the libxfs code.

The first two patches fix some minor bugs in libxfs.

Patches 3-6 refactor all utilities to use common libhandle functions to
retrieve the filesystem geometry, bulkstat, and inumbers.  The helpers
will make it easier for newer userspace to fall back to older versions
of ioctls.

Patch 7 fixes the return types on the libfrog bitmap code functions to
be more general and less scrub specific.

Patch 8 ports xfs_repair to use the libxfs dirent and attr name check
functions.

Patch 9 reworks the xfs_scrub throttling function to use named constants
instead of magic values to make it easier to verify that it actually
does what the manpage says.

Patch 10 enables mkfs to set the DAX flag on the root directory.

Patch 11 strengthens mkfs's log alignment checking code.

Patch 12 enables reflink by default in mkfs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.1-fixes
