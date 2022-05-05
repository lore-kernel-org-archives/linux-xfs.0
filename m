Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC01C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381600AbiEEQHw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381611AbiEEQHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A09D56F95
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E871861D53
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC5AC385A8;
        Thu,  5 May 2022 16:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766651;
        bh=XdRbOmXFxKZHfXDP6t1h8IheC2geUCC84spVESbfMs8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b9nkAyCGIviTwUjrCF+gzKMXYGPaFTZMKoCNH2I3ZZdpzwGSdmPRlZXaQ052kkZVH
         AEtAoTifdcU052C32AglaFXCym59Va5bQbf+8/P8lEJimCa24QSQzQ/1TKRVuFn86B
         MR7LtsFJjhHU0gA+nbZbco9lXwKR6wRkmYmSb/ht8rTkcDlvAZoSY55Cn93lt8cvu3
         mnXRCF/PHD+tqWreq30gsgggOCIxKSrR6bCqttvN1gWF5zeURytUVc62NrG+OTVaIL
         dfn3AyTws7fUUKAL5BBYOSS/qwUz1Z/2duAQ5/CdJDSjWiKfEJUkcUKSHfV6vxRPWD
         N/RISjikfXrWQ==
Subject: [PATCH 2/2] xfs_db: fix a complaint about a printf buffer overrun
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:10 -0700
Message-ID: <165176665092.246897.6105158987030874479.stgit@magnolia>
In-Reply-To: <165176663972.246897.5479033385952013770.stgit@magnolia>
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

gcc 11 warns that stack_f doesn't allocate a sufficiently large buffer
to hold the printf output.  I don't think the io cursor stack is really
going to grow to 4 billion levels deep, but let's fix this anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/io.c b/db/io.c
index 98f4e605..bfc86cc4 100644
--- a/db/io.c
+++ b/db/io.c
@@ -638,7 +638,7 @@ stack_f(
 	char	**argv)
 {
 	int	i;
-	char	tagbuf[8];
+	char	tagbuf[14];
 
 	for (i = iocur_sp; i > 0; i--) {
 		snprintf(tagbuf, sizeof(tagbuf), "%d: ", i);

