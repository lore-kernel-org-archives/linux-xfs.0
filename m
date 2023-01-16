Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AF8C678D4
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Jan 2023 23:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbjAPXdm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Jan 2023 18:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235482AbjAPXdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2023 18:33:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565C02ED72;
        Mon, 16 Jan 2023 15:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF32EB81104;
        Mon, 16 Jan 2023 23:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E75C433D2;
        Mon, 16 Jan 2023 23:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673911506;
        bh=ojZWPHS+IIMGuPGnsOHsgYoO/oDNhc0Uw7ZucK6fAJY=;
        h=From:To:Cc:Subject:Date:From;
        b=kDD+2LFrJFCh3ePeNzs/Ts07X6vxXzYMyoJjykhG5iXLBNj68HmB+m7WG96biPCBp
         kLBEWy3QjKnNO42SCANr2y+x79f6wSTo2BRebmeUGelYS5kQuV0vd+jLnObLfBudAl
         IPWdrYrTQzI7JOnFYVI/vBtJT8dzcVQVu1Nnj7MP0IRFxHYqCpfY/Hbqu9nA3QH8ky
         VIWIbPdJlje6MR2YvjEPU5itLKEQj+ZXK9jpD6MPrlKvHlBZuPOvHuzGO9ISqMtver
         vPJ788IVDsfNEyjVN2CYos8IRjKwIWDy24swBdTxaEFJkYrkRcdCckrifqlqPb/NT/
         uHIKJBysLZNzg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fsverity@lists.linux.dev
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update fsverity git repo, list, and patchwork
Date:   Mon, 16 Jan 2023 15:22:57 -0800
Message-Id: <20230116232257.64377-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

We're moving fsverity development to use its own git repo, mailing list,
and patchwork project, instead of reusing the fscrypt ones.  Update the
MAINTAINERS file accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 42fc47c6edfd7..936cbdbc60eb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8520,10 +8520,10 @@ F:	include/linux/fsnotify*.h
 FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PROTECTION
 M:	Eric Biggers <ebiggers@kernel.org>
 M:	Theodore Y. Ts'o <tytso@mit.edu>
-L:	linux-fscrypt@vger.kernel.org
+L:	fsverity@lists.linux.dev
 S:	Supported
-Q:	https://patchwork.kernel.org/project/linux-fscrypt/list/
-T:	git git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git fsverity
+Q:	https://patchwork.kernel.org/project/fsverity/list/
+T:	git https://git.kernel.org/pub/scm/fs/fsverity/linux.git
 F:	Documentation/filesystems/fsverity.rst
 F:	fs/verity/
 F:	include/linux/fsverity.h

base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.0

