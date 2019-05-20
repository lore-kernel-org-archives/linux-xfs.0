Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55958 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfETWa7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:30:59 -0400
Subject: [PATCH 0/3] fstests: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 15:30:51 -0700
Message-ID: <155839145160.62682.10916303376882370723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com, amir73il@gmail.com, fstests@vger.kernel.org

Hi all,

The first two patches fix t_open_tmpfiles to shut down the scratch
filesystem properly by reverting a broken fix and teaching xfstests to
pass the relevant handles around.  The final patch cleans up some open
coded src/godown calls against the scratch fs to use the wrapper.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
