Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5827C7F58
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 07:46:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 390F3304043
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 05:46:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NBm3CbhjfRcQjxCZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 05:46:55 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 57C562D44FC
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 12:46:54 +0000 (UTC)
Received: from jtulak-t430.brq.redhat.com (jtulak.brq.redhat.com [10.34.1.5])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id t6FCkr9n023337
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 08:46:53 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/2] xfsprogs: Partial OS X support
Date: Wed, 15 Jul 2015 14:46:50 +0200
Message-Id: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These patches fixes the current broken OS X support of xfsprogs.
The goal is to make xfsprogs buildable on current OS X Yosemite,
and to have a working mkfs.xfs. The usage is indeed limited and
there is still space for many improvements, but "it works".

Jan Tulak (2):
  Prefix LIST_... macros to XFS_LIST_...
  OS X partial support

 Makefile                  |   6 +++
 include/bitops.h          |  47 ---------------------
 include/builddefs.in      |   2 +-
 include/darwin.h          | 104 +++++++++++++++++++++++++++++++++++++---------
 include/freebsd.h         |  47 +++++++++++++++++++++
 include/gnukfreebsd.h     |  46 ++++++++++++++++++++
 include/hlist.h           |  10 ++---
 include/irix.h            |  50 +++++++++++++++++++++-
 include/linux.h           |  46 ++++++++++++++++++++
 include/list.h            |   8 ++--
 libdisk/fstype.c          |   1 +
 libhandle/Makefile        |   4 ++
 libhandle/handle.c        |   2 +-
 libxcmd/paths.c           |   2 +-
 libxfs/trans.c            |   2 +-
 libxfs/xfs_bit.h          |   4 +-
 libxfs/xfs_fs.h           |   4 +-
 libxlog/xfs_log_recover.c |   6 +--
 man/man3/xfsctl.3         |   2 +-
 repair/incore.h           |   2 +-
 repair/phase6.c           |   4 +-
 21 files changed, 307 insertions(+), 92 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
