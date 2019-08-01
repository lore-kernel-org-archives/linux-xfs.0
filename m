Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfHABmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:42:49 -0400
Subject: [PATCH v2 0/5] xfs: fixes and new tests for bulkstat v5
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 31 Jul 2019 18:42:35 -0700
Message-ID: <156462375516.2945299.16564635037236083118.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, fstests@vger.kernel.org

Hi all,

Fix some problems introduced by the creation of the V5 bulkstat ioctl,
and then add some new tests to make sure the new libxfrog bulkstat
wrappers work fine with both the new v5 ioctl and emulating it with the
old v1 ioctl.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bulkstat-v5

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bulkstat-v5
