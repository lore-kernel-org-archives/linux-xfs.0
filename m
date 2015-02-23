Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 374BD7F67
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 09:51:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4CB6AC001
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 07:51:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wKstn9pNZ8sVAknc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 07:51:52 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1NFpphx025099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:52 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1NFppRS005489
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfsprogs: a couple metadump fixes and sb logging backports
Date: Mon, 23 Feb 2015 10:51:45 -0500
Message-Id: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
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

Patches 1 and 2 are a couple metadump fixes that fell out from playing
around with large block size filesystems (e.g., 64k on ppc64), similar
to the repair patches I had sent recently. Patches 3 and 4 are backports
of a couple of the sb logging rework fixes.

Dave,

I'm not sure what the workflow here is wrt to the sb logging backports.
FWIW, these are the only patches I need on top of the libxfs-3.19-update
branch to get most of the sparse inode bits to backport cleanly. Do you
want to include them in that branch? Otherwise, I'll just keep them in
my sparse inodes branch for now.

Brian

Brian Foster (4):
  metadump: include NULLFSINO check in inode copy code
  metadump: check for non-zero inode alignment
  xfsprogs: remove bitfield based superblock updates
  xfsprogs: consolidate superblock logging functions

 db/metadump.c                    |   3 +-
 db/sb.c                          |   9 +-
 libxfs/support/libxfs_api_defs.h |   2 +-
 libxfs/support/trans.c           |   2 +-
 libxfs/xfs_attr_leaf.c           |   2 +-
 libxfs/xfs_bmap.c                |  14 +-
 libxfs/xfs_sb.c                  | 286 ++++++++++++++-------------------------
 libxfs/xfs_sb.h                  |  11 +-
 libxfs/xfs_shared.h              |  33 ++---
 libxfs/xfs_trans_resv.c          |  14 --
 libxfs/xfs_trans_resv.h          |   1 -
 mdrestore/xfs_mdrestore.c        |   2 +-
 mkfs/proto.c                     |   6 +-
 mkfs/xfs_mkfs.c                  |   4 +-
 repair/phase5.c                  |   2 +-
 repair/sb.c                      |   2 +-
 repair/scan.c                    |   2 +-
 17 files changed, 144 insertions(+), 251 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
