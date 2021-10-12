Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5E7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B838F60ED4
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhJLXfJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234129AbhJLXfJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18FF760E53;
        Tue, 12 Oct 2021 23:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081587;
        bh=4pf79IE/0zNHwYe1S8jrCDlOFIOHSxBep67laOaxw+Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W0DjnPc+4riccz1O0N7LwYQe8EU5B6Qy4Tr8TdPYFCP7cbnTmxbL9q21d6zLDMun+
         zRbn0t5VEEx9hE5lCK8OmtIKf71Yvf+OftqrZvLMSseqIMFEawSEZLmuJbne9es/vb
         6OkhuqhvaNONRdrOzOYoQpw8+Ag2F3FCmzVvcbMH2VBywOOewW85kvMSQVK19RLZ7S
         AiRQQEgctWK7Y/G7B/3dSWGRkbWBRej2ACXsCe6njIlTTHxXA48xTV7NtmDSLAoWGo
         6HZNtpKMNRI6/foYEeG+PBctkKqEo0WdYm0ZgypNrbT+IuMrpaPmkF2WazCmZ6URjx
         6+xrUKokPT5GA==
Subject: [PATCH 06/15] xfs: rearrange xfs_btree_cur fields for better packing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:06 -0700
Message-ID: <163408158681.4151249.744541700094003708.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reduce the size of the btree cursor structure some more by rearranging
fields to eliminate unused space.  While we're at it, fix the ragged
indentation and a spelling error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f31f057bec9d..613f7a303cc6 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -234,11 +234,11 @@ struct xfs_btree_cur
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
-	uint			bc_flags; /* btree features - below */
+	unsigned int		bc_flags; /* btree features - below */
+	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
-	uint8_t		bc_nlevels;	/* number of levels in the tree */
-	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
-	int		bc_statoff;	/* offset of btre stats array */
+	uint8_t			bc_nlevels; /* number of levels in the tree */
+	int			bc_statoff; /* offset of btree stats array */
 
 	/*
 	 * Short btree pointers need an agno to be able to turn the pointers

