Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39EDFA3741
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 13:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJ1NFZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 09:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiJ1NFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 09:05:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5631CF568
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 06:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666962259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bljpRyn6TFqr866poR8rmihslATX8outKaBMzz9eLSk=;
        b=fZtf+VBj8RWQkyBk510GcnylwagidFZqD8KAumPOACoCXj9ZIBdk5RlA+IYdpCiiR16L5l
        lYKUKmLQ+N1T9lga+SA25R1Lkt+NSBjYBRu0eXUSAGbAT/28vXmqe30S6RPjTb0gJBb1Nz
        W6/QQ3It/zDpDc9eHJWJ0M2cXFpCZ/s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-PLeSqzOCMxCbx_yUWcFlIQ-1; Fri, 28 Oct 2022 09:04:17 -0400
X-MC-Unique: PLeSqzOCMxCbx_yUWcFlIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57553857D10
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:04:07 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 650A340C9567
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:04:05 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 1/2] xfs: lift truncate iomap zeroing into a new helper
Date:   Fri, 28 Oct 2022 09:04:10 -0400
Message-Id: <20221028130411.977076-2-bfoster@redhat.com>
In-Reply-To: <20221028130411.977076-1-bfoster@redhat.com>
References: <20221028130411.977076-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Create a new helper to improve readability of subsequent changes in
this area of code. No functional change is intended, but while here,
also change the end offset of the flush to use newsize - 1. This off
by one should have no impact on cases where the flush is relevant
because zeroing only occurs when the size is non-block aligned.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iops.c | 52 +++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..d31e64db243f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -770,6 +770,39 @@ xfs_setattr_nonsize(
 	return error;
 }
 
+/*
+ * Do the appropriate zeroing for a particular truncate operation. This zeroes
+ * the range of blocks between oldsize and newsize on a truncate up or otherwise
+ * partially zeroes the post-EOF portion of the EOF block at newsize.
+ */
+static int
+xfs_truncate_zeroing(
+	struct xfs_inode	*ip,
+	xfs_off_t		oldsize,
+	xfs_off_t		newsize,
+	bool			*did_zeroing)
+{
+	int			error;
+
+	if (newsize > oldsize) {
+		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
+		return xfs_zero_range(ip, oldsize, newsize - oldsize,
+				did_zeroing);
+	}
+
+	/*
+	 * iomap won't detect a dirty page over an unwritten block (or a cow
+	 * block over a hole) and subsequently skips zeroing the newly post-EOF
+	 * portion of the page. Flush the new EOF to convert the block before
+	 * the pagecache truncate.
+	 */
+	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping, newsize - 1,
+					     newsize - 1);
+	if (error)
+		return error;
+	return xfs_truncate_page(ip, newsize, did_zeroing);
+}
+
 /*
  * Truncate file.  Must have write permission and not be a directory.
  *
@@ -835,24 +868,7 @@ xfs_setattr_size(
 	 * extension, or zeroing out the rest of the block on a downward
 	 * truncate.
 	 */
-	if (newsize > oldsize) {
-		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
-		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
-				&did_zeroing);
-	} else {
-		/*
-		 * iomap won't detect a dirty page over an unwritten block (or a
-		 * cow block over a hole) and subsequently skips zeroing the
-		 * newly post-EOF portion of the page. Flush the new EOF to
-		 * convert the block before the pagecache truncate.
-		 */
-		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
-						     newsize);
-		if (error)
-			return error;
-		error = xfs_truncate_page(ip, newsize, &did_zeroing);
-	}
-
+	error = xfs_truncate_zeroing(ip, oldsize, newsize, &did_zeroing);
 	if (error)
 		return error;
 
-- 
2.37.3

