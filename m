Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A6EC761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjDDO5B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbjDDO4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43E349F0
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mf1FPmX34sPBqBJ1RqvZnmanS11JhvTJ+HM36CjFqII=;
        b=Tk67VzTuWL2LwRhQMenWZGAHURIsnfKTeC9EfZBOrxjraDJyfWA/BAzJKQ3xkBgQKNsBw8
        PLHXVKdTf3QIM4z7rYi5AUx8Ph7UZ3nbE4QD7YIbUnrpZMzXCiYuXvEdxNWHXJ4g7ZgdDw
        9brxHCHCl85+k0CRgXBMETKvENGJLRQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-W9MFRsznOo2Dt5oGQwazKg-1; Tue, 04 Apr 2023 10:55:28 -0400
X-MC-Unique: W9MFRsznOo2Dt5oGQwazKg-1
Received: by mail-qt1-f200.google.com with SMTP id p22-20020a05622a00d600b003e38f7f800bso22066736qtw.9
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mf1FPmX34sPBqBJ1RqvZnmanS11JhvTJ+HM36CjFqII=;
        b=anwhEAgj9AIzKrANZNxJZWMVbsAOFmaKVSbHFfm8BsWU5cUjUgxxuKoDRewHKlotzp
         H6/nL/RgtoeSKIZGSH8cnpafMXcp32DBBNJU9xWKx9trjBCvzikSp5cZMsZrb+ismiVu
         /R1hR9ltqsNzQhuvt2wry73HvinRprZYMmZBgpYtNuEtSSQmM2A2MGKdHPVo2ZAVn/ve
         EfKs/F877MUnT2AGkHAbZQbkqxG6MW9rRcbmrm/MXtyImemEca5dou1d9qZ/I6cWGLa+
         zHuCbFfKN8+1ZjkDNFoyADJHYZEnLjYJT2m3Lo7MxSQ6wgmV1ebp91qLedF+a33jZ5ec
         oW7Q==
X-Gm-Message-State: AAQBX9cxuxVDexlT0IVfuBipTQ/6E1Mm+N56MzWMEoOuTKtkU+g/gnw6
        87VpFluQ6PJmdL8PPmrO4hxplxZvWRUl3/yDCO643Yd9iQUz5Z5x9W/84apEf4N2+Bm1eTl9T7a
        0MCkJvz7yJMTnNeBwreM=
X-Received: by 2002:a05:622a:586:b0:3e4:df94:34fa with SMTP id c6-20020a05622a058600b003e4df9434famr4035254qtb.37.1680620124159;
        Tue, 04 Apr 2023 07:55:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350bRYRoH4ADtP4T/X8Xk7AmNG3QGNTCPUhw/3V50RQPtNVC1H25ltfcQUL3M/obCpWJOFk1Kng==
X-Received: by 2002:a05:622a:586:b0:3e4:df94:34fa with SMTP id c6-20020a05622a058600b003e4df9434famr4035211qtb.37.1680620123789;
        Tue, 04 Apr 2023 07:55:23 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:23 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 13/23] xfs: add iomap's readpage operations
Date:   Tue,  4 Apr 2023 16:53:09 +0200
Message-Id: <20230404145319.2057051-14-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The read IO path provides callout for configuring ioend. This allows
filesystem to add verification of completed BIOs. The
xfs_prepare_read_ioend() configures bio->bi_end_io which places
verification task in the workqueue. The task does fs-verity
verification and then call back to the iomap to finish IO.

This patch add callouts implementation to verify pages with
fs-verity. Also implements folio operation .verify_folio for direct
folio verification by fs-verity.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_aops.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c | 11 +++++++++++
 fs/xfs/xfs_linux.h |  1 +
 3 files changed, 57 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index daa0dd4768fb..2a3ab5afd665 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -548,6 +548,49 @@ xfs_vm_bmap(
 	return iomap_bmap(mapping, block, &xfs_read_iomap_ops);
 }
 
+static void
+xfs_read_work_end_io(
+	struct work_struct *work)
+{
+	struct iomap_read_ioend *ioend =
+		container_of(work, struct iomap_read_ioend, work);
+	struct bio *bio = &ioend->read_inline_bio;
+
+	fsverity_verify_bio(bio);
+	iomap_read_end_io(bio);
+	/*
+	 * The iomap_read_ioend has been freed by bio_put() in
+	 * iomap_read_end_io()
+	 */
+}
+
+static void
+xfs_read_end_io(
+	struct bio *bio)
+{
+	struct iomap_read_ioend *ioend =
+		container_of(bio, struct iomap_read_ioend, read_inline_bio);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+
+	WARN_ON_ONCE(!queue_work(ip->i_mount->m_postread_workqueue,
+					&ioend->work));
+}
+
+static void
+xfs_prepare_read_ioend(
+	struct iomap_read_ioend	*ioend)
+{
+	if (!fsverity_active(ioend->io_inode))
+		return;
+
+	INIT_WORK(&ioend->work, &xfs_read_work_end_io);
+	ioend->read_inline_bio.bi_end_io = &xfs_read_end_io;
+}
+
+static const struct iomap_readpage_ops xfs_readpage_ops = {
+	.prepare_ioend		= &xfs_prepare_read_ioend,
+};
+
 STATIC int
 xfs_vm_read_folio(
 	struct file			*unused,
@@ -555,6 +598,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_readpage_ctx	ctx = {
 		.cur_folio		= folio,
+		.ops			= &xfs_readpage_ops,
 	};
 
 	return iomap_read_folio(&ctx, &xfs_read_iomap_ops);
@@ -566,6 +610,7 @@ xfs_vm_readahead(
 {
 	struct iomap_readpage_ctx	ctx = {
 		.rac			= rac,
+		.ops			= &xfs_readpage_ops,
 	};
 
 	iomap_readahead(&ctx, &xfs_read_iomap_ops);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 285885c308bd..e0f3c5d709f6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -27,6 +27,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_verity.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -83,8 +84,18 @@ xfs_iomap_valid(
 	return true;
 }
 
+static bool
+xfs_verify_folio(
+	struct folio	*folio,
+	loff_t		pos,
+	unsigned int	len)
+{
+	return fsverity_verify_folio(folio, len, pos);
+}
+
 static const struct iomap_folio_ops xfs_iomap_folio_ops = {
 	.iomap_valid		= xfs_iomap_valid,
+	.verify_folio		= xfs_verify_folio,
 };
 
 int
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index e88f18f85e4b..c574fbf4b67d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -63,6 +63,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/fsverity.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
-- 
2.38.4

