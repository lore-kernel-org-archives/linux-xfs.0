Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBC5C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7381764E08
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhA2CRw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhA2CRv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A8864E05;
        Fri, 29 Jan 2021 02:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886624;
        bh=I4Rc6oh/YKxVK5LgT4CLsfv3rvejDXusZwe9mVP0r0w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SGQLUILcg5uwsKWBm0TfxpgTiKiuIohKmjjC//94hXCM9oUlY/fhL91VW2EeDLr9+
         M5qw3eFq26MSNcwS3eelWzxoOqnYQ/JqBiBL2KaJajrcc5mUhtNyT2qdvRLXJjjzAA
         IH7v+GGaFbUFosQ/4uoXXfh6l6KKGBaVuvJSfrQHyAV2VYSTp85GwCctdBByf9InIq
         x1UVxvP7bE7SSZ52J/jVwtWI07WrQfMHbyutP8/FbdOicWhpz5t6e3P2nJR2kESyYu
         Gg5sPZUCnHv0L2Ixdpk2PyQDa9EaPcqWilxzXSGD6BVzGnbXkRTStDxiT8lOqD7GLN
         OeGf7ogKVlGmg==
Subject: [PATCH 06/13] xfs: reduce quota reservation when doing a dax
 unwritten extent conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:17:03 -0800
Message-ID: <161188662355.1943645.4498589995636729261.stgit@magnolia>
In-Reply-To: <161188658869.1943645.4527151504893870676.stgit@magnolia>
References: <161188658869.1943645.4527151504893870676.stgit@magnolia>
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

