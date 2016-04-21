Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A51D97CA1
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:39:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7532630404E
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:39:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DFLtEWqpKK9OGY5N (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:39:56 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id D517664075
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:39:55 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0D007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:39:55 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 00/19 v2] mkfs cleaning
Date: Thu, 21 Apr 2016 11:39:34 +0200
Message-Id: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
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

Updated version. Most notable changes are dropping of
"xfsprogs: disable truncating of files", reverting 
"don't treat files as though they are block devices"
back to Dave's version, and adding a new patch
"mkfs: conflicting values with disabled crc should fail."


Dave Chinner (15):
  xfsprogs: use common code for multi-disk detection
  mkfs: sanitise ftype parameter values.
  mkfs: Sanitise the superblock feature macros
  mkfs: validate all input values
  mkfs: factor boolean option parsing
  mkfs: validate logarithmic parameters sanely
  mkfs: structify input parameter passing
  mkfs: getbool is redundant
  mkfs: use getnum_checked for all ranged parameters
  mkfs: add respecification detection to generic parsing
  mkfs: table based parsing for converted parameters
  mkfs: merge getnum
  mkfs: encode conflicts into parsing table
  mkfs: add string options to generic parsing
  mkfs: don't treat files as though they are block devices

Jan Tulak (4):
  mkfs: move spinodes crc check
  mkfs: unit conversions are case insensitive
  mkfs: add optional 'reason' for illegal_option
  mkfs: conflicting values with disabled crc should fail

 include/Makefile        |    5 +-
 include/xfs_multidisk.h |   73 ++
 libxfs/init.c           |    6 +
 libxfs/linux.c          |   11 +-
 man/man8/mkfs.xfs.8     |   45 +-
 mkfs/Makefile           |    2 +-
 mkfs/maxtrres.c         |    2 +-
 mkfs/proto.c            |   58 +-
 mkfs/xfs_mkfs.c         | 1983 +++++++++++++++++++++++++++++------------------
 mkfs/xfs_mkfs.h         |   89 ---
 repair/xfs_repair.c     |   44 +-
 11 files changed, 1417 insertions(+), 901 deletions(-)
 create mode 100644 include/xfs_multidisk.h
 delete mode 100644 mkfs/xfs_mkfs.h

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
