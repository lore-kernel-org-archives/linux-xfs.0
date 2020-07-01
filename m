Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D47C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F6F2078D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGoVevKH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbgGAQv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732546AbgGAQvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zHW36s/snJE2ggr6hpkbMpu5eR3RUmCUNf25VBddjNA=;
        b=gGoVevKHRYxKcYJ8goto06FdzYhojRBykerUFU++F8EuBBy92xlz+rTJm0WuJaXlHUwbTX
        iHfqboIRMk+McIqCOwXkT7gI3Wbj080w2Fw9uhOun+gSjrS6nwNob3YphAib8IHzGSk6oP
        yntBZQk9vP2G7OVU0e+j+JGvXpDATxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-_yTHETGtNbipXHbnfr9duw-1; Wed, 01 Jul 2020 12:51:21 -0400
X-MC-Unique: _yTHETGtNbipXHbnfr9duw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23FC9107ACCD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:20 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D44055C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:19 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/10] xfs: prevent fs freeze with outstanding relog items
Date:   Wed,  1 Jul 2020 12:51:13 -0400
Message-Id: <20200701165116.47344-8-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 379cbff438bc..f77af5298a80 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -35,6 +35,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_trans_priv.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -914,6 +915,9 @@ xfs_fs_freeze(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	if (WARN_ON_ONCE(atomic64_read(&mp->m_ail->ail_relog_res)))
+		return -EAGAIN;
+
 	xfs_stop_block_reaping(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-- 
2.21.3

