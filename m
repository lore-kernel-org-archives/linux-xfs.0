Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99B9C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 17:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243696AbiBQRZk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:25:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243698AbiBQRZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 12:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D5A02B357C
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 09:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645118723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IwakkKXg+1+m/sECrlgsyD/fOQm0prk8CgYyuRENgyo=;
        b=BtlrhRCEJDkxoiFMuj2jc+AQct1Bf8/Rjwpza4yaXYXhD9FYz3FMlD/woPO43Xz8jNDOL7
        WUGf1xKWlX5YsQ8vkNvU6JfVJb3W+/Wyb8+bHQ4FhMAddMM0h3Maq9IMARZYn3ntCC2W+j
        gWPAQYiTJYuoUwhylu0PmXcjBwbwQDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-kFUmKbq-PS-_m5l3X_xoEQ-1; Thu, 17 Feb 2022 12:25:22 -0500
X-MC-Unique: kFUmKbq-PS-_m5l3X_xoEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D60F2F4A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:21 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF2A02DE6F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 4/4] xfs: skip busy inodes on finobt inode allocation
Date:   Thu, 17 Feb 2022 12:25:18 -0500
Message-Id: <20220217172518.3842951-5-bfoster@redhat.com>
In-Reply-To: <20220217172518.3842951-1-bfoster@redhat.com>
References: <20220217172518.3842951-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Experimental algorithm to skip busy inodes on finobt based inode
allocation. This is a first pass implementation intended primarily
for functional and performance experimentation. The logic is
intentionally kept simple to minimize the scope of changes required
to demonstrate functionality.

The existing finobt inode allocation algorithms are updated to
filter out records that are covered by at least one still-busy
inode[1] and continue scanning as appropriate based on the
allocation mode. For example, near allocation mode continues
scanning left and right until a usable record is found. newino mode
checks the target record and then scans from the first record in the
tree until a usable record is found. If the associated algorithm
cannot find a usable record, it falls back to new chunk allocation
to add non-busy inodes to the selection pool and restarts.

[1] As I write this, it occurs to me this logic could be further
improved to compare the first busy inode against the first free
inode in the record without disrupting the subsequent inode
selection logic.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 81 +++++++++++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 3eb41228e210..c79c85327cf4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1248,12 +1248,53 @@ xfs_dialloc_ag_inobt(
 	return error;
 }
 
+#define XFS_LOOKUP_BATCH	XFS_INODES_PER_CHUNK
+#define XFS_ICI_BUSY_TAG	2
+STATIC bool
+xfs_dialloc_ag_inobt_rec_busy(
+	struct xfs_perag		*pag,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	struct xfs_inode		*batch[XFS_LOOKUP_BATCH];
+	struct xfs_inode		*ip;
+	int				found, i;
+	xfs_agino_t			startino = rec->ir_startino;
+	bool				busy = false;
+	unsigned long			destroy_gp;
+
+	rcu_read_lock();
+	found = radix_tree_gang_lookup_tag(&pag->pag_ici_root, (void **) batch,
+					   startino, XFS_LOOKUP_BATCH,
+					   XFS_ICI_BUSY_TAG);
+	for (i = 0; i < found; i++) {
+		ip = batch[i];
+		spin_lock(&ip->i_flags_lock);
+		if (ip->i_ino >= startino + XFS_INODES_PER_CHUNK) {
+			spin_unlock(&ip->i_flags_lock);
+			break;
+		}
+		destroy_gp = ip->i_destroy_gp;
+		spin_unlock(&ip->i_flags_lock);
+
+		if (!poll_state_synchronize_rcu(destroy_gp)) {
+			busy = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	trace_printk("%d: agno %d startino 0x%x found %d busy %d caller %pS\n",
+		     __LINE__, pag->pag_agno, startino, found, busy,
+		     (void *) _RET_IP_);
+	return busy;
+}
+
 /*
  * Use the free inode btree to allocate an inode based on distance from the
  * parent. Note that the provided cursor may be deleted and replaced.
  */
 STATIC int
 xfs_dialloc_ag_finobt_near(
+	struct xfs_perag		*pag,
 	xfs_agino_t			pagino,
 	struct xfs_btree_cur		**ocur,
 	struct xfs_inobt_rec_incore	*rec)
@@ -1281,8 +1322,10 @@ xfs_dialloc_ag_finobt_near(
 		 * existence is enough.
 		 */
 		if (pagino >= rec->ir_startino &&
-		    pagino < (rec->ir_startino + XFS_INODES_PER_CHUNK))
-			return 0;
+		    pagino < (rec->ir_startino + XFS_INODES_PER_CHUNK)) {
+			if (!xfs_dialloc_ag_inobt_rec_busy(pag, rec))
+				return 0;
+		}
 	}
 
 	error = xfs_btree_dup_cursor(lcur, &rcur);
@@ -1306,6 +1349,21 @@ xfs_dialloc_ag_finobt_near(
 		error = -EFSCORRUPTED;
 		goto error_rcur;
 	}
+
+	while (i == 1 && xfs_dialloc_ag_inobt_rec_busy(pag, rec)) {
+		error = xfs_ialloc_next_rec(lcur, rec, &i, 1);
+		if (error)
+			goto error_rcur;
+		i = !i;
+	}
+
+	while (j == 1 && xfs_dialloc_ag_inobt_rec_busy(pag, &rrec)) {
+		error = xfs_ialloc_next_rec(rcur, &rrec, &j, 0);
+		if (error)
+			goto error_rcur;
+		j = !j;
+	}
+
 	if (i == 1 && j == 1) {
 		/*
 		 * Both the left and right records are valid. Choose the closer
@@ -1327,6 +1385,9 @@ xfs_dialloc_ag_finobt_near(
 	} else if (i == 1) {
 		/* only the left record is valid */
 		xfs_btree_del_cursor(rcur, XFS_BTREE_NOERROR);
+	} else {
+		error = -EAGAIN;
+		goto error_rcur;
 	}
 
 	return 0;
@@ -1342,6 +1403,7 @@ xfs_dialloc_ag_finobt_near(
  */
 STATIC int
 xfs_dialloc_ag_finobt_newino(
+	struct xfs_perag		*pag,
 	struct xfs_agi			*agi,
 	struct xfs_btree_cur		*cur,
 	struct xfs_inobt_rec_incore	*rec)
@@ -1360,7 +1422,8 @@ xfs_dialloc_ag_finobt_newino(
 				return error;
 			if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
 				return -EFSCORRUPTED;
-			return 0;
+			if (!xfs_dialloc_ag_inobt_rec_busy(pag, rec))
+				return 0;
 		}
 	}
 
@@ -1379,6 +1442,14 @@ xfs_dialloc_ag_finobt_newino(
 	if (XFS_IS_CORRUPT(cur->bc_mp, i != 1))
 		return -EFSCORRUPTED;
 
+	while (xfs_dialloc_ag_inobt_rec_busy(pag, rec)) {
+		error = xfs_ialloc_next_rec(cur, rec, &i, 0);
+		if (error)
+			return error;
+		if (i == 1)
+			return -EAGAIN;
+	}
+
 	return 0;
 }
 
@@ -1470,9 +1541,9 @@ xfs_dialloc_ag(
 	 * not, consider the agi hint or find the first free inode in the AG.
 	 */
 	if (pag->pag_agno == pagno)
-		error = xfs_dialloc_ag_finobt_near(pagino, &cur, &rec);
+		error = xfs_dialloc_ag_finobt_near(pag, pagino, &cur, &rec);
 	else
-		error = xfs_dialloc_ag_finobt_newino(agi, cur, &rec);
+		error = xfs_dialloc_ag_finobt_newino(pag, agi, cur, &rec);
 	if (error)
 		goto error_cur;
 
-- 
2.31.1

