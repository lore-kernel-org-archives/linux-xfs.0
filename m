Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67BD87F37
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 10:06:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B6C48F8074
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 08:06:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GdTWZ4WQXu4IRwfl for
	<xfs@oss.sgi.com>; Fri, 20 Sep 2013 08:06:15 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8KF6FSM010630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 11:06:15 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8KF6Ex1025154
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 11:06:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/4] xfs: rework xfs_inactive()
Date: Fri, 20 Sep 2013 11:06:08 -0400
Message-Id: <1379689572-5543-1-git-send-email-bfoster@redhat.com>
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

v3:
- Error handling fixes: cancel transaction before iunlock.
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
 fs/xfs/xfs_symlink.c |  86 +++++++++---------
 fs/xfs/xfs_symlink.h |   2 +-
 fs/xfs/xfs_vnode.h   |   8 --
 5 files changed, 180 insertions(+), 159 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
