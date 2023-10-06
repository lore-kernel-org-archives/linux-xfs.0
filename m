Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268D2E94101
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbjJFSzU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbjJFSyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1B5118
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=etHlCA8T/PaxWUxEWZ1DvVJeeVyrnJ0a0ek/fvsTpN8=;
        b=AO2ERmYKUmpkSCDVm84IJkCxZgVXfEZl+YIBEqG+AlcFqX/hMNjdq+zwR8lEvlRicRRiEm
        0oNRigzxj1UVt7jnyGvnOgD6OCl0iNWAFyREU0q7ZW5neqjj+5JzTs2iX0vkN79TR1eT7O
        nAwQpgL9X6KfE1rIbT6zarvpKP2Toso=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-xifcPG94NDuudZHil9CspA-1; Fri, 06 Oct 2023 14:52:40 -0400
X-MC-Unique: xifcPG94NDuudZHil9CspA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-993eeb3a950so189276666b.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618359; x=1697223159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=etHlCA8T/PaxWUxEWZ1DvVJeeVyrnJ0a0ek/fvsTpN8=;
        b=bMoNpBHLxA/F4JU43xxJA5GXzKIEkD+tdD+/vFMvSzD/zlEYmtEp+K4dm+hmdqiYWH
         w2RBZEkyvAHAEipWaezsdrtmHyE0Ml8ttb6b9eAZW/saQwN7gPmVjMpbqSmm9nrto7QK
         pHt4eW8MGwpml87C/HmLrIFEbbcnUoJZqmEZvyHt+zc8DBzl9jWc9Lo9e52D92yKmYZa
         HUHcmQydp4M2vXVl6QWrqy6YAYS+EyRjaAxZkij4VvPBEMYcXvH9AJlGali0EAMAKiky
         eyFE6BT6SJW920+zGWaduvu/v0NlLTJwbeOHQIF/Vwjj49TEMP6eKxCtMp+NINGMrocu
         tNwQ==
X-Gm-Message-State: AOJu0Yx9GQOFqHxYgYbIds3h1WrIjNJY8vGWlSo1p0hLRA3Ph2trZDxt
        QOFLVhxx4zMBpC5EL70PGnAdC5cat1d/tudpU4WhN+WNBf5xuolXklf/Nn3V9b2ddGq3yCJgLCE
        QI7+c5LDAxQGsRbkDzdibVjeVZp8vVnREmSUrlGpsd/pldmbQnMrkCHpiunOZnoJ07uofh6DQ7E
        wcK6w=
X-Received: by 2002:a17:906:cc53:b0:9ae:5523:3f8e with SMTP id mm19-20020a170906cc5300b009ae55233f8emr8487894ejb.63.1696618359291;
        Fri, 06 Oct 2023 11:52:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF73s7VGFatKV6LUYuO61TYbYu4BE1wLl/SWf4Vq8QcPJ6yV/S+GMfoQzJ3iL6XWu4mnlQgEg==
X-Received: by 2002:a17:906:cc53:b0:9ae:5523:3f8e with SMTP id mm19-20020a170906cc5300b009ae55233f8emr8487881ejb.63.1696618359073;
        Fri, 06 Oct 2023 11:52:39 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:38 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 22/28] xfs: initialize fs-verity on file open and cleanup on inode destruction
Date:   Fri,  6 Oct 2023 20:49:16 +0200
Message-Id: <20231006184922.252188-23-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c  | 8 ++++++++
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..a92c8197c26a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -31,6 +31,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1191,10 +1192,17 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error = 0;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
 			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3cdb642961f4..6a3b5285044a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -47,6 +47,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -673,6 +674,7 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
+	fsverity_cleanup_inode(inode);
 	xfs_inode_mark_reclaimable(ip);
 }
 
-- 
2.40.1

