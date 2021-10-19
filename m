Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FE3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568D560EFE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhJSSy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234726AbhJSSy0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E5C60E90;
        Tue, 19 Oct 2021 18:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669533;
        bh=IRWWchr0jMrW6oryTo/LIJpaMAqqQw5u6FT48GegpFc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RtnIWQ4NNyy+C4Gtd72T1xDyM6KMJMgfp+XVWsxRZbWVrTRqG2ZsumqLeGQaWhyCG
         AZnRkX9FGhmOTJP8+WPhcTxTmO44bAdQ6KN40QCfVoDoBaN07xMaUSZ6ys47LUnaMz
         2TIcJGCAwPKMiO9rIItjUsK1ZpnHBgJUAtEw6BwPy0+jZfoURK3a0IU4zI62v0GluA
         EKgjWGo2LeGgyD7+rZdf9rro8lgJ1iaQw+H8TYXTkSWmCKj6xGcx3YBEEap1iWdhLX
         NCqEmAdnc9tkhgOybBQOwuXrMGKY8Lq9KeqfI9ZL9SDG5buwqouQfEBJtzEm2blZMa
         RSXd4sR8Y6IEQ==
Subject: [PATCH 1/5] xfs: compact deferred intent item structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:52:12 -0700
Message-ID: <163466953269.2235671.2810573391142102057.stgit@magnolia>
In-Reply-To: <163466952709.2235671.6966476326124447013.stgit@magnolia>
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rearrange these structs to reduce the amount of unused padding bytes.
This saves eight bytes for each of the three structs changed here, which
means they're now all (rmap/bmap are 64 bytes, refc is 32 bytes) even
powers of two.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.h     |    2 +-
 fs/xfs/libxfs/xfs_refcount.h |    2 +-
 fs/xfs/libxfs/xfs_rmap.h     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 2cd7717cf753..db01fe83bb8a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -257,8 +257,8 @@ enum xfs_bmap_intent_type {
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;
-	struct xfs_inode			*bi_owner;
 	int					bi_whichfork;
+	struct xfs_inode			*bi_owner;
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 02cb3aa405be..894045968bc6 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -32,8 +32,8 @@ enum xfs_refcount_intent_type {
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
 	enum xfs_refcount_intent_type		ri_type;
-	xfs_fsblock_t				ri_startblock;
 	xfs_extlen_t				ri_blockcount;
+	xfs_fsblock_t				ri_startblock;
 };
 
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index fd67904ed446..85dd98ac3f12 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -159,8 +159,8 @@ enum xfs_rmap_intent_type {
 struct xfs_rmap_intent {
 	struct list_head			ri_list;
 	enum xfs_rmap_intent_type		ri_type;
-	uint64_t				ri_owner;
 	int					ri_whichfork;
+	uint64_t				ri_owner;
 	struct xfs_bmbt_irec			ri_bmap;
 };
 

