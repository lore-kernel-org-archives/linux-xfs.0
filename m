Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49606 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbdDFSnE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 14:43:04 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/3 V3] xfs_io: hook up statx
Message-ID: <4bb89f72-962d-a9a2-c224-daa828558444@sandeen.net>
Date: Thu, 6 Apr 2017 13:43:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>

These 3 patches are a third pass to add a statx command
to xfs_io in hopes that it will aid creation of xfstests
statx regression tests.

bare "statx" output should look just like bare "stat" output.

xfs_io> help statx
statx [-v|-r][-m basic | -m all | -m <mask>][-FD] -- extended statistics on the currently open file

 Display extended file status.

 Options:
 -v -- More verbose output
 -r -- Print raw statx structure fields
 -m mask -- Specify the field mask for the statx call
            (can also be 'basic' or 'all'; default STATX_ALL)
 -D -- Don't sync attributes with the server
 -F -- Force the attributes to be sync'd with the server

xfs_io> statx -r
stat.mask = 0x7ff
stat.blksize = 4096
stat.attributes = 0x0
stat.nlink = 1
stat.uid = 0
stat.gid = 0
stat.mode: 0100644
stat.ino = 3905768
stat.size = 4691
stat.blocks = 16
stat.atime.tv_sec = 1491338515
stat.atime.tv_nsec = 564190075
stat.btime.tv_sec = 0
stat.btime.tv_nsec = 0
stat.ctime.tv_sec = 1489602207
stat.ctime.tv_nsec = 556521524
stat.mtime.tv_sec = 1489602207
stat.mtime.tv_nsec = 556521524
stat.rdev_major = 0
stat.rdev_minor = 0
stat.dev_major = 8
stat.dev_minor = 33

patch 2 factors out some stat functionality, and adds a
raw stat(2) dumper for consistency.

patch 3 implements the statx stuff, and includes a header file
with lots of the new #defines so this can build on older systems;
eventually that can be removed perhaps.

An interesting limitation of all of the xfs_io stat
variants is that they currently can't stat any file that
they can't open, which may or may not be a limitation that
we care about....

-Eric
