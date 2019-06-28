Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56252 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfF1SfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 14:35:24 -0400
Subject: [PATCH v2 0/2] vfs: make active swap files unwritable
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 28 Jun 2019 11:35:11 -0700
Message-ID: <156174691124.1557844.14293659081769020256.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, akpm@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hi all,

I discovered that it's possible for userspace to write to active swap
files and swap devices.  While activated, the kernel effectively holds
an irrevocable (except by swapoff) longterm lease on the storage
associated with the swap device, so we need to shut down this vector for
memory corruption of userspace programs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=immutable-swapfiles

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=immutable-swapfiles
