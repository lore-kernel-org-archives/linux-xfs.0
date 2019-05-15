Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f176.google.com ([209.85.214.176]:41243 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfEOUrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 16:47:35 -0400
Received: by mail-pl1-f176.google.com with SMTP id f12so431796plt.8
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 13:47:35 -0700 (PDT)
Date: Wed, 15 May 2019 13:47:32 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: xfsdump confused by ino's < root ino
Message-ID: <20190515204732.GA4466@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

Hi,

We use xfsdump and xfsrestore (v3.1.7) to back up one of our storage
systems, and we ran into an issue where xfsdump prints the following for
a mount which isn't a bind mount:

/sbin/xfsdump: NOTE: root ino 136 differs from mount dir ino 256, bind mount?

Which also results in a crash from xfsrestore:

xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.

Looking at [1], xfsdump uses bulkstat to get the minimum inode number on
the filesystem. But, at least one of our filesystems has a root inode
number of 256 and uses inode numbers 136-199, which tricks xfsdump into
thinking that the filesystem is bind mounted. Is this an invalid
assumption in xfsdump, or is it filesystem corruption?

Thanks!

1: https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/commit/?id=25195ebf107dc81b1b7cea1476764950e1d6cc9d
