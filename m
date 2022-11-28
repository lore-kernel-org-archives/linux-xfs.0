Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A0AC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Nov 2022 17:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiK1RnO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 12:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiK1Rmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 12:42:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34577286EC
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 09:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669657182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eQPjuAtjowCpN/x3NgMEuvJ2bzg0KVPgoSLTrpqCfcA=;
        b=dn7XuDE5gw3cvbBJlknYnmWk2ZThPbMIjZUNzHvjCWfDMiBW8JbSRVkUcQ31OZ9IWIg+VA
        UuY8tWgyUKUnfjYvoGCg15tcOQElFm3LExcIgLuXn9ia5OeHfT9ZSIGLpau0E62FNz9I+h
        wAF8ZzLxmZ6+cNSrgVBovsjqGI6sgNs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-ukWMI1o2NGCZISvL_03dEg-1; Mon, 28 Nov 2022 12:39:40 -0500
X-MC-Unique: ukWMI1o2NGCZISvL_03dEg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C73B29AA3BB
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 17:39:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2321549BB60
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 17:39:40 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix broken truncate pre-size update flushing
Date:   Mon, 28 Nov 2022 12:39:45 -0500
Message-Id: <20221128173945.3953659-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pre-size update flush logic in xfs_setattr_size() has become
warped enough that it's difficult to surmise how it is actually
supposed to work. The original purpose of this flush is to mitigate
the "NULL file" problem when a truncate logs a size update before
preceding writes have been flushed and the fs happens to crash. This
code has seen several incremental changes since then that alter
behavior in potentially unexpected ways.

For context, the first in line is commit 5885ebda878b ("xfs: ensure
truncate forces zeroed blocks to disk"). This introduced the zeroing
check specifically for extending truncates and seems straightforward
enough of a change to accomplish that correctly.

Next, commit 68a9f5e7007c ("xfs: implement iomap based buffered
write path") switched over to iomap and introduced did_zeroing for
the truncate down case. This didn't change the flush range offsets,
however, which means partial post-eof zeroing on a truncate down may
only flush if the on disk inode size hadn't been updated to reflect
the in-core size at the start of the truncate.

Sometime after that, commit 350976ae2187 ("xfs: truncate pagecache
before writeback in xfs_setattr_size()") reordered the flush to
after the pagecache truncate to prevent a stale data exposure due to
iomap not zeroing properly. This failed to account for the fact that
pagecache truncate doesn't mark pages dirty and thus leaves the
filesystem responsible for on-disk consistency. Therefore, post-eof
data exposure was still possible if a dirty page was cleaned before
pagecache truncate. This also introduced an off by one issue for the
newsize == oldsize scenario which causes the flush to submit the EOF
page for I/O, but not actually wait on it if the offsets align to
the same page.

Finally, commit 869ae85dae64 ("xfs: flush new eof page on truncate
to avoid post-eof corruption") came along to address the
aforementioned stale data exposure race. This fails to account for
the same scenario on extending truncates, for one, but can also work
against the NULL file detection logic the flush was introduced to
mitigate the first place. This is because selectively flushing the
EOF block can update on-disk size before any preceding dirty data
may have been written back.

Since it is confusing enough to assess intent of the current code
and the various ways it might or might not be broken, this patch
just assumes we want to flush any combination of block zeroing or
previous I/O patterns deemed susceptible to the NULL file problem,
and then tries to do that correctly. Note that the EOF block flush
cannot be removed without reintroducing the data exposure race, but
that problem is mitigated by a separate patch that moves the flush
out of truncate and into iomap processing callbacks such that it is
no longer unconditional.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iops.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..39e9088cd32c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -785,6 +785,7 @@ xfs_setattr_size(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		oldsize, newsize;
+	loff_t			flushoff = LLONG_MAX;
 	struct xfs_trans	*tp;
 	int			error;
 	uint			lock_flags = 0;
@@ -880,17 +881,24 @@ xfs_setattr_size(
 	truncate_setsize(inode, newsize);
 
 	/*
-	 * We are going to log the inode size change in this transaction so
-	 * any previous writes that are beyond the on disk EOF and the new
-	 * EOF that have not been written out need to be written here.  If we
-	 * do not write the data out, we expose ourselves to the null files
-	 * problem. Note that this includes any block zeroing we did above;
-	 * otherwise those blocks may not be zeroed after a crash.
+	 * We are going to log the inode size change in this transaction so any
+	 * previous writes that are beyond the on disk EOF and the new EOF that
+	 * have not been written out need to be written here. If we do not write
+	 * the data out, we expose ourselves to the null files problem.
+	 *
+	 * To also cover block zeroing performed above, start with the lowest of
+	 * the old and new sizes to handle truncate up or down, and then factor
+	 * in ->i_disk_size if necessary. Since pagecache was truncated just
+	 * above, we don't need a precise end offset and can flush through the
+	 * end of the mapping.
 	 */
-	if (did_zeroing ||
-	    (newsize > ip->i_disk_size && oldsize != ip->i_disk_size)) {
-		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-						ip->i_disk_size, newsize - 1);
+	if (did_zeroing)
+		flushoff = min_t(loff_t, oldsize, newsize);
+	if (newsize > ip->i_disk_size && oldsize != ip->i_disk_size)
+		flushoff = min_t(loff_t, flushoff, ip->i_disk_size);
+	if (flushoff != LLONG_MAX) {
+		error = filemap_write_and_wait_range(inode->i_mapping, flushoff,
+						     LLONG_MAX);
 		if (error)
 			return error;
 	}
-- 
2.37.3

