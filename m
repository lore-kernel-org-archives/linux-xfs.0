Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F745C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F7F613B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbhDEO7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:59:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235835AbhDEO7T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 10:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617634752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RuodbMAMgMz9kDK6tYXejMKh1hxuIRRmUof5LkZSzAo=;
        b=Cfs4PmIG6nhj7OrvQX8i2IePeJAv2s/aansy59NmGh70Smb32MfQsv0uSaMZu5d55sXmTi
        qhGzu25yJpliutK/S/kWz7bchE6Mxi4Y0c7G3q/h26fh1hOhNv6rcKdZuj6fFv/OlbOuGE
        KcCML59Hh5SDSTCs2l3QsPV6chkOiWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-E-fTqlXWO3Gy2IHAgJVtqQ-1; Mon, 05 Apr 2021 10:59:11 -0400
X-MC-Unique: E-fTqlXWO3Gy2IHAgJVtqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7971801971
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:04 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77B645D749
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: drop submit side trans alloc for append ioends
Date:   Mon,  5 Apr 2021 10:59:00 -0400
Message-Id: <20210405145903.629152-2-bfoster@redhat.com>
In-Reply-To: <20210405145903.629152-1-bfoster@redhat.com>
References: <20210405145903.629152-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
---
 fs/xfs/xfs_aops.c | 45 +++------------------------------------------
 1 file changed, 3 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1cc7c36d98e9..c1951975bd6a 100644
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
@@ -182,12 +155,10 @@ xfs_end_ioend(
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
-	else
-		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
 
 done:
-	if (ioend->io_private)
-		error = xfs_setfilesize_ioend(ioend, error);
+	if (!error && xfs_ioend_is_append(ioend))
+		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -237,7 +208,7 @@ xfs_end_io(
 
 static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
 {
-	return ioend->io_private ||
+	return xfs_ioend_is_append(ioend) ||
 		ioend->io_type == IOMAP_UNWRITTEN ||
 		(ioend->io_flags & IOMAP_F_SHARED);
 }
@@ -250,8 +221,6 @@ xfs_end_bio(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	unsigned long		flags;
 
-	ASSERT(xfs_ioend_needs_workqueue(ioend));
-
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	if (list_empty(&ip->i_ioend_list))
 		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
@@ -501,14 +470,6 @@ xfs_prepare_ioend(
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
2.26.3

