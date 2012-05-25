Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4P7IoZ8044152 for <xfs@oss.sgi.com>; Fri, 25 May 2012 02:18:50 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id MkHoxZJWAvc6yNBo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 00:18:47 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: Build system revamp, part 1
Date: Fri, 25 May 2012 09:18:37 +0200
Message-Id: <1337930323-575-1-git-send-email-jengelh@inai.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jengelh@inai.de


The following changes since commit a8decaf0cf49d3db099e8dc419390c353e2b19ad:

  3.1.8 release (2012-03-20 13:52:15 -0500)

are available in the git repository at:
  git://inai.de/xfsprogs master

Jan Engelhardt (6):
      build: rename to configure.ac
      build: use new autoconf constructs
      build: remove home-baked long/ptr size detection
      build: use standard type intptr_t
      build: use standard type uintptr_t
      Update .gitignore

 .gitignore                   |   82 +++++++++++++++++++++---------------------
 configure.in => configure.ac |   17 ++++++---
 db/bit.c                     |    8 ++--
 db/check.c                   |    8 ++--
 db/field.c                   |    8 ++--
 db/field.h                   |    6 ++--
 include/platform_defs.h.in   |   52 +++------------------------
 include/xfs_btree.h          |   12 +++---
 libxfs/xfs_alloc_btree.c     |   24 ++++++------
 libxfs/xfs_bmap_btree.c      |   24 ++++++------
 libxfs/xfs_ialloc_btree.c    |   24 ++++++------
 logprint/log_misc.c          |    2 +-
 m4/package_types.m4          |   51 --------------------------
 repair/agheader.c            |   26 +++++++-------
 repair/attr_repair.c         |    6 ++--
 repair/avl.c                 |   36 +++++++++---------
 repair/avl.h                 |   18 +++++-----
 repair/dir.c                 |   54 ++++++++++++++--------------
 repair/dir2.c                |   24 ++++++------
 repair/incore_ext.c          |   27 +++++++-------
 repair/incore_ino.c          |   10 +++---
 repair/phase5.c              |    5 ++-
 repair/phase6.c              |   64 ++++++++++++++++----------------
 23 files changed, 251 insertions(+), 337 deletions(-)
 rename configure.in => configure.ac (90%)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
