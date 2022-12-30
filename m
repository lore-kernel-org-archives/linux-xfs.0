Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CECC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiL3Wsd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbiL3Wsc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:48:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC85318E30
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:48:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C3F5B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50133C433D2;
        Fri, 30 Dec 2022 22:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440509;
        bh=mGwgeu1hj9D453WbT89vVxXyKPx12WmK8r+med5VdL0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aJy541lxfNedi0xldlBz3lyZKKhrEMTvVeTph+dDaRHmprxvdq6iL21Qo7nZpChz2
         Pcc7Q64AVA8mTRD1UiX/JveN/dT7avxRWZY6F6u7iTB+tlfT54EGEDzk/d6Fgpg8mY
         RO/gXCTT7XbgSdA8B4wJ1Cyptg6oI79PqNhFKjge5V98xn2NwUNw5wAieiFCCQ0yrg
         bxVtiN/b0HEOadVW6VdJnb6wwOVcVAbncNZmCjKdtuxcnWDX6pSMBFIynepFKuBk3w
         MfpNvOKkzv/5riD5o7lvtTakIntEpouFY0ikHfUPgqEtRzTxMcZG4IAc+7u4r79ppq
         g/pO8NMI8zafA==
Subject: [PATCH 01/11] xfs: xattr scrub should ensure one namespace bit per
 name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:46 -0800
Message-ID: <167243830623.687022.11979221984710331928.stgit@magnolia>
In-Reply-To: <167243830598.687022.17067931640967897645.stgit@magnolia>
References: <167243830598.687022.17067931640967897645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check that each extended attribute exists in only one namespace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 31529b9bf389..95752e300105 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -128,10 +128,16 @@ xchk_xattr_listent(
 		return;
 	}
 
+	/* Only one namespace bit allowed. */
+	if (hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) {
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
+
 	/* Does this name make sense? */
 	if (!xfs_attr_namecheck(name, namelen)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
-		return;
+		goto fail_xref;
 	}
 
 	/*

