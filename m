Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A25177F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 07:57:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3234EAC005
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 05:57:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uKKdcaKEtGStWwWo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 05:57:08 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 0/4] xfsprogs: Partial OS X support
Date: Mon, 20 Jul 2015 14:56:54 +0200
Message-Id: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

These patches fixes the current broken OS X support of xfsprogs.
The goal is to make xfsprogs buildable on current OS X Yosemite,
and to have a working mkfs.xfs. The usage is indeed limited but 
"it works".

This v2 fixes known issues from the first patchset and builds
entire xfsprogs.

Jan Tulak (4):
  xfsprogs: Prefix LIST_... macros to XFS_LIST_...
  xfsprogs: Don't Make .po files with gettext disabled
  xfsprogs: Use glibtoolize on osx
  xfsprogs: OS X partial support

 Makefile              |  19 +++++-
 configure.ac          |   1 +
 fsr/xfs_fsr.c         |  20 +++++-
 include/bitops.h      |   2 +
 include/builddefs.in  |   6 +-
 include/darwin.h      | 168 ++++++++++++++++++++++++++++++++++++++++++++------
 include/list.h        |   6 +-
 io/readdir.c          |   4 ++
 libdisk/fstype.c      |   1 +
 libhandle/Makefile    |   4 ++
 libxcmd/paths.c       |   2 +-
 m4/package_libcdev.m4 |  14 +++++
 repair/phase6.c       |   2 +-
 13 files changed, 218 insertions(+), 31 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
