Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FFCC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 14:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E51120684
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 14:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ANcootqc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLCOF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 09:05:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59010 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726098AbfLCOF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 09:05:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575381925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2NSnkvNyo7BHve+ChAWYI1iBJhtNx/P/u5acrYukJNo=;
        b=ANcootqcz+1iqc+dNuCT8xu+q/7iVRAH8L4C30fLJxtfza82seskjAWX4TWEF5HSC30Io5
        rYSJ3cwz0+FjeBRdhsA7GQAo5vfe169j9ZbA8sE1BhP73fV5EwsM8YAJ13UAcgr8oEWSkB
        YPyzFrUsb+tUg3zhw9nZNgURTUnJLe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-_Y5BYUN7P5iT7hRUEF2l8A-1; Tue, 03 Dec 2019 09:05:24 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A81BA8017CC
        for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2019 14:05:23 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66B91600C8
        for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2019 14:05:23 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix mount failure crash on invalid iclog memory access
Date:   Tue,  3 Dec 2019 09:05:24 -0500
Message-Id: <20191203140524.36043-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: _Y5BYUN7P5iT7hRUEF2l8A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot (via KASAN) reports a use-after-free in the error path of
xlog_alloc_log(). Specifically, the iclog freeing loop doesn't
handle the case of a fully initialized ->l_iclog linked list.
Instead, it assumes that the list is partially constructed and NULL
terminated.

This bug manifested because there was no possible error scenario
after iclog list setup when the original code was added.  Subsequent
code and associated error conditions were added some time later,
while the original error handling code was never updated. Fix up the
error loop to terminate either on a NULL iclog or reaching the end
of the list.

Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6a147c63a8a6..f6006d94a581 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1542,6 +1542,8 @@ xlog_alloc_log(
 =09=09prev_iclog =3D iclog->ic_next;
 =09=09kmem_free(iclog->ic_data);
 =09=09kmem_free(iclog);
+=09=09if (prev_iclog =3D=3D log->l_iclog)
+=09=09=09break;
 =09}
 out_free_log:
 =09kmem_free(log);
--=20
2.20.1

