Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbeKAUED (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Nov 2018 16:04:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 205F6308A948
        for <linux-xfs@vger.kernel.org>; Thu,  1 Nov 2018 11:01:36 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/2] xfsdump whitespace changes
Date: Thu,  1 Nov 2018 12:01:28 +0100
Message-Id: <20181101110130.19489-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

(I'm splitting the previous set into smaller ones, so changes doesn't
 have to wait.)

This set is dealing with whitespaces only, no functional change, code
shuffling, etc. should be present. The first patch clears out trailing
whitespaces, the second one sorts out the crazy mishmash of tabs and
spaces.

I know that these kind of changes are usually not welcomed as they
conflict with other people's work, but that should not be an issue for
xfsdump.

Jan Tulak (2):
  xfsdump: remove trailing whitespaces
  xfsdump: change indentation to tabs

 common/arch_xlate.c     |  330 ++--
 common/cldmgr.c         |   38 +-
 common/cldmgr.h         |    6 +-
 common/cleanup.c        |   10 +-
 common/cleanup.h        |   12 +-
 common/content.h        |   14 +-
 common/content_common.c |   28 +-
 common/content_inode.h  |   14 +-
 common/dlog.c           |   94 +-
 common/dlog.h           |   42 +-
 common/drive.c          |   38 +-
 common/drive.h          |   74 +-
 common/drive_minrmt.c   |  926 +++++-----
 common/drive_scsitape.c | 1377 ++++++++-------
 common/drive_simple.c   |  308 ++--
 common/fs.c             |   28 +-
 common/fs.h             |   22 +-
 common/getdents.c       |   14 +-
 common/global.c         |  120 +-
 common/global.h         |    4 +-
 common/hsmapi.c         |   50 +-
 common/inventory.c      |  142 +-
 common/inventory.h      |   46 +-
 common/main.c           |  604 +++----
 common/media.c          |   62 +-
 common/media_rmvtape.h  |    2 +-
 common/mlog.c           |   78 +-
 common/mlog.h           |    2 +-
 common/openutil.c       |   14 +-
 common/qlock.c          |   26 +-
 common/rec_hdr.h        |    2 +-
 common/ring.c           |   32 +-
 common/ring.h           |   46 +-
 common/stream.c         |   16 +-
 common/stream.h         |   20 +-
 common/ts_mtio.h        |  110 +-
 common/types.h          |   76 +-
 common/util.c           |  178 +-
 common/util.h           |   46 +-
 dump/content.c          | 2172 ++++++++++++------------
 dump/inomap.c           |  402 ++---
 dump/inomap.h           |   34 +-
 dump/var.c              |   38 +-
 inventory/inv_api.c     |  354 ++--
 inventory/inv_core.c    |   40 +-
 inventory/inv_files.c   |    2 +-
 inventory/inv_fstab.c   |   92 +-
 inventory/inv_idx.c     |  197 ++-
 inventory/inv_mgr.c     |  175 +-
 inventory/inv_oref.c    |  140 +-
 inventory/inv_oref.h    |   82 +-
 inventory/inv_priv.h    |  128 +-
 inventory/inv_stobj.c   |  516 +++---
 inventory/inventory.h   |   70 +-
 inventory/testmain.c    |  147 +-
 invutil/cmenu.c         |  654 +++----
 invutil/cmenu.h         |   82 +-
 invutil/fstab.c         |  414 ++---
 invutil/invidx.c        | 1574 +++++++++--------
 invutil/invutil.c       | 1161 +++++++------
 invutil/invutil.h       |   12 +-
 invutil/list.c          |  148 +-
 invutil/list.h          |   37 +-
 invutil/menu.c          |  292 ++--
 invutil/screen.c        |   64 +-
 invutil/stobj.c         |  654 +++----
 librmt/rmtabort.c       |    2 +-
 librmt/rmtaccess.c      |    2 -
 librmt/rmtclose.c       |    2 -
 librmt/rmtcommand.c     |    3 -
 librmt/rmtcreat.c       |    2 -
 librmt/rmtdev.c         |    2 -
 librmt/rmtfstat.c       |    2 +-
 librmt/rmtioctl.c       |  222 +--
 librmt/rmtlib.h         |    2 +-
 librmt/rmtlseek.c       |    2 -
 librmt/rmtmsg.c         |   26 +-
 librmt/rmtopen.c        |   72 +-
 librmt/rmtstatus.c      |    3 -
 restore/bag.c           |   22 +-
 restore/bag.h           |    4 +-
 restore/content.c       | 3568 +++++++++++++++++++--------------------
 restore/dirattr.c       |  308 ++--
 restore/dirattr.h       |    6 +-
 restore/inomap.c        |  118 +-
 restore/mmap.c          |   16 +-
 restore/namreg.c        |   82 +-
 restore/node.c          |   98 +-
 restore/node.h          |   12 +-
 restore/tree.c          | 1082 ++++++------
 restore/tree.h          |    8 +-
 restore/win.c           |   28 +-
 restore/win.h           |   10 +-
 93 files changed, 10202 insertions(+), 10234 deletions(-)

-- 
2.19.1
