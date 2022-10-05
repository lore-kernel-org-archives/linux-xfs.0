Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92049C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 22:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJEWbE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJEWbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD2083F28;
        Wed,  5 Oct 2022 15:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1970C617BF;
        Wed,  5 Oct 2022 22:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7578AC433C1;
        Wed,  5 Oct 2022 22:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009061;
        bh=5xuLgnuncb/cE8rZF9FKplElkdPJprnPdd8Ql+Kx0RU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WQITEWGEjWNLNi4CKJi/LV8qGKRrUqUpOw6REGvMQX0uO4UiiWChMwMZps0nuUV0L
         x7rMsTUMOqwEpGxaoM9i7emKigztVakLDuCmSTd75pps3G4GKLoVicro+2WMIPSymN
         46AZCAaVAug3eDMl1z5+axfEXX9Gry30hoOPpGLwKoXEDQNt5PuoTxi5xwPAMKledX
         rYF+KeMQNJPrd+SC6cOJ4Tgo4VQkZssl36qcEQbAHZwi1L5BM8lXdOvWFvQdJe4O7X
         1awc1sfjCjrXDV0D7Zd7dcQgni3nDfYGKjPMb/shnGBZBWlorpHOF34QJtq61X+zTV
         Y9U6Q/SEBeHiA==
Subject: [PATCH 5/6] common/populate: don't metadump xfs filesystems twice
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:31:01 -0700
Message-ID: <166500906102.886939.861772249521756043.stgit@magnolia>
In-Reply-To: <166500903290.886939.12532028548655386973.stgit@magnolia>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Due to some braino on my part, _scratch_populate_cached will metadump
the filesystem twice -- once with compression disabled, and again with
it enabled, maybe.  Get rid of the first metadump.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    1 -
 1 file changed, 1 deletion(-)


diff --git a/common/populate b/common/populate
index 9739ac99e0..4eee7e8c66 100644
--- a/common/populate
+++ b/common/populate
@@ -890,7 +890,6 @@ _scratch_populate_cached() {
 	"xfs")
 		_scratch_xfs_populate $@
 		_scratch_xfs_populate_check
-		_scratch_xfs_metadump "${POPULATE_METADUMP}"
 
 		local logdev=
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \

