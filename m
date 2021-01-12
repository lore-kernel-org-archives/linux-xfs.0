Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645C3C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 19:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C34B23109
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 19:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406743AbhALTLU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 14:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406050AbhALTLT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jan 2021 14:11:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 434C923107;
        Tue, 12 Jan 2021 19:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610478639;
        bh=s0XI6BAJMx2DjAAxOccZB3WiQrh3FRss4X/fyLFfd0U=;
        h=From:To:Cc:Subject:Date:From;
        b=pUTyrKNf9TtCtxbPJ9j0yDLCdUSPuop8j3zJvg/gqKwPiNNZ8HEdnnfAtFs5LKNfD
         uB7YRY6nIfZtChQ01Y0cJZT1zm9HBVp36J8motzrWtnKcLmvr9x2dvVYFl5rwmy8EY
         3vbWVEteD5spS8UlphUu0Ia4niS0/4uFXU11JUjh+H1ic128/5fvHeV8hx5ZbblVcG
         1BNtfIMN5t0vhvlxe+AFVlb25ftiEtsyihktUdO3PxlzC/I/B2SfULlT7gxaBVfmOr
         Mb+mDq3urJzqNL+k/iCC+D8he5wmxQlFhBLaz++Zb+kDG0sgUQi482wNMh34jQmYzu
         8yW5AxtmQjnQw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3] xfs: remove a stale comment from xfs_file_aio_write_checks()
Date:   Tue, 12 Jan 2021 11:10:24 -0800
Message-Id: <20210112191024.65206-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The comment in xfs_file_aio_write_checks() about calling file_modified()
after dropping the ilock doesn't make sense, because the code that
unconditionally acquires and drops the ilock was removed by
commit 467f78992a07 ("xfs: reduce ilock hold times in
xfs_file_aio_write_checks").

Remove this outdated comment.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v3: resent as standalone patch and added a Reviewed-by.

 fs/xfs/xfs_file.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f738372..4927c6653f15d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -389,12 +389,6 @@ xfs_file_aio_write_checks(
 	} else
 		spin_unlock(&ip->i_flags_lock);
 
-	/*
-	 * Updating the timestamps will grab the ilock again from
-	 * xfs_fs_dirty_inode, so we have to call it after dropping the
-	 * lock above.  Eventually we should look into a way to avoid
-	 * the pointless lock roundtrip.
-	 */
 	return file_modified(file);
 }
 

base-commit: e71ba9452f0b5b2e8dc8aa5445198cd9214a6a62
-- 
2.30.0

