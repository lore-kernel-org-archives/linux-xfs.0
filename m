Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02C057F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 01:02:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 040168F8040
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 23:02:31 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tTOxferb0dzdU5GD for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 23:02:30 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] repair: handle directory block corruption in phase 6
Date: Fri,  4 Jul 2014 15:57:12 +1000
Message-Id: <1404453435-1915-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1404453435-1915-1-git-send-email-david@fromorbit.com>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

This should only occur in no-modify mode, but when we fail to find
the last extent in a directory btree due to corruption we need to
trash the directory if it's the first data block we find the error
on. That is because there is nothing to recover from the directory,
and if we try to scan it xfs_reapir segv's because nothing has been
read from disk.

Also catch a memory allocation failure in this code, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 9b10f16..47ecad4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2179,7 +2179,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 	freetab = malloc(FREETAB_SIZE(ip->i_d.di_size / mp->m_dirblksize));
 	if (!freetab) {
 		do_error(
-		_("malloc failed in longform_dir2_entry_check (%" PRId64 " bytes)\n"),
+_("malloc failed in longform_dir2_entry_check (%" PRId64 " bytes)\n"),
 			FREETAB_SIZE(ip->i_d.di_size / mp->m_dirblksize));
 		exit(1);
 	}
@@ -2191,6 +2191,11 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 	}
 	num_bps = freetab->naents;
 	bplist = calloc(num_bps, sizeof(struct xfs_buf*));
+	if (!bplist)
+		do_error(
+_("calloc failed in longform_dir2_entry_check (%zu bytes)\n"),
+			num_bps * sizeof(struct xfs_buf*));
+
 	/* is this a block, leaf, or node directory? */
 	libxfs_dir2_isblock(NULL, ip, &isblock);
 	libxfs_dir2_isleaf(NULL, ip, &isleaf);
@@ -2203,8 +2208,18 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		int			 error;
 
 		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
-		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
+		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK)) {
+			/*
+			 * if this is the first block, there isn't anything we
+			 * can recover so we just trash it.
+			 */
+			 if (da_bno == 0) {
+				fixit++;
+				goto out_fix;
+			}
 			break;
+		}
+
 		db = xfs_dir2_da_to_db(mp, da_bno);
 		if (db >= num_bps) {
 			/* more data blocks than expected */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
