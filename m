Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58ABC55185
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A20620882
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTucQUdQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgDVRyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:54:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34486 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726066AbgDVRyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onKKjuZzTBHBazkIKmPNkqHIik6QYAnkCFDoCE1W+W8=;
        b=hTucQUdQX0CO9KggdLLcO3nSoPgmxzXSpyxjjcsRip5+ImT6yChnSvihQ7D2xWk5WNY9kx
        ngxbaIsuqw/FIeHyegtgQM4BA0n0KhmMeXQkuuliyUkJL9pS0niZLhjEdcRtXyTpXvarUL
        pPwMG0trSfPvNNqg6nisgo+b+KVGFds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-O2xTNheyNECXhcIpRASzBQ-1; Wed, 22 Apr 2020 13:54:33 -0400
X-MC-Unique: O2xTNheyNECXhcIpRASzBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DC3613FC
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:32 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECBBA6084C
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:31 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 04/13] xfs: remove unnecessary shutdown check from xfs_iflush()
Date:   Wed, 22 Apr 2020 13:54:20 -0400
Message-Id: <20200422175429.38957-5-bfoster@redhat.com>
In-Reply-To: <20200422175429.38957-1-bfoster@redhat.com>
References: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
index 6cdb9fbe2d89..aa490efdcaa8 100644
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

