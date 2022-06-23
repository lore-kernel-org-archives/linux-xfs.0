Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB85C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiFWUhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiFWUhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:37:12 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66C360F19
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id a14so483157pgh.11
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+DnQkEplT8yWF8rUNzXw53fIrMrZXJEC5FULg3fZdeo=;
        b=mshNF/Gg49f68apv6SCEGYK4SxwySSRP3yICw05ns6zeaiEwlVd7hc2u9YGoJZaW/Y
         d8CPofi4CGjcnBWj1MIgSV1E+DkJIiM8zJ3NxrExfO+CE1T532NRAvJd4NUqKc3LQDKd
         VoFyiXXAi0R79gmip+xM7YL/O5fr5o3UBn72B9v9KwZhBTEwXpkobebuzuv7kt5hK/QN
         X/2FIPYDnitTHSpZhgjSBkRUXvZzWU5vKfNwqSg/YNqGsih3XDhYJwi6JUHEDqf9Pzft
         lXs6P4tBfLDyt+sbMARNjh+rjBZm8n9uFx3BZ+eelbgJwnzCILRmRnI4L4vFof1dv+mw
         gKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+DnQkEplT8yWF8rUNzXw53fIrMrZXJEC5FULg3fZdeo=;
        b=eRSH3PYvpk1nZ3fUcJ4ijcwdK5n57vlB5QDqxLdqdybIo6gE0KtOf9GcQ7ebLnPbz6
         oWXtja/kW8Vvz6w2GHF6R+uxx+Hzo6K3QebAWLiUnaw38pOjAx5fkmMo+CTOdcu7DlnP
         c2KhT6m580Ix7vMJA9M7B19o0J1QLTRdySwCS2Qq8Th3iWDqb50P0/LKU3kokuRH9WuE
         dam2Zt7CZrO5syv+bt7GnSKeG4GuMhn7WcJavISKRpKGUQUg5uyqQ2Gb0y0YN4A8MzHE
         kvWyhVvlgpdn94IXes/+Pyyw+bEqQG3Bu6arkElIHw12ztiMUhSh4IPXeJ194VJw2oSe
         t4pw==
X-Gm-Message-State: AJIora8wpFxZyDrakl6TCscDK6dsoBNZ9k19Uk1Zv5RQ8vFZd7CY9/SB
        rmd6BSQ3sqQoHi0K45PxDLloVO9f0YRqxw==
X-Google-Smtp-Source: AGRyM1uCG1AtV4TznrR/VJ3EBJJSZ136bC7/d04zLTo1QORg/iCsHq9Z5Lzcwiw95krXWQrLL6wSHg==
X-Received: by 2002:a05:6a00:c89:b0:525:43d2:e925 with SMTP id a9-20020a056a000c8900b0052543d2e925mr11212030pfv.47.1656016631074;
        Thu, 23 Jun 2022 13:37:11 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:a654:18fe:feac:cac1])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b0016a17da4ad4sm228386pll.39.2022.06.23.13.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:37:10 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v3 2/7] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Thu, 23 Jun 2022 13:36:36 -0700
Message-Id: <20220623203641.1710377-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220623203641.1710377-1-leah.rumancik@gmail.com>
References: <20220623203641.1710377-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 5ca5916b6bc93577c360c06cb7cdf71adb9b5faf ]

If writeback I/O to a COW extent fails, the COW fork blocks are
punched out and the data fork blocks left alone. It is possible for
COW fork blocks to overlap non-shared data fork blocks (due to
cowextsz hint prealloc), however, and writeback unconditionally maps
to the COW fork whenever blocks exist at the corresponding offset of
the page undergoing writeback. This means it's quite possible for a
COW fork extent to overlap delalloc data fork blocks, writeback to
convert and map to the COW fork blocks, writeback to fail, and
finally for ioend completion to cancel the COW fork blocks and leave
stale data fork delalloc blocks around in the inode. The blocks are
effectively stale because writeback failure also discards dirty page
state.

If this occurs, it is likely to trigger assert failures, free space
accounting corruption and failures in unrelated file operations. For
example, a subsequent reflink attempt of the affected file to a new
target file will trip over the stale delalloc in the source file and
fail. Several of these issues are occasionally reproduced by
generic/648, but are reproducible on demand with the right sequence
of operations and timely I/O error injection.

To fix this problem, update the ioend failure path to also punch out
underlying data fork delalloc blocks on I/O error. This is analogous
to the writeback submission failure path in xfs_discard_page() where
we might fail to map data fork delalloc blocks and consistent with
the successful COW writeback completion path, which is responsible
for unmapping from the data fork and remapping in COW fork blocks.

Fixes: 787eb485509f ("xfs: fix and streamline error handling in xfs_end_io")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 34fc6148032a..c8c15c3c3147 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -82,6 +82,7 @@ xfs_end_ioend(
 	struct iomap_ioend	*ioend)
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 	unsigned int		nofs_flag;
@@ -97,18 +98,26 @@ xfs_end_ioend(
 	/*
 	 * Just clean up the in-memory structures if the fs has been shut down.
 	 */
-	if (xfs_is_shutdown(ip->i_mount)) {
+	if (xfs_is_shutdown(mp)) {
 		error = -EIO;
 		goto done;
 	}
 
 	/*
-	 * Clean up any COW blocks on an I/O error.
+	 * Clean up all COW blocks and underlying data fork delalloc blocks on
+	 * I/O error. The delalloc punch is required because this ioend was
+	 * mapped to blocks in the COW fork and the associated pages are no
+	 * longer dirty. If we don't remove delalloc blocks here, they become
+	 * stale and can corrupt free space accounting on unmount.
 	 */
 	error = blk_status_to_errno(ioend->io_bio->bi_status);
 	if (unlikely(error)) {
-		if (ioend->io_flags & IOMAP_F_SHARED)
+		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
+			xfs_bmap_punch_delalloc_range(ip,
+						      XFS_B_TO_FSBT(mp, offset),
+						      XFS_B_TO_FSB(mp, size));
+		}
 		goto done;
 	}
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

