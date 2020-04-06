Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE771C2BB1D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C784B21D93
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUk8FbPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgDFMgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24169 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727952AbgDFMgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zEpjhkqKfDhENSK0q05xHaVYnJhXM6Cq/MGKDW/x7qQ=;
        b=IUk8FbPPnC5XUWhoOD+HbOeAiLf9kT3GqHRG6DZFCBkGc/5iFhkvctaY2xYuu2cKH0vGU9
        lz5bEsHqmuksy/fns81LAmwVONBlG15kSrgAhlWOx5HqCKadcjr0Ph/L3u1rBG4HUAxlLT
        6r7oxwOnG7OLYwn5nzpCdAgkfO0rUWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-waGEQcnoPmSoOcu2UaUQCQ-1; Mon, 06 Apr 2020 08:36:37 -0400
X-MC-Unique: waGEQcnoPmSoOcu2UaUQCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE5BD107ACC7
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:36 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7654E60BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 07/10] xfs: prevent fs freeze with outstanding relog items
Date:   Mon,  6 Apr 2020 08:36:29 -0400
Message-Id: <20200406123632.20873-8-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The automatic relog mechanism is currently incompatible with
filesystem freeze in a generic sense. Freeze protection is currently
implemented via locks that cannot be held on return to userspace,
which means we can't hold a superblock write reference for the
duration relogging is enabled on an item. It's too late to block
when the freeze sequence calls into the filesystem because the
transaction subsystem has already begun to be frozen. Not only can
this block the relog transaction, but blocking any unrelated
transaction essentially prevents a particular operation from
progressing to the point where it can disable relogging on an item.
Therefore marking the relog transaction as "nowrite" does not solve
the problem.

This is not a problem in practice because the two primary use cases
already exclude freeze via other means. quotaoff holds ->s_umount
read locked across the operation and scrub explicitly takes a
superblock write reference, both of which block freeze of the
transaction subsystem for the duration of relog enabled items.

As a fallback for future use cases and the upcoming random buffer
relogging test code, fail fs freeze attempts when the global relog
reservation counter is elevated to prevent deadlock. This is a
partial punt of the problem as compared to teaching freeze to wait
on relogged items because the only current dependency is test code.
In other words, this patch prevents deadlock if a user happens to
issue a freeze in conjunction with random buffer relog injection.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index abf06bf9c3f3..0efa9dc70d71 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -35,6 +35,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_trans_priv.h"
=20
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -870,6 +871,9 @@ xfs_fs_freeze(
 {
 	struct xfs_mount	*mp =3D XFS_M(sb);
=20
+	if (WARN_ON_ONCE(atomic64_read(&mp->m_ail->ail_relog_res)))
+		return -EAGAIN;
+
 	xfs_stop_block_reaping(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
--=20
2.21.1

