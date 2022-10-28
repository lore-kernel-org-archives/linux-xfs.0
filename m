Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F796C38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 13:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiJ1NMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiJ1NMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 09:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C001C25CE
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 06:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666962665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LcNC7YWA4uLE8BL09yke7JBHW+XjW4WLFzWcInIwnTk=;
        b=LLGkORzCXzXp/me8TGcXvnS6Ql1XK0GVuvABgXb3IhcV4FUWstXQIqkvivvreiPDrkUPRN
        DHsfIgLiqsx0sSDw+3eCz7j1Da4Sv+0WW+nzSLdrn6CB4WJQ3WVrPpzoW6Bzuke5eBBKPV
        AqD+h3OWHm0iXHohNQvtlNZkHqZT/5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-FvC8k1XqM82rwA7DV2BsCQ-1; Fri, 28 Oct 2022 09:11:03 -0400
X-MC-Unique: FvC8k1XqM82rwA7DV2BsCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F42B185A79C
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:11:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75FBF40C6EC3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:11:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Date:   Fri, 28 Oct 2022 09:11:09 -0400
Message-Id: <20221028131109.977581-1-bfoster@redhat.com>
In-Reply-To: <20221028130411.977076-1-bfoster@redhat.com>
References: <20221028130411.977076-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's a quick prototype of "option 3" described in my previous mail.
This has been spot tested and confirmed to prevent the original stale
data exposure problem. More thorough regression testing is still
required. Barring unforeseen issues with that, however, I think this is
tentatively my new preferred option. The primary reason for that is it
avoids looking at extent state and is more in line with what iomap based
zeroing should be doing more generically.

Because of that, I think this provides a bit more opportunity for follow
on fixes (there are other truncate/zeroing problems I've come across
during this investigation that still need fixing), cleanup and
consolidation of the zeroing code. For example, I think the trajectory
of this could look something like:

- Genericize a bit more to handle all truncates.
- Repurpose iomap_truncate_page() (currently only used by XFS) into a
  unique implementation from zero range that does explicit zeroing
  instead of relying on pagecache truncate.
- Refactor XFS ranged zeroing to an abstraction that uses a combination
  of iomap_zero_range() and the new iomap_truncate_page().

From there we'd hopefully have predictable and functionally correct
zeroing in the filesystem. The next step would probably be to see if/how
the truncate page and zero range implementations could combine into a
single zero range implementation. I have vague thoughts on that, but at
this stage I'm not going too deep into how that should look without some
sort of functional implementation to base it on.

Brian

 fs/xfs/xfs_iops.c | 49 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..1679fafaec6f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -784,11 +784,13 @@ xfs_setattr_size(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	struct folio		*eof_folio = NULL;
 	xfs_off_t		oldsize, newsize;
 	struct xfs_trans	*tp;
 	int			error;
 	uint			lock_flags = 0;
 	bool			did_zeroing = false;
+	bool			eof_dirty;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
@@ -841,20 +843,40 @@ xfs_setattr_size(
 				&did_zeroing);
 	} else {
 		/*
-		 * iomap won't detect a dirty page over an unwritten block (or a
-		 * cow block over a hole) and subsequently skips zeroing the
-		 * newly post-EOF portion of the page. Flush the new EOF to
-		 * convert the block before the pagecache truncate.
+		 * iomap won't detect a dirty folio over an unwritten block (or
+		 * a cow block over a hole) and subsequently skips zeroing the
+		 * newly post-EOF portion of the folio. Doing a flush here (i.e.
+		 * as is done for fallocate ZERO_RANGE) updates extent state for
+		 * iomap, but has too much overhead for the truncate path.
+		 *
+		 * Instead, check whether the new EOF is dirty in pagecache. If
+		 * so, hold a reference across the pagecache truncate and dirty
+		 * the folio. This ensures that partial folio zeroing from the
+		 * truncate makes it to disk in the rare event that iomap skips
+		 * zeroing and writeback happens to complete before the
+		 * pagecache truncate. Note that this really should be handled
+		 * properly by iomap zero range.
 		 */
-		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
-						     newsize);
-		if (error)
-			return error;
+		eof_folio = filemap_lock_folio(inode->i_mapping,
+					(newsize - 1) >> PAGE_SHIFT);
+		if (eof_folio) {
+			if (folio_test_dirty(eof_folio) ||
+			    folio_test_writeback(eof_folio))
+				eof_dirty = true;
+			folio_unlock(eof_folio);
+			if (!eof_dirty) {
+				folio_put(eof_folio);
+				eof_folio = NULL;
+			}
+		}
 		error = xfs_truncate_page(ip, newsize, &did_zeroing);
 	}
 
-	if (error)
+	if (error) {
+		if (eof_folio)
+			folio_put(eof_folio);
 		return error;
+	}
 
 	/*
 	 * We've already locked out new page faults, so now we can safely remove
@@ -878,6 +900,15 @@ xfs_setattr_size(
 	 * guaranteed not to write stale data past the new EOF on truncate down.
 	 */
 	truncate_setsize(inode, newsize);
+	if (eof_folio) {
+		trace_printk("%d: ino 0x%llx newsize 0x%llx folio idx 0x%lx did_zeroing %d\n",
+			__LINE__, ip->i_ino, newsize, folio_index(eof_folio), did_zeroing);
+		if (!did_zeroing) {
+			filemap_dirty_folio(inode->i_mapping, eof_folio);
+			did_zeroing = true;
+		}
+		folio_put(eof_folio);
+	}
 
 	/*
 	 * We are going to log the inode size change in this transaction so
-- 
2.37.3

