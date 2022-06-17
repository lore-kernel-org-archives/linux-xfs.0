Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C020C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381709AbiFQKHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381596AbiFQKHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:18 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9D76A418;
        Fri, 17 Jun 2022 03:06:51 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c21so5130440wrb.1;
        Fri, 17 Jun 2022 03:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XIj+XIGeyKI5FSWHzvU/4VEeWwx2VX+90KKkI9DaRug=;
        b=N5KFvKm5imKJ9UeSYvVSn3JV1xNsIncONcQSXbfCX2umx4x1RAowPzMgYaSC/tSPJV
         RuR277iVrBxWdrhieIhWAd+vSGUoX+ubWLn9LmARgETWjpe3NHep1bnbQ8FWXnei1xc/
         zQkYrA3/Usp3oMimmGSZpbfZCIguTajxIasfmwfZ4M0O6FlUXvPaF4E4ibAixystE+E+
         hSt1jKJDlGoRnQdqoTOkPS1C7N/rq38Ayj0b2/GCMaormoFQGaca/s9E8Bj2hY/igHLo
         3FcivylLDlMbBg3aMEbFAkJ62HNocZbBIy81e6rWZaD7Hmkgst60hyQ6ZM3JAHAT/pIV
         kJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XIj+XIGeyKI5FSWHzvU/4VEeWwx2VX+90KKkI9DaRug=;
        b=a8+sAIgzZHv/jkMok82qRMHoGKjJRcCEBNfwjYtIWB0K/GDH7xasnVBEyEqDu/9K+D
         xhzCJzd9vTSgm8dw5A8JLCCUR8AokWaEUiKTDCGFOBCuEd5DNTO8iYfjVjt6wQuM+sW9
         jpV3ZH6IaZx4iwxu4Tol4oeg+kAtB73CFHSVPfeFk3Hie0o01g1lyOFOCzdDIIbtRpMe
         zr9C95PVtWZq5j2YzT/aWFedRZUfsg4emArQZiFf06UKWIJreGKDhmFpDKWQKMs1sJ1i
         xApk4detdCnq3bNfXpBhOXJ48k/YZKTKADsDwHG+BBNA8oMXrbrkou4Rc14ezTVaO962
         7APQ==
X-Gm-Message-State: AJIora+BdsfCRF3xnvjxhq1q3eQvNwGsHns57vDtBQUN/eVPdI6Dczwh
        jWPblkYGpTfSIP91DmsLbyU=
X-Google-Smtp-Source: AGRyM1s/6TsX5UTwruLCfYYy6dUoMxQyGlyfGGWDdaxtkgvTqyqeN75pp8Hy+SFw1evyVe/iDxHJHA==
X-Received: by 2002:a5d:5581:0:b0:20f:fc51:7754 with SMTP id i1-20020a5d5581000000b0020ffc517754mr8427465wrv.413.1655460409678;
        Fri, 17 Jun 2022 03:06:49 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:49 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 02/11] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Fri, 17 Jun 2022 13:06:32 +0300
Message-Id: <20220617100641.1653164-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 5ca5916b6bc93577c360c06cb7cdf71adb9b5faf upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_aops.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b4186d666157..953de843d9c3 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -145,6 +145,7 @@ xfs_end_ioend(
 	struct iomap_ioend	*ioend)
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 	unsigned int		nofs_flag;
@@ -160,18 +161,26 @@ xfs_end_ioend(
 	/*
 	 * Just clean up the in-memory strutures if the fs has been shut down.
 	 */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (XFS_FORCED_SHUTDOWN(mp)) {
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
2.25.1

