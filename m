Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27740C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBPVNI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPVNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:13:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FFE301B6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:13:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3185FB82760
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D070AC4339B;
        Thu, 16 Feb 2023 21:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581983;
        bh=gl2sOMnVS5OK8gPaWW8/Ibw8Ok/RIlJS3AMKKr/Saeg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hE4XxksXrqPbQ/gCm2RgfU07UzOpn7ZWU91q7XnZZfuJ/TdLcRlDXTiHA6qJggVU/
         HoMrZAwKE0D45HfenulnClz7OFL+CyO1o1unBGwGONmd1/bnUC32kz2ts3f3j7S2q+
         pVmQXaQ3YNpwqX0xyhKGaTkgu2J4Md0FqA7r3Z1P1s9ECswsYqZmbGCPy1Qk4PrVki
         J0mLy+eUYYAt7nI1C53CInv6GgZVy/NVK0xDh1tUKHaIVu3kqJ5LJPVihnzlrkFh4j
         AxooiElGaKI9W/q6H8mvMUEFTPRxvxURzuTOsQ+4EGpZoyFyxRTiWQKOZrfRsMUjhR
         Mj3nwcHpohPLA==
Date:   Thu, 16 Feb 2023 13:13:03 -0800
Subject: [PATCH 1/3] mkfs: enable large extent counts by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657883073.3478343.1371429481246172738.stgit@magnolia>
In-Reply-To: <167657883060.3478343.13279613574882662321.stgit@magnolia>
References: <167657883060.3478343.13279613574882662321.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Format filesystems with the large extent counter feature turned on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |    7 ++++---
 mkfs/xfs_mkfs.c        |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 211e7b0c..4c379549 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -645,9 +645,10 @@ free space conditions.
 .TP
 .BI nrext64[= value]
 Extend maximum values of inode data and attr fork extent counters from 2^31 -
-1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
-omitted, 1 is assumed. This feature is disabled by default. This feature is
-only available for filesystems formatted with -m crc=1.
+1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively.
+If the value is omitted, 1 is assumed.
+This feature will be enabled when possible.
+This feature is only available for filesystems formatted with -m crc=1.
 .TP
 .RE
 .PP
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d3f34ef8..f355e416 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4092,7 +4092,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,
-			.nrext64 = false,
+			.nrext64 = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.

