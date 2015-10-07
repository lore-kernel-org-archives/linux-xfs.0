Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFF717F77
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 06:08:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F28AAC009
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 04:08:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WQheGmzzAFCa8SbH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 04:08:13 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 0F4A68EA21
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 11:08:13 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/2] xfs: prefix two XATTR_ names with XFS_
Date: Wed,  7 Oct 2015 13:07:49 +0200
Message-Id: <1444216071-6281-1-git-send-email-jtulak@redhat.com>
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

This set introduces renaming of XATTR_LIST_MAX and XATTR_SIZE_MAX
to XFS_XATTR_... to make it the same as in xfsprogs. See specific
patches for reasoning.

Jan Tulak (2):
  xfs: prefix XATTR_LIST_MAX with XFS_
  xfs: avoid dependency on Linux XATTR_SIZE_MAX

 fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
 fs/xfs/libxfs/xfs_format.h      | 10 +++++++++-
 fs/xfs/libxfs/xfs_fs.h          | 10 ++++++++++
 fs/xfs/xfs_ioctl.c              |  6 +++---
 fs/xfs/xfs_ioctl32.c            |  2 +-
 5 files changed, 24 insertions(+), 6 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
