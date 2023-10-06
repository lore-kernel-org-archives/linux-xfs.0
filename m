Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFC0E94103
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjJFSzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjJFSyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605D210D
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UWcs9SrNpmcSvDrcidpI6DOh7inrMPlH2bbWKy/g+Tc=;
        b=We+8gB62bgJsHrUT9woKtEqMHftHGfT3juSmEmikqgu+uKmvyZsDBTxUCevzsUmR0bS7jK
        Pod1xga1ov5KIJyWv5TL8w9xci2y/JMyUastfSZ4i++usNTfvPhqocVGfl+lIUcuBZfi4t
        hbrPS/JBZXwl6RM+AhP0FN8t2sqJDWc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222--ly-YUfZMy26Nad2QYwW4A-1; Fri, 06 Oct 2023 14:52:35 -0400
X-MC-Unique: -ly-YUfZMy26Nad2QYwW4A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9adad8f306fso197845166b.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618353; x=1697223153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWcs9SrNpmcSvDrcidpI6DOh7inrMPlH2bbWKy/g+Tc=;
        b=Nu2KiAmLjpUY2J6Rv9kb2sU+wahwMG2uNzAGu/sJRtFk3656rDeEppuf7I4lPayQQ+
         0exOh30jiv2yIM4ArXj2C65YtSIdWsAlNcfnW48oxwPTd6NuYMu3eXFB3waFdYAeaVOV
         E1w/5/xrcDh7ZzOerdQiYewJAX2LOSoLvI3cQI46VkKZFDetLiXQ3X+sm5Odtrm16rmG
         FYziNdrH6vgttkCscIsv18gPgGTgiMZBcyjXsAqDmyfsDX/PSwDsl1ZhXtCPOvYuVzdp
         hG4J7Zb1MoMzFvNUl4mYh6I7Y6Wse8KoReByussuCqTbaAALZt/nFGPOm+BfxXymRFve
         o23g==
X-Gm-Message-State: AOJu0YzYAYcMzAgBux+Eu6vetjKUpbDAEaARIzksjlEC2fL2sImSqAoA
        kymi68P9No88l1htg1c42xfnU++JiMpDEMR3HVztqg4ILoL0PsYlJxpiPAUbCRint/+YKO48Ll2
        6Sqc/+1FXceS9a5mS24bx8iy5yj7GoS9QmAVjk2wWUaNlPY86JDIrWUHqjpo5uALh229ODgaXni
        DsVmo=
X-Received: by 2002:a17:906:53:b0:9ae:738b:86d0 with SMTP id 19-20020a170906005300b009ae738b86d0mr7651952ejg.66.1696618353625;
        Fri, 06 Oct 2023 11:52:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdagM+opy7rXcNtWvd0CvvXwFThJ35jMAyomOLpjoWKe3Lj27i5d7fquRXV2FvmC3HqgU7lQ==
X-Received: by 2002:a17:906:53:b0:9ae:738b:86d0 with SMTP id 19-20020a170906005300b009ae738b86d0mr7651934ejg.66.1696618353283;
        Fri, 06 Oct 2023 11:52:33 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:32 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 16/28] xfs: add bio_set and submit_io for ioend post-processing
Date:   Fri,  6 Oct 2023 20:49:10 +0200
Message-Id: <20231006184922.252188-17-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The read IO path provides callout for configuring ioend. This allows
filesystem to add verification of completed BIOs. One of such tasks
is verification against fs-verity tree when pages were read. iomap
allows using custom bio_set with submit_bio() to add ioend
processing. The xfs_prepare_read_ioend() configures bio->bi_end_io
which places verification task in the workqueue. The task does
fs-verity verification and then call back to the iomap to finish IO.

This patch adds callouts implementation to verify pages with
fs-verity. Also implements folio operation .verify_folio for direct
folio verification by fs-verity.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_aops.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_aops.h  |  2 ++
 fs/xfs/xfs_linux.h |  1 +
 fs/xfs/xfs_super.c |  9 ++++-
 4 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b413a2dbcc18..fceb0c3de61f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -26,6 +26,8 @@ struct xfs_writepage_ctx {
 	unsigned int		cow_seq;
 };
 
+static struct bio_set xfs_read_ioend_bioset;
+
 static inline struct xfs_writepage_ctx *
 XFS_WPC(struct iomap_writepage_ctx *ctx)
 {
@@ -548,19 +550,97 @@ xfs_vm_bmap(
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
+static int
+xfs_verify_folio(
+	struct folio	*folio,
+	loff_t		pos,
+	unsigned int	len)
+{
+	if (fsverity_verify_blocks(folio, len, pos))
+		return 0;
+	return -EFSCORRUPTED;
+}
+
+int
+xfs_init_iomap_bioset(void)
+{
+	return bioset_init(&xfs_read_ioend_bioset,
+			   4 * (PAGE_SIZE / SECTOR_SIZE),
+			   offsetof(struct iomap_read_ioend, read_inline_bio),
+			   BIOSET_NEED_BVECS);
+}
+
+void
+xfs_free_iomap_bioset(void)
+{
+	bioset_exit(&xfs_read_ioend_bioset);
+}
+
+static void
+xfs_submit_read_bio(
+	const struct iomap_iter *iter,
+	struct bio *bio,
+	loff_t file_offset)
+{
+	struct iomap_read_ioend *ioend;
+
+	ioend = container_of(bio, struct iomap_read_ioend, read_inline_bio);
+	ioend->io_inode = iter->inode;
+	if (fsverity_active(ioend->io_inode)) {
+		INIT_WORK(&ioend->work, &xfs_read_work_end_io);
+		ioend->read_inline_bio.bi_end_io = &xfs_read_end_io;
+	}
+
+	submit_bio(bio);
+}
+
+static const struct iomap_readpage_ops xfs_readpage_ops = {
+	.verify_folio		= &xfs_verify_folio,
+	.submit_io		= &xfs_submit_read_bio,
+	.bio_set		= &xfs_read_ioend_bioset,
+};
+
 STATIC int
 xfs_vm_read_folio(
 	struct file		*unused,
 	struct folio		*folio)
 {
-	return iomap_read_folio(folio, &xfs_read_iomap_ops, NULL);
+	return iomap_read_folio(folio, &xfs_read_iomap_ops, &xfs_readpage_ops);
 }
 
 STATIC void
 xfs_vm_readahead(
 	struct readahead_control	*rac)
 {
-	iomap_readahead(rac, &xfs_read_iomap_ops, NULL);
+	iomap_readahead(rac, &xfs_read_iomap_ops, &xfs_readpage_ops);
 }
 
 static int
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index e0bd68419764..fa7c512b2717 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -10,5 +10,7 @@ extern const struct address_space_operations xfs_address_space_operations;
 extern const struct address_space_operations xfs_dax_aops;
 
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
+int	xfs_init_iomap_bioset(void);
+void	xfs_free_iomap_bioset(void);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index e9d317a3dafe..ee213c6dfcaf 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -64,6 +64,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/debugfs.h>
+#include <linux/fsverity.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5e1ec5978176..3cdb642961f4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2375,11 +2375,17 @@ init_xfs_fs(void)
 	if (error)
 		goto out_remove_dbg_kobj;
 
-	error = register_filesystem(&xfs_fs_type);
+	error = xfs_init_iomap_bioset();
 	if (error)
 		goto out_qm_exit;
+
+	error = register_filesystem(&xfs_fs_type);
+	if (error)
+		goto out_iomap_bioset;
 	return 0;
 
+ out_iomap_bioset:
+	xfs_free_iomap_bioset();
  out_qm_exit:
 	xfs_qm_exit();
  out_remove_dbg_kobj:
@@ -2412,6 +2418,7 @@ init_xfs_fs(void)
 STATIC void __exit
 exit_xfs_fs(void)
 {
+	xfs_free_iomap_bioset();
 	xfs_qm_exit();
 	unregister_filesystem(&xfs_fs_type);
 #ifdef DEBUG
-- 
2.40.1

