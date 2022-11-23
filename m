Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30AFC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbiKWRJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbiKWRJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2B527177
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFE39CE2497
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9E8C433C1;
        Wed, 23 Nov 2022 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223352;
        bh=PsFSUpI4Dtk5T88JogAd7uG6ZwUeo4HDquPdeZ/XI+8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=diywI7/VYHkg+Y5puM+a0zrtWVnZExRYrIJaFkLmbTlJ5RRcgkB1w3Dzrc6PjyRzb
         a6hUVEZ9TnyFWracibocCezA1w7+vSSQKTiy8p89P/Zic2TdCMEz7/Y0DWbT4sqguD
         30bUMFu2b2sCKeh1poCkeMiPB597EWVWeSQRz1ici6/GRBvUynIxzQjPX6yYZQdTXp
         oR+Dyjt4ziraPux3PSbinqK6hATZWF7KOQMF2ZPP9R/Ck6yCJPFc4bNQNE8OGBO/GG
         QsQXsYvnUJTU8FpHcmJMS+Po+6pX7LQXC9T12N00ZnjvnILYhJZUb4nW/bmkBAxfeG
         03wNIR189P49g==
Subject: [PATCH 3/9] misc: add missing includes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:11 -0800
Message-ID: <166922335148.1572664.9580374600448542934.stgit@magnolia>
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
References: <166922333463.1572664.2330601679911464739.stgit@magnolia>
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
index a45d99ab5bb..0d9bd355fc3 100644
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
index a41d50c4a7f..6525f63de00 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -28,6 +28,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_health.h"
 
 /*
  * Calculate the worst case log unit reservation for a given superblock

