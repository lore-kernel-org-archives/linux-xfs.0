Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9D437F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 09:51:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B6DE38F8039
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 07:51:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Oby1WmPrkLOsRAkX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 07:51:52 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1NFppTg009422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:51 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1NFpplK006897
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] metadump: check for non-zero inode alignment
Date: Mon, 23 Feb 2015 10:51:47 -0500
Message-Id: <1424706709-21594-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
References: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
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

The copy_inode_chunk() function performs some basic sanity checks on the
inode record, block number, etc. One of these checks includes whether
the inode chunk is aligned according to sb_inoalignmt. sb_inoalignment
can equal 0 with larger block sizes. This results in a mod-by-zero,
"badly aligned inode ..." warnings and skipped inodes in metadump
images. This can be reproduced with a '-m crc=1,finobt=1 -b size=64k' fs
on ppc64.

Update copy_inode_chunk() to only enforce the inode alignment check when
sb_inoalignmt is non-zero.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/metadump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/db/metadump.c b/db/metadump.c
index 604fcf4..94f92bc 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1865,6 +1865,7 @@ copy_inode_chunk(
 			(mp->m_sb.sb_inopblock > XFS_INODES_PER_CHUNK &&
 					off % XFS_INODES_PER_CHUNK != 0) ||
 			(xfs_sb_version_hasalign(&mp->m_sb) &&
+					mp->m_sb.sb_inoalignmt != 0 &&
 					agbno % mp->m_sb.sb_inoalignmt != 0)) {
 		if (show_warnings)
 			print_warning("badly aligned inode (start = %llu)",
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
