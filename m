Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41806 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761965AbdKQVAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:00:13 -0500
Subject: [PATCH v10 00/27] xfsprogs-4.15: online scrub/repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:00:09 -0800
Message-ID: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the tenth revision of a patchset that adds to XFS userland tools
support for online metadata scrubbing and repair.

We start by creating the basic shell of the program that can do argument
parsing and error reporting, create some abstractions for the XFS ioctls
that we use to iterate and scrub metadata, and then tie together all the
in-kernel scrubbing in separate scrub phases.

Next, we move on to checking the directory tree for connectivity and
naming problems and add the infrastructure to perform an (optional) scan
of the in-use parts of the disk media.  We also implement a minimal
preen -- if the fs checks out, we can try to run fstrim; and some basic
progress reporting if the program is running interactively.

Finally, we add some wrapper scripts to schedule scrubs of all the
mounted filesystems; and the necessary systemd / cron infrastructure
that is needed to automatically scan everything once a week.  All of
this is disabled by default.  The systemd integration allows us to give
scrub exactly the privileges it needs while walling off the rest of the
system.

If you're going to start using this mess, you probably ought to just
pull from my git tree for xfsprogs[1].  This series relies on the
libfrog patches sent earlier.  Kernel support will appear in 4.15-rc1.

Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
