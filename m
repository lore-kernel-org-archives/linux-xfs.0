Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699A7CE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjIYV7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjIYV7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F12AF
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8245AC433C8;
        Mon, 25 Sep 2023 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679165;
        bh=9lmQWTi1uTSGt0D9GK4iqVhEFc5jhoDQxzoW9o8wxcI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a747cAFko8MlrVtTk3vChoHZfbnpifB5QqsL2375R+ID3oRhZR10IwC1npZ8HATm0
         80CVFdwNwOdUjnPaiNy/+xWRbGJhHbZJJIrWK3FZWwpGvMz/uAb1xUd9dMPJuFCKgp
         VWdHY4PPRLFcGPObszcy+5n0gmfhVzoOyRNWIzIcDz0IyWL3NoI9XPGr6g/XNCUp4W
         gNzSkHKtQcP/GdoVvH835j9Six8BP0fwtAJ/sGl8c9RtV4DDpLipIcTdJOK+J5sTvB
         uRs4fJDrDZ9xVLHcQnxMYZD70aH9KHRRBue19TeKYPxbn48a0WDobB/53NY0uokiSk
         MNSN6EmZRad9A==
Subject: [PATCH 1/3] mkfs: enable large extent counts by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:25 -0700
Message-ID: <169567916506.2320343.9512642932638220161.stgit@frogsfrogsfrogs>
In-Reply-To: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
References: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Format filesystems with the large extent counter feature turned on.
We shall now support 64-bit extent counts for the data fork and 32-bit
extent counts for the attr fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |    7 ++++---
 mkfs/xfs_mkfs.c        |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 08bb92f6522..3a44b92a6a0 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -638,9 +638,10 @@ free space conditions.
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
index d3a15cf44e0..a3dcc811304 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4141,7 +4141,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,
-			.nrext64 = false,
+			.nrext64 = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.

