Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56984 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCTAok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:44:40 -0400
Subject: [PATCH 00/12] fstests: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:44:36 -0700
Message-ID: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Here are a bunch of fixes and some new tests.

Patches 1-2 improve the random number algorithm that is used to shuffle
the test list when -r is used.

Patches 3-6 fix some minor problems with existing tests.

Patches 7-8 refactor the code that creates and maintains the cache of
populated filesystem images so that we can cache multiple different
configurations on the test filesystem, since it is advantageous to be
able to populate different configurations without discarding perfectly
good images.

Patch 9 implements a bunch more reflink corner cases when sharing into
or out from a bunch of different types of blocks.

Patch 10 ensures that xfs_copy and xfs_metadump can deal with all types
of xfs metadata.

Patch 11-12 wipe the scratch devices between tests and fix the tests
that erroneously expected the scratch devices to contain anything.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
