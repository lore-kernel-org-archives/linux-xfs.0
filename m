Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2379EE9371B
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjJFSyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbjJFSyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B77E9
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O7XPmH44P+ap8pothWdhiZlYSUyho8+XNKckKHFJIOg=;
        b=WaDfzgzQXkFAW8xt9ap7louC39O3sz+51vr+KUmxixNl9L/wAU1LGTkEk3fTvK13KZCU6l
        O5E4sS1vNFw639eN1Rew8j+Sc9IrtcC7eHuZ29p7li/8psvhPW46s1zIlz2RH7sm4ehs9m
        K20/Crv9Mq6cRQsStrejpYymLK2LaNw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-fMo_qf0uOhmAy5Z13GpKXw-1; Fri, 06 Oct 2023 14:52:28 -0400
X-MC-Unique: fMo_qf0uOhmAy5Z13GpKXw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9ae42088b4bso195964866b.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618347; x=1697223147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7XPmH44P+ap8pothWdhiZlYSUyho8+XNKckKHFJIOg=;
        b=YG+6c7sSsHh4ZMceSo+zCdtIFyNCv6TxcFxBgHuSeM1RAgeSZLFjL37xzpNr8e95qN
         o4dM5q4FUbloYIF+0tKuzmGXxJjCth07aA58+2yNbM2cHcrl83NPd+NeshYGa3n3QGz1
         5nOKt4PgG27on/O8CtQ306vX/Fe8KkRF4N8eUGjlubBu5kE0VzJmPqxBFka1z+zJuiX7
         9P82xTtLwzqG3SoW+R94COKuX/AVXO6+CsCUcto2z8ZiPhixkzJvnT5bHHerThHCZzwS
         0FFdddV49mF/8rWC+c2c9E1FF01zjzpliw+UBJVMXa2WxplVOB8S7aEYBjMH1SnLlFjt
         YZzA==
X-Gm-Message-State: AOJu0Yw75xU4xa6GiLBfH9+9NOVHAdCCe44kIiLcCxE82RUzJOOmiwiq
        qDrekFPZAi5+CLWSEqM2NyDe2wrHCwIhCg5wfjbxUx8WE0eLDwCLA8/6QGlVvvf33bggrIFpfz4
        FAXfYk2nqKNG+RoFxkM0KLjzG/KSrey/VXdKN5ZPF6tnYoJ8L2i9+LQL/HIc/fu/onOQWISDZ4k
        5xgjA=
X-Received: by 2002:a17:906:9c1:b0:9ae:5aa4:9fa with SMTP id r1-20020a17090609c100b009ae5aa409famr8090445eje.42.1696618347087;
        Fri, 06 Oct 2023 11:52:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUhTkv6Y3ms1dW1sNfvoG2u1LCutOMUQtjoa3WTTMfsWftHZEKYPqcdq3cLzDayMSeNmLAOA==
X-Received: by 2002:a17:906:9c1:b0:9ae:5aa4:9fa with SMTP id r1-20020a17090609c100b009ae5aa409famr8090433eje.42.1696618346871;
        Fri, 06 Oct 2023 11:52:26 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:26 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 09/28] fsverity: pass log_blocksize to end_enable_verity()
Date:   Fri,  6 Oct 2023 20:49:03 +0200
Message-Id: <20231006184922.252188-10-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS will need to know log_blocksize to remove the tree in case of an
error. The size is needed to calculate offsets of particular Merkle
tree blocks.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/btrfs/verity.c        | 4 +++-
 fs/ext4/verity.c         | 3 ++-
 fs/f2fs/verity.c         | 3 ++-
 fs/verity/enable.c       | 6 ++++--
 include/linux/fsverity.h | 4 +++-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index b39199b57a69..2b34796f68d3 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -621,6 +621,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
  * @desc:              verity descriptor to write out (NULL in error conditions)
  * @desc_size:         size of the verity descriptor (variable with signatures)
  * @merkle_tree_size:  size of the merkle tree in bytes
+ * @log_blocksize:     log size of the Merkle tree block
  *
  * If desc is null, then VFS is signaling an error occurred during verity
  * enable, and we should try to rollback. Otherwise, attempt to finish verity.
@@ -628,7 +629,8 @@ static int btrfs_begin_enable_verity(struct file *filp)
  * Returns 0 on success, negative error code on error.
  */
 static int btrfs_end_enable_verity(struct file *filp, const void *desc,
-				   size_t desc_size, u64 merkle_tree_size)
+				   size_t desc_size, u64 merkle_tree_size,
+				   u8 log_blocksize)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(filp));
 	int ret = 0;
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 4eb77cefdbe1..4e2f01f048c0 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -189,7 +189,8 @@ static int ext4_write_verity_descriptor(struct inode *inode, const void *desc,
 }
 
 static int ext4_end_enable_verity(struct file *filp, const void *desc,
-				  size_t desc_size, u64 merkle_tree_size)
+				  size_t desc_size, u64 merkle_tree_size,
+				  u8 log_blocksize)
 {
 	struct inode *inode = file_inode(filp);
 	const int credits = 2; /* superblock and inode for ext4_orphan_del() */
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index bb354ab8ca5a..601ab9f0c024 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -144,7 +144,8 @@ static int f2fs_begin_enable_verity(struct file *filp)
 }
 
 static int f2fs_end_enable_verity(struct file *filp, const void *desc,
-				  size_t desc_size, u64 merkle_tree_size)
+				  size_t desc_size, u64 merkle_tree_size,
+				  u8 log_blocksize)
 {
 	struct inode *inode = file_inode(filp);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index c284f46d1b53..c87cab796f0b 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -274,7 +274,8 @@ static int enable_verity(struct file *filp,
 	 * Serialized with ->begin_enable_verity() by the inode lock.
 	 */
 	inode_lock(inode);
-	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
+	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size,
+				      desc->log_blocksize);
 	inode_unlock(inode);
 	if (err) {
 		fsverity_err(inode, "%ps() failed with err %d",
@@ -300,7 +301,8 @@ static int enable_verity(struct file *filp,
 
 rollback:
 	inode_lock(inode);
-	(void)vops->end_enable_verity(filp, NULL, 0, params.tree_size);
+	(void)vops->end_enable_verity(filp, NULL, 0, params.tree_size,
+				      desc->log_blocksize);
 	inode_unlock(inode);
 	goto out;
 }
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 252b2668894c..cac012d4c86a 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -51,6 +51,7 @@ struct fsverity_operations {
 	 * @desc: the verity descriptor to write, or NULL on failure
 	 * @desc_size: size of verity descriptor, or 0 on failure
 	 * @merkle_tree_size: total bytes the Merkle tree took up
+	 * @log_blocksize: log size of the Merkle tree block
 	 *
 	 * If desc == NULL, then enabling verity failed and the filesystem only
 	 * must do any necessary cleanups.  Else, it must also store the given
@@ -65,7 +66,8 @@ struct fsverity_operations {
 	 * Return: 0 on success, -errno on failure
 	 */
 	int (*end_enable_verity)(struct file *filp, const void *desc,
-				 size_t desc_size, u64 merkle_tree_size);
+				 size_t desc_size, u64 merkle_tree_size,
+				 u8 log_blocksize);
 
 	/**
 	 * Get the verity descriptor of the given inode.
-- 
2.40.1

