Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E14AC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348453AbiFCS5w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348455AbiFCS5v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:57:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463B329824
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:57:50 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c196so7824052pfb.1
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMVrwoUBIzYykRNvCM8LvaV83/Lj/orop8MXMLHpjaw=;
        b=NRl5gnT5aruvsDhVGP8CosYjTRMSUHn35HQzJFQ+zHFkD6M7QcoH5GPPN4AGUo+9VQ
         lReX788zV8vzRJEtRtWplYUWFSkSxs9ISmZ/fIFcb95zP5e//fR5mIaQDCSo+mfoSJaL
         pmYSRTCb2SEfcpRHJJh8y9MQHUsRIwKHDjY8/xSi8+iktGa9mh+lHFqEM2a6fTALwGz6
         6SsWtFBYMMAH4Zua6ZnVN2qLQF5RBMPp8GMXG3BMFl0Hg4tFqZ8hYpEM7mJBdih65wM2
         nFJ+OySIo084K86vHfUUvmaTNpS/erPYGh/bgs/5p/7Ues2Cb6BlVxttF9+fWKCTcPdc
         nmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMVrwoUBIzYykRNvCM8LvaV83/Lj/orop8MXMLHpjaw=;
        b=bSHTPU0lS8SySx6fizlnk3fxxCeKVNapkaQNbkxwuXJOmlwsXeWFfU6Awuf0xnCwbl
         OnRN/1F2UjgX1vJSptOdAok4PbwEUbR8JZWYtYs02ksD/gWw76bI2xGnjyTQ/Oqseeg4
         wJehLju5SXVKGxqEDZ2J0QZJ1EpGdAqlrhU1IeGHBv6P7eyL5OBBsLV9x9bxc0ZLAZC6
         T3uQLZkLw4APXbD6N0gXNjeUWTlgl8wtcqim3yTKGjArY8jqS3odhnloDdsKqpxzjut/
         y5LOCxPQ9a/AbuY8dMxQ7CO3KDgT7a1G3yH7ACmQSWuJbIj+lerrrZp39Ef7/B5HBG+K
         4b8g==
X-Gm-Message-State: AOAM533I192917ZCGhHeliN+XoVOrcUh365K5JeTyeNZE+qNyhzQIQh4
        ED+31gGQXKyCtFA5PX5ofDyNufjIreDKew==
X-Google-Smtp-Source: ABdhPJxGsTGJ5Yvs3MWiS5ke1OpJatYX/j3WodHC5nn4XlkE27iNWU2XJZ17O0kjBt//0v7ndz3N1w==
X-Received: by 2002:a63:2a89:0:b0:3fa:cc62:e00f with SMTP id q131-20020a632a89000000b003facc62e00fmr10036528pgq.364.1654282669617;
        Fri, 03 Jun 2022 11:57:49 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:57:49 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 02/15] xfs: punch out data fork delalloc blocks on COW writeback failure
Date:   Fri,  3 Jun 2022 11:57:08 -0700
Message-Id: <20220603185721.3121645-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
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
2.36.1.255.ge46751e96f-goog

