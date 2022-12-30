Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB8AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbiLaCmd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiLaCmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:42:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B5D62FD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94997B81E0E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429A3C433D2;
        Sat, 31 Dec 2022 02:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454534;
        bh=95MpwCTJhgAvEb9rD+ZHrLCsyCZwEoFPJ1vVrWmnykM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fOfpo7KsgS7GXeK6h0RWAXZctg32QlDRHlgrXVip8SBeseqjunT5tYtRhMWDyutw5
         Ugwa3m1lrGUvKhOgu6+qQdCNkcdmsG3vZRD3dF3TJelMTvCqZFXLlY8Q0Y8MMVOZi3
         pXHV/YVPv5qSapjFKkFMm6Z2DZih4twoQIfbbk5LOvQ455qigRhq62xJ/hTwop9PTg
         Lx5RbjfJYrJbFXEM/p4IxjW+fdaLPcq+SSftDpn2V41oqNYYXz3U0t7HeOOL9TBfBe
         DpIsRvMeoLh/y1lqoFxorkS/ruovdTY+bgfKD6r8w/f7V1VnFL348du7UPA+aC4Boc
         uNtPMWAmDZMGQ==
Subject: [PATCH 2/3] xfs_logprint: report realtime EFIs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:52 -0800
Message-ID: <167243879258.732626.4222434443076145692.stgit@magnolia>
In-Reply-To: <167243879231.732626.2849871285052288588.stgit@magnolia>
References: <167243879231.732626.2849871285052288588.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Decode the EFI format just enough to report if an EFI targets the
realtime device or not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_redo.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 770485df75d..8fbc19a60e9 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -113,8 +113,14 @@ xlog_print_trans_efi(
 
 	ex = f->efi_extents;
 	for (i=0; i < f->efi_nextents; i++) {
-		printf("(s: 0x%llx, l: %d) ",
-			(unsigned long long)ex->ext_start, ex->ext_len);
+		unsigned int	len;
+		int		rt;
+
+		rt = !!(ex->ext_len & XFS_EFI_EXTLEN_REALTIME_EXT);
+		len = ex->ext_len & ~XFS_EFI_EXTLEN_REALTIME_EXT;
+
+		printf("(s: 0x%llx, l: %u, rt? %d) ",
+			(unsigned long long)ex->ext_start, len, rt);
 		if (i % 4 == 3) printf("\n");
 		ex++;
 	}
@@ -160,8 +166,14 @@ xlog_recover_print_efi(
 	ex = f->efi_extents;
 	printf("	");
 	for (i=0; i< f->efi_nextents; i++) {
-		printf("(s: 0x%llx, l: %d) ",
-			(unsigned long long)ex->ext_start, ex->ext_len);
+		unsigned int	len;
+		int		rt;
+
+		rt = !!(ex->ext_len & XFS_EFI_EXTLEN_REALTIME_EXT);
+		len = ex->ext_len & ~XFS_EFI_EXTLEN_REALTIME_EXT;
+
+		printf("(s: 0x%llx, l: %u, rt? %d) ",
+			(unsigned long long)ex->ext_start, len, rt);
 		if (i % 4 == 3)
 			printf("\n");
 		ex++;

