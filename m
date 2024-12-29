Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979DD157E99
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479615; cv=none; b=GEqzNejNlolQC2+e9kmMgzowuY7tptKd/4p6bmCfOaCLvc/Pw4OwqmYSnCJXv7AmZgy7VWgR7jmJJQg846rl1KfbRVxS51TM5irCSRDqceDl+lOqgAw7PXxzcBYPkTvwQB5JgO/xTQdpE3jvr7/JRy50l+1grR461jt3UpW9U6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479615; c=relaxed/simple;
	bh=YeKPhqJM1Nl6IWzbXqu35q0M/POMmMK4E2A57Tgc6g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7FyS82UVuOQeXvS6QGS3w8cGn9d/YuwAOXFpnsyh+Ozs7HW3BmG4nuFfBwssQoqjlMJ571QAW4k+kofnFvjfk7StUBPCaDZRRyLiKGt9hRuW09QPwQmpmvYLLWiYZPZU1616nnV/PjTNR8avHS23wclf20rH+WId/5o2T+1KZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSKaU6qz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSKaU6qz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y16F8dn40v9E2WGmSRw8sn/6QguEwQow4jk5Rxdt5/I=;
	b=dSKaU6qzBWYxatIZ/BXyPuTOoKxeymcPdZZ9D64KwjWJUArSUrZKHwgxxgkteq15Vxl0S0
	GPdjfcCHixrPrpGXnlr2JHCKYqmcF3nw9vovyU/6YJUEThz08mxgPrMxZKiG73cW90nu58
	pa17ok7YwtJuJYs9IMRhC70MkcR3lJ8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-l9Td--R_MGGoMG6scr3WVw-1; Sun, 29 Dec 2024 08:40:10 -0500
X-MC-Unique: l9Td--R_MGGoMG6scr3WVw-1
X-Mimecast-MFC-AGG-ID: l9Td--R_MGGoMG6scr3WVw
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa6869e15ebso131643766b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479608; x=1736084408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y16F8dn40v9E2WGmSRw8sn/6QguEwQow4jk5Rxdt5/I=;
        b=ZF2eMelFpNySH1vC1c/2hAlS0A2MqA3mG7MY/PrW91ij35Qp9GYUy+hXcvm2nZdWyR
         wCzNT+BW/xBp4NIWDBdEERFB/NlMi0vXTFXbYO3YnYvDb16KJZ6HgYOCU8HgA2rjut6P
         m9HxCtKQyMbADrAHkDXQITenZWPTzDcop/Yn0DgoCYwOlhY+LHPzHJq9Da8vGkghxNro
         V6jelv/GEUscL5bkgQZQl1v7j9yplDTbstoVSZgFNTmS6e+j7kCbnqb/driHFuSeQb6H
         RcZIGbAtAx/+qNVoArnPlyfuw/4HrrJ075gZcrcVTBfIxbYBMWJdCvw7yonNsZjX0Poe
         ySLA==
X-Gm-Message-State: AOJu0YxHSxU/BHAqsohtBaAI0s22nAcvA2EtfGU4sRAwsE9X+VPtRy7C
	nzdzIPJEA4AgwdrYRBxOcbV8Te1CczfVH10RYgbVL82yVPBW3lHvgWgPlfxcUx6RT6baCnDyxh0
	g4I7qKzCeWOoNO3m73iQx1AbIHzCOFoF+/Ri+IGAuGEGcS2cp3GNWCQfBuhIg2PWyLAeD31jvGX
	L7DHgTp3R3ZyDODX3gL+pvnkLEPvi6bt4j+wNWMozK
X-Gm-Gg: ASbGncttvt9y1BCt+PyrHcfkWaxe7FHSbBIEu7iVUNEFdJMH70qKwTCNzV85mrRG0qT
	nmHWUF9jZcSj9j/f+/Z5YhyVQ9mWVOB1+B6g0x0nLi1mOiRaZkufX/eNlQ825Ht4Zw7qBlTiBHt
	TEU8u3zVLh/PBrLZsxbLo2R1zpmXON3vfnN73WbSp34lS6Af0EVZzpgEJQZ3SXzf8uFYN/XuxEP
	ljUJ8KrLtfQAx+mULbWovJ8rUEK9QGLY8/ArdND5tPCioirvdxP1d47DESvIpALNp8Uw/8cL0pq
	OXjaL9i14vAQz5A=
X-Received: by 2002:a17:907:94c7:b0:aa6:42d8:afac with SMTP id a640c23a62f3a-aac08155190mr3794996666b.15.1735479607830;
        Sun, 29 Dec 2024 05:40:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnUp/AgduUyj2iiTh1WYhWz0eaAzZVkRbJKvP6sWQtqS7hjOBg4SE4Mr1SO/7VP2efTZSfFg==
X-Received: by 2002:a17:907:94c7:b0:aa6:42d8:afac with SMTP id a640c23a62f3a-aac08155190mr3794991666b.15.1735479607118;
        Sun, 29 Dec 2024 05:40:07 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:06 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 17/24] xfs: add fs-verity support
Date: Sun, 29 Dec 2024 14:39:20 +0100
Message-ID: <20241229133927.1194609-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Add integration with fs-verity. The XFS store fs-verity metadata in
the extended file attributes. The metadata consist of verity
descriptor and Merkle tree blocks.

The descriptor is stored under "vdesc" extended attribute. The
Merkle tree blocks are stored under binary indexes which are offsets
into the Merkle tree.

When fs-verity is enabled on an inode, the XFS_IVERITY_CONSTRUCTION
flag is set meaning that the Merkle tree is being build. The
initialization ends with storing of verity descriptor and setting
inode on-disk flag (XFS_DIFLAG2_VERITY).

The verification on read is done in read path of iomap.

Merkle tree blocks are indexed by a per-AG rhashtable to reduce the time
it takes to load a block from disk in a manner that doesn't bloat struct
xfs_inode.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: replace caching implementation with an xarray, other cleanups]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile               |   2 +
 fs/xfs/libxfs/xfs_ag.h        |   1 +
 fs/xfs/libxfs/xfs_attr.c      |   4 +
 fs/xfs/libxfs/xfs_da_format.h |  14 +
 fs/xfs/libxfs/xfs_ondisk.h    |   4 +
 fs/xfs/libxfs/xfs_verity.c    |  58 +++++
 fs/xfs/libxfs/xfs_verity.h    |  13 +
 fs/xfs/xfs_aops.c             |  56 +++-
 fs/xfs/xfs_fsops.c            |   1 +
 fs/xfs/xfs_fsverity.c         | 471 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h         |  54 ++++
 fs/xfs/xfs_inode.h            |   2 +
 fs/xfs/xfs_iomap.h            |   2 +
 fs/xfs/xfs_mount.c            |   1 +
 fs/xfs/xfs_super.c            |   9 +
 fs/xfs/xfs_trace.c            |   1 +
 fs/xfs/xfs_trace.h            |  39 +++
 17 files changed, 730 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_verity.c
 create mode 100644 fs/xfs/libxfs/xfs_verity.h
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ed9b0dabc1f1..ebee7b75e5ae 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -57,6 +57,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_trans_resv.o \
 				   xfs_trans_space.o \
 				   xfs_types.o \
+				   xfs_verity.o \
 				   )
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
@@ -140,6 +141,7 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
+xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
 
 # notify failure
 ifeq ($(CONFIG_MEMORY_FAILURE),y)
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 1f24cfa27321..ea30f982771e 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -89,6 +89,7 @@ struct xfs_perag {
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
+
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3f3699e9c203..9c416d2506a4 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -28,6 +28,7 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 #include "xfs_iomap.h"
+#include "xfs_verity.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1766,6 +1767,9 @@ xfs_attr_namecheck(
 	if (!xfs_attr_check_namespace(attr_flags))
 		return false;
 
+	if (attr_flags & XFS_ATTR_VERITY)
+		return xfs_verity_namecheck(attr_flags, name, length);
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 060cedb4c12d..cb49e2629bb5 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -924,4 +924,18 @@ struct xfs_parent_rec {
 	__be32	p_gen;
 } __packed;
 
+/*
+ * fs-verity attribute name format
+ *
+ * Merkle tree blocks are stored under extended attributes of the inode.  The
+ * name of the attributes are byte positions into the merkle data.
+ */
+struct xfs_merkle_key {
+	__be64	mk_pos;
+};
+
+/* ondisk xattr name used for the fsverity descriptor */
+#define XFS_VERITY_DESCRIPTOR_NAME	"vdesc"
+#define XFS_VERITY_DESCRIPTOR_NAME_LEN	(sizeof(XFS_VERITY_DESCRIPTOR_NAME) - 1)
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 2617081bf989..e4ac5a0a01fd 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -292,6 +292,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_SB_OFFSET(sb_rgextents,		276);
 	XFS_CHECK_SB_OFFSET(sb_rgblklog,		280);
 	XFS_CHECK_SB_OFFSET(sb_pad,			281);
+
+	/* fs-verity xattrs */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_merkle_key,		8);
+	XFS_CHECK_VALUE(sizeof(XFS_VERITY_DESCRIPTOR_NAME),	6);
 }
 
 #endif /* __XFS_ONDISK_H */
diff --git a/fs/xfs/libxfs/xfs_verity.c b/fs/xfs/libxfs/xfs_verity.c
new file mode 100644
index 000000000000..ff02c5c840b5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_verity.c
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 Red Hat, Inc.
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_log_format.h"
+#include "xfs_attr.h"
+#include "xfs_verity.h"
+
+/* Set a merkle tree pos in preparation for setting merkle tree attrs. */
+void
+xfs_merkle_key_to_disk(
+	struct xfs_merkle_key	*key,
+	uint64_t		pos)
+{
+	key->mk_pos = cpu_to_be64(pos);
+}
+
+/* Retrieve the merkle tree pos from the attr data. */
+uint64_t
+xfs_merkle_key_from_disk(
+	const void		*attr_name,
+	int			namelen)
+{
+	const struct xfs_merkle_key *key = attr_name;
+
+	ASSERT(namelen == sizeof(struct xfs_merkle_key));
+
+	return be64_to_cpu(key->mk_pos);
+}
+
+/* Return true if verity attr name is valid. */
+bool
+xfs_verity_namecheck(
+	unsigned int		attr_flags,
+	const void		*name,
+	int			namelen)
+{
+	if (!(attr_flags & XFS_ATTR_VERITY))
+		return false;
+
+	/*
+	 * Merkle tree pages are stored under u64 indexes; verity descriptor
+	 * blocks are held in a named attribute.
+	 */
+	if (namelen != sizeof(struct xfs_merkle_key) &&
+	    namelen != XFS_VERITY_DESCRIPTOR_NAME_LEN)
+		return false;
+
+	return true;
+}
diff --git a/fs/xfs/libxfs/xfs_verity.h b/fs/xfs/libxfs/xfs_verity.h
new file mode 100644
index 000000000000..5813665c5a01
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_verity.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Red Hat, Inc.
+ */
+#ifndef __XFS_VERITY_H__
+#define __XFS_VERITY_H__
+
+void xfs_merkle_key_to_disk(struct xfs_merkle_key *key, uint64_t pos);
+uint64_t xfs_merkle_key_from_disk(const void *attr_name, int namelen);
+bool xfs_verity_namecheck(unsigned int attr_flags, const void *name,
+		int namelen);
+
+#endif	/* __XFS_VERITY_H__ */
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 559a3a577097..bcc51628dbdd 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -19,6 +19,8 @@
 #include "xfs_reflink.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_fsverity.h"
+#include <linux/fsverity.h>
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -132,6 +134,10 @@ xfs_end_ioend(
 
 	if (!error && xfs_ioend_is_append(ioend))
 		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
+
+	/* This IO was to the Merkle tree region */
+	if (xfs_fsverity_in_region(ioend->io_offset))
+		error = xfs_fsverity_end_ioend(ip, ioend);
 done:
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
@@ -512,19 +518,65 @@ xfs_vm_bmap(
 	return iomap_bmap(mapping, block, &xfs_read_iomap_ops);
 }
 
+static void
+xfs_read_end_io(
+	struct bio *bio)
+{
+	struct iomap_read_ioend *ioend =
+		container_of(bio, struct iomap_read_ioend, io_bio);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+
+	WARN_ON_ONCE(!queue_work(ip->i_mount->m_postread_workqueue,
+					&ioend->io_work));
+}
+
+static void
+xfs_prepare_read_ioend(
+	struct iomap_read_ioend	*ioend)
+{
+	if (ioend->io_flags & IOMAP_F_BEYOND_EOF) {
+		INIT_WORK(&ioend->io_work, &xfs_attr_verify_args);
+		ioend->io_bio.bi_end_io = &xfs_read_end_io;
+		return;
+	}
+
+	if (!fsverity_active(ioend->io_inode))
+		return;
+
+	INIT_WORK(&ioend->io_work, &iomap_read_fsverity_end_io_work);
+	ioend->io_bio.bi_end_io = &xfs_read_end_io;
+}
+
+static const struct iomap_readpage_ops xfs_readpage_ops = {
+	.prepare_ioend		= &xfs_prepare_read_ioend,
+};
+
 STATIC int
 xfs_vm_read_folio(
 	struct file		*unused,
 	struct folio		*folio)
 {
-	return iomap_read_folio(folio, &xfs_read_iomap_ops);
+	struct iomap_readpage_ops xfs_readpage_ops = {
+		.prepare_ioend	= xfs_prepare_read_ioend
+	};
+	struct iomap_readpage_ctx ctx = {
+		.cur_folio	= folio,
+		.ops		= &xfs_readpage_ops,
+	};
+
+	return iomap_read_folio_ctx(&ctx, &xfs_read_iomap_ops);
 }
 
 STATIC void
 xfs_vm_readahead(
 	struct readahead_control	*rac)
 {
-	iomap_readahead(rac, &xfs_read_iomap_ops);
+	struct iomap_readpage_ctx ctx = {
+		.rac = rac,
+		.ops = &xfs_readpage_ops,
+	};
+
+	iomap_readahead_ctx(&ctx, &xfs_read_iomap_ops);
 }
 
 static int
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 28dde215c899..3962ce5e3023 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -21,6 +21,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
+#include "xfs_fsverity.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
new file mode 100644
index 000000000000..0af0f22ff075
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.c
@@ -0,0 +1,471 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 Red Hat, Inc.
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_log_format.h"
+#include "xfs_attr.h"
+#include "xfs_verity.h"
+#include "xfs_bmap_util.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_trace.h"
+#include "xfs_quota.h"
+#include "xfs_ag.h"
+#include "xfs_fsverity.h"
+#include "xfs_iomap.h"
+#include "xfs_bmap.h"
+#include "xfs_format.h"
+#include <linux/fsverity.h>
+#include <linux/iomap.h>
+
+/*
+ * Initialize an args structure to load or store the fsverity descriptor.
+ * Caller must ensure @args is zeroed except for value and valuelen.
+ */
+static inline void
+xfs_fsverity_init_vdesc_args(
+	struct xfs_inode	*ip,
+	struct xfs_da_args	*args)
+{
+	args->geo = ip->i_mount->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK,
+	args->attr_filter = XFS_ATTR_VERITY;
+	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->dp = ip;
+	args->owner = ip->i_ino;
+	args->name = XFS_VERITY_DESCRIPTOR_NAME;
+	args->namelen = XFS_VERITY_DESCRIPTOR_NAME_LEN;
+	xfs_attr_sethash(args);
+}
+
+/*
+ * Initialize an args structure to load or store a merkle tree block.
+ * Caller must ensure @args is zeroed except for value and valuelen.
+ */
+inline void
+xfs_fsverity_init_merkle_args(
+	struct xfs_inode	*ip,
+	struct xfs_merkle_key	*key,
+	uint64_t		merkleoff,
+	struct xfs_da_args	*args)
+{
+	xfs_merkle_key_to_disk(key, merkleoff);
+	args->geo = ip->i_mount->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK,
+	args->attr_filter = XFS_ATTR_VERITY;
+	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->dp = ip;
+	args->owner = ip->i_ino;
+	args->name = (const uint8_t *)key;
+	args->namelen = sizeof(struct xfs_merkle_key);
+	args->region_offset = XFS_FSVERITY_MTREE_OFFSET;
+	xfs_attr_sethash(args);
+}
+
+/* Delete the verity descriptor. */
+static int
+xfs_fsverity_delete_descriptor(
+	struct xfs_inode	*ip)
+{
+	struct xfs_da_args	args = { };
+
+	xfs_fsverity_init_vdesc_args(ip, &args);
+	return xfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false);
+}
+
+/* Delete a merkle tree block. */
+static int
+xfs_fsverity_delete_merkle_block(
+	struct xfs_inode	*ip,
+	u64			pos)
+{
+	struct xfs_merkle_key	name;
+	struct xfs_da_args	args = { };
+
+	xfs_fsverity_init_merkle_args(ip, &name, pos, &args);
+	return xfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false);
+}
+
+/* Retrieve the verity descriptor. */
+static int
+xfs_fsverity_get_descriptor(
+	struct inode		*inode,
+	void			*buf,
+	size_t			buf_size)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_da_args	args = {
+		.value		= buf,
+		.valuelen	= buf_size,
+	};
+	int			error = 0;
+
+	/*
+	 * The fact that (returned attribute size) == (provided buf_size) is
+	 * checked by xfs_attr_copy_value() (returns -ERANGE).  No descriptor
+	 * is treated as a short read so that common fsverity code will
+	 * complain.
+	 */
+	xfs_fsverity_init_vdesc_args(ip, &args);
+	error = xfs_attr_get(&args);
+	if (error == -ENOATTR)
+		return 0;
+	if (error)
+		return error;
+
+	return args.valuelen;
+}
+
+/*
+ * Clear out old fsverity metadata before we start building a new one.  This
+ * could happen if, say, we crashed while building fsverity data.
+ */
+static int
+xfs_fsverity_delete_stale_metadata(
+	struct xfs_inode	*ip,
+	u64			new_tree_size,
+	unsigned int		tree_blocksize)
+{
+	u64			pos;
+	int			error = 0;
+
+	/*
+	 * Delete as many merkle tree blocks in increasing blkno order until we
+	 * don't find any more.  That ought to be good enough for avoiding
+	 * dead bloat without excessive runtime.
+	 */
+	for (pos = new_tree_size; !error; pos += tree_blocksize) {
+		if (fatal_signal_pending(current))
+			return -EINTR;
+		error = xfs_fsverity_delete_merkle_block(ip, pos);
+		if (error)
+			break;
+	}
+
+	return error != -ENOATTR ? error : 0;
+}
+
+/* Prepare to enable fsverity by clearing old metadata. */
+static int
+xfs_fsverity_begin_enable(
+	struct file		*filp,
+	u64			merkle_tree_size,
+	unsigned int		tree_blocksize)
+{
+	struct inode		*inode = file_inode(filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
+
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
+
+	if (IS_DAX(inode))
+		return -EINVAL;
+
+	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
+		return -EBUSY;
+
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
+	return xfs_fsverity_delete_stale_metadata(ip, merkle_tree_size,
+			tree_blocksize);
+}
+
+/* Try to remove all the fsverity metadata after a failed enablement. */
+static int
+xfs_fsverity_delete_metadata(
+	struct xfs_inode	*ip,
+	u64			merkle_tree_size,
+	unsigned int		tree_blocksize)
+{
+	u64			pos;
+	int			error;
+
+	if (!merkle_tree_size)
+		return 0;
+
+	for (pos = 0; pos < merkle_tree_size; pos += tree_blocksize) {
+		if (fatal_signal_pending(current))
+			return -EINTR;
+		error = xfs_fsverity_delete_merkle_block(ip, pos);
+		if (error == -ENOATTR)
+			error = 0;
+		if (error)
+			return error;
+	}
+
+	error = xfs_fsverity_delete_descriptor(ip);
+	return error != -ENOATTR ? error : 0;
+}
+
+/* Complete (or fail) the process of enabling fsverity. */
+static int
+xfs_fsverity_end_enable(
+	struct file		*filp,
+	const void		*desc,
+	size_t			desc_size,
+	u64			merkle_tree_size,
+	unsigned int		tree_blocksize)
+{
+	struct xfs_da_args	args = {
+		.value		= (void *)desc,
+		.valuelen	= desc_size,
+	};
+	struct inode		*inode = file_inode(filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error = 0;
+
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
+
+	/* fs-verity failed, just cleanup */
+	if (desc == NULL)
+		goto out;
+
+	xfs_fsverity_init_vdesc_args(ip, &args);
+	error = xfs_attr_set(&args, XFS_ATTRUPDATE_UPSERT, false);
+	if (error)
+		goto out;
+
+	error = filemap_write_and_wait(inode->i_mapping);
+	if (error)
+		goto out;
+
+	/* Set fsverity inode flag */
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
+			0, 0, false, &tp);
+	if (error)
+		goto out;
+
+	/*
+	 * Ensure that we've persisted the verity information before we enable
+	 * it on the inode and tell the caller we have sealed the inode.
+	 */
+	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	if (!error)
+		inode->i_flags |= S_VERITY;
+
+out:
+	if (error) {
+		int	error2;
+
+		error2 = xfs_fsverity_delete_metadata(ip,
+				merkle_tree_size, tree_blocksize);
+		if (error2)
+			xfs_alert(ip->i_mount,
+ "ino 0x%llx failed to clean up new fsverity metadata, err %d",
+					ip->i_ino, error2);
+	}
+
+	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
+	return error;
+}
+
+static int
+xfs_fsverity_read_iomap_begin(
+	struct inode		*inode,
+	loff_t			pos,
+	loff_t			length,
+	unsigned		flags,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_merkle_key	name;
+	struct xfs_da_args	args = { };
+
+	pos = pos & XFS_FSVERITY_MTREE_MASK;
+	xfs_fsverity_init_merkle_args(ip, &name, pos, &args);
+
+	return xfs_attr_read_iomap(&args, iomap);
+}
+
+const struct iomap_ops xfs_fsverity_read_iomap_ops = {
+	.iomap_begin = xfs_fsverity_read_iomap_begin,
+};
+
+static int
+xfs_fsverity_write_iomap_begin(
+	struct inode		*inode,
+	loff_t			pos,
+	loff_t			length,
+	unsigned		flags,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_da_args	args;
+	struct xfs_merkle_key	name;
+	loff_t			xattr_name;
+	unsigned int		xattr_size;
+	int			error;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	pos = pos & XFS_FSVERITY_MTREE_MASK;
+
+	/* We always allocate one xattr block, as this block will be used by
+	 * iomap. Even for smallest Merkle trees */
+	/* TODO this can be optimized to use shortname attributes */
+	xattr_size = mp->m_attr_geo->blksize;
+	xattr_name = pos & ~(xattr_size - 1);
+
+	xfs_fsverity_init_merkle_args(ip, &name, xattr_name, &args);
+	args.valuelen = xattr_size;
+	args.region_offset = XFS_FSVERITY_MTREE_OFFSET;
+
+	error = xfs_attr_write_iomap(&args, iomap);
+	if (error)
+		return error;
+
+	/* Offset into xattr block. One block can have multiple merkle tree
+	 * blocks */
+	iomap->offset += (pos & (xattr_size - 1));
+	/* Instead of attribute size (which blksize) use requested
+	 * size */
+	iomap->length = length;
+
+	return 0;
+}
+
+int
+xfs_fsverity_end_ioend(
+	struct xfs_inode	*ip,
+	struct iomap_ioend	*ioend)
+{
+	struct xfs_da_args	args;
+	struct xfs_merkle_key	name;
+	loff_t			pos;
+	struct bio		bio = ioend->io_bio;
+	void			*addr;
+	int			error;
+	struct folio		*folio = bio_first_folio_all(&bio);
+
+	pos = ioend->io_offset & XFS_FSVERITY_MTREE_MASK;
+	xfs_fsverity_init_merkle_args(ip, &name, pos, &args);
+	args.valuelen = ioend->io_size;
+	addr = kmap_local_folio(folio, 0);
+	args.value = addr;
+	error = xfs_attr_write_end_ioend(&args);
+	kunmap_local(addr);
+
+	return error;
+}
+
+const struct iomap_ops xfs_fsverity_write_iomap_ops = {
+	.iomap_begin = xfs_fsverity_write_iomap_begin,
+};
+
+void
+xfs_attr_verify_args(
+		struct work_struct	*work)
+{
+	struct xfs_inode		*ip;
+	void				*addr;
+	struct xfs_merkle_key		name;
+	struct xfs_da_args		args;
+	int				error;
+	struct iomap_read_ioend		*ioend =
+		container_of(work, struct iomap_read_ioend, io_work);
+	struct bio			*bio = &ioend->io_bio;
+	struct folio			*folio = bio_first_folio_all(bio);
+
+	ip = XFS_I(ioend->io_inode);
+	xfs_fsverity_init_merkle_args(ip, &name, ioend->io_offset, &args);
+	addr = kmap_local_folio(folio, 0);
+	args.valuelen = ioend->io_size;
+	args.value = addr;
+	error = xfs_attr_read_end_io(&args);
+	kunmap_local(addr);
+	if (error)
+		bio->bi_status = BLK_STS_IOERR;
+	iomap_read_end_io(bio);
+}
+
+/* Retrieve a merkle tree block. */
+static struct page *
+xfs_fsverity_read_merkle(
+	struct inode	*inode,
+	pgoff_t		index,
+	unsigned long	num_ra_pages)
+{
+	struct folio	*folio;
+	unsigned int	block_size;
+	u64		tree_size;
+	int		error;
+	u8		log_blocksize;
+
+	error = fsverity_merkle_tree_geometry(inode, &log_blocksize, &block_size,
+				      &tree_size);
+	if (error)
+		return ERR_PTR(error);
+
+	struct ioregion region = {
+		.inode = inode,
+		.pos = index << log_blocksize,
+		.length = block_size,
+		.offset = XFS_FSVERITY_MTREE_OFFSET,
+		.ops = &xfs_fsverity_read_iomap_ops,
+	};
+
+	folio = iomap_read_region(&region);
+	if (IS_ERR(folio))
+		return ERR_CAST(folio);
+
+	/* Wait for buffered read to finish */
+	error = folio_wait_locked_killable(folio);
+	if (error)
+		return ERR_PTR(error);
+	if (IS_ERR(folio) || !folio_test_uptodate(folio))
+		return ERR_PTR(-EFSCORRUPTED);
+
+	return folio_file_page(folio, 0);
+}
+
+/* Write a merkle tree block. */
+static int
+xfs_fsverity_write_merkle(
+	struct inode	*inode,
+	const void	*buf,
+	u64		pos,
+	unsigned int	size)
+{
+	struct ioregion region = {
+		.inode = inode,
+		.pos = pos,
+		.buf = buf,
+		.length = size,
+		.offset = XFS_FSVERITY_MTREE_OFFSET,
+		.ops = &xfs_fsverity_write_iomap_ops,
+	};
+
+	return iomap_write_region(&region);
+}
+
+const struct fsverity_operations xfs_fsverity_ops = {
+	.begin_enable_verity		= xfs_fsverity_begin_enable,
+	.end_enable_verity		= xfs_fsverity_end_enable,
+	.get_verity_descriptor		= xfs_fsverity_get_descriptor,
+	.read_merkle_tree_page		= xfs_fsverity_read_merkle,
+	.write_merkle_tree_block	= xfs_fsverity_write_merkle,
+};
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
new file mode 100644
index 000000000000..c14b01508349
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Red Hat, Inc.
+ */
+#ifndef __XFS_FSVERITY_H__
+#define __XFS_FSVERITY_H__
+
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include <linux/iomap.h>
+
+#ifdef CONFIG_FS_VERITY
+
+/* Merkle tree location in page cache. We take memory region from the inode's
+ * address space for Merkle tree. */
+#define XFS_FSVERITY_MTREE_OFFSET (1 << 30)
+#define XFS_FSVERITY_MTREE_MASK (XFS_FSVERITY_MTREE_OFFSET - 1)
+
+inline void
+xfs_fsverity_init_merkle_args(
+	struct xfs_inode	*ip,
+	struct xfs_merkle_key	*key,
+	uint64_t		merkleoff,
+	struct xfs_da_args	*args);
+
+struct xfs_merkle_bkey {
+	/* inumber of the file */
+	xfs_ino_t		ino;
+
+	/* the position of the block in the Merkle tree (in bytes) */
+	u64			pos;
+};
+
+int
+xfs_fsverity_end_ioend(
+	struct xfs_inode	*ip,
+	struct iomap_ioend	*ioend);
+
+static inline bool
+xfs_fsverity_in_region(
+		loff_t pos)
+{
+	return pos >= XFS_FSVERITY_MTREE_OFFSET;
+};
+void xfs_attr_verify_args(struct work_struct *work);
+
+extern const struct fsverity_operations xfs_fsverity_ops;
+#else
+#define xfs_fsverity_bmbt_irec(ip, key, merkleoff, args) (0)
+#define xfs_fsverity_end_ioend(ip, ioend) (0)
+#endif	/* CONFIG_FS_VERITY */
+
+#endif	/* __XFS_FSVERITY_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1648dc5a8068..e0b2e7acdf74 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -404,6 +404,8 @@ xfs_inode_can_atomicwrite(
  */
 #define XFS_IREMAPPING		(1U << 15)
 
+#define XFS_VERITY_CONSTRUCTION	(1U << 16) /* merkle tree construction */
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8347268af727..d6cbd675e96a 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -53,5 +53,7 @@ extern const struct iomap_ops xfs_read_iomap_ops;
 extern const struct iomap_ops xfs_seek_iomap_ops;
 extern const struct iomap_ops xfs_xattr_iomap_ops;
 extern const struct iomap_ops xfs_dax_write_iomap_ops;
+extern const struct iomap_ops xfs_fsverity_read_iomap_ops;
+extern const struct iomap_ops xfs_fsverity_write_iomap_ops;
 
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5918f433dba7..0f60eedf3d76 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -37,6 +37,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
+#include "xfs_fsverity.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3de6717e4fad..88862092f838 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -30,6 +30,7 @@
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
 #include "xfs_sysfs.h"
+#include "xfs_fsverity.h"
 #include "xfs_ondisk.h"
 #include "xfs_rmap_item.h"
 #include "xfs_refcount_item.h"
@@ -53,6 +54,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/fsverity.h>
+#include <linux/iomap.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -1555,6 +1557,9 @@ xfs_fs_fill_super(
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	sb->s_op = &xfs_super_operations;
+#ifdef CONFIG_FS_VERITY
+	sb->s_vop = &xfs_fsverity_ops;
+#endif
 
 	/*
 	 * Delay mount work if the debug hook is set. This is debug
@@ -1799,6 +1804,10 @@ xfs_fs_fill_super(
 		xfs_set_resuming_quotaon(mp);
 	mp->m_qflags &= ~XFS_QFLAGS_MNTOPTS;
 
+	if (xfs_has_verity(mp))
+		xfs_warn(mp,
+	"EXPERIMENTAL fsverity feature in use. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 8f530e69c18a..6e5a1b17c2f4 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -49,6 +49,7 @@
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
 #include "xfs_rtgroup.h"
+#include "xfs_fsverity.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index de937b3770d3..0bd6d1e992e2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -98,6 +98,7 @@ struct xfs_rmap_intent;
 struct xfs_refcount_intent;
 struct xfs_metadir_update;
 struct xfs_rtgroup;
+struct xfs_merkle_bkey;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -5576,6 +5577,44 @@ DEFINE_EVENT(xfs_metadir_class, name, \
 	TP_ARGS(dp, name, ino))
 DEFINE_METADIR_EVENT(xfs_metadir_lookup);
 
+#ifdef CONFIG_FS_VERITY
+DECLARE_EVENT_CLASS(xfs_fsverity_cache_class,
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_merkle_bkey *key,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, key, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(u64, pos)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = key->ino;
+		__entry->pos = key->pos;
+		__entry->caller_ip = (void *)caller_ip;
+	),
+	TP_printk("dev %d:%d ino 0x%llx pos 0x%llx caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->pos,
+		  __entry->caller_ip)
+)
+
+#define DEFINE_XFS_FSVERITY_CACHE_EVENT(name) \
+DEFINE_EVENT(xfs_fsverity_cache_class, name, \
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_merkle_bkey *key, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, key, caller_ip))
+DEFINE_XFS_FSVERITY_CACHE_EVENT(xfs_fsverity_cache_miss);
+DEFINE_XFS_FSVERITY_CACHE_EVENT(xfs_fsverity_cache_hit);
+DEFINE_XFS_FSVERITY_CACHE_EVENT(xfs_fsverity_cache_reuse);
+DEFINE_XFS_FSVERITY_CACHE_EVENT(xfs_fsverity_cache_store);
+DEFINE_XFS_FSVERITY_CACHE_EVENT(xfs_fsverity_cache_drop);
+DEFINE_XFS_FSVERITY_CACHE_EVENT(xfs_fsverity_cache_unmount);
+DEFINE_XFS_FSVERITY_CACHE_EVENT(xfs_fsverity_cache_reclaim);
+#endif /* CONFIG_XFS_VERITY */
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.47.0

