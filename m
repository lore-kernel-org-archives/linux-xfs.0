Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:44:21 -0400
Subject: [PATCH v6 00/15] xfs: refactor and improve inode iteration
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Jun 2019 13:43:57 -0700
Message-ID: <156158183697.495087.5371839759804528321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

Hi all,

This next series refactors all the inode walking code in XFS into a
single set of helper functions.  The goal is to separate the mechanics
of iterating a subset of inode in the filesystem from bulkstat.

First we clean up a few weird things in XFS, then build a generic inode
iteration function.  Next, we convert the bulkstat ioctl to use it, then
fix a few things from some of the code we saved from the old bulkstat
inode iteration code.  After that, we restructure the code slightly to
support the inumbers functionality, and then port the inumbers ioctl to
it too.

Finally, we introduce a parallel inode walk feature to speed up
quotacheck on large filesystems.  The justification for this part is a
little questionable since it needs further discovery of what hardware
and software this works best on.  It's also an open question of whether
or not bulkstat could be optimized further.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=parallel-iwalk

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=parallel-iwalk
