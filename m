Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D770BC2D0EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B31612223C
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UludvWn6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgDQPJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:09:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39708 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgDQPJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpMBsU/jMI/ZvMgldHYmi+dYL/qC/ZrOvZKXjinlZN8=;
        b=UludvWn6833R5gdNmmNaU3otOWWWO8fgurC/ENmctgK255wpDf5TBpwhudV3t/9911uPX8
        n7doLU9e+STT5aL3zXNIGvxXYl4h7ZsryWeQ5c2EFbpLoLzzrHC3/LV09oJPfOQi088/3f
        p1g/XLIQ6GlMWbK1bzYBK+HQ2318wAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-4LdlqqVDMB6KADuHYN86tw-1; Fri, 17 Apr 2020 11:09:02 -0400
X-MC-Unique: 4LdlqqVDMB6KADuHYN86tw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDE101005513
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98E5760BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:01 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: remove unnecessary shutdown check from xfs_iflush()
Date:   Fri, 17 Apr 2020 11:08:51 -0400
Message-Id: <20200417150859.14734-5-bfoster@redhat.com>
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The shutdown check in xfs_iflush() duplicates checks down in the
buffer code. If the fs is shut down, xfs_trans_read_buf_map() always
returns an error and falls into the same error path. Remove the
unnecessary check along with the warning in xfs_imap_to_bp()
that generates excessive noise in the log if the fs is shut down.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  7 +------
 fs/xfs/xfs_inode.c            | 13 -------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.=
c
index 39c5a6e24915..b102e611bf54 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -172,12 +172,7 @@ xfs_imap_to_bp(
 				   (int)imap->im_len, buf_flags, &bp,
 				   &xfs_inode_buf_ops);
 	if (error) {
-		if (error =3D=3D -EAGAIN) {
-			ASSERT(buf_flags & XBF_TRYLOCK);
-			return error;
-		}
-		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
-			__func__, error);
+		ASSERT(error !=3D -EAGAIN || (buf_flags & XBF_TRYLOCK));
 		return error;
 	}
=20
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4c9971ec6fa6..98ee1b10d1b0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3657,19 +3657,6 @@ xfs_iflush(
 		return 0;
 	}
=20
-	/*
-	 * This may have been unpinned because the filesystem is shutting
-	 * down forcibly. If that's the case we must not write this inode
-	 * to disk, because the log record didn't make it to disk.
-	 *
-	 * We also have to remove the log item from the AIL in this case,
-	 * as we wait for an empty AIL as part of the unmount process.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error =3D -EIO;
-		goto abort;
-	}
-
 	/*
 	 * Get the buffer containing the on-disk inode. We are doing a try-lock
 	 * operation here, so we may get an EAGAIN error. In that case, return
--=20
2.21.1

