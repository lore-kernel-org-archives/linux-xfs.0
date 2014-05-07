Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A47227F4E
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A46FAC00A
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:22:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pG8mWpyG582UKfhW for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 05:22:02 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47CM15C004818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:02 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s47CM1we025677
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 13/20] xfsprogs/repair: account for finobt in ag 0 geometry
	pre-calculation
Date: Wed,  7 May 2014 08:21:52 -0400
Message-Id: <1399465319-65066-14-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
References: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
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

Account for the finobt in calc_mkfs().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 08b25f0..9eb2fa4 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -399,14 +399,18 @@ calc_mkfs(xfs_mount_t *mp)
 	do_inoalign = mp->m_sinoalign;
 
 	/*
-	 * pre-calculate geometry of ag 0.  We know what it looks
-	 * like because we know what mkfs does -- 3 btree roots,
-	 * and some number of blocks to prefill the agfl.
+	 * Pre-calculate the geometry of ag 0. We know what it looks like
+	 * because we know what mkfs does: 2 allocation btree roots (by block
+	 * and by size), the inode allocation btree root, the free inode
+	 * allocation btree root (if enabled) and some number of blocks to
+	 * prefill the agfl.
 	 */
 	bnobt_root = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
 	bcntbt_root = bnobt_root + 1;
 	inobt_root = bnobt_root + 2;
 	fino_bno = inobt_root + XFS_MIN_FREELIST_RAW(1, 1, mp) + 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		fino_bno++;
 
 	/*
 	 * If the log is allocated in the first allocation group we need to
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
