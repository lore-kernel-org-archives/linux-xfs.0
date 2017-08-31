Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5079 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbdHaOLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:15 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 0/7] xfs: add customizable default values for error configuration
Date: Thu, 31 Aug 2017 22:15:51 +0800
Message-ID: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

Hi all,

This is the initial patchset based on feedbacks from the RFC patcheset [1].
Its main purpose is adding customizable default values for XFS error
configuration, so a default value can be configured for all XFS filesystems
at one time.

A sysfs tree is created under .../xfs/default_error and its hierarchies are
the same with the tree under .../fs/xfs/<dev>/error. The main change is the
implementation method of the default error configuration. In the RFC patchset,
a modify-and-notify method is used. Now, a distinct flag is kept for each
fs-specific error configuration. The flag denotes the error configuration has
a no-default value, and it will be set when a value of no-"default" is written
to the corresponding sysfs file, and will be cleared when a value of "default"
is wrote. These flags will checked by xfs_error_get_cfg() when returning an
error configuration to XFS error handler.

Other changes include adding an extra sysfs attribute named summary to assist
the test of error configuration ("default" vs no-"default") and updating the
documentation accordingly.

Thoughts, reviews, flames appreciated.

Tao

[1]: http://www.spinics.net/lists/linux-xfs/msg09362.html

Hou Tao (7):
  xfs: prepare for the customizable default values of error
    configuration
  xfs: add sysfs files for default values of error configuration
  xfs: make the default values of error configuration customizable and
    workable
  xfs: merge the initialization table into the default error
    configuration
  xfs: construct the values of error configuration for XFS error handler
  xfs: show the summary of error configurations for debugging purpose
  xfs: document the customizable default values of error configuration

 Documentation/filesystems/xfs.txt |  31 ++-
 fs/xfs/xfs_buf_item.c             |  23 +--
 fs/xfs/xfs_mount.c                |   9 +-
 fs/xfs/xfs_mount.h                |  45 ++++-
 fs/xfs/xfs_super.c                |  11 +-
 fs/xfs/xfs_sysfs.c                | 384 ++++++++++++++++++++++++++++----------
 fs/xfs/xfs_sysfs.h                |  11 +-
 7 files changed, 384 insertions(+), 130 deletions(-)

-- 
2.5.0

