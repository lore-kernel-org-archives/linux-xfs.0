Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34890 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:05:52 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 0/8] add generic interface to set/get project
Date: Fri,  1 Mar 2019 23:05:33 +0900
Message-Id: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Currently, Filesystem use FS_IOC_FS_SETXATTR ioctl
to change project ID of file. However we don't
support ioctl on symlink files, and it is desirable
to change symlink files' project ID just like uid/gid.

This patch try to reuse existed interface fchownat(),
use group id to set project ID if flag AT_FCHOWN_PROJID
passed in.

Also extend statx() calles to get symlink files' project
ID and inherit attribute.

Wang Shilong (8):
  fs: add support to change project ID
  ext4: support project ID in ext4_setattr()
  f2fs: support project ID in f2fs_setattr()
  xfs: support project ID in xfs_setattr()
  fs: add project support to statx
  ext4: support project in ext4_getattr()
  f2fs: support project in f2fs_getattr()
  xfs: support project in xfs_getattr()

 fs/attr.c                        | 26 +++++++++++++--
 fs/ext4/inode.c                  | 15 +++++++--
 fs/f2fs/file.c                   | 12 +++++--
 fs/open.c                        | 29 +++++++++++++----
 fs/quota/dquot.c                 | 23 ++++++++++++++
 fs/stat.c                        |  1 +
 fs/xfs/xfs_iops.c                | 54 ++++++++++++++++++++++++++------
 fs/xfs/xfs_linux.h               | 10 ++++++
 include/linux/fs.h               |  3 ++
 include/linux/quotaops.h         |  9 ++++++
 include/linux/stat.h             |  2 ++
 include/uapi/linux/fcntl.h       |  1 +
 include/uapi/linux/stat.h        |  8 +++--
 tools/include/uapi/linux/fcntl.h |  1 +
 tools/include/uapi/linux/stat.h  |  8 +++--
 15 files changed, 175 insertions(+), 27 deletions(-)

-- 
2.19.1
