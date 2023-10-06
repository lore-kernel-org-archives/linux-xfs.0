Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C96CE81E1F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjJFSx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbjJFSx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:53:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842E0E4
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wj5hMGaY9RCgF1kuAnCk/NqRYGmG4WFEtNC/8xLzEio=;
        b=ELScyJpHQIT3VZJOXt23KTcTOc3UcohSsTEPWTVYe+JFO6EpqTmnSN1Z7qAqmucX+4JVbb
        SWciYPzJvkNPYn4QGw3OLHPhiPfThSEoLUUJ4FOYQYRnQFhU7d96riFZy5TjIrQM4RVW0k
        q9TneYmTtm0XqGebNEneiLNNVpdfV5g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190--dYNi0WrOhWTe_j-5ids5A-1; Fri, 06 Oct 2023 14:52:27 -0400
X-MC-Unique: -dYNi0WrOhWTe_j-5ids5A-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b98bbf130cso207020466b.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618346; x=1697223146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wj5hMGaY9RCgF1kuAnCk/NqRYGmG4WFEtNC/8xLzEio=;
        b=eCvcnuM2/lBT/314OhTd4R2RC/xZoiEX89WGq8DqqLkIaXGTTmn4uKixgybLr5Amgk
         wpNV/7F/rOX3qoIA0K8U4oO6buxe5+3PQJdgWK7B9BMDT+/lDlvbWxJ7dXY2epNPml+A
         Wq6RpAqvP6eP1H7YbPWT1STXhf9ZnWVO8NYj1KC6umghmqpm58EwzxOLXYp+hdsVbeXy
         yBiUQZ0Gl/IjbrWm+3Lfrf9IpJ1tr5ihvtm8EFW1iPDl1UKkTdKYRKiwfS2lnfvz6mGa
         m+RpctIeKZWFexaBYWsep/fokPJwEb05Rm1lnCHfwMm+YB2ShTS5yzXdVLHxUbeBi2rO
         acoQ==
X-Gm-Message-State: AOJu0YywyOmHQTVL+yeVBXk/HP918xM839tMoa/2rRDACpOypUXwi6p6
        jcwgDtdFNDkru/3gAn6xSRJYO9sjzDhJcT+d+smzpNumKLw2U+Hkjrgz+ak0D5XUigGoShOm8qm
        71XF9lsJOjDs1IA5X2Eod5qe9d2K1tXPWq4acqYPOwrp3yYX7anPqTcnafcFMW3EnkJ2Kgikgll
        CSAYM=
X-Received: by 2002:a17:907:d047:b0:9ae:6744:4591 with SMTP id vb7-20020a170907d04700b009ae67444591mr7570437ejc.43.1696618346186;
        Fri, 06 Oct 2023 11:52:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZsbXSDA5dCU5U470HWiK746cPDwE1tLcX0vn7uqd8EYCM3Rp8th3S69Fttrk14CPUXhcckw==
X-Received: by 2002:a17:907:d047:b0:9ae:6744:4591 with SMTP id vb7-20020a170907d04700b009ae67444591mr7570420ejc.43.1696618345847;
        Fri, 06 Oct 2023 11:52:25 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:25 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 08/28] fsverity: pass Merkle tree block size to ->read_merkle_tree_page()
Date:   Fri,  6 Oct 2023 20:49:02 +0200
Message-Id: <20231006184922.252188-9-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS will need to know size of Merkle tree block as these blocks
will not be stored consecutively in fs blocks. Therefore, they could
not be obtained in PAGEs like in ext4. Rather, they are stored under
offsets used as name in extended attributes. The size is needed to
calculate the offset.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/btrfs/verity.c         | 3 ++-
 fs/ext4/verity.c          | 3 ++-
 fs/f2fs/verity.c          | 3 ++-
 fs/verity/read_metadata.c | 3 ++-
 fs/verity/verify.c        | 3 ++-
 include/linux/fsverity.h  | 3 ++-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 744f4f4d4c68..b39199b57a69 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -713,7 +713,8 @@ int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size)
  */
 static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 						pgoff_t index,
-						unsigned long num_ra_pages)
+						unsigned long num_ra_pages,
+						u8 log_blocksize)
 {
 	struct folio *folio;
 	u64 off = (u64)index << PAGE_SHIFT;
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 2f37e1ea3955..4eb77cefdbe1 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -359,7 +359,8 @@ static int ext4_get_verity_descriptor(struct inode *inode, void *buf,
 
 static struct page *ext4_read_merkle_tree_page(struct inode *inode,
 					       pgoff_t index,
-					       unsigned long num_ra_pages)
+					       unsigned long num_ra_pages,
+					       u8 log_blocksize)
 {
 	struct folio *folio;
 
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 4fc95f353a7a..bb354ab8ca5a 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -256,7 +256,8 @@ static int f2fs_get_verity_descriptor(struct inode *inode, void *buf,
 
 static struct page *f2fs_read_merkle_tree_page(struct inode *inode,
 					       pgoff_t index,
-					       unsigned long num_ra_pages)
+					       unsigned long num_ra_pages,
+					       u8 log_blocksize)
 {
 	struct page *page;
 
diff --git a/fs/verity/read_metadata.c b/fs/verity/read_metadata.c
index 8bd4b29a9a95..197624cab43e 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -44,7 +44,8 @@ static int fsverity_read_merkle_tree(struct inode *inode,
 		struct page *page;
 		const void *virt;
 
-		page = vops->read_merkle_tree_page(inode, index, num_ra_pages);
+		page = vops->read_merkle_tree_page(inode, index, num_ra_pages,
+						   vi->tree_params.log_blocksize);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			fsverity_err(inode,
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index e7b13d143ae9..f556336ebd8d 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -120,7 +120,8 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 
 		hpage = inode->i_sb->s_vop->read_merkle_tree_page(inode,
 				hpage_idx, level == 0 ? min(max_ra_pages,
-					params->tree_pages - hpage_idx) : 0);
+					params->tree_pages - hpage_idx) : 0,
+				params->log_blocksize);
 		if (IS_ERR(hpage)) {
 			fsverity_err(inode,
 				     "Error %ld reading Merkle tree page %lu",
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 6514ed6b09b4..252b2668894c 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -103,7 +103,8 @@ struct fsverity_operations {
 	 */
 	struct page *(*read_merkle_tree_page)(struct inode *inode,
 					      pgoff_t index,
-					      unsigned long num_ra_pages);
+					      unsigned long num_ra_pages,
+					      u8 log_blocksize);
 
 	/**
 	 * Write a Merkle tree block to the given inode.
-- 
2.40.1

