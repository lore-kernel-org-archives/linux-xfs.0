Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13495C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 21:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBBDF206E2
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 21:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgGHVUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 17:20:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:35580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgGHVUA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Jul 2020 17:20:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6092FAD33;
        Wed,  8 Jul 2020 21:19:58 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de,
        cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 5/6] btrfs: remove BTRFS_INODE_READDIO_NEED_LOCK
Date:   Wed,  8 Jul 2020 16:19:25 -0500
Message-Id: <20200708211926.7706-6-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708211926.7706-1-rgoldwyn@suse.de>
References: <20200708211926.7706-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Since we now perform direct reads using i_rwsem, we can remove this
inode flag used to co-ordinate unlocked reads.

The truncate call takes i_rwsem. This means it is correctly synchronized
with concurrent direct reads.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jth@kernel.org>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/btrfs_inode.h | 18 ------------------
 fs/btrfs/inode.c       |  3 ---
 2 files changed, 21 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index e7d709505cb1..aeff56a0e105 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -28,7 +28,6 @@ enum {
 	BTRFS_INODE_NEEDS_FULL_SYNC,
 	BTRFS_INODE_COPY_EVERYTHING,
 	BTRFS_INODE_IN_DELALLOC_LIST,
-	BTRFS_INODE_READDIO_NEED_LOCK,
 	BTRFS_INODE_HAS_PROPS,
 	BTRFS_INODE_SNAPSHOT_FLUSH,
 };
@@ -313,23 +312,6 @@ struct btrfs_dio_private {
 	u8 csums[];
 };
 
-/*
- * Disable DIO read nolock optimization, so new dio readers will be forced
- * to grab i_mutex. It is used to avoid the endless truncate due to
- * nonlocked dio read.
- */
-static inline void btrfs_inode_block_unlocked_dio(struct btrfs_inode *inode)
-{
-	set_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
-	smp_mb();
-}
-
-static inline void btrfs_inode_resume_unlocked_dio(struct btrfs_inode *inode)
-{
-	smp_mb__before_atomic();
-	clear_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
-}
-
 /* Array of bytes with variable length, hexadecimal format 0x1234 */
 #define CSUM_FMT				"0x%*phN"
 #define CSUM_FMT_VALUE(size, bytes)		size, bytes
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0fa75af35a1f..264b676ebf29 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4835,10 +4835,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 		truncate_setsize(inode, newsize);
 
-		/* Disable nonlocked read DIO to avoid the endless truncate */
-		btrfs_inode_block_unlocked_dio(BTRFS_I(inode));
 		inode_dio_wait(inode);
-		btrfs_inode_resume_unlocked_dio(BTRFS_I(inode));
 
 		ret = btrfs_truncate(inode, newsize == oldsize);
 		if (ret && inode->i_nlink) {
-- 
2.26.2

