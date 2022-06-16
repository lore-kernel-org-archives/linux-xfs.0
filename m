Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5094C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 18:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiFPS2i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377330AbiFPS20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 14:28:26 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838433C4BD
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:24 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y196so2190897pfb.6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LGv/mFW2AS6eWmd5Niio/kjTP7cNOgpUwkqEf6qV+0I=;
        b=JUpTIBf8ePGEobbLGA0DjRDvVsORLk7GwkXpK4QGogu9nBfHzBHWAo5+WGeLefucHS
         RVr80XMiAKISEB8a4fLAWjVu59SpLxJVMhObYuRiWuSS01eAqAEZfjhgDfLzkRbKJCdj
         wV2L1rFGjg+DgK5g8cFMm1T75+gPRR0PvZ6mlftckcix9kDfH3HGJ6yldMCFi9o7uX8l
         58TkbYSM4cuNWM2jkiFRwjdDULkp7cw7pBBQUyi0qn5QDiqP3GeH+HcjAe0tWNULK4bt
         fY5I8uLhIXYEtN+w9tSHPqfq7DZlj/52K3GJCSfhT3zVxQiBZV5wcRwC7JBGuveDPOL7
         5lTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LGv/mFW2AS6eWmd5Niio/kjTP7cNOgpUwkqEf6qV+0I=;
        b=2i/pVPNDiTsQ4SwtDhjyWmImdqU4XjW6h7gdNRcKnGlyB0KcIbSVTVBRGH5NaD2jiy
         AyE0Ii/t6hWb+/SkzjVZYH5486hoWh3bv63Stvk08krS6NUwacTm3DgbAEaVlVCMst7q
         BtIWqaAcRyLrSrS6GEbxLgJ0ePHsx5y0xRkh1H7PSHv2qGnfWIfrLaLYBFSYcy8CPuYt
         G0TLTWyvaOuTc4nwPZNyIygD07mpbqe3KapmAF0GMhZuD4LMoj96BhXN6yCY0Bj7Z4zv
         Tt/KiY8r2mV+/uaM6pN+R97esZk3WIcL48WUExiiOT4aiNwr4y9s4LbwEWxDhj1EEeo7
         TktQ==
X-Gm-Message-State: AJIora+uDBhpMBb3CjcOmZtLxcyZG9LtDI8zsicsyvqTiaNk/CC4tBeI
        u5IuQvQjwEoysoSemxBhMbrTLEO9V96QhA==
X-Google-Smtp-Source: AGRyM1vPtcDa05MBzUizzK0QZD4hsPdh5K23rRvCDdDSbtq792iU1lzR+QZmqNwRBE2guoS5DMOlYQ==
X-Received: by 2002:a63:4b20:0:b0:401:ae11:2593 with SMTP id y32-20020a634b20000000b00401ae112593mr5509218pga.375.1655404103777;
        Thu, 16 Jun 2022 11:28:23 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:fd57:7edc:385a:c1be])
        by smtp.gmail.com with ESMTPSA id fs20-20020a17090af29400b001ea75a02805sm4131511pjb.52.2022.06.16.11.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:28:23 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     mcgrof@kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v2 2/8] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Thu, 16 Jun 2022 11:27:43 -0700
Message-Id: <20220616182749.1200971-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
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
2.36.1.476.g0c4daa206d-goog

