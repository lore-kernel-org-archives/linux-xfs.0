Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7948E7F37
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2015 10:06:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 608728F8033
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2015 08:06:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EKrOlNd3aZF46E44 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Mar 2015 08:06:37 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2RF6bHg019447
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 27 Mar 2015 11:06:37 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t2RF6a83028543
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2015 11:06:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] db/check: handle zero inoalignmt correctly for large block
	sizes
Date: Fri, 27 Mar 2015 11:06:35 -0400
Message-Id: <1427468795-49219-1-git-send-email-bfoster@redhat.com>
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

The check command prints a spurious error when sb_inoalignmt is zero but
the sb align feature bit is set:

$ mkfs.xfs -f -bsize=16k <dev>
$ xfs_db -c "check" <dev>
sb versionnum extra align bit 80

This occurs because check determines whether to expect the alignment
feature bit based on a non-zero inoalignmt (in init()). sb_inoalignmt of
0 is expected for block sizes that are large enough for at least one
full inode record (64 inodes), however. For example, when bsize >= 16k
on v4 filesystems or >=32k on v5 filesystems.

Update the init() logic in the check command to detect this particular
scenario. Set the in-memory feature bit if inoalignmt is zero and the
block size is large enough for full inode records such that blockget_f()
does not complain.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/check.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/db/check.c b/db/check.c
index 4fd9fd0..c4c972f 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1832,7 +1832,13 @@ init(
 	error = sbver_err = serious_error = 0;
 	fdblocks = frextents = icount = ifree = 0;
 	sbversion = XFS_SB_VERSION_4;
-	if (mp->m_sb.sb_inoalignmt)
+	/*
+	 * Note that inoalignmt == 0 is valid when fsb size is large enough for
+	 * at least one full inode record per block. Check this case explicitly.
+	 */
+	if (mp->m_sb.sb_inoalignmt ||
+	    (xfs_sb_version_hasalign(&mp->m_sb) &&
+	     mp->m_sb.sb_inopblock >= XFS_INODES_PER_CHUNK))
 		sbversion |= XFS_SB_VERSION_ALIGNBIT;
 	if ((mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO) ||
 	    (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO) ||
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
