Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4523 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbdHULtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 07:49:33 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 0/3] xfs: add customizable default values for error configuration
Date: Mon, 21 Aug 2017 19:54:19 +0800
Message-ID: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, cmaiolino@redhat.com

Hi all,

XFS has the configurable error handlers for each mounted device, but
the default values of these configuration are static. It will be useful
to make the default values customizable when there are many XFS filesystems
and we need to shutdown the filesystem after getting any error.

The patches are simple. A sysfs tree is created under .../xfs/default_error
and its hierarchies are the same with the tree under .../fs/xfs/<dev>/error.

When the default value of any error configuration is being modified, the
corresponding value of all mount points will be checked again the old
default value. If they are the same, the value of the mount point will
be updated to the new default value as well, else the value of the mount
point will NOT be changed.

Thoughts, reviews, flames appreciated.

Tao

Hou Tao (3):
  xfs: prepare for the customizable default values of error
    configuration
  xfs: add sysfs files for default values of error configuration
  xfs: make the default values of error configuration customizable and
    workable

 fs/xfs/xfs_buf_item.c |   6 +-
 fs/xfs/xfs_mount.c    |   9 +-
 fs/xfs/xfs_mount.h    |  37 +++-
 fs/xfs/xfs_super.c    |  11 +-
 fs/xfs/xfs_sysfs.c    | 569 +++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_sysfs.h    |   9 +-
 6 files changed, 518 insertions(+), 123 deletions(-)

-- 
2.5.0

