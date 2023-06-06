Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D0BC7EE2F
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbjFFW3Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239860AbjFFW3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D2D171B;
        Tue,  6 Jun 2023 15:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD9646387C;
        Tue,  6 Jun 2023 22:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A2C433D2;
        Tue,  6 Jun 2023 22:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090560;
        bh=Jsolamm28sojxmyIeUZQC6tRUT28viNE5ruHj9LDtdk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M4Ip5zomZpANn0Z4LrFBeIpyoyHzQ91rJ64Epv9Fh5owTqw94PmCgN3tQ9ah9t9Zc
         aaOaZA7wvkOZe1tGlPpjcfhOmSfI6x/zlzkWZmoM8U8DobLB2FQM+/24ROe71Yi1K1
         4uHESFioTfBPqyRQDNM4lNuQgXZg0LrtRPmiuoE5Ny9n3lMJwPoWTFB8LvJUU5gw8S
         RTcaG6vOiHyCK7NlVWRAm2artx6F6/en8Mg9nssROT2UWbAxDJw9ZY9bgdoSyFh+ho
         xN8mZFP3RFOWrluhJu2SyWEBX6/Qh9zJf66KhlJ5hjS4ngX1OtilrXdvcqlOsgRBpV
         SYAv/xE1cXliQ==
Subject: [PATCH 3/3] xfs/155: improve logging in this test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:19 -0700
Message-ID: <168609055958.2590724.15653702877825285667.stgit@frogsfrogsfrogs>
In-Reply-To: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
References: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If this test fails after a certain number of writes, we should state
the exact number of writes so that we can coordinate with 155.full.
Instead, we state the pre-randomization number, which isn't all that
helpful.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/155 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/155 b/tests/xfs/155
index 25cc84069c..302607b510 100755
--- a/tests/xfs/155
+++ b/tests/xfs/155
@@ -63,11 +63,12 @@ done
 
 # If NEEDSREPAIR is still set on the filesystem, ensure that a full run
 # cleans everything up.
+echo "Checking filesystem one last time after $allowed_writes writes." >> $seqres.full
 if _check_scratch_xfs_features NEEDSREPAIR &> /dev/null; then
 	echo "Clearing NEEDSREPAIR" >> $seqres.full
 	_scratch_xfs_repair 2>> $seqres.full
 	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
-		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
+		echo "Repair failed to clear NEEDSREPAIR on the $allowed_writes writes test"
 fi
 
 # success, all done

