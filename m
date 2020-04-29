Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B89C8300F
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B12B20787
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIzHgl6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgD2RWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20642 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726808AbgD2RWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LzizEJhJ38FfWN2xyvNZf1bzDaxqj9gExbBj9eurt+0=;
        b=DIzHgl6J537QAa9tWfTeqH4EBzP7t1+lZqsfi9+kAEnCdp4ytjc2WJUdxNnGitXhAxwkmK
        ST+vw91u8MeZ3yVw9x+MEEXmQRvIvuC8NQeXogJnZxWjRQheujkLdNXBlBGaH7VCBxDnB6
        h7S60Qbwhfa7vZcieM0vdI6BWmsuhMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-5N9dYBODP6mS_7IUic4o0A-1; Wed, 29 Apr 2020 13:22:04 -0400
X-MC-Unique: 5N9dYBODP6mS_7IUic4o0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 380991083E86
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:03 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D70405C220
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 16/17] xfs: remove unused shutdown types
Date:   Wed, 29 Apr 2020 13:21:52 -0400
Message-Id: <20200429172153.41680-17-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both types control shutdown messaging and neither is used in the
current codebase.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c | 5 +----
 fs/xfs/xfs_mount.h | 2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3e61d0cc23f8..ef1d5bb88b93 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -504,10 +504,7 @@ xfs_do_force_shutdown(
 	} else if (logerror) {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
 			"Log I/O Error Detected. Shutting down filesystem");
-	} else if (flags & SHUTDOWN_DEVICE_REQ) {
-		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
-			"All device paths lost. Shutting down filesystem");
-	} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
+	} else {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
 			"I/O Error Detected. Shutting down filesystem");
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b2e4598fdf7d..07b5ba7e5fbd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -259,8 +259,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int =
flags, char *fname,
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed =
*/
 #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount *=
/
 #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structu=
res */
-#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
-#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
=20
 /*
  * Flags for xfs_mountfs
--=20
2.21.1

