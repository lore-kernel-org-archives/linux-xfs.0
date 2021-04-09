Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B82DC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14280610C8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhDIOMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233777AbhDIOM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617977535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cKzUxOMrgak0nxAPyUbLcQ47DBfX/fTvppZ33g7MQpY=;
        b=BApUIW0hg4uv/aWE5NQWGKpg1Hq9RXOQfL1SSSDYHOUfPm9GxtbOHAN9Xv8n6LuwFCuT+q
        uvbeUkh8DUb7xTi2LOH7LsGw1DPWldV8R/7Q62M1kLI52hNTq4041vQBPwkpSkcXp4BA82
        tj+tPt4hcwAu9ESow9Dm/ecq3g4qkXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-oBSLgYtAMAOS8qfMuRCWBQ-1; Fri, 09 Apr 2021 10:12:13 -0400
X-MC-Unique: oBSLgYtAMAOS8qfMuRCWBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F1B78030B5
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:12 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63A226064B
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:12 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 4/5] xfs: drop unnecessary setfilesize helper
Date:   Fri,  9 Apr 2021 10:12:09 -0400
Message-Id: <20210409141210.1000155-5-bfoster@redhat.com>
In-Reply-To: <20210409141210.1000155-1-bfoster@redhat.com>
References: <20210409141210.1000155-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_setfilesize() is the only remaining caller of the internal
__xfs_setfilesize() helper. Fold them into a single function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 026e165d8371..8540180bd106 100644
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

