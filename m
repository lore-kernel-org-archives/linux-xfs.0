Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4FC147F4E
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 14:36:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 300D2304053
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:36:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YYDvIPrDtbsyMlls (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 12:36:33 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t09KaXFS014563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 9 Jan 2015 15:36:33 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t09KaW16019176
	for <xfs@oss.sgi.com>; Fri, 9 Jan 2015 15:36:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: only reset sb_quotaino when both group/proj in-core inos
	are null
Date: Fri,  9 Jan 2015 15:36:31 -0500
Message-Id: <1420835791-26895-1-git-send-email-bfoster@redhat.com>
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

Several xfstests tests report disconnected quota inodes on the post-test
xfs_repair check on v4 filesystems. These include tests generic/232,
xfs/007, xfs/108 and xfs/199. This occurs due to the sb_gquotaino field
being reset to NULLFSINO when quota is not enabled. To reproduce:

	$ mkfs.xfs -f <dev>
	$ mount <dev> /mnt -o gquota; umount /mnt
	$ mount <dev> /mnt; umount /mnt
	$ xfs_repair -n <dev>
	...
	disconnected inode 131, would move to lost+found
	...

This problem was a regression due to pquotaino work and originally fixed
by the following commit:

	xfs: null unused quota inodes when quota is on

... and then reintroduced by the more recent work to kill per-field
superblock logging:

	xfs: remove bitfield based superblock updates

Fix it up again as it was fixed the first time. On v4 filesystems, only
reset the sb_quotaino field on-disk if both the in-core group and
project inode fields are null.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b440839..bacbb83 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -442,8 +442,16 @@ xfs_sb_quota_to_disk(
 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
 	else if (from->sb_qflags & XFS_PQUOTA_ACCT)
 		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
-	else
-		to->sb_gquotino = cpu_to_be64(NULLFSINO);
+	else {
+		/*
+		 * Only write NULLFSINO if quotas are not actually enabled.
+		 * Hence only write NULLFSINO if both in-core quota inodes are
+		 * NULL.
+		 */
+		if (from->sb_gquotino == NULLFSINO &&
+		    from->sb_pquotino == NULLFSINO)
+			to->sb_gquotino = cpu_to_be64(NULLFSINO);
+	}
 
 	to->sb_pquotino = 0;
 }
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
