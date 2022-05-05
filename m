Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E76DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381183AbiEEQIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiEEQId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B8D5C373
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC62761DAB
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB9C385A8;
        Thu,  5 May 2022 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766689;
        bh=SrqXRAK2iPcFYU8/UuLTZAOMCfxMncm2y+LwvjsifoM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CsZPLPyPmX0ee0S1nz7ne5cGk4ET3u0m58jCZITAsTwp6/LhO2CHx/bbYKi38Os8n
         9H1cdZe7jnMi2LqxdRZl1eFvnceySb0vsXsEFa5y8J+CzwuSxKacakJFsJCssgukuh
         F9vxCzVsF0Tu9Vs2dGxIvQxxe2BSBk33T5bijnXGNCrI9e+L2fvi4WzYC2Mkn/PKcF
         3ntwvPJaTFGPeDPAgChVHAGUwjvQIEORDhhEtG11gHizydCgYjZ6zC2CG1sa82dEJx
         nenLS5XFws/6ZfFxfgMiph5fBmqdMki9q1b12IbfbywjP2RwddClKrr8d6fJm0F10i
         G5npckXwI4Q7w==
Subject: [PATCH 1/4] xfs_repair: fix sizing of the incore rt space usage map
 calculation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:48 -0700
Message-ID: <165176668866.247207.345273533440446216.stgit@magnolia>
In-Reply-To: <165176668306.247207.13169734586973190904.stgit@magnolia>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If someone creates a realtime volume exactly *one* extent in length, the
sizing calculation for the incore rt space usage bitmap will be zero
because the integer division here rounds down.  Use howmany() to round
up.  Note that there can't be that many single-extent rt volumes since
repair will corrupt them into zero-extent rt volumes, and we haven't
gotten any reports.

Found by running xfs/530 after fixing xfs_repair to check the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/incore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/incore.c b/repair/incore.c
index 4ffe18ab..10a8c2a8 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -209,7 +209,7 @@ init_rt_bmap(
 	if (mp->m_sb.sb_rextents == 0)
 		return;
 
-	rt_bmap_size = roundup(mp->m_sb.sb_rextents / (NBBY / XR_BB),
+	rt_bmap_size = roundup(howmany(mp->m_sb.sb_rextents, (NBBY / XR_BB)),
 			       sizeof(uint64_t));
 
 	rt_bmap = memalign(sizeof(uint64_t), rt_bmap_size);

