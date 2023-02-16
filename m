Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BA0C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjBPUzy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjBPUzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:55:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1390452CCA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:55:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC48BB82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFB0C433EF;
        Thu, 16 Feb 2023 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580936;
        bh=uj9EeYr/6ka8DVlebjCW61OQGVkKk4LU5t9szUs8l7o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qJscDW998ivbphcQGOwKa0zqIYv5aF3PBeHHb//IaHFR6buett1B6pFVjDDczEzck
         yNPnQhFq1FXkbpPLlX4J0QrZd6LKcQWhKWi9EgvVNsMcUowi7w7oICQ1jHNbxaMuSU
         pH9h9DjGALSUEQDPWNOOHeAQUDTEpmiwhlnkJHodLZ8UUOhBeaylkD/QZo19tMUQ1b
         eZAj/YtTOIUwNFRDxtk/tae9CLykXDeQoqMHCyzSe3x+eKplMGhowuTLp4k+J74KLL
         vyilaqCwp8095roGPVjnCB8BNlRfbxaoTPP/cCJiuTX4G/n+7Ghr5+h1zwaar5pKgG
         GWF2F34USGgAw==
Date:   Thu, 16 Feb 2023 12:55:35 -0800
Subject: [PATCH 08/25] xfsprogs: define parent pointer xattr format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879008.3476112.5817042695666164354.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 059f7b9c5aedf18990aaaee05ff9938b8d87a5ef

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

name={parent inode #, parent inode generation, dirent offset}
value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_da_format.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 3dc03968..b02b67f1 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */

