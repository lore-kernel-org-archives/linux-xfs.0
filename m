Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33612C433E9
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 040B964E34
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhBACFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhBACF3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4381564E2F;
        Mon,  1 Feb 2021 02:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145068;
        bh=Ng6tAo1MOkD2NgjlSi8P8tX+Da26MPdyu74FgjuU5jU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KAk1W58RufzwHNQ8JgXQ6DdMoOlWn/cpLcThE3wJ0RBeXu6NMVqlnSQXhp5U1mnZS
         +B2OqR3wDdI+N7lLbQeQhJeqcC598BWV3SixYDIwZnqmYttlBRyD8ZDqa98c/Kz/gM
         fqpBrf/0L3yyICv+7xAHqQtxrKOsMce1kfHLMCxhzAkG/NRTMQmrzyqh+zdrenwRJL
         pTChJh7baWDeTvdLIlxaM20H+ckzE2oodGpGLFoTcOKO5VCufe+R/eSn2sizpuWf0a
         jbnopoyAoUYuvJuY8ifLUrYYrvS4BokTjTaerGwLe3eOaoegD1jkmAGM3DlIt3XLXn
         zaOsEVN8H45YQ==
Subject: [PATCH 07/17] xfs: reduce quota reservation when doing a dax
 unwritten extent conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:04:27 -0800
Message-ID: <161214506850.139387.4865345219813591818.stgit@magnolia>
In-Reply-To: <161214502818.139387.7678025647736002500.stgit@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 3b0fe47805802, we reduced the free space requirement to
perform a pre-write unwritten extent conversion on an S_DAX file.  Since
we're not actually allocating any space, the logic goes, we only need
enough reservation to handle shape changes in the bmbt.

The same logic should have been applied to quota -- we're not allocating
any space, so we only need to reserve enough quota to handle the bmbt
shape changes.

Fixes: 3b0fe4780580 ("xfs: Don't use reserved blocks for data blocks with DAX")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index de0e371ba4dd..6dfb8d19b540 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -236,7 +236,7 @@ xfs_iomap_write_direct(
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
 		if (imap->br_state == XFS_EXT_UNWRITTEN) {
 			tflags |= XFS_TRANS_RESERVE;
-			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
+			resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,

