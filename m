Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39088 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393093AbfBNKA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:00:59 -0500
Received: by mail-pl1-f193.google.com with SMTP id 101so2900728pld.6
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:00:59 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Date: Thu, 14 Feb 2019 02:00:07 -0800
Message-Id: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Hi,

Since statx was added in 4.11, userspace has had an interface for
reading btime (file creation time), but no way to set it. This RFC patch
series adds support for changing btime with utimensat(). Patch 1 adds
the VFS infrastructure, patch 2 adds the support to utimensat() with a
new flag, and the rest of the patches add filesystem support; I excluded
CIFS for now because I don't have a CIFS setup to test it on.

Updating btime is useful for at least a couple of use cases:

- Backup/restore programs (my motivation for this feature is btrfs send)
- File servers which interoperate with operating systems that allow
  updating file creation time, including Mac OS [1] and Windows [2]

I've also included a man page patch, xfs_io support, and an xfstest.

Thoughts on the implementation or the interface?

Thanks!

1: https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/setattrlist.2.html
2: https://docs.microsoft.com/en-us/windows/desktop/api/fileapi/nf-fileapi-setfiletime

Omar Sandoval (6):
  fs: add btime to struct iattr
  fs: add AT_UTIME_BTIME for utimensat()
  Btrfs: add support for setting btime
  ext4: add support for setting btime
  f2fs: add support for setting btime
  xfs: add support for setting btime

 fs/attr.c                      |  6 +++
 fs/btrfs/inode.c               |  2 +
 fs/btrfs/super.c               |  4 +-
 fs/ext4/inode.c                | 15 +++++-
 fs/ext4/super.c                |  2 +-
 fs/f2fs/file.c                 | 19 ++++++--
 fs/f2fs/super.c                |  2 +-
 fs/utimes.c                    | 86 +++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_format.h     |  2 +-
 fs/xfs/libxfs/xfs_log_format.h |  2 +-
 fs/xfs/xfs_iops.c              | 11 ++++-
 fs/xfs/xfs_super.c             |  2 +-
 include/linux/fs.h             |  4 ++
 include/uapi/linux/fcntl.h     |  2 +
 14 files changed, 111 insertions(+), 48 deletions(-)

-- 
2.20.1
