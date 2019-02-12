Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49556 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfBLCRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 21:17:24 -0500
Subject: [PATCH 0/3] fstests: fixes and new tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 11 Feb 2019 18:17:20 -0800
Message-ID: <154993784038.1948.7502664832930298472.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

The first patch fixes kmemleak to deal with sections correctly.

Patches 2-3 check that statx btime (aka inode creation time) report
reasonable results for filesystems that support it.

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
