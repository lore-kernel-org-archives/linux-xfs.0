Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2FF47CA4
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 07:16:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68BA4304048
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 32Ehh5dUSVHyDf3L (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:26 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9CDA383F47
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 12:16:25 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4ACGOug016940
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 08:16:25 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/7] Configurable error behavior [V4]
Date: Tue, 10 May 2016 14:16:14 +0200
Message-Id: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
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

New revision ot the patchset according with comments for V3.

This patchset is aimed to implement a configurable error behavior in XFS, and,
most of the design has been done by Dave, so, I kept his signed-off.

Detailed changelog is written on each patch, but, major changes are:

	- make fail_at_unmount a global configuration option inside
	  ../xfs/<dev>/err/fail_at_unmount

Carlos Maiolino (7):
  xfs: configurable error behavior via sysfs
  xfs: introduce metadata IO error class
  xfs: add configurable error support to metadata buffers
  xfs: introduce table-based init for error behaviors
  xfs: add configuration of error failure speed
  xfs: add configuration handlers for specific errors
  xfs: add "fail at unmount" error handling configuration

 fs/xfs/xfs_buf.h      |  20 ++++
 fs/xfs/xfs_buf_item.c | 121 +++++++++++++--------
 fs/xfs/xfs_mount.c    |  22 +++-
 fs/xfs/xfs_mount.h    |  34 ++++++
 fs/xfs/xfs_sysfs.c    | 291 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_sysfs.h    |   3 +
 fs/xfs/xfs_trace.h    |   1 -
 7 files changed, 446 insertions(+), 46 deletions(-)

-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
