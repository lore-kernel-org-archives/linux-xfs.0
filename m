Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC0DC61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbjKVXIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbjKVXH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804261AE
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208FAC433C8;
        Wed, 22 Nov 2023 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694475;
        bh=9qilUWqu6kmq22zPjxgPw68gixpLgVLPA8lhN3Te/78=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WlZ+rDKT0yOS8sDHefEsMwdRxHq93vGJ+uslxehD6EHRD+c1ClcYGzNTlx8vqxIha
         T37l0vlX3CK50V5Xqv4DsysUn7r5YG2q3vFhktj9roDGxyBsJveQ5pGv2wMNrM6V19
         dHRGca/44AsfPgga8EdxY9+r3GgThZh1QQ49i3UGMX/em3+jJ0Zk001KE7SaxaC0m6
         ByTKc+6IfQK3xFvGeKCWfzxZ4N/VWRxi61s6StjJEcQI44wzGBlw+/nsKXZkTQotDY
         7Yn8wXgy1Sk3qx2phDEXscBIAW9AteFEqc8P8cC3Gq3SArWgYpv8I+x8zSEcs7MaQv
         NQYPFiKBcQqCg==
Subject: [PATCH 2/4] xfs_scrub: handle spurious wakeups in scan_fs_tree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:54 -0800
Message-ID: <170069447457.1867812.1581024114980726743.stgit@frogsfrogsfrogs>
In-Reply-To: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Coverity reminded me that the pthread_cond_wait can wake up and return
without the predicate variable (sft.nr_dirs > 0) actually changing.
Therefore, one has to retest the condition after each wakeup.

Coverity-id: 1554280
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index 577eb6dc3e8..3c1825a75e7 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -263,7 +263,7 @@ scan_fs_tree(
 	 * about to tear everything down.
 	 */
 	pthread_mutex_lock(&sft.lock);
-	if (sft.nr_dirs)
+	while (sft.nr_dirs > 0)
 		pthread_cond_wait(&sft.wakeup, &sft.lock);
 	assert(sft.nr_dirs == 0);
 	pthread_mutex_unlock(&sft.lock);

