Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44376 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754051AbeDVPHu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:07:50 -0400
Subject: [PATCH v2 00/10] xfs-4.18: online scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:07:26 -0700
Message-ID: <152440964593.30048.15577210457233332459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

Hi all,

Here's a revised series cleaning up some problems and bugs in the online
scrub code.  Most of the problems fixed here were uncovered through more
thorough testing of the online repair series, which was posted
previously.

First, we amend scrub to skip cross-referencing once the first error is
found; this patch hasn't changed since its posting during the 4.17 cycle.
Second is a patch adding more "finish scrub as soon as we've decided
CORRUPT" checks.

The next two patches refactor the quota scrub to drop all the weird code
that attaches to the quota ip in favor of using the well known mechanism
that we use for all other inodes.  This enables us to call the data fork
scrubber on the quota inodes; and the dquot iterator that we created
earlier.  We also adapt the rtbitmap/rtsum scrubbers to check the data
forks with the same helper.

The next two patches fix some broken interaction between scrub and the
rest of xfs.

Following that are three fixes to the scrubbers themselves -- the first
checks that a btree block never contains fewer than minrecs records
unless it's the top block in a tree.  The second refactors the
transaction allocation helper; and the last one fixes a potential ABBA
deadlock in the parent scrubber.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.17-rc1.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
