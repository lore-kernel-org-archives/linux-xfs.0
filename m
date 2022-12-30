Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024E7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiLaCmf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaCme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:42:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460402DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:42:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9510BCE1A76
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BC5C433EF;
        Sat, 31 Dec 2022 02:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454549;
        bh=AgKYC7IJLDW/A7Ez9N1sqmy3x/mg5S7yhqZaZhX2dyc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EN1rEvsi/Mesi9Y/DrobWEHynwX5k+2px8j9Sx/vznch5tL8MYkJSnLIoUBbYqDI1
         44rnZh/jLs5X/5hAQZbc0pLArlgjm/iG0t91yeOeueo8QzDjHmhJgrnT/745I4c+HG
         WIfIICZfqT057bdPJVfy1Gw1IxJV1pUZ49TzmmfncrlPx91341hIwWStQAokbj8qvp
         SeLr99VkaSZqHz/6e0smbK4hVDf3LkBP6O43UNpnvR1L2rUjp075KVJm8rbaYORR3I
         Mg6kDe4E1Crb/IoYU2ELAaAkNef+zOk/qnBkTS40Q1OXRIpC7Fd6aBa1UliYysiayE
         qkT7wDHf/Jqlg==
Subject: [PATCH 3/3] xfs: support error injection when freeing rt extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:52 -0800
Message-ID: <167243879271.732626.167002049028322051.stgit@magnolia>
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

A handful of fstests expect to be able to test what happens when extent
free intents fail to actually free the extent.  Now that we're
supporting EFIs for realtime extents, add to xfs_rtfree_extent the same
injection point that exists in the regular extent freeing code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 26428898d60..b0934b1f24a 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_health.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_errortag.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1135,6 +1136,9 @@ xfs_rtfree_extent(
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_rtcheck_alloc_range(mp, tp, start, len);
 	if (error)
 		return error;

