Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15471C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbjEZCW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbjEZCW3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:22:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8948E1B1
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2054464C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8499CC4339B;
        Fri, 26 May 2023 02:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067742;
        bh=OgVYIxfhTNFCRckhNEZRqTOM5uV/LWcESWbN67AKyd0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dJDdsRIy0KSrm8VSjfd5JkStie0j9E3+k9P+NTXu5Ag0FDfYHrB2FpKEXN4+godM2
         /Lbkvqv39vFAhm4IbTnlwRC6MdC2AdflxD+/ozofAmQesS+CjGSeXwBDqe+TQec6ES
         AqPO+cqhwJRyl0AzUJHErFvFXf1x3gTOxquqJEiuQ4yyMSAVCBTTCgCsRM6UroHlwt
         a6QnFyqyMc+u6rpbsL1DQ7bUowwG7xvtJtYV250xGq2hKfh6OZQd8nhmBE3g+VRJGI
         fEI03WeTBmByTJG1rN2tAjps+8yFPVlnh87GUbaPP1PasNTv4KiK07SsTO3yYGSJc0
         7JiVD4cchpt0Q==
Date:   Thu, 25 May 2023 19:22:22 -0700
Subject: [PATCH 02/30] xfs: define parent pointer ondisk extended attribute
 format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077915.3749421.4452983979387529506.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent namehash}
        value={dirent name}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.
Storing the dirent name hash in the key reduces hash collisions if a
file is hardlinked multiple times in the same directory.

By using the NVLOOKUP mode in the extended attribute code to match
parent pointers using both the xattr name and value, we can identify the
exact parent pointer EA we need to modify/remove in rename/unlink
operations without searching the entire EA space.

By storing the dirent name, we have enough information to be able to
validate and reconstruct damaged directory trees.  Earlier iterations of
this patchset encoded the directory offset in the parent pointer key,
but this format required repair to keep that in sync across directory
rebuilds, which is unnecessary complexity.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: replace diroffset with the namehash in the pptr key]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_da_format.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index dd1c70385cf..62d75e0f368 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -821,4 +821,25 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * The xattr name encodes the parent inode number, generation and the crc32c
+ * hash of the dirent name.
+ *
+ * The xattr value contains the dirent name.
+ */
+struct xfs_parent_name_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+	__be32	p_namehash;
+};
+
+/*
+ * Maximum size of the dirent name that can be stored in a parent pointer.
+ * This matches the maximum dirent name length.
+ */
+#define XFS_PARENT_DIRENT_NAME_MAX_SIZE \
+	(MAXNAMELEN - 1)
+
 #endif /* __XFS_DA_FORMAT_H__ */

