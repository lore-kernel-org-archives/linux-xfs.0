Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933817AbdCUS73 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 14:59:29 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC 0/2] xfs_io: hook up statx
Message-ID: <0bc83cf4-a927-e78e-9bfb-7f3fa91303eb@redhat.com>
Date: Tue, 21 Mar 2017 14:59:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>

These 2 patches are a first pass to add a statx command
to xfs_io in hopes that it will aid creation of xfstests
statx regression tests.

xfs_io> help statx
statx [-O | -m mask][-FDLAP] -- extended information about the currently open file

 Display extended file status.

 Options:
 -m mask -- Specify the field mask for the statx call (default STATX_ALL)
 -A -- Suppress terminal automount traversal
 -D -- Don't sync attributes with the server
 -F -- Force the attributes to be sync'd with the server
 -L -- Follow symlinks (statx link target)
 -O -- Remove basic stats (STATX_BASIC_STATS) from default mask
 -P -- pretty-print results similar to stat(1)

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

patch 2 is a bit of a hack for now; it hardcodes the 64-bit x86
syscall nr, and includes a whole header full of statx
#defines.

I'm not sure if we want to provide those under #ifndef,
or just require new kernel headers & test for them w/
autoconf.  I'll clean it up one way or another.

It also lifts a fair bit from David's samples/statx/test-statx.c;
a lot of that is pretty-printing that we don't do for xfs_io's
standard stat command, so maybe it should get dropped from this
patch for code brevity.

Another interesting limitation of all of the xfs_io stat
variants is that they currently can't stat any file that
they can't open, which may or may not be a limitation that
we care about....

Anyway - thoughts on whether this is enough of an interface
to facilitate testing, and whether we should accommodate old
headers would be appreciated, and I'll get it cleaned up &
send a V2.

-Eric
