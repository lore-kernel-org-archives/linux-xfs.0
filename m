Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4695CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357653AbiATA07 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA07 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A90DC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9A661511
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504D7C004E1;
        Thu, 20 Jan 2022 00:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638418;
        bh=mcM4Qh4uy4jiKN55wmGVnb5YajDug06iq3p3in2MhG4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PjOPRyN3DvdVhfWG0+/BkrW8LKN5s4LB9+xDJ8+d2F3jylh5snBSiOvIFV7NBlija
         SudI4hkMnBarIOdzWgXRCuCRGq5i30dB8L7aWtNYAt+HPLlM1n+/SJXv+tpmDzEI0Z
         ZI4g4/uSlacpUu15u1SMFdqTiPFlcAPI0ucwH77aegmM/z0xJWMOYUts+lAM2nU01I
         6ec3bbxqTt3T5Lj0+1sWJm16Bq2n/LCyZWl2SX9Lx70J76PCgU9BKjWjrfrhMK3lLF
         sCSFHLhwu5zwydn/JYLkTHcBz1igX5n3sVmRtjBROVc0VwvfcVqT5qAlR/6JdGI3Ny
         un4dOUVIcvHdw==
Subject: [PATCH 41/48] xfs: compact deferred intent item structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:57 -0800
Message-ID: <164263841795.865554.12508860123797088374.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 9e253954acf53227f33d307f5ac5ff94c1ca5880

Rearrange these structs to reduce the amount of unused padding bytes.
This saves eight bytes for each of the three structs changed here, which
means they're now all (rmap/bmap are 64 bytes, refc is 32 bytes) even
powers of two.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.h     |    2 +-
 libxfs/xfs_refcount.h |    2 +-
 libxfs/xfs_rmap.h     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 2cd7717c..db01fe83 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -257,8 +257,8 @@ enum xfs_bmap_intent_type {
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;
-	struct xfs_inode			*bi_owner;
 	int					bi_whichfork;
+	struct xfs_inode			*bi_owner;
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 02cb3aa4..89404596 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -32,8 +32,8 @@ enum xfs_refcount_intent_type {
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
 	enum xfs_refcount_intent_type		ri_type;
-	xfs_fsblock_t				ri_startblock;
 	xfs_extlen_t				ri_blockcount;
+	xfs_fsblock_t				ri_startblock;
 };
 
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index fd67904e..85dd98ac 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -159,8 +159,8 @@ enum xfs_rmap_intent_type {
 struct xfs_rmap_intent {
 	struct list_head			ri_list;
 	enum xfs_rmap_intent_type		ri_type;
-	uint64_t				ri_owner;
 	int					ri_whichfork;
+	uint64_t				ri_owner;
 	struct xfs_bmbt_irec			ri_bmap;
 };
 

