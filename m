Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D428AC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 21:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAE3520709
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 21:43:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g44pTDef"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgENVnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 17:43:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727029AbgENVnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 17:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589492620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RWnGiUlfVU+0dG/DrAFstyChF3OtB7CKO02ualxqtWE=;
        b=g44pTDefdsojXCvWqWfGxrHfZtuAuuUnmXabYlJ9z7Mw4RlOApXWk8WWMH9leeuejIUa81
        EUTcgjR3i3SJeRdfxVU50BYHYWuHsNxGVUFZV4bF7gG4sKAnv2ZUCD5rM1IAYHffBM5QDt
        K4UYS1dx18RzudFtTgxF7qfk4jx5PnI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-o12D95x7O-yHrX8D0IJGgQ-1; Thu, 14 May 2020 17:43:38 -0400
X-MC-Unique: o12D95x7O-yHrX8D0IJGgQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4399801503
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2020 21:43:37 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BE8A5C1BE
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2020 21:43:37 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFCRAP] xfs: handle ENOSPC quota return in
 xfs_file_buffered_aio_write
Message-ID: <e6b9090b-722a-c9d1-6c82-0dcb3f0be5a2@redhat.com>
Date:   Thu, 14 May 2020 16:43:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since project quota returns ENOSPC rather than EDQUOT, the distinction
between those two error conditions in xfs_file_buffered_aio_write() is
incomplete.  If project quota is on, and we get ENOSPC, it seems that
we have no good way to know if it was due to quota, or due to actual
out of space conditions, and we may need to run both remediation options...

This is completely untested and not even built, because I'm really not sure
what the best way to go here is.  True ENOSPC is hopefully rare, pquota
ENOSPC is probably less so, so I'm not sure how far we should go digging
to figure out what the root cause of the ENOSPC condition is, when pquota
is on (on this inode).

If project quota is on on this inode and pquota enforced, should we look
to the super to make a determination about low free blocks in the fs?

Should we crack open the dquot and see if it's over limit?

Should we just run both conditions and hope for the best?

Is this all best effort anyway, so we just simply care if we take the
improper action for pquota+ENOSPC?

Probably-shouldn't-merge-this-sez: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4b8bdecc3863..8cec826046ce 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -647,27 +647,31 @@ xfs_file_buffered_aio_write(
 	 * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
 	 * also behaves as a filter to prevent too many eofblocks scans from
 	 * running at the same time.
+	 *
+	 * Fun fact: Project quota returns -ENOSPC, so... complexity here.
 	 */
-	if (ret == -EDQUOT && !enospc) {
-		xfs_iunlock(ip, iolock);
-		enospc = xfs_inode_free_quota_eofblocks(ip);
-		if (enospc)
-			goto write_retry;
-		enospc = xfs_inode_free_quota_cowblocks(ip);
+	if (!enospc) {
+		if (ret == -ENOSPC) {
+			struct xfs_eofblocks eofb = {0};
+	
+			enospc = 1;
+			xfs_flush_inodes(ip->i_mount);
+	
+			xfs_iunlock(ip, iolock);
+			eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
+			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+			xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		}
+		if (ret == -EDQUOT ||
+		    (ret == -ENOSPC && ip->i_pdquot &&
+		     XFS_IS_PQUOTA_ENFORCED(mp) && ip->i_pdquot)) {
+			xfs_iunlock(ip, iolock);
+			enospc |= xfs_inode_free_quota_eofblocks(ip);
+			enospc |= xfs_inode_free_quota_cowblocks(ip);
+			iolock = 0;
+		}
 		if (enospc)
 			goto write_retry;
-		iolock = 0;
-	} else if (ret == -ENOSPC && !enospc) {
-		struct xfs_eofblocks eofb = {0};
-
-		enospc = 1;
-		xfs_flush_inodes(ip->i_mount);
-
-		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
-		goto write_retry;
 	}
 
 	current->backing_dev_info = NULL;

