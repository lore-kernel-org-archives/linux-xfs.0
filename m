Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43692 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965724AbeAKThv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:37:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/8] libxfs: cleanup & leak detection
Date: Thu, 11 Jan 2018 13:37:30 -0600
Message-Id: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series is motivated by 2 things; moving libxfs transaction
code slightly closer to how it looks in the kernel, and also
adding (or fixing) infrastructure to better detect leaks in
libxfs.

The first 3 patches just tidy up the use of some
of the private buffer fields in xfs_buf, to match the kernel.

The next 5 revolve around using pseudo memory zones in libxfs
and detecting whether all allocated items have been freed when
libxfs is torn down.  By default there should be no functional
change here, but if the LIBXFS_LEAK_CHECK env var is set, it
will squawk about leaks and exit with exit(1):

[sandeen@sandeen xfsprogs]$ mkfs/mkfs.xfs -dfile,name=fsfile2,size=1g
meta-data=fsfile2                isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
zone xfs_buf_log_item freed with 3 items allocated
[sandeen@sandeen xfsprogs]$ echo $?
1

I've got more going on to fix up these leaks, but this lays the groundwork
in a hopefully easy series to review.

Thanks,
-Eric

