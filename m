Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755336AbeEHQhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:37:33 -0400
Subject: [PATCH 0/4] xfsprogs-4.17: tooling fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 May 2018 09:37:14 -0700
Message-ID: <152579743411.10641.4577883761846454290.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

The first three patches of this series fix some deficiencies I found
when I tried to use xfsbuflock.py to diagnose deadlocks in generic/388.
The script didn't know that buffers are created locked, it didn't tell
you the line number of when a buffer got locked, and it got a little
confused about trylock.  So fix all three of those.

The fourth patch fixes another bashism in fsck.xfs.

This probably won't eat your data, and the branch[2] should apply
against for-next.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
