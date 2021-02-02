Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19050C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F7164EDD
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhBBCEw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhBBCEu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:04:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7346F64EE0;
        Tue,  2 Feb 2021 02:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231438;
        bh=mImxWs9OlJYcSAb342becCXS8Wfr74e6q0SILzFwu6Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SdB9a+BWow4TzYwQ8FbzO68gjI6oWRqRDovq/AKhKQNF7cMk6m62ZztlteZDzwmNE
         HcWurBm9lqCyV5lVPbbc+ck+Y0BfDW5LTJ+dqGUEYhCowBPWGeYyDa5Kqh35TJrYVY
         419Xlqh8FGwEMT5rKPRaOvFZgDJ4lgJ2/xhwtaT1ZfqadOxBzNc9w448bN7xxYc0WY
         ckN9ENWI6O8JVoXh/uu3UlMHPqdjE+JixAFBxz2gXfAap2Y1xCWpLzydTQEmJX0XBU
         mcqUreywlmCnlC0thNrmxEiuYCdBP1aj8toGUNOA72336DsZWjnu9h08A05Lpq9edw
         MKPjv/mQUcpiA==
Subject: [PATCH 07/16] xfs: reduce quota reservation when doing a dax
 unwritten extent conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:03:58 -0800
Message-ID: <161223143804.491593.16044871987087423002.stgit@magnolia>
In-Reply-To: <161223139756.491593.10895138838199018804.stgit@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
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
index ea2f71e09b41..b046eadd3b21 100644
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

