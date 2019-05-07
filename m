Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfEGQ5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:05 -0400
Subject: [PATCH 0/3] fstests: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 May 2019 09:56:50 -0700
Message-ID: <155724821034.2624631.4172554705843296757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xuyang2018.jy@cn.fujitsu.com, fstests@vger.kernel.org

Hi all,

Here are three patches fixing various regressions in xfstests when
mkfs.xfs defaults to enabling reflink and/or rmap by default.  Most of
the changes deal with the change in minimum log size requirements.  They
weren't caught until now because there are a number of tests that call
mkfs on a loop device or a file without using MKFS_OPTIONS.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
