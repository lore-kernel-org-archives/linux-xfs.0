Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 21:17:46 -0500
Subject: [PATCH 0/2] fstests: incore unlinked list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 11 Feb 2019 18:17:42 -0800
Message-ID: <154993786231.2062.8490515215533507881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

This series adds regression tests for the new XFS incore unlinked backref
cache feature.

The first patch teaches the XFS debug knob code to _notrun a test if the
kernel supports debug knob discovery (via sysfs) but doesn't advertise
the particular knob.

The second patch adds four new regression tests.  The two generic/ tests
exercise the creation and removal of O_TMPFILE files (or files which
have been created, opened, unlinked, and then closed), which ensures
that the filesystem can demonstrate that behavior without problems.  The
two xfs/ tests examine the same behavior, but they deliberately skip the
backref cache lookups to ensure that the old code still works.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=incore-unlinked-list

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=incore-unlinked-list

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=incore-unlinked-list
