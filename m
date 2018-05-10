Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49536 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbeEJTST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 15:18:19 -0400
Subject: [PATCH v5 0/8] xfs-4.18: scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 12:18:00 -0700
Message-ID: <152597988038.25215.9276761144353662866.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

Hi all,

Here's a revised series cleaning up some problems and bugs found by
stressing the online scrub code.  Most of the problems fixed here were
uncovered through more thorough testing of the online repair series,
which was posted previously.

The first patch cleans up some goofyness in the quota init code.

Next we continue amending the code to finish scrub as soon as we've
decided it's CORRUPT.

The next two patches fix the quota and realtime scrubbers to call the
bmapbtd scrubber on their data forks.

Then there's a patch to fix a potential ABBA deadlock in the parent
scrubber.

Next, there's a patch to refactor AGFL walking into a library iterator
function.

The last two patches fix up the bmapi_remap interface to work on the
attribute fork and plumb in support for unwritten and normap modes;
these are the last two patches needed before landing the online repair
code.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.17-rc4.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel-moo
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
