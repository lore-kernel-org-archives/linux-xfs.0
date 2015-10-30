Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 35DF87F3F
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 10:05:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1727C304070
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kux8r5db6VO6Ro2c (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:13 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 0/5] xfs: SGI ACL Fixes
Date: Fri, 30 Oct 2015 16:05:03 +0100
Message-Id: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Here is a reworked patch queue that also handles setting SGI_ACL_{FILE,DEFAULT}
via XFS_IOC_ATTRMULTI_BY_HANDLE.  Please review.

Thanks,
Andreas

Andreas Gruenbacher (5):
  xfs: Validate the length of on-disk ACLs
  xfs: Plug memory leak in xfs_attrmulti_attr_set
  xfs: SGI ACLs: Fix caching and mode setting
  xfs: Add namespace parameter to the xfs kuid/kgid <=> uid/gid wrappers
  xfs: SGI ACLs: Map uid/gid namespaces

 fs/xfs/libxfs/xfs_format.h |   8 ++-
 fs/xfs/xfs_acl.c           | 139 +++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_acl.h           |  13 +++++
 fs/xfs/xfs_inode.c         |  14 ++---
 fs/xfs/xfs_ioctl.c         |  61 +++++++++++++++++++-
 fs/xfs/xfs_iops.c          |  12 ++--
 fs/xfs/xfs_linux.h         |  21 ++++---
 fs/xfs/xfs_symlink.c       |   4 +-
 fs/xfs/xfs_xattr.c         |  20 ++++++-
 9 files changed, 244 insertions(+), 48 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
