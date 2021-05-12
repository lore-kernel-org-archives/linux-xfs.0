Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F84C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 643B16127A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELCD3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 22:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhELCD3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 22:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD91F610EA;
        Wed, 12 May 2021 02:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784942;
        bh=1e3afn9sSKWBbmLz1TL3wtUwNUoeI9Lu2TmAcGoddhI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e9oxzNm0AzL91rmW+JKPD8+8wG+dn+5hjNl5MV+7kNm/Jd3Sn9gDWY+BYsjTJKEwu
         kCpFTCfzRrxu5OHr1hoQN7v3AfBSIn1aTe5OWUXnXiOXD2MMlbjAY2tdFRss7l1E8i
         sBklf54tn0OSiCJwq9+9R3UoZ3o01DxuRc/AYmS95VqCId5cD6/+l5CUjr30aFReQN
         ZbW9GH46RXnvl6+bdUbqcsbp0nHPbaIKBL7wjEqfKNsUbv7OG1Lwsp8VRBdnmVh13E
         bkSIumM6htXZJ3QDk7BLlvP1PkN7s8wXU+DrjfcBPrRslNq7Hl38NJra7PS3TWfY0y
         d0vf50o8vUB6Q==
Subject: [PATCH 7/8] fsx: fix backwards parameters in complaint about overly
 long copy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 May 2021 19:02:19 -0700
Message-ID: <162078493928.3302755.17832088383743982289.stgit@magnolia>
In-Reply-To: <162078489963.3302755.9219127595550889655.stgit@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If fsx encounters a situation where copy_file_range reports that it
copied more than it was asked to, we report this as a failure.
Unfortunately, the parameters to the print function are backwards,
leading to this bogus complaint about a short copy:

do_copy_range: asked 28672, copied 24576??

When we really asked to copy 24k but 28k was copied instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 16e75c40..12c2cc33 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1662,7 +1662,7 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
 			prt("copy range: 0x%x to 0x%x at 0x%x\n", offset,
 					offset + length, dest);
 			prt("do_copy_range: asked %u, copied %u??\n",
-					nr, olen);
+					olen, nr);
 			report_failure(161);
 		} else if (nr > 0)
 			olen -= nr;

