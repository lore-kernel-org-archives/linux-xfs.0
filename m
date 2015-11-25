Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9DBEA7F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 14:18:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 898088F8040
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:18:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Sokv9AB6GvLt3M3V (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:17:59 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id DD69268E00
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 20:17:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-225.bos.redhat.com [10.18.41.225])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAPKHwMZ026348
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 15:17:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfsprogs: log format fixes, db command
Date: Wed, 25 Nov 2015 15:17:53 -0500
Message-Id: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
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

Hi all,

This series includes a few fixes to log formatting/handling code in
xfsprogs. Patch 1 fixes a minor issue in xfs_logprint. Patch 2 fixes the
incorrect formatting issue with larger lsunit alignments noted in the
previously posted torn log write detection series:

  http://oss.sgi.com/pipermail/xfs/2015-November/044845.html

Patch 3 is mostly a refactor to allow the log format command to use
variable sized records rather than unconditionally use 256kB records.
Patch 4 adds the 'logformat' xfs_db command to facilitate testing of the
log formatting mechanism.

This has been lightly tested with xfstests, including via a couple
forthcoming tests that take advantage of the logformat command.
Thoughts, reviews, flames appreciated.

Brian

Brian Foster (4):
  logprint: use correct ext. header count for unaligned size
  libxfs: format the log with valid log record headers
  libxfs: conditionalize log format record size optimization
  db: add the logformat command

 copy/xfs_copy.c     |   2 +-
 db/Makefile         |   4 +-
 db/command.c        |   2 +
 db/logformat.c      | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/logformat.h      |  19 +++++++
 db/metadump.c       |   2 +-
 db/sb.c             |   2 +-
 include/libxfs.h    |   2 +-
 libxfs/rdwr.c       |  89 ++++++++++++++++++++++++-------
 logprint/log_misc.c |   2 +
 mkfs/xfs_mkfs.c     |   3 +-
 repair/phase2.c     |   2 +-
 repair/xfs_repair.c |   2 +-
 13 files changed, 251 insertions(+), 29 deletions(-)
 create mode 100644 db/logformat.c
 create mode 100644 db/logformat.h

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
