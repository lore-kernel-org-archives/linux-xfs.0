Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778D1C30654
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 17:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjGCRDr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjGCRDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 13:03:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE96E58;
        Mon,  3 Jul 2023 10:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7924060FEF;
        Mon,  3 Jul 2023 17:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD46EC433C8;
        Mon,  3 Jul 2023 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688403824;
        bh=TMwy5ndrR4N1nNLEBC3BsHDB+L1wCBVqQsL9dDeCCPg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u6yZNFEjjrCdT2SAo6e4SOex0u1KCnh7L/GVKNJe+kYvkiedxXkzKTY0rFHLIaEhE
         E6ZdSzsDs91HQi21Kw0PW8cx19z5UyNLWV1526II4FqpMkuKZ2f7cGs0LYDWG9H/xH
         vjC2aYkWjsu5obYFqWZ279Vh8Eko28HQXikfPtuogO3xeUAwGA5HZLB8uM9refOOoS
         nZkPfYptc9lCTwrjPjUOGXlFjQ31+XYY4tAobNXI7+BDTUtHj7cpO9GLRp9+zq2oM/
         Ciy+Jd7j50smOEI5Zxge0OE0IZz0fRISp1gncfBO5W8RYaJa+zCyMC8qLo38EjlJN7
         Ir7bXxw6Bqrtg==
Subject: [PATCH 2/5] xfs/569: skip post-test fsck run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 03 Jul 2023 10:03:44 -0700
Message-ID: <168840382437.1317961.10711798856849951797.stgit@frogsfrogsfrogs>
In-Reply-To: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test examines the behavior of mkfs.xfs with specific filesystem
configuration files by formatting the scratch device directly with those
exact parameters.  IOWs, it doesn't include external log devices or
realtime devices.  If external devices are set up, the post-test fsck
run fails because the filesystem doesnt' use the (allegedly) configured
external devices.  Fix that by adding _require_scratch_nocheck.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/569 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/569 b/tests/xfs/569
index e8902708bc..b6d5798058 100755
--- a/tests/xfs/569
+++ b/tests/xfs/569
@@ -14,7 +14,7 @@ _begin_fstest mkfs
 
 # Modify as appropriate.
 _supported_fs xfs
-_require_scratch
+_require_scratch_nocheck
 
 ls /usr/share/xfsprogs/mkfs/*.conf &>/dev/null || \
 	_notrun "No mkfs.xfs config files installed"

