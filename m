Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3A2C38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 13:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiJ1NFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 09:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiJ1NFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 09:05:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04E31C8827
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 06:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666962250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAoBOQdboEgt4DT/StJPABS1zauUSE6g6Zt8AugoUtc=;
        b=e2EHy5D6wFMBFKym43cmHuP3wZ49PY0wCnbuxl2I6VLqmnMqezt5wPdg0DjVHxMKN8f1VX
        naSHPHImkhNTa2VaEA2PyiHSHQRWGjMRc1iTc5ckYHkE7020hCaQR8j5y2VnjT6XwbW4TP
        H8mmmBHlhowUaVNKaVPxsljhYrFuapM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-gL0YoVbHMhyFycIcqzMVNg-1; Fri, 28 Oct 2022 09:04:08 -0400
X-MC-Unique: gL0YoVbHMhyFycIcqzMVNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95B5F1871DA8
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:04:07 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B83540C9568
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:04:05 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 2/2] xfs: optimize eof page flush for iomap zeroing on truncate
Date:   Fri, 28 Oct 2022 09:04:11 -0400
Message-Id: <20221028130411.977076-3-bfoster@redhat.com>
In-Reply-To: <20221028130411.977076-1-bfoster@redhat.com>
References: <20221028130411.977076-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The flush that occurs just before xfs_truncate_page() during a
non-extending truncate exists to avoid potential stale data exposure
problems when iomap zeroing might be racing with buffered writes
over unwritten extents. However, we've had reports of this causing
significant performance regressions on overwrite workloads where the
flush serves no correctness purpose. For example, the uuidd
mechanism stores time metadata to a file on every generation
sequence. This involves a buffered (over)write followed by a
truncate of the file to its current size. If these uuids are used as
transaction IDs for a database application, then overall performance
can suffer tremendously by the repeated flushing on every truncate.

To avoid this problem, update the truncate path to only flush in
scenarios that are known to conflict with iomap zeroing. iomap skips
zeroing when it sees a hole or unwritten extent, so this essentially
means the filesystem should flush if either of those scenarios have
outstanding dirty pagecache and can skip the flush otherwise.

The ideal longer term solution here is to avoid the need to flush
entirely and allow the zeroing to detect a dirty page and zero it
accordingly, but this is a bit more involved in that it may involve
the iomap interface. The purpose of this change is therefore to
prioritize addressing the performance regression in a straightfoward
enough manner that it can be separated from further improvements.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iops.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d31e64db243f..37f78117557e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -782,7 +782,15 @@ xfs_truncate_zeroing(
 	xfs_off_t		newsize,
 	bool			*did_zeroing)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	struct xfs_ifork	*ifp = ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	xfs_off_t		end;
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSBT(mp, newsize);
 	int			error;
+	bool			found;
 
 	if (newsize > oldsize) {
 		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
@@ -790,16 +798,40 @@ xfs_truncate_zeroing(
 				did_zeroing);
 	}
 
+	/*
+	 * No zeroing occurs if newsize is block aligned (or zero). The eof page
+	 * is partially zeroed by the pagecache truncate, if necessary, and
+	 * post-eof blocks are removed.
+	 */
+	if ((newsize & (i_blocksize(inode) - 1)) == 0)
+		return 0;
+
 	/*
 	 * iomap won't detect a dirty page over an unwritten block (or a cow
 	 * block over a hole) and subsequently skips zeroing the newly post-EOF
-	 * portion of the page. Flush the new EOF to convert the block before
-	 * the pagecache truncate.
+	 * portion of the page. To ensure proper zeroing occurs, flush the eof
+	 * page if it is dirty and backed by a hole or unwritten extent in the
+	 * data fork. This ensures that iomap sees the eof block in a state that
+	 * warrants zeroing.
+	 *
+	 * This should eventually be handled in iomap processing so we don't
+	 * have to flush at all. We do it here for now to avoid the additional
+	 * latency in cases where it's not absolutely required.
 	 */
-	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping, newsize - 1,
-					     newsize - 1);
-	if (error)
-		return error;
+	end = newsize - 1;
+	if (filemap_range_needs_writeback(inode->i_mapping, end, end)) {
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		found = xfs_iext_lookup_extent(ip, ifp, end_fsb, &icur, &got);
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+		if (!found || got.br_startoff > end_fsb ||
+		    got.br_state == XFS_EXT_UNWRITTEN) {
+			error = filemap_write_and_wait_range(inode->i_mapping,
+					end, end);
+			if (error)
+				return error;
+		}
+	}
 	return xfs_truncate_page(ip, newsize, did_zeroing);
 }
 
-- 
2.37.3

