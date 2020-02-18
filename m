Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71851C34026
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 17:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C6124654
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 17:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V2EfASBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgBRRyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 12:54:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44224 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbgBRRyd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 12:54:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582048472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0hL4QtsLE3z4g4a5CqGV4oKEWayP5827SQA8HxihoUY=;
        b=V2EfASBLbS1uHstnNdk/slH92kAivCmKS8JH+dC+cXb2zKAJwXQnZrdDsLfGC23Gp6MJho
        u+ZuZOTM80TcDjkQ7qwTNW6JiOlIhFXpvfyKpTYkHHi12bKMotE1f8GXErNCA2O7p149SR
        j0y5cHq5pezeVW36dIjT+/ZEFftKb0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-cI8yaPDuNJaoImfocvXcow-1; Tue, 18 Feb 2020 12:54:26 -0500
X-MC-Unique: cI8yaPDuNJaoImfocvXcow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DCB410CE788
        for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2020 17:54:26 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB65260C81
        for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2020 17:54:25 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: fix iclog release error check race with shutdown
Date:   Tue, 18 Feb 2020 12:54:25 -0500
Message-Id: <20200218175425.20598-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
l_icloglock held"), xlog_state_release_iclog() always performed a
locked check of the iclog error state before proceeding into the
sync state processing code. As of this commit, part of
xlog_state_release_iclog() was open-coded into
xfs_log_release_iclog() and as a result the locked error state check
was lost.

The lockless check still exists, but this doesn't account for the
possibility of a race with a shutdown being performed by another
task causing the iclog state to change while the original task waits
on ->l_icloglock. This has reproduced very rarely via generic/475
and manifests as an assert failure in __xlog_state_release_iclog()
due to an unexpected iclog state.

Restore the locked error state check in xlog_state_release_iclog()
to ensure that an iclog state update via shutdown doesn't race with
the iclog release state processing code.

Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock=
 held")
Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Include Fixes tag.
- Use common error path to include shutdown call.
v1: https://lore.kernel.org/linux-xfs/20200214181528.24046-1-bfoster@redh=
at.com/

 fs/xfs/xfs_log.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581..796ff37d5bb5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -605,18 +605,23 @@ xfs_log_release_iclog(
 	struct xlog		*log =3D mp->m_log;
 	bool			sync;
=20
-	if (iclog->ic_state =3D=3D XLOG_STATE_IOERROR) {
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-		return -EIO;
-	}
+	if (iclog->ic_state =3D=3D XLOG_STATE_IOERROR)
+		goto error;
=20
 	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
+		if (iclog->ic_state =3D=3D XLOG_STATE_IOERROR) {
+			spin_unlock(&log->l_icloglock);
+			goto error;
+		}
 		sync =3D __xlog_state_release_iclog(log, iclog);
 		spin_unlock(&log->l_icloglock);
 		if (sync)
 			xlog_sync(log, iclog);
 	}
 	return 0;
+error:
+	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+	return -EIO;
 }
=20
 /*
--=20
2.21.1

