Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718D3C46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbiLaDGb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbiLaDGY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:06:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DF9DFA;
        Fri, 30 Dec 2022 19:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB0FDB81EAA;
        Sat, 31 Dec 2022 03:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F8FC433D2;
        Sat, 31 Dec 2022 03:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455981;
        bh=3t+x6wcvdnCnEZRkx5dETm8hgR3phjDiGKquSVrrHA4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SpoR0U5aPJBRpnbPVg3sfwQQuA7UmNEHxwVl4IVqv9kuB45aNT7L8Mo6j0ykJeQS3
         6DdNV8RBgv9rLqyKRn0hW5wC29VdJd6PogDRV/hqJ4St8kHEImRT0mEst0Ls5mGn+0
         FFI2j6MkczT+sP+9n+P1FFjgmT8a40wXrocsRPVcDoyjk4fGIBG2OZAo3xxyoVMPov
         pjO83ONJFo35WbDSPXIedUdA9Jb8wtRrYgw6HOiNgg0V1uze9orgPLCBc+KPRAPbq0
         Xhsg7UFKrBkXPdHl6ft+0hx/NnMPeKFYniE3kTg+s1u90a/HyxqplHdpXkSeB9Hq5c
         lMUFgYUWb3TKg==
Subject: [PATCH 1/9] xfs/122: fix metadirino
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:32 -0800
Message-ID: <167243883260.736753.15941517302628210329.stgit@magnolia>
In-Reply-To: <167243883244.736753.17143383151073497149.stgit@magnolia>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix xfs/122 to work properly with metadirino.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 21549db7fd..eee6c1ee6d 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -35,6 +35,7 @@ offsetof(xfs_sb_t, sb_logsunit) = 196
 offsetof(xfs_sb_t, sb_lsn) = 240
 offsetof(xfs_sb_t, sb_magicnum) = 0
 offsetof(xfs_sb_t, sb_meta_uuid) = 248
+offsetof(xfs_sb_t, sb_metadirino) = 264
 offsetof(xfs_sb_t, sb_pquotino) = 232
 offsetof(xfs_sb_t, sb_qflags) = 176
 offsetof(xfs_sb_t, sb_rblocks) = 16

