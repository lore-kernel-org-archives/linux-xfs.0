Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CA9C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiKICFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKICFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C6254B36
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0FCB6187F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45860C43470;
        Wed,  9 Nov 2022 02:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959517;
        bh=Z5fBb2h9k5fUz3EumAnPqr7x9VpXIjHqaoRO9jDnUzE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q4RkithT9wrVWutOoZLadUSbwYaTnxBjimkI9UF7Ez20TWbJa6UIvGD1qWrWK6FN8
         AEPBABlEFfYJKLVpLLNU7sNKOQbAkjQI+uE3Wkl30cEY8blkDTmzXA9KcfJUwBcZfp
         TohmbVLyCJFYCPODMx0QR2Oyd8UufcT76eOx8q0wEyiDSe1HZUYI0004bXO23im3Ye
         iGzBHA9wLw3M6FRZ4sgxvY06/BI87Yq8W7C2DCUZh5qhOFOw7vkHnNxh2w0G4O7e7F
         Wey+w5AoCBpP+Pozp+jZVa071srVHRP7NrApB0dcLjrf3jbkgsWxSEnOJQI9gPDErQ
         pNhGcNk55FVww==
Subject: [PATCH 3/7] misc: add missing includes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:16 -0800
Message-ID: <166795951686.3761353.9298355629581823694.stgit@magnolia>
In-Reply-To: <166795950005.3761353.14062544433865007925.stgit@magnolia>
References: <166795950005.3761353.14062544433865007925.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add missing #include directives so that the compiler can typecheck
functions against their declarations.  IOWs, -Wmissing-declarations
found some things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/linux.c |    1 +
 libxfs/util.c   |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libfrog/linux.c b/libfrog/linux.c
index a45d99ab5b..0d9bd355fc 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -12,6 +12,7 @@
 #include "platform_defs.h"
 #include "xfs.h"
 #include "init.h"
+#include "libfrog/platform.h"
 
 extern char *progname;
 static int max_block_alignment;
diff --git a/libxfs/util.c b/libxfs/util.c
index a41d50c4a7..6525f63de0 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -28,6 +28,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_health.h"
 
 /*
  * Calculate the worst case log unit reservation for a given superblock

