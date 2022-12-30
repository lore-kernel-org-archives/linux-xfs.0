Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBC9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbiLaDHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiLaDHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:07:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7D21054D;
        Fri, 30 Dec 2022 19:07:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85D3361D33;
        Sat, 31 Dec 2022 03:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AB4C433D2;
        Sat, 31 Dec 2022 03:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456044;
        bh=Yuh6pKSVZBj0Aj5aA2CmOLwOL+2xwUaEJywYeik6uLU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PRrkUWs1aEDumXYWxi0aZdptThHthpNEfUAixbt3uAGUX/42YOtHoH5oPC+UZOhjl
         KdM3fy/zeFWYhBl97rdWG/j+CjpDzRrzyglvSlc/6U1B59KeCvbaihgctcYaObnONH
         4s+NfHEvDrg/hgO9xCT4DzksXuBde15jvViwMjo9tE8/IVO2feH5EgZr/QzLMgkziR
         iGEpK9LVEdsa7MeHVYfc60m1UUnmo2kRb5p/PVrj2tl8XM4dGE4hNBetC/bdrCTNMw
         zYdnkfNfcqThyhullk183ZUKXxHjBhUcawT6K+9Ax/X8N7fPdl3wgJvrKu1A1aEQXF
         5boE5/80xfMEA==
Subject: [PATCH 5/9] xfs/206: update for metadata directory support
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:33 -0800
Message-ID: <167243883306.736753.14765365095410052316.stgit@magnolia>
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

Filter 'metadir=' out of the golden output so that metadata directories
don't cause this test to regress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/206 b/tests/xfs/206
index cb346b6dc9..c181d7dd3e 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -64,7 +64,8 @@ mkfs_filter()
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
-	    -e "/^Default configuration/d"
+	    -e "/^Default configuration/d" \
+	    -e "/metadir=.*/d"
 }
 
 # mkfs slightly smaller than that, small log for speed.

