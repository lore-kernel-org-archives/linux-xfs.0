Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED23C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiL3WmG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiL3WmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:42:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1861573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:42:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8841CB81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420A9C433EF;
        Fri, 30 Dec 2022 22:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440120;
        bh=ZpaKomQyKPZkM1xzkcE5M38OD7YNZPlUrOEbMIDQPhQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iVCYsrQFjzZEmLL2v90Y92EJQRiefrYqb5D14VD/JCqigzwUrOURsfSTJMoMv8sTh
         zl9VSAKk6r63VwW9O20hdLoBhUNgtTVTu6n1YgOg6xQd5YOrlLCePf2Wp5gkOXUa/x
         cedHEY0eh6G98xQCGkHsAWQ+JVn2nc0W6T4lml7FHyOzluxOtb68QkpRcUG0JT+Wwj
         6Y7YfNUtDUbbKCOR509yGBDVncdL98lInPwHXHYfb6ZpHKcjUqmQSUenc9Ycx3mHSM
         y47oOG8TaTYMsupx0TvQTPfIgSh4My5tnsoJ/o/YUekDc2s7QpHxrbHMfsVU8S033w
         aN0wh6syCj3sw==
Subject: [PATCH 1/6] xfs: refactor converting btree irec to btree key
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:25 -0800
Message-ID: <167243828525.684405.3071704178187826488.stgit@magnolia>
In-Reply-To: <167243828503.684405.18151259725784634316.stgit@magnolia>
References: <167243828503.684405.18151259725784634316.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We keep doing these conversions to support btree queries, so refactor
this into a helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 35f574421670..d02634c44bff 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4923,6 +4923,19 @@ xfs_btree_overlapped_query_range(
 	return error;
 }
 
+static inline void
+xfs_btree_key_from_irec(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_key		*key,
+	const union xfs_btree_irec	*irec)
+{
+	union xfs_btree_rec		rec;
+
+	cur->bc_rec = *irec;
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+	cur->bc_ops->init_key_from_rec(key, &rec);
+}
+
 /*
  * Query a btree for all records overlapping a given interval of keys.  The
  * supplied function will be called with each record found; return one of the
@@ -4937,18 +4950,12 @@ xfs_btree_query_range(
 	xfs_btree_query_range_fn	fn,
 	void				*priv)
 {
-	union xfs_btree_rec		rec;
 	union xfs_btree_key		low_key;
 	union xfs_btree_key		high_key;
 
 	/* Find the keys of both ends of the interval. */
-	cur->bc_rec = *high_rec;
-	cur->bc_ops->init_rec_from_cur(cur, &rec);
-	cur->bc_ops->init_key_from_rec(&high_key, &rec);
-
-	cur->bc_rec = *low_rec;
-	cur->bc_ops->init_rec_from_cur(cur, &rec);
-	cur->bc_ops->init_key_from_rec(&low_key, &rec);
+	xfs_btree_key_from_irec(cur, &high_key, high_rec);
+	xfs_btree_key_from_irec(cur, &low_key, low_rec);
 
 	/* Enforce low key < high key. */
 	if (cur->bc_ops->diff_two_keys(cur, &low_key, &high_key) > 0)

