Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF47C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBPUnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBPUnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:43:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E032050356
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EB9960A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9CFC43443;
        Thu, 16 Feb 2023 20:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580231;
        bh=uIqo2ctPozZkfZRTnHo3CVuA9CaepXvanhsgeEufeW8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fe+yZXjiemLITybaLmfp+q6LN6Z/gZ1JloP6MJvLuCIJXeH67qdalh+1xqjQMuRhs
         Kqf2zhCSf2X6PoAZSaVoJyUr6WGkhD5BzhEoOinYQz0jTXLZNYWWnoC2C8iUqFwzHI
         lszhi1bjJNvTGeA/zMHRaS9Oo7eMgrajGENWDhKuvFaOS4P/S4ERs9mSvaD2PLsbEE
         mKyL2Hgipr10u2n6VJG2dRI5uHOLtw2BhGINGB3igWsmwdtvy2PRkEtyTULkNxEwZ/
         fy54Ehes+ITaHK4jZWE9jCpCprJjzULJcPmHSZ/5Ecf19DP6QlplQHNqxrLinzFS70
         rT+RtdwQcAEhQ==
Date:   Thu, 16 Feb 2023 12:43:51 -0800
Subject: [PATCH 08/23] xfs: port xbitmap_test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873950.3474338.147729841394735200.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile       |    2 +-
 fs/xfs/scrub/bitmap.c |   22 ++++++++++++++++++++++
 fs/xfs/scrub/bitmap.h |    2 ++
 3 files changed, 25 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 42d0496fdad7..2de5a71a2fa3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -147,6 +147,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader.o \
 				   alloc.o \
 				   attr.o \
+				   bitmap.o \
 				   bmap.o \
 				   btree.o \
 				   common.o \
@@ -170,7 +171,6 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
-				   bitmap.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 1b04d2ce020a..14caff0a28ce 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -396,3 +396,25 @@ xbitmap_empty(
 {
 	return bitmap->xb_root.rb_root.rb_node == NULL;
 }
+
+/* Is the start of the range set or clear?  And for how long? */
+bool
+xbitmap_test(
+	struct xbitmap		*bitmap,
+	uint64_t		start,
+	uint64_t		*len)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		last = start + *len - 1;
+
+	bn = xbitmap_tree_iter_first(&bitmap->xb_root, start, last);
+	if (!bn)
+		return false;
+	if (bn->bn_start <= start) {
+		if (bn->bn_last < last)
+			*len = bn->bn_last - start + 1;
+		return true;
+	}
+	*len = bn->bn_start - start;
+	return false;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 7afd64a318d1..dd492798b7af 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -39,4 +39,6 @@ int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 
 bool xbitmap_empty(struct xbitmap *bitmap);
 
+bool xbitmap_test(struct xbitmap *bitmap, uint64_t start, uint64_t *len);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */

