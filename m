Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C59797F59
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 09:33:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B4B768F8039
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 07:33:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zw0lTU6QcDuw7nzO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 07:33:16 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 7BD8D2BB392
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 14:33:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t51EXFUh026119
	for <xfs@oss.sgi.com>; Mon, 1 Jun 2015 10:33:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: fix a couple post-merge sparse inode chunks issues
Date: Mon,  1 Jun 2015 10:33:12 -0400
Message-Id: <1433169194-41808-1-git-send-email-bfoster@redhat.com>
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

Here are a couple quick hitter fixes for sparse inodes. Patch 1 fixes a
compile failure detected by the kbuild robot with 32-bit configs. Patch
2 fixes a problem with the DEBUG mode random sparse inode chunk
allocation on large block size filesystems.

Brian

Brian Foster (2):
  xfs: fix sparse inodes 32-bit compile failure
  xfs: check min blks for random debug mode sparse allocations

 fs/xfs/libxfs/xfs_ialloc.c | 15 ++++++++-------
 fs/xfs/xfs_inode.c         |  2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
