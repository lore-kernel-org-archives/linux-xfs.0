Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 339BE7F7E
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 13:03:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1193E304064
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 11:03:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id j0fgvJV3KT8cz9pu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 11:03:21 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id F19B9ABB37
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 18:03:20 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t76HiYad032227
	for <xfs@oss.sgi.com>; Thu, 6 Aug 2015 13:44:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 04/11] xfs: ensure EFD trans aborts on log recovery extent
	free failure
Date: Thu,  6 Aug 2015 13:44:25 -0400
Message-Id: <1438883072-28706-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
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

Log recovery attempts to free extents with leftover EFIs in the AIL
after initial processing. If the extent free fails (e.g., due to
unrelated fs corruption), the transaction is cancelled, though it might
not be dirtied at the time. If this is the case, the EFD does not abort
and thus does not release the EFI. This can lead to hangs as the EFI
pins the AIL.

Update xlog_recover_process_efi() to log the EFD in the transaction
before xfs_free_extent() errors are handled to ensure the transaction is
dirty, aborts the EFD and releases the EFI on error. This is consistent
with how EFDs are handled at runtime in xfs_bmap_finish().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9d8f242..3433b7b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3779,11 +3779,16 @@ xlog_recover_process_efi(
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
+		/*
+		 * Log the EFD before error handling to ensure the EFD aborts
+		 * (and releases the EFI) on error.
+		 */
 		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
-		if (error)
-			goto abort_error;
 		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
 					 extp->ext_len);
+		if (error)
+			goto abort_error;
+
 	}
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
