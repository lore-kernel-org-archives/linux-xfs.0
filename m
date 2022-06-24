Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDC1C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 06:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiFXGhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 02:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiFXGhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 02:37:12 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8449A60F17;
        Thu, 23 Jun 2022 23:37:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n185so703584wmn.4;
        Thu, 23 Jun 2022 23:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SO7FU+0OUbBLhswG2cCvyF6AplpoM05NubU1LyceI0s=;
        b=UYdq+NO1MfX9KeZlN3pf7cunWQ5bORh/0kTYzCI8gbVTtIOKj0rTQ7zMfOywBjkQli
         xj7kbU1FUKWdkypQmMBpd4iFsBTBdvCQNfPT1evxdXB7Vz/N7qUw7X5x0S6m0WiD0Pdw
         PkTXldy0TIgivcxu6WzykCJl+VP/DZbpkopzKoHiXUS2JvPstabTl2kCGPu3gEa4yoVv
         89hHuRWflpZqKq85DK9VKRwJBjbVjhh7fgNWdcGauYDEPsvApZ9z82jTJ9UcW9thdw74
         XgGV0amOok2rCW16y9Rklzup781Lp/PFkYiI0O/cisl5NdyXpvQ/ADK/tCYO0y+t1BFI
         h5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SO7FU+0OUbBLhswG2cCvyF6AplpoM05NubU1LyceI0s=;
        b=BtADwHuI/xKKI9rNM6/crB+gjuFtIpgsavQ9HTuu1+WpoG58vrUuWVViQjvtupQpjZ
         IZyTqThbeUXpUDFpzZsGwE2G0EJkpZuCtxlZNrPwfopU1Dqt3pMAyHS0W/rl7jbnjvT0
         u9Nwz0clwINP0uJXXtGIZpoImrobDbifIJOg3H2g/hEKlWw3IJMuT8vlZz3aOhh9uESq
         RJXq/xp1NRmQ/IkFbF3Q4hhfoWvaCFy9wb6PBwjq6dii9JhX9ZVaxSoCfZK0ORy4aM/g
         QUw2VCdFNUVnV61FhZ1f5JEyNeKXjErvSe6tJReb0ZrqKkVhfkTaAdXScjAcum3CpRh+
         bFxw==
X-Gm-Message-State: AJIora/e+5lGO9wnWSQh6Pol4/jLBNuloNLQyiouP+6OxRAGuCUV98sj
        uMKjmz7ZXeZF3+YQGOljrTc=
X-Google-Smtp-Source: AGRyM1vULihLp3IRnQw52s1Whds5jfJ+PsCLUgsHRgl+rJs8WZWGajqgVzQrHJLATSiY3sOICAN8ew==
X-Received: by 2002:a05:600c:3505:b0:39c:93d4:5eec with SMTP id h5-20020a05600c350500b0039c93d45eecmr1802191wmq.179.1656052629973;
        Thu, 23 Jun 2022 23:37:09 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d67ce000000b0021b89c07b6asm1540653wrw.108.2022.06.23.23.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:37:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: [5.10 CANDIDATE v2 2/5] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Fri, 24 Jun 2022 09:36:59 +0300
Message-Id: <20220624063702.2380990-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624063702.2380990-1-amir73il@gmail.com>
References: <20220624063702.2380990-1-amir73il@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4304c6416fbb..4b76a32d2f16 100644
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

