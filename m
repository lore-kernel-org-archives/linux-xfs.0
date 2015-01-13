Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73D947F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:08:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53DD4304039
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:08:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FXa7Rvgd7s13CYn5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 12:08:17 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t0DK8FlQ026626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 15:08:16 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t0DK8Ecm012865
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 15:08:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] repair: fix unnecessary secondary scan if only last sb is
	corrupt
Date: Tue, 13 Jan 2015 15:08:12 -0500
Message-Id: <1421179693-17227-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1421179693-17227-1-git-send-email-bfoster@redhat.com>
References: <1421179693-17227-1-git-send-email-bfoster@redhat.com>
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

verify_set_primary_sb() scans the secondary superbocks based on the
geometry specified in the primary and determines the most likely correct
geometry by tracking how many superblocks are consistent across the set.
The most frequent geometry is copied into the primary superblock. The
return value is checked by the caller (phase1()) to determine whether a
brute force secondary scan is necessary.

This generally occurs when not enough secondary sb's are consistent to
declare the geometry correct. If enough secondaries are consistent,
verify_set_primary_sb() returns the status of the last secondary sb that
was scanned. Corruptions to secondary supers other than the last are
thus resolved fine. If the last secondary is corrupt, however, an error
is returned to phase1(). This causes a brute force scan even if enough
supers were found to repair the last secondary.

Move the initialization of retval to after the sb scan to return an
error only if not enough secondary supers were found to declare a
correct geometry.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/sb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index ad27756..dc154f7 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -724,7 +724,6 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 	 * sector size rather than the sector size in @rsb.
 	 */
 	size = NUM_AGH_SECTS * (1 << (XFS_MAX_SECTORSIZE_LOG));
-	retval = 0;
 	list = NULL;
 	num_ok = 0;
 	*sb_modified = 0;
@@ -779,6 +778,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 	/*
 	 * see if we have enough superblocks to bother with
 	 */
+	retval = 0;
 	if (num_ok < num_sbs / 2) {
 		retval = XR_INSUFF_SEC_SB;
 		goto out_free_list;
@@ -868,5 +868,5 @@ out_free_list:
 	free_geo(list);
 	free(sb);
 	free(checked);
-	return(retval);
+	return retval;
 }
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
