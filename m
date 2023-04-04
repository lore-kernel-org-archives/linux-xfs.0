Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0EBC6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbjDDO43 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbjDDO4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B364495
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z32N0rKUyphSVMSofzw3CVH4IfYQ7TTzuKWmER1MJ68=;
        b=NMBThs9fBzHBwHMNrsOXYH5g6jNOcD7L7l/fE7MSv0TDmnl1alMEes//4H1JHlulukebVh
        kkrIkVsMDmTTQNz1J/l/XtujR4lMRWcNz/yoKBmomHRjQaAJcUXWkYm5PuY2ZCCd2WuFvu
        zuwtpvkXxK2/xrl0IHXbM7reOVkxGLc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-P2q_Cu2ZN6qEccYUqACzcA-1; Tue, 04 Apr 2023 10:55:03 -0400
X-MC-Unique: P2q_Cu2ZN6qEccYUqACzcA-1
Received: by mail-qv1-f72.google.com with SMTP id f3-20020a0cc303000000b005c9966620daso14610600qvi.4
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z32N0rKUyphSVMSofzw3CVH4IfYQ7TTzuKWmER1MJ68=;
        b=VB+u9TPmi6DueDsmviIByXZxNPuowZbm+DYuRTxTJHk87+t0pO+KqteIdi25we+P6T
         PbBbakt6iIKOFYcAsNkr3NxvpLPqiiFXkr3wbJnBaMLdKuij1Usx//MS20sVXJeBnC9b
         2Mt2YGF6eFtlYrs3NdrjcZbpiRI+Ja+SyHId/+O4cfOtJL9mGlEiQwRqwFFH0O6kBPeX
         2kduMzibo1OMuTUPJbzrYR72Qs4zP43vl7ixPBMfS/ZYIRNu8pSo7SAkav309Qw1TuFC
         zSbdNWOqbVKPjADZ/0HuMqtkeWUomev2oAXC3tzbaP9aN1O3b1w9YW2TS6lt6PuH6bT9
         7MHw==
X-Gm-Message-State: AAQBX9fTCYb5lGvZO+PFm7oM7Htwvussfdy3JMYnBSpJSzhNumJAUur9
        TnXJq0rxTOP6qKmNws9ceOJ5nK89Qz04uCbFmUfiuTwmBJMPZSUWOUC9OMyL7R8dsOYchAtBEj6
        A/OvgYTJOY+7gEPNl26Q=
X-Received: by 2002:a05:622a:106:b0:3e4:ed0d:6a87 with SMTP id u6-20020a05622a010600b003e4ed0d6a87mr3825573qtw.32.1680620102989;
        Tue, 04 Apr 2023 07:55:02 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zp0JOhVAHhC6Iyf8k/1+phPOce9sQ42GmA8VSWN8AvlHBpCO2hspsjGFg8IADdMrX46OgtcA==
X-Received: by 2002:a05:622a:106:b0:3e4:ed0d:6a87 with SMTP id u6-20020a05622a010600b003e4ed0d6a87mr3825521qtw.32.1680620102599;
        Tue, 04 Apr 2023 07:55:02 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:02 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 06/23] fsverity: add drop_page() callout
Date:   Tue,  4 Apr 2023 16:53:02 +0200
Message-Id: <20230404145319.2057051-7-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Allow filesystem to make additional processing on verified pages
instead of just dropping a reference. This will be used by XFS for
internal buffer cache manipulation in further patches. The btrfs,
ext4, and f2fs just drop the reference.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/btrfs/verity.c         | 12 ++++++++++++
 fs/ext4/verity.c          |  6 ++++++
 fs/f2fs/verity.c          |  6 ++++++
 fs/verity/read_metadata.c |  4 ++--
 fs/verity/verify.c        |  6 +++---
 include/linux/fsverity.h  | 10 ++++++++++
 6 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index c5ff16f9e9fa..4c2c09204bb4 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -804,10 +804,22 @@ static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
 			       pos, buf, size);
 }
 
+/*
+ * fsverity op that releases the reference obtained by ->read_merkle_tree_page()
+ *
+ * @page:  reference to the page which can be released
+ *
+ */
+static void btrfs_drop_page(struct page *page)
+{
+	put_page(page);
+}
+
 const struct fsverity_operations btrfs_verityops = {
 	.begin_enable_verity     = btrfs_begin_enable_verity,
 	.end_enable_verity       = btrfs_end_enable_verity,
 	.get_verity_descriptor   = btrfs_get_verity_descriptor,
 	.read_merkle_tree_page   = btrfs_read_merkle_tree_page,
 	.write_merkle_tree_block = btrfs_write_merkle_tree_block,
+	.drop_page		 = &btrfs_drop_page,
 };
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index e4da1704438e..35a2feb6fd68 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -388,10 +388,16 @@ static int ext4_write_merkle_tree_block(struct inode *inode, const void *buf,
 	return pagecache_write(inode, buf, size, pos);
 }
 
+static void ext4_drop_page(struct page *page)
+{
+	put_page(page);
+}
+
 const struct fsverity_operations ext4_verityops = {
 	.begin_enable_verity	= ext4_begin_enable_verity,
 	.end_enable_verity	= ext4_end_enable_verity,
 	.get_verity_descriptor	= ext4_get_verity_descriptor,
 	.read_merkle_tree_page	= ext4_read_merkle_tree_page,
 	.write_merkle_tree_block = ext4_write_merkle_tree_block,
+	.drop_page		= &ext4_drop_page,
 };
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 4fc95f353a7a..019c7a6c6bcf 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -283,10 +283,16 @@ static int f2fs_write_merkle_tree_block(struct inode *inode, const void *buf,
 	return pagecache_write(inode, buf, size, pos);
 }
 
+static void f2fs_drop_page(struct page *page)
+{
+	put_page(page);
+}
+
 const struct fsverity_operations f2fs_verityops = {
 	.begin_enable_verity	= f2fs_begin_enable_verity,
 	.end_enable_verity	= f2fs_end_enable_verity,
 	.get_verity_descriptor	= f2fs_get_verity_descriptor,
 	.read_merkle_tree_page	= f2fs_read_merkle_tree_page,
 	.write_merkle_tree_block = f2fs_write_merkle_tree_block,
+	.drop_page		= &f2fs_drop_page,
 };
diff --git a/fs/verity/read_metadata.c b/fs/verity/read_metadata.c
index 2aefc5565152..cab1612bf4a3 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -56,12 +56,12 @@ static int fsverity_read_merkle_tree(struct inode *inode,
 		virt = kmap_local_page(page);
 		if (copy_to_user(buf, virt + offs_in_page, bytes_to_copy)) {
 			kunmap_local(virt);
-			put_page(page);
+			inode->i_sb->s_vop->drop_page(page);
 			err = -EFAULT;
 			break;
 		}
 		kunmap_local(virt);
-		put_page(page);
+		inode->i_sb->s_vop->drop_page(page);
 
 		retval += bytes_to_copy;
 		buf += bytes_to_copy;
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index f50e3b5b52c9..c2fc4c86af34 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -210,7 +210,7 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		if (is_hash_block_verified(vi, hpage, hblock_idx)) {
 			memcpy_from_page(_want_hash, hpage, hoffset, hsize);
 			want_hash = _want_hash;
-			put_page(hpage);
+			inode->i_sb->s_vop->drop_page(hpage);
 			goto descend;
 		}
 		hblocks[level].page = hpage;
@@ -248,7 +248,7 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 			SetPageChecked(hpage);
 		memcpy_from_page(_want_hash, hpage, hoffset, hsize);
 		want_hash = _want_hash;
-		put_page(hpage);
+		inode->i_sb->s_vop->drop_page(hpage);
 	}
 
 	/* Finally, verify the data block. */
@@ -259,7 +259,7 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 	err = cmp_hashes(vi, want_hash, real_hash, data_pos, -1);
 out:
 	for (; level > 0; level--)
-		put_page(hblocks[level - 1].page);
+		inode->i_sb->s_vop->drop_page(hblocks[level - 1].page);
 
 	return err == 0;
 }
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 6d7a4b3ea626..3e923a8e0d6f 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -120,6 +120,16 @@ struct fsverity_operations {
 	 */
 	int (*write_merkle_tree_block)(struct inode *inode, const void *buf,
 				       u64 pos, unsigned int size);
+
+	/**
+	 * Release the reference to a Merkle tree page
+	 *
+	 * @page: the page to release
+	 *
+	 * This is called when fs-verity is done with a page obtained with
+	 * ->read_merkle_tree_page().
+	 */
+	void (*drop_page)(struct page *page);
 };
 
 #ifdef CONFIG_FS_VERITY
-- 
2.38.4

