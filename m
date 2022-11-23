Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB55C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbiKWRKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbiKWRJt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BD7E096
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F27BB821BD
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2B3C433C1;
        Wed, 23 Nov 2022 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223385;
        bh=FAu8G0kfzCjH7k1IfZGiULMVlK06TpbvBGV6svNGnes=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZImhUPYpmKZPgn7SrWqj5anF7YFu+2PeXC700aDkZVn2EWA649eSRopibkEjiv/3g
         I0mPkD3mneEV8+lwZwQwX8im97QPY5f+2/93Q8FmIvfRkM09U7fzm17wes+dzEg4C8
         5x4LvWfdOUwZngVds2oiiTz3zXQmpAo9HvV0gD7hvM994IlXhWhdTBkkZlTT+Fi+fg
         Cjx+q6HlK5zs3W7Nh+igQH3ryWTrs0BrntMydMtATiARZNJbwSZEc0fwaccuz0C7zS
         QGlUkpH1B8cyFoAFOQaPxGGKU71ul96lmgqxjQ7tm8tRHExfZPdVmz0xlfd7MXMsph
         hkYa1hX2HGmiQ==
Subject: [PATCH 9/9] mkfs.xfs: add mkfs config file for the 6.1 LTS kernel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:44 -0800
Message-ID: <166922338486.1572664.12822037256588012126.stgit@magnolia>
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

Add a new mkfs config file to reflect the default featureset for the 6.1
LTS release.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/Makefile     |    3 ++-
 mkfs/lts_6.1.conf |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.1.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 55d9362f6b6..6c7ee186fa2 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -14,7 +14,8 @@ CFGFILES = \
 	lts_4.19.conf \
 	lts_5.4.conf \
 	lts_5.10.conf \
-	lts_5.15.conf
+	lts_5.15.conf \
+	lts_6.1.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
new file mode 100644
index 00000000000..08bbe9f3c7e
--- /dev/null
+++ b/mkfs/lts_6.1.conf
@@ -0,0 +1,14 @@
+# V5 features that were the mkfs defaults when the upstream Linux 6.1 LTS
+# kernel was released at the end of 2022.
+
+[metadata]
+nrext64=0
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+reflink=1
+rmapbt=0
+
+[inode]
+sparse=1

