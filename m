Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A4F87F37
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 14:15:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA892AC002
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0MU1rDjFdTEouBgI for
	<xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:22 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8JJFMRl022301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:22 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8JJFLfe009189
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/4] xfs: rework xfs_inactive()
Date: Thu, 19 Sep 2013 15:15:17 -0400
Message-Id: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
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

This set reworks the xfs_inactive() path with the intent to clean up the
transaction management overall. This is preparation work for the free
inode btree set and subsequent work in the area. The patches clean up
the remote symlink work, truncate work and ifree work respectively.

This passes through a quick xfstests run (with debug and lockdep)
without any major explosions. Thoughts appreciated.

Brian

v2:
- Cleaned up error handling throughout the set.
- Added inode locking to xfs_inactive_symlink().
- Added patch 4 to clean up xfs_inactive() after transaction management
  purge.

Brian Foster (4):
  xfs: push down inactive transaction mgmt for remote symlinks
  xfs: push down inactive transaction mgmt for truncate
  xfs: push down inactive transaction mgmt for ifree
  xfs: clean up xfs_inactive() error handling, kill
    VN_INACTIVE_[NO]CACHE

 fs/xfs/xfs_inode.c   | 241 +++++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_inode.h   |   2 +-
 fs/xfs/xfs_symlink.c |  81 ++++++++---------
 fs/xfs/xfs_symlink.h |   2 +-
 fs/xfs/xfs_vnode.h   |   8 --
 5 files changed, 174 insertions(+), 160 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
