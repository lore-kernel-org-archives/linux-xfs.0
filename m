Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53736 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbdCXEct (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Mar 2017 00:32:49 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/2 V2] xfs_io: hook up statx
Message-ID: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Date: Thu, 23 Mar 2017 23:32:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

These 2 patches are a second pass to add a statx command
to xfs_io in hopes that it will aid creation of xfstests
statx regression tests.

xfs_io> help statx
statx [-O | -m mask][-FDLA] -- extended information about the currently open file

 Display extended file status.

 Options:
 -m mask -- Specify the field mask for the statx call (default STATX_ALL)
 -A -- Suppress terminal automount traversal
 -D -- Don't sync attributes with the server
 -F -- Force the attributes to be sync'd with the server
 -L -- Follow symlinks (statx link target)
 -O -- Add only basic stats (STATX_BASIC_STATS) to default mask

xfs_io> statx
stx_mask: 0xfff
stx_blksize: 4096
stx_attributes: 0x70
stx_nlink: 1
stx_uid: 0
stx_gid: 0
stx_mode: 0100644
stx_ino: 99
stx_size: 0
stx_blocks: 0
stx_atime.tv_sec: 1490109633
stx_atime.tv_nsec: 676550238
stx_btime.tv_sec: 1490109633
stx_btime.tv_nsec: 675550234
stx_ctime.tv_sec: 1490109725
stx_ctime.tv_nsec: 69966839
stx_mtime.tv_sec: 1490109633
stx_mtime.tv_nsec: 676550238
stx_rdev_major: 0
stx_rdev_minor: 0
stx_dev_major: 7
stx_dev_minor: 0

patch 2 includes a header file with lots of the new #defines
so this can build on older systems; eventually that can be
removed perhaps.

An interesting limitation of all of the xfs_io stat
variants is that they currently can't stat any file that
they can't open, which may or may not be a limitation that
we care about....

-Eric

