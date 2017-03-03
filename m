Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752261AbdCCXVP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:21:15 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Date: Fri,  3 Mar 2017 15:13:07 -0800
Message-Id: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This series adds mkfs.xfs.conf support, so that options can now be
shoved into a configuration file. This enables certain defaults to be
saved for folks sticking to certain values, but more importantly it
also enables distributions to override certain defaults so that new
filesystems remain compatible with older distributions.

This has been based on top of xfsprogs-dev v4.9.0-rc1.

Given we already have an existinsg infrastructure to validate argument
values this reuses that infrastructure by first adding helpers and porting
over the argument parsing suppor to use these helpers.

Luis R. Rodriguez (9):
  mkfs.xfs: add helper to parse command line options
  mkfs.xfs: move dopts to struct mkfs_xfs_opts
  mkfs.xfs: move iopts to to struct mkfs_xfs_opts
  mkfs.xfs: move lopts to struct mkfs_xfs_opts
  mkfs.xfs: move mopts to struct mkfs_xfs_opts
  mkfs.xfs: move nopts to struct mkfs_xfs_opts
  mkfs.xfs: move ropts to struct mkfs_xfs_opts
  mkfs.xfs: use parse_subopts() to parse sopts
  mkfs.xfs: add mkfs.xfs.conf parse support

 .gitignore             |    3 +
 Makefile               |    2 +-
 etc/Makefile           |   21 +
 etc/mkfs.xfs.conf.in   |   58 ++
 include/builddefs.in   |    2 +
 include/buildmacros    |    6 +
 man/man5/mkfs.xfs.conf |  113 +++
 man/man8/mkfs.xfs.8    |   28 +
 mkfs/xfs_mkfs.c        | 1788 ++++++++++++++++++++++++++----------------------
 9 files changed, 1220 insertions(+), 801 deletions(-)
 create mode 100644 etc/Makefile
 create mode 100644 etc/mkfs.xfs.conf.in
 create mode 100644 man/man5/mkfs.xfs.conf

-- 
2.11.0

