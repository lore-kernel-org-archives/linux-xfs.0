Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA90C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiATASr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiATASq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B2FC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C1561510
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB285C004E1;
        Thu, 20 Jan 2022 00:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637925;
        bh=V9KED14WUY/JT8WgSJwuQfvFxK/DgkFv/Kstl4Y4NW4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o009PDAMG+my/U3auLy8b4HhHw41iUnoTQ4sO+GYDKH3rF3fk0J7wkTV/t37Um+iq
         Z068SpDUaXIYJ1mkQpPPNOUffMCxk0lFk1ScGy3QLiRtgZBXQXSnyIHlw0K+Xm2Fbg
         fYmbGOazEYfw/nIcO2I3FD4D9CbJJkJOQzCKOFcLVKDdVvwVoK5cB6H8SgToSSDGGt
         MLZjPqV36Aj5wENed8/ZiMAOG3SaT1BGMKQubRbBQqWPuvlH/9obqTQboXU0tD6l9O
         FEfeUo9W+FWVzpCWzQlO6TZePCjv0xjYgPTRwSt7tu8SanbYm7CBVstsCC6ahBcLko
         2J9WVhtLQ1+PA==
Subject: [PATCH 15/45] xfs: mark the record passed into xchk_btree functions
 as const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:45 -0800
Message-ID: <164263792538.860211.10681620497227990371.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 22ece4e836beff1df528ee09cf21ca5fab7235f5

xchk_btree calls a user-supplied function to validate each btree record
that it finds.  Those functions are not supposed to change the record
data, so mark the parameter const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_arch.h      |   10 +++++-----
 libxfs/xfs_bmap_btree.c |    2 +-
 libxfs/xfs_bmap_btree.h |    3 ++-
 3 files changed, 8 insertions(+), 7 deletions(-)


diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 7f973249..d46ae470 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -232,19 +232,19 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
 	*a = cpu_to_be64(be64_to_cpu(*a) + b);
 }
 
-static inline uint16_t get_unaligned_be16(void *p)
+static inline uint16_t get_unaligned_be16(const void *p)
 {
-	uint8_t *__p = p;
+	const uint8_t *__p = p;
 	return __p[0] << 8 | __p[1];
 }
 
-static inline uint32_t get_unaligned_be32(void *p)
+static inline uint32_t get_unaligned_be32(const void *p)
 {
-	uint8_t *__p = p;
+	const uint8_t *__p = p;
         return (uint32_t)__p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
 }
 
-static inline uint64_t get_unaligned_be64(void *p)
+static inline uint64_t get_unaligned_be64(const void *p)
 {
 	return (uint64_t)get_unaligned_be32(p) << 32 |
 			   get_unaligned_be32(p + 4);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index acaf2941..9e2e9926 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -56,7 +56,7 @@ xfs_bmdr_to_bmbt(
 
 void
 xfs_bmbt_disk_get_all(
-	struct xfs_bmbt_rec	*rec,
+	const struct xfs_bmbt_rec *rec,
 	struct xfs_bmbt_irec	*irec)
 {
 	uint64_t		l0 = get_unaligned_be64(&rec->l0);
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 209ded1e..eda85512 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -90,7 +90,8 @@ extern void xfs_bmdr_to_bmbt(struct xfs_inode *, xfs_bmdr_block_t *, int,
 void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(const struct xfs_bmbt_rec *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(const struct xfs_bmbt_rec *r);
-extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
+void xfs_bmbt_disk_get_all(const struct xfs_bmbt_rec *r,
+		struct xfs_bmbt_irec *s);
 
 extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 			xfs_bmdr_block_t *, int);

