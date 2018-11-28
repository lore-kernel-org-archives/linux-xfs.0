Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbeK2D7T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:59:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83D9CC049598
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 16:57:01 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/4] xfsdump: a little bit of cleaning
Date: Wed, 28 Nov 2018 17:56:45 +0100
Message-Id: <20181128165649.56853-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Jan Tulak <jtulak@redhat.com>

Rather than send a big list of changes at once like the last time, I'm
sending just a few patches. Once these are reviewed and ok (should not be
hard, 3 of the 4 are just few-line changes), then I will send some more.
Hopefully, this will be easier and quicker for all of us.

Anyway, these four patches lay some preparatory work by fixing some of
the compile-time warnings, so any if any further change (formatting or
bug-fixing) introduces a new one, we can spot it without running a diff.

The first patch (trailing whitespaces) can be verified with objdump -d
that it does not change the compiled code.

Cheers,
Jan

Jan Tulak (4):
  xfsdump: (style) remove trailing whitespaces
  xfsdump: do not split function call with ifdef
  common/types.h: Wrap #define UUID_STR_LEN 36 in #ifndef
  common/drive.c: include stdlib.h

 common/arch_xlate.c     |  24 +--
 common/cleanup.c        |   2 +-
 common/cleanup.h        |   2 +-
 common/content.h        |   2 +-
 common/content_inode.h  |   4 +-
 common/dlog.c           |   2 +-
 common/drive.c          |  13 +-
 common/drive.h          |   8 +-
 common/drive_minrmt.c   |  63 ++++----
 common/drive_scsitape.c |  70 ++++----
 common/drive_simple.c   |  10 +-
 common/global.c         |   6 +-
 common/global.h         |   4 +-
 common/hsmapi.c         |   2 +-
 common/inventory.c      | 120 +++++++-------
 common/inventory.h      |  46 +++---
 common/main.c           |  28 ++--
 common/media.c          |   4 +-
 common/media_rmvtape.h  |   2 +-
 common/mlog.c           |  16 +-
 common/mlog.h           |   2 +-
 common/qlock.c          |  10 +-
 common/rec_hdr.h        |   2 +-
 common/ring.c           |   4 +-
 common/ring.h           |   2 +-
 common/stream.c         |   2 +-
 common/ts_mtio.h        |  60 +++----
 common/types.h          |   4 +-
 common/util.c           |   8 +-
 common/util.h           |   2 +-
 dump/content.c          |  84 +++++-----
 dump/inomap.c           |   6 +-
 inventory/inv_api.c     | 198 +++++++++++------------
 inventory/inv_core.c    |  30 ++--
 inventory/inv_fstab.c   |  58 +++----
 inventory/inv_idx.c     | 128 +++++++--------
 inventory/inv_mgr.c     | 114 ++++++-------
 inventory/inv_oref.c    |  96 +++++------
 inventory/inv_oref.h    |  12 +-
 inventory/inv_priv.h    |  64 ++++----
 inventory/inv_stobj.c   | 344 ++++++++++++++++++++--------------------
 inventory/inventory.h   |  64 ++++----
 inventory/testmain.c    |  80 +++++-----
 invutil/fstab.c         |   6 +-
 invutil/invidx.c        |  50 +++---
 invutil/invutil.c       |  56 +++----
 invutil/menu.c          |   8 +-
 invutil/screen.c        |   2 +-
 invutil/stobj.c         |   6 +-
 librmt/rmtioctl.c       |  34 ++--
 librmt/rmtlib.h         |   2 +-
 restore/bag.c           |   2 +-
 restore/content.c       | 110 ++++++-------
 restore/dirattr.c       |   4 +-
 restore/inomap.c        |   2 +-
 restore/namreg.c        |   4 +-
 restore/node.c          |   2 +-
 restore/tree.c          |  62 ++++----
 58 files changed, 1080 insertions(+), 1072 deletions(-)

--
2.19.1
