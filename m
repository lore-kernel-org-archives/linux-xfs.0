Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E48C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FAA6610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhIOXKL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232774AbhIOXKK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 718AD600D4;
        Wed, 15 Sep 2021 23:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747331;
        bh=XOFO/D0dZwL5QNZ0Ir9JxH3yZUIKuY+tsoeuF24dADI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bvlGy7h/kMvqKfmlHikdm4cVq7uw8aq0ZFCW3aFtB7/Jn7lwr4EOW7SS5SCbs/J9M
         pb226dSHqKgnSmGiocF1kobkv7mFxVDBREBdvTns1xSs8olDhuruNgfAALjO0I34js
         YVkreoqXcztCAZWdjWZMVu5u5fBGLimibL+NLXc3vZT1M8B1q1phbWKLK0qFtmNN0d
         uCLXS6sFGglG8xP8UaJuraIs1SoCl7uFebfsFKd1kT3LG9RuJwC7YdYBzDdVEKRU7y
         wxD8wofEMZsn+VQ9FDpbE6QHj7vfILLI+V4LszPi6wuBNHfMjnGMLncgQjq5MuejPw
         +mUsWo7/diKng==
Subject: [PATCH 25/61] xfs: convert raw ag walks to use for_each_perag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:51 -0700
Message-ID: <163174733121.350433.10722031048038727525.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 934933c3eec9e4a5826d3d7a47aca0742337fded

Convert the raw walks to an iterator, pulling the current AG out of
pag->pag_agno instead of the loop iterator variable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_types.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 8e67c5bb..93dd10fb 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -11,6 +11,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_ag.h"
 
 /* Find the size of the AG, in blocks. */
 inline xfs_agblock_t
@@ -222,12 +223,13 @@ xfs_icount_range(
 	unsigned long long	*max)
 {
 	unsigned long long	nr_inos = 0;
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
 	/* root, rtbitmap, rtsum all live in the first chunk */
 	*min = XFS_INODES_PER_CHUNK;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+	for_each_perag(mp, agno, pag) {
 		xfs_agino_t	first, last;
 
 		xfs_agino_range(mp, agno, &first, &last);

