Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbeIDDLh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Sep 2018 23:11:37 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D30E0308FB85
        for <linux-xfs@vger.kernel.org>; Mon,  3 Sep 2018 22:49:20 +0000 (UTC)
Received: from localhost (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7853389DE7
        for <linux-xfs@vger.kernel.org>; Mon,  3 Sep 2018 22:49:20 +0000 (UTC)
Date: Mon, 3 Sep 2018 23:49:19 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180903224919.GA16358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

[This is silly and has no real purpose except to explore the limits.
If that offends you, don't read the rest of this email.]

I am trying to create an XFS filesystem in a partition of approx
2^63 - 1 bytes to see what happens.

This creates a 2^63 - 1 byte virtual disk and partitions it:

  # nbdkit memory size=9223372036854775807

  # modprobe nbd
  # nbd-client localhost /dev/nbd0
  # blockdev --getsize64 /dev/nbd0
  9223372036854774784
  # gdisk /dev/nbd0
  [...]
  Command (? for help): n
  Partition number (1-128, default 1):
  First sector (18-9007199254740973, default = 1024) or {+-}size{KMGTP}:
  Last sector (1024-9007199254740973, default = 9007199254740973) or {+-}size{KMGT
P}:
  Current type is 'Linux filesystem'
  Hex code or GUID (L to show codes, Enter = 8300):
  Changed type of partition to 'Linux filesystem'
  Command (? for help): w

The first problem was that the standard mkfs.xfs command will
try to trim the disk in 4 GB chunks (I believe this is a limit
imposed by the kernel APIs).  For a 8 EB image that takes forever.

However I can use the -K option to get around that:

  # mkfs.xfs -K /dev/nbd0p1
  meta-data=/dev/nbd0p1            isize=512    agcount=8388609, agsize=268435455 blks
           =                       sectsz=1024  attr=2, projid32bit=1
           =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
  data     =                       bsize=4096   blocks=2251799813684987, imaxpct=1
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
  log      =internal log           bsize=4096   blocks=521728, version=2
           =                       sectsz=1024  sunit=1 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  mkfs.xfs: read failed: Invalid argument

I guess this indicates a real bug in mkfs.xfs.  I've not tracked down
exactly why this syscall fails yet but will see if I can find it
later.

But first I wanted to ask a broader question about whether there are
other mkfs options (apart from -K) which are suitable when creating
especially large XFS filesystems?

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW
