Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15745 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbeKJAMK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:10 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71FC1308FBA9
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:19 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 00/24] xfsdump: code style change
Date: Fri,  9 Nov 2018 15:29:40 +0100
Message-Id: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

This set is dealing with whitespaces only, no functional change, code
shuffling, etc. should be present (with one small exception in patch no. 2).
>From the previous set I split the changes into multiple patches, one type of
change at a time, and tried to make the code fully compliant with xfs style,
so the number of changes is way bigger than in the first set.

The only patch with code shuffling (but no behavioral change) is: "xfsdump: do
not split function call with ifdef." See the patch for details.

For patch 21 - xfsdump: (style) format intercharacter spaces, I think whether
it is still to much agregated and I should separate the changes. Some other
patches I had to split to multiple files as they are too big to pass through
to the mailing list - it is in their name. The largest one is 660K now, so I
will check if that passed through, or it is still too big.

The whole set is created mechanically from scratch. Scripts used for the
specific change are part of the commit message and I can easily put it all
together. So there is no need to worry about rebase conflicts, etc. when
pointing out issues.

The tools used to make these changes are sed and uncrustify.
http://uncrustify.sourceforge.net/

A git tree with these patches is also on Github:
https://github.com/jtulak/xfsdump/tree/style-nov-9th
or
git clone --single-branch -b style-nov-9th https://github.com/jtulak/xfsdump.git


Jan Tulak (24):
  xfsdump: (style) remove trailing whitespaces
  xfsdump: do not split function call with ifdef
  xfsdump: (1/4)(style) remove spaces from parentheses
  xfsdump: (2/4)(style) remove spaces from parentheses
  xfsdump: (3/4)(style) remove spaces from parentheses
  xfsdump: (4/4)(style) remove spaces from parentheses
  xfsdump: (style) remove a space in front of comma/semicolon
  xfsdump: (style) remove a space in ptr dereferences
  xfsdump: add a space after comma and semicolon where was none
  xfsdump: (style) insert a newline between type and fnt name in
    definitions
  xfsdump: (style) add a space after if, switch, for, do, while
  xfsdump: (1/4)(style) add first empty line for multiline comments
  xfsdump: (2/4)(style) add first empty line for multiline comments
  xfsdump: (3/4)(style) add first empty line for multiline comments
  xfsdump: (4/4)(style) add first empty line for multiline comments
  xfsdump: (style) curly brackets should wrap with one space
  xfsdump: (1/4)(style) indent and align the code
  xfsdump: (2/4)(style) indent and align the code
  xfsdump: (3/4)(style) indent and align the code
  xfsdump: (4/4)(style) indent and align the code
  xfsdump: (style) format intercharacter spaces
  xfsdump: (style) format newlines
  xfsdump: (style) add stars to multiline comments
  xfsdump: (style) remove parentheses after return

 common/arch_xlate.c     |    45 +-
 common/cldmgr.c         |   181 +-
 common/cldmgr.h         |    44 +-
 common/cleanup.c        |    95 +-
 common/cleanup.h        |    25 +-
 common/content.h        |   179 +-
 common/content_common.c |   135 +-
 common/content_common.h |     2 +-
 common/content_inode.h  |   505 +-
 common/dlog.c           |   485 +-
 common/dlog.h           |    92 +-
 common/drive.c          |   313 +-
 common/drive.h          |  1015 ++--
 common/drive_minrmt.c   |  3952 +++++++-------
 common/drive_scsitape.c |  5402 ++++++++++---------
 common/drive_simple.c   |  1441 ++---
 common/exit.h           |    15 +-
 common/fs.c             |   247 +-
 common/fs.h             |    52 +-
 common/getdents.c       |    51 +-
 common/getdents.h       |     2 +-
 common/global.c         |   353 +-
 common/global.h         |   115 +-
 common/hsmapi.c         |   408 +-
 common/hsmapi.h         |    88 +-
 common/inventory.c      |   504 +-
 common/inventory.h      |   179 +-
 common/lock.c           |    20 +-
 common/lock.h           |     6 +-
 common/main.c           |  2516 ++++-----
 common/media.c          |   218 +-
 common/media.h          |    82 +-
 common/media_rmvtape.h  |    30 +-
 common/mlog.c           |   599 +--
 common/mlog.h           |   148 +-
 common/openutil.c       |    98 +-
 common/openutil.h       |    40 +-
 common/path.c           |   238 +-
 common/path.h           |    11 +-
 common/qlock.c          |   248 +-
 common/qlock.h          |   112 +-
 common/rec_hdr.h        |    86 +-
 common/ring.c           |   407 +-
 common/ring.h           |   120 +-
 common/stream.c         |   159 +-
 common/stream.h         |    68 +-
 common/timeutil.c       |    14 +-
 common/timeutil.h       |    18 +-
 common/ts_mtio.h        |  1117 ++--
 common/types.h          |   173 +-
 common/util.c           |   465 +-
 common/util.h           |   167 +-
 dump/content.c          |  6940 ++++++++++++------------
 dump/getopt.h           |    81 +-
 dump/inomap.c           |  1486 +++---
 dump/inomap.h           |   125 +-
 dump/var.c              |   129 +-
 dump/var.h              |     4 +-
 include/swab.h          |   127 +-
 include/swap.h          |    42 +-
 inventory/getopt.h      |    19 +-
 inventory/inv_api.c     |   928 ++--
 inventory/inv_core.c    |   152 +-
 inventory/inv_files.c   |    32 +-
 inventory/inv_fstab.c   |   213 +-
 inventory/inv_idx.c     |   500 +-
 inventory/inv_mgr.c     |   593 ++-
 inventory/inv_oref.c    |   253 +-
 inventory/inv_oref.h    |   259 +-
 inventory/inv_priv.h    |   514 +-
 inventory/inv_stobj.c   |  1318 ++---
 inventory/inventory.h   |   262 +-
 inventory/testmain.c    |   429 +-
 invutil/cmenu.c         |   673 ++-
 invutil/cmenu.h         |   102 +-
 invutil/fstab.c         |   613 ++-
 invutil/getopt.h        |    22 +-
 invutil/invidx.c        |  1634 +++---
 invutil/invidx.h        |     6 +-
 invutil/invutil.c       |  1901 ++++---
 invutil/invutil.h       |    66 +-
 invutil/list.c          |   201 +-
 invutil/list.h          |    33 +-
 invutil/menu.c          |   463 +-
 invutil/screen.c        |    80 +-
 invutil/stobj.c         |   880 ++-
 librmt/isrmt.c          |     4 +-
 librmt/rmtabort.c       |     6 +-
 librmt/rmtaccess.c      |    15 +-
 librmt/rmtclose.c       |    26 +-
 librmt/rmtcommand.c     |    15 +-
 librmt/rmtcreat.c       |    19 +-
 librmt/rmtdev.c         |    14 +-
 librmt/rmtfstat.c       |    31 +-
 librmt/rmtioctl.c       |   385 +-
 librmt/rmtisatty.c      |    13 +-
 librmt/rmtlib.h         |    26 +-
 librmt/rmtlseek.c       |    23 +-
 librmt/rmtmsg.c         |    40 +-
 librmt/rmtopen.c        |   198 +-
 librmt/rmtread.c        |    29 +-
 librmt/rmtstatus.c      |    42 +-
 librmt/rmtwrite.c       |    28 +-
 restore/bag.c           |    97 +-
 restore/bag.h           |    71 +-
 restore/content.c       | 10886 ++++++++++++++++++++------------------
 restore/dirattr.c       |  1148 ++--
 restore/dirattr.h       |    82 +-
 restore/getopt.h        |    85 +-
 restore/inomap.c        |   538 +-
 restore/inomap.h        |    73 +-
 restore/mmap.c          |    24 +-
 restore/namreg.c        |   490 +-
 restore/namreg.h        |    37 +-
 restore/node.c          |   664 +--
 restore/node.h          |    47 +-
 restore/tree.c          |  4975 +++++++++--------
 restore/tree.h          |   151 +-
 restore/win.c           |   325 +-
 restore/win.h           |    28 +-
 120 files changed, 33644 insertions(+), 31156 deletions(-)

--
2.19.1
