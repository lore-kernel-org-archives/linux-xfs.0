Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5DDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11ECF61108
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJNUTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUTj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B1C610E6;
        Thu, 14 Oct 2021 20:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242653;
        bh=+G+/C4xNQ5kHtnDWm1LeqiwMTH4WeeQXQIMq1WESILY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hgH7LAFfhqzae8ALi+kVZkcX33wbPDcrr+OCEt2Z6+MFyCJO7rvQeuImD5rq47gQO
         A6bf+7ZcVNIHz4A4grpmM4pZsi5QyGBVCAgKs6PQHqf03HSjPGjG5NryeD5vvmBdqD
         LZ1HOFMknSbSozqtZc/s6vPpjG9n5z/fJniYdvDdsGeYx47Go94docqOQ4ZlXY3Ujs
         AXnnGGvAVtEQMBHC5OnKnLcvl28yAtuN+M0Q7j6QGQIqGJceHNEH2iIRvhsmkm19Iu
         GBDPCnvuV6FOKJgMuwc5sjjLd/DzmyQOpnjhdTW1WCtFAh0wBApzgE1uFh9nSmiyPW
         CuYfOsZGBNFnA==
Subject: [PATCH 07/17] xfs: rearrange xfs_btree_cur fields for better packing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:33 -0700
Message-ID: <163424265349.756780.751665886469662355.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0181fc98bc12..eaffd8223ce6 100644
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

