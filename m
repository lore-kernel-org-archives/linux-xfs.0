Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F02C6FD18
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 04:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDSEdK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 00:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDSEdJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 00:33:09 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64DB6EAF
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 21:33:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id eo4-20020a05600c82c400b003f05a99a841so777683wmb.3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 21:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681878786; x=1684470786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f5Db4dGL+4C5nlcUB4dOyP6cfF37dTGP+VFo4ClofGE=;
        b=fGrM/oclRjsz1rtFFChYKAP9qAPc24iY8+CO9fly1Ah2F4sPdYnQ1x3l1UVPLhfU3L
         QX2sAhzp6Ab0W2S8WA3+RqHUJRqLvLI1szVJe6Spwt/yRTbX5QFKp/bVd9o4rtDI3Apg
         P46c4OezUZTWVu/Xoi6f1RnmGwb2FoePzPlQ8LcQCSCbgIBz/7Qt5woXLdfPkFmdy4br
         FE6UO/EY1JPPJUjFCUxiomaIeIY9vsXj+3/1l0yEw1yKAD4/Gqo7synS0q1vKTtCtx98
         21MH2/I/ABjHF879+oil+wPEg+2n7Q/UU8HBzMCPYBy3rcPEuZmrB4XmA/71LpHW5Tus
         hwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681878786; x=1684470786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f5Db4dGL+4C5nlcUB4dOyP6cfF37dTGP+VFo4ClofGE=;
        b=ArbORc5wUJC1LMcU+izYdHFROL5IU587vRTX85kzWOChpdNIkolxZF1oUyjZamEvHT
         vEAGa2b1MVSLOW8n6m6KIu8tyCQbwASI5dQxA+1K5kL2vwc17pqC6qGr7INGxxxLQOag
         yatAPyvECEzaXvWbZA0jpoPalb86ajHZt+4A9zOTkqiVpjKRhJyMH8NyZUKNZaYtx3VJ
         72siz/pbK4ERJzFiCyZyuf2dm9pmajdMfKwFe4PdDmV0eVNugv0M6lXRpIDdOpr4lohK
         e7UzohLopX2KnbKZoZ1/o5+vXUU7Yyj4UacdWYCuBF56o9bxy5JY9c4FAGw+4gdAk1sx
         J4iQ==
X-Gm-Message-State: AAQBX9ewrfocELV7A34lOtjtmKaTyXC7k/mjbEA9F6cyDZ5LfITP4qtf
        rtLhI+RATRymuhLMs9Ud6Js=
X-Google-Smtp-Source: AKy350aufTatpkNZ4V6ZXsSjL9DxhAtgZHsFUx+rRDQdpPtVrRgp0kPkpNkTnm9ty1b6q5E/Ifb2UA==
X-Received: by 2002:a05:600c:b58:b0:3f1:72f2:25cb with SMTP id k24-20020a05600c0b5800b003f172f225cbmr7800446wmr.9.1681878785462;
        Tue, 18 Apr 2023 21:33:05 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t12-20020a5d460c000000b002c561805a4csm14596792wrq.45.2023.04.18.21.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:33:05 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Christian Theune <ct@flyingcircus.io>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 CANDIDATE] xfs: drop submit side trans alloc for append ioends
Date:   Wed, 19 Apr 2023 07:32:59 +0300
Message-Id: <20230419043259.2026839-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 7cd3099f4925d7c15887d1940ebd65acd66100f5 upstream.

Per-inode ioend completion batching has a log reservation deadlock
vector between preallocated append transactions and transactions
that are acquired at completion time for other purposes (i.e.,
unwritten extent conversion or COW fork remaps). For example, if the
ioend completion workqueue task executes on a batch of ioends that
are sorted such that an append ioend sits at the tail, it's possible
for the outstanding append transaction reservation to block
allocation of transactions required to process preceding ioends in
the list.

Append ioend completion is historically the common path for on-disk
inode size updates. While file extending writes may have completed
sometime earlier, the on-disk inode size is only updated after
successful writeback completion. These transactions are preallocated
serially from writeback context to mitigate concurrency and
associated log reservation pressure across completions processed by
multi-threaded workqueue tasks.

However, now that delalloc blocks unconditionally map to unwritten
extents at physical block allocation time, size updates via append
ioends are relatively rare. This means that inode size updates most
commonly occur as part of the preexisting completion time
transaction to convert unwritten extents. As a result, there is no
longer a strong need to preallocate size update transactions.

Remove the preallocation of inode size update transactions to avoid
the ioend completion processing log reservation deadlock. Instead,
continue to send all potential size extending ioends to workqueue
context for completion and allocate the transaction from that
context. This ensures that no outstanding log reservation is owned
by the ioend completion worker task when it begins to process
ioends.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Christian Theune <ct@flyingcircus.io>
Link: https://lore.kernel.org/linux-xfs/CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Darrick,

As I wrote in $LINK, this fix from v5.13 was missed from my backports
due to a tool error.

It's also in good timeing because Chandan has just finished the v5.12
backports.

I ran it though 10 kdevops cycles.

Please approve.

Thanks,
Amir.

 fs/xfs/xfs_aops.c | 45 +++------------------------------------------
 1 file changed, 3 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 953de843d9c3..e341d6531e68 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -39,33 +39,6 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 		XFS_I(ioend->io_inode)->i_d.di_size;
 }
 
-STATIC int
-xfs_setfilesize_trans_alloc(
-	struct iomap_ioend	*ioend)
-{
-	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	ioend->io_private = tp;
-
-	/*
-	 * We may pass freeze protection with a transaction.  So tell lockdep
-	 * we released it.
-	 */
-	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
-	/*
-	 * We hand off the transaction to the completion thread now, so
-	 * clear the flag here.
-	 */
-	xfs_trans_clear_context(tp);
-	return 0;
-}
-
 /*
  * Update on-disk file size now that data has been written to disk.
  */
@@ -191,12 +164,10 @@ xfs_end_ioend(
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
-	else
-		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
 
+	if (!error && xfs_ioend_is_append(ioend))
+		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 done:
-	if (ioend->io_private)
-		error = xfs_setfilesize_ioend(ioend, error);
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -246,7 +217,7 @@ xfs_end_io(
 
 static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
 {
-	return ioend->io_private ||
+	return xfs_ioend_is_append(ioend) ||
 		ioend->io_type == IOMAP_UNWRITTEN ||
 		(ioend->io_flags & IOMAP_F_SHARED);
 }
@@ -259,8 +230,6 @@ xfs_end_bio(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	unsigned long		flags;
 
-	ASSERT(xfs_ioend_needs_workqueue(ioend));
-
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	if (list_empty(&ip->i_ioend_list))
 		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
@@ -510,14 +479,6 @@ xfs_prepare_ioend(
 				ioend->io_offset, ioend->io_size);
 	}
 
-	/* Reserve log space if we might write beyond the on-disk inode size. */
-	if (!status &&
-	    ((ioend->io_flags & IOMAP_F_SHARED) ||
-	     ioend->io_type != IOMAP_UNWRITTEN) &&
-	    xfs_ioend_is_append(ioend) &&
-	    !ioend->io_private)
-		status = xfs_setfilesize_trans_alloc(ioend);
-
 	memalloc_nofs_restore(nofs_flag);
 
 	if (xfs_ioend_needs_workqueue(ioend))
-- 
2.34.1

