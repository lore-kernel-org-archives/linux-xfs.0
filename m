Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91798C2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 652482076D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+X+nkOK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgDHMV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 08:21:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgDHMV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 08:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586348485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WgidWMvlnp5wYWI8flkO16ALRl9eYdPdHCKuIt09UEA=;
        b=C+X+nkOKfpQzbSaC9cXcfmDWA3xZucF0qOz98ifQk85N4r4YfQiXm9+HIUA93baW4yz8Of
        G3777ARpA78jM5l7oVIYtPrFZ1+YbqewBU8g/KBAu1hMUDn3fndE6TbdDyZPWuD/ltxMrq
        gn8KuzETsP6NITnrEiMq1WEp0b6nIw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-DdN3WsF-M9iT-XFvmuQxPw-1; Wed, 08 Apr 2020 08:21:21 -0400
X-MC-Unique: DdN3WsF-M9iT-XFvmuQxPw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDBE8A2281
        for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2020 12:21:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97B6C1001281
        for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2020 12:21:19 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: acquire superblock freeze protection on eofblocks scans
Date:   Wed,  8 Apr 2020 08:21:19 -0400
Message-Id: <20200408122119.33869-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The filesystem freeze sequence in XFS waits on any background
eofblocks or cowblocks scans to complete before the filesystem is
quiesced. At this point, the freezer has already stopped the
transaction subsystem, however, which means a truncate or cowblock
cancellation in progress is likely blocked in transaction
allocation. This results in a deadlock between freeze and the
associated scanner.

Fix this problem by holding superblock write protection across calls
into the block reapers. Since protection for background scans is
acquired from the workqueue task context, trylock to avoid a similar
deadlock between freeze and blocking on the write lock.

Fixes: d6b636ebb1c9f ("xfs: halt auto-reclamation activities while rebuil=
ding rmap")
Reported-by: Paul Furtado <paulfurtado91@gmail.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Note that this has the opposite tradeoff as the approach I originally
posited [1], specifically that the eofblocks ioctl() now always blocks
on a frozen fs rather than return -EAGAIN. It's worth pointing out that
the eofb control structure has a sync flag (that is not used for
background scans), so yet another approach could be to tie the trylock
to that.

Brian

[1] https://lore.kernel.org/linux-xfs/20200407163739.GG28936@bfoster/

 fs/xfs/xfs_icache.c | 10 ++++++++++
 fs/xfs/xfs_ioctl.c  |  5 ++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a7be7a9e5c1a..8bf1d15be3f6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -911,7 +911,12 @@ xfs_eofblocks_worker(
 {
 	struct xfs_mount *mp =3D container_of(to_delayed_work(work),
 				struct xfs_mount, m_eofblocks_work);
+
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
 	xfs_icache_free_eofblocks(mp, NULL);
+	sb_end_write(mp->m_super);
+
 	xfs_queue_eofblocks(mp);
 }
=20
@@ -938,7 +943,12 @@ xfs_cowblocks_worker(
 {
 	struct xfs_mount *mp =3D container_of(to_delayed_work(work),
 				struct xfs_mount, m_cowblocks_work);
+
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
 	xfs_icache_free_cowblocks(mp, NULL);
+	sb_end_write(mp->m_super);
+
 	xfs_queue_cowblocks(mp);
 }
=20
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cdfb3cd9a25b..309958186d33 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2363,7 +2363,10 @@ xfs_file_ioctl(
 		if (error)
 			return error;
=20
-		return xfs_icache_free_eofblocks(mp, &keofb);
+		sb_start_write(mp->m_super);
+		error =3D xfs_icache_free_eofblocks(mp, &keofb);
+		sb_end_write(mp->m_super);
+		return error;
 	}
=20
 	default:
--=20
2.21.1

