Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235F6C7619A
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 00:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDMAKr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 20:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDMAKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 20:10:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E1DB3;
        Wed, 12 Apr 2023 17:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0DBE612D2;
        Thu, 13 Apr 2023 00:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098C4C4339B;
        Thu, 13 Apr 2023 00:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681344645;
        bh=6anALwak1MzDTPnNmndKAl7aqs/gjZBDdaXAnZ3Dyq0=;
        h=Date:From:To:Cc:Subject:From;
        b=b1st2K5R85KAeiNejofXdUZScKeU/yb3zLl6TOysi1zJUBR2WE4dZJQ4+Qgat/O6h
         CuUPHpQbs/YlTpFYLDgqfeYzyCOMMm6FJszCHKdVYdHHnsdgHnNOOzobbL5KAwW/tG
         NEGGNSOJCSAqjS5gQWYD0FWkulsrrCLUMXxGFHEDxYbWwsF+Y6CUbpcu3RTGLq0Ezb
         xxb2dDM7/ip6uIocqyXFtomLSC3V57oXKahKIHZvzToWcxdfNtJ3XJ1iYne9mX2jVc
         KladN5iFSVUBiOw9pHidfKEnKAp+bMfFtL9TQLwhM4RjvECZVi2B8eY1KrxyMemkh0
         ZwVTdWxqamxaA==
Date:   Wed, 12 Apr 2023 17:10:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH] xfs/517: add missing freeze command
Message-ID: <20230413001043.GA360885@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test is supposed to race fsstress, fsmap, and freezing for a while,
but when we converted it to use _scratch_xfs_stress_scrub, the freeze
loop fell off by accident.  Add it back.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/517 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/517 b/tests/xfs/517
index 4481ba41da..68438e544e 100755
--- a/tests/xfs/517
+++ b/tests/xfs/517
@@ -32,7 +32,7 @@ _require_xfs_stress_scrub
 
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
-_scratch_xfs_stress_scrub -i 'fsmap -v'
+_scratch_xfs_stress_scrub -f -i 'fsmap -v'
 
 # success, all done
 echo "Silence is golden"
