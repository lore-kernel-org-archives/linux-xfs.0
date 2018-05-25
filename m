Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030394AbeEYWLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 18:11:51 -0400
Subject: [PATCH 0/7] xfsprogs-4.17: last of the fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 May 2018 15:11:37 -0700
Message-ID: <152728629694.22515.17699396814561914788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

The first patch fixes a Coverity bug that was introduced in the latest
push of for-next.

Then there are three patches to fix some deficiencies I found when I
tried to use xfsbuflock.py to diagnose deadlocks in generic/388.  The
script didn't know that buffers are created locked, it didn't tell you
the line number of when a buffer got locked, and it got a little
confused about trylock.  So fix all three of those.

The fourth patch fixes another bashism in fsck.xfs.

The fifth patch removes crc32 support (not crc32c support) which is not
used anywhere in xfs.  This reduces text segment size by 8K in all
programs.

--D
