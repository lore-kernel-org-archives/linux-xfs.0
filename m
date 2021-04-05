Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4110C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7537D613B2
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241368AbhDEO7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:59:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235835AbhDEO7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 10:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617634757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VU+k5GyO+umd6s/8LIQeqlvWmpqOJ0zxFseHCE+reDk=;
        b=gLyWWp4caQF7hf8MWGoZ+lzrhxEPTfalR6ztyUkqjLwfLt/lD+pO+aU+iK42RD11+JxPtX
        wUqfE5aCVdFdis4kqrD90Lk5Qk22Pw7Q/Pg5fIfeV1JmmcnFMppY6ICCtaGkIhstd04SAw
        bsJMElxHmWqyF24S/nnY5qeOA2OaoS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-Yj1uf6wrMv60jKUE449nyA-1; Mon, 05 Apr 2021 10:59:15 -0400
X-MC-Unique: Yj1uf6wrMv60jKUE449nyA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD38B100B3A3
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:05 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A11E35D749
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:05 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: drop unnecessary setfilesize helper
Date:   Mon,  5 Apr 2021 10:59:03 -0400
Message-Id: <20210405145903.629152-5-bfoster@redhat.com>
In-Reply-To: <20210405145903.629152-1-bfoster@redhat.com>
References: <20210405145903.629152-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_setfilesize() is the only remaining caller of the internal
__xfs_setfilesize() helper. Fold them into a single function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a7f91f4186bc..87c2912f147d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -42,14 +42,20 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 /*
  * Update on-disk file size now that data has been written to disk.
  */
-STATIC int
-__xfs_setfilesize(
+int
+xfs_setfilesize(
 	struct xfs_inode	*ip,
-	struct xfs_trans	*tp,
 	xfs_off_t		offset,
 	size_t			size)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
 	xfs_fsize_t		isize;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+	if (error)
+		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_new_eof(ip, offset + size);
@@ -68,23 +74,6 @@ __xfs_setfilesize(
 	return xfs_trans_commit(tp);
 }
 
-int
-xfs_setfilesize(
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	size_t			size)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	return __xfs_setfilesize(ip, tp, offset, size);
-}
-
 /*
  * IO write completion.
  */
-- 
2.26.3

