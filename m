Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7C9C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 13:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878AF20738
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 13:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="huXfcTYc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgGGN6e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:58:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29898 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgGGN6d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 09:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594130312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=+wSPtysqp5eygsPtgm8Yotx8a3kQG1jD1lvu616hZ+4=;
        b=huXfcTYcGwdzK/Pxt7F/6FhCV3jUelC7py5FoIfwV2CiWZgz65gM5kWCk6Or0UkECcrGKP
        OUypMhceyxpxQsC7zIRohkVlWJRO3hPlyopyw11hBjn2iMieoRGkPMz155H9Mc6MrZLVON
        mkfzDYu+Ci8q1srmRDTFZe0Gim686xE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-nHRrrFmlPkahD8P2_0kZyw-1; Tue, 07 Jul 2020 09:58:31 -0400
X-MC-Unique: nHRrrFmlPkahD8P2_0kZyw-1
Received: by mail-pf1-f200.google.com with SMTP id b69so21413874pfb.14
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2020 06:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+wSPtysqp5eygsPtgm8Yotx8a3kQG1jD1lvu616hZ+4=;
        b=BGI5LY/0cETdJgb/GI1nugPeVpHQKeUhbAQAD0JVxIFnT/zy+bvKzOnfo0nAoI+ukw
         PJnJJOIkUq1PUB5DitkWQi52QCnHn5nHiamdM9kj2TGDhCvbLLkv3A9MAJqOZXhys0L9
         Cr8TehfMjIMDl5pMUIpFgx6Ly+IcHfk94vbPhbjWbzGz0ExKGLVVFwbIgd4633Ru04JK
         aSwadP1Ew1cY1MzzmFWD6ldeUUIH6xkv9ihZ5q0E9q+KsCcOtrbJNAph/69m9ybvptCB
         NVgWaL3HK+fjZ1CCOEBaQOl/mD+xsjj4zmJklnOE5TXx1kzOGuCs6hhhvZXhW15A39cE
         h6pw==
X-Gm-Message-State: AOAM5331plM3PbJ0zAlcLaLj10gOXOegvmtgLPR/1UevtaqhyhCs0/q6
        42jkIPPVGSqT193ujALxwVbBasOt6me3mY0lVv5Xx2eHk712bn0vRE3NJ72oNh+AE4Mjc0N4OJI
        5telInvDr8rTeazs2fXFZ
X-Received: by 2002:a17:90a:d086:: with SMTP id k6mr4141522pju.133.1594130309691;
        Tue, 07 Jul 2020 06:58:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzglWn73oG7rSiqBwt+OZXxSTKDrSv97CCRcujNeFM8E+I6V/wq26CXS4wGDRg3CWE2WdzZ2A==
X-Received: by 2002:a17:90a:d086:: with SMTP id k6mr4141494pju.133.1594130309396;
        Tue, 07 Jul 2020 06:58:29 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n18sm23247271pfd.99.2020.07.07.06.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:58:28 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH 1/2] xfs: arrange all unlinked inodes into one list
Date:   Tue,  7 Jul 2020 21:57:40 +0800
Message-Id: <20200707135741.487-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200707135741.487-1-hsiangkao@redhat.com>
References: <20200707135741.487-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no need to keep old multiple short unlink inode buckets
since we have an in-memory double linked list for all unlinked
inodes.

Apart from the perspective of the necessity, the main advantage
is that the log and AGI update can be reduced since each AG has
the only one head now, which is implemented in the following patch.

Therefore, this patch applies the new way in xfs_iunlink() and
keep the old approach in xfs_iunlink_remove_inode() path as well
so inode eviction can still work properly in recovery.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ab288424764c..10565fa5ace4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -33,6 +33,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_iunlink_item.h"
@@ -1955,25 +1956,32 @@ xfs_iunlink_update_bucket(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	struct xfs_buf		*agibp,
-	unsigned int		bucket_index,
+	xfs_agino_t		old_agino,
 	xfs_agino_t		new_agino)
 {
+	struct xlog		*log = tp->t_mountp->m_log;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		old_value;
-	int			offset;
+	unsigned int		bucket_index;
+	int                     offset;
 
 	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
 
+	bucket_index = 0;
+	/* During recovery, the old multiple bucket index can be applied */
+	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
+		ASSERT(old_agino != NULLAGINO);
+
+		if (be32_to_cpu(agi->agi_unlinked[0]) != old_agino)
+			bucket_index = old_agino % XFS_AGI_UNLINKED_BUCKETS;
+	}
+
 	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
 			old_value, new_agino);
 
-	/*
-	 * We should never find the head of the list already set to the value
-	 * passed in because either we're adding or removing ourselves from the
-	 * head of the list.
-	 */
-	if (old_value == new_agino) {
+	/* check if the old agi_unlinked head is as expected */
+	if (old_value != old_agino) {
 		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
@@ -2001,14 +2009,13 @@ xfs_iunlink_insert_inode(
 	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 
 	/*
 	 * Get the index into the agi hash table for the list this inode will
 	 * go on.  Make sure the pointer isn't garbage and that this inode
 	 * isn't already on the list.
 	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
@@ -2036,7 +2043,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
+	return xfs_iunlink_update_bucket(tp, agno, agibp, next_agino, agino);
 }
 
 /*
@@ -2051,27 +2058,20 @@ xfs_iunlink_remove_inode(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino = ip->i_next_unlinked;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
 	if (ip->i_prev_unlinked == NULLAGINO) {
 		/* remove from head of list */
-		if (be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino) {
-			xfs_buf_mark_corrupt(agibp);
-			return -EFSCORRUPTED;
-		}
 		if (next_agino == agino ||
 		    !xfs_verify_agino_or_null(mp, agno, next_agino))
 			return -EFSCORRUPTED;
 
-		error = xfs_iunlink_update_bucket(tp, agno, agibp,
-					bucket_index, next_agino);
+		error = xfs_iunlink_update_bucket(tp, agno, agibp, agino, next_agino);
 		if (error)
-			return -EFSCORRUPTED;
+			return error;
 	} else {
 		/* lookup previous inode and update to point at next */
 		struct xfs_inode	*pip;
-- 
2.18.1

