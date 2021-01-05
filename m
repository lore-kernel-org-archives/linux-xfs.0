Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A235CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 16:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F56F22C9D
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 16:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbhAEQYb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 11:24:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbhAEQYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 11:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609863785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z1JS5QptyN5hvrW5uAOoOSIbCevsTIGYX5oXqRn01L0=;
        b=ewseqkvY4gLEkRqNLL5QxL+4iD3BZT8AlLONYWh12cutdYCD+9mtLSbm9kGIe+Kkb2f3Ng
        Acshl1UvWaoi2oL0JLPIcZ6UR2p6O/wcklKYlZJcU4InwtNZ6UyXBXLNbc1lmP1FPJ20mF
        qVdCSmI6BsZXuVXZPWXPI9oYZXa4SX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-WJ2TEW8oN5GPLIBE0iMxuw-1; Tue, 05 Jan 2021 11:23:02 -0500
X-MC-Unique: WJ2TEW8oN5GPLIBE0iMxuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB004107ACE3
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jan 2021 16:23:01 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-14-10.pek2.redhat.com [10.72.14.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6B7F7092E
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jan 2021 16:23:00 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: expose inobtcount in xfs geometry
Date:   Wed,  6 Jan 2021 00:22:54 +0800
Message-Id: <20210105162254.706534-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As xfs supports the feature of inode btree block counters now, expose
this feature flag in xfs geometry, for userspace can check if the
inobtcnt is enabled or not.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

The related userspace xfsprogs patch as this link:
https://www.spinics.net/lists/linux-xfs/msg47853.html

Thanks,
Zorro

 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2a2e3cfd94f0..6fad140d4c8e 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
+#define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bbda117e5d85..60e6d255e5e2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1138,6 +1138,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
 	if (xfs_sb_version_hasbigtime(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
+	if (xfs_sb_version_hasinobtcounts(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
-- 
2.25.4

