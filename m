Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 57D517F37
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 11:19:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E666AAC005
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 09:19:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gFqlmgfRzo0rflaD for
	<xfs@oss.sgi.com>; Wed, 18 Sep 2013 09:19:54 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8IGJlST027371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 12:19:53 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8IGAU6i022372
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 12:10:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/3] xfs: rework xfs_inactive()
Date: Wed, 18 Sep 2013 12:15:57 -0400
Message-Id: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
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

Brian Foster (3):
  xfs: push down inactive transaction mgmt for remote symlinks
  xfs: push down inactive transaction mgmt for truncate
  xfs: push down inactive transaction mgmt for ifree

 fs/xfs/xfs_inode.c   | 212 ++++++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_symlink.c |  64 ++++++----------
 fs/xfs/xfs_symlink.h |   2 +-
 3 files changed, 147 insertions(+), 131 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
